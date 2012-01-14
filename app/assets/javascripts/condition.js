$(function(){
	data = $("#product-group-condition-klass").data();
	$(".condition .field").live("change", function (evt) {
		var $target 	= $(evt.target).siblings('input.value').val('').end();
		var $select 	= $target.siblings('select.operator').html('');
		var fieldType = $.grep(data.fields, function(element) {
				return (""+ element.id) == $target.val();
		})[0].field_type;

    $.each( data.operators[fieldType], function(i, element) {
		  $select.append($("<option />", { value: element.value, text: element.name }));
    });
    return false;
	});

  $(".add-condition").live("click", function (evt) {
		var index   = +$(".condition:last").data().index;
		var params  = $.extend({ index: index+1 }, data);
		$(".condition:last").after(Mustache.to_html($("#product_template").html(), params));
		return false;
	});

  $(".remove-condition").live("click", function (evt) {
		var $condition = $(evt.target).parents(".condition");
    $.each($condition.find(":input:not(:hidden)"), function (i, element) {
		  $(element).remove();
		});

		$condition.find(".remove-condition").remove();
		$condition.find(".destroy-flag").val('1');
		return false;
	});
});
