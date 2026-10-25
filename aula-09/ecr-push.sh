#!/usr/bin/env bash
set -euo pipefail

REGION="us-east-1"
REPOSITORY="technova-api"
CONTEXT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/technova-api" && pwd)"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REGISTRY="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
IMAGE="${REGISTRY}/${REPOSITORY}"
SHA_TAG="sha-$(git rev-parse --short=7 HEAD)"

echo "Verificando repositório ECR..."

if ! aws ecr describe-repositories \
  --repository-names "$REPOSITORY" \
  --region "$REGION" >/dev/null 2>&1; then
  aws ecr create-repository \
    --repository-name "$REPOSITORY" \
    --region "$REGION" \
    --image-scanning-configuration scanOnPush=true
fi

echo "Autenticando Docker no Amazon ECR..."

aws ecr get-login-password --region "$REGION" |
  docker login --username AWS --password-stdin "$REGISTRY"

echo "Construindo imagem Docker..."

docker build -t "${IMAGE}:${SHA_TAG}" "$CONTEXT_DIR"

docker tag "${IMAGE}:${SHA_TAG}" "${IMAGE}:latest"

echo "Publicando tags SHA e latest..."

docker push "${IMAGE}:${SHA_TAG}"
docker push "${IMAGE}:latest"

GIT_TAG="$(git describe --tags --exact-match HEAD 2>/dev/null || true)"

if [[ "$GIT_TAG" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
  MAJOR_MINOR="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
  MAJOR="${BASH_REMATCH[1]}"

  for TAG in "$VERSION" "$MAJOR_MINOR" "$MAJOR"; do
    docker tag "${IMAGE}:${SHA_TAG}" "${IMAGE}:${TAG}"
    docker push "${IMAGE}:${TAG}"
  done
else
  echo "Sem git tag vX.Y.Z no commit atual: semver não publicado."
fi

echo "Publicação concluída!"
echo "Imagem: ${IMAGE}"
echo "Tags: ${SHA_TAG}, latest"
