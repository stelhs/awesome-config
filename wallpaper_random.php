#!/usr/bin/php
<?php
require_once '/usr/local/lib/php/common.php';
require_once '/usr/local/lib/php/os.php';
require_once '/usr/local/lib/php/database.php';

define("RANDOM_HISTORY_FILE", "/var/local/wallpapers_random_history");
define("PHOTOS_LIST_FILE", "/var/local/wallpaper_list");


function get_list_photos()
{
    static $list_photos = [];
    if (count($list_photos))
        return $list_photos;

    $content = file_get_contents(PHOTOS_LIST_FILE);
    if (!$content) {
        perror("can't opened file %s\n", PHOTOS_LIST_FILE);
        return NULL;
    }

    $list_photos = split_string_by_separators($content, "\n");
    return $list_photos;
}


function get_count_photos()
{
    return count(get_list_photos());
}


function get_random_history()
{
    @$content = file_get_contents(RANDOM_HISTORY_FILE);
    if (!$content)
        return [];

    $ret = json_decode($content, true);
    if (!$ret) {
        unlink(RANDOM_HISTORY_FILE);
        return [];
    }

    return $ret;
}


function update_random_history($value)
{
    $history = get_random_history();
    @$history[$value] ++;

    file_put_contents(RANDOM_HISTORY_FILE, json_encode($history));
}

function get_max()
{
    $history = get_random_history();
    $count_photos = get_count_photos();
    $max = 0;

    for ($i = 0; $i < $count_photos; $i++) {
        $count = 0;
        if (isset($history[$i]))
            $count = $history[$i];

        if ($count > $max)
            $max = $count;
    }
    return $max;
}


function get_random_number()
{
    $max = get_max();
    $history = get_random_history();

    $count_photos = get_count_photos();
    
    do {
        $number = random_int(0, $count_photos);
        $count = 0;
        if (isset($history[$number]))
            $count = $history[$number];

    } while($count > $max + 1);

    return $number;
}

function main($argv)
{
    $wallpaper_dirs = ['/home/stelhs/MyPhoto/Объекты/',
                       '/home/stelhs/MyPhoto/Походы/',
                       '/home/stelhs/MyPhoto/Поездки/',
                       '/home/stelhs/MyPhoto/Прогулки/',
                       '/home/stelhs/MyPhoto/Минск/Старый минск/'];

    if (!isset($argv[1]))
        return 1;
    $mode = $argv[1];
    switch ($mode) {
    case 'init':
        @unlink(PHOTOS_LIST_FILE);
        foreach ($wallpaper_dirs as $dir) {
            run_cmd(sprintf("find '%s' -type f -name '*.jpg' >> %s", $dir, PHOTOS_LIST_FILE));
            run_cmd(sprintf("find '%s' -type f -name '*.JPG' >> %s", $dir, PHOTOS_LIST_FILE));
        }
        return 0;

    case 'update':
        $history = get_list_photos();
        $number = get_random_number();
        update_random_history($number);
        $photo = $history[$number];
        run_cmd("xargs -0 feh --bg-scale", false, $photo);
        return 0;
    }

    return 0;
}


function print_help()
{
    $utility_name = $argv[0];
    perror("Usage: $utility_name <command> <args>\n" .
             "\tcommands:\n" .
                 "\t\t init: make photos tree file " . RANDOM_HISTORY_FILE . "\n" .
                 "\t\t update: set random photos on background screen\n" .
             "\n\n");
}


$rc = main($argv);
if ($rc) {
    print_help();
    exit($rc);
}
    
