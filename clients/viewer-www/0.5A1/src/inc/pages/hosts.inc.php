<?php
/*
 * File : hosts.inc.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-11
 * Version : 0.5A1
 *
 * Description : Content for host overview.
 *
 * Changelog
 * ---------
 *  2016-02-11 : Created file.
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

echo <<< PG
	<h1>Hosts Overview</h1>

	<div id="tableview">
		<table id="dataHosts" width="100%">
			<thead>
				<tr>
					<th><input type="checkbox" name="checkAll" id="checkAll"></th>
					<th>Hostname</th>
					<th>IP Address</th>
					<th>Type</th>
					<th>OS</th>
					<th>Model</th>
					<th>Manufacturer</th>
					<th>Last Checked</th>
					<th>Status</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>

	<button id="btnRefresh"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span></button>
PG;
