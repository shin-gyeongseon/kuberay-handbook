# 4.5 RayJob CRD

RayJob은 일회성(batch) 작업을 Ray 클러스터에서 실행하기 위한 CRD(Custom Resource Definition)입니다. 머신러닝 학습, 데이터 처리, 스크립트 실행 등 다양한 단발성 작업을 Kubernetes 위에서 자동화할 수 있도록 도와줍니다.

## RayJob CRD 개요

- 클러스터가 자동으로 생성되고, 작업 실행 후 자동 종료 가능
- 기존 클러스터에 붙어서 실행하거나, 새로운 클러스터 생성 가능
- Python 기반의 Job 스크립트를 container image와 함께 제출
- 작업 상태(JobStatus)를 통해 성공/실패 여부 추적

## 주요 스펙

### 작업 제출 설정

```yaml
spec:
  entrypoint: "python script.py"
  runtimeEnv:
    ...
  rayClusterSpec:
    ...
```

- `entrypoint`: 작업 실행 명령. Python 스크립트 또는 명령어
- `runtimeEnv`: 필요한 라이브러리, 패키지 등을 정의 (pip, env 등)
- `rayClusterSpec`: 작업 실행에 사용할 RayCluster 정의

### 런타임 환경

```yaml
runtimeEnv:
  workingDir: "s3://my-bucket/job-code"
  pip:
    - pandas
    - scikit-learn
  envVars:
    DATA_PATH: "/mnt/data"
```

- `workingDir`: 작업 소스코드 위치 (s3, http, PVC 등)
- `pip`: 필요한 Python 패키지 리스트
- `envVars`: 실행 시 사용될 환경변수들

### 의존성 관리

- `initContainers`나 `volumeMounts`를 활용해 데이터 및 모델 사전 준비 가능
- PVC(영구 볼륨)와 연동하여 데이터 입력/출력 처리 가능

## 예제 매니페스트

```yaml
apiVersion: ray.io/v1
kind: RayJob
metadata:
  name: sample-ray-job
spec:
  entrypoint: "python train.py"
  runtimeEnv:
    workingDir: "s3://ml-jobs/train-job"
    pip:
      - xgboost
      - numpy
    envVars:
      MODEL_DIR: "/output"
  rayClusterSpec:
    headGroupSpec:
      rayStartParams:
        dashboard-host: "0.0.0.0"
      template:
        spec:
          containers:
            - name: ray-head
              image: rayproject/ray:2.9.0
    workerGroupSpecs:
      - groupName: workers
        replicas: 2
        rayStartParams:
          num-cpus: "2"
        template:
          spec:
            containers:
              - name: ray-worker
                image: rayproject/ray:2.9.0
```

## 작업 모니터링 및 디버깅

- `kubectl get rayjob` 으로 전체 작업 목록 확인
- `status.jobStatus` 필드로 실행 결과 확인 (SUCCEEDED / FAILED / RUNNING)
- 로그 확인: `kubectl logs job-pod-name`
- Ray Dashboard에서도 작업 상태, 리소스 사용량 확인 가능

---

RayJob은 단발성 실행이 필요한 모든 Ray 기반 작업에 적합한 도구입니다. 반복적인 실험, 데이터 처리 배치, 모델 학습 자동화 등에 효과적으로 활용할 수 있습니다.
