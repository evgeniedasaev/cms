##############################################################################
#
#	object_type_id
#		1 - ссылка на object_link_id
#		2 - ссылка на URL
#		3 и далее - на усмотрение разработчика
#
##############################################################################

@CLASS
Object

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[sort_order][
		$.type[int]
	]
	^field[thread_id][
		$.type[int]
		$.is_protected(true)
	]
	^field[parent_id][
		$.type[int]
#		$.is_protected(true)
	]
	^field[nesting][
		$.type[int]
		$.is_protected(true)
	]
	^field[name][
		$.type[string]
	]
	^field[type_id][
		$.name[object_type_id]
		$.type[int]
		$.is_protected(true)
	]
	^field[template_id][
		$.type[int]
	]
	^field[process_id][
		$.name[data_process_id]
		$.type[int]
	]
	^field[link_type_id][
		$.type[int]
		$.is_protected(true)
	]
	^field[link_to_object_id][
		$.type[int]
	]
	^field[url][
		$.type[string]
	]
	^field[permalink][
		$.type[string]
	]
	^field[full_path][
		$.type[string]
		$.is_protected(true)
	]
	^field[is_fake][
		$.type[bool]
	]
	^field[is_published][
		$.type[bool]
		$.is_protected(true)
	]
	^field[is_published_real][
		$.type[bool]
	]
	^field[auser_id][
		$.type[int]
		$.is_protected(true)
	]
	^field[dt_create][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[dt_update][
		$.type[datetime]
		$.is_protected(true)
	]
	^field[gender][
		$.type[string]
	]

	^rem{ *** валидаторы *** }
	^validates_numericality_of[thread_id][
		$.is_integer(true)
	]
	^validates_numericality_of[parent_id][
		$.is_integer(true)
	]
	^validates_numericality_of[nesting][
		$.is_integer(true)
	]
	^validates_numericality_of[type_id][
		$.is_integer(true)
	]
	^validates_numericality_of[template_id][
		$.is_integer(true)
	]
	^validates_numericality_of[process_id][
		$.is_integer(true)
	]
	^validates_numericality_of[auser_id][
		$.is_integer(true)
	]
	^validates_numericality_of[link_type_id][
		$.is_integer(true)
	]
	^validates_numericality_of[link_to_object_id][
		$.is_integer(true)
	]
	^validates_presence_of[type_id]
	^validates_presence_of[name]
#	^validates_uniqueness_of[permalink][
#		$.scope[parent_id]
#	]
	^validates_format_of[permalink][
	    $.width[^^[a-z0-9_\-]+^$]
	    $.modificator[i]
	]
	^validate_with[validate_permalink]
	^validate_with[validate_link_to_object]
	^validate_with[validate_link_to_url]
	^validate_with[validate_by_type]
	
	^rem{ *** ассоциации *** }
	^belongs_to[parent][
		$.class_name[Object]
		$.foreign_key[parent_id]
	]
	^has_many[thread][
		$.class_name[Object]
		$.primary_key[thread_id]
		$.foreign_key[thread_id]
		$.order[nesting ASC, sort_order ASC]
	]
	^has_many[childs][
		$.class_name[Object]
		$.foreign_key[parent_id]
		$.order[sort_order ASC]
	]
	^has_many[thread_childs][
		$.class_name[Object]
		$.foreign_key[thread_id]
		$.order[sort_order ASC]
	]
	^belongs_to[linked_object][
		$.class_name[Object]
		$.foreign_key[link_to_object_id]
	]
	^has_and_belongs_to_many[navigations][
		$.class_name[Navigation]
		$.join_table[object_to_navigation]
	]

	^has_and_belongs_to_many[main_navigations][
		$.class_name[Navigation]
		$.join_table[object_to_navigation]
		$.condition[main_navigations.navigation_id = 1]
	]
	^has_and_belongs_to_many[filters][
		$.class_name[GoodsProperty]
		$.join_table[filter_property]
		$.order[sort_order]
	]

	^has_many[goods][
		$.class_name[Goods]
		$.foreign_key[category_id]
		
		$.dependent[nulled]
	]	
	^has_many[seo_text_parts][
		$.class_name[SeoTextPart]
		$.foreign_key[object_id]
		$.condition[object_class = "Object"]
	]

	^has_one[object_category]

	^rem{ *** scopes *** }
	^scope[sorted][
		$.order[sort_order ASC]
	]
	^scope[published][
		$.condition[object.is_published = 1]
	]
	^scope[root][
		$.condition[parent_id = 0]
	]
	^scope[news][
		$.condition[
			object_type_id = $OBJECT_TYPES.news.id
		]
	]
	^scope[blog_root][
		$.include[childs]
		$.condition[permalink = "articles" AND object_type_id = $OBJECT_TYPES.blog.id]
		$.limit(0)
	]
	^scope[blogs][
		$.include[childs]
		$.condition[object_type_id = $OBJECT_TYPES.blog.id]
		$.order[sort_order ASC]
	]
#end @auto[]



##############################################################################
@validate_permalink[params]
	^if(def $self.permalink){
		$parents[$self.fake_stack_ids]
	
		^if($parents && ^self.CLASS.count[
			$.condition[parent_id IN (^foreach[$parents;id]{$id}[,]) AND permalink = "$self.permalink" AND object_id != ^self.id.int(0)]
		]){
			^self.errors.append[permalink_not_unique;permalink;permalink not unique]
		}
	}
#end @validate_permalink[]



##############################################################################
@validate_link_to_object[params]
	^if($self.type_id == 1 && !$self.link_to_object_id){
		^self.errors.append[link_to_object_empty;link_to_object;link_to_object empty]
	}
#end @validate_link_to_object[]



##############################################################################
@validate_link_to_url[params]
	^if($self.type_id == 2 && !def $self.url){
		^self.errors.append[url_empty;url;url empty]
	}
#end @validate_link_to_url[]



##############################################################################
@validate_by_type[params]
	^if($self.type.presence_of_permalink && !def $self.attributes.permalink){
		^self.errors.append[permalink_empty;permalink;permalink empty]
	}
#end @validate_by_type[]



##############################################################################
@GET_fake_stack_ids[]
	$result[^array::create[]]

	$parent[$self.parent_real]
	^if($parent){
		^result.add[$parent.id]
		^result.join[$parent.fake_childs_tree_ids]
	}{
		^result.add[0]
		$fakes[^Object:find[
			$.condition[site_id = ^self.site_id.int(0) AND parent_id = 0 ANd is_fake = 1]
		]]
		^foreach[$fakes;object]{
			^result.add[$object.id]
			^result.join[$object.fake_childs_tree_ids]
		}
	}
#end @GET_fake_stack_ids[]



##############################################################################
@GET_fake_childs_tree_ids[]
	$result[^array::create[]]

	^foreach[$self.childs;child]{
		^if(!$child.is_fake){^continue[]}

		^result.add[$child.id]
		^result.join[$child.fake_childs_tree_ids]
	}
#end @GET_fake_childs_tree_ids[]



##############################################################################
@GET_parent_real[]
	$result[$self.parent]
	^while($result && $result.is_fake){
		$result[$result.parent]
	}
#end @GET_parent_real[]



##############################################################################
@GET_file_path[]
	^if(def $self.full_path){
		$result[/off-line${self.full_path}]
	}{
		$result[/off-line/${self.id}]
	}
#end @GET_file_path[]



##############################################################################
@GET_type[]
	$result[$OBJECT_TYPES.[$self.type_id]]
#end @GET_type[]



##############################################################################
@GET_template[]
	^if($self.template_id){
		$result[$OBJECT_TEMPLATES.[$self.template_id]]
	}{
		$result[$OBJECT_TEMPLATES.[$self.type.template_id]]
	}
#end @GET_template[]



##############################################################################
@GET_process[]
	^if($self.process_id){
		$result[$OBJECT_PROCESSES.[$self.process_id]]
	}{
		$result[$OBJECT_PROCESSES.[$self.type.data_process_id]]
	}
#end @GET_process[]



##############################################################################
@GET_ext[]
	^if(def $self.type.class_name){
		^if(!$self.is_new){
			$mapper[^process{^$$self.type.class_name:CLASS}]
			$result[^mapper.find_by_object_id($self.id)]
		}

		^if(!def $result){
			$result[^reflection:create[$self.type.class_name;create]]
			$result.object[$self]
		}
	}{
		$result[]
	}
#end @GET_ext[]



##############################################################################
@GET_child_ids[]
	$result[$self.childs.ids]
#end @GET_child_ids[]



##############################################################################
@GET_child_tree_ids[]
	$result[^array::create[]]
	^result.add[$self.id]
	
	^self.CLASS._load_association[$self.childs][
		$.childs[
			$.childs[
				$.childs(true)
			]
		]
	]

	^foreach[$self.childs;child]{
		^result.join[$child.child_tree_ids]
	}
#end @GET_child_tree_ids[]



##############################################################################
@parent_by_nesting[iNesting]
	$result[$self.parent]

	^while($result.nesting > $iNesting){
		$result[$result.parent]
	}
#end @parent_by_nesting[]



##############################################################################
@after_update_attributes[]
	^BASE:after_update_attributes[]
	
	^if(def $self.name && !def $self.permalink && $self.type.permalink_generator){
		$self.permalink[^Urlify:urlify[$self.name]]
	}
#end @after_update_attributes[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	$self.dt_create[^date::now[]]
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]
	
#	^if(!$self.template_id){
#		$self.template_id($self.type.template_id)
#	}
	
#	^if(!$self.process_id){
#		$self.process_id($self.type.data_process_id)
#	}
	
	^rem{ *** если перемещаем к другому родителю *** }
	^if($self.parent_id != $self.parent_id_was){
		^if($self.parent_id){
			$self.site_id[$self.parent.site_id]
			$self.thread_id[$self.parent.thread_id]
			$self.nesting($self.parent.nesting + 1)
		}{
			$self.thread_id[$self.id]
			$self.nesting[0]
		}
	}
	
	^rem{ *** если задан permalink и у родителя есть full_path *** }
	^if(def $self.permalink && !$self.is_fake && (!$self.parent_real || def $self.parent_real.full_path)){
		^rem{ *** генерируем full_path относительно родителя *** }
		$self.full_path[${self.parent_real.full_path}/${self.permalink}]
	}{
		$self.full_path[]
	}
	
	^rem{ *** is_piblished *** }
	^if($self.parent_id){
		$self.is_published($self.parent.is_published && $self.is_published_real)
	}{
		$self.is_published($self.is_published_real)
	}

	^rem{ *** если изменился full_path или объект переместили *** }
	^if($self.is_published != $self.is_published_was || $self.site_id != $self.site_id_was || $self.thread_id != $self.thread_id_was || $self.nesting != $self.nesting_was || $self.is_fake != $self.is_fake_was || $self.full_path ne $self.full_path_was){
		^self.update_childs_nested_attributes[]
	}

	^rem{ *** если новый объект или переместили к другому родителю *** }
	^if($self.is_new || $self.parent_id != $self.parent_id_was){
		^rem{ *** определяем sort_order *** }
		$self.sort_order(^oSql.int{SELECT MAX(sort_order) FROM $self.table_name WHERE site_id = ^self.site_id.int(0) AND parent_id = ^self.parent_id.int(0)}[ $.default(0) ] + 1)
	}
#end @before_save[]



##############################################################################
@after_create[]
	^BASE:after_create[]

	^rem{ *** если это новый объект в корень *** }
	^if(!$self.parent_id){
		^rem{ *** обновляем thread_id *** }
		$self.thread_id[$self.id]
		$r[^self.save[]]
	}
#end @after_create[]



##############################################################################
@_destroy[]
	^rem{ *** удаляем расширенный объект *** }
	^if(def $self.ext){
		$r[^self.ext.destroy[]]
	}
	
	^rem{ *** удаляем детей *** }
	^foreach[$self.childs;object]{
		$r[^object.destroy[]]
	}
	
	^BASE:_destroy[]
#end @destroy[]



##############################################################################
#	обновляем дочерние объекты (рекурсивно)
##############################################################################
@update_childs_nested_attributes[][object]
	^foreach[$self.childs;object]{
		^rem{ *** обновляем расположение *** }
		$object.site_id[$self.site_id]
		$object.thread_id[$self.thread_id]
		$object.nesting($self.nesting + 1)

		^rem{ *** если текущий объект скрыт, то и все дочерние - тоже *** }
		$object.is_published($self.is_published && $object.is_published_real)

		^rem{ *** обновляем full_path *** }
		^if(def $object.permalink && !$object.is_fake && (!$object.parent_real || def $object.parent_real.full_path)){
			$object.full_path[${object.parent_real.full_path}/${object.permalink}]
		}{
			$object.full_path[]
		}	

		^if(!^object.save[]){
			^throw_inspect[^object.errors.array[]]
		}
		
		^if($object.is_fake){
			^object.update_childs_nested_attributes[]							^rem{ *** для фиктивных объектов вызываем принудительно для пересчета full_path *** }
		}
	}
#end @update_childs_nested_attributes[]




##############################################################################
@format_seo_name[sSeoName]
	$result[$sSeoName]

	^rem{*** если словоформа не подобралась - используем значение по-умолчанию ***}
	^if(!def $result){
		$result[$self.name]
	}
	
	^rem{*** приводим к нижнему регистру ***}
	$result[^result.lower[]]
#end @format_seo_name[]




##############################################################################
@GET_cover[]	
	^include[$CONFIG.sLibPath/file_uploader.p]
	$images[^images[$self]]
	$images_hash[^images.hash[_name]]

	^if($images_hash.cover){
		$result[$images_hash.cover]
	}{
		$result[$images.0]
	}
#end @GET_cover[]




##############################################################################
@GET_hide_series[]	
	$result(false)

	^if($self.type.id == $OBJECT_TYPES.group.id){
		$result($self.object_category && $self.object_category.hide_series)
	}
#end @GET_hide_series[]



##############################################################################
@object_file_path[object]
	$result[$object.file_path]
#end @object_file_path[]
