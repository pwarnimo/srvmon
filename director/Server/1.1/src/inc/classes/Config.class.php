<?php
/**
 * Configuration class.
 *
 * ### About
 *  
 * *	Filename : Config.class.php
 * *	Create data : 2015-05-07
 * *	Version : 1.1
 *  
 * ### Description
 *  
 * This class is used to retrieve configuration entries from the config array.
 *  
 * ### List of changes
 *  
 * *	2015-05-07 : Created file.
 * *	2015-05-11 : Adding phpDocumentor comments.
 * *	2015-05-20 : Final bugfixing + Adding comments.
 * *	2015-07-24 : Preparing for package release.
 *  
 * ### License
 *  
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
 *
 * @author Pol Warnimont <pwarnimo@gmail.com>
 * @copyright 2015 Pol Warnimont
 * @license AGPLv3
 * @license http://www.gnu.org/licenses/agpl.html 
 */

class Config {
	/**
	 * Retrieve configuration item.
	 *
	 * This functions enables a user to get a configuration entry the config array
	 * by using it like a directory path.
	 *  
	 * Ex.: echo Config::get("mysql/username"); This will return the username for the DB.
	 *
	 * @param string $path Path for the configuration entry.
	 * @return string|boolean Returns the value of the configuration entry. If the entry
	 * does not exist then the function will return false.
	 */
	public static function get($path) {
		if ($path) {
			$config = $GLOBALS["config"];
			$path = explode("/", $path);

			foreach ($path as $val) {
				if (isset($config[$val])) {
					$config = $config[$val];
				}
			}

			return $config;
		}

		return false;
	}
}
