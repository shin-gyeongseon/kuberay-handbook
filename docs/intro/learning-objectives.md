# 1.2 Ray Cluster 학습 목표와 문서 활용 방법

> **이 장에서는** Ray Cluster를 학습할 때 도달해야 할 **구체적인 목표**와, MkDocs 기반 문서를 가장 효율적으로 **활용하는 방법**을 안내합니다. 1.1장에서 Ray와 분산 실행 모델의 전반을 살펴보았다면, 이제는 목표 지향적으로 학습 여정을 설계해 봅시다.

---

## ✨ 왜 Ray Cluster인가?

Ray Cluster는 **Python‑first** 분산 실행 엔진으로, 단일 노트북에서 대규모 ML 워크로드까지 자연스럽게 확장됩니다. 특히 MLOps 관점에서 

* **동적 오토스케일링**
* **배치·서빙 통합 실행 모델**
* **멈춤/재개(friendliness to fault tolerance)**

을 경험할 수 있다는 점이 탁월합니다. 본 심화 여정은 클러스터 운용의 전체 라이프사이클—**설치 → 개발 → 서빙 → 모니터링 → 예외 대응**—을 직접 체험하도록 설계되었습니다.

---

## 🏁 학습 목표

### 🚩 기본 레벨 (입문)

| 목표                 | 체크포인트                                       |
| ------------------ | ------------------------------------------- |
| Ray Core 핵심 개념 이해  | `ray.init()` , Remote Function / Actor 패러다임 |
| 로컬 단일 노드 → 클러스터 전환 | `ray start --head` 로 클러스터 부트스트랩             |
| 기본 작업 분산 실행        | CPU‑바운드 태스크 병렬 처리 예제 완주                     |

### 🚀 심화 레벨 (Cluster Ops)

* **Autoscaler** 설정으로 워커 노드 자동 증감 실습
* **Placement Group** 활용해 GPU 리소스 패킹/스프레딩
* 장애 주입(Chaos Engineering)으로 **Fault Tolerance** 메커니즘 검증
* **Serve Deployment Graph** 작성 및 A/B 트래픽 분배 실험

### 🔍 MLOps 관점 (End‑to‑End)

1. **데이터 파이프라인** – Ray DAG + Dataset API로 분산 전처리
2. **모델 학습** – Ray Train/Tune로 하이퍼파라미터 스윕
3. **서빙** – Ray Serve + FastAPI 래퍼, CI/CD 핸드오프
4. **모니터링/알림** – Prometheus/Grafana로 메트릭 수집, AlertManager 연동
5. **예외 및 롤백** – Checkpoint & Canary Release 주기 실습

---

## 📚 문서 활용 가이드

### 독자 프로필

* **초급 분산 컴퓨팅 경험자** (멀티프로세싱/멀티스레딩 사용 경험)
* **ML·MLOps 실무 초입 단계**
* **Docker & Kubernetes 사용 경험** *(권장)*


### 예제 코드 & 데이터셋

* 내가 만든 코드를 공유해야 되나 생각중 ... 아무것도 아닐것 같아서 ... (20250619)
* Jupyter Notebook: -
* 데이터셋 다운로드 스크립트: -

---

## 🔗 추가 자료

* [Ray 공식 문서](https://docs.ray.io)
* [Ray Serve Quick‑Start](https://docs.ray.io/en/latest/serve/index.html)
