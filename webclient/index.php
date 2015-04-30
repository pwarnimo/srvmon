<?php
/*
 * File        : index.php
 * Author(s)   : Pol Warnimont
 * Create date : 2015-04-24
 * Version     : 0.1
 *
 * Description : The main index page for the WebUI.
 * 
 * Changelog
 * ---------
 *  2015-04-24 : Create file.
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
?>
<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang=""> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>SRVMON UI 0.1 -- Login</title>
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

    	<?php
		include "inc/settings/dbconfig.inc.php";
		include "inc/whitelists/whitelist.inc.php";

		function __autoload($class_name) {
			require_once "inc/classes/" . $class_name . ".class.php";
		}
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
          <a class="navbar-brand" href="#">SRVMON UI 0.1</a>
        </div>
      </div>
    </nav>
   
	<div id="wrapper">
		<div id="sidebar-wrapper">
			<ul class="sidebar-nav">
				<li class="norm"><a href="#"><span class="glyphicon glyphicon-tasks"> Servers</span></a></li>
				<li class="norm"><a href="#"><span class="glyphicon glyphicon-list-alt"> Services</span></a></li>
				<li class="norm"><a href="#"><span class="glyphicon glyphicon-user"> Users</span></a></li>
				<li class="norm"><a href="#"><span class="glyphicon glyphicon-cog"> Settings</span></a></li>
			</ul>
		</div>

		<div id="page-content-wrapper">
			<div class="page-content">
				<div class="container">
					<div class="row">
						<div class="col-md-12">
							<?php
								$page = filter_input(INPUT_GET, "page");

								if ($page != false) {
									if (in_array($page, $whitelist)) {
										include("inc/pages/" . $page . ".inc.php");
									}
									else {
										include("inc/pages/error.inc.php");
									}
								}
								else {
									include("inc/pages/servers.inc.php");
								}
							?>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>


        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')</script>

        <script src="js/vendor/bootstrap.min.js"></script>

        <script src="js/main.js"></script>

        <!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
        <script>
            (function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
            function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
            e=o.createElement(i);r=o.getElementsByTagName(i)[0];
            e.src='//www.google-analytics.com/analytics.js';
            r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
            ga('create','UA-XXXXX-X','auto');ga('send','pageview');
        </script>
    </body>
</html>
