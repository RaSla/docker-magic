#!/bin/sh

docker compose exec ocserv ocserv -t \
&& echo "Test config - PASS" \
&& docker compose kill ocserv -s HUP \
&& echo "The OCserv config was reloaded"
