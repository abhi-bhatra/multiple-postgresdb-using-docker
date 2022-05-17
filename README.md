# Multiple PostgreSql Databases in a single Docker container

> We will be creating multiple databases when docker starts PostgreSQL. In this repository, we contain a script to create multiple database.
---

### Working with Docker image

##### Building a custom image

Build and push the image to your Docker repository:

`docker build -t abhinav332/multiplepostgres dbsetup/ .`

`docker push abhinav332/multiplepostgres`

##### Browsing Files

We put the script into `./dbsetup/postgres-script` Directory, so that the container can be created automatically when it is started. 

##### Run the Docker file

```
docker run -itd \
    --name abhinav332/multiplepostgres \
    -e POSTGRES_MULTIPLE_DATABASES=db1,db2 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -p 5432:5432 \
    abhinav332/multiplepostgresql:latest
```
---

### Creating a Stateful set of our custom PostgreSQL image

##### Creating Postgres Statefulset

StatefulSet is a Kubernetes workload API object that can be used to manage stateful applications. StatefulSets are ideal for database deployments. In this example, we will create a PostgreSQL deployment as a StatefulSet with a persistent storage volume.

We will run `kubectl apply -f ps-statefulset.yaml`

##### Creating Postgres PVC

We want to create permanent file storage for your database data. This is because the Docker instance does not persist any information when the container no longer exists. In this configuration, we instructed it to reserve 4GB of read-write storage at /mnt/data on the cluster’s node.

We will run `kubectl apply -f ps-pvc.yaml`

##### Creating Postgres Service

We can also create a service to expose the PostgreSQL server. We have several options to do so, like configuring a different port or exposing the NodePort or LoadBalancer. For the sake of simplicity, we will exposes the service on the Node's IP at a port `5432`.

We will run `kubectl apply -f ps-svc.yaml`

##### Creating Postgres Secret

We are storing the postgres secret which is a `username` and a `password` of our postgres database.

We will run `kubectl apply -f ps-svc.yaml`