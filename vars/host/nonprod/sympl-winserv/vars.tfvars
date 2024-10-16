name                    = "sympl-winserv2019-instance-01"
ami                     = "<AMI_ID>"
instance_type           = "r6i.4xlarge"
associate_public_ip_address = false
monitoring              = true
vpc_security_group_ids  = [ "<SG_GROUP>" ]
subnet_id               = "<SUBNET_ID>"
key_name                = "<KEY_PAIR>"
iam_instance_profile    = "<IAM_ROLE>"

root_block_volume_size  = 275

create_ebs_block_device_sdd = true
ebs_block_device_sdd_size   = 560

create_ebs_block_device_sde = true
ebs_block_device_sde_size   = 250

create_ebs_block_device_sdf = true
ebs_block_device_sdf_size   = 100