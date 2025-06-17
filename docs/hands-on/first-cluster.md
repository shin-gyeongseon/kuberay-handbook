# 5.2 최초 RayCluster 배포

> **작성 중** - 이 문서는 아직 작성 중입니다.

## 전제 조건

## 기본 RayCluster 매니페스트 생성

```yaml
# ray-cluster.yaml 예시
apiVersion: ray.io/v1alpha1
kind: RayCluster
metadata:
  name: ray-cluster
spec:
  # 구성 내용
```

## 클러스터 배포

```bash
kubectl apply -f ray-cluster.yaml
```

## 배포 확인

## 기본 테스트

## 리소스 정리
