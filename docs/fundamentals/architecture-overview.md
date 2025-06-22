# 2.1 Ray 아키텍처 한눈에 보기

Ray는 분산 컴퓨팅을 단순화하기 위해 설계된 범용 프레임워크로, 머신러닝, 데이터 처리, 서빙 등 다양한 워크로드를 유연하게 확장할 수 있도록 구성되어 있습니다. 이 장에서는 Ray의 핵심 아키텍처를 전체적으로 조망하며, 주요 구성 요소들의 역할과 상호작용을 설명합니다.

## 개요

Ray 아키텍처는 크게 **Head Node**, **Worker Node**, 그리고 그 위에서 동작하는 **Core Component**로 나뉘며, 사용자 애플리케이션은 Task, Actor, Serve 등의 형태로 실행됩니다. 이러한 구조는 **수평 확장성(Scalability)**과 **유지보수성(Modularity)**을 동시에 고려한 설계입니다.

## 주요 컴포넌트

### Ray Head Node  
클러스터의 중심으로 작동하며, **스케줄링**, **메타데이터 관리**, **대시보드 제공** 등의 핵심 역할을 수행합니다.

### Ray Worker Node  
실질적인 작업이 수행되는 노드로, Task와 Actor를 실행하는 워커 프로세스가 존재합니다.

### GCS (Global Control Store)  
클러스터 전반의 메타데이터를 관리하는 중앙 저장소로, 일반적으로 Redis에 기반합니다. Actor, Task, Resource 상태를 추적합니다.

### Raylet  
각 노드에서 자원 스케줄링과 Task 분배를 담당하는 로컬 에이전트 역할을 합니다.

### Object Store  
노드 간 공유 메모리 영역으로, Task/Actor 간 대규모 데이터 전달 시 네트워크 병목을 줄이는 핵심 구성 요소입니다.

### Dashboard  
웹 기반의 시각화 도구로, 클러스터 상태, 자원 사용량, 실행 중인 워크로드를 실시간으로 모니터링할 수 있습니다.

## 아키텍처 다이어그램

```mermaid
graph TD
    subgraph Ray Cluster
        Head[Ray Head Node]
        Worker1[Worker Node 1]
        Worker2[Worker Node 2]
    end

    subgraph Head Node 내부
        GCS[(Global Control Store)]
        Scheduler[Task Scheduler]
        Dashboard[Web Dashboard]
    end

    subgraph Worker Node 내부
        Raylet1[Raylet Agent]
        ObjectStore1[Object Store]
        TaskRunner1[Task/Actor Worker]
    end

    Head --> GCS
```mermaid
graph TD
    subgraph Ray Cluster
        Head[Ray Head Node]
        Worker1[Worker Node 1]
        Worker2[Worker Node 2]
    end

    subgraph Head Node 내부
        GCS[(Global Control Store)]
        Scheduler[Task Scheduler]
        Dashboard[Web Dashboard]
    end

    subgraph Worker Node 내부
        Raylet1[Raylet Agent]
        ObjectStore1[Object Store]
        TaskRunner1[Task/Actor Worker]
    end

    Head --> GCS
```mermaid
graph TD
    subgraph Ray Cluster
        Head[Ray Head Node]
        Worker1[Worker Node 1]
        Worker2[Worker Node 2]
    end

    subgraph Head Node 내부
        GCS[(Global Control Store)]
        Scheduler[Task Scheduler]
        Dashboard[Web Dashboard]
    end

    subgraph Worker Node 내부
        Raylet1[Raylet Agent]
        ObjectStore1[Object Store]
        TaskRunner1[Task/Actor Worker]
    end

    Head --> GCS
    Head --> Dashboard
    Head --> Scheduler
    Scheduler -->|Distribute Task| Raylet1
    Raylet1 --> TaskRunner1
    Raylet1 --> ObjectStore1
    GCS --> Raylet1
```
