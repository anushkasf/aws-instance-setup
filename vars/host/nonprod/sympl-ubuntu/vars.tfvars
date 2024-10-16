name                    = "sympl-ubuntu-instance-01"
ami                     = "<AMI_ID>"
instance_type           = "m5.2xlarge"
associate_public_ip_address = false
monitoring              = true
vpc_security_group_ids  = [ "<SG_GROUP>" ]
subnet_id               = "<SUBNET_ID>"
key_name                = "<KEY_PAIR>"
iam_instance_profile    = "<IAM_ROLE>"

root_block_volume_size  = 80

create_ebs_block_device_sdd = false
create_ebs_block_device_sde = false
create_ebs_block_device_sdf = false