﻿
&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	   Попытка
		
		ТекущаяСтрока = Элементы.Сотрудники.ТекущиеДанные;
		
		// Проверяем, что не уволен
		Если СотрудникУволенНаСервере(ТекущаяСтрока.Сотрудник) Тогда
			
			Сообщить("Сотрудник """ + ТекущаяСтрока.Сотрудник + """ уже уволен!");
			ТекущаяСтрока.Сотрудник = Неопределено;
			Возврат;
			
		КонецЕсли;
		
		// Получаем данные сотрудника для заполнения полей
		ИнфоСотрудника = ПолучитьДанныеСотрудникаССервера(ТекущаяСтрока.Сотрудник);
		
		// Заполняем поля текущими данными сотрудника
		ТекущаяСтрока.Оклад = ИнфоСотрудника.Оклад;
		
	Исключение
		
		Сообщить("Ошибка: " + ОписаниеОшибки());
		
	КонецПопытки;

КонецПроцедуры

&НаСервере
Функция СотрудникУволенНаСервере(СотрудникСсылка)
	Возврат СотрудникУволен(СотрудникСсылка);	
КонецФункции
   
&НаСервере
Функция ПолучитьДанныеСотрудникаССервера(СотрудникСсылка)
   Возврат ПолучитьДанныеСотрудникаПоСсылке(СотрудникСсылка);	
КонецФункции


&НаКлиенте
Процедура КомандаВыполнить(Команда)
	
	Для Каждого Строка Из Объект.Сотрудники Цикл
		УстановитьОкладСотрудникуНаСервере(Строка.Сотрудник, Строка.Оклад);
	КонецЦикла;
	
	Если Объект.Сотрудники.Количество() = 0 Тогда
		Сообщить("Сначала добавьте сотрудников!");
	Иначе
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура УстановитьОкладСотрудникуНаСервере(СотрудникСсылка, НовыйОклад)
	
	Если ЗначениеЗаполнено(СотрудникСсылка) И ТипЗнч(НовыйОклад) = Тип("Число") Тогда
		ОбъектСотрудник = СотрудникСсылка.ПолучитьОбъект();
		// изменяем данные объекта
		ОбъектСотрудник.Оклад = НовыйОклад;
		ОбъектСотрудник.Записать();
	Иначе
		Сообщить("Переданы неправильные значения");	
	КонецЕсли;
	                       
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	// устанавливаем выбранное значение
	Объект.Подразделение = ВыбранноеЗначение;
	
	ПодразделениеОбработкаВыбораНаСервере();
	// обновляем таблицу
	Элементы.Сотрудники.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеОбработкаВыбораНаСервере()
	
	// получаем сотрудников подразделения из запроса	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадровыеПеремещенияСрезПоследних.Сотрудник
		|ИЗ
		|	РегистрСведений.КадровыеПеремещения.СрезПоследних КАК КадровыеПеремещенияСрезПоследних
		|ГДЕ
		|	КадровыеПеремещенияСрезПоследних.Подразделение = &Подразделение
		|	И КадровыеПеремещенияСрезПоследних.Действие <> &ДействиеУвольнение";
	
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);  
	Запрос.УстановитьПараметр("ДействиеУвольнение", Перечисления.КадровыеДействия.Увольнение); 
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	// чистим таблицу
	Объект.Сотрудники.Очистить();
	// заполняем таблицу
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = Объект.Сотрудники.Добавить();
		НоваяСтрока.Сотрудник =  ВыборкаДетальныеЗаписи.Сотрудник;
		НоваяСтрока.Оклад =  ВыборкаДетальныеЗаписи.Сотрудник.Оклад;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Объект.Сотрудники.Очистить();
	Объект.Подразделение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОкладПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Сотрудники.ТекущиеДанные;
	МРОТ = ПолучитьМРОТССервера();
	
	Если ТекущаяСтрока.Оклад < МРОТ Тогда
		Сообщить("Оклад не может быть ниже МРОТ!");
		ТекущаяСтрока.Оклад = МРОТ;
	КонецЕсли;

КонецПроцедуры


&НаСервере
  Функция ПолучитьМРОТССервера()
	  Возврат Константы.МРОТ.Получить();
  КонецФункции

