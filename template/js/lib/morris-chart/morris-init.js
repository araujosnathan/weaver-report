// Dashboard 1 Morris-chart
$( function () {

	"use strict";
	// Morris bar chart
	Morris.Bar( {
		element: 'morris-bar-chart',
		data: [ 
			INFO_BUGS_SPRINT
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
			value: BACKLOG_SPRINT,

        }, {
			label: "Fixed",
			value: FIXED_SPRINT
        }, {
			label: "Flagged",
			value: FLAGGED_SPRINT
        } ],
		resize: true,
		colors: [ '#4680ff', '#26DAD2', '#fc6180' ]
	} );

	
} );
