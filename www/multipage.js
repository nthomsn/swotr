/*
* multipage.js is the javascript at the heart of shiny multipage. It sets up
* the different views for each page.
*/

// Main script
// -----------------------------------------------------------------------------
$(document).ready(function() {
  // Hide all views to start
	hideAllViews();

  // Parse the querystring... apparently JQuery or vanilla JS can't do this
	var querystring = (function(a) {
    if (a === "") return {};
    var b = {};
    for (var i = 0; i < a.length; ++i)
    {
        var p=a[i].split('=', 2);
        if (p.length == 1)
            b[p[0]] = "";
        else
            b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
    }
    return b;
  })(window.location.search.substr(1).split('&'));

  // If the querystring has a view param then set the dropdown menu to that
  if(querystring.view) {
    setTimeout(function () {
      //setView(querystring.view);
      $('#viewer').find('option').val(querystring.view);
    }, 100);
  }

  // Monitor the dropdown and change the view when one is selected
  monitorViewSelector();

});

// Functions
// -----------------------------------------------------------------------------

// Set the page to only display one view
var setView = function(viewName) {
  $(".viewer#" + viewName).show().find(".shiny-bound-output").trigger('shown');
  $('body > .form-group').hide();
}

// Hide all pages, but not a dropdown selector to choose the views
var hideAllViews = function() {
  $(".viewer").hide().each(function(i, e) {});
}

// Run a monitor() function every 40 ms that checks to see if a user
// has selected a view. As soon as one is selected run setView()
var monitorViewSelector = function() {
  var viewSelector = $('#viewer');
	var viewerDefault = viewSelector.find('option').val();
	(function monitor() {

    // If an option is selected set the view to that page
    // Return when this is done, don't keep monitoring
		var viewSelection = viewSelector.find('option').val();
		if(viewSelection != viewerDefault) {
		  console.log(viewSelection);
		  setView(viewSelection);
		  return;
		}

		// Run this function again in 40ms
    setTimeout(monitor, 40);

	})();
}


