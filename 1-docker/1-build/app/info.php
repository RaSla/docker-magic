<?php

header('Content-Type: text/plain');
header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1

$dt = date(DATE_ATOM);
echo "Current DateTime: $dt\n";
echo "Current PHP-version: " . phpversion() . "\n";
