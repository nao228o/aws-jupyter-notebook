#! /bin/bash

apply () {
    cd vpc
    terraform init
    terraform apply --auto-approve
    cd ../subnet
    terraform init
    terraform apply --auto-approve
    cd ../ec2
    terraform init
    terraform apply --auto-approve
}

destroy () {
    cd ec2
    terraform destroy --auto-approve
    cd ../subnet
    terraform destroy --auto-approve
    cd ../vpc
    terraform destroy --auto-approve
}

case $1 in
    apply)
        apply
        ;;
    destroy)
        destroy
        ;;
esac

