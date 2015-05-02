$(document).ready(function() {
	console.log("SERVER PAGE INIT...");

	$(".sidebar-nav li").removeClass("linkact");
	$("#servers").addClass("linkact");

	getServerData();
});

function getServerData(ID) {
	console.log(ID);
};
