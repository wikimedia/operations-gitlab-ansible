# WMF GitLab Service provisioning

## Facts to know about GitLab Server

* GitLab is a versatile DevOps platform, delivered as a single application
* GitLab documentation can be found at https://docs.gitlab.com/
* GitLab platform contains many software components running as well-tightened software combine
* GitLab platform includes other preconfigured software, such as Git, Nginx, PostgreSQL, Redis, Puma, OmniAuth, Prometheus, Grafana, Python, Ruby, Rsync, GnuPG and more
* GitLab data version management is based on git and uses it extensively
* GitLab main part is written in Ruby on Rails
* GitLab platform uses integrated chef configuration management component to configure itself
* GitLab platform is installed with single Linux distro package named `gitlab-ce` (ce stands for Community Edition, also there is an Enterprise Edition); this all-in-one-package installation is called *Omnibus*
* GitLab provides platform services via http[s] (web ui, api) and ssh (git over ssh); so, a host running GitLab (usually) publicly serves on tcp ports **80**, **443** and **22**

GitLab Server paths:

* GitLab platform installation is in `/opt/gitlab`
* GitLab platform configuration is in `/etc/gitlab/gitlab.rb`
* GitLab secrets are in `/etc/gitlab/gitlab-secrets.json`
* GitLab stores data in `/var/opt/gitlab`
* GitLab stores data backups in `/var/opt/gitlab/backups`
* GitLab stores platform configuration and secrets backups in `/etc/gitlab/config_backup`
* GitLab stores logs in `/var/log/gitlab`
* `gitlab.rb` defines configuration for platform itself only, user-level configuration is stored in integrated database
* GitLab uses external smtp server to deliver emails (configured in `gitlab.rb`)
* GitLab uses OmniAuth framework to integrate external user authentication providers; documentation can be found at https://docs.gitlab.com/ee/integration/omniauth.html

GitLab Server control:

* GitLab platform can be controlled with gitlab-ctl CLI command. Most often used operands are `status`, `start`, `stop`, `reconfigure`, `restart`, `backup-etc`
* There is also a command to delete all data and start from scratch (*use with great caution!*): `gitlab-ctl cleanse`
* GitLab backup (and restore!) can be made with `gitlab-backup` CLI command

## Facts to know about GitLab Runners

* GitLab Runner is an application that works with GitLab CI/CD to run jobs in a pipeline
* GitLab Runner documentation can be found at https://docs.gitlab.com/runner/
* GitLab Runners are (usually) installed in a host separated from main GitLab server installation
* GitLab Runner communicates with GitLab server via http[s] (connection is from Runner to Server)
* GitLab Runner is authenticated in GitLab Server with Runner Registration Token that can be found in main GitLab Web UI
* One GitLab Server may have multiple Runners connected

## Automated GitLab Server installation

* GitLab (as a platform) is installed and configured with provided Ansible playbook which can be found on S&F's GitLab (`git clone git@gitlab.gluzdov.com:wmf_gitlab/ansible.git`)
* Hosts to deploy GitLab Servers need to be configured in `[gitlab_servers]` section of 'hosts' file (it's an Ansible inventory configuration file)
* Ansible playbook parameters are set up on host-by-host basis in `host_vars/<hostname>` YAML files
* List of available playbook parameters can be found in `gitlab_server/defaults/main.yml` file
* Before running Ansible playbook it needs checking the ability of ssh-ing the target hosts and have sudo permissions there
* To run Ansible playbook just execute `install-gitlab-server.sh` script

## Automated GitLab Runner installation

* GitLab Runner is installed and configured with provided Ansible playbook which can be found on S&F's GitLab (`git clone git@gitlab.gluzdov.com:wmf_gitlab/ansible.git`)
* Hosts to deploy GitLab Runners need to be configured in `[gitlab_runners]` section of 'hosts' file (it's an Ansible inventory configuration file)
* Ansible playbook parameters are set up on host-by-host basis in `host_vars/<hostname>` YAML files
* List of available playbook parameters can be found in `gitlab_runner/defaults/main.yml` file
* Before running Ansible playbook it needs checking the ability of ssh-ing the target hosts and have sudo permissions there
* To run Ansible playbook just execute `install-gitlab-runner.sh` script

## GitLab Server backup

* GitLab Server ansible deploy automatically configures periodic backup runs by installing crontab into `/etc/cron.d/gitlab` file
* Periodic backup runs are initiated by cron daemon from root user
* GitLab Server backup consists of two parts: 1) data backup and 2) configuration and secrets backup
* GitLab data backups by default go to `/var/opt/gitlab/backup`
* GitLab configuration and secrets backup go to `/etc/gitlab/config_backup`
* Valid secrets backup is required to adequately restore the data backup, including encrypted information for two-factor authentication and the CI/CD secure variables
* It is recommended to store data backup and secrets backup separately for securiry reasons
* GitLab Server peiodically removes old backup data. Keep time is configured in `gitlab_backup_keep_time` playbook variable
* GitLab Backup and Restore documentation can be found at https://docs.gitlab.com/omnibus/settings/backups.html
* GitLab Restore for Omnibus installations documentation can be found at https://docs.gitlab.com/ee/raketasks/backup_restore.html#restore-for-omnibus-gitlab-installations

## Further documentation can be found [here](https://docs.google.com/document/d/1JM-hR9GMxHt1OgTRgGjn5O6F8hv5svciiCiWPHOz72g/edit?usp=sharing)
