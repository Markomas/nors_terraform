output "blue-app-lv-ip" {
  value = module.nors-lv-app-blue.ip
}

output "green-app-lv-ip" {
  value = module.nors-lv-app-green.ip
}

output "db-lv-ip" {
  value = module.nors-lv-db.ip
}

output "load-balancer-ip" {
  value = module.nors-load-balancer.ip
}