---
layout: post
title: Terraform will damage your Computer
date: 2023-05-15 17:59:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - terraform
  - macos
tags:
  - terraform
  - macos
---
Today I experienced the following error on my Intel MacBook Pro when attempting to run [Terraform](https://www.terraform.io/)...

![MacOS Terraform will damage your computer ](assets/2023/05/macos-terraform-damage-computer.png)

The equivalent English error message is "Terraform will damage your computer. You should move it to the Trash.". Hashicorp have cycled their keys used to sign their packages/executables. You can read more about that at the link below. I resolved it by simply removing the old terraform binary and replacing it with a newer version...

```bash
which terraform
sudo rm /usr/local/bin/terraform
wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_darwin_amd64.zip
unzip terraform_1.4.6_darwin_amd64.zip
sudo mv terraform /usr/local/bin
terraform version
```

* Further useful links

** [HashiCorp Response to CircleCI](https://support.hashicorp.com/hc/en-us/articles/13177506317203)
** [Stack Overflow - Terraform will damage your Computer](https://stackoverflow.com/questions/76129509/terraform-will-damage-your-computer-on-macos-intel)
** [Terraform will damage your Computer](https://www.storagetutorials.com/solved-terraform-will-damage-your-computer/)