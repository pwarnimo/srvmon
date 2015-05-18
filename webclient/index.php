<?php
/*
 * File        : index.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.5
 *
 * Description : Displays the login form for the WebUI.
 * 
 * Changelog
 * ---------
 *  2015-04-24 : Create file.
 *  2015-04-30 : Added license and header.
 *  2015-05-06 : Changing structure.
 *  2015-05-16 : Worked on the login system.
 *  2015-05-17 : Worked on the login system.
 *  2015-05-18 : Adding remember me functionality.
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

	require_once "inc/init.php";
?>
<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang=""> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>SRVMON WebUI 0.5 -- Login</title>
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="apple-touch-icon" href="apple-touch-icon.png">
		<link rel="stylesheet" href="css/bootstrap.min.css">
		<style>
			body {
				padding-top: 50px;
				padding-bottom: 20px;
			}
		</style>
		<link rel="stylesheet" href="css/bootstrap-theme.min.css">	
		<link rel="stylesheet" href="//cdn.datatables.net/1.10.7/css/jquery.dataTables.min.css">
		<link rel="stylesheet" href="css/main.css">

		<script src="js/vendor/modernizr-2.8.3-respond-1.4.2.min.js"></script>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')</script>
		<script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
	</head>
	<body>
		<?php
			// Testing BEGIN
			echo "<pre style=\"color:#f00;\">DEBUG</pre>";

			if (Input::exists()) {
				if (Token::check(Input::get("token"))) {
					$validator = new Validator();

					$validation = $validator->check($_POST, array(
						"dtUsername" => array("required" => true),
						"dtPassword" => array("required" => true)
					));

					if ($validation->passed()) {
						$user = new User();
						$remember = (Input::get("remember") === "on") ? true : false;
						$login = $user->login(Input::get("dtUsername"), Input::get("dtPassword"), $remember);

						if ($login) {
							Redirect::to("test.php");
							//echo "<p>" . Session::get(Config::get("session/session_name")) . "</p>";
						}
					}
					else {
						foreach ($validation->errors() as $error) {
							echo $error . "<br>";
						}
					}
				}
			}

			echo "<pre style=\"color:#f00;\">DEBUG</pre>";
			// Testing END
		?>

		<!--[if lt IE 8]>
      	<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
		<![endif]-->
		<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<a class="navbar-brand" href="#">SRVMON WebUI 0.5</a>
				</div>
			</div>
		</nav>
 
		<div class="row">
			<div class="col-md-4">
			</div>
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">WebUI Login</h3>
					</div>
					<div class="panel-body">
						<form class="form-horizontal" action="" method="post">
							<p>Please enter your login credentials.</p>
							
							<div class="form-group">
								<label for="dtUsername" class="col-sm-2 control-label">Username</label>
								<div class="col-sm-10">
									<input type="text" class="form-control" name="dtUsername" id="dtUsername" placeholder="johndoe" value="<?php echo escape(Input::get("dtUsername"))?>">
								</div>
							</div>

							<div class="form-group">
							   <label for="dtPassword" class="col-sm-2 control-label">Password</label>
								<div class="col-sm-10">
									<input type="password" class="form-control" name="dtPassword" id="dtPassword" placeholder="Password">
								</div>
							</div>

							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<div class="checkbox">
										<label>
											<input type="checkbox" name="remember" id="remember"> Remember me
										</label>
									</div>
								</div>
							</div>

							<input type="hidden" name="token" value="<?php echo Token::generate(); ?>">

							<div class="form-group">
								<div class="col-sm-offset-2 col-sm-10">
									<input type="submit" class="btn btn-default" value="submit">
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="col-md-4">
			</div>
		</div>

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')</script>
		<script src="js/vendor/bootstrap.min.js"></script>

		<script src="js/main.js"></script>
	</body>
</html>
