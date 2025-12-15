variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
  default     = "legacy-tf"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "southeastasia"
}

variable "admin_username" {
  description = "VM admin username."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for the VM."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {
    owner = "terraform-tech-refresh-test"
    env   = "dev"
  }
}
