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



variable "cloudflare_api_token" {



  type        = string



  description = "Cloudflare API Token for DNS-01 challenges"



  sensitive   = true



}







variable "acme_email" {

  type        = string

  description = "Email address for Let's Encrypt"

}



variable "apps_domain" {



  type        = string



  description = "The base domain for applications"



}







variable "cloudflare_tunnel_token" {







  type        = string







  description = "Cloudflare Tunnel Token"







  sensitive   = true







}















variable "beszel_agent_key" {















  type        = string















  description = "Beszel Agent Public Key (from Hub)"















  sensitive   = true















  default     = ""















}































variable "beszel_agent_token" {















  type        = string















  description = "Beszel Agent Token (for push mode)"















  sensitive   = true















  default     = ""















}































variable "repository_url" {































  type        = string



  description = "The Git repository URL"



  default     = "https://github.com/fabricesemti80/project-dockerstack-mk2.git"



}







variable "repository_branch" {



  type        = string



  description = "The Git branch to use"



  default     = "refs/heads/main"



}




