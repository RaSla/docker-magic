#!/bin/sh

# This runs a benchmark for 30 seconds, using 2 threads, keeping 50 HTTP connections open,
# and a constant throughput of 2000 requests per second (total, across all connections combined).
#wrk -t2 -c50 -d30s -R2000 -f urls-app.txt
wrk -t2 -c50 -d30s http://127.0.0.1:8080/catalog.php
