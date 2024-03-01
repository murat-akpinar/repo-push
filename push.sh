#!/bin/bash

TAR_FILE=$1

# Repo URL'si
REPO_URL="nexus-repo-address"
today=$(date +%Y%m%d)

if [ -z "$TAR_FILE" ]; then
    echo "Lütfen bir tar dosyası adı girin."
    echo "Kullanım: $0 <dosya.tar>"
    exit 1
fi

output=$(docker load -i "$TAR_FILE")
loaded_image=$(echo $output | grep -oP '(?<=Loaded image: )[^ ]+')

if [ -z "$loaded_image" ]; then
    echo "Imaj yüklenemedi veya imaj adı bulunamadı."
    exit 1
fi

# İmaj adını ve tag'ını ayır (eğer varsa)
image_name=$(echo $loaded_image | cut -d ':' -f 1)
image_tag=$(echo $loaded_image | cut -d ':' -f 2)

# Eğer yüklenen imajda tag yoksa, 'latest' olarak varsay
if [ -z "$image_tag" ]; then
    image_tag="latest"
fi

# Yeni tag ile docker tag ve docker push
new_tag="${REPO_URL}/${image_name}:${today}"
docker tag "${image_name}:${image_tag}" "${new_tag}"
docker push "${new_tag}"

