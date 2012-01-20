var App = App || {};

App.ajaxifyPriceVariantForm = function(){

  function handleSuccess(responseText, statusText, xhr, jqForm) {
    var error = responseText.error;
    if (error) {
      alert(error);
    } else {
      alert('Variants were successfully saved');
    }
  }

  function beforeSubmit(formData, jqForm, options) {
    return true;
  }

  var options = {
    success: handleSuccess,
    beforeSubmit: beforeSubmit,
    dataType: 'json'
  };

  $('form#price-and-variant').ajaxForm(options);
};

$(function(){
  App.ajaxifyPriceVariantForm();
});
