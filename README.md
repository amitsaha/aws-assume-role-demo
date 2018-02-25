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

HVM EBS based for t2.micro: ami-ff4ea59d

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

**Create default VPC**

http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/default-vpc.html

```
[ec2-user@ip-172-31-6-239 ~]$ aws s3 ls s3://github-amitsaha-bucket/*

An error occurred (AccessDenied) when calling the ListObjects operation: Access Denied
[ec2-user@ip-172-31-6-239 ~]$ aws s3 ls s3://github-amitsaha-bucket/

An error occurred (AccessDenied) when calling the ListObjects operation: Access Denied
[ec2-user@ip-172-31-6-239 ~]$ aws sts assume-role --role-arn arn:aws:iam::033145145979:role/test_profile2_role --role-session-name s3-example

An error occurred (AccessDenied) when calling the AssumeRole operation: User: arn:aws:sts::033145145979:assumed-role/test_profile1_role/i-0b3f9c44566fbc260 is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::033145145979:role/test_profile2_role

[ec2-user@ip-172-31-6-239 ~]$ aws sts assume-role --role-arn arn:aws:iam::033145145979:role/test_profile2_role --role-session-name s3-example
{
    "AssumedRoleUser": {
        "AssumedRoleId": "AROAJ3CMHLQFMYPPWQLSQ:s3-example", 
        "Arn": "arn:aws:sts::033145145979:assumed-role/test_profile2_role/s3-example"
    }, 
    "Credentials": {
        "SecretAccessKey": "PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo", 
        "SessionToken": "FQoDYXdzEI7//////////wEaDDqRJAWz11tovnatwSLuAUf1CIjLW0OI5dTCAh610HW7f3fBxglofbntqxCSJVyei1DafEjriLIskDzKoCdz6Y7F5Z/uyv/Ue7dCCCvXFpVYExwt82hE7yTGrYJB/oQl+bkMIzPhlHyegDa3/+vxdFu2kbcve8a1VlNhZE8fnpaRLGMoEr9/Ll+NQLjtRyysQ7DuN0GuMVIDiUzqOZHVDFDt4/c5LBHd2VZNfZ2t/rfPTkIwfkI9JQUVON+lcrk5W+FH16Onp1vuZXX4cmraMWQ1ROGf2x4fHGPIcMqaw674sgOnMSllyCUONLIaSPOeJLfOSDIrM/Xfv0PvslgotNrK1AU=", 
        "Expiration": "2018-02-25T13:33:56Z", 
        "AccessKeyId": "ASIAI7JVCNUGFT6XGMAQ"
    }
}
[ec2-user@ip-172-31-6-239 ~]$ date
Sun Feb 25 12:34:03 UTC 2018
[ec2-user@ip-172-31-6-239 ~]$ aws s3 ls s3://github-amitsaha-bucket/

An error occurred (AccessDenied) when calling the ListObjects operation: Access Denied
[ec2-user@ip-172-31-6-239 ~]$ AWS_ACCESS_KEY_ID=ASIAI7JVCNUGFT6XGMAQ AWS_SECRET_ACCESS_KEY=PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo aws s3 ls s3://github-amitsaha-bucket/

An error occurred (InvalidAccessKeyId) when calling the ListObjects operation: The AWS Access Key Id you provided does not exist in our records.
[ec2-user@ip-172-31-6-239 ~]$ AWS_ACCESS_KEY_ID=ASIAI7JVCNUGFT6XGMAQ AWS_SECRET_ACCESS_KEY=PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo aws s3 ls s3://github-amitsaha-bucket/

An error occurred (InvalidAccessKeyId) when calling the ListObjects operation: The AWS Access Key Id you provided does not exist in our records.
[ec2-user@ip-172-31-6-239 ~]$ AWS_SESSION_TOKEN="FQoDYXdzEI7//////////wEaDDqRJAWz11tovnatwSLuAUf1CIjLW0OI5dTCAh610HW7f3fBxglofbntqxCSJVyei1DafEjriLIskDzKoCdz6Y7F5Z/uyv/Ue7dCCCvXFpVYExwt82hE7yTGrYJB/oQl+bkMIzPhlHyegDa3/+vxdFu2kbcve8a1VlNhZE8fnpaRLGMoEr9/Ll+NQLjtRyysQ7DuN0GuMVIDiUzqOZHVDFDt4/c5LBHd2VZNfZ2t/rfPTkIwfkI9JQUVON+lcrk5W+FH16Onp1vuZXX4cmraMWQ1ROGf2x4fHGPIcMqaw674sgOnMSllyCUONLIaSPOeJLfOSDIrM/Xfv0PvslgotNrK1AU=" AWS_ACCESS_KEY_ID=ASIAI7JVCNUGFT6XGMAQ AWS_SECRET_ACCESS_KEY=PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo aws s3 ls s3://github-amitsaha-bucket/
[ec2-user@ip-172-31-6-239 ~]$ vim hello
[ec2-user@ip-172-31-6-239 ~]$ AWS_SESSION_TOKEN="FQoDYXdzEI7//////////wEaDDqRJAWz11tovnatwSLuAUf1CIjLW0OI5dTCAh610HW7f3fBxglofbntqxCSJVyei1DafEjriLIskDzKoCdz6Y7F5Z/uyv/Ue7dCCCvXFpVYExwt82hE7yTGrYJB/oQl+bkMIzPhlHyegDa3/+vxdFu2kbcve8a1VlNhZE8fnpaRLGMoEr9/Ll+NQLjtRyysQ7DuN0GuMVIDiUzqOZHVDFDt4/c5LBHd2VZNfZ2t/rfPTkIwfkI9JQUVON+lcrk5W+FH16Onp1vuZXX4cmraMWQ1ROGf2x4fHGPIcMqaw674sgOnMSllyCUONLIaSPOeJLfOSDIrM/Xfv0PvslgotNrK1AU=" AWS_ACCESS_KEY_ID=ASIAI7JVCNUGFT6XGMAQ AWS_SECRET_ACCESS_KEY=PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo aws s3 cp hello  s3://github-amitsaha-bucket/
upload: ./hello to s3://github-amitsaha-bucket/hello             
[ec2-user@ip-172-31-6-239 ~]$ AWS_SESSION_TOKEN="FQoDYXdzEI7//////////wEaDDqRJAWz11tovnatwSLuAUf1CIjLW0OI5dTCAh610HW7f3fBxglofbntqxCSJVyei1DafEjriLIskDzKoCdz6Y7F5Z/uyv/Ue7dCCCvXFpVYExwt82hE7yTGrYJB/oQl+bkMIzPhlHyegDa3/+vxdFu2kbcve8a1VlNhZE8fnpaRLGMoEr9/Ll+NQLjtRyysQ7DuN0GuMVIDiUzqOZHVDFDt4/c5LBHd2VZNfZ2t/rfPTkIwfkI9JQUVON+lcrk5W+FH16Onp1vuZXX4cmraMWQ1ROGf2x4fHGPIcMqaw674sgOnMSllyCUONLIaSPOeJLfOSDIrM/Xfv0PvslgotNrK1AU=" AWS_ACCESS_KEY_ID=ASIAI7JVCNUGFT6XGMAQ AWS_SECRET_ACCESS_KEY=PzFA0bJxxeB+i4kWjowpM6VTQTQfIiejbRxXkZdo aws s3 ls s3://github-amitsaha-bucket/
2018-02-25 12:38:32         12 hello
[ec2-user@ip-172-31-6-239 ~]$ 

```

