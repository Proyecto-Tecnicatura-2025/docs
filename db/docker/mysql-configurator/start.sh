#!/bin/bash
IFS=':' read -ra USERS_ARRAY <<< "$MYSQL_USERS"

for user in "${USERS_ARRAY[@]}"; do
    var_name="MYSQL_${user^^}_PASSWORD"
    password="${!var_name}"
    var_name="MYSQL_${user^^}_HOST"
    host="${!var_name}"

    query="ALTER USER '$user'@'%' IDENTIFIED BY '$password';
            RENAME USER '$user'@'%' TO '$user'@'$host';"

    mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" --skip-ssl -D ${MYSQL_DATABASE} -H ${MYSQL_HOST} -B -e "$query" || true
done

query="FLUSH PRIVILEGES;"
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" --skip-ssl -D ${MYSQL_DATABASE} -H ${MYSQL_HOST} -B -e "$query" 
