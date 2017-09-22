/*var x = document.getElementById("demo");
if (navigator.geolocation) {
   navigator.geolocation.getCurrentPosition(showPosition);
} else {
   document.title = "Geolocation is not supported by this browser.";
}

function showPosition(position) {
   document.title = "Latitude: " + position.coords.latitude +
   "<br>Longitude: " + position.coords.longitude;
}*/
try{
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(showPosition);
		//document.title = "This is the new page title";
	}
}catch(err){
	document.title = err.message;
}

function showPosition(position) {
	document.title = "This is the new page title";
}
