##############################################################################
#
##############################################################################

@CLASS
SeoTextPart

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{*** поля ***}
	^field[object_class][
		$.type[string]
	]
	^field[object_id][
		$.type[int]
	]
	^field[case_name][
		$.type[string]
	]
	^field[name_femenine][
		$.type[string]
	]
	^field[name_masculine][
		$.type[string]
	]
	^field[name_neuter][
		$.type[string]
	]
	^field[name_multiple][
		$.type[string]
	]

	^rem{*** аксессоры ***}

	^rem{*** валидаторы ***}
	^validates_presence_of[object_class]
	^validates_presence_of[object_id]
	^validates_presence_of[case_name]
	^validate_with[name_validator]
# 	^validate_with[uniqueness]

	^rem{*** ассоциации ***}
# 	^belongs_to[group][
# 		$.foreign_key[object_id]
# 		$.class_name[Object]
# 		$.condition[group.object_class = "Object"]
# 	]
# 	^belongs_to[type][
# 		$.foreign_key[object_id]
# 		$.class_name[GoodsType]
# 		$.condition[group.object_class = "GoodsType"]
# 	]
# 	^belongs_to[property_value][
# 		$.foreign_key[object_id]
# 		$.class_name[GoodsPropertyPosibleValue]
# 		$.condition[group.object_class = "GoodsPropertyPosibleValue"]
# 	]
#end @auto[]



##############################################################################
@name_validator[hParams]
	^if(!def $self.name_femenine && !def $self.name_masculine && !def $self.name_neuter && !def $self.name_multiple){
		^self.errors.append[name;name_empty;Укажите поля для seo-генератора]
	}
#end of @name_validator[]



##############################################################################
@uniqueness[hParams]
	^if(^SeoTextPart:count[
		$.condition[object_class = "$self.object_class" AND object_id = $self.object_id AND case_name = "$self.case_name"]
	]){
		^self.errors.append[seo_text_part;seo_text_part_uniqueness;Такая запись уже существует]
	}
#end of @uniqueness[]



##############################################################################
@part_for_text[sGender]
	$result[$self.[name_${sGender}]]
	^if(!def $result){	$result[$self.name_femenine]	}
	^if(!def $result){	$result[$self.name_masculine]	}
	^if(!def $result){	$result[$self.name_neuter]	}
	^if(!def $result){	$result[$self.name_multiple]	}
#end @part_for_text[]
