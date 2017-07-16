##############################################################################
#	
##############################################################################

@CLASS
MailingMail

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[uuid][
		$.type[string]
	]
	^field[mailing_campaign_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}

	^rem{*** ассоциации ***}		
	^belongs_to[mailing_campaign]
	^belongs_to[user]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.uuid){
		$self.uuid[^self.generate_message_id_header[]]
	}
#end @before_create[]



##############################################################################
# Метод генерирует Message-Id заголовок письма
##############################################################################
@generate_message_id_header[]
	$now[^date::now[]]
	$time_part[^convertN[^now.unix-timestamp[];36;0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ]]

	$random_number_part[^math:uid64[]]
	
	$result[<${time_part}.${random_number_part}@${env:SERVER_NAME}>]
#end @generate_message_id_header[]



##############################################################################
# Конвертация из одной системы исчисления в любую другую
##############################################################################
@convertN[n;base;digits]
	$result[]
	^while($n>=$base){
		$new(^math:trunc($n/$base))
		$result[^digits.mid($n-$new*$base;1)$result]
		$n($new)
	}
	$result[^digits.mid($n;1)$result]
#end @convertN[]