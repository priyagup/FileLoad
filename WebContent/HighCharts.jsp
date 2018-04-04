<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<body>
<div id="container"></div>
<button id="large">Large</button>
<button id="small">Small</button>
<button id="auto">Auto</button>
</body>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>HighCharts</title>
<style type="text/css">
#container {
	min-width: 310px;
	max-width: 800px;
}
</style>
<script>
window.onload = function () {
    // Create the chart
    lists = $.parseJSON('${json}');
	var dp1= [{x: 1, y: 206}];
	var dp2= [{x: 1, y: 206}];
	var dp3= [{x: 1, y: 206}];
	for (var i = 0; i < lists.length; i++) {
		dp1[i] = {x: new Date(lists[i].year, lists[i].month, lists[i].day, lists[i].hour, lists[i].minute), y: lists[i].ce };
	}
	for (var i = 0; i < lists.length; i++) {
		dp2[i] = {x: new Date(lists[i].year, lists[i].month, lists[i].day, lists[i].hour, lists[i].minute), y: lists[i].Opacity};
	}
	for (var i = 0; i < lists.length; i++) {
		dp3[i] = {x: new Date(lists[i].year, lists[i].month, lists[i].day, lists[i].hour, lists[i].minute), y: lists[i].AirAssist};
	}
   
	var chart = Highcharts.stockChart('container', {
        chart: {
            height: 400,
            events: {
                load: function () {
                    // set up the updating of the chart each second
                    var series = this.series[0];
                    setInterval(function () {
                    	lists = $.parseJSON('${json}');
                    	for (var i = 0; i < lists.length; i++) {
                    		var x: new Date(lists[i].year, lists[i].month, lists[i].day, lists[i].hour, lists[i].minute;
                    		var y: lists[i].ce;
                    	}
                        series.addPoint([x, y], true, true);
                    }, 1000);
                }
            }
        },

        title: {
            text: 'Highstock Responsive Chart'
        },
        subtitle: {
            text: 'Click small/large buttons or change window size to test responsiveness'
        },
        rangeSelector: {
            selected: 1
        },
        series: [{
            name: 'AAPL Stock Price',
            data: dp1,
            type: 'area',
            threshold: null,
            tooltip: {
                valueDecimals: 2
            }
        }],
        responsive: {
            rules: [{
                condition: {
                    maxWidth: 500
                },
                chartOptions: {
                    chart: {
                        height: 300
                    },
                    subtitle: {
                        text: null
                    },
                    navigator: {
                        enabled: false
                    }
                }
            }]
        }
    });
    $('#small').click(function () {
        chart.setSize(400);
    });
    $('#large').click(function () {
        chart.setSize(800);
    });
    $('#auto').click(function () {
        chart.setSize(null);
    });
}
</script>
</head>

</html>