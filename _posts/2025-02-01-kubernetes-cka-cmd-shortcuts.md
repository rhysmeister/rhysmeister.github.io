---
layout: post
title: CKA Exam Command Shortcuts 
date: 2025-02-01 17:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - kubernetes
  - cka
tags:
  - kubernetes
  - cka
---


| Alias   Example | Description |
|--------|---------|---------|-------------|
| `k=kubectl` | - | Pre-configured alias for kubectl |
| `export do="--dry-run=client -o yaml"` | `k create deploy nginx --image=nginx $do` | Generate YAML for deployment without applying it |
| `export now="--force --grace-period 0"` | `k delete pod x $now` | Force delete a pod immediately |

These shortcuts can help speed up command execution during the CKA exam.
