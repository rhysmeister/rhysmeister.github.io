---
layout: post
title: kubectl apply Vs kubectl create
date: 2025-03-02 20:00:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - kubernetes
  - kubectl
tags:
  - kubernetes
  - kubectl
---

What's the difference between `kubectl apply` and `kubectl create`?

There's already a whole bunch of good explainers...

- [Difference Between kubectl apply and kubectl create](https://www.baeldung.com/ops/kubectl-apply-create)
- [Obligatory Stackoverflow thread](https://stackoverflow.com/questions/47369351/kubectl-apply-vs-kubectl-create)
- [YouTube Explainer](https://www.youtube.com/watch?v=oCl882Q-Lnw)

But what, for example, assuming none of the K8s resources defined in the file exist, would the difference between...

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

and

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

be? We should end up with the same result right? Sadly, this is not the case. The apply command will result in a failed deployment and report the following error...

`
The CustomResourceDefinition "installations.operator.tigera.io" is invalid: metadata.annotations: Too long: must have at most 262144 bytes
`

There's a [Github thread going into detail](https://github.com/projectcalico/calico/issues/7826) about this but basically `kubectl apply` should not be used as it was not designed to handle large resources. For [Calico] we should use `kubectl create` on deployment and `kubectl replace` on upgrade to handle this issue.