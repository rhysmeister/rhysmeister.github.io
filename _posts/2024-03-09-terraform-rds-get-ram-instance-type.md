---
layout: post
title: Get RDS Instance Type RAM in Terraform
date: 2024-03-09 19:54:00.000000000 +01:00
type: post
published: true
status: publish
categories:
  - terraform
  - rds
tags:
  - terraform
  - rds
---
For a monitoring project I'm currently working on I need to get the amount of RAM an [RDS](https://aws.amazon.com/rds/) Instance has. Unfortunately the [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) resource doesn't expose this type of information to us. Terraform does however give us an [external datasource](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) that we can take advantage of to provide the data.

First we need to write a wrapper script around an [aws ec2](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/index.html) command. We use the [describe-instance-types](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/describe-instance-types.html) sub-command to get the amount of RAM an instance has. This instance type information, as far as I know, is still relevant to RDS Instance, so it's safe to use for this purpose. I'm also using the [jq](https://github.com/jqlang/jq) command on the final line to return the data in a form Terraform can handle...

```bash
#!/bin/bash

set -e

trap 'echo "Failed describing instance type $instance_type exit code $?"' ERR

eval "$(jq -r '@sh "INSTANCE_TYPE=\(.instance_type)"')"

MB=$(aws ec2 describe-instance-types --instance-type "$INSTANCE_TYPE" --query "InstanceTypes[0].MemoryInfo.SizeInMiB")

jq -n --arg mb "$MB" '{"MB":$mb}'
```

The next important thing is to wrap this script up into a data resource using the external provider...

```terraform
data "external" "rds" {
  program = ["bash", "${path.module}/bash/rds-ram-mb.sh"]

  query = {
    instance_type = join(".", [split(".", aws_db_instance.rds1.instance_class)[1], split(".", aws_db_instance.rds1.instance_class)[2]])
  }

  depends_on = [aws_db_instance.rds1]
}
````

We're setting the instance_type variable using a few Terraform functions. Basically this turns `db.t3.micro` into `t3.micro`. This is the format that the aws cli tool in the wrapper script requires. Also note the use of `depends_on` as the RDS Instance needs to exist before the datasource is run.

With all that in place we can then reference the RAM value like so...

```terraform
output "instance_ram" {
  value = data.external.rds.result.MB
}
```

There's a working demo over at [github/rhysmeister](https://github.com/rhysmeister/aws-rds-external-data-source-demo)

After performing a `terraform apply` you'll see the output variable is set to the instance type's RAM in MB. In this case the RDS instance is a db.t3.micro and it has 1024MB of RAM.

![Terraform RDS Instance RAM Output](assets/2024/03/terraform-rds-ram-output.png)