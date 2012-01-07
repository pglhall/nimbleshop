jQuery ->
	data = ($ "#condition-klass").data()
	($ ".condition .field").live "change", (evt)->
		$target = $(evt.target).siblings('input.value').val('').end()
		for element in data.fields
			if (""+ element.id) == $target.val()
				field = element
		$select = $target.siblings('select.operator').html ''
		for e in data.operators[field.field_type]
		  $select.append $("<option />", { value: e.value, text: e.name })
		false
	($ ".add-condition").live "click", (evt)->
		index   = +($ ".condition:last").data().index
		params  = $.extend(index: index+1, data)
		html = Mustache.to_html($("#product_template").html(), params)
		($ ".condition:last").after html
		false
	($ ".remove-condition").live "click", (evt)->
		condition = $(evt.target).parents(".condition")
		for element in condition.find(":input:not(:hidden)")
		  $(element).remove()
		condition.find(".remove-condition").remove()
		condition.find(".destroy-flag").val('1')
		false
