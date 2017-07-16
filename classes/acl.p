##############################################################################
#
##############################################################################

@CLASS
ACL

@OPTIONS
locals

@BASE
Environment



##############################################################################
@auto[]
	$self.FULL_GRAND_ACCESS(1)

	^rem{ *** Деревья кэширующие права по user_id -> object_type_id -> object_id -> [ UserRight ] *** }
	$self.USER_RIGHTS[^hash::create[]]					^rem{ *** полные собранные права по user_id *** }
	
	$self.ROLES[^Role:find[
		$.include[rights]
	]]
	$self.ROLES[^self.ROLES.hash[name]]
#end @auto[]



##############################################################################
@mask[id]
	$result(^math:pow(2;$id))
#end @mask[]



##############################################################################
#	user
#	action
#	object_type
#	object
#	roles - дополнительные роля, назначенные по логике
##############################################################################
@check_rights[user;action;object_type;object;roles]
	^if(!def $action){
		^throw[parser.runtime;ACL:check_rights;no action specify]
	}
	^if(!def $object_type){
		^throw[parser.runtime;ACL:check_rights;no object_type specify]
	}
	^if(!def $object){
		$object[0]
	}
	
	$result(false)

	$allow(0)
	$deny(0)
	
#	$user_rights[^user_object_right[$user][$object_type;$object]]
#	$allow($allow | $user_rights.allow)
#	$deny($deny | $user_rights.deny)
	
	^foreach[$user.roles;role]{
		$role_rights[^user_object_right[$role][$object_type;$object]]
		$allow($allow | $role_rights.allow)
		$deny($deny | $role_rights.deny)
	}
	
	^foreach[$roles;role]{
		$role_rights[^user_object_right[$role][$object_type;$object]]
		$allow($allow | $role_rights.allow)
		$deny($deny | $role_rights.deny)
	}
	
	^if($self.ROLES.guest){
		$guest_rights[^user_object_right[$self.ROLES.guest][$object_type;$object]]
		$allow($allow | $guest_rights.allow)
		$deny($deny | $guest_rights.deny)
	}
	
	^if($deny & $self.FULL_GRAND_ACCESS){
		$result(false)															^rem{ *** полный запрет доступа по 1 *** }
	}{	
		$result($allow & ~$deny & (^mask($RIGHTS.[$object_type].rights.[$action].id) | $self.FULL_GRAND_ACCESS))
	}
#end @check_rights[]



##############################################################################
@user_object_right[user;object_type;object]
	$rights[^user_rights[$user]]

	$allow(^rights.[$object_type].[0].allow.int(0))
	$deny(^rights.[$object_type].[0].deny.int(0))

	^if(def $object){
		$allow($allow | ^rights.[$object_type].[$object].allow.int(0))
		$deny($deny | ^rights.[$object_type].[$object].deny.int(0))
	}
	
	$result[
		$.allow[$allow]
		$.deny[$deny]
	]
#end @user_object_right[]



##############################################################################
@user_rights[user]
	^if(!^self.USER_RIGHTS.contains[$user.id]){
		$self.USER_RIGHTS.[$user.id][^user.rights.tree[object_type;object_id]]
	}
		
	$result[$self.USER_RIGHTS.[$user.id]]
#end @user_rights[]