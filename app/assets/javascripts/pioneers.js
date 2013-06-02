$('input#pioneer_approved_at').datetimepicker({
	dateFormat: "yy-mm-dd",
	timeFormat: "HH:mm"
});
$('input#pioneer_uploaded_at').datetimepicker({
	dateFormat: "yy-mm-dd",
	timeFormat: "HH:mm"
});

if ($('input#pioneer_approved').is(':checked')) {
	$('div.approved_date_container').show();
};

$('input#pioneer_approved').on('click', function(){
	var is_checked = $(this).is(':checked');
	var approved_date_container = $('div.approved_date_container');
	var approved_at_input = $('input#pioneer_approved_at');
	if (is_checked){
		approved_date_container.slideDown();
		approved_at_input.val(get_formatted_now());
	}
	else {
		approved_date_container.slideUp();
		approved_at_input.val('');
	};
});

function get_formatted_now(){
	var now = new Date();
	var formatted_date = $.datepicker.formatDate('yy-mm-dd', now);
	var hour = now.getHours();
	var minutes = now.getMinutes();
	var time_obj = { hour: hour, minute: minutes };
	var formatted_time = $.datepicker.formatTime('HH:mm', time_obj, {});
	return formatted_date + ' ' + formatted_time
};