// Firefox User Preferences
// Author: Bogachenko Vyacheslav

// Warning in "about:config"
// Предупреждение в "about:config"
user_pref("browser.aboutConfig.showWarning", false);

// Opening the "Welcome" and "New Notes" tabs
// Открытие вкладок "Добро пожаловать" и "Новые заметки"
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);

// Start page
//      0 = Blank page
//      1 = Home page
//      2 = Last page visited
//      3 = Resume previous session
// Стартовая страница
//      0 = Пустая страница
//      1 = Домашняя страница
//      2 = Последняя посещенная страница
//      3 = Возобновить предыдущую сессию
user_pref("browser.startup.page", 0);

// Home page and new windows
// Домашняя страница и новые окна
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.startup.blankWindow", false);

// Новые вкладки
// New tabs
user_pref("browser.newtabpage.pinned", "");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.preload", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.newtabpage.activity-stream.system.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.asrouter.providers.cfr", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.message-groups", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.messaging-experiments", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.onboarding", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.whats-new-panel", "");
user_pref("browser.newtabpage.activity-stream.asrouter.useRemoteL10n", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.config", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.isCollectionDismissible", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.personalization.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories.options", "");
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.readTime.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.personalization.modelKeys", "");
user_pref("browser.newtabpage.activity-stream.discoverystream.spocs.personalized", false);
user_pref("browser.newtabpage.activity-stream.feeds.aboutpreferences", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.spocTopsitesPlacement.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.favicon", false);
user_pref("browser.newtabpage.activity-stream.feeds.newtabinit", false);
user_pref("browser.newtabpage.activity-stream.feeds.places", false);
user_pref("browser.newtabpage.activity-stream.feeds.prefs", false);
user_pref("browser.newtabpage.activity-stream.feeds.recommendationprovider", false);
user_pref("browser.newtabpage.activity-stream.feeds.sections", false);
user_pref("browser.newtabpage.activity-stream.feeds.system.topsites", false);
user_pref("browser.newtabpage.activity-stream.feeds.systemtick", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.noDefaultSearchTile", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts", false);
user_pref("browser.newtabpage.activity-stream.logowordmark.alwaysVisible", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.impressionId", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.cfr", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.message-groups", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.messaging-experiments", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.snippets", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.onboarding", "");
user_pref("browser.newtabpage.activity-stream.asrouter.providers.whats-new-panel", "");

// Restriction on opening new windows
//      0 = Open all links in tabs
//      1 = Open links in windows
//      2 = Open links in tabs, except when custom window options are specified
// Ограничение на открытие новых окон
//      0 = Открывать все ссылки во вкладках
//      1 = Открывать ссылки в окнах
//      2 = Открывать ссылки во вкладках за исключением случаев, когда заданы нестандартные параметры окна
user_pref("browser.backspace_action", 0);

// Opening tabs and external applications in the background
//      TRUE = Open such tabs in the background
//      FALSE = Switch to openable tabs
// Открытие вкладок и внешних приложений в фоновом режиме
//      TRUE = Открывать такие вкладки в фоне
//      FALSE = Переключаться на открываемые вкладки
user_pref("browser.tabs.loadDivertedInBackground", true);

// Search suggestions
// [NOTE] The default search engine uses geolocation-related data (your real location, determined by IP address).
// Поисковые предложения
// [ЗАМЕТКА] Поисковый механизм по умолчанию использует данные, связанные с геолокацией (вашим реальным местонахождением, определяемым по IP-адресу).
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.search.suggest.enabled.private", true);

// Preloading autocomplete URLs (when you enter in the address bar)
// Предварительная загрузка URL-адресов автозаполнения (при вводе в адресную строку)
//user_pref("browser.urlbar.speculativeConnect.enabled", false);

// Suggestion types in the address bar
// Типы предложений в адресной строке
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

// Remember the search history and form data
// Помнить историю поиска и данные формы
user_pref("browser.formfill.enable", false);

// Automatic deletion of history when closing the browser
// Автоматическое удаление истории при закрытии браузера
user_pref("privacy.sanitize.sanitizeOnShutdown", true);

// Which data items should be automatically deleted when the browser is closed
// Какие элементы данных должны быть автоматически удалены при закрытии браузера
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("privacy.clearOnShutdown.openWindows", true);
user_pref("privacy.clearOnShutdown.cookies", true);

// Browser cleanup wizard
// [NOTE] This dialog window is invoked by hotkeys - Ctrl + Shift + Del.
// Мастер очистки браузера
// [ЗАМЕТКА] Это диалоговое окно вызывается горячими клавишами - Ctrl + Shift + Del.
user_pref("privacy.cpd.cache", true);
user_pref("privacy.cpd.cookies", false);
user_pref("privacy.cpd.downloads", true);
user_pref("privacy.cpd.formdata", true);
user_pref("privacy.cpd.history", true);
user_pref("privacy.cpd.offlineApps", true);
user_pref("privacy.cpd.passwords", false);
user_pref("privacy.cpd.sessions", true);
user_pref("privacy.cpd.siteSettings", true);
user_pref("privacy.cpd.openWindows", true);

// Time range to clear
//      0 = Everything
//      1 = Last hour
//      2 = Last two hours
//      3 = Last four hours
//      4 = Today
//      5 = Last five minutes
//      6 = Last twenty-four hours
// Диапазон времени для очистки
//      0 = Все
//      1 = Последний час
//      2 = Последние два часа
//      3 = Последние четыре часа
//      4 = Сегодня
//      5 = Последние пять минут
//      6 = Последние сутки
user_pref("privacy.sanitize.timeSpan", 0);

// Open bookmarks in a new tab
// Открытие закладок в новой вкладке
user_pref("browser.tabs.loadBookmarksInTabs", true);

// Opening bookmarks in background tabs
// Открытие закладок в фоновых вкладках
user_pref("browser.tabs.loadBookmarksInBackground", true);

// Maximum number of backup bookmarks
// Максимальное количество резервных закладок
user_pref("browser.bookmarks.max_backups", 3);

// "Backspace" button value
//      0 = Previous page
//      1 = Scroll page up
//      2 = Do nothing
// Значение кнопки "Backspace"
//      0 = Предыдущая страница
//      1 = Прокрутить страницу вверх
//      2 = Ничего не делать
user_pref("browser.backspace_action", 2);

// Защита от отслеживания
// Tracking protection
user_pref("privacy.trackingprotection.enabled", false);
user_pref("privacy.trackingprotection.annotate_channels", false);
user_pref("privacy.trackingprotection.cryptomining.enabled", false);
user_pref("privacy.trackingprotection.fingerprinting.enabled", false);
user_pref("privacy.fingerprintingProtection.pbmode", false);
user_pref("privacy.trackingprotection.pbmode.enabled", false);
user_pref("privacy.antitracking.enableWebcompat", false);

// Automatically play sound in non-active tabs
//      TRUE = Do not play
//      FALSE = Play
// Автоматическое воспроизведение звука в неактивных вкладках
//      TRUE = Не воспроизводить
//      FALSE = Воспроизводить
user_pref("media.block-autoplay-until-in-foreground", true);

// Telemetry
// This feature sends data about usage, browser performance, user interface features, memory and hardware configurations, as well as real IP to Mozilla servers. In addition, information may be collected about the sites visited.
// [WARNING] This is a serious source of leaks and user tracking, do not turn it on.
// Телеметрия
// Эта функция отправляет данные об использовании, производительности браузера, функциях пользовательского интерфейса, конфигурации памяти и оборудования, а также реальных IP-адресах на серверы Mozilla. Кроме того, может собираться информация о посещаемых сайтах.
// [ВНИМАНИЕ] Это серьезный источник утечек и слежения за пользователем, не включайте его.
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabledFirstSession", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("browser.search.serpEventTelemetry.enabled", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint", "data:,");

// Health report details
// [NOTE] This function collects advanced information about the health of the program and sends it to Mozilla servers, in particular: the number of crashes, information about slow loading. It includes data on equipment, operating system, version of this program, installed add-ons (number and type), intra-browser events, rendering, restoration of sessions, their duration, profile age, number of pages visited.
// Данные об отчета о здоровье
// [ЗАМЕТКА] Данная функция собирает расширенную информацию о работоспособности программы и отсылает ее на серверы Mozilla, в частности: количество падений, сведения о медленной загрузке. Она включает в себя данные об оборудовании, операционной системе, версии этой программы, установленных дополнениях (количество и тип), внутрибраузерных событиях, рендеринге, восстановлении сессий, их длительности, возрасте профиля, количестве посещенных страниц.
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Crash reports
// [NOTE] This function sends information about program crashes to the Mozilla server, including technical information (memory status, etc.), time, and visited web links.
// Отчеты о сбоях
// [ЗАМЕТКА] Эта функция отсылает на сервер Mozilla сведения о сбоях программы, включая техническую информацию (состояние памяти и т.п.), время и посещаемые веб-ссылки.
user_pref("breakpad.reportURL", "");
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.tabs.crashReporting.sendReport", false);

// Mozilla VPN Mobile Promotions and Advertisements
// Мобильные акции и реклама Mozilla VPN
user_pref("identity.mobilepromo.android", "");
user_pref("identity.mobilepromo.ios", "");
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("browser.contentblocking.report.vpn-promo.url", "");
user_pref("browser.promo.focus.enabled", false);
user_pref("browser.promo.pin.enabled", false);
user_pref("identity.sendtabpromo.url", "");

// Recommended themes and extensions
// Рекомендованные темы и расширения
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.discovery.containers.enabled", false);
user_pref("extensions.getAddons.showPane", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);

// Page preloading
// Предварительная загрузка страниц
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);
user_pref("network.http.speculative-parallel-limit", 0);

// Captive portal detection
// Обнаружение портала авторизации
user_pref("captivedetect.canonicalURL", "");
user_pref("captivedetect.canonicalContent", "");
user_pref("network.connectivity-service.IPv4.url", "");
user_pref("network.connectivity-service.IPv6.url", "");
user_pref("network.captive-portal-service.enabled", false);
user_pref("network.connectivity-service.enabled", false);

// Synchronization of preferences
// Синхронизация предпочтений
user_pref("services.sync.engine.history", false);
user_pref("services.sync.engine.prefs", false);
user_pref("services.sync.engine.tabs", false);

// Web notifications
// [NOTE] Data is sent to the site(s) not currently open in the browser.
// Веб-уведомления
// [ЗАМЕТКА] Данные отсылаются на сайт(ы) не открытые в данный момент в браузере.
user_pref("dom.webnotifications.enabled", false);
user_pref("dom.webnotifications.requireuserinteraction", false);
user_pref("dom.push.enabled", false);
user_pref("dom.push.connection.enabled", false);

// Disk cache
// Кэш-диска
user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.disk_cache_ssl", false);
user_pref("browser.cache.disk.smart_size.enabled", false);
user_pref("browser.cache.disk.capacity", 0);

// Saving settings to disk for the permission manager
//      TRUE = Keep them until the browser is closed
//      FALSE = Keep them
// Сохранения настроек на диск для диспетчера разрешений
//      TRUE = Хранить их до тех пор, пока браузер не закроется
//      FALSE = Хранить их
user_pref("permissions.memory_only", true);

// Storing extra session data
//      0 = Everywhere
//      1 = Unencrypted sites
//      2 = Nowhere
// Сохранение дополнительных данных сеанса
//      0 = Везде
//      1 = Незашифрованные сайты
//      2 = Нигде
user_pref("browser.sessionstore.privacy_level", 2);

// Restore active session in case of browser crash
// Восстановления активной сессии в случае падения браузера
user_pref("browser.sessionstore.resume_from_crash", false);

// Interval between saving sessions
// Интервал между сохранением сеансов
user_pref("browser.sessionstore.interval", 120000);

// Restoring the browser after restarting the operating system
// Восстановление браузера после перезагрузки операционной системы
user_pref("toolkit.winRegisterApplicationRestart", false);

// Cookies
// [NOTE] A Cookie is a piece of data (a small text file) sent by the server and stored in the browser. When the user reloads the same page, the browser sends the cookie back to the server and notifies it of the previous activity. Cookies store information such as passwords, logins, session data, credit card data, email addresses, and record various user activity and other statistics.
// [WARNING] Cookies are actively used by many web resources in the process of monitoring and tracking user activity. Theft and analysis of cookies is a potentially dangerous and serious attack, leading to global leaks of user data and use.
//      0 = Accept cookies and site data
//      1 = Block third-party cookies
//      2 = Block all cookies
//      3 = Block cookies from sites not visited
//      4 = Block cross-site tracking cookies
//      5 = Block cross-site tracking cookies and isolate other cross-site tracking cookies
// Куки
// [ЗАМЕТКА] Cookie - фрагмент данных (небольшой текстовый файл), отправляемый сервером и сохраняющийся в браузере. Когда пользователь вновь загружает ту же самую страницу, браузер отсылает cookie назад на сервер и уведомляет его о предыдущей активности. Cookie хранят такую информацию, как пароли, логины, сеансовые данные, данные кредитных карт, электронные почтовые адреса и записывают различную пользовательскую активность и прочую статистику.
// [ВНИМАНИЕ] Cookie активно используются многими веб-ресурсами в процессе контроля и слежки за пользовательской активностью. Похищение и анализ cookie является потенциально опасной и серьезной атакой, приводящей к глобальным утечкам пользовательских данных и их использованию.
//      0 = Принимать куки и данные сайтов
//      1 = Блокировать стороннии куки
//      2 = Блокировать все куки
//      3 = Блокировать куки с не посещенных сайтов
//      4 = Блокировать межсайтовые отслеживающие куки
//      5 = Блокировать межсайтовые отслеживающие куки, а также изолировать другие межсайтовые отслеживающие куки
user_pref("network.cookie.cookieBehavior", 4);

// Collecting HTML video statistics
// Сбор HTML-видеостатистики
user_pref("media.video_stats.enabled", false);

// Autocomplete user name and password
// Aвтоматическое заполнение имени пользователя и пароля
user_pref("signon.autofillForms", false);
user_pref("signon.autofillForms.http", false);

// Show password notifications for hacked sites
// Показывать уведомления о паролях для взломанных сайтов
user_pref("signon.management.page.breach-alerts.enabled", false);

// Smooth scrolling
// [NOTE] Recommended for brake applications, hardware failures, and problems with the video card.
// Плавная прокрутка
// [ЗАМЕТКА] Рекомендовано при торможениях, аппаратных сбоях и проблемах с видеокартой.
user_pref("general.smoothScroll", false);

// Path to save files
//      0 = Desktop
//      1 = Downloads
//      2 = Last used folder
// Путь для сохранения файлов
//      0 = Рабочий стол
//      1 = Загрузки
//      2 = Последняя используемая папка
user_pref("browser.download.folderList", 1);
user_pref("browser.download.useDownloadDir", false);

// Adding downloads to the list of recent system documents
// Добавление загрузок в список последних документов системы
user_pref("browser.download.manager.addToRecentDocs", false);

// Show the "Open with" dialog box in the download window
// Показ диалогового окна "Открыть при помощи" в окне загрузки
user_pref("browser.download.forbid_open_with", true);

// Predictor
// [NOTE] This function creates the simplest connections to the server. When the cursor is over a certain link, the browser tries to predict the user's actions on the page in order to increase the performance and speed of content processing.
// Предсказатель
// [ЗАМЕТКА] Эта функция создает простейшие подключения к серверу. Когда курсор находится над определенной ссылкой, браузер пытается предсказать действия пользователя на странице, чтобы повысить производительность и скорость обработки контента.
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

// WebExtension restrictions for specific Mozilla domains
// Ограничения WebExtension для определенных доменов Mozilla
user_pref("extensions.webextensions.restrictedDomains", "");

// Thumbnails of visited pages
//      TRUE = Page thumbnails will not be created
//      FALSE = Page thumbnails will be created
// Эскизы посещенных страниц
//      TRUE = Эскизы страниц создаваться не будут
//      FALSE = Эскизы страниц создаваться будут
user_pref("browser.pagethumbnails.capturing_disabled", true);

// User interface tour (UITour)
// Тур по интерфейсу пользователя
user_pref("browser.uitour.enabled", false);

// Block pop-ups
// Блокировать всплывающие окна
user_pref("dom.disable_open_during_load", true);
user_pref("dom.block_multiple_popups", true);
user_pref("dom.disable_window_move_resize", true);

// Maximum number of pop-ups
// Максимальное количество всплывающих окон
user_pref("dom.popup_maximum", 5);

// Limit events that can trigger a popup
// Ограничить события, которые могут вызвать всплывающее окно
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");

// Setting default permissions (resource://app/defaults/permissions) in the Permission Manager
// Установка по умолчанию разрешений (resource://app/defaults/permissions) в Менеджере Разрешений
user_pref("permissions.manager.defaultsUrl", "");

// Force punycode for internationalized domain names
// Принудительное использование Юникода для интернационализированных доменных имен
user_pref("network.IDN_show_punycode", true);

// Bookmark save format
//      TRUE = Save to HTML
//      FALSE = Save to SQLITE
// Формат сохранения закладок
//      TRUE = Сохранение в HTML
//      FALSE = Сохранение в SQLITE
user_pref("browser.bookmarks.autoExportHTML", false);

// Showing search results
//      TRUE = Open search result in new page
//      FALSE = Open search result in current page
// Показ результатов поиска
//      TRUE = Открывать результат поиска на новой странице
//      FALSE = Открывать результат поиска в текущей странице
user_pref("browser.search.openintab", true);

// Showing search results
//      TRUE = To wrap lines
//      FALSE = Do not wrap lines
// Показ результатов поиска
//      TRUE = Переносить строки
//      FALSE = Не переносить строки
user_pref("view_source.wrap_long_lines", true);

// CSS :visited selectors
// [NOTE] Disables the use of styles with the: visited selector to visited links, which prevents the user from finding out what URLs the user has in the browser history.
// CSS :visited селекторы
// [ЗАМЕТКА] Отключает применение к посещенным ссылкам стилей с селектором :visited, что предотвращает возможность выяснить, какие URL есть у пользователя в истории браузера.
user_pref("layout.css.visited_links_enabled", false);

// Closing the browser when closing the last tab
// Закрытие браузера при закрытии последней вкладки
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Preloading documents or resources specified via <link rel = "preload">
// Предзагрузка документов или ресурсов, указанных через <link rel="preload">
user_pref("network.preload", false);

// Module LaterRun
// [NOTE] Displaying new users with various help information when "N" starts up the browser.
// Модуль LaterRun
// [ЗАМЕТКА] Показ новых пользователей различной справочной информация при "N" запуске браузера.
user_pref("browser.laterrun.enabled", false);

// Pocket extension
// [NOTE] Proprietary application Pocket (formerly known as Read It Later) allows you to save links to texts in the cloud storage for further reading, storing data about user activity and synchronizing them between all devices subscribed to the service. This can de-anonymize users and reveal their preferences.
// Расширение Pocket
// [ЗАМЕТКА] Проприетарное приложение Pocket (ранее известное как Read It Later) позволяет сохранять ссылки на тексты в облачном хранилище для их дальнейшего прочтения, храня таким образом данные о пользовательской активности и синхронизируя их между всеми устройствами, подписанным на услуги сервиса. Это может деанонимизировать пользователей и раскрыть их предпочтения.
user_pref("extensions.pocket.enabled", false);

// Extension Form Autofill
// Расширение Form Autofill
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.available", "off");
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("extensions.formautofill.section.enabled", false);

// Web compatibility reporter
// Отправка отчетов о совместимости с интернетом
user_pref("extensions.webcompat-reporter.enabled", false);

// Black lists
// Черные списки
user_pref("extensions.blocklist.enabled", false);

// Virtual reality
// Виртуальная реальность
user_pref("dom.vr.enabled", false);

// Gamepad control
// Управление геймпадом
user_pref("dom.gamepad.enabled", false);

// Shaking the screen
// Встряхивание экрана
user_pref("dom.vibrator.enabled", false);

// Battery status tracking
// Отслеживание состояния батареи
user_pref("dom.battery.enabled", false);

// Shield
// Щит
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.first_run", false);

// Safe browsing
// Безопасный просмотр
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.allowOverride", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.blockedURIs.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);

// Content blocking
// Блокировка контента
user_pref("browser.contentblocking.category", "custom");
user_pref("browser.contentblocking.cfr-milestone.enabled", false);
user_pref("browser.contentblocking.cryptomining.preferences.ui.enabled", false);
user_pref("browser.contentblocking.database.enabled", false);
user_pref("browser.contentblocking.fingerprinting.preferences.ui.enabled", false);
user_pref("browser.contentblocking.report.lockwise.enabled", false);
user_pref("browser.contentblocking.report.monitor.enabled", false);

// Исследования
// Studies
user_pref("app.shield.optoutstudies.enabled", false);

// Display all parts of a URL in the address bar
// Отображение все частей URL-адреса в адресной строке
user_pref("browser.urlbar.trimURLs", false);

// Reader View
// Вид для чтения
user_pref("reader.parse-on-load.enabled", false);

// Geolocation
// Геолокация
user_pref("geo.enabled", false);

// Search region
// Регион поиска
user_pref("geo.provider.network.url", "");
user_pref("geo.provider.ms-windows-location", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

// Permission settings for sites
//      0 = Always ask
//      1 = Allow
//      2 = Block
// Настройки разрешения для сайтов
//      0 = Всегда спрашивать
//      1 = Разрешать
//      2 = Блокировать
user_pref("permissions.default.geo", 2);
user_pref("permissions.default.camera", 2);
user_pref("permissions.default.desktop-notification", 2);
user_pref("permissions.default.microphone", 0);
user_pref("permissions.default.xr", 2);

// Icon mode
//      0 = Normal
//      1 = Compact
//      2 = Large
// Режим иконок
//      0 = Обычный
//      1 = Компактный
//      2 = Большой
user_pref("browser.uidensity", 1);

// Больше от Mozilla
// More from Mozilla
user_pref("browser.preferences.moreFromMozilla", false);

// Firefox Default Browser Agent
// [ЗАМЕТКА] Задача Агента браузера по умолчанию проверяет, не изменилось ли значение по умолчанию с Firefox на другой браузер.
// Браузерный агент Firefox по умолчанию
// [NOTE] The Default Browser Agent task checks to see if the default value has changed from Firefox to another browser.
user_pref("default-browser-agent.enabled", false);

// Атрибут rel=noopener
// rel=noopener attribute
user_pref("dom.targetBlankNoOpener.enabled", false);

// "Confirm that you want to leave" dialog on the closing page
//      TRUE = Hide this dialog
//      FALSE = Show this dialog
// "Подтвердите, что вы хотите уйти" диалог на странице закрытия
//      TRUE = Скрывать этот диалог
//      FALSE = Показывать этот диалог
user_pref("dom.disable_beforeunload", true);

// First Party Isolation
user_pref("privacy.firstparty.isolate", true);
user_pref("privacy.firstparty.isolate.use_site", true);

// DNS over HTTPS
// DNS поверх HTTPS
user_pref("doh-rollout.clearModeOnShutdown", false);

// Automatic page translation in Firefox
// Автоматический страниц перевод в Firefox
user_pref("browser.translations.automaticallyPopup", false);
user_pref("browser.translations.enable", false);