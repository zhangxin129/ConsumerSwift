#!/usr/bin/php

#  GenerateOtherLocalizableFile.sh
#
#  Created by wangfd on 16/3/18.
#  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
#

<?php

function process_lang ($lang)
{
    global $src_root;
    global $og_keys;

    $og_keys_copy = array_merge($og_keys, array());

    $strings_file = $src_root . '/HSConsumer/' .$lang. '.lproj/Localizable.strings';
    echo 'Generate file: ', $strings_file, "...";

    if (!file_exists($strings_file))
    {
        echo " no exist\n";
        return;
    }

    if (!is_readable($strings_file))
    {
        echo " is not readable\n";
        return;
    }

    if (!is_writable($strings_file))
    {
        echo " is not writable\n";
        return;
    }

    $fp = fopen($strings_file, 'r');
    $keys = array();

    while (!feof($fp))
    {
        $line = fgets($fp);

        if (false === strpos($line, '='))
        {
            continue;
        }
        $tempKey = current(explode('=', $line));
        $key = trim($tempKey);
        $keys[$key] = $line;
    }

    fclose($fp);

    $fp = fopen($strings_file, 'w');

    foreach ($keys as $k => $v)
    {
        if (array_key_exists($k, $og_keys_copy))
        {
            fputs($fp, $keys[$k]);
            unset($og_keys_copy[$k]);
        }
    }

    foreach ($og_keys_copy as $k => $v)
    {
//        if (array_key_exists($k, $keys))
//        {
//            continue;
//        }

        fputs($fp, $og_keys_copy[$k]);
    }

    fclose($fp);

    echo " success\n";
}

$langs = array('zh-Hans','en','zh-Hant');

$args = getopt('d:', array('required:'));

if ('' == $args)
{
    echo "not SRCROOT\n";
    exit(1);
}

$src_root = $args['d'];
$og_strings_file = $src_root . '/HSConsumer/zh-Hans.lproj/Localizable.strings';

$og_fp = fopen($og_strings_file, 'r');
$og_keys = array();
while (!feof($og_fp))
{
    $line = fgets($og_fp);

    if (false === strpos($line, '='))
    {
        continue;
    }

    if (0 == preg_match('/^"(.*?)"(\s*)=(\s*)"(.*?)";$/i', $line))
    {
        echo 'String format error:' . $line . "\n";
        exit(1);
    }

    $tempKey = current(explode('=', $line));
    $key = trim($tempKey);

    if (isset($og_keys[$key]))
    {
        echo 'Key error: ' . $key . " duplicate key!\n";
        exit(1);
    }

    $og_keys[$key] = $line;
}
fclose($og_fp);

echo 'There are ' . count($og_keys) . " keys in origin file.\n";

foreach ($langs as $lan)
{
    process_lang($lan);
}

echo "Generate other Loclizable string file complete!\n";
