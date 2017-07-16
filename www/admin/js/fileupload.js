(function($) {
	var listDropAreas = []
	var fileUploaderInputs = []

	/*
		В качестве url_upload и url_delete необходимо передавать url
		без GET-параметров их можно передать в объекте params.
	*/
	var config = {
		'url_upload': '/file_session/upload/',
		'url_delete': '/file_session/delete/',
		'params': {},
		'use_file_session': true,
		'inside_textarea': true,
		'success_callback': undefined,
		'response_action': false,
		'response_action_selector': ''
	};

	var makeUrl = function (url_type, id) {
		if(typeof id !== 'undefined'){
			return config['url_' + url_type] + id + '.js'
		} else {
			return config['url_' + url_type].slice(0, -1) + '.js'
		}
	}

	var ajaxFileUpload = function (ajaxConfig) {
		if(FormData.prototype.isPrototypeOf(ajaxConfig['data'])){
			for ( var key in config['params'] ){
				ajaxConfig['data'].append(key, config['params'][key]);
			}
		} else {
			ajaxConfig['data'] = $.extend(config['params'], ajaxConfig['data']);
		}

		$.ajax(ajaxConfig);
	}

	$.fn.dacFileUploader = function(_config) {
		config = $.extend(config, window.dacFileUploaderConfig);
		config = $.extend(config, _config);
		config = $.extend(config, $(this).data());

		fileUploaderInputUID = generateRandomId();
		config = $.extend(config, {'fileInputUID': fileUploaderInputUID});

		var fileUploaderInput = $(this)
		fileUploaderInputs[fileUploaderInputUID] = fileUploaderInput

		fileUploaderInput.data('file-uploader-uid', fileUploaderInputUID)

		if (typeof fileUploaderInput.data('filedrag') !== 'undefined' && fileUploaderInput.data('filedrag').trim().length) {
			listDropAreas[fileUploaderInputUID] = $(fileUploaderInput.data('filedrag'))
		} else {
			listDropAreas[fileUploaderInputUID] = $('<div id="filedrag' + fileUploaderInputUID + '" class="filedrag"><div class="filedrag-content-wrapper"><div class="filedrag-content"><i class="fa fa-arrow-up"></i><div>Перетащить файлы сюда</div></div></div></div>')

			fileUploaderInput.after(listDropAreas[fileUploaderInputUID])
		}

		listDropAreas[fileUploaderInputUID].hide()

		resizeDropArea(listDropAreas[fileUploaderInputUID])

		listDropAreas[fileUploaderInputUID]
			.on('dragenter', function (event) {
				cancelDefaultBehavour(event)

				showDrag = true

				activateDropArea($(this))
			})
			.on('dragover', function (event) {
				cancelDefaultBehavour(event)

				showDrag = true
			})
			.on('drop', function (event) {
				cancelDefaultBehavour(event);

				disActivateDropArea($(this));

				var files = event.originalEvent.dataTransfer.files;

				// обрабатываем загруженные файлы
				handleFileUpload(files, this.closest('form'));

				resizeDropArea($(this))

				$(this).hide()
			});

		var showDrag = false,
			showDragTimeout = null

		// позволяет сменить оформление области дропа
		$(document)
			.on('dragenter', function (event) {
				showDrag = true

				activateDropArea(listDropAreas[fileUploaderInputUID])

				if (!listDropAreas[fileUploaderInputUID].is(':visible') && fileUploaderInput.parent().is(':visible')) {
					listDropAreas[fileUploaderInputUID].show()
				}
			})
			.on('dragover', function (event) {
				cancelDefaultBehavour(event);

				// disActivateDropArea(listDropAreas[fileUploaderInputUID]);

				showDrag = true
			})
			.on('dragleave', function (event) {
				showDrag = false

				clearTimeout(showDragTimeout)

				showDragTimeout = setTimeout(function(){
					if(!showDrag) {
							disActivateDropArea(listDropAreas[fileUploaderInputUID])
							listDropAreas[fileUploaderInputUID].hide()
					}
				}, 200)
			})

		// обрабатываем загрузку в file input другого файла
		fileUploaderInput
			.on('change', function (event) {
				// загружаем файлы
				handleFileUpload(this.files, this.closest('form'))

				// сбрасываем поле для прикрепления файла
				// (необходимо только при использовании file_session])
				if(config['use_file_session']){
					$(this).replaceWith($(this).val('').clone(true))
				}
			})

		fileUploaderInput.closest('form')
			.on('reset', function (event) {
				var fileContainer = $(this)
					.find('.filecontainer')

				fileContainer && fileContainer
					.find('.fileinput')
					.remove()

				resizeDropArea(listDropAreas[fileUploaderInputUID])
				listDropAreas[fileUploaderInputUID].hide()
			})

		fileUploaderInput.closest('.fileinput-wrapper').find('a.fileinput-link')
			.on('click', function (event) {
				var input = $(this).closest('.file-load-block').find('input:file')

				input.closest('form').blur()
				input.trigger('click')
			})

		fileUploaderInput
			.on('click', function (event) {
				fileUploaderInput.closest('form').blur()
			})
	};

	$(document)
		.on('click', '.file-session-delete', function (event) {
			cancelDefaultBehavour(event)

			if (confirm('Вы действительно хотите отменить загрузку?')) {
				var fileUID = $(this).closest('.fileinput').find('input:hidden').val()

				deleteFileSession(fileUID)
			}
		})
		.on('click', '.file-delete', function (event) {
			cancelDefaultBehavour(event)

			var _this = $(this);
			var fileId = _this.data('file-id');

			if (confirm('Вы действительно хотите удалить файл?')) {
				ajaxFileUpload({
					type: 'POST',
					url: makeUrl('delete', fileId),
					success: function() {
						_this.closest('.file')
							.fadeOut('slow')
							.remove();
					},
					error: function (XMLHttpRequest, textStatus) {
						alert("При отправке данных произошла ошибка сервера!")
					}
				});
			}
		})

/* Изменяет оформление дроп-области, если она активна  */
var activateDropArea = function(dropAreaObject) {
	resizeDropArea(dropAreaObject)
	dropAreaObject.addClass('active')
}



/* Изменяет оформление дроп-области, если она неактивна  */
var disActivateDropArea = function(dropAreaObject) {
	resizeDropArea(dropAreaObject)
	dropAreaObject.removeClass('active')
}



	/* Изменяет размеры дроп-области под основную форму  */
	var resizeDropArea = function(dropAreaObject) {
		if (config['inside_textarea']){
			var $form = dropAreaObject.closest('form')

			dropAreaObject.css({
				'width': parseFloat($form.width()),
				'height': parseFloat($form.getVisibleHeight())
			});
		}
	}



	/* Отмена стандартного поведения при перетаскивании */
	var cancelDefaultBehavour = function(event) {
		event.stopPropagation();
		event.preventDefault();
	}


	/* Cоздаем новый file input */
	var addFileInput = function(fileName, fileUID, form) {
		// создаем новый file input
		var fileField = $(form).find('.filesample')
			.clone()
			.removeClass('hidden filesample')
			.attr('data-fileinput-id', fileUID);

		// прописываем имя файла
		if (fileName.length) {
			fileName = fileName.split('\\').pop()

			fileField.find('.filename').text(fileName)
		}

		$('<input>')
			.attr({
				'type': 'hidden',
				'name': 'files[]'
			})
			.val(fileUID)
			.appendTo(fileField)

		// добавляем его к остальным file input
		$('.filecontainer', form).append(fileField);
		return fileField;
	}



	/* Удаляем file input */
	var dropFileInput = function(fileUID) {
		var fileInput = $('.filecontainer')
			.find('.fileinput[data-fileinput-id=' + fileUID + ']')
			.remove()
	}

	var showLoader = function() {
		if (!listDropAreas[config.fileInputUID].find('.fileupload-loader').length) {
			var loader = $('<img>')
				.attr({
					"class": "fileupload-loader",
					"src": "/js/fileupload/loader.gif"
				});

			listDropAreas[config.fileInputUID].append(loader);
		}
	}
	var hideLoader = function() {
		listDropAreas[config.fileInputUID].find('.fileupload-loader').remove();
	}

	/* Обработка выбора файлов */
	var handleFileUpload = function(files, form) {
		$.each(files, function(i, file) {
			var fileReadyForUpload = new FormData();
			fileReadyForUpload.append('file', file);

			if(config['use_file_session']){
				addFileSession(file.name, fileReadyForUpload, form);
			} else {
				ajaxFileUpload({
					type: 'POST',
					url: makeUrl('upload'),
					dataType: 'json',
					contentType: false,
					processData: false,
					cache: false,
					data: fileReadyForUpload,
					beforeSend: function (){
						showLoader();
					},
					success: function (data, status, xhr) {
						processResponse(data, status, xhr, form);
					},
					error: function (XMLHttpRequest, textStatus) {
						alert("При отправке данных произошла ошибка сервера!")
					},
					complete: function () {
						hideLoader();
					}
				});
			}
		});
	}

	function processResponse(data, status, xhr, form) {
		var target = $(config['response_action_selector']);

		switch (config['response_action']) {
			case "append_to":
				target.append(unescape(data.html)).show(200);
			break;

			case "prepend_to":
				target.prepend(unescape(data.html)).show(200);
			break;
		}
	}

	/* Создаем прогресс бар */
	function createStatusbar(obj) {
			this.statusBar = $("<div class='progress progress-striped active'></div>")
			this.progressBar = $('<div class="bar"></div>')
				.appendTo(this.statusBar)
			this.statusBar.appendTo(obj)

			this.abort = obj
				.find('.close')
				.removeClass('file-session-delete')

			this.setProgress = function(progress) {
				this.progressBar.css({ width: progress + '%' }, 10)
			}

			this.setAbort = function(jqxhr) {
				var sb = this.statusBar

				this.abort.click(function() {
					cancelDefaultBehavour(event)

					if (confirm('Вы действительно хотите отменить загрузку?')) {
						jqxhr.abort()
					}
				})
			}
	}



	/* Создаем fileSession */
	var addFileSession = function(file_name, file, form) {
		var status = null
		var tempUID = 'temp-' + $('.filecontainer .fileinput').length

		var jqXhr = ajaxFileUpload({
			type: "POST",
			contentType:false,
			processData: false,
			cache: false,
			url: makeUrl('upload'),
			data: file,
			dataType: 'html',
			context: {
				file: file,
				form: form
			},
			beforeSend: function() {
				var obj = addFileInput(file_name, tempUID, this.form)

				status = new createStatusbar(obj)

				obj
					.closest('.ajaxform')
					.addClass('fileload')
			},
			xhr: function() {
				var xhrobj = $.ajaxSettings.xhr()

				if (xhrobj.upload) {
					xhrobj.upload.addEventListener('progress', function(event) {
						var percent = 0
						var position = event.loaded || event.position
						var total = event.total

						if (event.lengthComputable) {
							percent = Math.ceil(position / total * 100);
						}

						status.setProgress(percent)
					}, false)
				}

				return xhrobj
			},
			error: function (XMLHttpRequest, textStatus) {
				dropFileInput(tempUID)

				if (textStatus !== 'abort')
					alert("Файл " + this.file.name + " (" + this.file.size + " байт) не загружен. Возможно файл превысил допустимый лимит загрузки. Обратитесь к администратору!")
			},
			success: function (fileUID) {
				status.setProgress(100)

				dropFileInput(tempUID)

				var obj = addFileInput(file_name, fileUID, this.form)

				obj
					.closest('.ajaxform')
					.removeClass('fileload')
			},
			complete: function () {}
		})

		status.setAbort(jqXhr)
	}



	/* удаляем fileSession */
	var deleteFileSession = function(fileUID) {
		ajaxFileUpload({
			type: 'POST',
			url: makeUrl('delete'),
			data: {
				'uid': fileUID
			},
			error: function (XMLHttpRequest, textStatus) {
				alert("При отправке данных произошла ошибка сервера!")
			},
			success: function () {
				dropFileInput(fileUID)
			}
		})
	}


	var generateRandomId = function() {
		var charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'

		var id = ''
		for (var i = 1; i <= 10; i++) {
			id += charSet[Math.floor(Math.random() * charSet.length)]
		}

		return id
	}

	$.fn.getVisibleHeight = function() {
		var $el = $(this),
				scrollTop = $(window).scrollTop(),
				scrollBot = scrollTop + $(window).height(),
				elTop = $el.offset().top,
				elBottom = elTop + $el.outerHeight(),
				visibleTop = elTop < scrollTop ? scrollTop : elTop,
				visibleBottom = elBottom > scrollBot ? scrollBot : elBottom;

		return (visibleBottom - visibleTop);
	}
})(jQuery);
