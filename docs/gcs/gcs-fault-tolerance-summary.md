KubeRay의 GCS(Global Control Service) fault tolerance는 클러스터 수준 메타데이터를 관리하는 GCS의 실패를 방지하기 위해 설계되었습니다. 기본 GCS는 메모리 기반으로 결함 허용 기능이 없어 실패 시 전체 클러스터가 중단될 수 있지만, 이를 활성화하면 고가용성 Redis를 사용해 데이터를 백업하고 재시작 시 복구합니다.

주요 특징:

운명 공유(fate-sharing): GCS fault tolerance 비활성화 시 GCS 프로세스 종료 후 Ray head Pod도 종료되며, 워커 Pod는 상태 손실로 재연결 실패.
사용 사례: Ray Serve처럼 고가용성이 중요한 경우 권장. 일반 워크로드에는 비권장.
전제 조건: Ray 2.0.0+, KubeRay 1.3.0+, Redis(단일 샤드 또는 Sentinel, 레플리카 포함).
주의사항: Redis의 영속적 fault tolerance가 필요하면 별도 튜닝 문서 참조.