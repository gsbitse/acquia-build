<?php

global $base_url;

print('base url = '+$base_url);
variable_set('apc_flush_webservers_to_flush', $base_url);

shell_exec("drush cc apc");


