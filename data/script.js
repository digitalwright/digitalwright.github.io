numberLines = function() {
	var pre = document.getElementsByTagName('pre'),
	pl = pre.length;
	var k = 1;
	for (var i = 0; i < pl; i++) {
		var s = pre[i].innerHTML.split("\n");
		var x = new Array(s.length);
		x[0] = 0;
		var inline = 0;
		for (j = 1; j < s.length; j++) {
			if (s[j].charAt(0) == '&') { // line of code
				if (inline == 1)
					s[j - 1] += '</span>';
				if (s[j].length == 5) {
					s[j] += '\n';
					x[j] = -1;
				} else {
					x[j] = 0;
				}
				s[j] = '<span class="line">' + s[j].substring(5);
				inline = 1;
			} else if (s[j].charAt(0) == '+') { // line of code
				if (s[j].length == 2) {
					x[j] = -1;
				} else {
					x[j] = 0;
				}
				s[j] = '<span class="line">' + s[j].substring(2) + '</span>';
			} else { // line of results
				if (inline == 1)
					s[j - 1] += '</span>';
				inline = 0;
				s[j] = '<span class="results">' + s[j] + '</span>';
				x[j] = 1;
			}
		}
		if (inline == 1)
			s[j - 1] += '</span>';
		
		pre[i].innerHTML = '<span class="linenumber"></span>' + s.join('') + '<span class="cl"></span>';
		
		for (var j = 0; j < s.length; j++) {
			var line_num = pre[i].getElementsByTagName('span')[0];
			if (x[j] == 0) { // line of code
				line_num.innerHTML += '<span>' + k + '</span>';
				k++;
			} else if (x[j] < 0) { // empty line of code
				line_num.innerHTML += '<span>-</span>';
			} else { // line of results
				line_num.innerHTML += '<span class="results"><br></span>';
			}
		}
	}
}

toggle = function() {
	var text = document.getElementById("displayText");
	if (text.innerHTML == "Hide output") {
		text.innerHTML = "Show output";
	} else {
		text.innerHTML = "Hide output";
	}
	
	var lines = document.getElementsByClassName("results");
	for (var i = 0; i < lines.length; i++) {
		if (lines[i].style.display == "none") {
			lines[i].style.display = "block";
		} else {
			lines[i].style.display = "none";
		}
	}
}