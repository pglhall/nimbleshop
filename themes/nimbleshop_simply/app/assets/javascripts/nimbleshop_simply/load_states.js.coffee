window.NimbleshopSimply = window.NimbleshopSimply || {}

class NimbleshopSimply.manageStates

	stateCodeField: ($country) ->
		$country.parents('[data-behavior~=well]').find("[name$='[state_code]']")

	createOption: (state) ->
		($ "<option />", text: state[0], value: state[1])

	updateStates: ($country) ->
		$stateCode = @stateCodeField($country).html('')
		for state in window.countryStateCodes[$country.val()]
			$stateCode.append @createOption(state)

	handler: (evt) =>
		$country = $(evt.target)
		@updateStates $country
		false

	constructor:  ->
		($ "select[name$='[country_code]']").bind('change', @handler)
