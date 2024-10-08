provider "github" {
  token = var.github_token
  owner = var.my_github_organization
}

resource "github_repository" "new_repos" {
  count        = length(local.repo_names)
  name         = local.repo_names[count.index]
  visibility   = "private"  # Adjust as needed
  description  = "Repository created via Terraform. This repository is used for automated and consistent creation of repositories."
  auto_init    = true
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "my_github_organization" {
  description = "GitHub Organization Name"
  type        = string
}

variable "emails" {
  description = "List of email addresses to derive repository names"
  type        = list(string)
}

variable "repo_count_per_email" {
  description = "Number of repositories to create per email"
  type        = number
  default     = 1
}

locals {
  # Use the current timestamp directly without formatting
  current_timestamp = timestamp()
  
  # Extract the date part from the timestamp in a default format
  formatted_date = substr(local.current_timestamp, 0, 10)  # Example: 2024-08-12
  
  # Create repository names based on the email addresses and current date
  repo_names = flatten([
    for email in var.emails : [
      for i in range(var.repo_count_per_email) : "Test_${split("@", email)[0]}_${local.formatted_date}"
    ]
  ])
}

output "current_timestamp" {
  value = local.current_timestamp
}

output "formatted_date" {
  value = local.formatted_date
}

output "repo_names" {
  value = local.repo_names
}
