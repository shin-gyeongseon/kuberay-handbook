# 5.3 RayService로 온라인 서빙 전환

> **작성 중** - 이 문서는 아직 작성 중입니다.

## RayService 개요

## 기본 RayService 매니페스트

```yaml
# ray-service.yaml 예시
apiVersion: ray.io/v1alpha1
kind: RayService
metadata:
  name: ray-service
spec:
  # 구성 내용
```

## 서비스 배포

```bash
kubectl apply -f ray-service.yaml
```

## 서비스 접근

## 트래픽 라우팅

## 자가 치유 테스트

## 모니터링 설정
