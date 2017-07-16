##############################################################################
#
##############################################################################

@CLASS
GoodsSerieImage

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[goods_serie_id][
		$.type[int]
	]
	^field[image_file_name][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[is_main][
		$.type[bool]
	]

	^rem{ *** ассесоры *** }
	
	^rem{ *** валидаторы *** }
	^validates_presence_of[image][
		$.on[create]
	]
	^validate_with[validates_file_image]
	^validates_file_of[image]
	^validates_image_of[image]

	^rem{ *** ассоциации *** }
	^belongs_to[goods_series][
		$.class_name[GoodsSerie]
	]
	^has_many[positions][
		$.class_name[GoodsSerieImageToGoods]
	]

 	^has_attached_image[image][
		$.thumb[
			$.0[
				$.action[resize]

				$.width[50]
				$.height[50]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]

		$.S[
			$.0[
				$.action[resize]

				$.width[200]
				$.height[200]
				$.bKeepRatio(true)
				$.sResizeType[decr]
				
				$.iQuality(80)
			]
		]

		$.preview[
			$.0[
				$.action[resize]

				$.width[268]
				$.height[172]
				$.bKeepRatio(true)
				$.sResizeType[decr]
				
				$.iQuality(80)
			]
		]
		
		$.L[
			$.0[
				$.action[resize]

				$.width[500]
				$.height[0]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
			$.1[
				$.action[crop]

				$.position[center]
			
				$.width[500]
				$.height[300]
				
				$.iQuality(80)
			]
		]
		$.xL[
			$.0[
				$.action[resize]

				$.width[900]
				$.height[400]

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
		$.for_mark[
			$.0[
				$.action[resize]

				$.width[800]
				$.height[0]

				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
	]

	^rem{*** скоупы ***}
	^scope[published][
		$.condition[is_published = 1]
	]
#end @auto[]



##############################################################################
@validates_file_image[]
	$value[$self.attributes.file]

	^if(def $value && $self.type_id == 0){
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
	
	^rem{ *** обновляем сгенерированные изображения *** }
	^self.image.delete_resizes[]
#end @before_save[]



##############################################################################
@after_save[]
	^BASE:after_save[]

	^rem{ *** если изображение и сделано "главным" изображением *** }
	^if($self.is_main != $self.is_main_was){
		^if($self.is_main){
			^rem{ *** сбрасываем у остальных флаг "главного" изображения *** }
			^self.CLASS.update_all[
				$.is_main(false)
			][
				$.condition[goods_serie_id = $self.goods_serie_id AND goods_serie_image_id != $self.id]
			]
		}{
			$first_photo[^self.CLASS.first(1)[]]
			^if($first_photo){
				^self.CLASS.update_all[
					$.is_main(true)
				][
					$.condition[goods_serie_image_id = $first_photo.id]
				]
			}
		}
	}
#end @after_save[]
