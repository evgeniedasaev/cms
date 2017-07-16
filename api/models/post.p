##############################################################################
#
##############################################################################

@CLASS
Post

@OPTIONS
locals

@BASE
ActiveModel



##############################################################################
@auto[]
	^BASE:auto[]

	^rem{ *** аттрибуты *** }
	^field[blog_id][
		$.type[int]
	]
	^field[permalink][
		$.type[string]
	]
	^field[title][
		$.type[string]
	]
	^field[image_file_name][
		$.type[string]
	]
	^field[description][
		$.type[string]
	]
	^field[lead][
		$.type[string]
	]
	^field[body][
		$.type[string]
	]
	^field[source_url][
		$.type[string]
	]
	^field[is_published][
		$.type[bool]
	]
	^field[auser_id][
		$.type[int]
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

	^rem{ *** валидаторы *** }
# 	^validates_presence_of[auser_id]
	^validates_presence_of[blog_id]
	^validates_presence_of[title]
	^validates_presence_of[permalink][
		$.on[update]
	]
	^validates_uniqueness_of[permalink][
		$.scope[blog_id]
	]
	^validates_format_of[permalink][
		$.width[^^[a-z0-9_\-]+^$]
		$.modificator[i]
	]
	^validates_file_of[image]
	^validates_image_of[image]	

	^rem{ *** ассоциации *** }
	^belongs_to[blog][
		$.class_name[Object]
		$.foreign_key[blog_id]
	]
	^has_and_belongs_to_many[tags][
		$.class_name[Tag]
		$.join_table[post_to_tag]
	]

	^has_attached_image[image][
		$.is_deletable(true)

		$.S[
			$.0[
				$.action[resize]

				$.width[170]
				$.height[136]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.xS[
			$.0[
				$.action[resize]

				$.width[80]
				$.height[50]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]
		$.M[
			$.0[
				$.action[resize]

				$.width[270]
				$.height[218]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]
		]		
		$.L[
			$.0[
				$.action[resize]

				$.width[900]
				$.height[1500]
				$.bKeepRatio(true)
				$.sResizeType[decr]
			]			
		]
	]

	^scope[published][
		$.condition[post.is_published = 1]
	]
	^scope[sorted][
		$.order[post.dt DESC]
	]
#end @auto[]



##############################################################################
@GET_file_path[]
	$result[/off-line/${self.table_name}/${self.id}]
#end @GET_file_path[]



##############################################################################
@before_create[]
	^BASE:before_create[]

	^if(!def $self.dt_create){
		$self.dt_create[^date::now[]]
	}

	^if(!def $self.permalink){
		^rem{ *** генерируем permalink путем транслита названия и удаления запрещенных символов *** }
		$self.permalink[^Urlify:urlify[$self.title]]
	}
#end @before_create[]



##############################################################################
@before_save[]
	^BASE:before_save[]

	$self.dt_update[^date::now[]]

	^if(!def $self.dt){
		$self.dt[^date::now[]]
	}
#end @before_save[]



##############################################################################
@after_destroy[]
	^BASE:after_destroy[]

	^if(-d $self.file_path){
		^use[FileSystem.p]
		^FileSystem:dirDelete[$self.file_path][
			$.bRecursive(true)
		]
	}
#end @after_destroy[]
