# 1. 왜 Ray인가? _(Why Ray?)_

> **요약** : 데이터·AI 워크로드가 “대규모·저지연·다양성” 3박자를 요구하면서, **Ray**는 _Python 친화적 분산 런타임 + 유니버설 API + 클라우드 네이티브 오퍼레이터(KubeRay)_ 라는 독특한 조합으로 급부상했습니다.

## 1-1. 기술적 필요성

| 요구사항 | 전통 솔루션 한계 | Ray의 접근 |
|----------|-----------------|------------|
| **세분화된 병렬화** <br>(Micro-task, Actor) | Spark: RDD단위·배치 중심 | Task/Actor API로 함수·객체 단위 스케일-아웃 |
| **Python 에코시스템** | Hadoop 계열은 JVM 위주 | CPython 그대로 실행, Numpy/PyTorch 호환 |
| **서빙·실험·파이프라인 통합** | MSA 따로, Airflow 따로 | Serve·Tune·Workflow 모듈로 “하나의 런타임” |
| **클라우드 네이티브** | YARN/Mesos 종속 · 쿠버네티스 부자연 | KubeRay Operator + CRD = 선언형 배포 |
| **GPU / TPU 혼합 스케줄링** | Spark는 GPU 지원이 제한적 | 자원 태그 기반 스케줄러, Rapids·CUDA 호환 |

## 1-2. 경쟁 프레임워크 비교

| 항목 | **Ray** | **Apache Spark** | **Dask** | **Celery** |
|------|---------|------------------|-----------|-----------|
| 주 사용언어 | Python (1st-class) | JVM·Scala | Python | Python |
| 실행 단위 | *Task / Actor* | Stage / RDD | Task / Graph | Task / Queue |
| 실시간·서빙 | **Serve** 통합 | Structured Streaming 한정 | 별도 프로젝트 필요 | 제한적 |
| 쿠버네티스 Operator | **KubeRay** (CRD 완비) | Spark-on-k8s Webhook | Dask-Kubernetes | 없음 |
| GPU 네이티브 | ✅ | ⚠ 부분 | ⚠ 부분 | ❌ |
| 대표 사용처 | OpenAI, Shopify, Uber | Netflix, Pinterest | Prefect, Saturn Cloud | Instagram, Reddit |

> **결론** : _“Python 데이터 + AI +Burst-scaling”_ 조합엔 Ray가 비용 대비 학습·서빙 통합 속도가 가장 빠르다.

## 1-3. 채택 트렌드 & 사례

- **OpenAI** : GPT 전처리 파이프라인 → Ray Data & Workflow  
- **Shopify** : 실시간 딜리버리 ETA → Ray Serve + Autoscaler  
- **Uber** : 자율주행 시뮬레이션 → 10 K+ 노드 Ray Cluster  

IDC 2024 보고서 기준, _“Ray adoption CAGR > 120 %”_ 로 Spark/Dask 대비 가장 가파른 성장세를 기록.

## 1-4. 이 문서의 학습 범위

1. **기초** : Task·Actor·Placement Group 이해  
2. **Ray Service 패밀리** : Cluster / Serve / Job / Workflow  
3. **KubeRay 실전** : CRD 배포·오토스케일·모니터링  
4. **운영 고급** : 멀티테넌시·GPU 스케줄링·CI/CD
