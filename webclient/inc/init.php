<?php
/* File        : init.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.5
 *
 * Description : Initializes this web application.
 * 
 * Changelog
 * ---------
 *  2015-04-24 : Create file.
 *  2015-04-30 : Added license and header.
 *  2015-05-06 : Changing structure.
 *
 * License
 * -------
 *  Copyright (C) 2015  Pol Warnimont
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

	session_start();

	$GLOBALS["config"] = array(
		"mysql" => array(
			"host"   => "127.0.0.1",
			"user"   => "sqlusr",
			"pass"   => "q1w2e3!",
			"dbname" => "srvmon"
		),
		"remember" => array(
			"cookieName"   => "hash",
			"cookieExpire" => 604800
		),
		"session" => array(
			"session_name" => "user",
			"token_name" => "token"
		)
	);

	spl_autoload_register(function($class) {
		require_once "inc/classes/" . $class . ".class.php";
	});

	require_once "inc/functions/sanitize.php";
