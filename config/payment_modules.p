$CURRENT_PAYMENT_MODULE_CODE[platron]

$PAYMENT_MODULES[
	$.platron[
		$.id(1)
		$.code[platron]
		$.name[Платрон]
		$.controller[platron_payment]
		$.url[https://www.platron.ru/payment.php]
	]
]
$CURRENT_PAYMENT_MODULE[$PAYMENT_MODULES.[$CURRENT_PAYMENT_MODULE_CODE]]