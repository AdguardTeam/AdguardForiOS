#Подготовка и сборка расширения для iOS Safari.

##Установить Xcode 7.1 или выше.

##Получить исходники из svn. 

Для этого открыть Terminal.app и зайти в удобный для вас рабочий каталог. Выполнить набор команд для получения частичного дерева svn, которое будет содержать только необходимые для сборки исходники:

<pre>
mkdir AG
cd AG
svn checkout --depth=immediates http://svn.performix.ru/svn/AG/trunk
cd trunk
svn checkout --depth=immediates http://svn.performix.ru/svn/AG/trunk/Applications/
cd Applications
svn checkout --depth=infinity http://svn.performix.ru/svn/AG/trunk/Applications/iOS/
</pre>

##Подключить Apple ID к Xcode.

Apple ID должен иметь аккаунт разработчика и входить в команду Performiks OOO как разработчик.
Для подключение следует открыть Xcode, в главном меню Xcode -> Preferences -> Accounts. Добавить аккаунт в список.

##Oткрыть "workspace" в Xcode.

Открыть .../AG/trunk/Applications/iOS/AdguardSafariExtension/trunk/AdguardSafariExtension-iOS.xcworkspace в Xcode.

##Проверить состояние Identity и Capabilities.

Выбрать настройки проекта. (В Project navigator, который левая панель со списком файлов, выбрать проект Adgurad). В главном окне выбрать в разделе TARGETS Adguard. На вкладке General в разделе Identity проверить значение поля Team, оно должно содержать "Performiks OOO". Так же рядом не должно быть ни каких предупреждений. Если такие предупреждения имеются, то как правило, также присутствует кнопка "Fix Issue", которую следует нажать. Цель манипуляций - отсутствие предупреждений и поле Team в значении "Performiks OOO".

Далее переключить на вкладку Capabilities. Проверить состояние раздела App Groups. В разделе не должно быть предупреждений и подсветки красным. В случае проблем должна присутствовать кнопка "Fix Issue", которую следует нажать.

Выполнить аналогичные проверки для целей (TARGETS): AdguardBlockingExtension, ActionExtension.

##Собрать проект.

Выбрать схему AdguardExtension (Xcode главное меню Product -> Scheme -> AdguardExtension) и нажать cmd-B (Build)


#Обновление локализаций (если это требуется).

Действия выполнять в Xcode, в открытом AdguardSafariExtension-iOS.xcworkspace .

Для экспорта базовой локали в http://www.oneskyapp.com надо выбрать схему "Export Localization" (Xcode главное меню Product -> Scheme -> Export Localization) и нажать cmd-B (Product -> Build).

Для импорта в проект локализаций с http://www.oneskyapp.com надо выбрать схему "Import Localization" (Xcode главное меню Product -> Scheme -> Import Localization) и нажать cmd-B (Product -> Build).


#Подкотовка и загрузка в App Store.

Действия выполнять в Xcode, в открытом AdguardSafariExtension-iOS.xcworkspace .

В Project navigator, который левая панель со списком файлов, выбрать Config.xcconfig в корне. В главном окне прописать требуемые значения для: AG_VERSION, AG_BUILD.

Выбрать схему AdguardExtension (Xcode главное меню Product -> Scheme -> AdguardExtension) и выбрать в  главном меню Product -> Archive. По завершению процесса должно открыться окно Organizer. В окне Organizer должен быть выбран только что созданный вами архив AdguardExtension. Для отправки  нажать кнопку "Upload to App Store...".

Примечание:

Для возможности загрузки в App Store следует иметь в вашей "Связке ключей" идентификацию для дистрибуции, это валидный, для данного проекта iOS Distribution сертификат с приватным ключем. 
