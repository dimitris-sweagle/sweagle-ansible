Put here all packages files if you want to use force_local_install = true

Create a folder for these components to put their packages

- jdk: you should have jdk package in gz format
  - since 3.10, script executor will rely on GraalVM jdk (jdk1.8 v19.2 or higher)
  - other components still rely on JDK 1.8 (for openJDK taken from https://adoptopenjdk.net/releases.html)

- <OS family> = Debian
      - all Debian family (Ubuntu, ...) DEB packages

- <OS family> = RedHat
      - all Red Hat Family (Rhel, CentOS, Fedora) RPM packages

- <OS family>/: in root folder of the OS family, you should have
      - unzip (required to install vault and SWEAGLE)
      - epel (optional, for Red Hat OS family to install jq)
      - jq (required to load data in SWEAGLE )
      - policycoreutils-python (for Red Hat OS family to manage SELinux)
      - telnet (optional)
      - screen (optional)

- <OS family>/elasticsearch
      - elasticsearch-6.6.1

- <OS family>/mongodb: you should have at least these packages
      - /prereqs/* (all packages required for list below)
      - mongodb-org-server
      - mongodb-org-shell
      - policycoreutils-python-2.5-33.el7.x86_64
      - python-pymongo

- <OS family>/mysql: you should have (in this order)
      - /prereqs/net-tools-2.0-0.20150915git.4.mga6.x86_64
      - 1-mysql-community-common-5.7.25-1.el7.x86_64
      - 2-mysql-community-libs-5.7.25-1.el7.x86_64
      - mysql-community-client-5.7.25-1.el7.x86_64
      - mysql-community-libs-compat-5.7.25-1.el7.x86_64
      - mysql-community-server-5.7.25-1.el7.x86_64
      - MySQL-python-1.2.5-1.el7.x86_64

- <OS family>/nginx
      - nginx-1.14.2-1.el7_4.ngx.x86_64

- sweagle: you should have
      /full_{{YOUR VERSION}}.zip
      /upgrade-{{YOUR VERSION}}.zip (if you just want to upgrade an existing installation)
      /sweagle.key (to enable SSL, this is your private key file)
      /sweagle.pem (to enable SSL, this is your public certificate key)
      /sweagleExpert/exporters with cloning of https://github.com/sweagleExpert/exporters.git
      /sweagleExpert/mditypes with cloning of https://github.com/sweagleExpert/mditypes.git
      /sweagleExpert/nodetypes with cloning of https://github.com/sweagleExpert/nodetypes.git
      /sweagleExpert/templates with cloning of https://github.com/sweagleExpert/templates.git
      /sweagleExpert/validators with cloning of https://github.com/sweagleExpert/validators.git

- vault
      - vault_0.7.2_linux_386.zip

(For 3.13 and upward)
- mysql-jdbc: you should have
      /mysql-connector-java-8.0.13.tar.gz downloaded from https://downloads.mysql.com/archives/c-j/
