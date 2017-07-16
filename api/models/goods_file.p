##############################################################################
#
##############################################################################

@CLASS
GoodsFile

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[type_id][
		$.name[file_type_id]
		$.type[int]
	]
	^field[goods_id][
		$.type[int]
	]
	^field[file_file_name][
		$.type[string]
	]
	^field[image_width][
		$.type[string]
	]
	^field[image_height][
		$.type[double]
	]
	^field[title][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[is_main][
		$.type[bool]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[sort_order][
		$.type[int]
	]

	^rem{ *** ассесоры *** }

	^rem{ *** валидаторы *** }
	^validates_presence_of[goods_id]
	^validates_numericality_of[goods_id]

	^validates_presence_of[file][
		$.on[create]
	]
	^validates_file_of[file]
	^validates_file_of[image]
	^validates_image_of[image]
	^validate_with[validates_file_image]

	^rem{ *** связи *** }
	^belongs_to[type][
		$.class_name[GoodsFileType]
		$.foreign_key[type_id]
	]
	^belongs_to[goods]

#	^has_and_belongs_to_many[variations][
#		$.class_name[Goods]
#		$.join_foreign_key[goods_variation_id]
#		$.join_table[goods_file_to_goods_variation]
#	]
	^has_many[positions][
		$.class_name[ComplectToGoods]
	]

	^has_attached_file[file]
	^has_attached_image[image][
		$.field[file]
		$.thumb[
			$.0[
				$.action[resize]

				$.width[50]
				$.height[50]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.middle[
			$.0[
				$.action[resize]

				$.width[80]
				$.height[50]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.small[
			$.0[
				$.action[resize]

				$.width[250]
				$.height[157]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.eS[
			$.0[
				$.action[resize]

				$.width[50]
				$.height[42]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.L[
			$.0[
				$.action[resize]

				$.width[351]
				$.height[220]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]

		$.xS[
			$.0[
				$.action[resize]

				$.width[100]
				$.height[0]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]

			$.1[
				$.action[crop]

				$.position[center]

				$.width[50]
				$.height[50]
			]
		]
		$.for_mark[
			$.0[
				$.action[resize]

				$.width[800]
				$.height[0]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.preview[
			$.0[
				$.action[resize]

				$.width[268]
				$.height[210]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]

		$.for_gallery_S[
			$.0[
				$.action[resize]

				$.width[72]
				$.height[70]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]

			$.1[
				$.action[crop]

				$.position[center]

				$.width[72]
				$.height[70]
			]
		]

		$.for_gallery_L[
			$.0[
				$.action[resize]

				$.width[650]
				$.height[500]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
			$.1[
				$.action[watermark]

				$.image[/images/watermark.png]
				$.sPosition[bottom-right]

				$.size_control(true)
			]
		]
	]
#end @auto[]



##############################################################################
@GET_file_path[]
	$result[/off-line/goods/^eval($self.goods_id \ 1000)/${self.goods_id}/${self.id}]
#end @GET_image_file_path[]



##############################################################################
@validates_file_image[]
	$value[$self.attributes.file]
	^if(def $value && ^self.type_id.int(-1) == 0){
		^if($value is file){
			^try{
				$image[^image::measure[$value]]
			}{
				$exception.handled(true)
				^self.errors.append[file_wrong;file;file must be jpg, gif or png]
			}
		}{
			^self.errors.append[file_wrong;file;file must be jpg, gif or png]
		}
	}
#end @validates_file_image[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	^rem{ *** если новый *** }
	^if($self.is_new || $self.type_id != $self.type_id_was){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name WHERE goods_id = $self.goods_id AND file_type_id = ^self.type_id.int(0)}[ $.default(0) ] + 1)
	}

	$other_image_count(^self.CLASS.count[
		$.condition[
			file_type_id = 0 AND
			goods_id = $self.goods_id AND
			goods_file_id != ^self.id.int(0)
		]
	])

	^if(($self.is_new && !$self.type_id && !$other_image_count) || ($other_image_count == 0) || (!$self.is_main && $self.is_main_was)){
		$self.is_main(true)
	}
#end @before_save[]



##############################################################################
@after_save[]
	^BASE:after_save[]

	^rem{ *** если изображение и сделано "главным" изображением *** }
	^if(!$self.type_id && $self.is_main && $self.is_main != $self.is_main_was){
		^rem{ *** сбрасываем у остальных флаг "главного" изображения *** }
		^self.CLASS.update_all[
			$.is_main(false)
		][
			$.condition[
				goods_id = $self.goods_id AND
				goods_file_id != $self.id AND
				file_type_id = 0
			]
		]
	}

	^if(!$self.type_id){
		^self.image.delete_resizes[]
	}

	^rem{ *** если изображения товара и переданы связи с вариантами *** }
#	^if(!$self.type_id && !($self.attributes.variations_list is "void")){
#		$variaiton_ids[$self.attributes.variations_list]
#		$variations[^Goods:find[$variaiton_ids]]

#		^if($variations){
#			^rem{ *** записываем связи с вариантами *** }
#			$self.variations[$variations]
#		}{
#			^rem{ *** удаляем связи с варианнтами *** }
#			^self.variations.clear[]
#		}
#	}
#end @after_save[]



##############################################################################
@after_destroy[]
	^BASE:after_destroy[]

	^rem{ *** выбор нового главного изображения при удалении старого *** }
	^if(!$self.type_id && $self.is_main){
		$goods_file[^self.CLASS.first(1)[
			$.condition[
				goods_id = $self.goods_id AND
				goods_file_id != $self.id AND
				file_type_id = 0
			]
		]]

		^if($goods_file){
			^if(!^goods_file.update_attributes[ $.is_main(true) ]){
				^oLogger.info{ERROR to set main image for goods $goods_file.goods_id while deleting image for goods $self.goods_id}
				^throw[ErrorGoodsImage;GoodsImage#UpdateError;Error while setting main image]
			}
		}
	}
#end @after_destroy[]
