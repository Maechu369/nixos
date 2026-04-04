{ username, ... }:
{
  services.borgbackup.jobs."home" = {
    paths = [ "/home" ];
    exclude = [ "/home/${username}/.local/share/Steam" ];
    repo = "/mnt/backup/borg-home";
    encryption.mode = "none";
    compression = "zstd,3";
    startAt = "daily";
    prune.keep = {
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
    persistentTimer = true;
  };
  systemd.services."borgbackup-job-home" = {
    requires = [ "mnt-backup.mount" ];
    after = [ "mnt-backup.mount" ];
    serviceConfig = {
      ExecStopPost = "systemctl stop --no-block mnt-backup.mount";
    };
  };
  systemd.mounts = [
    {
      what = "/dev/data/backup";
      where = "/mnt/backup";
      type = "ext4";
      options = "defaults";
      wantedBy = [ ];
    }
  ];
  systemd.automounts = [
    {
      where = "/mnt/backup";
      wantedBy = [ ];
    }
  ];
}
