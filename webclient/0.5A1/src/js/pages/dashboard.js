var tableObject;

$(document).ready(function() {
	console.log("DASHBOARD INIT...");

	$(".nav li").removeClass("active");
	$("#lnk-dashboard").addClass("active");

	getServersJSON();
});

function getServersJSON() {
	$.ajax({
		type : "POST",
		url : "actionswitcher.php?action=getServers",
		statusCode : {
			404 : function() {
				console.log("Function getServers() not found in actionswitcher.php!");
			}
		},
		success : function(data) {
			var dataObj = JSON.parse(data);
			var tHtml = "";

			for (var i = 0; i < dataObj.data.length; i++) {
				var currentObj = dataObj.data[i];

				if (currentObj["dtEnabled"] == "1") {
					var enData = "<span class=\"label label-success\">Online</span>";
				}
				else {
					var enData = "<span class=\"label label-danger\">Offline</span>";
				}

				tHtml += "<tr id=\"S" + currentObj["idServer"] + "\">" +
					"<td><input type=\"checkbox\" id=\"C" + currentObj["idServer"] + "\"></td>" +
					"<td>" + currentObj["dtHostname"] + "</td>" +
					"<td>" + currentObj["dtIPAddress"] + "</td>" +
					"<td>" + currentObj["dtType"] + "</td>" +
					"<td>" + currentObj["dtOS"] + "</td>" +
					"<td>" + currentObj["dtModel"] + "</td>" +
					"<td>" + currentObj["dtManufacturer"] + "</td>" +
					"<td>" + enData + "</td>"
					"</tr>";
			}

			$("#dataServers tbody").html(tHtml);

			tableObject = $("#dataServers").dataTable({
				"bAutoWidth" : false,
				"aoColumns" : [
					{
						"sTitle" : "<input type=\"checkbox\" id=\"checkAll\">"
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
						"sTitle" : "Manufacturer"
					},
					{
						"sTitle" : "Status"
					}
				]
			});
		}
	});
};
