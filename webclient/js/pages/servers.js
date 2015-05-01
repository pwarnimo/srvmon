var oTable;

$(document).ready(function() {
	console.log("SERVERS PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#servers").addClass("linkact");

	populateServersTable();

	setInterval(function() {
		refreshTable();
	}, 60000);
});

function refreshTable() {
	oTable.fnDestroy();
	oTable.find("tbody").empty();
	populateServersTable();
};

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
			var tHtml = "";

			for (var i = 0; i < result.length; i++) {
				if (result[i]["dtEnabled"] == 1) {
					var enabledHtml = "<span style=\"color: #0a0;\" class=\"glyphicon glyphicon-ok-circle\"> ONLINE</span>"
				}
				else {
					var enabledHtml = "<span style=\"color: #a00;\" class=\"glyphicon glyphicon-remove-circle\"> OFFLINE</span>"
				}

				tHtml += "<tr id=\"" + result[i]["idServer"] + "\"><td><input type=\"checkbox\" id=\"" + result[i]["idServer"] + "\"></td>" +
					"<td>" + result[i]["dtHostname"] + "</td>" +
					"<td>" + result[i]["dtIPAddress"] + "</td>" +
					"<td>" + result[i]["dtType"] + "</td>" +
					"<td>" + result[i]["dtOS"] + "</td>" +
					"<td>" + result[i]["dtModel"] + "</td>" +
					"<td>" + enabledHtml + "</td>";
			}

			$("#dataServers tbody").html(tHtml);

			$("#dataServers tbody td").each(function () {
				if ($(this).html().trim().length == 0) {
					$(this).html("/");
				}
			});

			oTable = $("#dataServers").dataTable({
				"bAutoWidth" : false,
				"aoColumns" : [
					{
						"sTitle" : "<input type=\"checkbox\" id=\"checkAll\">",
						"sWidth" : "16px"
					},
					{
						"sTitle" : "Hostname"
					},
					{
						"sTitle" : "IP Address"
					},
					{
						"sTitle" : "Type"
					},
					{
						"sTitle" : "OS"
					},
					{
						"sTitle" : "Model"
					},
					{
						"sTitle" : "Status"
					}
				]
			});
		}
	});
};
