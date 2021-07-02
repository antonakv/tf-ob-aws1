# tf-ob-aws1

This manual is dedicated to create Amazon AWS resources using terraform.

On AWS create EC2 instance with Public IP on it add security group for ssh, ICMP (ping) and http/https 
create fqdn dns entry on domain (use one available on r53, no need to buy one) get a valid ssl cert for 
dns entry configure a nginx web test certificate works - on a desktop browser padlock closes.

## Requirements

- Hashicorp terraform recent version installed
[Terraform installation manual](https://learn.hashicorp.com/tutorials/terraform/install-cli)

- git installed
[Git installation manual](https://git-scm.com/download/mac)

- Amazon AWS account credentials saved in .aws/credentials file
[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

## Preparation 
- Clone git repository. 

```bash
git clone https://github.com/antonakv/tf-ob-aws1.git
```

Expected command output looks like this:

```bash
Cloning into 'tf-ob-aws2'...
remote: Enumerating objects: 12, done.
remote: Counting objects: 100% (12/12), done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 12 (delta 1), reused 3 (delta 0), pack-reused 0
Receiving objects: 100% (12/12), done.
Resolving deltas: 100% (1/1), done.
```

- Change folder to tf-ob-aws1

```bash
cd tf-ob-aws1
```

- Create file terraform.tfvars with following contents

```
key_name      = "PUT_YOUR_EXISTING_KEYNAME_HERE"
ami           = "ami-05f7491af5eef733a" # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type
instance_type = "t2.medium"
region        = "eu-central-1"
cidr_vpc      = "10.5.0.0/16"
cidr_subnet1  = "10.5.1.0/24"
cidr_subnet2  = "10.5.2.0/24"
```

## Run terraform code

- In the same folder you were before run init


```bash
terraform init
```

Sample result

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.42.0...
- Installed hashicorp/aws v3.42.0 (self-signed, key ID 34365D9472D7468F)

Partner and community providers are signed by their developers.
If you d like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

- In the same folder you were before run terraform apply

```bash
terraform apply
```

Sample command output

```bash
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_acm_certificate.aws1 will be created
  + resource "aws_acm_certificate" "aws1" {
      + arn                       = (known after apply)
      + domain_name               = "tfe3.anton.hashicorp-success.com"
      + domain_validation_options = [
          + {
              + domain_name           = "tfe3.anton.hashicorp-success.com"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
        ]
      + id                        = (known after apply)
      + status                    = (known after apply)
      + subject_alternative_names = (known after apply)
      + tags_all                  = (known after apply)
      + validation_emails         = (known after apply)
      + validation_method         = "DNS"
    }

  # aws_acm_certificate_validation.aws1 will be created
  + resource "aws_acm_certificate_validation" "aws1" {
      + certificate_arn = (known after apply)
      + id              = (known after apply)
    }

  # aws_instance.aws1 will be created
  + resource "aws_instance" "aws1" {
      + ami                                  = "ami-05f7491af5eef733a"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = true
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.medium"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = "aakulov"
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "aakulov-aws1"
        }
      + tags_all                             = {
          + "Name" = "aakulov-aws1"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "230f79e9db1f97b0bd4ae119fb47563c11397500"
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

 [ SOME LINES ARE REMOVED ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.vpc: Creating...
aws_acm_certificate.aws1: Creating...
aws_acm_certificate.aws1: Creation complete after 6s [id=arn:aws:acm:eu-central-1:267023797923:certificate/bc96f9fd-07a4-431d-aaed-243eacbdc0b2]
aws_acm_certificate_validation.aws1: Creating...
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Creating...
aws_vpc.vpc: Still creating... [10s elapsed]
aws_vpc.vpc: Creation complete after 12s [id=vpc-07a24ad2e888d0866]
aws_internet_gateway.igw: Creating...
aws_subnet.subnet1: Creating...
aws_subnet.subnet2: Creating...
aws_lb_target_group.aakulov-aws1: Creating...
aws_security_group.aakulov-aws1: Creating...
aws_subnet.subnet2: Creation complete after 1s [id=subnet-0fd6375887bc5bdcb]
aws_subnet.subnet1: Creation complete after 1s [id=subnet-05495d444fe15f8e0]
aws_internet_gateway.igw: Creation complete after 1s [id=igw-01d1d0289d0d09529]
aws_route_table.aws1-1: Creating...
aws_route_table.aws1-2: Creating...
aws_lb_target_group.aakulov-aws1: Creation complete after 1s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:targetgroup/aakulov-aws1/1d7b310c4d20229c]
aws_route_table.aws1-2: Creation complete after 1s [id=rtb-07b175480903347c9]
aws_route_table_association.subnet2: Creating...
aws_route_table.aws1-1: Creation complete after 1s [id=rtb-0699df1ad5760091a]
aws_route_table_association.subnet1: Creating...
aws_route_table_association.subnet2: Creation complete after 0s [id=rtbassoc-0a436b205cf8ec4aa]
aws_route_table_association.subnet1: Creation complete after 0s [id=rtbassoc-01044321e170ad496]
aws_security_group.aakulov-aws1: Creation complete after 2s [id=sg-0ce353352fc17749f]
aws_lb.aws1: Creating...
aws_instance.aws1: Creating...
aws_acm_certificate_validation.aws1: Still creating... [10s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [10s elapsed]
aws_lb.aws1: Still creating... [10s elapsed]
aws_instance.aws1: Still creating... [10s elapsed]
aws_acm_certificate_validation.aws1: Still creating... [20s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [20s elapsed]
aws_instance.aws1: Still creating... [20s elapsed]
aws_lb.aws1: Still creating... [20s elapsed]
aws_acm_certificate_validation.aws1: Creation complete after 28s [id=2021-07-02 12:32:34 +0000 UTC]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [30s elapsed]
aws_lb.aws1: Still creating... [30s elapsed]
aws_instance.aws1: Still creating... [30s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Still creating... [40s elapsed]
aws_instance.aws1: Still creating... [40s elapsed]
aws_lb.aws1: Still creating... [40s elapsed]
aws_route53_record.cert_validation["tfe3.anton.hashicorp-success.com"]: Creation complete after 50s [id=Z077919913NMEBCGB4WS0__f706da4cad7adeb580f9da519a94d5b8.tfe3.anton.hashicorp-success.com._CNAME]
aws_instance.aws1: Creation complete after 43s [id=i-0a53e658c04fc3b94]
aws_lb_target_group_attachment.aakulov-aws1: Creating...
aws_lb_target_group_attachment.aakulov-aws1: Creation complete after 0s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:targetgroup/aakulov-aws1/1d7b310c4d20229c-20210702123305801500000002]
aws_lb.aws1: Still creating... [50s elapsed]
aws_lb.aws1: Still creating... [1m0s elapsed]
aws_lb.aws1: Still creating... [1m10s elapsed]
aws_lb.aws1: Still creating... [1m20s elapsed]
aws_lb.aws1: Still creating... [1m30s elapsed]
aws_lb.aws1: Still creating... [1m40s elapsed]
aws_lb.aws1: Still creating... [1m50s elapsed]
aws_lb.aws1: Still creating... [2m0s elapsed]
aws_lb.aws1: Creation complete after 2m3s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:loadbalancer/app/aakulov-aws1/bad3e5463e8e6200]
aws_route53_record.aws1: Creating...
aws_lb_listener.aws1: Creating...
aws_lb_listener.aws1: Creation complete after 1s [id=arn:aws:elasticloadbalancing:eu-central-1:267023797923:listener/app/aakulov-aws1/bad3e5463e8e6200/45d95c2e6dfb8c77]
aws_route53_record.aws1: Still creating... [10s elapsed]
aws_route53_record.aws1: Still creating... [20s elapsed]
aws_route53_record.aws1: Still creating... [30s elapsed]
aws_route53_record.aws1: Still creating... [40s elapsed]
aws_route53_record.aws1: Still creating... [50s elapsed]
aws_route53_record.aws1: Still creating... [1m0s elapsed]
aws_route53_record.aws1: Creation complete after 1m1s [id=Z077919913NMEBCGB4WS0_tfe3.anton.hashicorp-success.com_CNAME]

Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

aws_url = "tfe3.anton.hashicorp-success.com"
```

