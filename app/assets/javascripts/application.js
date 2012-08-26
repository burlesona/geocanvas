//= require jquery
//= require jquery_ujs
//= require_tree .

$(function () {
	initialize();
	$('button#measure_reset').click( function(){
		measureReset();
	});
	$('form#location_search').submit( function(event) {
		event.preventDefault();
		locationSearch();
	});
});