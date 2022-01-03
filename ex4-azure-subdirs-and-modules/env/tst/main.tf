module "resx-group" {  
    source = "./../../module1" 
    
    resx_prefix = var.resx_prefix
    resx_group  = var.resx_group
}