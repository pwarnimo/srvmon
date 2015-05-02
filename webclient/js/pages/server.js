var otable;

$(document).ready(function() {
	console.log("SERVER PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#servers").addClass("linkact");

	getServerData($("#sid").val(), 1);
	getServicesForServer($("#sid").val(), 0);

	setInterval(function() {
		refreshTable();
		getServerData("#sid".val(), 1);
	}, 30000)
});

function refreshTable() {
	otable.fnDestroy();
	otable.find("tbody").empty();
	getServicesForServer($("#sid").val(), 0);
};

function getServicesForServer(ID, format) {
	console.log(ID);

	$.ajax({
		type : "POST",
		url : "inc/actionswitcher.inc.php?action=getServicesForServer",
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
			var tHtml = "";

			for (var i = 0; i < result.length; i++) {
				console.log("Current Service = " + i);

				console.log(result[i]["dtCaption"]);

				switch (result[i]["dtValue"]) {
					case "0" :
						var statusHtml = "<td class=\"ok\"><span class=\"glyphicon glyphicon-ok-circle\">&nbsp; OK</td>";
						break;

					case "1" :
						var statusHtml = "<td class=\"warning\"><span class=\"glyphicon glyphicon-warning-sign\">&nbsp; WARNING</td>";
						break;

					case "2" :
						var statusHtml = "<td class=\"fail\"><span class=\"glyphicon glyphicon-remove-circle\">&nbsp; FAILED</td>";
						break;

					case "3" :
						var statusHtml = "<td class=\"unreachable\"><span class=\"glyphicon glyphicon-exclamation-sign\">&nbsp; UNREACHABLE</td>";
						break;

					case "4" :
						var statusHtml = "<td class=\"pending\"><span class=\"glyphicon glyphicon-refresh\">&nbsp; PENDING</td>";
						break;
				}

				tHtml += "<tr id=\"" + result[i]["idService"] + "\"><td><input type=\"checkbox\" id=\"" + result[i]["idService"] + "\"></td>" +
					"<td>" + result[i]["dtCaption"] + "</td>" +
					"<td>" + result[i]["dtScriptOutput"] + "</td>" +
					statusHtml;
			}

			$("#dataServices tbody").html(tHtml);

			$("#dataServices tbody td").each(function () {
				if ($(this).html().trim().length == 0) {
					$(this).html("/");
				}
			});

			otable = $("#dataServices").dataTable({
				"bAutoWidth" : false,
				"aoColumns" : [
					{
						"sTitle" : "<input type=\"checkbox\" id=\"checkAll\">",
						"sWidth" : "16px"
					},
					{
						"sTitle" : "Caption"
					},
					{
						"sTitle" : "Output"
					},
					{
						"sTitle" : "Status"
					}
				]
			});
		}
	});
};

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

			$("#host").html(result[0]["dtHostname"] + " (" + result[0]["dtIPAddress"] + ")");
			$("#description").html(result[0]["dtDescription"]);
			$("#os").html(result[0]["dtOS"]);
			$("#type").html(result[0]["dtType"]);
			$("#model").html(result[0]["dtModel"]);
			$("#manufacturer").html(result[0]["dtManufacturer"]);
			$("#responsible").html(result[0]["dtResponsible"]);
		}
	});
};
