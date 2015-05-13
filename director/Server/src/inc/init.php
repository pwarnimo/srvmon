<?php
/* File        : init.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.0
 *
 * Description : Initilizes this web application.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-11 : Added phpDocumentor comments.
 *
 * License information
 * -------------------
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

$GLOBALS["config"] = array(
	"mysql" => array(
		"host"   => "127.0.0.1",
		"user"   => "sqlusr",
		"pass"   => "q1w2e3!",
		"dbname" => "srvmon"
	)
);

/**
 * Autoload classes.
 *
 * This function is used to automatically load classes if an instance is
 * created.
 */
spl_autoload_register(function($class) {
	require_once "inc/classes/" . $class . ".class.php";
});

require_once "inc/functions/sanitize.php";