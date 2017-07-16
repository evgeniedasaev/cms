var audio = new Audio('/admin/notification.mp3'),
	interval,
	count = 0,
	orders = [],
	ts = Math.floor(Date.now() / 1000),

	checkLoad = function() {
		var new_ts = Math.floor(Date.now() / 1000);

		$.get('/_admin/order/preload.js', {'ts': ts}, function (data) {
			ts = new_ts;

			if (data.count > 0){
				count += data.count;
				for (var i = 0; i < data.count; i++) {
					orders.push(data.orders[i]);
				}
				audio.play();
			}

			if (count > 0) $('#preload-holder').slideDown('fast').html('<td colspan="9" style="text-align: center; background: #dfd;"><a href="">Новых заказов: ' + count + '</a></td>');
		}, 'json');
	},

	insertData = function(event) {
		event.preventDefault();

		var x = orders.length;
		for (var i = 0; i < x; i++) {
			$('#preload-holder').after(orders[i]);
		}

		$('#preload-holder').slideUp('fast').html('');
		count = 0;
		orders = [];
	};

interval =  setInterval(checkLoad, 30000);
$(document).on('click', '#preload-holder a', insertData);

// отображение статусом для массовой смены
$('#mass-order-act').change(function() {
	if ($(this).val() == 'status') $('#mass-order-status').fadeIn('fast');
	else $('#mass-order-status').fadeOut('fast');
});

// отправка формы с массовыми действиями над заказами
$('#mass-order').submit(function(event) {
	if ($('#mass-order-print').val() != '' && $('#mass-order-print option:selected').data('href')) {
		event.preventDefault();
		window.open($('#mass-order-print option:selected').data('href') + '?' + $('#mass-order table.orders input.cb:checkbox').serialize());
	} else if ($('#mass-order-act').val() != '' && $('#mass-order-act option:selected').data('href')) {
		event.preventDefault();
		window.open($('#mass-order-act option:selected').data('href') + '?' + $('#mass-order table.orders input.cb:checkbox').serialize(), ($('#mass-order-act').val() == 'distribution') ? '_self' : '_blank');
	}
});