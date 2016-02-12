<?php
/*
 * File : index.php
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-09
 * Version : 0.5A1
 *
 * Description :  The main index page for the UI.
 *
 * Changelog
 * ---------
 *  2016-02-09 : Created file.
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

require_once "inc/init.php";
require_once "inc/settings/whitelistpg.inc.php";
?>
<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang=""> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title>SRVMON Viewer</title>
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
		<link rel="stylesheet" href="css/main.css">
			
		<script src="js/vendor/modernizr-2.8.3-respond-1.4.2.min.js"></script>
	</head>

	<body>
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
					<a class="navbar-brand" href="#">SRVMON Viewer</a>
				</div>
				<div id="navbar" class="navbar-collapse collapse">
					<ul class="nav navbar-nav">
						<li id="lnk-dashboard"><a href="index.php">Dashboard</a></li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Overview<span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li><a href="#">Hosts</a></li>
									<li><a href="#">Services</a></li>
									<li><a href="#">Messages</a></li>
									<li role="separator" class="divider"></li>
									<li><a href="#">Settings</a></li>
								</ul>
						</li>
						<li><a href="index.php?page=about">About</a></li>
					</ul>
				</div><!--/.navbar-collapse -->
			</div>
		</nav>

		<div class="container">
			<?php
				$page = filter_input(INPUT_GET, "page");

				if ($page != false) {
					if (in_array($page, $whitelistpg)) {
						include "inc/pages/" . $page . ".inc.php";
					}
					else {
						Redirect::to(404);
					}
				}
				else {
					include "inc/pages/dashboard.inc.php";
				}
			?>

			<hr>

			<footer>
				<p>&copy; Company 2015</p>
			</footer>
		</div> <!-- /container -->
		
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')</script>
		<script src="//cdn.datatables.net/1.10.7/js/jquery.dataTables.min.js"></script>
		
		<script src="js/vendor/bootstrap.min.js"></script>
		
		<script src="js/main.js"></script>

		<?php
			if ($page != false) {
				if (in_array($page, $whitelistpg)) {
					echo "<script src=\"js/pages/" . $page . ".js\"></script>";
				}
				else {
					Redirect::to(404);
				}
			}
			else {
				echo "<script src=\"js/pages/dashboard.js\"></script>";
			}
		?>
	</body>
</html>
