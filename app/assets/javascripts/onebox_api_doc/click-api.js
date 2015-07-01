
$(".link-api-list").on( 'click', function(e){
    e.preventDefault();
    var request_url = $(this).attr("href");
    $.ajax({
      url: request_url,
      dataType: "json",
      success: function(result){
        current_url = result.url
        return_html = result.html

        window.history.pushState("", "", current_url);

        var details_container = $("#api-details");
        details_container.html(return_html);

        var btn_copied = details_container.find('.copy--btn');
        bind_copy(btn_copied);
      }

    });
});

