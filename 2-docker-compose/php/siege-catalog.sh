#!/bin/sh

#siege -f urls-app.txt -i -c10 -t30s
siege -i -c10 -t30s http://127.0.0.1:8080/catalog.php
