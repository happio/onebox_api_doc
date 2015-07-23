$( document ).ready(function() {
  bind_copy();
});

function bind_copy (btn){
  var btn_copied = btn

  if (typeof btn_copied == 'undefined') {
    btn_copied = $('.copy--btn');
  }

  var clip = new ZeroClipboard( btn_copied );
  clip.on( "aftercopy", function( event ) {
    var from_btn = $(event.target);
    from_btn.text('Copied!');
    setTimeout(function() {
      from_btn.text('Copy');
    }, 5000);
  });

}

