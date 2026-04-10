# Kyverno Policy: Prevent Privileged & Root Containers

## Context

This policy comes from a common issue in shared Kubernetes clusters.

When multiple teams deploy workloads on the same cluster, it's very easy for insecure configurations to slip through — especially things like:

- running containers as root
- enabling privileged mode
- allowing privilege escalation

In a multi-tenant setup, this is not just a bad practice — it’s a real risk. One compromised container can potentially affect other workloads on the same node.

We initially relied on code reviews to catch this, but that didn’t scale well and was inconsistent.

---

## Approach

Instead of relying on humans, I moved this enforcement to the cluster level using Kyverno.

The idea is simple:
Any workload that doesn’t follow basic security constraints should never get scheduled in the first place.

Kyverno’s admission controller makes this straightforward — the request is validated before it reaches the scheduler.

---

## What this policy enforces

- No privileged containers
- Containers must not run as root
- Privilege escalation must be disabled
- Default seccomp profile must be used

---

