// Dashboard 1 Morris-chart
$( function () {

	"use strict";
	// Morris bar chart
	Morris.Bar( {
		element: 'morris-bar-chart',
		data: [ 
			{ s: 'CB-Sprint-03', bl: 7, fx: 6, fl: 1 }, { s: 'CB-Sprint-04', bl: 22, fx: 8, fl: 1 }, { s: 'CB-Sprint-05', bl: 21, fx: 7, fl: 0 }, { s: 'CB-Sprint-05', bl: 21, fx: 7, fl: 0 }
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
			value: 21,

        }, {
			label: "Fixed",
			value: 7
        }, {
			label: "Flagged",
			value: 0
        } ],
		resize: true,
		colors: [ '#4680ff', '#26DAD2', '#fc6180' ]
	} );

	
} );
