// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var Filter = {
    setup: function() {
        $('#accordian').on('click', 'h3', Filter.slide);
        $('#accordian').on('click', 'a', Filter.highlight);
        $('#save_filter').on('click', Filter.save);
        $('#check').on('click', Filter.check);
    },
    slide: function() {
    	if ($(this).next().is(":visible")) {
    		$(this).next().slideUp();
    	} else {
    		$(this).next().slideDown();
    	}
    },
    check: function() {
    	console.log($('#title input').val());
    },
    highlight: function() {
        $(this).toggleClass('selected');
        return false;
    },
    save: function() {
        var filters = "";
        $('#accordian ul').find(".selected").each(function() {
        	filters = filters.concat($(this).text().concat(", "));
        });
        console.log($('#name').find('input'))
        var name = $('#name input');
        if($('#name input').length) {
        	name = name.val()
        } else {
        	name = $('#name a').text()
        }
        // var extra_emails = $('#additional')
        // if($('#additional input').length) {
        //     extra_emails = extra_emails.val().split(',');
        // } else {
        //     extra_emails = $('#extra_emails a').text();
        // }
        var extra_emails = ""
        extra_emails = $('#additional input');
        if($('#additional input').length) {
            extra_emails = extra_emails.val()
        } else {
            extra_emails = $('#additional a').text()
        }

        console.log(name)
        console.log(extra_emails)
        var data = {
        	'filters': filters,
        	'name': name,
            'extra_emails': extra_emails
        }
        $.ajax({
      		url: "/groups/create",
      		type: 'POST',
      		data: data,
      		success: function(){
        		window.location.href = "/groups/index";
      		},
      		error:function(err){
       			console.log(err);
      		}
    	});
    },
};
$(Filter.setup);