var i=0;
function timedCount () {
	i = i+1;
	postMessage(i,"html5webWorkers.html");
	setTimeout("timedCount()",500);
}
		
timedCount();