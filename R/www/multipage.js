var ready = false;
var current = {};
var viewers = {};


$(document).ready(function() {

	$(".viewer").hide().each(function(i, e) {
	});
	var myView = null;
	var viewSelector = $('#viewer');
	var viewerDefault = viewSelector.find('option').val();
	var viewerBroadcastNumber = 0;



	(function monitor() {
		if(myView == null) {
			var select = viewSelector.find('option');
			if(select.val() != viewerDefault) {
				myView = select.val();
				$(".viewer#" + myView).show().find(".shiny-bound-output").trigger('shown');
				$('body > .form-group').hide();
			}
		} else {
		}

		setTimeout(monitor, 40);
	})();

});
