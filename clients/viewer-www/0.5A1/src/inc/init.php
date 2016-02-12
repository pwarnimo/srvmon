<?php
/*
 * File : init.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-09
 * Version : 0.5A1
 *
 * Description : Initializes the web application.
 *
 * Changelog
 * ---------
 *  2016-02-09 : Created file.
 *
 * License
 * -------
 *  Copyright (C) 2016  Pol Warnimont
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

session_start();

$GLOBALS["config"] = array(
	"director" => array(
		"host" => "http://localhost/director"
	),
	"remember" => array(
		"cookie_name" => "hash",
		"cookie_expiry" => 604800
	),
	"session" => array(
		"session_name" => "userdata",
		"token_name" => "token"
	)
);

spl_autoload_register(function($class) {
	require_once "inc/classes/" . $class . ".class.php";
});

// COMPOSER
require_once "vendor/autoload.php";
// COMPOSER

require_once "inc/functions/sanitize.php";
