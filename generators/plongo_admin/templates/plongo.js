$(document).ready(function() {
	
	$('.plongo-text textarea').filter(function() {
		return $(this).parents('.plongo-new-item').length == 0
	}).rte({
		controls_rte: rte_toolbar,
		controls_html: html_toolbar,
		height: 200
	});
	
	// form
	
	var updatePlongoCollectionItemPositions = function(collection) {
		$.each(collection.find('.plongo-item:visible'), function(index) {
			$(this).find('input[type=hidden].position').val(index);
		});
	}
	
	var setupPlongoCollectionEffects = function(collection, index) {
		collection.accordion('destroy');
		collection.accordion({
			header: 'div.plongo-item h3',
			collapsible: true,
			alwaysOpen: false,
			active: false,
			autoHeight: false
		}).sortable({
		    items: '>div.plongo-item',
				update: function(event, ui) {
					updatePlongoCollectionItemPositions(collection);
				}
		});

		if (typeof(index) != 'undefined')
			collection.accordion('activate', index);
	}
	
	$('.plongo-collection').each(function() {
		setupPlongoCollectionEffects($(this));
	});
	
	$('form').delegate('keypress', {
		'input.highlight': function(e) {
			var input = $(e.target);
			var title = input.parents('.plongo-item').find('h3');
			
			setTimeout(function() {
				title.html(input.val());
			}, 50);
		}
	});
	
	$('form').delegate('click', {
	  '.add-button': function(e) {
			var link = $(e.target);
			var pattern = link.parent().prev('.plongo-new-item');
			var newItem = pattern.clone();
						
			newItem.addClass('plongo-item');
			newItem.removeClass('plongo-new-item');
			newItem.html(pattern.html().replace(/NEW_RECORD(_[0-9])+/g, new Date().getTime()));
			
			var index = link.parents('ol').find('.plongo-item').size();
			
			newItem.insertBefore(pattern);
			
			newItem.show();
			
			newItem.find('textarea').rte({
				controls_rte: rte_toolbar,
				controls_html: html_toolbar,
				height: 200
			});
			
			var collection = link.parents('li.plongo-collection');
			
			setupPlongoCollectionEffects(collection, index);
			
			updatePlongoCollectionItemPositions(collection);
			
			e.preventDefault();
	  },
		'.remove-button': function(e) {
			var link = $(e.target);
			var field = link.next('input[type=hidden]');
			var collection = link.parents('li.plongo-collection');

			var wrapper = link.closest('div.plongo-item');
			if (wrapper.attr('id') == '') {
				wrapper.remove();
			} else {
				field.val('1');
				wrapper.hide();
			}

			updatePlongoCollectionItemPositions(collection);

			setupPlongoCollectionEffects();
		
			e.preventDefault();
		}
	});
	
	$('form').submit(function(e) {
		$(e.target).find('.plongo-new-item').remove();
	});
	
});