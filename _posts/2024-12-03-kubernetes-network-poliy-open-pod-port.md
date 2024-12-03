---
layout: post
title: Simple Kubernetes Network Policy to open up a pod port
date: 2024-12-03 21:16:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - kubernetes
tags:
  - kubernetes
  - networkpolicy
---

Below shows a very simple Kubernetes [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) object. This simply opens up port 80 to the outside in a locked-down environment. The key tags to understand are *run*, which should be a label on the pod you wish to match, and the *ports* block under *ingress*. This should be a list specifiying the ports you wish to open.


```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: np-test-1
  policyTypes:
  - Ingress
  ingress:
  - ports:
    - protocol: TCP
      port: 80
```