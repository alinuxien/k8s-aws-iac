output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "webserver1_ip" {
  value = aws_instance.webserver1.private_ip
}

output "webserver2_ip" {
  value = aws_instance.webserver2.private_ip
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "cloud_front_dns_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "rds_address" {
  value = aws_db_instance.database.address
}

output "memcached_address" {
  value = aws_elasticache_cluster.cache.cluster_address
}

output "memcached_configuration_endpoint" {
  value = aws_elasticache_cluster.cache.configuration_endpoint
}

output "kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}

output "ssh_tunneling_command" {
  value = format("ssh -v -N %s@%s -J %s@%s -L 1443:%s:443 &", var.webservers-user, aws_instance.webserver1.private_ip, var.bastion-user, aws_instance.bastion.public_ip, aws_elasticsearch_domain.es.endpoint)
}

resource "local_file" "AnsibleInventory" {
  content = templatefile("../ansible/inventory.tmpl", {
    bastion-dns      = aws_instance.bastion.private_dns,
    bastion-ip       = aws_instance.bastion.public_ip,
    bastion-id       = aws_instance.bastion.id,
    bastion-user     = var.bastion-user,
    webserver1-dns   = aws_instance.webserver1.private_dns,
    webserver1-ip    = aws_instance.webserver1.private_ip,
    webserver1-id    = aws_instance.webserver1.id
    webserver2-dns   = aws_instance.webserver2.private_dns,
    webserver2-ip    = aws_instance.webserver2.private_ip,
    webserver2-id    = aws_instance.webserver2.id,
    webservers-user  = var.webservers-user,
    logstash1-dns    = aws_instance.logstash1.private_dns,
    logstash1-ip     = aws_instance.logstash1.private_ip,
    logstash1-id     = aws_instance.logstash1.id
    logstash2-dns    = aws_instance.logstash2.private_dns,
    logstash2-ip     = aws_instance.logstash2.private_ip,
    logstash2-id     = aws_instance.logstash2.id,
    private_key_file = var.private_key_file
  })
  filename = "../ansible/inventory"
}

resource "local_file" "AnsibleWPCLIConfig" {
  content = templatefile("../ansible/roles/wordpress/tasks/config.yml.tmpl", {
    db_server           = aws_db_instance.database.address,
    db_name             = var.database-name,
    db_user             = var.database-username,
    db_pass             = var.database-password,
    webserver_path      = var.webserver-homepage-path,
    final_url           = format("https://%s", var.domain)
    website_title       = var.website_title,
    website_admin       = var.website_admin,
    website_admin_pass  = var.website_admin_pass,
    website_admin_email = var.website_admin_email,
    memchached_server   = aws_elasticache_cluster.cache.configuration_endpoint
  })
  filename = "../ansible/roles/wordpress/tasks/config.yml"
}

resource "local_file" "MetricBeatConfig" {
  content = templatefile("../ansible/roles/metricbeat/tasks/metricbeat.tmpl", {
    kibana_endpoint        = format("https://%s:443/_plugin/kibana", aws_elasticsearch_domain.es.endpoint)
    elasticsearch_endpoint = format("https://%s:443", aws_elasticsearch_domain.es.endpoint)
  })
  filename = "../ansible/roles/metricbeat/tasks/metricbeat.yml"
}

resource "local_file" "FileBeatConfig" {
  content = templatefile("../ansible/roles/filebeat/tasks/filebeat.tmpl", {
    kibana_endpoint    = format("https://%s:443/_plugin/kibana", aws_elasticsearch_domain.es.endpoint)
    logstash1_endpoint = format("%s:5044", aws_instance.logstash1.private_ip)
    logstash2_endpoint = format("%s:5044", aws_instance.logstash2.private_ip)
  })
  filename = "../ansible/roles/filebeat/tasks/filebeat.yml"
}

resource "local_file" "LogStashPipeline" {
  content = templatefile("../ansible/roles/logstash/tasks/01-mllec.tmpl", {
    elasticsearch_endpoint = format("https://%s:443", aws_elasticsearch_domain.es.endpoint)
  })
  filename = "../ansible/roles/logstash/tasks/01-mllec.conf"
}


