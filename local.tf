locals {
  # Tags configuration
  tags = {
    "Name"                      = var.name
    "Technical:ApplicationName"  = "Web"
    "Technical:ApplicationSubName" = "Host"
    "Technical:Environment"      = "NONPROD"
    "Technical:ApplicationID"    = "APP"
    "Technical:PlatformOwner"    = "CXDevOps"
  }
}
