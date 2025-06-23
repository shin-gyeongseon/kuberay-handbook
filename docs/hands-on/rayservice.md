# 5.3 RayService로 온라인 서빙 전환

이전 단계에서는 RayCluster와 RayJob을 통해 일회성 분산 작업을 실행하는 방법을 학습했습니다. 이번에는 **RayService**를 통해 Ray 기반 모델을 **지속적이고 안정적으로 서빙**하는 방법을 다룹니다. RayService는 배포 설정, 상태 모니터링, 롤링 업데이트, 자가 치유 등을 지원하는 CRD(Custom Resource Definition)입니다.

---

## ✅ RayService란?

RayService는 Ray Serve 기반의 배포를 쿠버네티스 환경에서 지속적으로 관리할 수 있도록 하는 리소스입니다.  
다음 기능들을 제공합니다:

- **ServeConfig** 기반 애플리케이션 정의
- **자동 롤링 업데이트** (config 변경 시)
- **Replica 상태 감시 및 자가 치유**
- **배포 상태 추적 및 일관성 유지**

---

## 📄 기본 RayService 매니페스트 예시

```yaml
apiVersion: ray.io/v1alpha1
kind: RayService
metadata:
  name: ray-serve-app
spec:
  rayClusterConfig:
    rayVersion: "2.9.0"
    headGroupSpec:
      serviceType: ClusterIP
      template:
        spec:
          containers:
            - name: ray-head
              image: rayproject/ray:2.9.0
              ports:
                - containerPort: 8000  # serve HTTP
                - containerPort: 8265  # dashboard
    workerGroupSpecs:
      - groupName: worker-group
        replicas: 1
        template:
          spec:
            containers:
              - name: ray-worker
                image: rayproject/ray:2.9.0
  serveConfigV2:
    applications:
      - name: hello
        routePrefix: "/hello"
        importPath: "app.serve.hello:entrypoint"
        runtimeEnv:
          workingDir: "s3://your-bucket/serve-app"
          pip:
            - requests
          env:
            AWS_ACCESS_KEY_ID: "your-access-key"
            AWS_SECRET_ACCESS_KEY: "your-secret-key"
            RAY_AWS_ENDPOINT_URL: "https://s3.us-east-1.amazonaws.com"
        deployments:
          - name: entrypoint
            numReplicas: 2
```

---

## 🚀 서비스 배포

```bash
kubectl apply -f ray-service.yaml
```

배포 후에는 다음 명령어로 리소스 상태를 확인할 수 있습니다:

```bash
kubectl get rayservices
kubectl get pods
```

---

## 🌐 서비스 접근

Serve는 기본적으로 HTTP(8000) 포트를 통해 접근할 수 있습니다. 클러스터 내부에서 접근하려면:

```bash
kubectl port-forward service/ray-serve-app-head 8000:8000
```

브라우저 또는 HTTP 클라이언트로 `http://localhost:8000/hello`에 요청을 보내면 됩니다.

---

## 🔀 트래픽 라우팅

`routePrefix`는 각 Serve Application의 라우팅 기준 경로입니다.  
여러 모델을 서빙할 경우 다음과 같이 설정할 수 있습니다:

- `/predict-a` → A 모델
- `/predict-b` → B 모델

---

## 🔄 자가 치유 및 롤링 업데이트

- ServeConfigV2가 변경되면 RayService는 기존 Deployment를 자동으로 업데이트합니다.
- 실패한 Replica는 자동으로 복구되며, 이는 "self healing" 메커니즘을 통해 이루어집니다.

---

## 📊 모니터링 설정

Ray Dashboard(8265 포트)를 포트 포워딩하여 접속할 수 있습니다.

```bash
kubectl port-forward service/ray-serve-app-head 8265:8265
```

또한 Prometheus 및 Grafana를 연동하여 리소스 및 Serve 상태를 시각화할 수 있습니다.

---

이제 RayService를 통해 모델을 안정적으로 서빙하는 구조를 구현할 수 있습니다. 다음 장에서는 자동 확장 기능과 HPA/Karpenter와의 차이점을 설명합니다.
