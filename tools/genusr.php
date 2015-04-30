#!/usr/bin/php
<?php
/* 
 * genusr.php - A script which generates users for SRVMON.
 * Copyright (C) 2015  Pol Warnimont
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

  if ($argc != 3) {
    printf("SRVMON GENUSR VERSION 0.9 (C) 2015 Pol Warnimont\n");
    printf("A script to generate users for the SRVMON monitoring suite.\n");
    printf("SRVMON GENUSR comes with ABSOLUTELY NO WARRANTY!\n\n");
    printf("Usage : ./genusr.php username password\n");
  }
  else {
    printf("SRVMON GENUSR VERSION 0.9\n\n");

    $username = $argv[1];
    $password = $argv[2];

    $cost = 10;
    $salt = strtr(base64_encode(mcrypt_create_iv(16, MCRYPT_DEV_URANDOM)), "+", ".");
    $salt = sprintf("$2a$%02d$", $cost) . $salt;

    $hash = crypt($password, $salt);

    printf("Credentials for %s:\n", $username);
    printf("  SALT => %s\n", $salt);
    printf("  HASH => %s\n\n", $hash);
  }
?>
