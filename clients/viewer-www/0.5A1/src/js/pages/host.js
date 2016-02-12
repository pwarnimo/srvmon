/*
 * File : host.js
 * Author(s) : Pol Warnimont
 * Create date : 2016-02-09
 * Version : 0.5A1
 *
 * Description : JS for data display.
 *
 * Changelog
 * ---------
 *  2016-02-09 : Created file.
 *  2016-02-10 : Implement ajax request for data retrieval.
 *  2016-02-11 : Reworked ajax request into datatable.
 *
 * License
 * -------
 *  Copyright (C)  Pol Warnimont
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

var tableObject;
var hostid;

$("document").ready(function () {
	hostid = $("#hostid").val();

	console.log("Getting data for host " + hostid);

	$("#refreshData").click(function () {
		getServerData(1);
	});

	$(".btnRefresh").hover(function () {
		$(this).css('cursor','pointer');
	});

	tableObject = $("#dataServices").DataTable({
		"ajax" : {
			"url" : "actionswitcher.php?action=getAllServicesForServer",
			"type" : "POST",
			"data" : {
				id : hostid
			},
			"dataSrc" : function (json) {
				var return_data = new Array();

				for (var i = 0; i < json.data.length; i++) {
					switch (json.data[i].dtValue) {
						case "0" :
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

					return_data.push({
						"idService" : "<input type=\"checkbox\" name=\"serviceSelect\" value=\"" + json.data[i].idService + "\">",
						"dtCaption" : json.data[i].dtCaption,
						"dtLastCheckTS" : json.data[i].dtLastCheckTS,
						"dtValue" : svcStatus
					});
				}

				return return_data;
			}
		},
		"columns" : [
			{ "data" : "idService" },
			{ "data" : "dtCaption" },
			{ "data" : "dtLastCheckTS" },
			{ "data" : "dtValue" }
		]
	});

	$("#refreshServices").click(function () {
		console.log("refreshing svc...");
		tableObject.ajax.reload();
	});

	getServerData(hostid);
});

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
