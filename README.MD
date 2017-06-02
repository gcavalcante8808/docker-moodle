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
 * **MOODLE_VERSION**: Moodle Version that will be installed (only numbers, no dots), if not provided assumes version 32 which corresponds to the version 3.2;
 * MOODLE_PLUGINS: If set (to any value) will download essential theme and grid course format (in the future will download more plugins by default).

Common Operations
-----------------

Some operations supported by the cli are now wrapped into the entrypoint. You can use them with the following commands:

```
    docker exec -it <server_container> /entrypoint maintenance_on #To Enable Maintenance
    docker exec -it <server_container> /entrypoint mainteance_off #To Disable Maitenance
    docker exec -it <server_container> /entrypoint run_cron #To Run Moodle's Cron Job
    docker exec -it <server_container> /entrypoint update #To update the moodle to the latest version of branch. 3.0.2 will be update to 3.0.8 for example.
```

** At this time there is no support for version upgrades, just simple updates. **


Author
------

Author: Gabriel Abdalla Cavalcante Silva (gabriel.cavalcante88@gmail.com)
