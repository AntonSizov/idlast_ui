// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jstz-1.0.4.min
//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.9.0.custom
//= require_tree .

$(document).ready(function(){
	document.cookie = 'jstz_time_zone='+jstz.determine().name()+';';
});

$('#user_articles_notify').click( function(e){
  $(this).closest('form').submit();
});
