$(document).ready(function() {
	console.log("SERVERS PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#servers").addClass("linkact");

	populateServersTable();
});

function populateServersTable() {
	console.log("Loading servers...");
	$.ajax({
		type : "POST",
		url : "inc/actionswitcher.inc.php?action=getServers",
		statusCode : {
			404 : function() {
				console.log("actionswitcher.inc.php not found!");
			}
		},
		success : function(data) {
			console.log(JSON.parse(data));

			var result = JSON.parse(data);

			for (var i = 0; i < result.length; i++) {
				console.log(result[i]["idServer"]);
			}
		}
	});
};
