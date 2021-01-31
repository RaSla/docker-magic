<?php
$redis = new Redis();

// подключаемся к серверу redis
$redis->connect(
  'redis',
  6379
);

// авторизуемся. пароль мы задали в файле `.env`
//$redis->auth($_ENV['REDIS_PASSWORD']);
// Увеличиваем счетчик посещений
$hits = $redis->incr('hits');

$host = gethostname();

// Выводим результат
$dt_utc = date(DATE_ATOM);
$txt = <<< TEXT
PHP says:
 DateTime (UTC): "$dt_utc"
 My Host name is "$host"

 Redis "hits": '$hits'
TEXT;

header('Content-Type: text/plain');
print "$txt";

// закрываем соединение
$redis->close();
