	// This scripts count downward from "TotalSeconds" to negative infinity
	var Timer;
	var TotalSeconds = 3;

	function CreateTimer() {
  	Timer = document.getElementById("timer");
  	UpdateTimer();
  	setTimeout("Tick()", 1000);
	}
	function Tick() {
 		TotalSeconds -= 1;
 		UpdateTimer();
 		setTimeout("Tick()", 1000);
	}
	function UpdateTimer() {
		Timer.innerHTML = TotalSeconds;
	}
