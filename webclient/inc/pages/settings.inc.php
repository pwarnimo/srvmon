<?php
$user = new User();

if (!$user->isLoggedIn()) {
	Session::flash("index", "You are not logged in!");
	Redirect::to("index.php");
}

echo <<< PAGE
	<div class="page-header">
		<h1>Settings <small>SRVMON UI</a></small></h1>
	</div>
	
	<div class="row">
		<div class="col-md-4">
			<div class="panel panel-primary">
				<div class="panel-heading">Versions</div>
				<div class="panel-body">
PAGE;

if (DB::getInstance()->query("SELECT dtCaption, dtValue FROM tblSetting WHERE dtCaption LIKE ?", array("%version"))->rowCount()) {
	$version = DB::getInstance()->results();
	$versions = json_decode(file_get_contents("http://srv04.scrubstudios.de/srvmon/version.php"), true);

	foreach ($version as $val) {
		$update = (floatval($versions[$val->dtCaption]) > floatval($val->dtValue)) ? "<span class=\"label label-warning\">Outdated " . $versions[$val->dtCaption] . "</span>" : "<span class=\"label label-success\">Up to date</span>";

		switch ($val->dtCaption) {
			case "dbversion":
				echo "<p>Database Version " . $val->dtValue . " " . $update . "</p>";
			break;
			case "webuiversion":
				echo "<p>WebUI Version " . $val->dtValue . " " . $update . "</p>";
			break;
			case "agentversion":
				echo "<p>Agent Version " . $val->dtValue . " " . $update . "</p>";
			break;
			case "updaterversion":
				echo "<p>Director Updater Version " . $val->dtValue . " " . $update . "</p>";
			break;
			case "serverversion":
				echo "<p>Director Server Version " . $val->dtValue . " " . $update . "</p>";
			break;
		}
	}
}
else {
	echo "<p>Failed to get the version!</p>";
}

echo <<< PAGE
				</div>
			</div>
		</div>
			
		<div class="col-md-8">
			<div class="panel panel-primary">
				<div class="panel-heading">About</div>
				<div class="panel-body">
					<h4>SRVMON WebUI 0.5</h4>
					<p>Copyright &copy; 2015 Pol Warnimont, ScrubStudios<br>The SRVMON WebUI comes with ABSOLUTELY NO WARRANTY!</p>
					<p>For more informations about the SRVMON monitoring suite, please visit the maintainers website <a href="http://pwarnimo.github.io/srvmon">http://pwarnimo.github.io/srvmon</a></p>
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
	
	<script src="js/pages/settings.js"></script>
PAGE;
?>
