#Подготовка и сборка Adguard/AdguardPro для iOS (Safari).

##Установить Xcode 7.3 или выше.

##Получить исходники из приватного git репозитория. 

Для этого открыть Terminal.app и зайти в удобный для вас рабочий каталог. Выполнить набор команд 

<pre>
mkdir AG
cd AG
git clone git@git.adguard.com:ios.git
</pre>

Таким образом вы получите master ветку, которая содержит последний стабильный код. Эта ветка используется для сборки приложений для внутреннего тестирования а также для обновления локализаций.  

##Подключить Apple ID к Xcode.

Apple ID должен иметь аккаунт разработчика и входить в команду Performiks OOO как разработчик.
Для подключение следует открыть Xcode, в главном меню Xcode -> Preferences -> Accounts. Добавить аккаунт в список.

##Oткрыть "workspace" в Xcode.

Открыть .../AG/trunk/Applications/iOS/AdguardSafariExtension/trunk/AdguardSafariExtension-iOS.xcworkspace в Xcode.

##Проверить состояние Identity и Capabilities.

Выбрать настройки проекта. (В Project navigator, который левая панель со списком файлов, выбрать проект Adgurad). В главном окне выбрать в разделе TARGETS Adguard. На вкладке General в разделе Identity проверить значение поля Team, оно должно содержать "Performiks OOO". Так же рядом не должно быть ни каких предупреждений. Если такие предупреждения имеются, то как правило, также присутствует кнопка "Fix Issue", которую следует нажать. Цель манипуляций - отсутствие предупреждений и поле Team в значении "Performiks OOO".

Далее переключить на вкладку Capabilities. Проверить состояние раздела App Groups. В разделе не должно быть предупреждений и подсветки красным. В случае проблем должна присутствовать кнопка "Fix Issue", которую следует нажать.

Выполнить аналогичные проверки для целей (TARGETS): AdguardBlockingExtension, ActionExtension, Adguard Pro, ProActionExtension, ProBlockingExtension, ProTunnel.

##Собрать проект.

Для сборки Adguard (стандартная версия) выбрать схему AdguardExtension (Xcode главное меню Product -> Scheme -> AdguardExtension) и нажать cmd-B (Build).
Для сборки Adguard Pro выбрать схему Adguard Pro (Xcode главное меню Product -> Scheme -> Adguard Pro) и нажать cmd-B (Build).


#Обновление локализаций (если это требуется).

Действия выполнять в Xcode, в открытом AdguardSafariExtension-iOS.xcworkspace .

Для экспорта базовой локали в http://www.oneskyapp.com надо выбрать схему "Export Localization" (Xcode главное меню Product -> Scheme -> Export Localization) и нажать cmd-B (Product -> Build).

Для импорта в проект локализаций с http://www.oneskyapp.com надо выбрать схему "Import Localization" (Xcode главное меню Product -> Scheme -> Import Localization) и нажать cmd-B (Product -> Build).

#Особенности ведения разработки (workflow).

Adguard for iOS - это проект с открытым исходным кодом. Но репозиторий содержит так же и наши приватные объекты, такие как скрипты локализации, медия ресурсы и т.д. По этому существует разделение. Ветка `master` содержит все исходники, включая приватные объекты, ветка `public` только открытую часть исходников, которую можно заливать на публичный репозиторий (GitHub). 

##Рабочий процесс.

Все разработки ведутся в отдельных ветках, способ именования:

* ветки для работы над новыми функциями: `feature/[issue number]`
* ветки для исправления багов: `bug/[issue number]`
* ветки для хотфиксов: `hotfix/[issue number]`

При этом  если исправления касаются приватной части исходников, то их надо выделить в отдельную ветку, или можно такие исправления выполнять сразу в `master` ветке.

По завершению работы, для публичных изменений делаем merge в `master` и в `public`, для приватных только в `master`.
Слияние между `master` и `public` не выполняется! По крайней мере при "нормальном" рабочем процессе.

По необходимости (желанию) `public` ветка заливается (push) на публичный репозиторий (GitHub).

##Release/beta/master ветки

Ветки `beta` и `release` используются только для того, чтобы всегда была возможность собрать тот же код, который был на момент текущей беты и текущего релиза. При необходимости выпустить релиз или бету необходимо сперва ветку `master` смержить с соответственно веткой `beta` или `release`.

##Выгрузка изменений в публичный репозиторий, по необходимости

В начале следует настроить публичный remote
<pre>
cd ios
git remote add github https://github.com/AdguardTeam/AdguardForiOS.git
</pre>
для проверки настроек выполните
<pre>
git remote -v 
</pre>
Должно получится
<pre>
github	https://github.com/AdguardTeam/AdguardForiOS.git (fetch)
github	https://github.com/AdguardTeam/AdguardForiOS.git (push)
origin	git@git.adguard.com:ios.git (fetch)
origin	git@git.adguard.com:ios.git (push)
</pre>

После этого для выгрузки изменений ветки `public` на GitHub можно пользоваться командой
<pre>
git push github public:master
</pre>

Все эти настройки также можно выполнить через UI Xcode (Menubar -> Source Control -> ios-master -> Configure ios...).

#Подкотовка и загрузка в App Store.

Действия выполнять в Xcode, в открытом AdguardSafariExtension-iOS.xcworkspace .

Переключится на ветку `beta` или `release` (Xcode главное меню Source Control -> ios-`<branch>` -> Switch to Branch...), в зависимости от того что вы хотите выгрузить. Выполнить слияние из `master`, если требуется.

##Для Adguard (стандарт)

В Project navigator, который левая панель со списком файлов, выбрать `Adguard-Config.xcconfig` в проекте Adguard. В главном окне прописать требуемые значения для: `AG_VERSION`, `AG_BUILD`.

Выбрать схему AdguardExtension (Xcode главное меню Product -> Scheme -> AdguardExtension) и выбрать в  главном меню Product -> Archive. По завершению процесса должно открыться окно Organizer. В окне Organizer должен быть выбран только что созданный вами архив Adguard. Для отправки  нажать кнопку "Upload to App Store...".

##Для Adguard Pro

В Project navigator, который левая панель со списком файлов, выбрать `Adguard-Pro-Config.xcconfig` в проекте Adguard -> группа AdguardPro. В главном окне прописать требуемые значения для: `AG_VERSION`, `AG_BUILD`.

Выбрать схему Adguard Pro (Xcode главное меню Product -> Scheme -> Adguard Pro) и выбрать в  главном меню Product -> Archive. По завершению процесса должно открыться окно Organizer. В окне Organizer должен быть выбран только что созданный вами архив Adguard Pro. Для отправки  нажать кнопку "Upload to App Store...".


##Примечание

Для возможности загрузки в App Store следует иметь в вашей "Связке ключей" идентификацию для дистрибуции, это валидный, для данного проекта iOS Distribution сертификат с приватным ключем. 
