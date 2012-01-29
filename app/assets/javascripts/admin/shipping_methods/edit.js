$(function() {
				$(".update-offset").live("ajax:success", function(t, result) {
								var html = result.html;
								$(t.target).parents('tr').replaceWith(html);
				});
});
