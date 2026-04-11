# Restrict Image Registry + Enforce Signed Images (KMS + Cosign)

## Problem

In a multi-tenant Kubernetes platform, developers can deploy container images from any public registry.

This creates multiple risks:
- Untrusted or compromised images
- Supply chain attacks
- Lack of traceability and ownership

## Solution

This policy enforces:

1. Only images from Google Artifact Registry are allowed
2. All images must be cryptographically signed
3. Signature verification is enforced at admission time

This eliminates the need for manual approval workflows and ensures only trusted workloads are deployed.

---

## Architecture Flow
```mermaid
flowchart TD
    A[Developer / CI Pipeline] --> B[Build Container Image]
    B --> C[Push to Artifact Registry]
    C --> D[Sign Image using Cosign + GCP KMS]
    D --> E[Deploy to Kubernetes]
    E --> F[Kyverno verifies signature]
    F --> G{Decision}
    G -->|Valid| H[ALLOW]
    G -->|Invalid| I[DENY]

---

## Step 1 — Create KMS Key

```bash
gcloud kms keyrings create cosign-keyring \
  --location=asia-south1

gcloud kms keys create cosign-key \
  --location=asia-south1 \
  --keyring=cosign-keyring \
  --purpose=asymmetric-signing \
  --default-algorithm=ec-sign-p256-sha256

```
## Step 2 — Grant Signing Permission
```bash
gcloud kms keys add-iam-policy-binding cosign-key \
  --location=asia-south1 \
  --keyring=cosign-keyring \
  --member="serviceAccount:CI-SA@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/cloudkms.signerVerifier"
```
## Step 3 — Get Public Key
```bash
gcloud kms keys versions get-public-key 1 \
  --location=asia-south1 \
  --keyring=cosign-keyring \
  --key=cosign-key
```
## Step 4 — Push Image to Artifact Registry
```bash
docker build -t asia-south1-docker.pkg.dev/PROJECT_ID/app/app:v1 .

docker push asia-south1-docker.pkg.dev/PROJECT_ID/app/app:v1
```

## Step 5 — Sign Image using Cosign + KMS
```bash
cosign sign \
  --key gcpkms://projects/PROJECT_ID/locations/asia-south1/keyRings/cosign-keyring/cryptoKeys/cosign-key \
  asia-south1-docker.pkg.dev/PROJECT_ID/app/app:v1
```

## Step 6 — Deploy Policy
```bash
kubectl apply -f policy.yaml
```
