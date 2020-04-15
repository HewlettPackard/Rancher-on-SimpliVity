# Rancher overview

You can use Rancher to deploy production-grade Kubernetes clusters from datacenter to cloud to the edge.
Rancher also unites all your disparate deployments with centralized authentication, access control and observability.

Yoiu can use Helm or the App Catalog to deploy and manage applications across any or all these environments, ensuring multi-cluster consistency with a single deployment.


## Terminology

The **Rancher server** manages and provisions Kubernetes clusters. You can interact with downstream Kubernetes clusters through the Rancher server’s user interface.

**RKE (Rancher Kubernetes Engine)** is a certified Kubernetes distribution and CLI/library which creates and manages a Kubernetes cluster.

The **Admin cluster** in this solution is a highly available, three-node RKE cluster with load balancers and support 
services including DHCP. The Rancher server software is deployed on each of the nodes in the admin cluster.

**User clusters** can be deployed using Rancher, on premise or in the cloud. You can also import existing clusters into
Rancher for unified management. This solution can be used to deploy one or more user clusters on vSphere
running on HPE SimpliVity hardware.

