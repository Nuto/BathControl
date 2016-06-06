function command(command) {
	var xhr = new XMLHttpRequest();
	xhr.open("GET", "/command/" + command);
	xhr.responseType = "json";
	xhr.onload = function() {
		if(this.status == 200) {
			console.log(this.response);
		}
	};
	xhr.onerror = function() {
		console.log("error");
	};
	xhr.send();
}