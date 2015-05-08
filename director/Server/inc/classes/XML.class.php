<?php
/* File        : XML.class.php
 * Author(s)   : Pol Warnimont 
 * Create date : 2015-05-08
 * Version     : 0.5
 *
 * Description : Generates XML code.
 * 
 * Changelog
 * ---------
 *  2015-05-08 : Created file.
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

class XML {
	private $db;

	public function __construct() {
		$this->db = DB::getInstance();
	}

	public function test() {
		$this->db->query("SELECT * FROM tblService");
		
		return $this->db->first()->dtCaption;
	}
}
