# 3.3 Ray Job ― 배치·실험 워크로드 제출

Ray Job은 일회성 작업, 배치 처리, 실험성 코드 실행 등에 활용되는 **단발성(disposable) 분산 작업 제출 기능**입니다. Ray Serve가 장기 실행되는 API 형태의 서빙이라면, Ray Job은 짧은 실행 단위의 코드 처리에 최적화되어 있습니다.

## 개요

- Ray Job은 Python 스크립트를 클러스터에 제출하여 분산 처리하게 하는 방식입니다.
- 일반적으로 머신러닝 학습, 데이터 처리, 테스트 실행과 같은 **일회성 작업**에 사용됩니다.
- Ray 클러스터가 이미 실행 중인 상태에서 Job을 제출하면, 내부에서 Task/Actor 형태로 실행됩니다.

## 작업 제출 방법

### 1. Python 스크립트 작성

```python
# hello_world.py
import ray

ray.init()
@ray.remote
def hello():
    return "Hello from Ray!"

print(ray.get(hello.remote()))
```

### 2. CLI로 제출

```bash
ray job submit --address http://<head-node-ip>:8265 -- python hello_world.py
```

- `--address`: Ray Dashboard 주소 (기본 포트 8265)
- Job은 클러스터 내부에서 실행되며 로그와 상태 추적이 가능합니다.

## 작업 모니터링

Job 제출 후 다음과 같이 상태를 조회할 수 있습니다:

```bash
ray job list
ray job logs <job-id>
ray job stop <job-id>
```

또는 Dashboard에서 실시간으로 실행 상태와 출력 로그를 확인할 수 있습니다.

## 예제

다음은 여러 개의 파일을 병렬 처리하는 예제입니다:

```python
# batch_processing.py
import ray

ray.init()

@ray.remote
def process(file):
    return f"{file} 처리 완료"

files = ["a.csv", "b.csv", "c.csv"]
results = ray.get([process.remote(f) for f in files])
print(results)
```

이 스크립트를 제출하면, 각 파일 처리 작업이 병렬로 실행되고 결과가 반환됩니다.

---

Ray Job은 짧고 반복되지 않는 작업을 빠르게 실행하고자 할 때 매우 유용한 도구입니다. 실험 코드 실행, 파이프라인 일부 처리, 모델 학습 실험 등에 적합합니다. 다음 섹션에서는 Ray Workflow 및 Ray Data를 통해 좀 더 복잡한 데이터 흐름을 관리하는 방법을 살펴봅니다.
