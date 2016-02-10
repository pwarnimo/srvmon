<?php
/*
 * File : server.inc.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-10
 * Version : 0.5A1
 *
 * Description : Content for single server overview.
 *
 * Changelog
 * ---------
 *  2016-02-10 : Created file.
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
	<h1>Host overview</h1>

	<div class="row">
		<div class="col-md-4">
			<div class="panel panel-primary">
				<div class="panel-heading">Details<div class="pull-right"><span id="refreshData" class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div></div>
				<div class="panel-body">
					<p>Host status: <span id="status"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Hostname: <span id="host"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Description: <span id="description"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Operating system: <span id="os"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Type: <span id="type"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Model: <span id="model"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Manufacturer: <span id="manufacturer"><span class="glyphicon glyphicon-hourglass"></span></span></p>
					<p>Responsible group: <span id="responsible"><span class="glyphicon glyphicon-hourglass"></span></span></p>
				</div>
			</div>
		</div>

		<div class="col-md-8">
			<div class="panel panel-primary">
				<div class="panel-heading">Services<div class="pull-right"><span id="refreshServices" class="glyphicon glyphicon-refresh" aria-hidden="true"></span></div></div>
				<div class="panel-body">
					<table id="dataServices" width="100%">
						<thead>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
PG;
