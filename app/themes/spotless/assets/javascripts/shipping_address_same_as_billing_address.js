$('#order_shipping_address_attributes_use_for_billing').live('click',  function(){

  if ($(this).is(':checked')) {
    $('#billing_form').hide();
  } else {
    $('#billing_form').show();
  }

});


// hide the billing_form if use_for_billing is checked
$(function(){
  if ($('#order_shipping_address_attributes_use_for_billing').is(':checked')) {
    $('#billing_form').hide();
  }
});
