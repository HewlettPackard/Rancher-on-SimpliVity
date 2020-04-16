# Executive summary

Software development in the enterprise is undergoing rapid and widespread change. Application architectures are moving
from monolithic and N-tier to cloud-native microservices while the development process has transitioned from waterfall
through agile to a DevOps focus. Meanwhile, deployments have moved from the data center to hosted environments
and now the cloud (public, private, and hybrid) and release cycles have shrunk from quarterly to weekly,
or even more frequently. To remain competitive, businesses require functionality to be delivered in a faster
and more streamlined manner, while facing ever-increasing security threats.

Rancher is a complete software stack for teams adopting containers. It addresses the operational and security challenges
of managing multiple Kubernetes clusters across any infrastructure, while providing DevOps teams with integrated tools
for running containerized workloads.

HPE SimpliVity is an enterprise-grade hyper-converged platform uniting best-in-class data services with the world's best-selling server. HPE SimpliVity provides new levels of performance, from infrastructure agility and resource fluidity to greater IT insights and visibility. By infusing artificial intelligence (AI) into hyperconverged infrastructure (HCI) environments, HPE SimpliVity has dramatically simplified and changed how customers can manage and support their infrastructure.

This Reference Configuration for Rancher on HPE SimpliVity is ideal for customer migrating legacy applications to
containers, transitioning to a container DevOps development model or needing a hybrid environment to support container and
non-containerized applications on a common VM platform. It provides a solution for IT operations, addressing the need for a
production-ready, on-premise environment for deploying and managing multiple Kubernetes clusters across all platforms, from
datacenter to cloud to edge. It describes how to automate and accelerate the provisioning of the environment using a set of
Ansible playbooks which, once configured, can deploy a highly available admin cluster in twenty minutes.


**Target Audience:** This document is primarily aimed at technical individuals working in the operations side of
the software pipeline, such as infrastructure architects, system administrators and infrastructure engineers, but
anybody with an interest in automating the provisioning of virtual servers and containers may find this document
useful.

**Assumptions:** A minimum understanding of concepts such as virtualization and
containerization and also some knowledge around Linux® and VMware® technologies.
