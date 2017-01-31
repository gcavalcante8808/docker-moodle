#!/bin/sh

set -e

run_moodle() {
    CONF=/var/www/html/config.php

    if [ -z ${DB_HOST} ]; then
        echo "No Default DB Host Provided. Assuming 'db'"
        DB_HOST="db"
    fi

    if [ -z ${DB_PORT} ]; then
        echo "No Default port for Db Provided. Assuming 5432."
        DB_PORT=5432
    fi

    if [ -z ${DB_USER} ]; then
        echo "No Default User provided for Db. Assuming moodle"
        DB_USER="moodle"
    fi

    if [ -z ${DB_PASS} ]; then
        echo "No Default DB Password provided. Assuming moodle"
        DB_PASS="moodle"
    fi

    if [ -z ${DB_NAME} ]; then
        echo "No default db name provided. Assuming moodle"
        DB_NAME="moodle"
    fi

    if [ -z ${VIRTUAL_HOST} ]; then
        echo "You dont have provided a virtual host config which is needed. Exiting ..."
        exit 1
    fi

    if [ -z ${MOODLE_VERSION} ]; then
        echo "No Moodle version provided. Assuming 3.1 ..."
        MOODLE_VERSION=31
    fi
    
    if [ -z ${VIRTUAL_PROTO} ]; then
    	echo "No protocol provided. Assuming http"
    	VIRTUAL_PROTO=http
    fi	

    if [ ! -e $CONF ]; then

        if [ -z ${ADMIN_PASSWORD} ]; then
            echo "No admin password provided ... Creating one ..."
            ADMIN_PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`
            echo "ADMIN PASSWORD: $ADMIN_PASSWORD"
        fi

        echo "Downloading Moodle..."
        git clone --depth 1 --branch MOODLE_${MOODLE_VERSION}_STABLE https://github.com/moodle/moodle.git .

        touch $CONF

	cat <<-EOF >> $CONF
		<?php
		unset(\$CFG);
		global \$CFG;
		\$CFG = new stdClass();
		\$CFG->dbtype = "pgsql";
		\$CFG->dblibrary = "native";
		\$CFG->dbhost = "$DB_HOST";
		\$CFG->dbname = "$DB_NAME";
		\$CFG->dbuser = "$DB_USER";
		\$CFG->dbpass = "$DB_PASS";
		\$CFG->prefix = 'mdl_';
		\$CFG->dboptions = array(
			'dbpersist' => false,
			'dbsocket' => false,
			'dbport' => "$DB_PORT",
		);

		\$CFG->wwwroot = "$VIRTUAL_PROTO://$VIRTUAL_HOST";
		\$CFG->dataroot = '/var/www/moodledata';
		\$CFG->admin = 'admin';
		\$CFG->directorypermissions = 0777;
		require_once(dirname(__FILE__) . '/lib/setup.php');
	EOF

    chmod -R 777 /var/www/moodledata
    echo "Moodle Configuration file created. Starting DB Migrations."
    php admin/cli/install_database.php --agree-license --lang=pt_BR --adminemail=ti@raleduc.com.br --adminpass=$ADMIN_PASSWORD
    echo "Database Migrated. Check the frontend to finish the installation proccess."

    fi
    
    exec apache2-foreground "$@"
}

maintenance_on() {
    php /var/www/html/admin/cli/maintenance.php --enable
    echo "Maintenance is ON"
}

maintenance_off() {
    php /var/www/html/admin/cli/maintenance.php --disable
    echo "Maintenance is OFF"
}

run_cron() {
    php /var/www/html/admin/cli/cron.php
    echo "Running Cron"
}

update_moodle(){
    cd /var/www/html
    git config --global user.email "root@local.host"
    git config --global user.name "gcavalcante8808"
    maintenance_on
    echo "Starting the Update"
    git stash --include-untracked
    git pull
    git stash pop
    echo "Updates Applied."
    maintenance_off
}

case "$@" in 
    run)
        run_moodle
        ;;
    maintenance_on)
        maintenance_on
        ;;
    maintenance_off)
        maintenance_off
        ;;
    update)
        update_moodle
        ;;
    *)
        echo "Usage: $0 {run,maintenance_on, maintenance_off, run_cron, update}"
        exit 1
        ;;
esac

