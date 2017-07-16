/*
    Плагин DAC для подгрузки товаров по скроллу страницы.
    Принимает следующие опции:
        catalogContainer - блок- контейнер для каталога
        loader - блок для анимации подгрузки
        randowCoeff - коэффициент запаздывания подгрузки (по-умолчанию 6)
        scrollBlock - блок, задающий уровень начала прокрутки
        link - класс ссылки для получения значений (например, активный элемент постранички)
        link - ссылка на скрипт, возвращающий подгружаемый список
    Каллбэки:
        before_send_callback - перед подгрузкой
        error_callback - - в случае ошибки подгрузки
        success_callback - после успешной подгрузки
        complete_callback - по заверщении подгрузки
*/

function dacScroller (options) {
    this.wrapper = options.wrapper;
    this.catalogContainer = options.catalogContainer;
    this.loader = options.loader;

    this.wrapper =(typeof options.wrapper !== 'undefined') ? options.wrapper : $(window);

    this.randowCoeff = (typeof options.randowCoeff !== 'undefined') ? options.randowCoeff : 6;
    this.scrollBlock = (typeof options.scrollBlock !== 'undefined')  ? options.scrollBlock : [];
    this.link = (typeof options.link !== 'undefined')  ? options.link : [];
    this.url = (typeof options.url !== 'undefined')  ? options.url : '';

    this.before_send_callback = (typeof options.before_send_callback !== 'undefined')  ? options.before_send_callback : function(data, self){};
    this.error_callback = (typeof options.error_callback !== 'undefined')  ? options.error_callback : function(data, self){};
    this.success_callback = (typeof options.success_callback !== 'undefined')  ? options.success_callback : function(data, self){};
    this.complete_callback = (typeof options.complete_callback !== 'undefined')  ? options.complete_callback : function(data, self){};

    this.isGoodsLoading = true;

    this.loader.hide();

    this.wrapper.scroll($.proxy( this.init_scroll, this ));
}

dacScroller.prototype = {
    update_catalog: function() {
        var self = this;
        var url = (self.link.length && self.link.attr('href') !== '#') ? (self.link.attr('href') + '&format=js') : self.url

        if (url !== '') {
            $.ajax({
                dataType: 'json',
                url: url,
                beforeSend: function (data) {
                    self.before_send_callback(data, self);

                    self.loader.show();
                    self.isGoodsLoading = false;
                },
                error: function (data) {
                    self.error_callback(data, self);
                },
                success: function (data) {
                    if (parseInt(data.max_page) >= parseInt(data.pageNum))
                        self.catalogContainer.append(data.html);

                    self.success_callback(data, self);
                },
                complete: function(data) {
                   self.complete_callback(data, self);

                    self.loader.hide();
                    self.isGoodsLoading = true;
                    self.reinit();
                }
            });
        }

        return false;
    },
    init_scroll: function (e) {
        if (this.scrollBlock.length) {
            if (self.pageYOffset){
                yScroll = self.pageYOffset;
            } else if (document.documentElement && document.documentElement.scrollTop){
                yScroll = document.documentElement.scrollTop;
            } else if (document.body){
                yScroll = document.body.scrollTop;
            }

            if (self.innerHeight) {
                windowHeight = self.innerHeight;
            } else if (document.documentElement && document.documentElement.clientHeight) {
                windowHeight = document.documentElement.clientHeight;
            } else if (document.body) {
                windowHeight = document.body.clientHeight;
            }

            /*
                смещение, которое обеспечивает задержку вызова события по достижению скроллом элемента, вычисляется 
                пропорционально экрану устройства
            */
            scrollCoeff = - windowHeight/this.randowCoeff;

            if ((this.scrollBlock.offset().top <= yScroll - scrollCoeff + windowHeight) && this.isGoodsLoading) {
                this.update_catalog();
            }
        }
    },
    reinit: function() {
        this.wrapper = $(this.wrapper.selector);
        this.catalogContainer = $(this.catalogContainer.selector);
        this.loader = $(this.loader.selector);
        this.scrollBlock = $(this.scrollBlock.selector);
        this.link = $(this.link.selector);
    }
}
