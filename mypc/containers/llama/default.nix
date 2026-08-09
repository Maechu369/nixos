{ ... }:
{
  containers."llama" = {
    autoStart = true;
    privateNetwork = true;
    privateUsers = "pick";
    hostAddress = "192.168.64.1";
    localAddress = "192.168.64.2";
    config = ./llama.nix;
    bindMounts = {
      "/var/lib/llama/models" = {
        hostPath = "/var/lib/llama/models";
        isReadOnly = true;
      };
    };
    bindMounts = {
      "/run/opengl-driver" = {
        hostPath = "/run/opengl-driver";
        isReadOnly = true;
      };
      "/run/opengl-driver-32" = {
        hostPath = "/run/opengl-driver-32";
        isReadOnly = true;
      };
      "/dev/nvidia0" = {
        hostPath = "/dev/nvidia0";
      };
      "/dev/nvidiactl" = {
        hostPath = "/dev/nvidiactl";
      };
      "/dev/nvidia-modeset" = {
        hostPath = "/dev/nvidia-modeset";
      };
      "/dev/nvidia-uvm" = {
        hostPath = "/dev/nvidia-uvm";
      };
      "/dev/nvidia-uvm-tools" = {
        hostPath = "/dev/nvidia-uvm-tools";
      };
    };
    allowedDevices = [
      {
        modifier = "rw";
        node = "/dev/nvidia0";
      }
      {
        modifier = "rw";
        node = "/dev/nvidiactl";
      }
      {
        modifier = "rw";
        node = "/dev/nvidia-modeset";
      }
      {
        modifier = "rw";
        node = "/dev/nvidia-uvm";
      }
      {
        modifier = "rw";
        node = "/dev/nvidia-uvm-tools";
      }
    ];
  };
  services.nginx.virtualHosts."llama.home.arpa" = {
    forceSSL = true;
    useACMEHost = "llama.home.arpa";
    locations."/" = {
      proxyPass = "http://192.168.64.2:8080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        allow 100.64.0.0/10;
        allow 192.168.2.3/32;
        deny all;
      '';
    };
    listen = [
      {
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }
    ];
  };
  security.acme.certs."llama.home.arpa" = {
    server = "https://step-ca.home.arpa:9000/acme/acme/directory";
    webroot = "/var/lib/acme/acme-challenge";
    group = "nginx";
  };
}
