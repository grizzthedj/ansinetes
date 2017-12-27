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
git clone https://github.com/grizzthedj/ansinetes
```

## Configuration

The IP addresses for the kubernetes master and minions need to be configured in 2 places. 

1. The hosts file(in the root of this project)
2. In the `group_vars/lab` file.   

NOTE: Additional lines will need to be added in both places in the case where more that 2 minions need to be deployed.

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

To access the Kubernetes Dashboard from your local workstation, the playbook creates a secure channel to your Kubernetes cluster via `kubectl proxy`.

The Dashboard can be accessed at:

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

To login as a `kube-admin` user, use the token from the ansible playbook output as shown in the screenshot below:

![alt text](https://github.com/grizzthedj/ansinetes/blob/master/docs/login-token.png)


