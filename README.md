# Wisecow Kubernetes Project

This project takes a simple web app called "Wisecow," puts it into a Docker container, and runs it on Kubernetes. Wisecow just shows a random quote from a cow every time you visit it.

## What You'll Need (Prerequisites)

  * Docker Desktop
  * A Kubernetes cluster
  * kubectl (the command-line tool to talk to Kubernetes)

--------------------------------------------------------------------------------

## 1. Setting Up Kubernetes Cluster

First, we need a Kubernetes cluster running on our machine. We can choose one of these below mentioned options.

### Option A: Use Docker Desktop

Docker Desktop comes with a built-in Kubernetes cluster.

1.  Open Docker Desktop.
2.  Go to Settings -> Kubernetes.
3.  Check the box that says Enable Kubernetes.
4.  Click Apply & Restart.

### Option B: Use Minikube

Minikube is a tool that runs a small, single-node Kubernetes cluster on your computer.

1.  Install Minikube from the official documentation if you haven't already.
2.  Start the cluster by running the below mentioned command in the terminal:
    ```bash
    minikube start
    ```

--------------------------------------------------------------------------------

## 2. Build the Docker Image

Now we need to package the Wisecow app into a Docker image.

  * If using Docker Desktop:
    Just run the standard build command.

    ```bash
    docker build -t wisecow:latest .
    ```

  * If using Minikube:
    We would need to build the image inside Minikube's own Docker environment.

    ```bash
    #Connecting the terminal to Minikube's Docker
    & minikube -p minikube docker-env --shell powershell | Invoke-Expression

    # Now build the image
    docker build -t wisecow:latest .
    ```

--------------------------------------------------------------------------------

## 3. Deploy Wisecow to Kubernetes

With the image built, we can now tell Kubernetes to run it. The `k8s/` folder contains all the instruction files (manifests) for Kubernetes.

Run the following commands to apply all the configurations:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/tls-secret.yaml
kubectl apply -f k8s/ingress.yaml
```

To check if it's working, we can see if the pods (where the app runs) are up:

```bash
kubectl get pods
```

-----

## 4. Accessing the Application

Once the pods are running, below are the steps mentioned following which we can see the Wisecow app in our browser.

  * If using Docker Desktop:
    Use `port-forward` to connect the local machine's port `4499` directly to the app's port inside the cluster.

    ```bash
    kubectl port-forward service/wisecow-service 4499:4499
    ```

    Then, open the browser and go to http://localhost:4499

  * If using Minikube:
    Minikube can give a direct URL to the service.

    ```bash
    minikube service wisecow-service
    ```

    This command will automatically open the correct URL in the browser.

-----

## Project Files Overview

  * wisecow.sh: The simple shell script that acts as the web server.
  * Dockerfile: Instructions to build the container image.
  * k8s/: A folder containing all the Kubernetes configuration files.
  * .github/workflows/: Contains the GitHub Actions workflow for CI/CD.

