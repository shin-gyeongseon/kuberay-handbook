# 4.3 RayCluster CRD 세부 필드

KubeRay에서 RayCluster는 클러스터 전체를 선언적으로 구성할 수 있도록 해주는 Custom Resource Definition(CRD)입니다. 이 문서에서는 RayCluster 리소스에서 자주 사용되는 주요 필드들을 설명하고, 예제 매니페스트와 고급 설정도 함께 소개합니다.

## RayCluster CRD 개요

RayCluster는 Head 노드와 하나 이상의 Worker 노드 그룹을 정의할 수 있으며, 각 노드 그룹의 리소스, 레이블, 환경변수, 시작 파라미터 등을 설정할 수 있습니다. 또한 autoscaling, volume mount, affinity 같은 Kubernetes 설정도 함께 사용할 수 있습니다.

```yaml
apiVersion: ray.io/v1
kind: RayCluster
metadata:
  name: example-cluster
spec:
  headGroupSpec:
    ...
  workerGroupSpecs:
    ...
```

## 주요 스펙

### 헤드 그룹 설정

`headGroupSpec`은 클러스터의 중심이 되는 Head 노드 설정을 정의합니다.

```yaml
headGroupSpec:
  rayStartParams:
    dashboard-host: "0.0.0.0"
    num-cpus: "2"
  template:
    spec:
      containers:
        - name: ray-head
          image: rayproject/ray:2.9.0
          ports:
            - containerPort: 6379
```

- `rayStartParams`: `ray start --head` 명령에 넘길 파라미터 정의
- `template.spec.containers.image`: 사용할 Ray 이미지
- `ports`: Head 노드의 Redis 포트 등 노출할 포트 설정

### 워커 그룹 설정

`workerGroupSpecs`는 하나 이상의 워커 그룹을 정의하며, 워커 노드 수, 자원, 스케일링 정책 등을 개별로 설정할 수 있습니다.

```yaml
workerGroupSpecs:
  - groupName: worker-group
    replicas: 2
    rayStartParams:
      num-cpus: "4"
    template:
      spec:
        containers:
          - name: ray-worker
            image: rayproject/ray:2.9.0
```

- `replicas`: 워커 노드 초기 개수
- `groupName`: 각 워커 그룹의 고유 식별자
- `rayStartParams`: `ray start --address=...`에 넘길 파라미터

### 오토스케일링 설정

WorkerGroup 단위로 Autoscaling을 설정할 수 있습니다.

```yaml
minReplicas: 1
maxReplicas: 5
```

- workload 증가 시, 워커 수가 `maxReplicas`까지 자동 증가 가능
- workload 감소 시, `minReplicas`까지 자동 축소

> Note: Ray의 내부 Autoscaler가 작동하며 Kubernetes HPA와는 별도입니다.

## 예제 매니페스트

```yaml
apiVersion: ray.io/v1
kind: RayCluster
metadata:
  name: sample-ray-cluster
spec:
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
      minReplicas: 1
      maxReplicas: 5
      rayStartParams:
        num-cpus: "2"
      template:
        spec:
          containers:
            - name: ray-worker
              image: rayproject/ray:2.9.0
```

## 고급 설정 옵션

- **volumeMounts / volumes**: 데이터 디스크 연결 (예: PVC)
- **nodeSelector / affinity**: 특정 노드에 스케줄링 제어
- **env / envFrom**: 환경변수 주입
- **lifecycle / initContainers**: Pod 초기화 및 종료 전후 처리

---

RayCluster CRD를 이해하면 Helm 없이도 YAML만으로 Ray 클러스터를 자유롭게 구성하고 확장할 수 있습니다. 다음 장에서는 RayService CRD에 대해 알아보겠습니다.
