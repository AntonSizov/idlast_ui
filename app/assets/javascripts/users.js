$('#user_articles_notify').click( function(e){
  $(this).closest('form').submit();
});

$('#user_timezone').on('change', function(e){
	$(this).closest('form').submit();
});
