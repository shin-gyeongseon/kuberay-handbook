# Ray Cluster Documentation

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

한국어로 작성된 Ray와 KubeRay에 대한 종합 가이드 및 실습 문서입니다. 이 저장소는 Ray의 핵심 개념부터 KubeRay를 활용한 실전 배포까지 체계적으로 학습할 수 있도록 구성되었습니다.
🌏 [WEB으로 보기](https://shin-gyeongseon.github.io/kuberay-handbook/)

## 📚 문서 구성

1. **Ray 소개**
   - Ray의 필요성과 장점
   - 학습 목표

2. **Ray 기초 다지기**
   - Ray 아키텍처 개요
   - 분산 개념: Task, Actor, Placement Group
   - Ray Runtime 핵심 서비스

3. **Ray Service 패밀리**
   - Ray Cluster (헤드 노드·워커 노드 구조)
   - Ray Serve (모델·API 서빙)
   - Ray Job (배치·실험 워크로드)
   - Ray Workflow / Ray Data

4. **KubeRay로 옮겨오기**
   - KubeRay 개요와 장점
   - KubeRay 아키텍처
   - RayCluster/Service/Job CRD 상세

5. **Hands-on KubeRay 실습**
   - Helm으로 KubeRay 설치
   - RayCluster 배포
   - RayService로 온라인 서빙
   - RayJob으로 분산 학습
   - Autoscaler/HPA 연동

6. **운영 & 모니터링** (작업 예정)
   - Ray Dashboard 사용법

## 🚀 시작하기

### 전제 조건

- Python 3.8+
- pip (Python 패키지 관리자)
- mkdocs (문서 빌드용)
- Docker (로컬 테스트용, 선택사항)

### 설치

1. 저장소 클론:
   ```bash
   git clone https://github.com/your-username/ray-cluster.git
   cd ray-cluster
   ```

2. 가상 환경 생성 및 활성화:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # Linux/Mac
   .venv\Scripts\activate    # Windows
   ```

3. 의존성 설치:
   ```bash
   pip install -r requirements.txt
   ```

### 로컬에서 문서 실행

```bash
mkdocs serve
```

웹 브라우저에서 `http://127.0.0.1:8000`에 접속하여 문서를 확인하세요.


## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.


---

이 문서는 [mkdocs-material/](https://squidfunk.github.io/mkdocs-material/)로 작성되었습니다.
