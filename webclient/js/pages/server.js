$(document).ready(function() {
	console.log("SERVER PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#servers").addClass("linkact");

	getServerData($("#sid").val(), 1);
});

function getServerData(ID, format) {
	console.log(ID);

	$.ajax({
		type : "POST",
		url : "inc/actionswitcher.inc.php?action=getServer",
		data : {
			sid : ID,
			format : format
		},
		statusCode : {
			404 : function() {
				console.log("actionswitcher.inc.php not found!");
			}
		},
		success : function(data) {
			console.log(data);

			var result = JSON.parse(data);

			if (result[0]["dtEnabled"] == 1) {
				$("#status").addClass("text-success");
				$("#status").html("<span class=\"glyphicon glyphicon-ok-circle\">&nbsp;ONLINE</span>");
			}
			else {
				$("#status").addClass("text-danger");
				$("#status").html("<span class=\"glyphicon glyphicon-remove-circle\">&nbsp;OFFLINE</span>");
			}

			$("#host").html(result[0]["dtHostname"] + "(" + result[0]["dtIPAddress"] + ")");
		}
	});
};
