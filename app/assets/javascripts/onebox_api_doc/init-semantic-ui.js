
$( document ).ready(function() {
  
  $('select.dropdown')
    .dropdown()
  ;

  $('.ui.accordion')
    .accordion({
      exclusive: false  
    })
  ;

  $('.menu .item')
    .tab()
  ;

  $('.dropdown.display_apis')
    .dropdown({
      // you can use any ui transition
      transition: 'drop'
    })
  ;

  $('.params .param__from, .api__note .note--warning')
    .popup()
  ;
  
});
