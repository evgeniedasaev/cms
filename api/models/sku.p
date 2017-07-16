##############################################################################
#
##############################################################################

@CLASS
SKU

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[goods_id][
		$.type[int]
	]
	^field[vendor_id][															^rem{ *** поставщик *** }
		$.type[string]
	]
	^field[uid][																^rem{ *** код SKU *** }
		$.type[string]
	]
	^field[code][																^rem{ *** артикул *** }
		$.type[string]
	]
	^field[name][
		$.type[string]
	]
	^field[price_cur][
		$.type[double]
	]
	^field[old_price_cur][
		$.type[double]
	]
	^field[cost_cur][
		$.type[double]
	]
	^field[in_stock][															^rem{ *** остаток *** }
		$.type[int]
	]
	^field[is_published][														^rem{ *** опубликовано *** }
		$.type[bool]
	]
	
	^rem{ *** TODO: минимальный остаток *** }
	^rem{ *** TODO: вес *** }
	^rem{ *** TODO: объем *** }
	
	^rem{ *** TODO: тип фасовки (по штуке / по несколько) и сколько в упаковок и сколько упаковок *** }
	
	^rem{ *** TODO: форма подтверждения *** }

	^field[dt_create][
		$.type[date]
		$.is_protected(true)
	]
	^field[dt_update][
		$.type[date]
		$.is_protected(true)
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[uid]	
	^validates_presence_of[name]
	^validates_uniqueness_of[uid][
		$.scope[vendor_id]
	]

	^rem{ *** связи *** }
	^belongs_to[goods][	
 		$.touch[update_by_sku]
	]
	^belongs_to[vendor]
	^has_many[properties][
		$.foreign_key[sku_id]
		$.class_name[SkuProperty]
		$.order[code]

		$.dependent[destroy]
		
		$.inverse_of[SKU]
	]
	^has_many[files][
		$.foreign_key[sku_id]
		$.class_name[SkuFile]
		
		$.dependent[destroy]
		
		$.inverse_of[SKU]		
	]
#end @auto[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.code){
		$self.code[^Urlify:urlify[$self.name]]
	}
	
	$self.dt_create[^date::now[]]

#	^if(!def $self.uid){
#		^self.make_uid[]
#	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]
	
	$self.dt_update[^date::now[]]
#end @before_save[]



##############################################################################
@make_uid[]
	$self.uid[^if(def $self.code){$self.code}{^math:md5[$self.name]}]
#end @make_uid[]



##############################################################################
@GET_code_for_goods[]
	$result[$self.code]
#end @GET_code_for_goods[]



##############################################################################
@GET_public_price[]
	$result[$self.price_cur]
#end @GET_public_price[]



##############################################################################
@GET_cost[]
	$result[$self.cost_cur]
#end @GET_cost[]



##############################################################################
@GET_delivery_days[]
	$result[$self.vendor.delivery_days]
#end @GET_delivery_days[]
