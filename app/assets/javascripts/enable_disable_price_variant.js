var App = App || {};

App.handleVariation2ActiveStatusChange = function(){
  if ($('#variation2_active_status').is(":checked")) {
    $('.variation2_col').removeAttr('disabled');
    $('#variation2_value').removeAttr('disabled');
  } else {
    $('.variation2_col').attr('disabled', 'disabled');
    $('#variation2_value').attr('disabled', 'disabled');
  }
};

App.handleVariation3ActiveStatusChange = function(){
  if ($('#variation3_active_status').is(":checked")) {
    $('.variation3_col').removeAttr('disabled');
    $('#variation3_value').removeAttr('disabled');
  } else {
    $('.variation3_col').attr('disabled', 'disabled');
    $('#variation3_value').attr('disabled', 'disabled');
  }
};

App.handleProductHasVariantCheckbox = function(){
  if ($('#variants_enabled').is(":checked")) {
    $('#variant_box').show();
  } else {
    $('#variant_box').hide();
  }
}

$(function(){

  $('#variants_enabled').click(function(){
    App.handleProductHasVariantCheckbox();
  });

  $('#variation2_active_status').click(function(){
    App.handleVariation2ActiveStatusChange();
  });

  $('#variation3_active_status').click(function(){
    App.handleVariation3ActiveStatusChange();
  });

  App.handleVariation2ActiveStatusChange();
  App.handleVariation3ActiveStatusChange();

});

