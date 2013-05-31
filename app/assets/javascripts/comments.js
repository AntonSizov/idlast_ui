function comment_submit(comment){
	$('button[type=submit], input[type=submit]').attr('disabled',true);
	$(comment).closest('form').submit();
};

function set_comments_number(){
	$('.comments-number').html($('#comments-list li').length);
};

$('#new_comment input[type=submit]').click( function(e){
	comment_submit(this);
});

$('#new_comment textarea').keydown(function (e) {
	if (e.ctrlKey && e.keyCode == 13) {
		comment_submit(this);
	}
});

$('#new_comment textarea').NobleCount('#remained_symbols',{
	max_chars: 1000,
	block_negative: true,
	on_update: function(self) {
	if (self.val().length == 0)
			$('#new_comment input[type=submit]').attr('disabled', '');
		else
			$("#new_comment input.btn").prop("disabled", null);
	}
});

function setup_comment_events() {
	$('.comment').on('mouseover', function(){
		var selector = '#' + this.id + ' .comment-tools';
		$(selector).show();
	});

	$('.comment').on('mouseout', function(){
		var selector = '#' + this.id + ' .comment-tools';
		$(selector).hide();
	});

	$('.comment-remove-btn').on('mouseover', function(){
		$(this).show();
		$(this).tooltip('show');
	});

	$('.comment-reply-to').on('click', function(){
		var reply_to = $(this).closest('div .media-body').find('strong').html();
		var textarea = $('#new_comment textarea');
		textarea.val('');
		textarea.focus();
		textarea.val(reply_to + ', ');
	});

};

setup_comment_events();

$('#new_comment textarea').autoGrow();

function hide_old_coments(){
	all_comments = $('li.comment');
	hide_comments = all_comments.slice(0,all_comments.length-3);
	hide_comments.hide();
	$('.show-all-comments-btn').on('click',function(){
		$(this).hide();
		hide_comments.slideDown();
	});
};

hide_old_coments();