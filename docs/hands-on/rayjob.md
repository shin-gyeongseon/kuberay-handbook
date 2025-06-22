
# 5.4 RayJob으로 분산 학습 실행

RayJob은 쿠버네티스 환경에서 **일회성(batch) 작업을 실행**하기 위한 Custom Resource입니다. 모델 학습, 데이터 전처리, 분산 계산 등의 작업을 안정적으로 제출하고 모니터링할 수 있게 도와줍니다.

---

## ✅ RayJob의 개념

RayJob은 RayCluster를 직접 다루지 않고도 **Job 단위로 작업을 실행**할 수 있게 해줍니다. 다음과 같은 특징을 가집니다:

- 일회성 실행 (배포 후 자동 종료)
- 클러스터 생성을 내부적으로 포함
- 작업 결과를 로그로 확인
- Serve와 달리 HTTP endpoint가 필요 없음

---

## 📄 기본 RayJob 매니페스트 예시

```yaml
apiVersion: ray.io/v1alpha1
kind: RayJob
metadata:
  name: rayjob-sample
spec:
  entrypoint: "python /app/train.py"
  runtimeEnv:
    workingDir: "s3://your-bucket/train-script"
    pip:
      - scikit-learn
      - pandas
    envVars:
      DATA_PATH: "s3://your-bucket/data/train.csv"
  rayClusterSpec:
    rayVersion: "2.9.0"
    headGroupSpec:
      serviceType: ClusterIP
      template:
        spec:
          containers:
            - name: ray-head
              image: rayproject/ray:2.9.0
              ports:
                - containerPort: 8265
    workerGroupSpecs:
      - groupName: worker-group
        replicas: 2
        template:
          spec:
            containers:
              - name: ray-worker
                image: rayproject/ray:2.9.0
```

---

## 🚀 작업 제출

RayJob을 클러스터에 제출하면 자동으로 RayCluster가 생성되고, 작업이 완료되면 클러스터도 종료됩니다.

```bash
kubectl apply -f rayjob.yaml
```

---

## 🔍 상태 확인

작업 상태는 다음과 같이 확인할 수 있습니다:

```bash
kubectl get rayjob
kubectl describe rayjob rayjob-sample
```

Pod 로그를 통해 결과 확인:

```bash
kubectl logs -f <head-pod-name>
```

---

## 🔁 재실행

RayJob은 기본적으로 완료되면 종료되기 때문에, 동일한 작업을 다시 실행하려면 리소스를 삭제한 후 다시 생성해야 합니다.

```bash
kubectl delete -f rayjob.yaml
kubectl apply -f rayjob.yaml
```

---

## 🔒 고급 설정 예시

- `ttlSecondsAfterFinished`: 완료 후 리소스를 자동 정리할 시간 지정
- `suspend`: Job 실행을 일시 중단하거나 재개 가능
- `output`: 작업 결과를 외부 저장소로 내보내는 파이프라인 구성 가능

---

이제 RayJob을 활용해 다양한 배치 작업과 분산 학습을 안정적으로 제출할 수 있습니다. 다음 장에서는 Ray Autoscaler와 Kubernetes HPA의 차이점을 살펴보겠습니다.

