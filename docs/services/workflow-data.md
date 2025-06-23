# 3.4 Ray Workflow / Ray Data

Ray Workflow와 Ray Data는 Ray를 활용한 **데이터 중심 파이프라인**과 **워크플로우 관리**를 위한 핵심 구성 요소입니다. 이 장에서는 두 기능의 개념과 사용 사례를 소개하고, 실제로 어떻게 연동하여 사용할 수 있는지도 설명합니다.

## Ray Workflow

Ray Workflow는 복잡한 데이터 처리나 모델 파이프라인을 **신뢰성 있게 관리**할 수 있도록 돕는 워크플로우 관리 프레임워크입니다.

### 개요

- 워크플로우 단계를 정의하고 실행 상태를 자동으로 추적
- 노드 장애 발생 시에도 재시작 및 상태 복구 가능
- 장기 실행 워크로드, 재현 가능한 실험 파이프라인에 적합

### 주요 기능

- **@workflow.step 데코레이터**를 통해 각 단계를 정의
- 상태는 자동으로 저장되며, 중단 시 resume 가능
- DAG(Directed Acyclic Graph) 형태의 종속 관계 정의 가능
- 결과는 object ref 또는 저장소 경로를 통해 접근 가능

```python
from ray import workflow

@workflow.step
def preprocess(data):
    return [x * 2 for x in data]

@workflow.step
def train(data):
    return sum(data)

output = train.step(preprocess.step([1, 2, 3])).run()
```

## Ray Data

Ray Data는 대규모 데이터를 병렬로 처리하기 위한 **분산 데이터셋 프레임워크**입니다. Spark와 유사하지만, Ray의 Task 및 Actor 기반 아키텍처와 자연스럽게 통합됩니다.

### 개요

- 대용량 파일을 병렬로 읽고 전처리
- 모델 학습, 서빙을 위한 batch 처리 최적화
- Pandas, NumPy, Arrow 등과 연동

### 주요 기능

- **read_csv, from_items** 등 다양한 입력 소스 지원
- map, filter, groupby, split 등의 연산 제공
- Dataset → IterableDataset 변환을 통해 streaming 방식도 지원

```python
import ray
import ray.data

ray.init()

ds = ray.data.read_csv("data.csv")
ds = ds.map(lambda row: {"value": row["value"] * 10})
ds.show()
```

## 연동 시나리오

Ray Workflow와 Ray Data는 함께 사용할 때 **재현 가능한 데이터 파이프라인 구축**에 매우 유용합니다. 예를 들어 다음과 같은 시나리오를 구성할 수 있습니다:

1. Ray Data로 대량의 데이터를 읽고 전처리
2. 전처리된 데이터를 Ray Workflow의 단계로 넘겨 모델 학습
3. 중간 결과를 저장하거나 로그로 기록하며 전체 흐름을 관리
4. 장애 발생 시 특정 단계부터 복구하여 재실행

---

Ray Workflow와 Ray Data는 Ray의 분산 아키텍처 위에서 안정적인 데이터 기반 애플리케이션을 구축할 수 있게 해줍니다. 복잡한 파이프라인을 간결하게 관리하고, 대규모 데이터를 효율적으로 처리하고 싶다면 이 두 구성 요소를 적극 활용해보세요.
