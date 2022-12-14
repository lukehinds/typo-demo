#!/usr/bin/env bash

########################
# include the magic
########################
. ~/bin/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

clear

pe "open -a \"Google Chrome\" https://github.com/lukehinds/favorite-json"

pe "open -a \"Google Chrome\" https://github.com/lukehinds/favourite-json"

pe "# export log_id from GitHub Action"

cmd

pe "rekor-cli get --log-index=$log_id --format=json | jq \".Body | .HashedRekordObj | .signature | .publicKey | .content\" | cut -d '\"' -f2 | base64 -D > cert-action.pem"

pe "openssl x509 -in cert-action.pem -text -noout"

pe "kubectl get all -n typo-demo"

pe 'tail -n 30 manifests/imagePolicy.yaml'

pe "kubectl apply -f manifests/imagePolicy.yaml --namespace typo-demo"

pe "kubectl run bad-image --image=ghcr.io/lukehinds/favourite-json:main"

pe "kubectl run nginx --image=nginx:latest"

pe "kubectl run good-image --image=ghcr.io/lukehinds/favorite-json:main"

pe "kubectl get pod good-image"

pe "cat ./Dockerfile"

pe "docker build -t typo-alpine:latest ."

pe "docker tag typo-alpine:latest ghcr.io/lukehinds/typo-alpine:latest"

pe "docker push ghcr.io/lukehinds/typo-alpine:latest"

pe "open -a \"Google Chrome\" https://github.com/users/lukehinds/packages/container/typo-alpine/settings"

pe "kubectl run typo-alpine --image=ghcr.io/lukehinds/typo-alpine:latest"

pe "tail -n 30 manifests/imagePolicy-email.yaml"

pe "kubectl apply -f manifests/imagePolicy-email.yaml --namespace typo-demo"

pe "cosign sign ghcr.io/lukehinds/typo-alpine:latest"

pe "# log_id from GitHub Cosign"

cmd

pe "rekor-cli get --log-index=$log_id --format=json | jq \".Body | .HashedRekordObj | .signature | .publicKey | .content\" | cut -d '\"' -f2 | base64 -D > cert-email.pem"

pe "openssl x509 -in cert-email.pem -text -noout"

pe "kubectl run typo-alpine --image=ghcr.io/lukehinds/typo-alpine:latest"

pe "kubectl delete pod good-image"

pe "kubectl delete pod typo-alpine"

pe "# Yay! We made it through the demo! <applause!>"

# pe "tail -n 30 manifests/imagePolicy-email.yaml"

# pe "kubectl apply -f manifests/imagePolicy-email.yaml --namespace typo-demo"

# pe "kubectl run good-image --image=ghcr.io/lukehinds/favorite-json:main"

# pe "cosign sign ghcr.io/lukehinds/favorite-json:main"

# p "# log_id from email"

# cmd

# pe "rekor-cli get --log-index=$log_id --format=json | jq \".Body | .HashedRekordObj | .signature | .publicKey | .content\" | cut -d '\"' -f2 | base64 -D > cert-email.pem"

# pe "openssl x509 -in cert-email.pem -text -noout"

# pe "kubectl run good-image --image=ghcr.io/lukehinds/favorite-json:main"

# pe "kubectl delete pod good-image"
