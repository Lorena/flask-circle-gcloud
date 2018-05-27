# testing
 
This is a sample project to show how you can use Google Cloud and CircleCI to host apps on
a Kubernetes cluster.

The project requires some inital setup that
1. Creates a Kubernetes Engine
2. Initiall creates the app deployment and service so it's reachable from an IP

## Initial deployment

### Kubernetes Cluster Engine

First, to have a cluster to run apps on, we need to create a Kubernetes Engine with a Google Cloud account. Assuming you have `gcloud` set up:

```$ gcloud deployment-manager deployments create kube-cluster-deployment --config deployment-manager/kube-cluster-deployment.yaml```

Then get the credentials for `kubectl` to run commands on the cluster:

```gcloud container clusters get-credentials kube-cluster```

### Upload initial image

As preparation for the kubernetes deployment, we need to have an image that is available:

```
$ docker build -t flask-test .
$ docker tag flask-test gcr.io/symbolic-axe-123456/flask-test:latest
```

### Create deployment and service

We can now create the initial deployment and service using a yaml file with the specifications. The yaml file refers to the image we just uploaded.

```$ kubectl create -f kube-deployments/flask-deployment.yaml```

Wait for an external IP to appear

```
$ kubectl get svc
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
flask-service   LoadBalancer   10.27.245.152   <pending>     80:30633/TCP   47s
kubernetes      ClusterIP      10.27.240.1     <none>        443/TCP        1m
(env) [niels@leoilap flask-test] (master)$ kubectl get svc
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
flask-service   LoadBalancer   10.27.245.152   35.195.123.199   80:30633/TCP   1m
kubernetes      ClusterIP      10.27.240.1     <none>           443/TCP        1m
```

All done!

Now, assuming you've set up the required environment variables on CircleCi, you should be able to commit and push to this repository, and your app will be updated accordingly.

## Required environment variables for CircleCI

Circle will require the following variables:
- GCLOUD_SERVICE_KEY
- GOOGLE_CLUSTER_NAME
- GOOGLE_COMPUTE_ZONE
- GOOGLE_PROJECT_ID

