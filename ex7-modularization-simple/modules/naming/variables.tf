variable "resource_type" {
    type = string
    validation {
      condition = contains([
                            "resource_group", 
                            "virtual_network"
                          ], 
                          var.resource_type)

      error_message = "Provided resource type is not supported (please implement)."
    }
}

variable "resource_location" {
  type = string
  validation {
    condition = contains([
                          "polandcentral"
                        ], 
                        var.resource_location)
    error_message = "Not supported location."
  }
}

variable "resource_area" {
  type = string
}

variable "resource_index" {
    type = number
    validation {
        condition = var.resource_index >= 0 && var.resource_index <= 999
        error_message = "Resource index must be between 0 and 999."
    }
}