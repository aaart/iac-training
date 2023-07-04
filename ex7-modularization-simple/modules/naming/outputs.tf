output "name" {
    value = "${var.resource_type_map[var.resource_type]}aaart${var.resource_area}${var.resource_location_map[var.resource_location]}${format("%03d", var.resource_index)}"
}

output "location" {
    value = var.resource_location
}