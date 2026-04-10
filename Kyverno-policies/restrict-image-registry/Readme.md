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

Developer / CI Pipeline
        ↓
Build Container Image
        ↓
Push to Artifact Registry
        ↓
Sign Image using Cosign + GCP KMS
        ↓
Deploy to Kubernetes
        ↓
Kyverno verifies signature
        ↓
ALLOW / DENY

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

 <b>```</b>
  
