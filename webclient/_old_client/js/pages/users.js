var otable;

$(document).ready(function() {
	console.log("USERS PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#users").addClass("linkact");

	populateUserTable();
});

function populateUserTable() {
	console.log("Getting user list from DB...");

	$.ajax({
		type : "POST",
		url : "actionswitcher.php?action=getUsers",
		statusCode : {
			404 : function() {
				console.log("actionswitcher.php not found!");
			}
		},
		success : function(data) {
			var result = JSON.parse(data);
			var tHtml = "";

			//idUser, dtUsername, dtEmail, fiRole, dtTelephone, dtName, dtSurname FROM tblUser

			for (var i = 0; i < result.length; i++) {
				tHtml += "<tr id=\"" + result[i]["idUser"] + "\"><td><input type=\"checkbox\" id=\"" + result[i]["idUser"] + "\"></td>" +
					"<td>" + result[i]["dtUsername"] + "</td>" + 
					"<td>" + result[i]["dtEmail"] + "</td>" +
					"<td>" + result[i]["fiRole"] + "</td>" +
					"<td>" + result[i]["dtTelephone"] + "</td>" +
					"<td>" + result[i]["dtName"] + "</td>" +
					"<td>" + result[i]["dtSurname"] + "</td></tr>";

				$("#dataUsers tbody").html(tHtml);

				$("#dataUsers tbody td").each(function () {
					if ($(this).html().trim().length == 0) {
						$(this).html("/");
					}
				});

				oTable = $("#dataUsers").dataTable({
					"bAutoWidth" : false,
					"aoColumns" : [
						{
							"sTitle" : "<input type=\"checkbox\" id=\"checkAll\">",
							"sWidth" : "16px"
						},
						{
							"sTitle" : "Username"
						},
						{
							"sTitle" : "E-Mail"
						},
						{
							"sTitle" : "Role"
						},
						{
							"sTitle" : "Telephone"
						},
						{
							"sTitle" : "Name"
						},
						{
							"sTitle" : "Surname"
						}
					]
				});
			}
		}
	});
};
