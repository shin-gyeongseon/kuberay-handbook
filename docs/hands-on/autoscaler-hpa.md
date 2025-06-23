# 5.5 Ray Autoscaler와 Kubernetes HPA 차이 및 연동

Ray는 자체적으로 클러스터 오토스케일링 기능을 제공하지만, 쿠버네티스 환경에서는 종종 Kubernetes HPA(Horizontal Pod Autoscaler)나 Karpenter와 함께 사용되기도 합니다. 이 문서에서는 Ray Autoscaler와 Kubernetes HPA의 차이를 명확하게 구분하고, 두 방식을 어떻게 함께 활용할 수 있는지 정리합니다.

---

## ✅ Ray Autoscaler란?

Ray Autoscaler는 **Ray Head 노드에 내장된 클러스터 레벨 스케일링 컴포넌트**입니다. 사용자의 워크로드(task, actor 등)가 늘어나면 **worker pod**를 자동으로 추가하거나 감소시키는 역할을 수행합니다.

- **동작 기준**: Ray 내부의 task 큐 / 리소스 대기열
- **스케일 대상**: Ray worker 노드
- **실행 위치**: Ray head pod 내부 (별도 컨트롤러 아님)
- **작동 방식**: `RayCluster.spec.enableInTreeAutoscaling = true` 설정 시 자동 활성화됨

> 참고: Ray의 Autoscaler는 내부적으로 `resource demand`를 기반으로 동작하므로, 사용자가 직접 리소스 요청/할당을 제어하지 않아도 됩니다.

---

## ✅ Kubernetes HPA란?

Kubernetes HPA는 **특정 Deployment나 Pod의 CPU/메모리 사용률** 또는 사용자 정의 metric을 기준으로 **replica 수를 자동 조절**하는 Kubernetes의 표준 오토스케일러입니다.

- **동작 기준**: CPU/메모리 사용량 또는 Custom Metric
- **스케일 대상**: Replica 개수 (ex. Web App, API 서버 등)
- **실행 위치**: Kubernetes Control Plane
- **기반 리소스**: metrics-server, Prometheus Adapter 등 필요

---

## 🔍 Ray Autoscaler vs HPA 비교

| 항목 | Ray Autoscaler | Kubernetes HPA |
|------|----------------|----------------|
| 적용 대상 | Worker Pod | 일반 Deployment |
| 동작 기준 | 리소스 대기열 (Task/Actor) | 리소스 사용률 (CPU/Memory) |
| 작동 위치 | Ray Head 내부 | Kubernetes Master |
| 연동 방식 | `RayCluster` 스펙 기반 | 별도 Metric + HPA 리소스 생성 필요 |
| 목적 | 클러스터 스케일링 | 애플리케이션 레벨 스케일링 |

---

## 🔧 함께 사용하는 경우

- **Ray Autoscaler**는 **클러스터 확장/축소**에 집중
- **Kubernetes HPA**는 **Serve Replica나 RayJob의 Pod 수 조절**에 적합

### 예시: Ray Serve와 HPA를 함께 사용하는 시나리오

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ray-serve-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ray-serve-replica
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
```

---

## 💡 정리

- Ray Autoscaler는 **클러스터 단위의 스케일링을 자동화**합니다.
- Kubernetes HPA는 **서비스 혹은 레플리카 단위의 스케일링**을 처리합니다.
- 둘은 중복되는 개념이 아니라 **서로 보완적**입니다.
- 사용자의 서비스 구조에 따라 적절히 **분리 사용하거나 병행 적용**할 수 있습니다.

---

> 🔗 참고 문서  
- [Ray Autoscaler 공식 문서](https://docs.ray.io/en/latest/cluster/autoscaling.html)  
- [Kubernetes HPA 개념](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)  
