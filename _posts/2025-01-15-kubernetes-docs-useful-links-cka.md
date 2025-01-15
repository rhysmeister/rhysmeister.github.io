---
layout: post
title: kubernetes.io documentation - Useful links for the CKA
date: 2025-01-15 07:00:00.000000000 +01:00
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

For the [CKA Exam](https://training.linuxfoundation.org/certification/certified-kubernetes-administrator-cka/) it's useful to know the documentation well, and to be able to navigate quickly to appropriate code snippets, command and the like. I present here a short list of links that may be useful, in the exam, for specific question categories.

* [Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
* [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
* [Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)
  * See [Securing communication](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#securing-communication) for running commands with tls certs.
* Configure POD Resources
  * [Memory Resources](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/)
  * [CPU Resources](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/)
* Volumes
  * [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
  * [PersistentVolumeClaims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims)
  * [Configure a volume for a POD](https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/)
  * [Configure a POD to use a PersistentVolume](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/)
* [kubectl](https://kubernetes.io/docs/reference/kubectl/)
  * [kubectl quick reference](https://kubernetes.io/docs/reference/kubectl/quick-reference/)
  * [JSONPath support](https://kubernetes.io/docs/reference/kubectl/jsonpath/)
  * [kubectl events](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_events/)
  * For kubectl examples search the documentation site for examples, e.g. `kubectl create <object>`.
    * [kubectl create secret generic](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_secret/)
    * [kubectl create deployment](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_deployment/)
    * [kubectl create configmap](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_configmap/)
* [Taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [Certificate Signing Requests](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests)
  * [How to issue a certificate for a user](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user)

Found a pretty [Comprehensive CKA Bookmark List](https://github.com/datmt/CKA-Examples/blob/master/resources/bookmark.html) during my googling.