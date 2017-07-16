!function ($) {
	// сохраняем оригинальный класс button как суперкласс
	var _super = $.fn.button;

	// создаем новый конструктор
	var ButtonDisselectable = function(element, options) {
			 // обращаемся к конструктору суперкласса
			_super.Constructor.apply( this, arguments );

	}

	// наследуем наш класс от оригинального Button
	ButtonDisselectable.prototype = $.extend({}, _super.Constructor.prototype, {
			constructor: ButtonDisselectable,
			_super: function() {
					var args = $.makeArray(arguments);
					_super.Constructor.prototype[args.shift()].apply(this, args);
			},
			// перекрываем метод toggle
			toggle: function() {
					// мотрим, выставлена ли опция disselectable в true
					var $parent = this.$element.closest('[data-disselectable="true"], [data-selectable="true"]')

					if (!$parent.length) {
						// если опция не указана - вызываем оригинальный toggle
						this._super('toggle');
					} else {
						//  противном случаем обрабатываем возможность снятия выбора с кнопки
						var activeElement = $parent && $parent.find('.active')

						this.$element.toggleClass('active')

						activeElement.removeClass('active')
					}

					if (!$parent.find('.active').length) {
						$parent.find('.default-active').addClass('active')
					}
			}
	});

	// переписываем оригинальную инициализацию button
	$.fn.button = $.extend(function(option) {

			var args = $.makeArray(arguments),
					option = args.shift();

			return this.each(function () {
				var $this = $(this)
					, data = $this.data('button')
					, options = typeof option == 'object' && option
				// используем новый класс-обертку ButtonDisselectable
				if (!data) $this.data('button', (data = new ButtonDisselectable(this, options)))
				if (option == 'toggle') data.toggle()
				else if (option) data.setState(option)
			})

	}, $.fn.button);

	// обрабатываем клик на checkbox
	$(document).on('click', '[data-toggle^=button][data-disselectable="true"] input[type=radio], [data-toggle^=button][data-disselectable="true"] a', function(event) {
		// отменяем вызов событий для родительских dom-объектов
		// нужно для предотвращения двойного вызова toggle для кнопки
		// event.stopPropagation();

		var $this = $(this);

		if ($this.is('input[type=radio]')) {
			var $radio = $this
		} else {
			var $radio = $this.find('input[type=radio]')
		}

		// устанавливаем состояние radio на основе данных о его предыдущем состоянии
		var previousValue = $radio.attr('previousValue');

		// находим обертку группы кнопок
		var $parent = $(this).closest('[data-toggle^=button][data-disselectable="true"]');
		$parent.find('input[type=radio]').each(function() {
			if ($(this)[0] != $this[0]) {
				$(this).attr('previousValue', false);
				$(this).prop('checked', false);
			}
		});

		$radio.prop('checked', (previousValue != 'true'));

		$radio.attr('previousValue', $radio.prop('checked'));
	});

	$(document).on('click', '[data-toggle^=button] :not(label, input[type=radio], a)', function(event) {
		$(this).closest('label').click()
	})

	// сброс активных кнопок по reset формы
	$(document).on('reset', 'form', function() {
		var $form = $(this);

		// ищем коннтейнер с кнопками
		var buttonsContainer = $form.find('[data-toggle^=button][data-disselectable="true"]')

		// сбрасываем активные кнопки, если контейнер был найден
		buttonsContainer && buttonsContainer
			.find('.btn:not(.default-active).active')
			.removeClass('active')
	})

}(window.jQuery);
