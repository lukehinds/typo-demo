# Demo Steps

## Install kind

```bash
kind create cluster --name sigstore-demo --config manifests/kind-config.yaml
```

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update
```

```bash
helm install kyverno kyverno/kyverno -n kcduk-demo --create-namespace
```
454

## Configure policy


```bash
kubectl apply -f manifests/imagePolicy.yaml --namespace kcduk-demo
```

Run bad image, fails

```bash
kubectl run bad-image --image=ghcr.io/lukehinds/blackhat-next-security-demo:main
```

Run good image, runs

```bash
kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main
```

Delete image

```bash
kubectl delete pod good-image --now
```

Add lhinds@sigstore.dev to policy, and apply config 

```yaml
- keyless:
    subject: "lhinds@sigstore.dev"
    issuer: "https://github.com/login/oauth"
```

```bash
kubectl apply -f manifests/imagePolicy.yaml --namespace kcduk-demo
```

Run good image, runs

```bash
kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main
```

Sign with podman

```bash
cosign sign ghcr.io/lukehinds/redhat-next-security-demo:main
```

Look up signature and cert in rekor and set 

```bash
logindex=12345
```

```bash
rekor-cli get --log-index 3482746 --format=json | jq ".Body | .HashedRekordObj | .signature | .publicKey | .content" | cut -d '"' -f2 | base64 -D
```

Show certificate

```bash
openssl x509 -in cert.pem -text
```

Run good image, runs

```bash
kubectl run good-image --image=ghcr.io/lukehinds/redhat-next-security-demo:main
```

