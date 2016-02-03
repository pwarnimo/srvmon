<?php
/*
 * File : init.php
 * Author(s) : Pol Warnimont
 * Create date : 2015-05-07
 * Version : 2.0 A1
 * 
 * Description : Initilizes this web application.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-11 : Added phpDocumentor comments. 
 *  2015-05-20 : Final bugfixes + Adding comments.
 *  2015-07-24 : Preparing for package release.
 *  2016-02-03 : Beginning with version 2.0.
 *
 * License information
 * -------------------
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
$GLOBALS["config"] = array(
	"mysql" => array(
		"host" => "127.0.0.1",
		"user" => "srvmonusr",
		"pass" => "q1w2e3!",
		"dbname" => "srvmon"
	)
);

spl_autoload_register(function($class) {
	require_once "inc/classes/" . $class . ".class.php";
});

require_once "inc/functions/sanitize.php";
