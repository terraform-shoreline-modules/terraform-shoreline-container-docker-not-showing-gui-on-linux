resource "shoreline_notebook" "gui_not_displaying_in_docker_container_on_linux" {
  name       = "gui_not_displaying_in_docker_container_on_linux"
  data       = file("${path.module}/data/gui_not_displaying_in_docker_container_on_linux.json")
  depends_on = [shoreline_action.invoke_validate_docker_dependencies,shoreline_action.invoke_docker_x11_mount]
}

resource "shoreline_file" "validate_docker_dependencies" {
  name             = "validate_docker_dependencies"
  input_file       = "${path.module}/data/validate_docker_dependencies.sh"
  md5              = filemd5("${path.module}/data/validate_docker_dependencies.sh")
  description      = "The Docker image used to launch the containerized GUI application may be missing necessary dependencies or libraries required for the GUI to display properly."
  destination_path = "/tmp/validate_docker_dependencies.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "docker_x11_mount" {
  name             = "docker_x11_mount"
  input_file       = "${path.module}/data/docker_x11_mount.sh"
  md5              = filemd5("${path.module}/data/docker_x11_mount.sh")
  description      = "Verify that the Docker container has access to the display server, either by setting the DISPLAY environment variable or by mounting the X11 socket file."
  destination_path = "/tmp/docker_x11_mount.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_validate_docker_dependencies" {
  name        = "invoke_validate_docker_dependencies"
  description = "The Docker image used to launch the containerized GUI application may be missing necessary dependencies or libraries required for the GUI to display properly."
  command     = "`chmod +x /tmp/validate_docker_dependencies.sh && /tmp/validate_docker_dependencies.sh`"
  params      = ["IMAGE_NAME","APPLICATION_NAME"]
  file_deps   = ["validate_docker_dependencies"]
  enabled     = true
  depends_on  = [shoreline_file.validate_docker_dependencies]
}

resource "shoreline_action" "invoke_docker_x11_mount" {
  name        = "invoke_docker_x11_mount"
  description = "Verify that the Docker container has access to the display server, either by setting the DISPLAY environment variable or by mounting the X11 socket file."
  command     = "`chmod +x /tmp/docker_x11_mount.sh && /tmp/docker_x11_mount.sh`"
  params      = []
  file_deps   = ["docker_x11_mount"]
  enabled     = true
  depends_on  = [shoreline_file.docker_x11_mount]
}

