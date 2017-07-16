moment.locale('ru');


function bind_modules (parent) {
	// сохраняем первоначальные данные форм
	$(parent).find('form.unbind').each(function () {
		$(this).data('initialForm', $(this).serialize());
	}).submit(function (e) {
		var formEl = this;
		var changed = false;

		/*$('form.unbind').each(function() {
			if (this != formEl && $(this).data('initialForm') != $(this).serialize()) {
				changed = true;
				$(this).addClass('changed');
			} else {
				$(this).removeClass('changed');
			}
		});*/
	
		if (changed && !confirm('Another form on this page has been changed. Are you sure you want to continue with this form submission?')) {
			e.preventDefault();
		} else {
			// ajaxform может сохраняться много раз и при ее изменении повторно должен быть запрос на переход
			if(!$(this).is('.ajaxform')){
				// для обычной формы - удаляем слежение за переходом
				$(window).unbind('beforeunload', catcher);
			}
		}
	});

	$(parent).find('textarea').autoResize();

	$(parent).find('.chzn-select').select2();
	$(parent).find(".chzn-select-deselect").select2({
		allowClear: true
	});
	$(parent).find(".chzn-select-custom").each(function () {
		var $element = $(this),
			options = {
				allowClear: true,
				formatNoMatches: function() {
					return 'Совпадений не найдено!'
				},
				formatSearching: function() {
					return 'Поиск...'
				},
				createSearchChoice: function(term, data) {
					if ($(data).filter(function() {		
						return this.text.localeCompare(term) === 0;
					}).length === 0) {	
						return {
							id: term,
							text: term
						};
					}
				},  
				initSelection : function(element, callback) {
					console.log(element, callback)
					callback({"text": element.data('lable')}); 
				}
			};

		if ($(this).data("autocomplete-url")){
			options["ajax"] = {
				url: $element.data('autocomplete-url'),
				dataType: 'json',
				type: 'POST',
				data: function (term, page) {
					return {
						q: term,
						goods_property_id: $element.data('property-id'),
						limit: 30
					};
				},
				results: function (data, page) {
					return {results: data.results};
				}
			}
		}

		if (!$(this).data("no-placeholder")){
			options["placeholder"] = 'Выберите или укажите значение'
		}

		if ($(this).data("multiple")){
			options["multiple"] = true
		}

		$element.select2(options)

		if ($element.data('selected-value')) {
			selected = $.parseJSON($element.data('selected-value').replace(/'/g,"\""))
			;
			$element.data().select2.updateSelection(selected);
		}
	});
	$(parent).find(".chzn-select-remote").each(function () {
		var $element = $(this);

		$element.select2({
			allowClear: true,
			placeholder: 'Выберите или укажите значение',
			formatNoMatches: function() {
				return 'Совпадений не найдено!'
			},
			formatSearching: function() {
				return 'Поиск...'
			},
			ajax: {
				url: $element.data('autocomplete-url'),
				dataType: 'json',
				type: 'POST',
				data: function (term, page) {
					return {
						q: term,
						limit: 30
					};
				},
				results: function (data, page) {
					return {results: data.results};
				}
			},
			initSelection: function(element, callback) {
				var id = $element.val();

				if (id > 0) {
					$.ajax({
						url: $element.data('autocomplete-url'),
						dataType: 'json',
						type: 'POST',						
						data: {
							id: id
						}
					}).done(function(data) {
						if ( "children" in data.results[0] ) {
							console.log(data.results[0]);
							callback(data.results[0].children[0]);
						} else {
							callback(data.results[0]);
						}						
					});
				}			
			}
		});
	});

	$(parent).find('.ajaxform').each(function () {
		var form = $(this);
		var options = {
			dataType: 'json',
			semantic: true,
			url: (form.attr('action') || '') + ((form.attr('action') && form.attr('action').indexOf('?') >= 0) ? '&' : '?') + '_format=js',
			beforeSubmit: showProcess,
			success: processJson,
			complete: hideProcess,
			error: function (form, XMLHttpRequest, e, textStatus) {
				alert("При отправке данных произошла ошибка сервера!");
				// alert(XMLHttpRequest.responseText);
			}
		}

		form.ajaxForm(options);
	});

	$(parent).find('.ajax-link').click(function (event) {
		event.preventDefault();

		$.ajax({
			dataType: 'json',
			url: $(this).attr('href'),
			data: {
				'_format' : 'json'
			},
			success: processJson
		});

		return false;
	});

	$.editable.addInputType('selectautocomplete', {
		element : $.editable.types.text.element,
		content : function(data, settings, original) {
			// $('select', this).prepend($('<option />').val(0).append('Не назначен'));
			// $.editable.types.select.content.apply(this, [data, settings, original]);
		},
		plugin : function(settings, original) {
			$('input', this).select2({
				'width' : '100%',
				'allowClear': true,
				query: function(query) {
					$.ajax({
						url: settings.loadurl,
						dataType: 'json',
						data: {
							'q' : query.term
						},
						context: query
					}).success(function (data) {
						var items = {
							results: []
						};

						if (settings.allow_empty) {
							items.results.push({
								id: 0,
								text: 'Не назначен'
							});
						}

						for (var id in data) {
							var item = data[id];

							items.results.push({
								id: item.id,
								text: item.name
							});
						}

						this.callback(items);
					});
				}
			}).on("change", function(e) {
				$(this).parent().submit();
			});
		}
	});

	$.editable.addInputType('textarea', {
		element : $.editable.types.textarea.element,
		plugin : function(settings, original) {
			$('textarea', this).autoResize();
			
			setTimeout(function (ta) {
				return function () {
					// $('textarea', ta).last()[0].focus();
					$('textarea', ta).last()[0].select();
				}
			}(this), 10)
		}
	});

	$(parent).find('.selectable').click(function () {
		var selector = $(this).find('.selector input[type="checkbox"]');
		// selector.prop('checked', !selector.prop('checked'));
		selector.click();

		// return false;
	});

	$(parent).find('.selectable .selector input[type="checkbox"]').click(function (e) {
		e.stopPropagation();
	})

	$(parent).find('.selectable .selector input[type="checkbox"]').change(function () {
		selectable = $(this).closest('.selectable');
		if ($(this).prop("checked")) {
			$(selectable).addClass('selected');
		} else {
			$(selectable).removeClass('selected');
		}
	});

	$(parent).find('.selectable a').click(function (e) {
		e.stopPropagation();
	});

	$(parent).find('.tooltiped').tooltip({});

	$(parent).find('.datepick').each(function () {
		$(this).datepicker({
			autoclose: true,
			format: 'dd.mm.yyyy',
			todayHighlight: true,
			language: 'ru',
			startDate: $(this).data('start-date'),
			endDate: $(this).data('end-date')
		})
			.on('changeDate', function (e) {
				$(this).prev().val(e.format( 'yyyy', e.date ) );
				$(this).prev().prev().val(e.format( 'mm', e.date ) );
				$(this).prev().prev().prev().val(e.format( 'dd', e.date ) );
			});
	});

	$(parent).find('.form-addon').each(function () {
		$(this).hide();
	});

	$(parent).find('form').on('focusin', function (event) {
		if ($(event.target).is('input:file, a.fileinput-link')) return false

		$(this).data('focusin', true);

		if ($(this).data('focusin')) {
			$(this).find('.form-addon').slideDown(400);
		}
	});
	$(parent).find('form').on('focusout', function () {
		$(this).data('focusin', false);

		setTimeout(function (f) {
			return function () {
				if (!$(f).data('focusin')) {
					$(f).find('.form-addon').slideUp(400);
				}
			}}(this), 1000)
	});


	// $(parent).find('.slinky-item-top').each(function () {
	// 	$(this).addClass('flow');

	// 	var wrapper = $('<div class="flow-wrapper"></div>')
	// 		.data('block', $(this))
	// 		.css({
	// 			display: 'block',
	// 			width: '100%',
	// 			height: $(this).outerHeight(true)
	// 		});

	// 	$(this).data('wrapper', wrapper);
	// 	$(this).closest('.pane-content')
	// 		.prepend(wrapper);
	// });

	$(parent).find('.slinky-item-bottom').each(function () {
		$(this).addClass('flow');

		var wrapper = $('<div class="flow-wrapper"></div>')
			.data('block', $(this))
			.css({
				display: 'block',
				width: '100%',
				height: $(this).outerHeight(true)
			});

		$(this).data('wrapper', wrapper);
		$(this).closest('.pane-content').append(wrapper);
	});

	$(parent).find('.slinky-item-top, .slinky-item-bottom').on('change, keyup, keydown', function () {
		$($(this).data('wrapper')).css({
			height: $(this).height()
		})
	});

	$(parent).find('.slinky-item-top, .slinky-item-bottom').on('change, keyup, keydown', function () {
		$($(this).data('wrapper')).css({
			height: $(this).height()
		})
	});


	var wysiwygOptions = {
		paragraphize: false,
		imageUpload: '/file_session/upload.js?upload_image=1',
		imageUploadCallback: function(image, json) {
			$(image).css('max-width', '600px')
			$(image).attr('data-relace-to-content-id', true)
		}
	}

	$(parent).find( ".markable-photo .goods .marker" ).draggable({
		revert: "invalid",
		containment: ".markable-photo #left-container",
		helper: "clone",
		cursor: "move"
	});

	$(parent).find('.markable-photo #image img').droppable({
		accept: ".markable-photo .goods .marker",
		drop: function( event, ui ) {
			var mark_position = {
				'top': ui.position.top - $('.markable-photo #image img').position().top,
				'left': ui.position.left - $('.markable-photo #image img').position().left
			}

			$('.markable-photo #position\\.' + $(ui.draggable).attr('goods_id') + '\\.x').val(mark_position.top);
			$('.markable-photo #position\\.' + $(ui.draggable).attr('goods_id') + '\\.y').val(mark_position.left);

			sticker = ui.draggable.clone()
				.css('position', 'absolute')
				.css('top', mark_position.top)
				.css('left', mark_position.left);

			console.log(ui.position)
			console.log($('.markable-photo #image img').position())
			console.log(mark_position)

			$(this).closest('#image').append(sticker);

			bind_marker(sticker);

			ui.draggable.draggable( "disable" );
		}
	});

	var existedPositions = $(parent).find( ".markable-photo #image .marker" )

	bind_marker(existedPositions)

	existedPositions.each(function() {
		$('.marker-' + $(this).attr('goods_id')).draggable( "disable" )
	})

	$(parent).find('.colorPickIt').ColorPicker({
		onSubmit: function(hsb, hex, rgb, el) {
			$(el).val('#' + hex);
			$(el).ColorPickerHide();
		},
		onBeforeShow: function () {
			$(this).ColorPickerSetColor(this.value);
		}
	})

	// Подключение подгрузки при прокрутке
	var scroller = new dacScroller({
		wrapper: $('.pane-content'),
		scrollBlock: $(parent).find('.lister-block'),
		catalogContainer: $(parent).find('#objects'),
		loader: $(parent).find('.loader'),
		success_callback: function(data, self){
			if (parseInt(data.max_page) >= parseInt(data.pageNum)) {
				if ($.isFunction('init_catalog') && !scroller.scrollBlock.find('.no-catalog').length)
					init_catalog();

				var curActivePage = $(parent).find('.lister-block a.active');
				var newActivePage = curActivePage.next('a:not(.forward)');

				if (newActivePage.length) {
					curActivePage.removeClass('active');
					newActivePage.addClass('active');
				}

				if (parseInt(data.max_page) > parseInt(data.pageNum)) {
				  var newNextPage =  newActivePage.next('a:not(.forward)');

				  self.link.attr('href', $('.lister-block a.forward').attr('href').replace(/page=(\d+)/, 'page=' + Number(parseInt(data.pageNum) + 1)));
				} else  {
				  self.link.remove();
				}
		  }
		}
	});

	scroller.link = scroller.scrollBlock.find('a.forward');
	scroller.scrollBlock.find('a, span').hide();


	// Сортировка списка файлов. Родительский объект должен иметь data-sort="true",
	// и data-url - url обработчика сортировки
	$(parent).find('[data-sort="true"]').sortable({
			items: '.sortitem',
			handle: '.sort',
			axis: 'y',
			placeholder: 'ui-state-highlight',
			forcePlaceholderSize: true,
			opacity: 0.4,
			update: resort_objects
	});


	// Механизм, реализующий переход по клику на строку таблицы #objects
	// У строки должен быть атрибут data-item-link-url, содержащий адрес перехода
	// Для того чтобы не иметь возможность выделить текстовые элементы в строке,
	// они должны быть обернуты в любой тэг, например, span ;)
	$('#objects tr').css('cursor', 'pointer');

	$('#objects').unbind('click')
		.click('tr', function(e) {
			if ($(e.target).is('td')) {
				var url = $(e.target).closest('[data-item-link-url]')
					.data('item-link-url');

				if (url) {
					window.location.href = url;
				}
			}
		});

	$('.select_geo').select2({
		'width' : '100%',
		'allowClear': true,
		query: function(query) {
			$.ajax({
				url: '/_admin/site_region/autocomplete.js',
				dataType: 'json',
				data: {
					'type' : query.element.data('select-type'),
					'q': query.term
				},
				context: query
			}).success(function (data) {
				var items = {
					results: []
				};

				items.results.push({
					id: '',
					text: 'Все'
				});
				items.results.push({
					id: 0,
					text: query.element.data('select-default-name') || ''
				});

				for (var id in data) {
					var item = data[id];

					for (var i = 0; i < item.length; ++i) {
						if(item[i].text){
							items.results.push({
								id: item[i].id,
								text: item[i].text
							});
						}
					}
				}
				this.callback(items);
			});
		},
		initSelection: function(element, callback) {
			if($(element).val() > 0) {
				$.ajax({
					url: '/_admin/site_region/autocomplete.js',
					dataType: 'json',
					data: {
						'type' : element.data('select-type'),
						'id': element.val()
					}
				}).success(function (data) {
					callback({
						id: data.results[0].id,
						text: data.results[0].text
					});
				});
			} else if ($(element).val() === "") {
				callback({
					id: '',
					text: 'Все'
				});
			} else {
				callback({
					id: 0,
					text: element.data('select-default-name') || ''
				});
			}
		}
	});

	$(parent).on('click', '.submit_form_on_click', function(event) {
		$( this ).closest('form').submit()
	})

	// инициализация маски для номера телефона
	$(parent).find(".maskedinput_phone").mask(function( val ) {
		return '+7 (000) 000-00-00';
	}, {
		placeholder: '+7 (___) ___-__-__',
		translation: {
			C : {
				pattern: /(7|8)/,
				optional: true
			}
		}
	});

}

function resort_objects() {
	var sort_url = $(this).closest('[data-sort="true"]').data('sort-url');

	$.ajax({
		type: "POST",
		async: true,
		cache: false,
		url: sort_url,
		data: $(this).sortable('serialize')
	});
}

function bind_marker (el) {
	el.draggable({
		containment: ".markable-photo #image",
		cursor: "move",
		stop: function (event, ui) {
			console.log(ui.position)
			$('.markable-photo #position\\.' + $(this).attr('goods_id') + '\\.x').val(ui.position.top);
			$('.markable-photo #position\\.' + $(this).attr('goods_id') + '\\.y').val(ui.position.left);
		}
	})
	.dblclick(function () {
		$('.markable-photo #position\\.' + $(this).attr('goods_id') + '\\.x').val('0');
		$('.markable-photo #position\\.' + $(this).attr('goods_id') + '\\.y').val('0');

		$('.markable-photo .marker-' + $(this).attr('goods_id')).draggable( "enable" );

		$(this).remove();
	})
}

function load_counters () {
	$.ajax({
		dataType: 'json',
		url : '/activity/count.json',
		success : function (data) {
			if (data.unread_notification_count > 0) {
				$('#activity-nav a').append('<span class="badge badge-warning" style="position: absolute; top: 10px;">' + data.unread_notification_count + '</span>');
			};
			if (data.active_conversation_count > 0 || data.unsigned_conversation_count > 0) {
				$('#conversation-nav a').append('<span class="badge ' + (data.unsigned_conversation_count > 0 ? 'badge-important' : 'badge-success') + '" style="position: absolute; top: 10px;">' + eval(Number(data.active_conversation_count) + Number(data.unsigned_conversation_count)) + '</span>');
			};
			if (data.active_deals_count > 0) {
				$('#deal-nav a').append('<span class="badge badge-success" style="position: absolute; top: 10px;">' + data.active_deals_count + '</span>');
			};
			if (data.active_tasks_count > 0 || data.overdue_tasks_count > 0) {
				$('#task-nav a').append('<span class="badge ' + (data.overdue_tasks_count > 0 ? 'badge-important' : 'badge-success') + '" style="position: absolute; top: 10px;">' + eval(Number(data.active_tasks_count) + Number(data.overdue_tasks_count)) + '</span>');
			};
			// if (data.inbox_tasks_count > 0) {
			// 	$('#task-nav a').append('<span class="badge badge-info" style="position: absolute; top: 10px;">' + data.inbox_tasks_count + '</span>');
			// };
		}
	});
}

$(document).ready(function () {
	// fix sub nav on scroll
	var $win = $(window)
	  , $nav = $('#barnav')
	  , navTop = $('#barnav').length && $('#barnav').offset().top - 0
	  , isFixed = 0

	$(window).bind('beforeunload', catcher);

	$(window).unload(function(event) {

	});


	$(document).keydown(kb);

	bind_modules(document);


	$(".file_add").on("click", function () {
		var input = $(this).closest(".input");

		$(this).closest("div").clone().appendTo(input);

		// разблокируем кнопку удаления
		if (input.find(".file").length > 1) {
			input.find(".file").each(function () {
				$(this).closest("div").find(".file_remove").removeAttr("disabled");
			});
		};

		return false;
	});

	$(".file_remove").on("click", function () {
		var input = $(this).closest(".input");

		$(this).closest("div").remove();

		// блокируем кнопку удаления
		if (input.find(".file").length <= 1) {
			input.find(".file").each(function () {
				$(this).closest("div").find(".file_remove").attr("disabled", "disabled");
			});
		};

		return false;
	});

	$(".field-clone").on("click", function () {
		var input = $($(this).data('field-input'));
		var field = $($(this).data('field-template'));

		field.clone()
			.css('display', '')
			.appendTo(input);

		// разблокируем кнопку удаления
		// if (input.find(field_selector).length > 1) {
		// 	input.find(field_selector).each(function () {
		// 		$(this).closest("div").find(".file_remove").removeAttr("disabled");
		// 	});
		// };

		return false;
	});

	$(".field-remove").on("click", function () {
		$(this).closest("div.input").hide()
			.find('._destroy').val(1);

		return false;
	});

	$(".fancybox").fancybox();

	// $(".show-modal").fancybox({
	// 	type: 'ajax',
	// 	autoSize: false,
	// 	autoCenter: true,
	// 	width: "auto",
	// 	maxWidth: 1400,
	// 	height: "auto",
	// 	maxHeight: 800,
	// 	minHeight: 640,
	// 	margin: 0,
	// 	padding: 0,
	// 	'beforeLoad': function (data) {
	// 		this.href = this.href + (this.href.indexOf('?') >= 0 ? '&' : '?') + 'modal=true'
	// 	},
	// 	'beforeShow': function () {
	// 		bind_modules($('.fancybox-inner'));
	// 	}
	// });

	// обновление списка таймеров после отправки ajax формы
	$(document)
		.on('ajaxComplete', function(event, xhr, settings) {
			// если на странице есть список завершенных таймеров
			if ($('.free_timers_form').length && xhr.responseText) {
				try {
					// пробуем распарсить ответ на запрос как json
					var responseJson = jQuery.parseJSON(xhr.responseText);

					// если в ответе был передан task_id
					if (responseJson.task_id) {
						// отправляем запрос на обновление списка
						update_timers_list(responseJson.task_id);
					}
				} catch(err) {}
			}
		});

	if ($('.rateit').length) {
		$('.rateit').rateit();
	}
	
	// if ($('.tag-it').length) {
 // 		$(".tag-it").tagit();
	// }

	$(document).on('change', '#statusUpdate', function(event) {
		var select = $(this);

		$.ajax({
			dataType: 'json',
			url: select.data('url'),
			data: {
				'feedback_ticket.status_id': select.val()
			},
			error: function() {
				alert('Произошла ошибка! Обратитесь к оператору!');
			},
			success: function(data) {
				select.closest("tr").attr('class', data.status_class);
			}
		})
	});


	$(document).on('click', '.properties_block_expander', function(event) {
		event.preventDefault();
	
		$(this).hide()
		
		$(".properties_block").removeClass("hidden")
	})

	new Clipboard('.clipboard-button');

	$(document).on('click', '.select_all', function (event) {
		var $selectAll = $(this)

		$(':checkbox' + $selectAll.data('selector')).prop('checked', ($selectAll.is(':checked')) ? true : '')
	})	
});


/* перехват выхода со страницы */
var catcher = function (parent) {
	if (!parent.length) {
		var parent = $(document);
	};

	var changed = false;

	$(parent).find('form.unbind').each(function () {
		if ($(this).data('initialForm') != $(this).serialize()) {
			changed = true;
			// $(this).addClass('changed');
		} else {
			// $(this).removeClass('changed');
		}
	});

	if (changed) {
		return 'Эта страница просит вас подтвердить, что вы хотите уйти — при этом введённые вами данные могут не сохраниться.';
	}
}


/* отлов обработки нажатий Ctrl + S, Meta + S, Ctrl + Enter для отправки текущей формы */
var kb = function(event) {
	ctrl = (event.metaKey && !event.ctrlKey) || event.ctrlKey;
	if (ctrl && (event.keyCode == 13 || event.keyCode == 83)) {
		var target = $(event.target);
		if (target && target[0].form) {
			$(target[0].form).submit();
			return false;
		}

		event.stopPropagation();
	}
}

/* отображение процесса отправки */
function showProcess (a, form) {
	if (form.hasClass('fileload')) {
		alert('Выполняется загрузка файла! Дождитесь окончания или отмените загрузку')

		return false
	}

	cont = form.parent().find(".alert");

	if (!cont.length)
	{
		cont = $("<div class='alert' style='display: none;'/>");
		cont.insertBefore(form);
	}

	if (cont.css("display") != "none")
		cont.hide("blind", function () {
			cont.insertBefore(form);
		});

//	form.find("#actions *").hide();
	form.find(".process").show();
}

/* скрытие процесса отправки */
function hideProcess (form, xhr, status) {
//	$("#actions *").show();
	$(".process").hide();
}

/* обработка ответа от сервера */
function processJson (data, status, xhr, form) {
	$("*").removeClass("error");

	if (!data) return;

	switch (data.code) {
		case "add":
			alert("WOW");
		break;

		case "append_to":
			form.closest('.modal-document, body').find("#" + data.id).remove();
			form.closest('.modal-document, body').find("#" + data.parent_id).append(unescape(data.html));
			form.closest('.modal-document, body').find("#" + data.id).hide().show(200);

			form.resetForm();
		break;

		case "prepend_to":
			form.closest('.modal-document, body').find("#" + data.id).remove();
			form.closest('.modal-document, body').find("#" + data.parent_id).prepend(unescape(data.html));
			form.closest('.modal-document, body').find("#" + data.id).hide().show(200);

			form.resetForm();
		break;

		case "remove":
			var obj = $("#" + data.id);

			if(obj.length > 0) {
				obj.remove();
			}
		break;

		case "update":
			var obj = $("#" + data.id);
			parent = obj.parent();
			$("#" + data.id).remove();
			parent.append(unescape(data.html));
		break;

		case "reload":
			$.ajax({
				url : data.url,
				context : data,
				success : function (body) {
					$("#" + this.id).html(body);
					bind_modules($("#" + this.id));
				}
			});
		break;

		case 200:
			cont = form.parent().find(".alert");
			cont.empty();

			cont.removeClass("alert-error");
			cont.addClass("alert-success");
			cont.append("<div class='title'>" + data.title + "</div>");
			cont.show("blind");

			if (data.clear_form) {
				form.resetForm();
			}

			// для unload перехода реинициализируем данные после сохранения формы
			form.data('initialForm', form.serialize());
		break;

		case 201:
			// для unload перехода реинициализируем данные после сохранения формы
			form.data('initialForm', form.serialize());

			modal = form.closest('.modal-document');

			if (modal.length) {
				$.ajax({
					'url' : data.url + (data.url.indexOf('?') >= 0 ? '&' : '?') + 'modal=true',
					context : modal,
					success : function (html) {
						modal.html(html);
						bind_modules(modal);
					}
				})
			} else {
				// если определен defferred для загрузки файлов - ждем, когда он будет разрешен
				if (typeof waitFileLoadFinished !== 'undefined') {
					$.when(waitFileLoadFinished).then(function(){
						window.location = data.url;
					});
				} else {
				window.location = data.url;
			}
			}
		break;

		case 500:
			cont = form.parent().find(".alert");
			cont.empty();

			cont.removeClass("alert-success");
			cont.addClass("alert-error");
			cont.append("<div class='title'>" + data.title + "</div>");
			cont.show("blind");

			$.each(data.errors, function(i, err) {
				cont.append("<div>" + err.msg + "</div>");

				$.each(err.field, function(i, field) {
					form.find("#" + field).parent().addClass("error");
				});
			});
		break;

		default:
			alert("Uncknown error!");
	}
}


function show_modal(html) {
	if (!$('.modal-overflow').length) {
		$('<div></div>')
			.addClass('modal-overflow')
			.css({
				position : 'fixed',
				top : '0',
				left : '0',
				width : '100%',
				height : '100%',
				background : '#EFEFEF',
				opacity : '0.4',
				overflow : 'auto',
				'z-index' : '999'
			})
			.click(function () {
				changed = catcher($('.modal-document:last'));

				if (changed == undefined || confirm(changed)) {
					$('.modal-document:last').remove();

					if (!$('.modal-document').length) {
						$('.modal-overflow').remove();
					}

					if (!$('.modal-overflow').length) {
						$('body').css({
							overflow : 'auto'
						})
					}
				}
			})
			.appendTo($("body"));

		$('body').css({
			overflow : 'hidden'
		});
	}

	var cont = $('<div></div>')
		.addClass('document modal-document')
		.css({
			// display : 'none',
			position : 'fixed',
			top : '0',
			right : '0',
			width : '50%',
			"min-width" : '1050px',
			height : '100%',
			background : '#FFF',
			overflow : 'auto',
			'z-index' : '1000'
		});

	cont.html(html);
	bind_modules(cont);

	cont.appendTo($("body"));
}


$(document).on('reset', 'form', function() {
	var $form = $(this);

	// сброс активных кнопок по reset формы
	setTimeout(function(){
		$form.find('.select2-offscreen').trigger('change'); 					// Сбрасываем все select2 при сбросе форм
	}, 10);

	// чистка wysiwyg после submit формы
	var $redactor = $form.find('.redactor-editor')
	if ($redactor.length) {
		$redactor.html('')
	}

	// сброс даты после отправки формы
	var $datepicker = $form.find('.datepick')

	$datepicker.datepicker('update', '')
	$datepicker.prev().val('')
	$datepicker.prev().prev().val('')
	$datepicker.prev().prev().prev().val('')
})



/* скрытие процесса отправки */
function loadList(options) {
	var $container = $(options.container)
	var $dataUrl = options.dataUrl

	if ($container.length && typeof $dataUrl !== 'undefined') {
		// Подключение подгрузки при прокрутке
		new dacScroller({
			url: $dataUrl,
			catalogContainer: $container,
			loader: $container.find('.loader'),
			success_callback: function(data, self) {
				self.catalogContainer.append(data.html)
				bind_modules(self.catalogContainer)
			}
		}).update_catalog()
	}
}
