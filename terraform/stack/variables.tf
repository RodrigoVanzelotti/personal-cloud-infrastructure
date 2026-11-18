variable "solution" {
  type = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.solution))
    error_message = "Use a solution directory name."
  }
}

variable "adoption_mode" {
  description = "Allow reviewed manual infrastructure adoption while automatic releases remain disabled."
  type        = bool
  default     = false
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["stage", "prod"], var.environment)
    error_message = "Environment must be stage or prod."
  }
}
