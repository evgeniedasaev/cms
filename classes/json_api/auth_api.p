##############################################################################
#
##############################################################################

@CLASS
AuthApi

@USE
json_api/auth.p

@OPTIONS
locals



##############################################################################
@create[hParams;sVersion]
	$self.auth[^Auth::create[$hParams.tokean]]
    
    $self.login[$hParams.login]
    $self.passwd[$hParams.passwd]
#end @create[]



##############################################################################
@logon[]
    $result[
        $.data[$NULL]
        $.errors[^array::create[]]
    ]

    ^rem{ *** авторизация пользователя *** }
	^if(def $self.login && def $self.passwd){		
		^self.auth.logon[$self.login;$self.passwd]
	}

    ^rem{ *** пользователя не удалось авторизовать *** }
	^if($self.auth.user.isGuest){		
		^result.errors.add[
            $.msg[check_login_and_password]
        ]
	}
    
    ^rem{ *** пользователя удалось авторизовать - возвращаем токен *** }
    ^if(!$self.auth.user.isGuest && $self.auth.session){        
        $result.data[
            $.id[$self.auth.user.id]
            $.type[auth]
            $.attributes[
                $.name[$self.auth.user.name]
                $.authTokean[$self.auth.session.sid]
                $.userTitle[$self.auth.user.employee_title]
                $.userPosition[$self.auth.user.position]
                $.userCompany[$self.auth.user.company]
            ]
        ]
    }
#end @logon[]



##############################################################################
@logout[]    
    ^self.auth.logout[]
    
	$result[
        $.data[
            $.id[$self.auth.user.id]
            $.type[$self.auth.user.table_name]
        ]
        $.errors[^array::create[]]
    ]
#end @logon[]