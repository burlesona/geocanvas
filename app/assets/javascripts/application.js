//= require jquery
//= require jquery_ujs
//= require_tree .

$(function () {
	initialize();
	$('button#measure_reset').click( function(){
		measureReset();
	});
});