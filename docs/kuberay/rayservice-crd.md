# 4.4 RayService CRD

RayService는 Ray Serve 기반의 애플리케이션을 Kubernetes에서 **지속적이고 안정적으로 운영**할 수 있게 도와주는 CRD입니다. RayService를 사용하면 Serve Deployment가 클러스터 내에서 자동 복구되고, 설정 변경 시 롤링 업데이트가 적용되며, 서비스 상태를 지속적으로 추적할 수 있습니다.

## RayService CRD 개요

- Serve 기반 모델 또는 API를 안정적으로 서빙
- Deployment 설정을 선언적으로 구성
- 상태 추적 및 자동 복구 메커니즘 포함
- 설정 변경 시 무중단 롤링 업데이트 제공

RayCluster와 달리 RayService는 클러스터 생성을 포함하며 Serve Deployment까지 함께 관리합니다. 즉, Serve 애플리케이션 운영의 전체 수명 주기를 책임지는 CRD입니다.

## 주요 스펙

### 서비스 구성

```yaml
spec:
  rayClusterConfig: # 내부적으로 생성될 RayCluster 정의
    ...
  serveConfigV2: # Serve Deployment 정의
    importPath: "app.MyModel"
    runtimeEnv:
      workingDir: "s3://my-bucket/code"
      pip:
        - scikit-learn
    deployments:
      - name: MyModel
        numReplicas: 2
        routePrefix: "/predict"
```

- `rayClusterConfig`: 내부에 Head/Worker 노드를 포함하는 RayCluster 정의
- `serveConfigV2`: Serve 앱 배포 설정. importPath 기준으로 사용자 클래스 실행
- `numReplicas`: Replica 수 자동 조절 가능
- `routePrefix`: 요청 경로 매핑

### 배포 전략

RayService는 Serve Deployment 변경 시 기존 인스턴스를 점진적으로 종료하고 새로 시작하는 방식의 **롤링 업데이트**를 제공합니다.

- 변경 시 새 Replica가 먼저 준비되고,
- 기존 Replica가 종료됨
- 이 과정에서 서비스 중단 없이 트래픽 처리 가능

### 자동 복구

RayService는 Controller를 통해 클러스터 및 Serve 상태를 지속적으로 감시하며, 다음과 같은 경우 자동 복구를 수행합니다:

- Pod Crash 또는 Unhealthy 상태 탐지
- Serve Deployment가 비정상 상태로 전환된 경우
- GCS 연결 실패 또는 Actor 실패

## 예제 매니페스트

```yaml
apiVersion: ray.io/v1
kind: RayService
metadata:
  name: sample-ray-service
spec:
  rayClusterConfig:
    headGroupSpec:
      rayStartParams:
        dashboard-host: "0.0.0.0"
      template:
        spec:
          containers:
            - name: ray-head
              image: rayproject/ray:2.9.0
    workerGroupSpecs:
      - groupName: worker
        replicas: 2
        rayStartParams:
          num-cpus: "2"
        template:
          spec:
            containers:
              - name: ray-worker
                image: rayproject/ray:2.9.0
  serveConfigV2:
    importPath: "app.MyModel"
    runtimeEnv:
      workingDir: "s3://my-bucket/code"
      pip:
        - scikit-learn
    deployments:
      - name: MyModel
        numReplicas: 2
        routePrefix: "/predict"
```

## 모니터링 및 로깅

- Ray Dashboard를 통해 Serve Deployment의 상태 확인 가능
- Kubernetes Event 및 Pod 상태를 통해 오류 및 재시작 원인 파악 가능
- Prometheus 및 Grafana를 통해 트래픽, Replica 수, 처리 시간 등을 시각화 가능

---

RayService는 서빙 애플리케이션을 Kubernetes 상에서 안정적으로 운영하기 위한 핵심 구성 요소입니다. 특히 모델 서빙, API 게이트웨이, 실시간 추론 시스템에서 매우 유용하게 사용될 수 있습니다.
