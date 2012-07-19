window.App = window.App || {}

class window.App.toggleStates

	toggleVisibility: (country) ->
		if @hasRegions country
			@stateNameField(country).val('').parents('.control-group').hide()
			@stateCodeField(country).val('').parents('.control-group').show()
		else
			@stateNameField(country).val('').parents('.control-group').show()
			@stateCodeField(country).val('').parents('.control-group').hide()

	hasRegions: ($element) ->
		window.countryStateCodes[$element.val()].length > 0

	stateNameField: ($element) ->
		$element.parents("div.well").find("[name$='[state_name]']")

	stateCodeField: ($element) ->
		$element.parents("div.well").find("[name$='[state_code]']")

	createOption: (state) ->
		($ "<option />", text: state[0], value: state[1])

	updateStates: ($element) ->
		$stateCode = @stateCodeField($element).html('')
		for state in window.countryStateCodes[$element.val()]
			$stateCode.append @createOption(state)

	handler: (evt) =>
		$country = $(evt.target)
		if @hasRegions $country
			@updateStates $country
		@toggleVisibility $country
		false

	constructor:  ->
		($ "select[name$='[country_code]']").bind('change', @handler)
		for country in  ($ "select[name$='[country_code]']")
			$(country).triggerHandler 'change'
