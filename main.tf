terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.7.4"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://10.100.129.17:8006/api2/json"

  pm_api_token_id = "sinan@pve!sinantoken

  pm_api_token_secret = "31e060e3-ae3d-464c-b500-13271ed59590"

  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k8s-masters" {
  count = 1
  name = "k8s-masters-${count.index+1}"

  target_node = var.proxmox_host

  clone = var.template_name

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "hosts"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "local-lvm"
    iothread = "
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.100.129.100/24,gw=10.100.129.1"

  sshkeys = <<EOF
  ${vars.ssh_key}
  EOF

  connection {
    type = "ssh"
    user = "root"
    private_key = "~/.ssh/id_rsa"
    host = "${self.public_ip}"
  }

  provisioner "file" {
    source = "inline_script.sh"
    destination = "/tmp/inline_script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/inline_script.sh",
      "/tmp/inline_script.sh"
    ]
  }
}

resource "proxmox_vm_qemu" "k8s-slaves" {
  count = 2
  name = "k8s-slaves-${count.index+1}"

  target_node = var.proxmox_host

  clone = var.template_name

  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "hosts"
  memory = 4096
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot = 0
    size = "20G"
    type = "scsi"
    storage = "local-lvm"
    iothread = "
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=10.100.129.10${count.index+1}/24,gw=10.100.129.1"

  sshkeys = <<EOF
  ${vars.ssh_key}
  EOF

  connection {
    type = "ssh"
    user = "root"
    private_key = "~/.ssh/id_rsa"
    host = "${self.public_ip}"
  }

  provisioner "file" {
    source = "inline_script.sh"
    destination = "/tmp/inline_script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/inline_script.sh",
      "/tmp/inline_script.sh"
    ]
  }
}
