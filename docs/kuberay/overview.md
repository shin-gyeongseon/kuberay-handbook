# 4.1 KubeRay 개요와 장점

KubeRay는 Ray를 Kubernetes 위에서 안정적으로 운영하고 확장할 수 있도록 도와주는 **공식 오퍼레이터 기반 관리 도구**입니다. Ray 클러스터를 Kubernetes 네이티브 방식으로 정의하고, 배포하고, 운영할 수 있게 만들어 줍니다.

## KubeRay란?

KubeRay는 Kubernetes CRD(Custom Resource Definition)를 기반으로 동작하는 컨트롤러입니다. 사용자는 RayCluster, RayJob, RayService 같은 리소스를 YAML로 정의하고, KubeRay는 이를 기반으로 Ray 클러스터를 자동으로 생성, 업데이트, 관리합니다.

🔗 Kubernetes Operator에 대해 더 알고 싶다면, CNCF 공식 블로그 글을 참고해보세요:  
[Kubernetes Operators: what are they?](https://www.cncf.io/blog/2022/06/15/kubernetes-operators-what-are-they-some-examples/?utm_source=chatgpt.com)  

- CNCF Sandbox 프로젝트로 2022년 공식 채택
- Ray 공식 팀(Anyscale)이 적극적으로 유지보수
- Helm 차트, Custom Controller, Validation Webhook 포함

## 주요 특징

- **Kubernetes 네이티브 인터페이스**  
  CRD 정의만으로 Ray 클러스터 구성 및 서빙, 잡 실행 가능

- **자동 롤링 업데이트**  
  Serve나 Cluster의 설정 변경 시 무중단 롤링 업데이트 제공

- **Helm 연동 및 GitOps 지원**  
  Helm 차트로 설치 가능하며 ArgoCD, Flux 등과 통합하여 GitOps 운영 가능

- **Multi-Tenant 환경 지원**  
  네임스페이스 분리, 리소스 쿼터를 통한 멀티 테넌시 구성 가능

- **Autoscaler 내장 지원**  
  워커 노드 수를 workload 기반으로 자동 조절 (Karpenter 등과 통합 가능)

## 사용 사례

- **머신러닝 플랫폼**  
  Ray 기반 분산 학습, 하이퍼파라미터 튜닝, 서빙 파이프라인을 통합 운영

- **산업 데이터 파이프라인**  
  Ray Serve를 통해 실시간 예측 API 제공, Ray Workflow로 ETL 파이프라인 관리

  > [The experimental Ray Workflows library has been deprecated and will be removed in a future version of Ray.](https://docs.ray.io/en/latest/workflows/index.html)
  이건 공식 문서에서 deprecated 되어있음, 사용하지 말자

- **R&D 실험 환경**  
  연구자가 자신의 네임스페이스에서 RayCluster를 온디맨드로 생성하고 실험

## 기존 솔루션 대비 장점

| 항목 | 기존 방법 | KubeRay 방식 |
|------|-----------|---------------|
| 배포 | 수동 Ray start 명령 | CRD 정의로 자동 생성 |
| 관리 | Pod 수동 관리 | 컨트롤러가 자동 조정 |
| 확장성 | 오토스케일링 직접 구현 필요 | 내장 Autoscaler + K8s 스케줄러 연계 |
| 업데이트 | 중단 후 재배포 | 롤링 업데이트 |
| 운영 도구 | 별도 설정 필요 | Helm + GitOps 연동 가능 |

---

KubeRay는 Ray의 강력한 분산 컴퓨팅 능력을 Kubernetes의 유연한 관리성과 결합해, 실무에서 사용 가능한 강력한 플랫폼을 제공합니다. 다음 장에서는 KubeRay의 아키텍처를 좀 더 깊이 있게 살펴보겠습니다.
