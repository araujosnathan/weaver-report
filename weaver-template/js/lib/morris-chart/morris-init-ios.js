// Dashboard 1 Morris-chart
$( function () {

	"use strict";
	// Morris bar chart
	Morris.Bar( {
		element: 'morris-bar-chart',
		data: [ 
			{ s: 'CB-Sprint-03', bl: 28, fx: 11, fl: 2 }, { s: 'CB-Sprint-04', bl: 9, fx: 22, fl: 1 }, { s: 'CB-Sprint-05', bl: 7, fx: 12, fl: 1 }
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
			value: 7,

        }, {
			label: "Fixed",
			value: 12
        }, {
			label: "Flagged",
			value: 1
        } ],
		resize: true,
		colors: [ '#4680ff', '#26DAD2', '#fc6180' ]
	} );

	
} );
