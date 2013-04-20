<?php

variable_set('apc_flush_webservers_to_flush', $base_url)

shell_exec("drush cc apc");


