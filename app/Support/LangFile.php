<?php

namespace App\Support;

use Illuminate\Support\Arr;

/**
 * Reads a Laravel language "group" (validation, auth, pagination, passwords) from the single
 * per-language JSON file (resources/lang/en.json or ar.json), so that ALL texts of the site
 * live in just two files. Keys such as "validation.between.numeric" become nested arrays.
 */
class LangFile
{
    protected static $cache = [];

    public static function group($locale, $group)
    {
        if (! isset(static::$cache[$locale])) {
            $path = resource_path('lang/'.$locale.'.json');
            $data = is_file($path) ? json_decode(file_get_contents($path), true) : [];
            static::$cache[$locale] = is_array($data) ? $data : [];
        }

        $prefix = $group.'.';
        $result = [];

        foreach (static::$cache[$locale] as $key => $value) {
            if (strpos($key, $prefix) === 0) {
                Arr::set($result, substr($key, strlen($prefix)), $value);
            }
        }

        return $result;
    }
}
