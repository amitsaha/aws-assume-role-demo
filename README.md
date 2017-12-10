Terraform:

```
$ cd terraform_config
$ terraform init
.. 
```

```
$ ls.terraform/plugins/darwin_amd64/
lock.json                         terraform-provider-aws_v1.5.0_x4
$ file .terraform/plugins/darwin_amd64/terraform-
provider-aws_v1.5.0_x4
.terraform/plugins/darwin_amd64/terraform-provider-aws_v1.5.0_x4: Mach-O 64-bit executable x86_64
```

This will download the `aws` provider. 

Setup the AWS configuration/profile.

```
$ terraform plan
```

```
$ terraform graph
digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
                "[root] aws_iam_instance_profile.iam_profile1" [label = "aws_iam_instance_profile.iam_profile1", shape = "box"]
                "[root] aws_iam_instance_profile.iam_profile2" [label = "aws_iam_instance_profile.iam_profile2", shape = "box"]
                "[root] aws_iam_role.role1" [label = "aws_iam_role.role1", shape = "box"]
                "[root] aws_iam_role.role2" [label = "aws_iam_role.role2", shape = "box"]
                "[root] aws_s3_bucket.bucket" [label = "aws_s3_bucket.bucket", shape = "box"]
                "[root] provider.aws" [label = "provider.aws", shape = "diamond"]
                "[root] aws_iam_instance_profile.iam_profile1" -> "[root] aws_iam_role.role1"
                "[root] aws_iam_instance_profile.iam_profile2" -> "[root] aws_iam_role.role2"
                "[root] aws_iam_role.role1" -> "[root] provider.aws"
                "[root] aws_iam_role.role2" -> "[root] provider.aws"
                "[root] aws_s3_bucket.bucket" -> "[root] local.bucket_names"
                "[root] aws_s3_bucket.bucket" -> "[root] provider.aws"
                "[root] meta.count-boundary (count boundary fixup)" -> "[root] aws_iam_instance_profile.iam_profile1"
                "[root] meta.count-boundary (count boundary fixup)" -> "[root] aws_iam_instance_profile.iam_profile2"
                "[root] meta.count-boundary (count boundary fixup)" -> "[root] aws_s3_bucket.bucket"
                "[root] provider.aws (close)" -> "[root] aws_iam_instance_profile.iam_profile1"
                "[root] provider.aws (close)" -> "[root] aws_iam_instance_profile.iam_profile2"
                "[root] provider.aws (close)" -> "[root] aws_s3_bucket.bucket"
                "[root] root" -> "[root] meta.count-boundary (count boundary fixup)"
                "[root] root" -> "[root] provider.aws (close)"
        }
}
```



**Get Amazon Linux ami id**

From https://aws.amazon.com/amazon-linux-ami/
ami-3248a350

**Create Key Pair by importing an existing key**

```
$ aws ec2 import-key-pair --key-name dev-key --public-key-material <pub key>

$ AWS_PROFILE=dev aws ec2 describe-key-pairs
{
    "KeyPairs": [
        {
            "KeyFingerprint": "ae:00:15:4c:fc:90:89:9d:b3:76:88:33:8c:8d:1e:e3",
            "KeyName": "dev-key"
        }
    ]
}

```

