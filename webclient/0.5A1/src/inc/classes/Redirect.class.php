<?php
/*
 * File : Redirect.class.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-09
 * Version : 0.5A1
 *
 * Description : HTTP redirection functions.
 *
 * Changelog
 * ---------
 *  2016-02-09 : Created class.
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

class Redirect {
	public static function to($location = null) {
		if ($location) {
			if (is_numeric($location)) {
				switch ($location) {
					case 404:
						header("HTTP/1.0 404 Not Found");
						exit();
					break;
				}
			}

			header("Location: " . $location);
			exit();
		}
	}
}