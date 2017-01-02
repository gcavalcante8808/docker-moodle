Moodle Docker Image
-------------------

This is a gcavalcante8808/moodle docker image based on official php7.0-apache image.

Simple Usage
------------

The fastest way to test this image is to use git and docker-compose to run all necessary pieces:

```
    cd /tmp
    git clone github.com/gcavalcante8808/docker-moodle.git
    cd docker-moodle
    docker-compose up -d
```

It will setUp an postgres database and a moodle container that will download and install the latest version of the software, which can be accessed on http://localhost.

**The moodle admin password will be created automatically; check the logs and write down this password.**

Usage
-----

You need to install and setup an postgres database before the use of the moodle container. After that, you'll need to provide the following information (through ENVIRONMENT variables):

 * DB_HOST: Address of Database Host;
 * DB_PORT: Port of Postgres Installation (5432 per default if not provided);
 * DB_USER: Name of database user (will try to use 'moodle' if not provided);
 * DB_PASS: Password of the user (will try to use 'moodle' if not provided);
 * DB_NAME: Database Name (will try to use 'moodle' if not provided):
 * VIRTUAL_HOST: wwwroot of moodle, must match with the server access fqdn (otherwise the moodle will try to redirect you to the configured url);
 * **MOODLE_VERSION**: Moodle Version that will be installed (only numbers, no dots), if not provided assumes version 31 which corresponds to the version 3.1;

Author
------

Author: Gabriel Abdalla Cavalcante Silva (gabriel.cavalcante88@gmail.com)
