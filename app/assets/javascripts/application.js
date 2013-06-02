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
//= require jquery-ui.min
//= require jquery.NobleCount.min
//= require jquery.autogrowtextarea
//= require bootstrap.min
//= require bootstrap
//= require jquery-ui-timepicker-addon
//= require jquery-ui-sliderAccess
//= require jquery-ui-timepicker-ru
//= require_tree .

$(document).ready(function(){
	document.cookie = 'jstz_time_zone='+jstz.determine().name()+';';
});

$.datepicker.regional['ru'] = {
	closeText: 'Закрыть',
	prevText: '<Пред',
	nextText: 'След>',
	currentText: 'Сегодня',
	monthNames: ['Январь','Февраль','Март','Апрель','Май','Июнь',
	'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'],
	monthNamesShort: ['Янв','Фев','Мар','Апр','Май','Июн',
	'Июл','Авг','Сен','Окт','Ноя','Дек'],
	dayNames: ['воскресенье','понедельник','вторник','среда','четверг','пятница','суббота'],
	dayNamesShort: ['вск','пнд','втр','срд','чтв','птн','сбт'],
	dayNamesMin: ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'],
	weekHeader: 'Не',
	dateFormat: 'dd.mm.yy',
	firstDay: 1,
	isRTL: false,
	showMonthAfterYear: false,
	yearSuffix: ''
};
$.datepicker.setDefaults($.datepicker.regional['ru']);

function time_zone_info() {
	return 'Часовой пояс определен автоматически. Если часовой пояс определен неверно, попробуйте выйти и зайти заново. В случае проблем, обращайтесь на support[at]idlast.com';
};

$('#timezone-info').tooltip({
	html: true,
	title: time_zone_info(),
	placement: 'bottom'
});