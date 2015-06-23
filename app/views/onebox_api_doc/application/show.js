
var details_container = $("#api-details");
details_container.html("<%=j render partial: 'onebox_api_doc/application/api_details', locals: { api: @api } %>");

var btn_copied = details_container.find('.copy--btn');
bind_copy(btn_copied);
