//= require zeroclipboard

var btn_copied = $(".api__url #copy--btn");
var clip = new ZeroClipboard( btn_copied );
clip.on( "aftercopy", function( event ) {
  btn_copied.text('Copied!');
  setTimeout(function() {
    btn_copied.text('Copy');
  }, 5000);
});