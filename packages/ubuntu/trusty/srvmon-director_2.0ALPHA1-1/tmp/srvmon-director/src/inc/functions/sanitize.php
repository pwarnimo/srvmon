<?php
/*
 * File        : sanitize.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-05-07
 * Version     : 2.0 A1
 *
 * Description : This file contains data sanitizing functions.
 *
 * Changelog
 * ---------
 *  2015-05-07 : Created file.
 *  2015-05-11 : Added phpDocumentor comments.
 *  2015-05-20 : Final bugfixing + Adding comments.
 *  2015-07-24 : Preparing for package release.
 *  2016-02-03 : Beginning with version 2.0.
 *  2016-02-06 : Alpha 2.0-1 package preparation.
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
function escape($string) {
	return htmlentities($string, ENT_QUOTES, "UTF-8");
}