# 3.2 Ray Serve ― 모델·API 서빙용 프레임워크

Ray Serve는 머신러닝 모델이나 웹 API를 **효율적이고 유연하게 서빙할 수 있도록 설계된 Ray 기반 프레임워크**입니다. 분산 환경에서도 자동 확장과 고가용성을 갖춘 서빙 시스템을 구축할 수 있으며, Python 함수나 FastAPI, Starlette 등과 쉽게 통합됩니다.

## 개요

기존에는 모델을 배포할 때 Flask 서버나 FastAPI 서버를 따로 띄우고, 인프라 스케일링도 수동으로 처리해야 했습니다. Ray Serve는 이러한 과정을 단순화하며 다음과 같은 특징을 가집니다:

- **분산 서빙 지원**: 여러 노드에 걸쳐 모델을 배포하고 부하를 분산
- **자동 스케일링**: 요청량에 따라 워커 수 자동 조절
- **유연한 API 정의**: Python 함수, 클래스, FastAPI와 자연스럽게 통합
- **서빙 그래프 구성 가능**: A/B 테스트, 트래픽 분할, DAG 구성 등을 통해 복잡한 서빙 전략 구현

## 주요 기능

- **Deployment**: 서빙 단위로 각 모델/엔드포인트를 배포
- **Handle**: 내부 혹은 외부에서 해당 Deployment로 요청을 전달하는 객체
- **Ingress**: FastAPI와 같은 웹 프레임워크와 통합해 HTTP 요청을 받을 수 있도록 함
- **Configurable Replica**: 각 Deployment는 복수의 Replica로 구성 가능하며, 설정을 통해 리소스 조절 가능

## 기본 사용법

```python
import ray
from ray import serve

ray.init()
serve.start()

@serve.deployment
@serve.ingress
class MyModel:
    def __init__(self):
        self.model = load_model()

    async def __call__(self, request):
        data = await request.json()
        result = self.model.predict(data["input"])
        return {"result": result}

MyModel.deploy()
```

위 예시는 HTTP 요청을 받아 모델 예측 결과를 반환하는 간단한 예입니다. FastAPI를 직접 사용하지 않고도 RESTful API를 구성할 수 있습니다.

## 고급 설정

Ray Serve는 다양한 고급 기능을 지원합니다:

- **서빙 그래프 구성 (DAG)**:
  여러 Deployment를 조합하여 DAG 형태로 요청 흐름을 구성할 수 있습니다.
  
- **트래픽 분할**:
  같은 엔드포인트에 대해 여러 버전의 모델을 배포하고 트래픽을 비율로 나누는 설정이 가능합니다.

- **리소스 제어**:
  각 Deployment에 대해 `num_replicas`, `num_cpus`, `autoscaling_config` 등을 설정하여 세밀하게 자원 조절 가능

```python
@serve.deployment(num_replicas=2, ray_actor_options={"num_cpus": 1})
class BatchingModel:
    ...
```

Ray Serve는 단순한 모델 API 서빙을 넘어, **서비스 컴포지션, 고가용성 설계, 멀티모델 트래픽 제어**까지 지원하는 강력한 프레임워크입니다. 다음 섹션에서는 Ray Job을 통해 어떻게 실험성 워크로드를 제출할 수 있는지 알아보겠습니다.
