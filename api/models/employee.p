##############################################################################
#
##############################################################################

@CLASS
Employee

@OPTIONS
locals

@BASE
Person



##############################################################################
@auto[]
	^BASE:auto[]
	
	^rem{ *** ассесоры *** }
	^field_accessor[passwd_confirmation]
#	^field_accessor[avatar]

	^rem{ *** ассоциации *** }

	^rem{ *** валидаторы *** }
#	^validates_presence_of[name]
#end @auto[]



##############################################################################
#	Номер устройства пользователя для звонков
##############################################################################
@device_number[][result]
	^if(!def $self._device_contact){
		$self._device_contact[^self.contacts.find_first[
			$.condition[type_id = $UserContact:TYPE.phone.id AND value != ""]
			$.order[LENGTH(value) ASC]
		]]
	}

	$result[$self._device_contact.value]
#end @device_number[]
