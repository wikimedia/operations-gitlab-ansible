#### GitLab Server installation

* Before running the script, check the ssh connectivity to the target server and ability to `sudo` on the System
* Specify the target hostname to deploy the GitLab Server in `[gitlab_servers]` section of 'hosts' file
* Set the parameters/variables in `host_vars/<gitlab_server_type>` YAML file (e.g. Paths, Ports, Auth Method, etc)
* Run `install-gitlab-server.sh` Bash script. It will execute the `install-gitlab-server.yml` playbook which installs the GitLab Server

#### Manual settings to be changed in the GitLab UI after installation

* Public sign up to disable
* Set the URL for redirection after logging out
* Set the custom hostname for private commit emails
* Set the Sign-in restrictions - Password authentication enabled for web interface and Password authentication enabled for Git over HTTP(S)
* Set the After sign-out path to https://idp.wmcloud.org/logout
* Disable the display controlling of third party offers
* Check if default initial branch name is `main`
* Disable allowing users to register any application to use GitLab as an OAuth provider
* Restrict use of the DSA keys