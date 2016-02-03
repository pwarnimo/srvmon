<?php
/**
 * Configuration class.
 *
 * ### About
 *  
 * *	Filename : Config.class.php
 * *	Create data : 2015-05-07
 * *	Version : 2.0 A1
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
 * *  2016-02-03 : Beginning with version 2.0.
 *  
 * ### License
 *  
 * Copyright (C) 2016  Pol Warnimont
 *  
 * This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *  
 * @author Pol Warnimont <pwarnimo@gmail.com>
 * @copyright 2016 Pol Warnimont
 * @license GPLv2
 * @license https://www.gnu.org/licenses/old-licenses/gpl-2.0.de.html
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
