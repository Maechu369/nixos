{ username, ... }: {
  security = {
    auditd.enable = true;
    audit = {
      enable = true;
      rules = [
        "-D" # 前のルールを全て消す
        "-b 16384" # バックログ
        "-f 1"

        # ノイズ除外
        "-a never,exit -F arch=b64 -S all -F exe=/usr/bin/firefox -F key=noise"

        # 認証
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/sudoers -p wa -k sudoers"
        "-w /etc/sudoers.d -p wa -k sudoers"
        "-w /etc/pam.d -p wa -k pam"

        # 永続化検知
        "-w /etc/systemd/system/ -p wa -k persist_systemd"
        "-w /etc/cron.d/ -p wa -k persist_cron"
        "-w /etc/ld.so.preload -p wa -k persist_ld"
        "-a always,exclude -F msgtype=SERVICE_START"
        "-a always,exclude -F msgtype=SERVICE_STOP"

        # カーネル
        "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k modules"
        "-a always,exit -F arch=b64 -S kexec_load -k kexec"

        # 時刻
        "-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time"

        # 権限昇格
        "-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -k root_exec"

        # 怪しい実行
        "-w /tmp -p x -k exec_tmp"
        "-w /dev/shm -p x -k exec_tmp"

        # mount
        "-a always,exit -F arch=b64 -S mount,umount2 -F auid>=1000 -F auid!=-1 -k mount"

        # 機密ファイル
        "-w /home/${username}/.ssh -p wra -k ssh_keys"
        "-w /home/${username}/.gnupg -p wa -k gnupg"
      ];
    };
  };
}
