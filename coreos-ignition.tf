# create a systemd service for pulling ide image
data "ignition_systemd_unit" "ide" {
  name = "ide.service"
  enabled = true
  content = <<EOM
[Unit]
Description=Fetch Integrated Development Envrionment image
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c '/usr/bin/docker pull ${var.ide_image}'

[Install]
WantedBy=multi-user.target
EOM
}

# create an ide launcher
data "ignition_file" "run_ide" {
  filesystem = "root"
  path = "/opt/bin/ide"
  mode = "0755"
  content {
    content = <<EOM
#!/bin/bash

# run ide container
docker run --rm --name ide -ti ${var.ide_image} bash
EOM
  }
}

data "ignition_config" "coreos" {
  files = [
    "${data.ignition_file.run_ide.id}",
  ]
  systemd = [
    "${data.ignition_systemd_unit.ide.id}",
  ]
}
