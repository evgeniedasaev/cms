##############################################################################
#
##############################################################################

@CLASS
AdminApplication



##############################################################################
@run[]
    $STATIC_VERSION[49a461d1]

    $DEFAULT_TITLE[DAC CMS 3.0]
    $DEFAULT_DESCRIPTION[]

    <!DOCTYPE html>
    <html lang="ru">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=$request:charset" />
        <title>$DEFAULT_TITLE</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="$DEFAULT_DESCRIPTION">
        <meta name="author" content="Dasaev Eugenie, jackensteiny@gmail.com">
        
        <link type="text/css" rel="stylesheet" href="/admin/css/jquery-ui.min.css?$STATIC_VERSION">
        
        <link type="text/css" rel="stylesheet" href="/admin/css/bootstrap.min.css?$STATIC_VERSION" media="screen">
        <link type="text/css" rel="stylesheet" href="/admin/css/bootstrap-responsive.css?$STATIC_VERSION">

        <link rel="stylesheet" href="/admin/css/font-awesome.min.css?$STATIC_VERSION">

        <script type="text/javascript" src="/admin/js/jquery.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/jquery-ui.min.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/jquery.mousewheel.pack.js?$STATIC_VERSION"></script>
        
        <link rel="stylesheet" href="/admin/css/jquery.fancybox.css?$STATIC_VERSION" type="text/css" media="screen" />
        <script type="text/javascript" src="/admin/js/jquery.fancybox.pack.js?$STATIC_VERSION"></script>

        <script type="text/javascript" src="/admin/js/bootstrap.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/bootstrap.tab.submenu.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/bootstrap-button-disselectable.js?$STATIC_VERSION"></script>
        
        <script type="text/javascript" src="/admin/js/jquery.form.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/jquery.blockUI.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/jquery.autoresize.js?$STATIC_VERSION"></script>
        
        <script type="text/javascript" src="/admin/js/jquery.jeditable.js?$STATIC_VERSION" charset="utf-8"></script>
        
        <script type="text/javascript" src="/admin/js/date.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/date_ru_utf8.js?$STATIC_VERSION"></script>
        
        <!--[if IE]><script type="text/javascript" src="/admin/js/jquery.bgiframe.js?$STATIC_VERSION"></script><![endif]-->

        <script type="text/javascript" src="/admin/js/select2/select2.js?$STATIC_VERSION"></script>	
        <link rel="stylesheet" href="/admin/js/select2/select2.css?$STATIC_VERSION" />

        <script type="text/javascript" src="/admin/js/bootstrap-datepicker.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/locales/bootstrap-datepicker.ru.js?$STATIC_VERSION"></script>	
        <link rel="stylesheet" href="/admin/css/datepicker.css?$STATIC_VERSION" type="text/css" />

        <script type="text/javascript" src="/admin/js/moment-with-locales.min.js?$STATIC_VERSION"></script>

        <script type="text/javascript" src="/admin/js/dac_scroller.js?$STATIC_VERSION"></script>

        <link rel="stylesheet" media="screen" type="text/css" href="/admin/js/colorpicker/css/colorpicker.css?$STATIC_VERSION" />
        <script type="text/javascript" src="/admin/js/colorpicker/js/colorpicker.js?$STATIC_VERSION"></script>

        <script type="text/javascript" src="/admin/$params.application/js/jquery.mask.min.js?$STATIC_VERSION"></script>

        <script type="text/javascript" src="/admin/js/common.js?$STATIC_VERSION"></script>

        <link rel="stylesheet" media="screen" type="text/css" href="/admin/js/fileupload/fileupload.css?$STATIC_VERSION" />
        <script type="text/javascript" src="/admin/js/fileupload.js?$STATIC_VERSION"></script>

        <link rel="stylesheet" href="/admin/css/rateit/rateit.css?$STATIC_VERSION">
        <script type="text/javascript" src="/admin/js/jquery.rateit.min.js?$STATIC_VERSION"></script>

        <script type="text/javascript" src="/admin/js/tag-it/tag-it.min.js?$STATIC_VERSION"></script>
        <link href="/admin/css/tag-it/jquery.tagit.css?$STATIC_VERSION" rel="stylesheet" type="text/css">
        <link href="/admin/css/tag-it/tagit.ui-zendesk.css?$STATIC_VERSION" rel="stylesheet" type="text/css">
        
        <script type="text/javascript" src="/admin/js/clipboard.min.js?$STATIC_VERSION"></script>

        <link type="text/css" rel="stylesheet" href="/admin/css/main.css?$STATIC_VERSION"/>

        <link rel="stylesheet" href="/admin/css/react-select.min.css?$STATIC_VERSION">
    </head>
    <body>
        <div id="app"></div>

        <script type="text/javascript" src="/admin/js/order_preloader.js?$STATIC_VERSION"></script>
        <script type="text/javascript" src="/admin/js/main.js?$STATIC_VERSION"></script>
    </body>
    </html>
#end of @run[]
