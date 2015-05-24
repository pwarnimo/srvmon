<?php
/*
 * File        : servers.inc.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-29
 * Version     : 0.1
 *
 * Description : Content for the servers overview.
 *
 * Changelog
 * ---------
 *  2015-04-29 : Created file
 *  2015-04-30 : Added license and header.
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


if (!$user->isLoggedIn()) {
	Session::flash("index", "You are not logged in!");
	Redirect::to("index.php");
}

$mngr = new ServerMngr();

$mngr->getServerFromDB(-1, false);
echo $mngr->serverToJSON(8);
echo $mngr->getOS();

echo <<< PAGE
	<!--<div class="page-header">
		<h1>Servers <small>SRVMON UI</a></small></h1>
	</div>

	<div id="tableview">
		<table id="dataServers" class="testtable" width="100%">
			<thead>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>-->

	<script src="js/pages/servers.js"></script>
PAGE;
