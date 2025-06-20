﻿&НаКлиенте
Процедура СписокСотрудниковДатаПриёмаПриИзменении(Элемент)
	
    ТекущаяСтрока = Элементы.СписокСотрудников.ТекущиеДанные;
	
	Если ТекущаяСтрока.ДатаПриёма > ТекущаяДата() Тогда
		
		Сообщить("Дата приёма не может быть в будущем!");
		ТекущаяСтрока.ДатаПриёма = ТекущаяДата();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьНовогосотрудника(ФИО, ДатаРождения, Подразделение, Должность, Оклад, ДатаПрийма)
	
	НовыйСотрудник = Справочники.Сотрудники.СоздатьЭлемент();
	НовыйСотрудник.Наименование = ФИО;
	НовыйСотрудник.ДатаРождения = ДатаРождения;
	НовыйСотрудник.Подразделение = Подразделение;
	НовыйСотрудник.Должность = Должность;
	НовыйСотрудник.Оклад = Оклад;
	НовыйСотрудник.ДатаПриёма = ДатаПрийма;
	
	Попытка
		
		НовыйСотрудник.Записать();
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Провести(Команда)
	
	Для Каждого Строка Из Объект.СписокСотрудников Цикл
		
		Если ПустаяСтрока(Строка.Сотрудник) Тогда
			
			Сообщить("ФИО сотрудника не может быть пустым!");
			Продолжить;
			
		КонецЕсли;
		
		Если СотрудникСуществуетНаСервере(Строка.Сотрудник) Тогда
			
			Ответ = Вопрос("Сотрудник """ + Строка.Сотрудник + """ уже существует! Добавить?", РежимДиалогаВопрос.ДаНет);
			
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				
				Продолжить;	
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДобавитьНовогосотрудника(Строка.Сотрудник, Строка.ДатаРождения, Строка.Подразделение, Строка.Должность, Строка.Оклад, Строка.ДатаПриёма) Тогда
			
			Сообщить("Сотрудник " + Строка.Сотрудник + " добавлен.");
			
		Иначе
			
			Сообщить("Не удалось добавить сотрудника " + Строка.Сотрудник + ". Попробуйте ещё раз.");
			
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция СотрудникСуществуетНаСервере(Сотрудник)	
	
	Возврат СотрудникСуществует(Сотрудник)
	
КонецФункции

&НаКлиенте
Процедура Очистить(Команда)
	Объект.СписокСотрудников.Очистить();
КонецПроцедуры
