<?php
/**
 * Class for password hashing.
 * 
 * ### About
 *  
 * *	Filename : Hash.class.php
 * *	Create data : 2015-05-08
 * *	Version : 1.1
 *  
 * ### Description
 *  
 *	This class is used to calculate the password hash for a user.
 *  
 * ### List of changes
 *  
 *	*	2015-07-09 : Created file.
 *	*	2015-07-24 : Preparing for package release.
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
class Hash {
	/**
	 *	Return a password hash.
	 *		
	 *	This function returns a hashed password.
	 *		
	 *	@param String $string Password string.
	 * @param String $salt Salt for the password hash.
	 *	@return String Returns the hashed password.
	 */
	public static function make($string, $salt = "") {
		return hash("sha256", $string . $salt);
	}
}
