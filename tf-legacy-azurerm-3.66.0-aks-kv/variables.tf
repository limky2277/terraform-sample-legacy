variable "name_prefix" {
  description = "Prefix for all resource names."
  type        = string
  default     = "legacy-aks-kv"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "southeastasia"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {
    owner = "terraform-tech-refresh-test"
    env   = "dev"
  }
}

variable "sp_client_id" {
  description = "Service principal client ID (appId) for AKS (legacy pattern)."
  type        = string
}

variable "sp_client_secret" {
  description = "Service principal client secret for AKS (legacy pattern)."
  type        = string
  sensitive   = true
}
