<?php

shell_exec("export PHP_INI_SCAN_DIR=/etc/php5/conf.d");

$ret = apc_clear_cache();
print("return from apc_clear_cache = $ret");

