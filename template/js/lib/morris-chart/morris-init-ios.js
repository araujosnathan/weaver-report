// Dashboard 1 Morris-chart
$( function () {

	"use strict";
	// Morris bar chart
	Morris.Bar( {
		element: 'morris-bar-chart',
		data: [ 
			{ s: 'CB-Sprint-X', bl: 9, fx: 0, fl: 1 }, { s: 'CB-Sprint-X', bl: 9, fx: 0, fl: 1 }
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
			value: 9,

        }, {
			label: "Fixed",
			value: 0
        }, {
			label: "Flagged",
			value: 1
        } ],
		resize: true,
		colors: [ '#4680ff', '#26DAD2', '#fc6180' ]
	} );

	
} );
