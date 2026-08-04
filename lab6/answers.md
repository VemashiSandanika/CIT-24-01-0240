## Lab 6 - Checkpoint Answers 
## Registration Number: CIT-24-01-0240 


# Task 1.2 - Pod to Component Mapping

| Pod name | Component |
|---|---|
| kube-apiserver-minikube | API Server |
| etcd-minikube | etcd |
| kube-scheduler-minikube | Scheduler |
| kube-controller-manager-minikube | Controller Manager |
| kube-proxy-wh49g | kube-proxy |
| coredns-7d764666f9-66kns | Not in the lecture list - this is the cluster's internal DNS |
| storage-provisioner | Not in the lecture list - Minikube's storage add-on |

# Checkpoint Q1

The control plane is the part of Kubernetes that makes decisions. It decides what should run and where, but it does not 
run the actual application containers. It has the API Server (which everything talks to), etcd (stores the cluster's state), 
the Scheduler (decides which node a Pod goes to), and the Controller Manager (keeps checking that what's actually running 
matches what should be running). A worker node is where the Pods actually run. Each worker node has a kubelet (starts and 
stops containers), kube-proxy (handles network traffic to Pods), and a container runtime (actually runs the containers).

# Checkpoint Q2

Yes, the IP address changed after I deleted the pod and recreated it from the same manifest. This happened because Pods 
in Kubernetes are "ephemeral," meaning they are not permanent objects. Deleting a Pod removes it completely, and applying 
the manifest again creates a brand new Pod that receives a freshly assigned IP address from the cluster's internal network. 
Kubernetes does not guarantee that a Pod will keep the same IP address across restarts, which is exactly why Services exist, 
since they provide a stable address that does not change even when the underlying Pods do.

## Checkpoint Q3

When I deleted one of the 3 pods, Kubernetes noticed the actual number of running pods (2) didn't match the desired number (3). 
The Deployment controller is always watching for this kind of mismatch. Once it detected the gap, it created a new pod 
automatically to bring the count back to 3. This happened within about 20 seconds in my case.

## Checkpoint Q4

Each tier (frontend, API, cache, database) is its own separate Kubernetes object with its own replica count and label selector, 
connected only through Services, not directly to each other. So scaling the frontend only changes its own ReplicaSet, never 
touching the api, cache, or postgres objects , which matches the lecture's point that each service can scale independently.

## Checkpoint Q5

port-forward connects directly to one specific pod by name, so if that pod gets deleted/replaced, the connection breaks. 
A Service instead gives a stable address that always points to whichever pods are currently healthy, even if the actual pods 
behind it change. This matters because pods get new IPs whenever they restart, so without a Service things would keep breaking.

## Checkpoint Q6

Docker Compose doesn't have a proper way to update containers without downtime, and it has no easy way to undo an update if 
something goes wrong. Kubernetes updates pods one at a time, keeping the app available the whole time, and it remembers the 
previous version so I could run kubectl rollout undo to instantly go back to the old image. Doing the same thing safely in 
Compose would need a lot of manual work. This directly matches the lecture's list of things 'Docker Compose Cannot' do- safe 
rolling updates and rollbacks are not something Compose supports natively.

## Checkpoint Q7

Frontend and API don't need to remember any specific identity, any copy of them works the same, so a Deployment is enough. 
The database needs to keep its data and stay connected to the same storage every time, so it needs a StatefulSet. StatefulSets 
give pods a fixed name (like postgres-0) and their own permanent storage that doesn't change even if the pod restarts. 
StatefulSets also guarantee ordering — Pods are created, scaled, and terminated in a strict sequential order (e.g. postgres-0 
before postgres-1 if there were more replicas), which matters for databases that need predictable startup order, whereas a 
Deployment gives no such guarantee.

## Checkpoint Q8

No, the data would not have survived. Without a PVC, the database's data directory is just ephemeral storage inside that one 
container. Deleting the Pod removes it completely, and the new container starts fresh with none of the old data. A PVC keeps 
the data on a separate volume that isn't tied to the container's lifecycle, so the new Pod reattaches to the same volume and 
keeps the same data , exactly what I observed when my test row survived the pod restart.

## Checkpoint Q9

The broken pod showed ErrImagePull first, then ImagePullBackOff. This isn't one of the four statuses mentioned in the lecture 
(Running/Pending/CrashLoopBackOff/OOMKilled). CrashLoopBackOff means the container starts but keeps crashing, while ImagePullBackOff 
means the container can't even start because Kubernetes couldn't download the image at all (since I used a fake tag that doesn't exist).


