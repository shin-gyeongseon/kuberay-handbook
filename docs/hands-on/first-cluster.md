# 5.2 최초 RayCluster 배포

Ray를 쿠버네티스 클러스터 상에 설치하고 운영하기 위한 첫 단계는 RayCluster 리소스를 정의하고 배포하는 것입니다. 이 문서에서는 RayCluster의 기본 구조를 설명하고, Helm Chart를 통해 실제로 배포하는 과정을 단계별로 안내합니다.

---

## ✅ 전제 조건

RayCluster를 배포하기 전에 다음 요소들이 준비되어 있어야 합니다:

- 쿠버네티스 클러스터 (v1.21 이상 권장)
- Helm이 설치되어 있어야 함 (`brew install helm`)
- `kuberay-operator`가 클러스터에 설치되어 있어야 함 ([이전 단계 참조](/docs/hands-on/install-helm.md))
- `kubectl` CLI 사용 가능

---

## ⚙️ 기본 RayCluster 매니페스트 생성

아래는 가장 간단한 형태의 RayCluster 정의입니다. Ray의 Head Pod와 Worker Pod 구성을 담고 있습니다.

```yaml
# ray-cluster.yaml
apiVersion: ray.io/v1alpha1
kind: RayCluster
metadata:
  name: ray-cluster
spec:
  rayVersion: "2.9.0"
  headGroupSpec:
    serviceType: ClusterIP
    template:
      spec:
        containers:
          - name: ray-head
            image: rayproject/ray:2.9.0
            command: ["/bin/bash", "-c"]
            args: ["ray start --head --port=6379"]
            ports:
              - containerPort: 6379
              - containerPort: 8265
  workerGroupSpecs:
    - replicas: 1
      groupName: small-group
      template:
        spec:
          containers:
            - name: ray-worker
              image: rayproject/ray:2.9.0
              command: ["/bin/bash", "-c"]
              args: ["ray start --address=ray-head:6379"]
```

---

## 🚀 클러스터 배포

위 매니페스트 파일을 사용해 실제로 클러스터에 배포합니다.

```bash
kubectl apply -f ray-cluster.yaml
```

배포 후에는 `kubectl get pods` 명령으로 Head/Worker Pod가 정상적으로 생성되었는지 확인합니다.

---

## 🔍 배포 확인

아래 명령어를 사용하여 Head Pod가 정상적으로 구동 중인지 확인합니다:

```bash
kubectl logs -f <head-pod-name>
```

또는 Ray Dashboard에 접속해 확인할 수도 있습니다:

```bash
kubectl port-forward service/ray-cluster-head 8265:8265
```

그 후 브라우저에서 `http://localhost:8265`에 접속하면 대시보드를 볼 수 있습니다.

---

## ✅ 기본 테스트

아래 Python 코드를 실행해 Ray가 정상적으로 분산 작업을 처리하는지 확인해봅니다.

```python
import ray

ray.init(address="auto")

@ray.remote
def f(x):
    return x * x

futures = [f.remote(i) for i in range(4)]
print(ray.get(futures))
```

---

## 🧹 리소스 정리

모든 테스트가 끝난 후, 클러스터 리소스를 삭제하려면 다음 명령어를 실행하세요:

```bash
kubectl delete -f ray-cluster.yaml
```

---

이제 기본적인 RayCluster 배포를 완료했습니다. 다음 단계에서는 RayJob을 활용한 작업 제출 방법을 살펴보겠습니다.
