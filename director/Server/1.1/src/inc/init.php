<?php
/* File        : init.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 1.1
 *
 * Description : Initilizes this web application.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-11 : Added phpDocumentor comments.
 *  2015-05-20 : Final bugfixes + Adding comments.
 *  2015-07-24 : Preparing for package release.
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

/*
 * The following array with the key "config" is used for the
 * configuration of this web application. Currently only the SQL
 * server properties are stored in this array but more values 
 * will be inserted in future versions. The values can be edited
 * manually in this file or edited using the setup.php script.
 */
$GLOBALS["config"] = array(
	"mysql" => array(
		"host"   => "CHANGE-ME-1",
		"user"   => "CHANGE-ME-2",
		"pass"   => "CHANGE-ME-3",
		"dbname" => "CHANGE-ME-4"
	),
	"encryption" => array(
		"masterkey" => "CHANGE-ME-5"
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

// Include input sanitization functions.
require_once "inc/functions/sanitize.php";
