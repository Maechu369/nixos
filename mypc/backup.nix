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
    preHook = ''
      mount /dev/data/backup /mnt/backup || true
    '';
    postHook = ''
      umount /mnt/backup || true
    '';
  };
}
