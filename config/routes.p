##############################################################################
#	Default routing
##############################################################################

	^oMap.application[api;api]
	
	^rem{ *** default rule *** }
	^oMap.connect[/:controller/:action/:id.:format]
