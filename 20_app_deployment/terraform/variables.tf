variable "portainer_url" {
  type        = string
  description = "The URL of the Portainer instance"
  default     = "https://157.180.84.140:9443"
}

variable "portainer_access_token" {
  type        = string
  description = "Portainer API Token (from Doppler)"
  sensitive   = true
}

variable "endpoint_id" {
  type        = number
  description = "The ID of the Portainer endpoint (environment)"
  default     = 1
}