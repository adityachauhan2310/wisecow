# Wisecow Kubernetes Project

This project shows how to take a simple web app called "Wisecow," put it into a Docker container, and run it on a local Minikube Kubernetes cluster with a secure HTTPS connection. The app itself just shows a random quote from a cow.

## What will be required (Prerequisites)

  * **Docker**
  * **Minikube**
  * **`kubectl`** (the command-line tool to talk to Kubernetes)

-----

## 1. Starting the Minikube Cluster

First, get the local Kubernetes cluster up and running.

```bash
minikube start
```

-----

## 2. Enable the Ingress Controller

Next, we need to enable the Ingress addon, which manages web traffic coming into the cluster.

```bash
minikube addons enable ingress
```

-----

## 3. Build the Docker Image

Now, we'll package the application into a Docker image. These two commands connect the terminal to Minikube's internal Docker environment and then build the image inside it.

```bash
# 1. Connect your terminal to Minikube's Docker
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# 2. Now, build the image
docker build -t wisecow:latest .
```

-----

## 4. Deploy Wisecow to Kubernetes

With the image ready, we can deploy the application. The `k8s/` folder contains all the necessary instruction files.

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/tls-secret.yaml
kubectl apply -f k8s/ingress.yaml
```

We can check if the app is starting by running `kubectl get pods`. Wait for the status to show `Running`.

-----

## 5. Access the Application

This is the final step to connect to the app from the browser.

### Step 5a: Start the Minikube Tunnel

We need to open a "bridge" from the computer directly to the services inside Minikube.

1.  Open a **new, separate terminal window**.
2.  Run the following command. It will ask for the administrator password and then will continue running.
    ```bash
    minikube tunnel
    ```
3.  **Keep this terminal window open.** If we close it, the bridge closes, and the app will become unreachable.

### Step 5b: Edit Your Hosts File

Now, we need to tell the computer that the address `wisecow.local` points to the tunnel which we just opened.

1.  Open **Notepad** as an **Administrator**.
2.  Go to **File -> Open** and navigate to the folder `C:\Windows\System32\drivers\etc`.
3.  Change the file type dropdown from "Text Documents" to **"All Files"** and open the `hosts` file.
4.  Add this new line at the very end of the file:
    ```
    127.0.0.1   wisecow.local
    ```
5.  Save the file.

### Step 5c: Visit the Site

While the tunnel is running, open the web browser and go to:
**[https://wisecow.local](https://www.google.com/search?q=https://wisecow.local)**


You will see a browser warning like "Your connection is not private." This is normal because we are using a self-signed certificate. Click **"Advanced"** and **"Proceed to wisecow.local"** to see the application.

-----

## Project Files Overview

  * wisecow.sh: The simple shell script that acts as the web server.
  * Dockerfile: Instructions to build the container image.
  * k8s/: A folder containing all the Kubernetes configuration files.
  * .github/workflows/: Contains the GitHub Actions workflow for CI/CD.


  Testing CI CD
