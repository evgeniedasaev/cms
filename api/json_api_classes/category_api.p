##############################################################################
#
##############################################################################

@CLASS
CategoryApi

@USE
json_api/json_api.p

@OPTIONS
locals

@BASE
JsonApi



##############################################################################
# Определяем resource
##############################################################################
@define_resource[]
	$result[^Object:all[
		$.condition[thread_id = 11 AND object_type_id = 4]
		$.order[parent_id ASC, nesting ASC]
	]]
#end @define_resource[]
