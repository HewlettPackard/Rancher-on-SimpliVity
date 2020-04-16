# Rancher overview

Rancher can be used to deploy production-grade Kubernetes clusters from on premise datacenters to the cloud and the edge.
It also enables you manage your multiple deployments through centralized authentication, access control and observability.

-  **Unified multi-cluster management**

    Rancher unites Kubernetes clusters with centralized authentication and access control, enterprise security, auditing, backups, upgrades, observability and alerts. Deploy and secure clusters consistently in minutes anywhere using an intuitive UI or powerful CLI

- **Hybrid & multi-cloud support**

    Manage on premise clusters and those hosted on cloud services from Microsoft (AKS), Amazon (EKS) and Google (GKE) from a single pane of glass. Centrally configure security policy, audit logs and monitor performance. Deploy multi-cluster apps consistently from the app catalog. Control access by connecting them to your internal identity provider like Active Directory, LDAP or Okta.

- **Centralized App Catalog**

   Leverage Helm for turnkey multi-cluster deployment of popular open source tools or apps from the partner ecosystem right within Rancher.

 - **Accelerate DevOps adoption**

    Rancher supports tools that DevOps teams already use like Jenkins, Gitlab or Travis for building CI/CD pipelines, Prometheus and Grafana for observability, Fluentd for logging, and Istio for service mesh.

- **Free and open-source**


## Terminology

The **Rancher server** manages and provisions Kubernetes clusters. You can interact with downstream Kubernetes clusters through the Rancher server’s user interface.

**RKE (Rancher Kubernetes Engine)** is a certified Kubernetes distribution and CLI/library which creates and manages a Kubernetes cluster.

The **Admin cluster** in this solution is a highly available, three-node RKE cluster with load balancers and support 
services including DHCP. The Rancher server software is deployed on each of the nodes in the admin cluster.

**User clusters** can be deployed using Rancher, on premise or in the cloud. You can also import existing clusters into
Rancher for unified management. This solution can be used to deploy one or more user clusters on vSphere
running on HPE SimpliVity hardware.

