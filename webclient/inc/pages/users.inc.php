<?php
$user = new User();

if (!$user->isLoggedIn()) {
	Session::flash("index", "You are not logged in!");
	Redirect::to("index.php");
}

//print_r(UserMngr::getUsers());

echo <<< OVERLAY
	<div id="dlgAdd" title="Add a new user">
		<p>Please fill in all required fields!</p>
		<form class="form-horizontal">
			<div class="form-group">
				<label for="dtUsername" class="col-sm-2 control-label">Username *</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="dtUsername" placeholder="john.doe" required>
				</div>
			</div>
			<div class="form-group">
				<label for="dtPassword" class="col-sm-2 control-label">Password *</label>
				<div class="col-sm-10">
					<input type="password" class="form-control" id="dtPassword" placeholder="Your Password" required>
				</div>
			</div>
			<div class="form-group">
				<label for="dtPasswordAgain" class="col-sm-2 control-label">Password Again *</label>
				<div class="col-sm-10">
					<input type="password" class="form-control" id="dtPasswordAgain" placeholder="Your Password" required>
				</div>
			</div>
			<div class="form-group">
				<label for="dtEmail" class="col-sm-2 control-label">E-Mail *</label>
				<div class="col-sm-10">
					<input type="email" class="form-control" id="dtEmail" placeholder="john.doe@example.com" required>
				</div>
			</div>
			<div class="form-group">
				<label for="dtTelephone" class="col-sm-2 control-label">Telephone No.</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="dtTelephone" placeholder="+352 123456">
				</div>
			</div>
			<div class="form-group">
				<label for="dtName" class="col-sm-2 control-label">Name *</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="dtName" placeholder="John" required>
				</div>
			</div>
			<div class="form-group">
				<label for="dtSurname" class="col-sm-2 control-label">Surname *</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="dtSurname" placeholder="Doe" required>
				</div>
			</div>
			<div class="form-group">
				<label for="fiType" class="col-sm-2 control-label">User Type *</label>
				<div class="col-sm-10">
					<select class="form-control">
OVERLAY;

if (!DB::getInstance()->query("SELECT * FROM tblRole")->error()) {
	foreach (DB::getInstance()->results() as $type) {
		echo "<option id=\"" . $type->idRole . "\">" . $type->dtDescription . "</option>";
	}
}
else {
	echo "<option>DB FAILURE</option>";
}

echo <<< OVERLAY
					</select>
				</div>
			</div>
OVERLAY;

echo "<input type=\"hidden\" name=\"token\" value=\"" . Token::generate() . "\">";

echo <<< OVERLAY
		</form>
	</div>
OVERLAY;

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
				<button type="button" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span> Add</button>
				<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span> Delete</button>
			</div>
		</div>
	</div>
	
	<script src="js/pages/users.js"></script>
PAGE;
?>
