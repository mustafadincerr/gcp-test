#!/bin/bash

# GCP Container Registry adresi ve proje adı

GCR_REGISTRY="[gcr.io](http://gcr.io/)"
PROJECT_ID="your-project-id"

# Container Registry'deki repository adı

REPO_NAME="your-repository"

# Takip edilecek son imaj sayısı

MAX_IMAGES=5

# Docker imajının etiketini oluştur

get_image_tag() {
local timestamp=$(date +%Y%m%d%H%M%S)
echo "image-$timestamp"
}

# Docker imajını GCP Container Registry'ye pushla

push_image() {
local image_tag=$1
local image_name="$GCR_REGISTRY/$PROJECT_ID/$REPO_NAME:$image_tag"

docker tag my-image:latest "$image_name"
docker push "$image_name"
}

# Docker imajını GCP Container Registry'den sil

delete_image() {
local image_name=$1
gcloud container images delete "$image_name" --force-delete-tags --quiet
}

# Son MAX_IMAGES imajları listele

list_images() {
gcloud container images list-tags "$GCR_REGISTRY/$PROJECT_ID/$REPO_NAME" \
--format='get(digest)' --limit=$MAX_IMAGES --sort-by=~timestamp
}

# Son imajların listesini al

image_list=$(list_images)

# Eğer listede 5 imaj varsa en eski imajı sil

if [ $(echo "$image_list" | wc -l) -eq $MAX_IMAGES ]; then
oldest_image=$(echo "$image_list" | tail -n 1)
delete_image "$GCR_REGISTRY/$PROJECT_ID/$REPO_NAME@$oldest_image"
fi

# Yeni bir Docker imajı oluştur ve GCP Container Registry'ye pushla

new_image_tag=$(get_image_tag)
push_image "$new_image_tag"