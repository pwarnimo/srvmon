var tableObject;

$("document").ready(function () {	
	$("#btnRefresh").click(function () {
		tableObject.ajax.reload();
	});

	tableObject = $("#dataHosts").DataTable({
		"ajax" : {
			"url" : "actionswitcher.php?action=getServers",
			"type" : "POST",
			"dataSrc" : function (json) {
				var return_arr = json.data;

				for (var i = 0; i < json.data.length; i++) {
					return_arr[i]["idServer"] = "<input type=\"checkbox\" name=\"selectHost\" value=\"" + return_arr[i]["idServer"] + "\">"

					if (return_arr[i]["dtEnabled"] == "1") {
						return_arr[i]["dtEnabled"] = "<span class=\"label label-success\">Online</span>";
					}
					else {
						return_arr[i]["dtEnabled"] = "<span class=\"label label-danger\">Offline</span>";
					}
				}

				return return_arr;
			}
		},
		"columns" : [
			{ "data" : "idServer" },
			{ "data" : "dtHostname" },
			{ "data" : "dtIPAddress" },
			{ "data" : "dtType" },
			{ "data" : "dtOS" },
			{ "data" : "dtModel" },
			{ "data" : "dtManufacturer" },
			{ "data" : "dtLastCheckTS" },
			{ "data" : "dtEnabled" }
		]
	});
});
