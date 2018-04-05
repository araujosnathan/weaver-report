// Dashboard 1 Morris-chart
$( function () {

	"use strict";
	// Morris bar chart
	Morris.Bar( {
		element: 'morris-bar-chart',
		data: [ 
			{ s: 'CB-Sprint-X', bl: 18, fx: 1, fl: 0 }, { s: 'CB-Sprint-X', bl: 18, fx: 1, fl: 0 }
       ],
		xkey: 's',
		ykeys: [ 'bl', 'fx', 'fl' ],
		labels: [ 'Bakclog', 'Fixed', 'Flagged' ],
		barColors: [ '#4680ff', '#26DAD2', '#fc6180' ],
		hideHover: 'auto',
		gridLineColor: '#eef0f2',
		resize: true
	} );

	// Morris donut chart

	Morris.Donut( {
		element: 'morris-donut-chart',
		data: [ {
			label: "Backlog",
			value: 18,

        }, {
			label: "Fixed",
			value: 1
        }, {
			label: "Flagged",
			value: 0
        } ],
		resize: true,
		colors: [ '#4680ff', '#26DAD2', '#fc6180' ]
	} );

	
} );
