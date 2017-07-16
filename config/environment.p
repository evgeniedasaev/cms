##############################################################################
#
##############################################################################

$CONFIG:queue_logger_level[
	$.mailing_queue[ERROR]
	$.mailing_campaign_queue[ERROR]
]

^MAIN:CLASS_PATH.append{$CONFIG:sLibPath/oauth}

^include[$CONFIG:sConfigPath/engine.p]
^include[$CONFIG:sConfigPath/rights.p]
^include[$CONFIG:sConfigPath/goods_filter.p]
^include[$CONFIG:sConfigPath/errors.p]

^include[$CONFIG:sConfigPath/seo_cases.p]
^include[$CONFIG:sConfigPath/seo_genders.p]

^include[$CONFIG:sConfigPath/social_logins.p]

^include[$CONFIG:sConfigPath/mailing_layouts.p]

^rem{*** подключение информации о платежных порталах ***}
^include[$CONFIG:sConfigPath/payment_modules.p]

$PRICE_NUMBER_FORMAT[
	$.sThousandDivider[ ]
	$.sDecimalDivider[.]
#	$.iFracLength(2)
	$.iMinLength(3)
]

$SPHINX_CONNECT[mysql://sphinx@127.0.0.1:9306?charset=utf8]

$static_version[^file::load[text;$CONFIG:sConfigPath/version.cfg]]
$self.STATIC_VERSION[^static_version.text.left(8)]

$COLOR_PROPERTY_ID(101)

$SHOP_NAME[ДомБутик]

$CATALOG_ID(11)


$PHONES[^array::create[
	$.number[+7 (499) 500-38-19]
# 		$.comment[Бесплатный для регионов РФ]
	$.is_default(1)
][
	$.number[+7 (499) 409-27-12]
# 		$.comment[Телефон в Москве]
	$.is_default(0)
]]

$default_phones[^PHONES.hash[is_default]]
$DEFAULT_PHONE_NUMBER[$default_phones.1.number]
