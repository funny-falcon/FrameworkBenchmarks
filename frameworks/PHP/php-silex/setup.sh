#!/bin/bash

sed -i 's|localhost|'"${DBHOST}"'|g' web/index.php
sed -i 's|".*\FrameworkBenchmarks/php-silex|"'"${TROOT}"'|g' deploy/php-silex
sed -i 's|Directory .*/FrameworkBenchmarks/php-silex|Directory '"${TROOT}"'|g' deploy/php-silex
sed -i 's|root .*/FrameworkBenchmarks/php-silex|root '"${TROOT}"'|g' deploy/nginx.conf
sed -i 's|/usr/local/nginx/|'"${IROOT}"'/nginx/|g' deploy/nginx.conf

PHP_HOME=${IROOT}/php-5.5.17

export PATH="$COMPOSER_HOME:$PHP_HOME/bin:$PHP_HOME/sbin:$PATH"

${PHP_HOME}/bin/php ${IROOT}/composer.phar install --optimize-autoloader
$PHP_FPM --fpm-config $FWROOT/config/php-fpm.conf -g $TROOT/deploy/php-fpm.pid
$NGINX_HOME/sbin/nginx -c $TROOT/deploy/nginx.conf
