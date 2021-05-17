#### GitLab Server Installation

* Before running the script, check the ssh connectivity to the target server and ability to `sudo` on the System
* Specify the target server hostname to deploy the GitLab Server in `[gitlab_servers]` section of 'hosts' file;
  It's possible to specify a short decriptive <gitlab_server_name> (like `gitlab-server-prod`) and the corresponding
  fqdn hostname in ansible_host parameter on the same line
* Set the parameters/variables in `host_vars/<gitlab_server_name>` YAML file (e.g. Paths, Ports, Auth Method, etc)
* Run `install-gitlab-server.sh` Bash script. It will execute the `install-gitlab-server.yml` playbook which installs and configures the GitLab Server

#### GitLab Runner Installation

* Before running the script, check the ssh connectivity to the target runner-server and ability to `sudo` on the System
* Specify the target runner-server hostname to deploy the GitLab Runner in `[gitlab_runners]` section of 'hosts' file;
  It's possible to specify a short decriptive <gitlab_runner_name> (like `gitlab-runner-prod`) and the corresponding
  fqdn hostname in ansible_host parameter on the same line
* Set the parameters/variables in `host_vars/<gitlab_runner_name>` YAML file (e.g. Paths, Ports, Auth Method, etc)
* Run `install-gitlab-runner.sh` Bash script. It will execute the `install-gitlab-runner.yml` playbook which installs the GitLab Runner

#### Manual Settings to Be Changed in GitLab UI After Installation

* Disable public sign up: Admin Area, Settings, General, Sign-up restrictions, Sign-up enabled: unchecked
* Set up logout redirection: Admin Area, Settings, General, Sign-in restrictions, After sign-out path: https://<IDP server>/logout,
  where <IDP server> is the base URL of the CAS server, like `idp.wmcloud.org` or `idp.wikimedia.org`
* Set up private commit emails hostname: Admin Area, Settings, Preferences, Email, Custom hostname (for private commit emails):
  <users.noreply.gitlab.domain>, where <gitlab domain> is the base URL of the GitLab server, like `gitlab.wikimedia.org`
* Set up Password authentication: Admin Area, Settings, Sign-in restrictions, Password authentication enabled for web interface: unchecked
* Set up Git over https Password authentication: Admin Area, Settings, Sign-in restrictions, Password authentication enabled for Git over HTTP(S): unchecked
* Disable third party offers: Admin Area, Settings, General, Third party offers, Do not display offers from third parties within GitLab: checked
* Default branch name: Admin Area, Settings, Repository, Default initial branch name: set to `main`
* Restrict unauthenticated requests: Admin Area, Settings, Network, User and IP Rate Limits, Enable unauthenticated request rate limit: checked
* Restrict outbound requests: Admin Area, Settings, Network, Outbound requests, Allow requests to the local network from web hooks and services: unchecked
* Restrict outbound requests: Admin Area, Settings, Network, Outbound requests, Allow requests to the local network from system hooks: unchecked
* Restrict protected paths: Admin Area, Settings, Network, Protected Paths, Enable protected paths rate limit: checked
* Accept Let's Encrypt ToS: Admin Area, Settings, Preferences, Pages, I have read and agree to the Let's Encrypt Terms of Service: checked
* Enable Prometheus metrics: Admin Area, Settings, Metrics and profiling, Metrics - Prometheus, Enable Prometheus Metrics: checked
* Disable Auto DevOps pipeline: Admin Area, Settings, CI/CD, Continuous Integration and Deployment, Default to Auto DevOps pipeline for all projects: unchecked
* Set abuse reports email: Admin Area, Settings, Reporting, Abuse reports, Abuse reports notification email: set to external abuse reports email
* Set up RSA SSH keys: Admin Area, Settings, General, Visibility and access controls, RSA SSH keys: setect `must be at least 2048 bits`
* Forbid DSA SSH keys: Admin Area, Settings, General, Visibility and access controls, DSA SSH keys: setect `are forbidden`
* Enable import from Phabricator: Admin Area, Settings, General, Visibility and access controls, Import sources: enable `Phabricator`
* Disable being OAuth provider: Admin Area, Settings, General, Account and limit, Allow users to register any application to use GitLab as an OAuth provider: `unchecked`
