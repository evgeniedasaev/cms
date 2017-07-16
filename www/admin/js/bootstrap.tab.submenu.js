!function ($) {
	"use strict"; // jshint ;_;

	// сохраняем оригинальный класс button как суперкласс
	var _super = $.fn.tab

	// создаем новый конструктор
	var TabSubmenu = function(element, options) {
		// обращаемся к конструктору суперкласса
		_super.Constructor.apply( this, arguments )
	}

	// наследуем аш класс от оригинального Button
	TabSubmenu.prototype = $.extend({}, _super.Constructor.prototype, {
		constructor: TabSubmenu

		, _super: function() {
				var args = $.makeArray(arguments)
				_super.Constructor.prototype[args.shift()].apply(this, args)
		}

		// перекрываем метод show
		, show: function () {
				var $this = this.element
					, $ul = $this.closest('ul:not(.dropdown-menu)')
					, selector = $this.attr('data-target')
					, previous
					, $target
					, e

				if (!selector) {
					selector = $this.attr('href')
					selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
				}

				$target = $(selector)

				// если на момент клика active - ужно вызывать hide
				if ( $this.parent('li').hasClass('active') && $target.hasClass('active') ) {
					$this.tab('hide')
					return
				}

				previous = $ul.find('.active:last a')[0]

				e = $.Event('show', {
					relatedTarget: previous
				})

				$this.trigger(e)

				if (e.isDefaultPrevented()) return

				this.activate($this.parent('li'), $ul)
				this.activate($target, $target.parent(), function () {
					$this.trigger({
						type: 'shown'
					, relatedTarget: previous
					})
				})
			}

		// метод вызывает скрытие подменю
		, hide: function () {
				var $this = this.element
					, selector = $this.attr('data-target')

				if (!selector) {
					selector = $this.attr('href')
					selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
				}

				this.disactivate( $(selector), $(selector).parent() )
			}

		// метод переводит элемент в неактивное состояние
		, disactivate: function ( element, container) {
				var $active = container.find('> .active')

				$active
					.removeClass('active')
					.find('> .dropdown-menu > .active')
					.removeClass('active')
			}
	})

	// переписываем оригинальную инициализацию button
	$.fn.tab = $.extend(function(option) {

			var args = $.makeArray(arguments),
					option = args.shift()

			return this.each(function () {
				var $this = $(this)
					, data = $this.data('tab')
				if (!data) $this.data('tab', (data = new TabSubmenu(this)))
				if (typeof option == 'string') data[option]()
			})

	}, $.fn.tab)

	// обрабатываем клик на пункт меню
	$(document).on('click', function (e) {
    if ($(event.target).closest('.secondmenu, .topmenu').length) return

	  var $element = $('[data-toggle="tab"]')
		var $parent = $element.closest('li.active')

    $parent && $element && $element.tab('hide')

    event.stopPropagation()
	})

}(window.jQuery)
