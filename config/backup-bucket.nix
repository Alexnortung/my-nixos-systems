{ inputs, config, ... }:
{
  services.s3fs-fuse = {
    enable = true;
    mounts = {
      backup-1 = {
        mountPoint = "/mnt/backup-1";
        bucket = "backup-1";
        options = [
          "passwd_file=${config.age.secrets.backup-1-credentials.path}"
          "use_path_request_style"
          "allow_other"
          "url=https://ams1.vultrobjects.com"
        ];
      };
    };
  };
}
