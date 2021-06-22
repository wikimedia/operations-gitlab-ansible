# Upgrading GitLab

WMF GitLab is installed via debian package named `gitlab-ce`. This is called an `Omnibus` setup.

The GitLab upgrade documentation is [here](https://docs.gitlab.com/ee/update/).

Specific Omnibus upgrade documentation is [here](https://docs.gitlab.com/omnibus/update/).

To make a successfull GitLab upgrade:

- make yourself familiar with [GitLab release and maintenance policy](https://docs.gitlab.com/ee/policy/maintenance.html)
- select exact GitLab version to upgrade to and find if it's a major, minor or patch upgrade
- read release notes of all versions between current and selected one
- determine if this is an upgrade with or without downtime
- if you are going to do an upgrade without downtime, determine the proper upgrade path, possibly consisting of several steps
- never upgrade over two major versions in a single step, that will (with great probability) lead to a broken installation
- determine if any manual migrations are required in your upgrade; built-in PostgreSQL database server or monitoring subsystem data upgrade may be required between major versions
- configuration changes and other manual intervention may be required in future upgrades, please check the official documentation
- first make an upgrade to the planned version on the test installation vm and proceed only if it is successfull
- plan production upgrade (on low load hours) and downtime (if required)
- make both full GitLab data and full configuration data backups before upgrading
- to reduce your upgrade time, it is possible to skip automatic (database only) backup during upgrade using `sudo touch /etc/gitlab/skip-auto-backup`; only do this if you have made full backup on the previous step
- run `apt-get update` before downloading any new packages
- preload to-be-installed GitLab CE packages before upgrading (using `apt-get install --download-only`)
- if you have GitLab Runners connected to your GitLab Server, it is recommended to pause all runners and wait until all jobs are finished before starting the upgrade
- in sequence, run each upgrade and required migrations on the upgrade path; check that all background migrations are fully finished and background migration queue is empty before starting each step
- make sure that GitLab Server is up and running after upgrade; please give it several minutes to calm down
- run basic smoke tests (make sure that web UI works, authentication works, ssh cloning works)
- re-enable paused runners (if required)

How to check for remaining background migrations (prints the current size of the background_migration queue):
```
gitlab-rails runner -e production 'puts Gitlab::BackgroundMigration.remaining'
```

Recommended upgrade cadence:

- patch upgrades: ASAP
- minor upgrades (issued monthly): every 3 months
- major upgrades (issued annually): once per year, when needed
