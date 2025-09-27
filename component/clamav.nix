{ pkgs, ... }: {
  services.clamav = {
    package = pkgs.clamav;
    daemon.enable = true;
    updater.enable = true;
  };
  systemd.timers."clamav-fullscan" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "monthly";
      Persistent = true;
      Unit = "clamav-fullscan.service";
      RandomizedDelaySec = 3600;
    };
  };
  systemd.services."clamav-fullscan" = {
    enable = true;
    wants = [ "clamav-daemon.service" ];
    after = [ "clamav-daemon.service" ];
    script = ''
      set -euo pipefail
      mkdir -p /var/log/clamav
      chown clamav:clamav /var/log/clamav
      ${pkgs.clamav}/bin/clamdscan -m --fdpass --log=/var/log/clamav/scan.log --exclude-dir="/sys" --exclude-dir="/proc" --exclude-dir="/dev" --exclude-dir="/run" --exclude-dir="/tmp" --exclude-dir="/nix/store" --exclude-dir="/nix/var" --infected --recursive /
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      StandardOutput = "journal";
      StandardError = "journal";
      CPUQuota = "50%";
      MemoryMax = "4G";
    };
  };
}
