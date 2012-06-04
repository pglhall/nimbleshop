window.App = window.App || {}

class window.App.toggleBillingAddress
	handler: (evt) =>
		if $(evt.target).is(":checked")
    		($ '#billing_well')
    			.hide()
		else
    		($ '#billing_well')
    			.show()

	constructor:  ->
		($ "#order_shipping_address_attributes_use_for_billing")
			.bind 'click', @handler

		($ "#order_shipping_address_attributes_use_for_billing")
			.triggerHandler 'click'
