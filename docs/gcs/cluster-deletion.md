Ray 클러스터를 완전히 삭제하려면 Pod, Redis 키, 리소스를 모두 정리해야 합니다. 아래는 단계별 방법입니다.

- RayCluster 커스텀 리소스 삭제:

    `kubectl delete raycluster <클러스터-이름>  # 예: raycluster-external-redis`

    이는 KubeRay 오퍼레이터가 Pod 삭제를 트리거합니다.

- Pod 삭제 확인:모든 Pod가 종료될 때까지 기다립니다.

    `kubectl get pods`
    예상: Ray 관련 Pod 없음. 

- Redis 키 클린업 (자동 또는 수동):  
    자동: 헤드 Pod 종료 후 오퍼레이터가 Job 생성하여 Redis 키 삭제.  
    `kubectl exec -i <REDIS-POD-이름> -- env REDISCLI_AUTH="<비밀번호>" redis-cli KEYS "*"`

    빈 목록 확인. 실패 시 수동 finalizer 제거 (위 명령 참조) 후 Redis 클린업.

- RayCluster 삭제 확인: `kubectl get raycluster`
    예상 출력: "No resources found in default namespace."

- 추가 정리 (필요 시):
    관련 ConfigMap, Secret, PVC 등 잔여 리소스 확인 및 삭제:

    ```shell
    kubectl get configmaps,secrets,pvcs -l ray-cluster-name=<클러스터-이름>
    kubectl delete <리소스-타입> <이름>
    ```

    Redis가 외부 클러스터라면 별도 관리.

    > 주의: 삭제 중 에러 발생 시 로그 확인 (kubectl logs <오퍼레이터-Pod>). GCS fault tolerance 비활성화 시 클린업 Job 생략