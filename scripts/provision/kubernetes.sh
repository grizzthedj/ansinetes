
# Initialize all nodes
ansible-playbook -v -i hosts --limit $1 --tags kubernetes -u root --ask-pass playbooks/provision-kubernetes-init.yml

# Set up master
ansible-playbook -vvvv -i hosts --limit $1 --tags kubernetes -u root --ask-pass playbooks/provision-kubernetes-master.yml

while [[ -z "$TOKEN" ]] ; do
  read -s -p "Enter the Kubernetes Master Token: " TOKEN && echo ""
done

while [[ -z "$CERT_HASH" ]] ; do
  read -s -p "Enter the Kubernetes Master CA Cert Hash: " CERT_HASH && echo ""
done

# Join minions to cluster
ansible-playbook -v -i hosts --limit $1 --extra-vars="token=$TOKEN cert_hash=$CERT_HASH" --tags kubernetes -u root --ask-pass playbooks/provision-kubernetes-minion.yml

# Add admin user for dashboard
ansible-playbook -vvvv -i hosts --limit $1 --tags kubernetes -u root --ask-pass playbooks/configure-kubernetes-master.yml