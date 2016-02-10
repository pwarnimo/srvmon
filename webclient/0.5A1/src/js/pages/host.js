var tableObject;

$("document").ready(function () {
	console.log("LOADING HOST...");

	$("#refreshData").click(function () {
		getServerData(1);
	});

	$("#refreshData").hover(function () {
		$(this).css('cursor','pointer');
	});

	//getServerData(1);
	getServiceList(1);
});

function getServiceList(ID) {
	$.ajax({
		type : "POST",
		url : "actionswitcher.php?action=getAllServicesForServer",
		data : {
			id : ID
		},
		statusCode : {
			404 : function () {
				console.log("Function getAllServicesForServer() not found in actionswitcher.php!");
			}
		},
		success : function (data) {
			var dataObj = JSON.parse(data);
			var tHtml = "";

			for (var i = 0; i < dataObj.data.length; i++) {
				var currentObj = dataObj.data[i];

				switch (currentObj["dtValue"]) {
					case "0":
						var svcStatus = "<span class=\"label label-success\">Ok</span>";
						break;

					case "1":	
						var svcStatus = "<span class=\"label label-warning\">Warning</span>";
						break;

					case "2":
						var svcStatus = "<span class=\"label label-danger\">Critical</span>";
						break;

					case "3":
						var svcStatus = "<span class=\"label label-default\">Timeout</span>";
						break;

					case "4":
						var svcStatus = "<span class=\"label label-primary\">Pending</span>";
						break;
				}

				tHtml += "<tr id=\"S" + currentObj["idService"] + "\">" +
					"<td><input type=\"checkbox\" id=\"C" + currentObj["idService"] + "\"></td>" +
					"<td>" + currentObj["dtCaption"] + "</td>" +
					"<td>" + currentObj["dtLastCheckTS"] + "</td>" +
					"<td>" + svcStatus+ "</td>" +
					"</tr>";
			}

			$("#dataServices tbody").html(tHtml);

			tableObject = $("#dataServices").dataTable({
				"bAutoWidth" : false,
				"aoColumns" : [
					{
						"sTitle" : "<input type=\"checkbox\" id=\"checkAll\">"
					},
					{
						"sTitle" : "Caption"
					},
					{
						"sTitle" : "Last checked"
					},
					{
						"sTitle" : "Status"
					}
				]
			});
		}
	});
};

function getServerData(ID) {
	$.ajax({
		type : "POST",
		url : "actionswitcher.php?action=getServer",
		data : {
			id : ID
		},
		statusCode : {
			404 : function () {
				console.log("Function getServer() not found in actionswitcher.php!");
			}
		},
		success : function (data) {
			var dataObj = JSON.parse(data);

			//console.log(dataObj.data[0]["dtDescription"]);
			if (dataObj.data[0]["dtEnabled"] == "1") {
				$("#status").html("<span class=\"label label-success\">Online</span>");
			}
			else {
				$("#status").html("<span class=\"label label-danger\">Offline</span>");
			}

			$("#host").html(dataObj.data[0]["dtHostname"] + " (" + dataObj.data[0]["dtIPAddress"] + ")");
			$("#description").html(dataObj.data[0]["dtDescription"]);
			$("#os").html(dataObj.data[0]["dtOS"]);
			$("#type").html(dataObj.data[0]["dtType"]);
			$("#model").html(dataObj.data[0]["dtModel"]);
			$("#manufacturer").html(dataObj.data[0]["dtManufacturer"]);
			$("#responsible").html(dataObj.data[0]["dtResponsible"]);
		}
	});
};
