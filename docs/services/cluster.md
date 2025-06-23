# 3.1 Ray Cluster ― 헤드 노드·워커 노드 구조

Ray 클러스터는 기본적으로 **헤드 노드(Head Node)**와 **워커 노드(Worker Node)**로 구성됩니다. 이 구조는 Ray의 분산 처리 능력을 뒷받침하는 핵심적인 기반입니다. 이 장에서는 각 노드가 어떤 역할을 하는지, 어떤 서비스들이 작동하는지, 그리고 클러스터를 어떻게 설정할 수 있는지를 알아봅니다.

## 개요

Ray 클러스터는 중앙에서 모든 작업을 관리하는 **헤드 노드**와, 실제 작업을 수행하는 **워커 노드**들로 구성됩니다.

- 헤드 노드는 클러스터 전체의 상태를 관리하고, 대시보드와 GCS(Global Control Store), 스케줄러를 포함합니다.
- 워커 노드는 실제로 Task나 Actor를 실행하는 Worker 프로세스를 포함합니다.
- 모든 노드는 `Raylet`이라는 로컬 에이전트를 통해 자원을 보고하고, 작업을 수신합니다.

이러한 구조는 수평 확장이 용이하며, 다양한 워크로드를 안정적으로 분산 처리할 수 있도록 해줍니다.

## 헤드 노드

헤드 노드는 Ray 클러스터의 **중추 역할**을 합니다.

- 클러스터 내 노드 상태 및 자원 모니터링
- Task 및 Actor 스케줄링 결정
- GCS, Dashboard, Autoscaler 등 주요 런타임 서비스 포함

또한 사용자는 헤드 노드에 접속해 Ray CLI나 Python API를 통해 클러스터에 작업을 제출할 수 있습니다. 즉, 헤드 노드는 **명령의 시작점이자 클러스터의 컨트롤 센터**입니다.

## 워커 노드

워커 노드는 클러스터 내에서 **실제 작업(Task/Actor)을 실행하는 역할**을 합니다.

- Python, Java 등의 Worker 프로세스가 Task/Actor를 병렬로 실행
- Raylet을 통해 헤드 노드와 통신하며 작업을 수신
- Object Store를 통해 데이터를 공유하거나 전달

여러 워커 노드를 추가함으로써 클러스터는 손쉽게 확장할 수 있고, 작업 처리 능력도 함께 증가합니다.

## 클러스터 설정 예시

Ray를 직접 실행하거나 KubeRay를 통해 배포할 때는 Head/Worker 역할을 명확히 설정해야 합니다. 예를 들어 `ray start` 명령을 통해 구성할 수 있습니다:

```bash
# 헤드 노드 시작
ray start --head --port=6379

# 워커 노드 시작
ray start --address='head-node-ip:6379'
```

Kubernetes 환경에서는 Helm Chart 또는 RayCluster CRD를 통해 다음과 같이 정의합니다:

```yaml
headGroupSpec:
  serviceType: ClusterIP
  rayStartParams:
    dashboard-host: "0.0.0.0"
    num-cpus: "2"

workerGroupSpecs:
  - replicas: 2
    rayStartParams:
      num-cpus: "4"
```

이와 같이 클러스터를 구성하면 다양한 환경에서 유연하게 Ray를 확장할 수 있습니다.
