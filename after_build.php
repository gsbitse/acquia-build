<?php

$ini_array = parse_ini_file("~/build/settings/config.ini");

if (isset($ini_array['acquia_key'])) {
  variable_set('acquia_key', $ini_array['acquia_key']);
}

if (isset($ini_array['acquia_identifier'])) {
  variable_set('acquia_identifier', $ini_array['acquia_identifier']);
}

if (isset($ini_array['acquia_subscription_name'])) {
  variable_set('acquia_subscription_name', $ini_array['acquia_subscription_name']);
}

acquia_agent_check_subscription();

