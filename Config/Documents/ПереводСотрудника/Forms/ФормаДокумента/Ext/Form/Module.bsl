﻿

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ДанныеСотрудника =  ПолучитьДанныеСотрудникаССервераПоСсылке(Объект.Сотрудник);
	
	Если ДанныеСотрудника = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;	
	
	Объект.Подразделение = ДанныеСотрудника.Подразделение;
	Объект.Должность = ДанныеСотрудника.Должность;
	Объект.Оклад = ДанныеСотрудника.Оклад;
	Объект.Дата = ТекущаяДата();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеСотрудникаССервераПоСсылке(СотрудникСсылка)
		
	Возврат ПолучитьДанныеСотрудникаПоСсылке(СотрудникСсылка);
	
КонецФункции

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Ссылка.Пустая() Тогда
		// проверка сотрудника
		Если Не СотрудникВШтате(Объект.Сотрудник) Тогда
			Сообщить("Сотрудник """ + ТекущийОбъект.Сотрудник + """ не в штате!");
			Отказ = Истина;
			Возврат;
		КонецЕсли; 
		// проверка оклада
		Если ТекущийОбъект.Оклад < Константы.МРОТ.Получить() Тогда
			Сообщить("Оклад не может быть ниже МРОТ");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Если документ не новый
	Если Не Объект.Ссылка.Пустая() Тогда
		// проверка прав на редактирование
		Если НачалоДня(Объект.Дата) < НачалоДня(ТекущаяДата()) И Не РольДоступна("Администратор") Тогда
			ЭтаФорма.ТолькоПросмотр = Истина;
			Сообщить("Запрещено редактировать проведённые документы за прошедшую дату! Обратитесь к администратору.");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры
