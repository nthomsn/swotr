var ready = false;
var current = {};
var viewers = {};
	

$(document).ready(function() {
	// init
	
	// hide viewers and get all current views
	$(".viewer").hide().each(function(i, e) {
		/*
		var view = $(e).attr('id');
		var viewer = localStorage.getItem('viewer-' + view);
		viewers['viewer-' + view] = {
			view: view,
			owner: viewer ? viewer.pageid: null,
			alive: false
		};
		*/
	});
	/*
	// each page grabs a unique id
	var pageid = Number(localStorage.getItem('page-id')) + 1;
	localStorage.setItem('page-id', pageid);
	*/
	// view init
	var myView = null;
	var viewSelector = $('#viewer');
	var viewerDefault = viewSelector.find('option').val();
	var viewerBroadcastNumber = 0;
	
	/*
	// remove already existing pages
	$('body > .form-group').click(function() {
		var $this = $(this);
		setTimeout(function() {
			$this.find('div.selectize-dropdown-content > div.option').each(function(i,e) {
				var view = $(e).attr('data-value');
				if(view == viewerDefault) return;
				
				if(viewers['viewer-' + view].alive) {
					$(e).hide();
				}
			});
		}, 1);
	});
	*/
	
	/*
	(function initCurrent() {
		// ping to see if shiny is ready
		if(Shiny.shinyapp !== undefined) {
			// grab the values
			$.each(Shiny.shinyapp.$inputValues, function(k, v) {
				if(k.startsWith('.')) return;
				current[k] = v;
			});
			ready = true;
		}
		// if it't not ready
		else {
			// reloop in 100ms
			setTimeout(initCurrent, 100);
		}
		
	})();
	*/
	
	// monitor
	(function monitor() {
		// no view
		if(myView == null) {
			var select = viewSelector.find('option');
			// selected a view
			if(select.val() != viewerDefault) {
				// set view
				myView = select.val();
				$(".viewer#" + myView).show().find(".shiny-bound-output").trigger('shown');
				$('body > .form-group').hide();
				/*
				localStorage.setItem('viewer-' + myView, JSON.stringify({
					view: myView,
					pageid: pageid,
					token: viewerBroadcastNumber,
					timeout: 5000
				}));
				*/
			}
		} else {	
			/*
			// rebroadcast view
			viewerBroadcastNumber += 1;
			localStorage.setItem('viewer-' + myView, JSON.stringify({
				view: myView,
				pageid: pageid,
				token: viewerBroadcastNumber,
				timeout: 5000
			}));
			*/
		}
		
		/*
		// if shiny is ready
		if(ready) {
			// monitor input values
			$.each(Shiny.shinyapp.$inputValues, function(k, v) {
				if(k.startsWith('.')) return;
				if(k == "viewer") return;
				
				// new value from input
				if(current[k] != v) {
					current[k] = v;
					localStorage.removeItem('multi-page-' + k);
					localStorage.setItem('multi-page-' + k, JSON.stringify({
						id:k,
						val:v
					}));
				}
			});
		}
		*/
		setTimeout(monitor, 40);
	})();
	
	/*
	// broadcast
	addEventListener('storage', function(evt) {
		// ignore unsets
		if(evt.newValue == null) return;
		
		// multi-page value broadcast
		if(evt.key.startsWith('multi-page')) {
			// get the set value
			var setVal = JSON.parse(evt.newValue);
			
			console.log("evt " , evt.key, " got ", setVal.id, " val ", setVal.val);
			
			// send value to shiny
			Shiny.onInputChange(setVal.id, setVal.val);
		}
		// viewer broadcase		
		else if(evt.key.startsWith('viewer-')) {
			var broadcast = JSON.parse(evt.newValue);
			
			// say the viewer is alive
			viewers[evt.key].view = broadcast.view;
			viewers[evt.key].alive = true;
			viewers[evt.key].owner = broadcast.pageid;
			
			// timeout viewer after some time passes
			setTimeout(function() {
				var latestBroadcast = JSON.parse(localStorage.getItem(evt.key));
				if(broadcast.token == latestBroadcast.token) {
					viewers[evt.key].alive = false;
				}
			}, Number(broadcast.timeout));
		}
	});
	*/
});
