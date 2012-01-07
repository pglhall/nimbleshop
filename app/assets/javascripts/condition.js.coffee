jQuery ->
	data = ($ "#condition-klass").data()
	($ ".condition .field").live "change", (evt)->
		$target = $(evt.target)
		for element in data.fields
			if (""+ element.id) == $target.val()
				field = element
		$select = $target.next('select.operator')
		$select.html ''
		$.each data.operators[field.field_type], (i, e) -> 
		  $select.append $("<option />", { value: e.value, text: e.name })
		false
	($ ".add-condition").live "click", (evt)->
		index   = +($ ".condition:last").data().index
		params  = $.extend(index: index+1, data)
		html = Mustache.to_html($("#product_template").html(), params)
		($ ".condition:last").after html
		false

	($ ".remove-condition").live "click", (evt)->
		$(evt.target).parents(".condition").remove()
		false
