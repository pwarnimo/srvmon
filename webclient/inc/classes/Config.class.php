<?php
/* File        : Config.class.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.5
 *
 * Description : Configuration management class.
 * 
 * Changelog
 * ---------
 *  2015-05-05 : Create file.
 *  2015-05-06 : Added license header.
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

class Config {
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
