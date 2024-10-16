variable "name" {
    type = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance."
  type        = string
  default     = "<AMI_ID>"  # SYSCOGOLD-TEAMMANAGED-WIN2019-2024.09.10
}

variable "instance_type" {
  description = "Instance type for the EC2 instance."
  type        = string
  default     = "r6i.4xlarge"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance."
  type        = bool
  default     = false
}

variable "monitoring" {
  description = "Enable or disable detailed monitoring for the instance."
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "Security group IDs to associate with the instance."
  type        = list(string)
  default     = ["<SG_GROUP>"]
}

variable "subnet_id" {
  description = "The subnet ID in which to launch the instance."
  type        = string
  default     = "<SUBNET_ID>"
}

variable "key_name" {
  description = "Key pair name to use for SSH access to the instance."
  type        = string
  default     = "Application-CDE-SS-CX-BastionHost-NonProd-2022"
}

variable "iam_instance_profile" {
  description = "IAM instance profile to attach to the instance."
  type        = string
  default     = "<IAM_ROLE>"
}

variable "root_block_volume_size" {
  description = "Size of the root block device in GiB"
  type        = number
  default     = 100
}

variable "ebs_block_device_sdd_size" {
  description = "Size of the EBS block device for /dev/sdd in GiB"
  type        = number
  default     = 50
}

variable "ebs_block_device_sde_size" {
  description = "Size of the EBS block device for /dev/sde in GiB"
  type        = number
  default     = 50
}

variable "ebs_block_device_sdf_size" {
  description = "Size of the EBS block device for /dev/sdf in GiB"
  type        = number
  default     = 50
}

variable "create_ebs_block_device_sdd" {
  description = "Whether to create the EBS block device for /dev/sdd"
  type        = bool
  default     = false
}

variable "create_ebs_block_device_sde" {
  description = "Whether to create the EBS block device for /dev/sde"
  type        = bool
  default     = false
}

variable "create_ebs_block_device_sdf" {
  description = "Whether to create the EBS block device for /dev/sdf"
  type        = bool
  default     = false
}