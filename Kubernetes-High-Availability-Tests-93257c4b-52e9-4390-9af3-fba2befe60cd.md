# Kubernetes - High Availability Tests

## Overview

The purpose of this document is to perform high availability and stability tests of the kubernetes cluster. These tests are performed on a pre-productive environment so as not to affect the stability of the production cluster.

## Designing an architecture in HA

![](ha-master-gce-d6f438a8-a149-4952-9e2e-346bf83b7a51.png)

### High availability for the Kubernetes control plane

The Kubernetes control plane consists of the controller manager, scheduler, and API server. When running a highly available Kubernetes cluster, the first thing to focus on is running multiple replicas of these control plane components.

### High availability for the Kubernetes data plane

Kubernetes uses etcd as a data store for all cluster-related data. That means the information about the pods you're running, the nodes you have in your clusters, and the secrets—all of that is stored in etcd. In a reliable system, etcd needs to be able to handle failures without losing data. Etcd uses a quorum-based leader election algorithm, while the Kubernetes scheduler uses an active-passive leader election.

## **Master Components**

Master components provide the cluster’s control plane. Master components make global decisions about the cluster (for example, scheduling), and detecting and responding to cluster events (starting up a new pod when a replication controller’s **`replicas`** field is unsatisfied).

Master components can be run on any machine in the cluster. However, for simplicity, set up scripts typically start all master components on the same machine, and do not run user containers on this machine. See [Building High-Availability Clusters](https://kubernetes.io/docs/admin/high-availability/) for an example multi-master-VM setup.

### kube-apiserver

Component on the master that exposes the Kubernetes API. It is the front-end for the Kubernetes control plane.

It is designed to scale horizontally – that is, it scales by deploying more instances. See [Building High-Availability Clusters](https://kubernetes.io/docs/admin/high-availability/).

### etcd

Consistent and highly-available key value store used as Kubernetes’ backing store for all cluster data.

Always have a backup plan for etcd’s data for your Kubernetes cluster. For in-depth information on etcd, see [etcd documentation](https://github.com/coreos/etcd/blob/master/Documentation/docs.md).

### kube-scheduler

Component on the master that watches newly created pods that have no node assigned, and selects a node for them to run on.

Factors taken into account for scheduling decisions include individual and collective resource requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference and deadlines.

### kube-controller-manager

Component on the master that runs [controllers](https://kubernetes.io/docs/admin/kube-controller-manager/).

Logically, each [controller](https://kubernetes.io/docs/admin/kube-controller-manager/) is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process.

These controllers include:

- Node Controller: Responsible for noticing and responding when nodes go down.
- Replication Controller: Responsible for maintaining the correct number of pods for every replication controller object in the system.
- Endpoints Controller: Populates the Endpoints object (that is, joins Services & Pods).
- Service Account & Token Controllers: Create default accounts and API access tokens for new namespaces.

### cloud-controller-manager

[cloud-controller-manager](https://kubernetes.io/docs/tasks/administer-cluster/running-cloud-controller/) runs controllers that interact with the underlying cloud providers. The cloud-controller-manager binary is an alpha feature introduced in Kubernetes release 1.6.

cloud-controller-manager runs cloud-provider-specific controller loops only. You must disable these controller loops in the kube-controller-manager. You can disable the controller loops by setting the **`--cloud-provider`** flag to **`external`** when starting the kube-controller-manager.

cloud-controller-manager allows cloud vendors code and the Kubernetes code to evolve independent of each other. In prior releases, the core Kubernetes code was dependent upon cloud-provider-specific code for functionality. In future releases, code specific to cloud vendors should be maintained by the cloud vendor themselves, and linked to cloud-controller-manager while running Kubernetes.

The following controllers have cloud provider dependencies:

- Node Controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- Route Controller: For setting up routes in the underlying cloud infrastructure
- Service Controller: For creating, updating and deleting cloud provider load balancers
- Volume Controller: For creating, attaching, and mounting volumes, and interacting with the cloud provider to orchestrate volumes

## **Node Components**

Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment.

### kubelet

An agent that runs on each node in the cluster. It makes sure that containers are running in a pod.

The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy. The kubelet doesn’t manage containers which were not created by Kubernetes.

### kube-proxy

[kube-proxy](https://kubernetes.io/docs/admin/kube-proxy/) enables the Kubernetes service abstraction by maintaining network rules on the host and performing connection forwarding.

### Container Runtime

The container runtime is the software that is responsible for running containers. Kubernetes supports several runtimes: [Docker](http://www.docker.com/), [containerd](https://containerd.io/), [cri-o](https://cri-o.io/), [rktlet](https://github.com/kubernetes-incubator/rktlet) and any implementation of the [Kubernetes CRI (Container Runtime Interface)](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-node/container-runtime-interface.md).

## HA test environment

The architecture that is currently deployed in indalo complies with the requirements that we have previously verified. The number of master nodes is 3 and is replicated in multizone. for the nodes the disposition is 2 in each escalation group within each zone of availability

![](indalo-HA-f4f29fd5-7376-4459-97fe-d466da2c6278.png)

## Scenarios

In this section, the different test scenarios are contemplated to check the stability of the cluster. We start from the previous test environment.

### Scenario 1. Unavailability of services of master nodes

**Description:** In this step we will turn off the machines corresponding to the masters in the different areas of availability from the AWS console. To do this, we will perform an incremental shutdown of the master nodes in a controlled manager and evaluate the impact of the pods of the *etc* and control manager. To make sure that the service is active, we will make several requests through *kubectl* to check the status of the cluster.

[kube-apiserver](https://www.notion.so/7a1cf453b4fc4c699ebb07312b3aeb90)

### Scenario 2. Unavailability of nodes

Description: In this step we will turn off the machines corresponding to the masters in the different areas of availability from the AWS console. To do this, we will perform an incremental shutdown of the master nodes in a controlled manager and evaluate the impact of the pods of the *etc* and control manager. To make sure that the service is active, we will make several requests through *kubectl* to check the status of the cluster.