# Restore backed up GitLab

GitLab Backup and Restore documentation is [here](https://docs.gitlab.com/ee/raketasks/backup_restore.html).

Make yourself familiar with [Restore Prerequisites](https://docs.gitlab.com/ee/raketasks/backup_restore.html#restore-prerequisites).

To restore a backup, you need data and configuration backup archives and working (possibly clean) GitLab installation. 

* Select backup archives (data and configuration) to restore and copy them to the target host; use data and configuration archives with corresponding datacodes
* Confirm that there is enough free space on GitLab installation mountpoint on the target host
* Make sure GitLab package (`gitlab-ce`) is properly installed on the target host and installed version is same as was used to create data and configuration archives;
  use version code from the name of the data archive to verify this
* Restore GitLab configuration fi;e into `/etc/gitlab/gitlab.rb` from the configuration backup archive
* Restore GitLab secrets file into `/etc/gitlab/gitlab-secrets.json` from the configuration backup archive
* Run `sudo gitlab-ctl reconfigure` to make sure GitLab installation is set up and PostgreSQL database is initialized;
  make sure GitLab configuration was done successfully
* Make sure GitLab is running with `sudo gitlab-ctl status`;
  if not, start it with `sudo gitlab-ctl start`
* Make sure the GitLab backup path, configured in `gitlab_rails['backup_path']` setting in `/etc/gitlab/gitlab.rb` exists,
  owned by `git:root` and has `rwx------` (`0700`) permissions;
  the default backup path is `/var/opt/gitlab/backups`
* Place your data backup archive (tar file) into the GitLab backup path;
  make sure it's owned by `git:git` and has `rw-------` (`0600`) permissions.
* Before restoring, disallow users' access to the GitLab:
* If you have GitLab Runners connected to your running GitLab Server, pause all runners and wait until all jobs are finished before starting the restore
* Stop GitLab's dedicated ssh server: `sudo systemctl stop ssh-gitlab`;
  check with `sudo systemctl status ssh-gitlab`
* Stop database-connected GitLab processes: `sudo gitlab-ctl stop puma` and `sudo gitlab-ctl stop sidekiq`;
  check with `sudo gitlab-ctl status`
* DO NOT stop other GitLab processes, they are required for restoring
* Restore GitLab data by running `sudo gitlab-backup restore BACKUP=timestamp_of_backup`;
  it's possible (but not recommended) to disable restore confirmations by using `sudo GITLAB_ASSUME_YES=1 gitlab-backup restore BACKUP=timestamp_of_backup`;
  `timestamp_of_backup` is the datecode from data backup archive name, example: `1624925137_2021_06_29_13.11.5`
* Reconfigure GitLab: `sudo gitlab-ctl reconfigure`
* Restart GitLab services: `sudo gitlab-ctl restart`;
  check with `sudo gitlab-ctl status`
* Run GitLab check rake task: `sudo gitlab-rake gitlab:check SANITIZE=true`;
  make sure all checks are fine
* Check GitLab can decrypt secrets: `sudo gitlab-rake gitlab:doctor:secrets`;
  make sure check is fine, if not, check that `/etc/gitlab/gitlab-secrets.json` was restored correctly
* Restore GitLab's dedicated ssh server: `sudo systemctl restart ssh-gitlab`
* run basic smoke tests (make sure that web UI works, authentication works, ssh cloning works)
* re-enable paused runners (if required)
