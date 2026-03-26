# ProjectX Infrastructure (Terraform + AWS + Kubernetes Monitoring)

## Overview

This repository contains Infrastructure as Code used to provision AWS infrastructure for the ProShop DevOps project.

Infrastructure is managed using **Terraform** and deployed via **GitHub Actions** following DevOps and GitOps principles.

The infrastructure provisions:

- AWS VPC
- Public and private subnets
- AWS EKS Kubernetes cluster
- Worker node groups
- AWS DocumentDB database
- AWS Secrets Manager credentials
- Prometheus monitoring
- Grafana dashboards
- Security groups and networking rules

This infrastructure supports the deployment of the ProShop e-commerce application running on Kubernetes.

---

# Architecture

Internet  
↓  
VPC  
↓  
Public Subnets  
↓  
Private Subnets  

EKS Cluster  
↓  
Worker Nodes  

Applications
- ProShop frontend
- ProShop backend

Monitoring Stack
- Prometheus
- Grafana

Database
- AWS DocumentDB

Secrets
- AWS Secrets Manager

---

# Technology Stack

Infrastructure
- Terraform
- AWS VPC
- AWS EKS
- AWS DocumentDB
- AWS Secrets Manager

Monitoring
- Prometheus
- Grafana

CI/CD
- GitHub Actions
- AWS OIDC authentication

---

# Terraform Modules

Infrastructure is implemented using custom Terraform modules.


### VPC Module

Creates:

- VPC
- public subnets
- private subnets
- route tables
- internet gateway

---

### EKS Module

Creates:

- EKS cluster
- worker node groups
- IAM roles
- Kubernetes networking

---

### DocumentDB Module

Creates:

- DocumentDB cluster
- database instances
- subnet group
- security group
- Secrets Manager credentials

---

# Monitoring Stack

Monitoring is implemented using **Prometheus and Grafana deployed in Kubernetes**.

Prometheus collects metrics from:

- Kubernetes nodes
- Kubernetes pods
- cluster components

Grafana provides dashboards to visualize:

- cluster CPU usage
- memory usage
- pod metrics
- application metrics

Prometheus and Grafana are deployed using Helm charts inside the **monitoring namespace**.

Example commands used for deployment:

helm upgrade --install prometheus ./eks-monitoring/charts/prometheus
-n monitoring
--create-namespace

helm upgrade --install grafana ./eks-monitoring/charts/grafana
-n monitoring

helm upgrade --install prometheus ./eks-monitoring/charts/prometheus
-n monitoring
--create-namespace

helm upgrade --install grafana ./eks-monitoring/charts/grafana
-n monitoring


During the project development only the **dev environment** is deployed.

---

# CI/CD Deployment

Terraform execution is handled through **GitHub Actions**.

Workflow steps:

1. Authenticate to AWS using OIDC
2. Terraform init
3. Terraform validate
4. Terraform plan
5. Terraform apply

Branch strategy:

feature/* → dev environment
main → dev environment

# DocumentDB Configuration

Database engine:

AWS DocumentDB (MongoDB compatible)

Configuration:

Instance type - db.t3.medium

Location - private subnets

TLS - disabled

Credentials stored in AWS Secrets Manager

---

# Connecting to DocumentDB

Run a temporary Mongo client pod:
kubectl run mongo-client
-n shop-app
--rm -it
--restart=Never
--image=mongo:4.4
-- bash


Then connect:
mongo
--host <docdb-endpoint>:27017
--username proshopadmin
--password <password>
--authenticationDatabase admin

Expected output - { "ok" : 1 }

# Seed Data

Initial application data can be imported directly from the backend container.

### 1. Find backend pod

kubectl get pods -n shop-app

---

### 2. Enter the backend container

kubectl exec -it proshop-backend-*******-***** -n shop-app -- sh

---

### 3. Navigate to backend directory

cd backend

---

### 4. Run seed script

node seeder.js

---


This imports initial application data including:

- users
- products
- orders

---


# DevOps Concepts Demonstrated

Infrastructure as Code

Terraform modular architecture

Kubernetes cluster provisioning

Database provisioning with Terraform

Monitoring with Prometheus and Grafana

Secure secret management

CI/CD with GitHub Actions

OIDC authentication with AWS
