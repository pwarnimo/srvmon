#!/usr/bin/php
<?php
  printf("GENUSR -- Generate salt and pw hash for the given user.\n");
  
  $username = "";
  $password = "";

  $cost = 10;
  $salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), "+", ".");
  $salt = sprintf("$2a$%02d$", $cost) . $salt;

  $hash = crypt($password, $salt);

  printf("Credentials for %s:\n", $username);
  printf("  SALT => %s\n", $salt);
  printf("  HASH => %s\n", $hash);
?>
