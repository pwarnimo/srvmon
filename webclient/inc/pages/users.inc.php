<?php
$user = new User();

if (!$user->isLoggedIn()) {
	Session::flash("index", "You are not logged in!");
	Redirect::to("index.php");
}

//print_r(UserMngr::getUsers());

echo <<< PAGE
	<div class="page-header">
		<h1>User management <small>SRVMON UI</a></small></h1>
	</div>
	
	<div class="row">
		<div class="col-md-12">
			<div class="panel panel-primary">
				<div class="panel-heading">User list</div>
				<div class="panel-body">
					<table id="dataUsers" class="testtable" width="100%">
						<thead>
						</thead>
						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>			

	<div class="row">
		<div class="col-md-12">
			<div class="btn-group" role="group" aria-label="...">
				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> Refresh</button>
			</div>
		</div>
	</div>
	
	<script src="js/pages/users.js"></script>
PAGE;
?>
