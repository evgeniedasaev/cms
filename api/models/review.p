##############################################################################
#
##############################################################################

@CLASS
Review

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	$self.RATING[
		$.0[Без оценки]
		$.1[Очень плохо]
		$.2[Плохо]
		$.3[Удовлетворительно]
		$.4[Хорошо]
		$.5[Отлично]
	]

	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[session_id][
		$.type[int]
	]
	^field[user_id][
		$.type[int]
	]
	^field[user_name][
		$.type[string]
	]
	^field[user_email][
		$.type[string]
	]
	^field[rating][
		$.type[int]
	]
	^field[pros][
		$.type[string]
	]
	^field[cons][
		$.type[string]
	]
	^field[comment][
		$.type[string]
	]
	^field[answer][
		$.type[string]
	]
	^field[order_n][
		$.type[string]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[manager_id][
		$.type[int]
	]
	^field[ip][
		$.type[string]
	]
	^field[dt][
		$.type[date]
	]
	^field[dt_create][
		$.type[date]
	]
	^field[dt_update][
		$.type[date]
	]

	^rem{ *** ассесоры *** }
	^field_accessor[publish_manager]

	^rem{ *** валидаторы *** }
	^validates_presence_of[user_name]
	^validates_presence_of[user_email]
	^validates_format_of[user_email][
		$.width[^^(?:[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+(?:\.[-a-z\d\+\*\/\?!{}`~_%&'=^^^$#]+)*)@(?:[-a-z\d_]+\.){1,60}[a-z]{2,6}^$]
		$.modificator[i]
	]
	^validate_with[validate_text_fields]

	^rem{ *** ассоциации *** }
	^belongs_to[user]

	^scope[published][
		$.condition[is_published = 1]
	]
	^scope[sorted][
		$.order[dt DESC]
	]
#end @auto[]



##############################################################################
@before_validate[]
	^BASE:before_validate[]

	$self.pros[^self.pros.trim[]]
	$self.cons[^self.cons.trim[]]
	$self.comment[^self.comment.trim[]]
	$self.answer[^self.answer.trim[]]
#end @before_validate[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt){
		$self.dt[^date::now[]]
	}
	$self.dt_create[^date::now[]]

	^self.save_ip[]
#end @before_create[]



##############################################################################
@save_ip[]
	$self.ip[$env:REMOTE_ADDR^if(def $env:HTTP_X_REAL_IP){, $env:HTTP_X_REAL_IP}^if(def $env:HTTP_X_FORWARDED_FOR){, $env:HTTP_X_FORWARDED_FOR}]
#end @save_ip[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^self.save_manager[]
#end @before_save[]



##############################################################################
@save_manager[]
	^if($self.is_published && !$self.is_published_was && $self.publish_manager){
		$self.manager_id($self.publish_manager)
	}
#end @save_manager[]



##############################################################################
@validate_text_fields[hParams]
	^if(!def $self.pros && !def $self.cons && !def $self.comment){
		^self.errors.append[text_fields_empty;text_fields;all text fields are empty]
	}
#end @validate_text_fields[]



##############################################################################
@GET_review_preview[]
	$result[$self.comment]

	^if(!def $result && def $self.pros){
		$result[$self.pros]
	}
	^if(!def $result && def $self.cons){
		$result[$self.cons]
	}

	$result[^result.left(50)^if(^result.length[] > 50){&hellip^;}]
#end @GET_review_preview[]
