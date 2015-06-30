var select_role = $('#filter-apis-by-tag');
select_role.on('change', function(){
  var target_url = $(this).find(':selected').data('url');
  location.replace(target_url);
});