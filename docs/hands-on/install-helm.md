# 5.1 Helm으로 KubeRay 설치

KubeRay는 Ray 클러스터를 쿠버네티스 상에서 운영할 수 있도록 해주는 Operator 기반 컴포넌트입니다. Helm을 통해 간단하고 일관된 방식으로 설치할 수 있으며, 이 문서에서는 Helm을 활용해 `kuberay-operator`를 설치하는 방법을 단계별로 안내합니다.

---

## ✅ 전제 조건

KubeRay를 설치하기 전에 다음 환경이 구성되어 있어야 합니다:

- 쿠버네티스 클러스터 (v1.21 이상 권장)
- Helm 3.x 설치되어 있어야 함
- `kubectl` CLI 사용 가능
- 클러스터에 접근할 수 있는 kubeconfig 설정 완료

---

## 🔧 Helm 설치 (필요 시)

macOS 환경에서는 Homebrew를 통해 Helm을 설치할 수 있습니다:

```bash
brew install helm
```

설치 확인:

```bash
helm version
```

---

## 📦 KubeRay Helm 차트 추가

KubeRay의 공식 Helm 차트를 Helm 저장소에 추가합니다.

```bash
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
helm repo update
```

---

## 🚀 KubeRay 설치

`kuberay-operator`는 RayCluster와 RayJob 등 CRD(Custom Resource)를 관리하는 핵심 구성 요소입니다. 아래 명령어로 설치합니다:

```bash
helm install kuberay kuberay/kuberay-operator
```

Namespace를 따로 지정하고 싶다면:

```bash
helm install kuberay kuberay/kuberay-operator -n ray-system --create-namespace
```

---

## 🔍 설치 확인

아래 명령어를 통해 Operator가 정상적으로 설치되었는지 확인합니다:

```bash
kubectl get pods -n ray-system
```

`kuberay-operator` Pod가 `Running` 상태여야 합니다.

```bash
┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─\─  pods(kuberay-test)[1] ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ NAME↑                                       PF          READY          STATUS                       RESTARTS           CPU           MEM           %CPU/R           %CPU/L           %MEM/R           %MEM/L IP                    NODE                     AGE
│ kuberay-operator-5d6b954f9d-2xwfj           ●           1/1            Running                             0             2            28                2                2                5                5 10.42.3.85            k3s-worker-02            3d1h
```

---

## 🛠️ 문제 해결

- CRD가 설치되지 않은 경우:

  ```bash
  kubectl get crd | grep ray
  ```

  위 명령에서 아무 것도 출력되지 않는다면 Helm 설치가 실패했을 수 있습니다.

- Operator Pod가 CrashLoopBackOff 상태라면, 로그 확인:

  ```bash
  kubectl logs -n ray-system deploy/kuberay-operator
  ```

- 이미 설치된 경우:

  ```bash
  helm upgrade --install kuberay kuberay/kuberay-operator
  ```

---

이제 Ray 클러스터를 쿠버네티스 환경에서 생성할 준비가 완료되었습니다. 다음 단계에서는 RayCluster 리소스를 정의하고 배포하는 방법을 알아봅니다.
