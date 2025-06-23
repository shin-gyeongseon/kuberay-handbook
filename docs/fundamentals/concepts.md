# 2.2 분산 개념: Task vs Actor vs Placement Group

분산 시스템에서 작업을 어떻게 나누고 실행할지 결정하는 방식은 매우 중요합니다. Ray는 이 과정을 쉽게 처리할 수 있도록 **Task**, **Actor**, **Placement Group**이라는 개념을 제공합니다. 이 장에서는 각 개념이 어떤 역할을 하며, 어떤 상황에서 사용하는지 알아보겠습니다.

## Task

**Task**는 Ray에서 가장 기본적인 작업 단위입니다. 하나의 함수나 연산을 병렬로 실행하고 싶을 때 사용합니다. 예를 들어, 이미지 100장을 동시에 처리하려면 각 이미지를 처리하는 함수를 Task로 만들어 병렬 실행할 수 있습니다.

- 상태를 저장하지 않고, 실행 후 결과만 반환합니다.
- 병렬성과 확장성이 매우 높습니다.
- 실행 중 상태를 기억할 필요가 없는 작업에 적합합니다.

```python
@ray.remote
def process_image(img):
    return some_processing(img)

futures = [process_image.remote(img) for img in image_list]
results = ray.get(futures)
```

## Actor

**Actor**는 **Task와 달리 상태를 갖는 객체**입니다. 즉, 여러 번 호출되더라도 내부 상태를 기억합니다. 상태 기반 처리가 필요한 머신러닝 모델, 게임 시뮬레이션, 스트리밍 처리를 구현할 때 유용합니다.

- 클래스 기반으로 정의하며, 메서드를 원격으로 호출합니다.
- 상태를 유지하므로, 복잡한 로직과 장기 실행에 적합합니다.

```python
@ray.remote
class Counter:
    def __init__(self):
        self.count = 0

    def increase(self):
        self.count += 1
        return self.count

counter = Counter.remote()
print(ray.get(counter.increase.remote()))  # 출력: 1
```

## Placement Group

**Placement Group**은 여러 Task나 Actor를 **특정 자원 배치 전략에 따라 함께 예약**할 수 있도록 도와줍니다. 이를 통해 GPU 자원 균등 배치, 노드 간 분산 실행 등을 구현할 수 있습니다.

- 리소스 고정(Packing), 분산 배치(Spreading) 전략 제공
- 고성능 컴퓨팅 환경에서 자원 최적화 가능
- 미리 자원을 확보해 안정적인 작업 실행 보장

```python
pg = ray.util.placement_group(
    [{"CPU": 2}, {"CPU": 2}],
    strategy="PACK"
)
ray.get(pg.ready())
```

## 요약

| 개념 | 특징 | 사용 예시 |
|------|------|----------|
| Task | 상태 없음, 병렬 실행 | 이미지 처리, 데이터 전처리 |
| Actor | 상태 있음, 클래스 기반 | 모델 학습, 세션 처리 |
| Placement Group | 자원 예약 및 배치 전략 설정 | GPU 작업, 노드 간 분산 실행 |

이 개념들을 이해하면 Ray에서 어떤 방식으로 작업을 분산하고, 어떤 전략으로 자원을 할당할지 설계할 수 있습니다. 다음 장에서는 Ray Runtime 내부에서 이런 작업들이 어떻게 실행되는지 더 깊이 살펴보겠습니다.
