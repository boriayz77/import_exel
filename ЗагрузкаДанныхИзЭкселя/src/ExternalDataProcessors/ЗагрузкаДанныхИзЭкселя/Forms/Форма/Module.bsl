
#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Асинх Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогОткрытия = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытия.МножественныйВыбор = Ложь;
	ДиалогОткрытия.Фильтр ="Exel-файл|*.xlsx|";
	ДиалогОткрытия.Заголовок="Загрузите Exel-Файл";
	РезультатВыбора =Ждать ДиалогОткрытия.ВыбратьАсинх();
	Если (РезультатВыбора = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	Объект.Путь= РезультатВыбора[0];
	
КонецПроцедуры
#КонецОбласти
#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Создание(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	ПоместитьСозданиеФайлВоВременноеХранилище();
КонецПроцедуры

&НаКлиенте
Процедура Проверка(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	ПоместитьПроверкуФайлаВоВременноеХранилище();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДокумента(Команда)

КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Асинх Процедура ЗаполнениеТабличнойЧасти()
	Описание = Ждать ПоместитьФайлНаСерверАсинх(,,,Объект.Путь,УникальныйИдентификатор);
    Если (Описание =Неопределено) Тогда
    	Возврат;
    КонецЕсли;
    ЗаполнениеТабличнойЧастиНаСервере(Описание.Адрес);
    
КонецПроцедуры
&НаКлиенте
Асинх Процедура ПоместитьПроверкуФайлаВоВременноеХранилище()
	Описание = Ждать ПоместитьФайлНаСерверАсинх(,,,Объект.Путь,УникальныйИдентификатор);
    Если (Описание =Неопределено) Тогда
    	Возврат;
    КонецЕсли;
    ПроверкаДанныхНаСервере(Описание.Адрес);
КонецПроцедуры
&НаКлиенте
Асинх Процедура ПоместитьСозданиеФайлВоВременноеХранилище()
	Описание = Ждать ПоместитьФайлНаСерверАсинх(,,,Объект.Путь,УникальныйИдентификатор);
    Если (Описание =Неопределено) Тогда
    	Возврат;
    КонецЕсли;
    СозданиеДанныхНаСервере(Описание.Адрес);
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнениеТабличнойЧастиНаСервере(АдресВременногоХранилища)
        ТабличныйДокумент = ПолучениеДокументаИзВременногоХранилища(АдресВременногоХранилища);
             Сообщение = Новый СообщениеПользователю();
        	 Сообщение.Текст=НСтр("ru = 'Документ загружен'");
        	 Сообщение.Сообщить();
КонецПроцедуры
&НаСервереБезКонтекста
Процедура ЗаполнениеДокументаНаСервере(АдресВременногоХранилища)
        ТабличныйДокумент = ПолучениеДокументаИзВременногоХранилища(АдресВременногоХранилища);
    Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиКТО.Наименование
	|ИЗ
	|	Справочник.ЗадачиКТО КАК ЗадачиКТО
	|ГДЕ
	|	ЗадачиКТО.Наименование <> """"";
	Результат= Запрос.Выполнить();
    ТаблицаЗначений = Результат.Выгрузить();
    Счетчик=0;
        Для  Строка=1 по ТабличныйДокумент.ВысотаТаблицы Цикл
        	ИмяЗадачи= ТабличныйДокумент.Область(Строка,1).Текст;
        	//НайденаЗадача = Справочники.ЗадачиКТО.НайтиПоНаименованию(ИмяЗадачи,Истина);
        	НайденаяЗадача=ТаблицаЗначений.Найти(ИмяЗадачи,"Наименование");
        	Если Не ЗначениеЗаполнено(НайденаяЗадача) Тогда
        		Счетчик=Счетчик+1;
        	КонецЕсли;
        КонецЦикла;
             Сообщение = Новый СообщениеПользователю();
        	 Сообщение.Текст=СтрШаблон(НСтр("ru = 'Задач найдено %1'"),Счетчик);
        	 Сообщение.Сообщить();
КонецПроцедуры
&НаСервереБезКонтекста
Процедура ПроверкаДанныхНаСервере(АдресВременногоХранилища)
        ТабличныйДокумент = ПолучениеДокументаИзВременногоХранилища(АдресВременногоХранилища);
    Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиКТО.Наименование
	|ИЗ
	|	Справочник.ЗадачиКТО КАК ЗадачиКТО
	|ГДЕ
	|	ЗадачиКТО.Наименование <> """"";
	Результат= Запрос.Выполнить();
    ТаблицаЗначений = Результат.Выгрузить();
    Счетчик=0;
        Для  Строка=1 по ТабличныйДокумент.ВысотаТаблицы Цикл
        	ИмяЗадачи= ТабличныйДокумент.Область(Строка,1).Текст;
        	//НайденаЗадача = Справочники.ЗадачиКТО.НайтиПоНаименованию(ИмяЗадачи,Истина);
        	НайденаяЗадача=ТаблицаЗначений.Найти(ИмяЗадачи,"Наименование");
        	Если Не ЗначениеЗаполнено(НайденаяЗадача) Тогда
        		Счетчик=Счетчик+1;
        	КонецЕсли;
        КонецЦикла;
             Сообщение = Новый СообщениеПользователю();
        	 Сообщение.Текст=СтрШаблон(НСтр("ru = 'Задач найдено %1'"),Счетчик);
        	 Сообщение.Сообщить();
КонецПроцедуры
&НаСервереБезКонтекста
Процедура СозданиеДанныхНаСервере(АдресВременногоХранилища)
        ТабличныйДокумент = ПолучениеДокументаИзВременногоХранилища(АдресВременногоХранилища);
    Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ЗадачиКТО.Наименование
	|ИЗ
	|	Справочник.ЗадачиКТО КАК ЗадачиКТО
	|ГДЕ
	|	ЗадачиКТО.Наименование <> """"";
	Результат= Запрос.Выполнить();
    ТаблицаЗначений = Результат.Выгрузить();
        Счетчик=0;
        Для  Строка=1 по ТабличныйДокумент.ВысотаТаблицы Цикл
        	ИмяЗадачи= ТабличныйДокумент.Область(Строка,1).Текст;
        	ОписаниеЗадачи=ТабличныйДокумент.Область(Строка,2).Текст;
        	//НайденаЗадача = Справочники.ЗадачиКТО.НайтиПоНаименованию(ИмяЗадачи,Истина);
        	НайденаяЗадача=ТаблицаЗначений.Найти(ИмяЗадачи,"Наименование");
        	Если Не ЗначениеЗаполнено(НайденаяЗадача) Тогда
        	НоваяЗадача=Справочники.ЗадачиКТО.СоздатьЭлемент();
        	НоваяЗадача.Наименование=ИмяЗадачи;
        	НоваяЗадача.Описание=ОписаниеЗадачи;
        	Попытка
        		НоваяЗадача.Записать();
        		Счетчик=Счетчик+1;
        	Исключение
        	 Сообщение = Новый СообщениеПользователю();
        	 Сообщение.Текст=СтрШаблон(НСтр("ru = 'задача с названием %1 не создана'"),ИмяЗадачи);
        	 Сообщение.Сообщить();
        	КонецПопытки;
        	КонецЕсли;
        КонецЦикла;
             Сообщение = Новый СообщениеПользователю();
        	 Сообщение.Текст=СтрШаблон(НСтр("ru = 'задач ссоздано %1'"),Счетчик);
        	 Сообщение.Сообщить();
КонецПроцедуры
&НаСервереБезКонтекста 
Функция ПолучениеДокументаИзВременногоХранилища(АдресВременногоХранилища)
	Данные=ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xlsx");
	Данные.Записать(ИмяВременногоФайла);
	ТабличныйДокумент= Новый ТабличныйДокумент();
	ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайла);
	УдалитьИзВременногоХранилища(АдресВременногоХранилища);
	Возврат ТабличныйДокумент;
КонецФункции
#КонецОбласти