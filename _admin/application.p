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
        <meta charset="utf-8">
        <title>$DEFAULT_TITLE</title>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="description" content="$DEFAULT_DESCRIPTION">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <base href="/" />
        <!--  -->
        <!-- XXX:FaviconsWebpackPlugin doesn't generate meta content below: -->
        <!-- Disable tap highlight on IE -->
        <meta name="msapplication-tap-highlight" content="no">
        <!-- Web Application Manifest -->
        <link rel="manifest" href="manifest.json">
        <!--  -->
        <!-- META TAG THAT IS REPLACED WITH INLINE STYLES IN SSR -->
        <meta name="ssr-styles"/>

        <link rel="stylesheet" href="/admin/css/react-select.min.css?$STATIC_VERSION">
    </head>
    <body>
        <noscript>
        You are using outdated browser. You can install modern browser here: <a href="http://outdatedbrowser.com/" >http://outdatedbrowser.com</a>.
        </noscript>
        <div id="app"></div>

        <script type="text/javascript" src="/admin/js/main.js?$STATIC_VERSION"></script>
    </body>
    </html>
#end of @run[]
