<?php
$user = new User();

if (!$user->isLoggedIn()) {
	Session::flash("index", "You are not logged in!");
	Redirect::to("index.php");
}

$sid = Input::get("sid");

echo "<input type=\"hidden\" name=\"sid\" id=\"sid\" value=\"" . $sid . "\"/>";

echo <<< PAGE
	<div class="page-header">
		<h1>Host Overview <small>SRVMON UI</a></small></h1>
	</div>
	
	<div class="row">
		<div class="col-md-4">
			<div class="panel panel-primary">
				<div class="panel-heading">Host details</div>
				<div class="panel-body">
					<p>Host status: <span id="status">?</span></p>
					<p>Hostname: <span id="host">? (?)</span></p>
					<p>Description: <span id="description">?</span></p>
					<p>Operating system: <span id="os">?</span></p>
					<p>Type: <span id="type">?</span></p>
					<p>Model: <span id="model">?</span></p>
					<p>Manufacturer: <span id="manufacturer">?</span></p>
					<p>Responsible group: <span id="responsible">?</span></p>
				</div>
			</div>
		</div>
			
		<div class="col-md-8">
			<div class="panel panel-primary">
				<div class="panel-heading">Host services</div>
				<div class="panel-body">
					<table id="dataServices" class="testtable" width="100%">
						<thead>
						</thead>
						<tbody>
						</tbody>
					</table
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-12">
			<div class="btn-group" role="group" aria-label="...">
				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> Refresh</button>
				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span> Back</button>
			</div>
		</div>
	</div>
	
	<script src="js/pages/server.js"></script>
PAGE;
?>
