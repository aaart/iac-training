variable "resx_prefix" {
  type = string
}

variable "resx_group" {
    type = object({
        name      = string
        location  = string
    })
}
