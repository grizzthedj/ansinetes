# ansinetes #

A set of ansible playbooks for the provisioning and deployment of Kubernetes clusters using `kubeadm`. Works on any VM's or bare metal running CentOS 7.

## Prequisites

At least 2 VM's, or bare metal machines running CentOS 7(minimal) that have IP addresses assigned, and are accessible over SSH.

## Notes  

1. Not recommended for production use, for testing and development only
2. Only supports deployments to CentOS 7 
3. Currently only supports deploying a single master, but supports 'n' minions

## Installation 

1). Install ansible

```
brew install ansible
```

2). Clone this repo

```
git clone https://github.com/grizzthedj/ansinetes && cd ansinetes
```

## Configuration

The IP addresses for the kubernetes master and minions need to be configured in 2 places. 

1. The hosts file

Create a file called `hosts` in the root of this project, and add the following content(substituting XXX with the desired "NAT'd" IP addresses(or "Real" IP's can be used if there is connectivity from the ansible host):
```
[kubernetes-master]
172.XXX.XXX.XXX  # K8s Master

[kubernetes-minions]
172.XXX.XXX.XXX  # Minion #1
172.XXX.XXX.XXX  # Minion #2

[lab:children]
lab_kubernetes_master
lab_kubernetes_minions

[lab_kubernetes_master]
172.XXX.XXX.XXX nickname=lab-kubernetes-master branch=test

[lab_kubernetes_minions]
172.XXX.XXX.XXX nickname=lab-kubernetes-minion-1 branch=test
172.XXX.XXX.XXX nickname=lab-kubernetes-minion-2 branch=test
```

2. In the `group_vars/lab` file

Create a file called `lab` in the `group_vars` directory, and add the following content(substituting XXX with the desired "Real" IP addresses:
```
kubernetes_master_ip: 172.XXX.XXX.XXX
kubernetes_minion_1_ip: 172.XXX.XXX.XXX
kubernetes_minion_2_ip: 172.XXX.XXX.XXX

cgroup_driver: cgroupfs
cluster_dns_ip: 10.96.0.10
kubernetes_user: kuber
kubernetes_master_host: "{{kubernetes_master_ip}}    kubernetes-master"
kubernetes_minion_1_host: "{{kubernetes_minion_1_ip}}    kubernetes-minion-1"
kubernetes_minion_2_host: "{{kubernetes_minion_2_ip}}    kubernetes-minion-2"
```

NOTE: Additional lines will need to be added in both files in the case where more that 2 minions need to be deployed.

### Usage

Deploy a kubernetes cluster to `lab` environment
```
./scripts/provision/kubernetes.sh lab
```

The above script is interactive and will prompt for the following: 

1. The root password for each node upon connection(once per master/minion)
2. K8s Master token(is to be copied from the ansible output, see screenshot below)
3. CA cert hash(is to be copied from the ansible output, see screenshot below)

![alt text](https://github.com/grizzthedj/ansinetes/blob/master/docs/token-cert-hash.png)

###  Dashboard access

To access the Kubernetes Dashboard from your local workstation, the playbook creates a secure channel to your Kubernetes cluster via `kubectl proxy`. You need to setup port forwarding over SSH(to the master) using port 8001 to access the dashboard.

NOTE: This is not currently working as intended. The temporary workaround is to login to the master server as root, and run the following, after the playbook has completed: 

```
su kuber
kubectl proxy &
```

Once port forwarding is setup, the Dashboard can be accessed at:

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

To login as a `kube-admin` user, use the token from the ansible playbook output as shown in the screenshot below:

![alt text](https://github.com/grizzthedj/ansinetes/blob/master/docs/login-token.png)


