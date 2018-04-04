
<!DOCTYPE HTML>
<html>
<link rel="stylesheet" type="text/css" href="wickedpicker.css">
<script type="text/javascript" src="jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="canvasjs.min.js"></script>
<script type="text/javascript" src="wickedpicker.js"></script>
<body>
	<div id="chartContainer" style="height: 400px; width: 100%;"></div>
	<form action="uploadfile" method="POST" id="chart">
		
		<div style="display: inline-flex;">
			<input type="text" name="starttime" id="starttime" class="timepicker"style="margin-left: 180px;" /> 
			<input type="text" name="endtime"id="endtime" class="timepicker" />
			<div class="checkboxThree">
				<input type="checkbox" value="1" id="checkboxThreeInput" name="type"style="opacity: 0" /> <label for="checkboxThreeInput"> </label>
			</div>
		</div>
		<button type="submit">Submit</button>
	</form>
</body>
<head>
<style>
body {
	background: #F9EEE6;
}

form button {
	margin: 0;
	color: #fff;
	background: #16a085;
	border: none;
	width: 10%;
	height: 35px;
	margin-top: -20px;
	margin-left: -4px;
	border-radius: 4px;
	border-bottom: 4px solid #117A60;
	transition: all .2s ease;
	outline: none;
}

form button:hover {
	background: #149174;
	color: #0C5645;
	margin-top: 15px;
}

form button:active {
	border: 0;
}

.timepicker {
	margin-right: 7%;
	border: 1px solid #c4c4c4;
	height: 25px;
	width: 275px;
	font-size: 13px;
	padding: 4px 4px 4px 4px;
	border-radius: 4px;
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	box-shadow: 0px 0px 8px #d9d9d9;
	-moz-box-shadow: 0px 0px 8px #d9d9d9;
	-webkit-box-shadow: 0px 0px 8px #d9d9d9;
}

.timepicker:focus {
	outline: none;
	border: 1px solid #7bc1f7;
	box-shadow: 0px 0px 8px #7bc1f7;
	-moz-box-shadow: 0px 0px 8px #7bc1f7;
	-webkit-box-shadow: 0px 0px 8px #7bc1f7;
}

.checkboxThree {
	bottom: 20px;
	width: 152px;
	height: 40px;
	background: #333;
	margin: 20px 0px;
	margin-right: 7%;
	border-radius: 70px;
	position: relative;
}

.checkboxThree:before {
	content: 'S';
	position: absolute;
	top: 12px;
	left: 13px;
	height: 2px;
	color: #16a085;
	font-size: 16px;
}

.checkboxThree:after {
	content: 'D';
	position: relative;
	top: 10px;
	left: 45px;
	height: 2px;
	color: white;
	font-size: 16px;
}

.checkboxThree label {
	display: block;
	width: 52px;
	height: 22px;
	border-radius: 50px;
	transition: all .5s ease;
	cursor: pointer;
	position: absolute;
	top: 9px;
	z-index: 1;
	left: 12px;
	background: #ddd;
}

.checkboxThree input[type=checkbox]:checked+label {
	left: 51px;
	background: #16a085;
}
</style>
<script>
	window.onload = function() {
		$('#starttime').wickedpicker({
			//now : "00:01"
		});//,twentyFour: true, timeSeparator: ':'
		$('#endtime').wickedpicker({
			now : "23:59"
		});//,twentyFour: true, timeSeparator: ':'
		var SelectType = "${type}";
		
		if (SelectType == "Dynamic") {

			dynamicChart();
		} else {

			staticChart();
		}
	}

	function dynamicChart() {
		//window.onload = function () {
		lists = $.parseJSON('${json}');
		var dp1 = [];
		var dp2 = [];
		var dp3 = [];
		var chart = new CanvasJS.Chart("chartContainer", {
			animationEnabled : true,
			exportEnabled : true,
			zoomEnabled : true,

			backgroundColor : "#F9EEE6",
			title : {
				text : "Dynamic Time-Series Chart",

			},
			axisX : {
				title : "Time",
				labelFormatter : function(e) {
					return CanvasJS.formatDate(e.value, "hh:mm TT");
				},
				intervalType : "minute",
				
			},
			axisY :[ {
				title : "Air Assist",
				gridThickness : 1,
				titleFontColor :"#7F6084",
				lineColor : "#7F6084",
				labelFontColor : "#7F6084",
				tickColor : "#7F6084",
				labelFontColor :"#7F6084",
				includeZero : false,
				tickThickness : 1,
				lineThickness : 1,
				

			},{
				title : "Opacity",
				titleFontColor : "#C0504E",
				gridThickness : 1,
				lineColor : "#C0504E",
				labelFontColor : "#C0504E",
				tickColor : "#C0504E",
				labelFontColor : "#C0504E",
				includeZero : false,
				lineThickness : 1,
				
			} ],
			axisY2 : {
				title : "Combustion Efficiency",
				lineColor : "#369EAD",
				tickColor : "#369EAD",
				labelFontColor : "#369EAD",
				titleFontColor : "#369EAD",
				gridThickness : 1,
				lineThickness : 1,
				includeZero : false,
			},
			toolTip : {
				shared : true
			},
			legend : {
				verticalAlign : "bottom",
				horizontalAlign : "center",
				fontSize : 15,
				fontFamily : "Lucida Sans Unicode",
				cursor : "pointer",
				itemclick : function(e) {
					if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
						e.dataSeries.visible = false;
					} else {
						e.dataSeries.visible = true;
					}
					e.chart.render();
				}
			},
			data : [
				{
					type : "spline",
					visible : false,
					showInLegend : true,
					axisYType: "secondary",
					markerType: "square",
					color: "#369EAD",
					name : "Combustion Efficiency",
					dataPoints : dp1
				},
					{
					type : "spline",
					visible : false,
					showInLegend : true,
					markerType: "triangle",
					axisYIndex : 1,
					color:"#C0504E",
					name : "Opacity",
					dataPoints : dp2
				},
				{
					type : "spline",
					lineThickness : 3,
					showInLegend : true,
					legendText: "cross",
					name : "Air Assist",
					color: "#7F6084",
					axisYIndex : 0,
					xValueType : "dateTime",
					xValueFormatString : "hh:mm TT",
					dataPoints : dp3
				}]
	
		});
		var updateInterval = 30;
		var index = 0;
		var time = new Date;
		var currentHour = time.getHours();
		var currentMinute = time.getMinutes();
		time.setHours(00);
		time.setMinutes(00);
		lists = $.parseJSON('${json}');
		function updateChart(count) {
			count = count || 1;
			var hour, min;
			for (var i = 0; i < count; i++) {
				// setting hours and minutes.
				hour = lists[index].hour;
				min = lists[index].minute;
				time.setHours(hour);
				time.setMinutes(min);
				// setting CE and Opacity
				yValue1 = lists[index].ce;
				yValue2 = lists[index].Opacity;
				yValue3 = lists[index].AirAssist;
				// pushing the new values
				dp1.push({
					x : time.getTime(),
					y : yValue1
				});
				dp2.push({
					x : time.getTime(),
					y : yValue2
				});
				dp3.push({
					x : time.getTime(),
					y : yValue3
				});
			}
			// updating legend text with  updated with y Value 
			chart.options.data[0].legendText = " CE : " + yValue1;
			chart.options.data[1].legendText = " Opacity : " + yValue2;
			chart.options.data[2].legendText = " Air Assist : " + yValue3;
			chart.render();
			index++;
		}
		lists = $.parseJSON('${json}');
		var size = lists.length;
		var function1 = setInterval(function() {
			updateChart();
		}, 100);
		function stopFunction(functionName) {
			clearInterval(functionName);
		}

		/* }; */

	}

	/*==============================================================================================================================*/
	$('#starttime').timepicker();
	$('#endtime').timepicker();

	function staticChart() {
		/* window.onload = function () { */
			maxcount = "${maxcount}";
			mincount = "${mincount}";
// 			alert(maxcount);
// 			alert(mincount);
			var AirAssist=[];
			var maxAirAssist,minAirAssist;
			
		lists = $.parseJSON('${json}');
		var dp1 = [ {x : 1,y : 206} ];
		var dp2 = [ {x : 1,y : 206} ];
		var dp3 = [ {x : 1,y : 206} ];
		for (var i = 0; i < lists.length; i++) {
			
// 		if(i == maxcount)
// 			alert(lists[i].AirAssist);
// 		if(i == mincount)
// 			alert(lists[i].AirAssist);
			AirAssist[i] = lists[i].AirAssist;
		
		}
		maxAirAssist = Math.max.apply(Math, AirAssist);
		minAirAssist = Math.min.apply(Math, AirAssist);
		for (var i = 0; i < lists.length; i++) {	 
			dp1[i] = {x : new Date(lists[i].year, lists[i].month, lists[i].day,lists[i].hour, lists[i].minute),y : lists[i].ce};
		}
		for (var i = 0; i < lists.length; i++) {
			dp2[i] = {x : new Date(lists[i].year, lists[i].month, lists[i].day,lists[i].hour, lists[i].minute),y : lists[i].Opacity };
		}
		for (var i = 0; i < lists.length; i++) {	
			if(lists[i].AirAssist== maxAirAssist){	
// 			alert(lists[i].AirAssist);
			dp3[i] = {x : new Date(lists[i].year, lists[i].month, lists[i].day,lists[i].hour, lists[i].minute),
				y : lists[i].AirAssist, indexLabel: "highest", markerType: "triangle",  markerColor: "#6B8E23",markerSize: 25,};
			}
			else if(lists[i].AirAssist== minAirAssist){
// 				alert(lists[i].AirAssist);
				dp3[i] = {x : new Date(lists[i].year, lists[i].month, lists[i].day,lists[i].hour, lists[i].minute),
					y : lists[i].AirAssist, indexLabel: "lowest", markerType: "cross",  markerColor: "red",markerSize: 25,};
				}
			else{
				dp3[i] = {x : new Date(lists[i].year, lists[i].month, lists[i].day,
								lists[i].hour, lists[i].minute),
						y : lists[i].AirAssist
					};
			}
			

		}

		var chart1 = new CanvasJS.Chart("chartContainer", {
			animationEnabled : true,
			animationDuration: 30000,
			interactivityEnabled: true,
			
			exportEnabled : true,
			zoomEnabled : true,
			backgroundColor : "#F9EEE6",
			toolTip : {
				shared : true,
				enabled: true,
			},
			
			title : {
				text : "Static Time-Series Chart",

			},
			axisX : {
				title : "Time",
				gridThickness : 1,
				labelFormatter : function(e) {
					return CanvasJS.formatDate(e.value, "hh:mm TT");
				},
				intervalType : "minute",
				scaleBreaks: {
					autoCalculate: true
				}

			},
			axisY : [ {
				title : "Air Assist",
				gridThickness : 1,
				titleFontColor :"#7F6084",
				lineColor : "#7F6084",
				labelFontColor : "#7F6084",
				tickColor : "#7F6084",
				labelFontColor :"#7F6084",
				includeZero : false,
				tickThickness : 1,
				lineThickness : 1,
				

			}, {
				title : "Opacity",
				titleFontColor : "#C0504E",
				gridThickness : 1,
				lineColor : "#C0504E",
				labelFontColor : "#C0504E",
				tickColor : "#C0504E",
				labelFontColor : "#C0504E",
				lineThickness : 1,
				includeZero : false,
				
			} ],
			axisY2 : {
				title : "Combustion Efficiency",
				lineColor : "#369EAD",
				tickColor : "#369EAD",
				labelFontColor : "#369EAD",
				titleFontColor : "#369EAD",
				gridThickness : 1,
				lineThickness : 1,
				includeZero : false,
				
			},
			
			legend: {
				verticalAlign : "bottom",
				horizontalAlign : "center",
				fontSize : 15,
				fontFamily : "Lucida Sans Unicode",
				cursor : "pointer",
				itemclick : function(e) {
					if (typeof (e.dataSeries.visible) === "undefined"
							|| e.dataSeries.visible)
						e.dataSeries.visible = false;
					else
						e.dataSeries.visible = true;
					chart1.render();
				}
			},

			data : [ {
				type : "spline",
				visible : false,
				 explodeOnClick: true,
				showInLegend : true,
				axisYIndex : 1,
				color:"#C0504E",
				name : "Opacity",
				markerType: "square",
				dataPoints : dp2
			},
			{
				type : "spline",
				lineThickness : 3,
				 explodeOnClick: true,
				showInLegend : true,
				name : "Air Assist",
				color: "#7F6084",
				axisYIndex : 0,
				xValueType : "dateTime",
				markerType: "triangle",
				xValueFormatString : "hh:mm TT",
				dataPoints : dp3
			}, {
				type : "spline",
				visible : false,
				 explodeOnClick: true,
				showInLegend : true,
				axisYType: "secondary",
				color: "#369EAD",
				name : "Combustion Efficiency",
				dataPoints : dp1
			}]
	
			
		});

		chart1.render();

	}

	/*uploaded data validation  */
	$("#uploadSubmit").click(function(event) {

		alert("1");
		var starttime = $('#start').val();
		var endtime = $('#end').val();

		//validate date
		if (!txtDate) {
			noty({
				text : 'Date is mandatory.'
			});
			event.preventDefault();
		} else if (!isDate(txtDate)) {
			noty({
				text : 'Invalid Date.'
			});
			event.preventDefault();
		}
		//valildate start time
		if (!starttime) {
			noty({
				text : 'Start Time is mandatory.'
			});
			event.preventDefault();
		} else if (!isTime(starttime)) {
			noty({
				text : 'Invalid Start Time.'
			});
			event.preventDefault();
		}

		//valildate end time
		if (!endTime) {
			noty({
				text : 'End Time is mandatory.'
			});
			event.preventDefault();
		} else if (!isTime(endtime)) {
			noty({
				text : 'Invalid End Time.'
			});
			event.preventDefault();
		}

		if (!compareTime(starttime, endtime)) {
			noty({
				text : 'Start Time should be less than End Time.'
			});
			event.preventDefault();
		}

	});

	function isTime(txtTime) {
		var parts = txtTime.split(':');
		if ((parts[0] < 0) || (parts[0] > 23) || (parts[1] < 0)
				|| (parts[1] > 59)) {
			return false;
		} else {
			return true;
		}
		;
	};

	function compareTime() {
		//convert both time into timestamp

		var stt = new Date(starttime);
		stt = $('#starttime').val();

		var endt = new Date(endtime);
		endt = $('#endtime').val();

		if (stt > endt) {
			alert("start time should be less than end time");
			return false;
		} else {
			return true;
		};
	};
</script>
</head>
</html>
