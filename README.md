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
* Gitlab secrets are in `/etc/gitlab/gitlab-secrets.json`
* Gitlab stores data in `/var/opt/gitlab`
* Gitlab stores data backups in `/var/opt/gitlab/backups`
* Gitlab stores logs in `/var/log/gitlab`
* `gitlab.rb` defines configuration for platform itself only, user-level configuration is stored in integrated database
* GitLab uses external smtp server to deliver emails (configured in `gitlab.rb`)
* GitLab uses OmniAuth framework to integrate external user authentication providers; documentation can be found at https://docs.gitlab.com/ee/integration/omniauth.html

GitLab Server control:

* GitLab platform can be controlled with gitlab-ctl CLI command. Most often used opreands are `status`, `start`, `stop`, `reconfigure`, `restart`, `backup-etc`
* there is also a command to delete all data and start from scratch (*use with great caution!*): `gitlab-ctl cleanse`
* GitLab backup (and restore!) can be made with `gitlab-backup` CLI command

## Facts to know about GitLab Runners

* GitLab Runner is is an application that works with GitLab CI/CD to run jobs in a pipeline
* GitLab Runner documentation can be found at https://docs.gitlab.com/runner/
* GitLab Runners are (usually) installed in a host separated from main GitLab server installation
* GitLab Runner communicates with GitLab server via http[s] (connection is from Runner to Server)
* GitLab Runner is authenticated in GitLab Server with Runner Registration Token that can be found in main GitLab Web UI
* One GitLab Server may have multiple Runners connected

## Automated GitLab Server installation

* GitLab (as a platform) is installed and configured with provided Ansible playbook which can be found on S&F's GitLab (`git clone git@gitlab.gluzdov.com:wmf_gitlab/ansible.git`)
* Hosts to deploy GitLab Servers to need to be configured in `[gitlab_servers]` section of 'hosts' file (it's an Ansible inventory configuration file)
* Ansible playbook parameters are set up on host-by-host basis in `host_vars/<hostname>` YAML files
* List of available playbook parameters can be found in `gitlab_server/defaults/main.yml` file
* before starting Ansible playbook, you need to check that you can ssh to target hosts and have sudo permission there
* to start Ansbile playbook, run `install-gitlab-server.sh` script

## Automated GitLab Runner installation

* GitLab Runner is installed and configured with provided Ansible playbook which can be found on S&F's GotLab (`git clone git@gitlab.gluzdov.com:wmf_gitlab/ansible.git`)
* Hosts to deploy GitLab Runners to need to be configured in `[gitlab_runners]` section of 'hosts' file (it's an Ansible inventory configuration file)
* Ansible playbook parameters are set up on host-by-host basis in `host_vars/<hostname>` YAML files
* List of available playbook parameters can be found in `gitlab_runner/defaults/main.yml` file
* before starting Ansible playbook, you need to check that you can ssh to target hosts and have sudo permission there
* to start Ansbile playbook, run `install-gitlab-runner.sh` script
