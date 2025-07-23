RayCluster 삭제 시 KubeRay는 GCS fault tolerance가 활성화된 클러스터에 Kubernetes finalizer를 추가하여 Redis 키 클린업을 보장합니다. 이는 클러스터 종료 후 잔여 데이터가 남지 않도록 합니다.

상세 과정 (KubeRay v1.0.0 기준):

- kubectl delete raycluster <클러스터-이름> 명령으로 RayCluster 삭제 요청.
- KubeRay 오퍼레이터가 RayCluster의 모든 Pod(헤드 및 워커)를 삭제.
- 헤드 Pod 종료 후, 오퍼레이터가 Redis 키 삭제를 위한 Kubernetes Job 생성.
- Job이 성공적으로 완료되면 finalizer 제거, RayCluster 완전 삭제.
- 만약 Job 실패 시 (v1.0.0): 삭제가 차단되며, 수동 finalizer 제거 필요:

`kubectl patch rayclusters.ray.io <클러스터-이름> --type json --patch='[ { "op": "remove", "path": "/metadata/finalizers" } ]'`

그 후 Redis 키 수동 정리.

**KubeRay v1.1.0부터: 클린업이 'best-effort'로 변경되어 Job 실패 시에도 finalizer 제거하고 삭제 진행**. 이는 ENABLE_GCS_FT_REDIS_CLEANUP feature gate로 비활성화 가능 [docs.ray.io - turn off redis clean up](https://docs.ray.io/en/latest/cluster/kubernetes/user-guides/kuberay-gcs-ft.html#turn-off-redis-cleanup)


