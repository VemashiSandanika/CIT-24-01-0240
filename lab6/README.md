# Lab 6 — Kubernetes Fundamentals with Minikube
# CCS3308 – Virtualization and Containers (Week 7)
# Registration Number: CIT-24-01-0240

## 1. Overview

This lab introduces the basic concepts and practical usage of Kubernetes. The objectives of this lab are to:
- Deploy and manage Pods
- Create Deployments
- Scale applications
- Expose applications using Services
- Perform rolling updates and rollbacks
- Deploy a multi-tier application
- Use StatefulSets for databases
- Troubleshoot Kubernetes workloads

## 2. Software Used

- Ubuntu Linux
- Docker
- Minikube
- Kubernetes
- kubectl
- Visual Studio Code / Nano Editor
- Git & GitHub

## 3. Project Structure

lab6/
│
├── k8s/
│   ├── pod-frontend.yaml
│   ├── deployment-frontend.yaml
│   ├── service-frontend.yaml
│   ├── api-deployment.yaml
│   ├── api-service.yaml
│   ├── cache-deployment.yaml
│   ├── cache-service.yaml
│   ├── postgres-statefulset.yaml
│   ├── postgres-service.yaml
│   └── broken-pod.yaml
│
├── screenshots/
│   ├── Task1.1.png
│   ├── Task2.1.png
│   ├── Task3.1.png
│   ├── Task4.1.png
│   ├── Task5.1.png
│   ├── Task6.1.png
│   ├── Task7.1.png
│   ├── Task7.2.1.png
|   ├── Task7.2.2.png
|   ├── Task7.2.3.png
│   ├── Task8.1.png
│   ├── Task9.1.png
|   ├── Task9.2.png
|   ├── Task9.3.png
│   └── Task10.1.png
│
├── README.md
└── answers.md


## 4. Lab Tasks Completed

## Part 1 – Creating a Pod

- Created a single Nginx Pod
- Verified the Pod was running
- Accessed the application using port forwarding

## Part 2 – Pod Verification

- Verified Pod status
- Accessed the application through localhost
- Observed the Nginx welcome page

## Part 3 – Deployment and Self-Healing

- Created a Deployment with three replicas
- Deleted one Pod
- Observed Kubernetes automatically creating a replacement Pod
- 
## Part 4 – Scaling

- Scaled the Deployment from 3 replicas to 5 replicas
- Scaled it back down to 2 replicas
- Observed Kubernetes creating and removing Pods automatically

## Part 5 – Service

- Created a NodePort Service
- Exposed the frontend application
- Accessed the application using Minikube Service

## Part 6 – Rolling Update and Rollback

- Updated the frontend container image
- Verified rollout completion
- Rolled back to the previous image version
- Verified successful rollback

## Part 7 – Multi-Tier Application

Deployed the following application components:

- Frontend Deployment
- API Deployment
- Redis Cache Deployment
- PostgreSQL StatefulSet

Created Services for each component.

Verified communication between services using a temporary BusyBox debug Pod.

## Part 8 – Persistent Storage

Configured PostgreSQL with:

- StatefulSet
- Persistent Volume Claim
- Persistent storage

Verified that storage remained attached to the database Pod.

## Part 9 – Troubleshooting

Created a faulty Pod configuration.

Used Kubernetes commands to:

- Identify the error
- Describe the Pod
- View logs
- Correct the configuration
- Redeploy successfully


## 5. Kubernetes Resources Used

- Pod
- Deployment
- Service
- NodePort
- ClusterIP
- StatefulSet
- Persistent Volume Claim (PVC)

## 6. Important Kubernetes Commands

bash
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get all

kubectl describe pod <pod-name>
kubectl logs <pod-name>

kubectl delete pod <pod-name>

kubectl scale deployment frontend --replicas=5

kubectl rollout status deployment/frontend
kubectl rollout undo deployment/frontend

kubectl port-forward pod/frontend-pod 8080:80

minikube service frontend --url

## 7. Learning Outcomes

By completing this lab, I learned how to:
- Create and manage Kubernetes Pods
- Deploy applications using Deployments
- Use Kubernetes Services for networking
- Scale applications
- Perform rolling updates and rollbacks
- Deploy multi-tier applications
- Use StatefulSets for databases
- Configure persistent storage
- Troubleshoot Kubernetes resources

## 8. Conclusion

This lab provided practical experience with Kubernetes fundamentals. It demonstrated how Kubernetes manages 
containerized applications using Pods, Deployments, Services, and StatefulSets. The self-healing, scaling, 
service discovery, rolling updates, and persistent storage features show why Kubernetes is widely used for 
modern cloud-native application deployment.

