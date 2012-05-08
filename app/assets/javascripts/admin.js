// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// bootstrap-collapse file is needed so that twitter bootstrap can collapse top navigation and make it work on iphone
//
//= require jquery-1.7.1
//= require jquery-ui-1.8.16
//= require jquery-ujs
//= require jquery-json
//= require mustache
//= require nested_form
//= require jquery-form
//= require autoresize
//= require twitter/bootstrap
//
//= require highlight_error_field
//= require enable_payment_method
//= require focus
//= require product-group-condition
//= require shipit
//= require ajaxify-price-variant-form
//= require enable_disable_price_variant
//= require ajaxify-link-groups
//= require admin/shipping_methods/edit
//= require admin/products/edit
//= require_tree ./class


$(function(){
  $('.autoresize').autoResize({maxHeight: 300});
});
