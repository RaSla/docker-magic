<?php

// Путь к файлу
$file_path = 'catalog.json';
// Получение времени последнего изменения файла
$file_modified_time = filemtime($file_path);

// Установка HTTP-заголовка с датой изменения файла
header('Last-Modified: ' . gmdate('D, d M Y H:i:s', $file_modified_time) . ' GMT');

// Чтение данных из файла catalog.json
$json_data = file_get_contents($file_path);
$data = json_decode($json_data, true);

// Создание HTML таблицы
$html = '<html><head><title>PHP Catalog</title></head><body>'."\n";
$html .= '<table border="1">'."\n";
$html .= '<tr><th>ID</th><th>Name</th><th>Стоимость</th><th>Залог</th><th colspan="3">Цена Проката</th></tr>'."\n";
foreach ($data as $item) {
    $html .= '<tr>';
    $html .= '<td>' . $item['id'] . '</td>';
    $html .= '<td>' . $item['name'] . '</td>';
    $html .= '<td>' . $item['cost'] . '</td>';
    $html .= '<td>' . $item['zalog'] . '</td>';
    $html .= '<td>' . $item['p1'] . '</td>';
    $html .= '<td>' . $item['p2'] . '</td>';
    $html .= '<td>' . $item['p3'] . "</td>";
    $html .= "</tr>\n";
}
$html .= "</table>\n";
$html .= "</body></html>\n";

// Вывод HTML таблицы
echo $html;
