﻿#Область ОбработчикиСобытийФормы
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// ПодключаемоеОборудование 5556
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	ЗаказУжеНашли = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" Тогда
			//Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Данные = Новый Структура("Штрихкод, Количество, ЕстьВопрос, Ответ, ЕстьОшибка, НадоПечататьЭтикетку, Заказы", Параметр[0],1, Ложь, Неопределено,Ложь,Ложь,Новый Массив ); // Достаем штрихкод из основных данных
			Иначе
				Данные = Новый Структура("Штрихкод, Количество, ЕстьВопрос, Ответ, ЕстьОшибка, НадоПечататьЭтикетку, Заказы", Параметр[1][1],1, Ложь, Неопределено,Ложь,Ложь,Новый Массив); // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			ОбработкаШтрихкодаНаКлиенте(Данные);
			
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Объект.Принято.Количество() <> 0 И Объект.НужноПринять.Количество() <> 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытием", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Сохранить данные приемки?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
	Если Объект.Принято.Количество() <> 0 И Объект.НужноПринять.Количество() = 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытием", ЭтотОбъект, Параметры);
		ТекстВопроса = НСтр("ru = 'Сохранить данные приемки?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытием(Результат, Параметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Принять(Неопределено);
	КонецЕсли;
	
КонецПроцедуры // ВопросПередЗакрытием()


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	
	Данные = Новый Структура("Штрихкод, Количество, ЕстьВопрос, Ответ , ЕстьОшибка, НадоПечататьЭтикетку, Заказы", Штрихкод,1, Ложь, Неопределено,Ложь,Ложь,Новый Массив ); // Достаем штрихкод из дополнительных данных
	ОбработкаШтрихкодаНаКлиенте(Данные);
	Штрихкод = "";
	ЭтаФорма.ТекущийЭлемент = Элементы.Штрихкод;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаШтрихкодаНаКлиенте(Данные)

ОбработкаШтрихкодаНаСервере(Данные);	

КонецПроцедуры // ОбработкаШтрихкодаНаКлиенте()

&НаСервере
Процедура ОбработкаШтрихкодаНаСервере(ДанныеШтрихкода)
	
	Штрихкод = ДанныеШтрихкода.Штрихкод;
	Если Штрихкод <> "666" Тогда
		Если ЗаказУжеНашли = Ложь И Документы.ЗаказПокупателя.НайтиПоРеквизиту("Штрихкод", Штрихкод) <> Документы.ЗаказПокупателя.ПустаяСсылка() Тогда
			ЗаказПокупателя = Документы.ЗаказПокупателя.НайтиПоРеквизиту("Штрихкод", Штрихкод);
			ЗаказУжеНашли = Истина;
			Перемещение = Документы.ПеремещениеЗапасов.НайтиПоРеквизиту("ЗаказПокупателя", ЗаказПокупателя);
			Если Перемещение <> Документы.ПеремещениеЗапасов.ПустаяСсылка() И Перемещение.Проведен Тогда
				ПолучитьДанныеПриемки();
			Иначе
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru = 'Не найдено перемещение запасов!'");
				Сообщение.Сообщить();
				ЗаказУжеНашли = Ложь;
				Возврат;
	 		КонецЕсли;
		ИначеЕсли ЗаказУжеНашли И Документы.ЗаказПокупателя.НайтиПоРеквизиту("Штрихкод", Штрихкод) = ЗаказПокупателя Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Этот заказ уже выбран!'");
			Сообщение.Сообщить();
			ЗаказУжеНашли = Истина;
			Возврат;
		ИначеЕсли ЗаказУжеНашли И ЗаказПокупателя <> Документы.ЗаказПокупателя.ПустаяСсылка() И Документы.ЗаказПокупателя.НайтиПоРеквизиту("Штрихкод", Штрихкод) <> ЗаказПокупателя Тогда
			ДанныеНоменклатуры = ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода);
			ДанныеНоменклатуры = ДанныеНоменклатуры[Штрихкод];
			Если ДанныеНоменклатуры.Количество() <> 0 Тогда
				стрНоменклатура = Новый Структура;
				стрНоменклатура.Вставить("Номенклатура", ДанныеНоменклатуры.Номенклатура);
				стрНоменклатура.Вставить("ЕдиницаИзмерения", ДанныеНоменклатуры.Номенклатура.ЕдиницаИзмерения);
				Если ДанныеНоменклатуры.ЕдиницаИзмерения = Справочники.ЕдиницыИзмерения.ПустаяСсылка() Тогда
					стрНоменклатура.Вставить("Коэффициент", 1);
				Иначе
					стрНоменклатура.Вставить("Коэффициент", ДанныеНоменклатуры.ЕдиницаИзмерения.Коэффициент);
				КонецЕсли; 
				ОбработатьВыборНоменклатуры(стрНоменклатура);
			Иначе
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru = 'Не найдена номенклатура!'");
				Сообщение.Сообщить();
				ЗаказУжеНашли = Истина;
				Возврат;
			КонецЕсли; 
		Иначе
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не найден заказ!'");
			Сообщение.Сообщить();
			ЗаказУжеНашли = Ложь;
			Возврат;
		КонецЕсли;
	Иначе
		Если ЗаказУжеНашли И ЗаказПокупателя <> Документы.ЗаказПокупателя.ПустаяСсылка() И Объект.НужноПринять.Количество() = 0 И Объект.Принято.Количество() <> 0 Тогда
			ЗаписатьВПриходныйОрдер();
			СнятьРезерв();
			ЗаказОбъект = ЗаказПокупателя.ПолучитьОбъект();
			ЗаказОбъект.ВариантЗавершения 	= Перечисления.ВариантыЗавершенияЗаказа.Успешно;
			ЗаказОбъект.СостояниеЗаказа 	= Справочники.СостоянияЗаказовПокупателей.Завершен;
			ЗаказОбъект.Записать();

			ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка();
			Объект.НужноПринять.Очистить();
			Объект.Принято.Очистить();			
			ЗаказУжеНашли = Ложь;
			Возврат;

			//Ордер = ЗаписатьВПриходныйОрдер();
			//Если Ордер <> Документы.ПриходныйОрдер.ПустаяСсылка() И Ордер.Проведен Тогда
			//	СнятьРезерв();
			//	ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка();
			//	Объект.НужноПринять.Очистить();
			//	Объект.Принято.Очистить();			
			//	ЗаказУжеНашли = Ложь;
			//	Возврат;
			//Иначе
			//	Сообщение = Новый СообщениеПользователю;
			//	Сообщение.Текст = НСтр("ru = 'Снять резерв не возможно!'");
			//	Сообщение.Сообщить();
			//	ЗаказУжеНашли = Истина;
			//	Возврат;
			//КонецЕсли;
			
		ИначеЕсли ЗаказУжеНашли И ЗаказПокупателя <> Документы.ЗаказПокупателя.ПустаяСсылка() И Объект.НужноПринять.Количество() <> 0 И Объект.Принято.Количество() <> 0 Тогда
			ЗаписатьВПриходныйОрдер();
			СнятьРезерв();
			ЗаказОбъект = ЗаказПокупателя.ПолучитьОбъект();
			ЗаказОбъект.ВариантЗавершения 	= Перечисления.ВариантыЗавершенияЗаказа.Успешно;
			ЗаказОбъект.СостояниеЗаказа 	= Справочники.СостоянияЗаказовПокупателей.Завершен;
			ЗаказОбъект.Записать();
			ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка();
			Объект.НужноПринять.Очистить();
			Объект.Принято.Очистить();			
			ЗаказУжеНашли = Ложь;
			Возврат;
			
			//Сообщение = Новый СообщениеПользователю;
			//Сообщение.Текст = НСтр("ru = 'По заказу принят не весь товар!'");
			//Сообщение.Сообщить();
			//ЗаказУжеНашли = Истина;
			//Возврат;
			
		ИначеЕсли ЗаказУжеНашли И ЗаказПокупателя <> Документы.ЗаказПокупателя.ПустаяСсылка() И Объект.НужноПринять.Количество() <> 0 И Объект.Принято.Количество() = 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Сначала нужно принять товар по заказу!'");
			Сообщение.Сообщить();
			ЗаказУжеНашли = Истина;                                   
			Возврат;
		ИначеЕсли ЗаказУжеНашли = Ложь ИЛИ ЗаказПокупателя = Документы.ЗаказПокупателя.ПустаяСсылка() Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Сначала нужно выбрать заказ!'");
			Сообщение.Сообщить();
			ЗаказУжеНашли = Ложь;                                   
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры
//раз два
//аа
&НаСервере
Процедура ПолучитьДанныеПриемки()
	
	Объект.НужноПринять.Очистить();
	Объект.Принято.Очистить();
	Ордер = Документы.ПриходныйОрдер.НайтиПоРеквизиту("ДокументОснование", Перемещение);
	Если Ордер <> Документы.ПриходныйОрдер.ПустаяСсылка() И Ордер.Проведен = Ложь Тогда
		Для каждого СрокаОрдера Из Ордер.Запасы Цикл
			//
			СтрокаПринято = Объект.Принято.Добавить(); //
			//
			ЗаполнитьЗначенияСвойств(СтрокаПринято, СрокаОрдера);
		КонецЦикла;
		Для каждого СтрокаПеремещения Из Перемещение.Запасы Цикл
			СтруктураПоиска = Новый Структура("Номенклатура", СтрокаПеремещения.Номенклатура);
			СтрокаПринято = Объект.Принято.НайтиСтроки(СтруктураПоиска);
			Если СтрокаПринято.Количество() = 0 Тогда
				КоличествоПринято = 0;
			Иначе
				КоличествоПринято = СтрокаПринято[0].Количество;
			КонецЕсли;
			СтрокаНужноПринять = Объект.НужноПринять.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНужноПринять, СтрокаПеремещения);
			СтрокаНужноПринять.Количество = СтрокаНужноПринять.Количество - КоличествоПринято;
		КонецЦикла;
		ОчиститьНулевыеСтроки(Объект.НужноПринять);
	Иначе
		Для каждого СтрокаПеремещения Из Перемещение.Запасы Цикл
			СтрокаНужноПринять = Объект.НужноПринять.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНужноПринять, СтрокаПеремещения);
		КонецЦикла;	
	КонецЕсли; 
		
	//СохраненнаяСборкаЗаказа = СохраненнаяСборкаЗаказа;
	//	ЭтаФорма.Заказ = СохраненнаяСборкаЗаказа.ЗаказПокупателя;
	//	Объект.НужноСобрать.Очистить();
	//	Объект.Собрано.Очистить();
	//	Для каждого СохраненнаяСтрока Из СохраненнаяСборкаЗаказа.НужноСобрать Цикл
	//		СтрокаТЧ =  Объект.НужноСобрать.Добавить();
	//		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СохраненнаяСтрока);
	//	КонецЦикла; 
	//	Для каждого СохраненнаяСтрока Из СохраненнаяСборкаЗаказа.Собрано Цикл
	//		СтрокаТЧ =  Объект.Собрано.Добавить();
	//		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СохраненнаяСтрока);
	//	КонецЦикла; 
	
КонецПроцедуры // ПолучитьДанныеПриемки()

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ПолучитьНоменклатуруПоШтрихкоду(ДанныеШтрихкода)
	
	ШтрихкодыМассив = Новый Массив;
	ШтрихкодыМассив.Добавить(ДанныеШтрихкода);
	Возврат РегистрыСведений.ШтрихкодыНоменклатуры.ПолучитьДанныеПоШтрихкодам(ШтрихкодыМассив);
	
КонецФункции // ПолучитьНоменклатуруПоШтрихкоду()

Процедура ОбработатьВыборНоменклатуры(стрНоменклатура)
	
	СтруктураПоиска = Новый Структура("Номенклатура", стрНоменклатура.Номенклатура);
	НайденнаяСтрокаНужноПринять = Объект.НужноПринять.НайтиСтроки(СтруктураПоиска);
	Если НайденнаяСтрокаНужноПринять.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не найдена номенклатура!'");
		Сообщение.Сообщить();
		Возврат;
	Иначе
		НайденнаяСтрокаНужноПринять[0].Количество = НайденнаяСтрокаНужноПринять[0].Количество - стрНоменклатура.Коэффициент;
		НайденнаяСтрокаПринято = Объект.Принято.НайтиСтроки(СтруктураПоиска);
		Если НайденнаяСтрокаПринято.Количество() = 0 Тогда
			НоваяСтрокаПринято = Объект.Принято.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПринято, стрНоменклатура);
			НоваяСтрокаПринято.Количество = стрНоменклатура.Коэффициент;
		Иначе
			НайденнаяСтрокаПринято[0].Количество = НайденнаяСтрокаПринято[0].Количество + стрНоменклатура.Коэффициент;
		КонецЕсли;
		ОчиститьНулевыеСтроки(Объект.НужноПринять);
	КонецЕсли; 
	
КонецПроцедуры // ОбработатьВыборНоменклатуры()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ОчиститьНулевыеСтроки(ТабЧасть)
	
	ВременнаяТабЧасть = ТабЧасть.Выгрузить();
	ТабЧасть.Очистить();
	Для каждого Строка Из ВременнаяТабЧасть Цикл
		Если Строка.Количество <> 0 Тогда
			НовСтрока = ТабЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);		
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры // ОчиститьНулевыеСтроки(ТабЧасть)


// <Описание процедуры>
//
//
&НаСервере
Процедура ЗаписатьВПриходныйОрдер()
	
	Перемещение = Документы.ПеремещениеЗапасов.НайтиПоРеквизиту("ЗаказПокупателя", ЗаказПокупателя);
	Ордер = Документы.ПриходныйОрдер.НайтиПоРеквизиту("ДокументОснование", Перемещение);
	Если Ордер = Документы.ПриходныйОрдер.ПустаяСсылка() Тогда
		ОрдерОбъект = Документы.ПриходныйОрдер.СоздатьДокумент();
	Иначе
		ОрдерОбъект = Ордер.ПолучитьОбъект();
	КонецЕсли;
	ОрдерОбъект.Дата = ТекущаяДата();
	ОрдерОбъект.Заполнить(Перемещение);
	ОрдерОбъект.Запасы.Очистить();
	Для каждого СтрокаПринято Из Объект.Принято Цикл
		СтрокаОрдер = ОрдерОбъект.Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаОрдер, СтрокаПринято);
	КонецЦикла;
	Если Объект.Принято.Итог("Количество") = Перемещение.Запасы.Итог("Количество") Тогда
		ОрдерОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Приходный ордер проведен!'");
		Сообщение.Сообщить();
	Иначе
		ОрдерОбъект.Записать();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'По заказу принят не весь товар! Приходный ордер сохранен!'");
		Сообщение.Сообщить();
	КонецЕсли; 

КонецПроцедуры // ЗаписатьВПриходныйОрдер()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура СнятьРезерв()
	
	Резервирование = Документы.РезервированиеЗапасов.НайтиПоРеквизиту("ЗаказПокупателя", ЗаказПокупателя);
	Если Резервирование = Документы.РезервированиеЗапасов.ПустаяСсылка() Тогда
		РезервированиеОбъект = Документы.РезервированиеЗапасов.СоздатьДокумент();
	Иначе
		РезервированиеОбъект = Резервирование.ПолучитьОбъект();
	КонецЕсли;
	РезервированиеОбъект.Дата = ТекущаяДата();
	РезервированиеОбъект.Заполнить(ЗаказПокупателя);
	РезервированиеОбъект.Запасы.Очистить();
	Для каждого СтрокаПриемки Из Объект.Принято Цикл
		СтрокаРезервирования = РезервированиеОбъект.Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаРезервирования, СтрокаПриемки);
		СтрокаРезервирования.ИсходноеМестоРезерва = ЗаказПокупателя.СкладОбеспечения;
		СтрокаРезервирования.НовоеМестоРезерва = Справочники.СтруктурныеЕдиницы.ПустаяСсылка();
	КонецЦикла;
	Если Объект.Принято.Итог("Количество") = Перемещение.Запасы.Итог("Количество") Тогда
		РезервированиеОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Резерв снят!'");
		Сообщение.Сообщить();
	Иначе
		РезервированиеОбъект.Записать();
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'По заказу принят не весь товар! Резерв снят не полностью!'");
		Сообщение.Сообщить();
	КонецЕсли; 

КонецПроцедуры // СнятьРезерв()

&НаКлиенте
Процедура Принять(Команда)
	
	Данные = Новый Структура("Штрихкод, Количество, ЕстьВопрос, Ответ , ЕстьОшибка, НадоПечататьЭтикетку, Заказы", Штрихкод,1, Ложь, Неопределено,Ложь,Ложь,Новый Массив );
	Данные.Вставить("Штрихкод", 666);
	ОбработкаШтрихкодаНаКлиенте(Данные);
	Штрихкод = "";
	ЭтаФорма.ТекущийЭлемент = Элементы.Штрихкод;
	
КонецПроцедуры // Принять()

&НаКлиенте
Процедура НужноПринятьВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка =Ложь;	
	сткПараметры = Новый Структура("ИдетификаторСтроки",ВыбраннаяСтрока);
	// Вставить содержимое обработчика.
	//СколькоПеренести = 0;
	Оповещение = Новый ОписаниеОповещения("ПослеВводаКоличестваПереместитьШтук", ЭтотОбъект,сткПараметры);
	ПоказатьВводЧисла(Оповещение, 1, "Введите количество посчитанных штук", 4, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаКоличестваПереместитьШтук(СколькоПеренести, Параметры) Экспорт
	Если НЕ СколькоПеренести = Неопределено Тогда
		// обработка введенного количества
		НайденнаяСтрока =  Объект.НужноПринять.НайтиПоИдентификатору(Параметры.ИдетификаторСтроки);
		Если СколькоПеренести > 0 Тогда
			Если СколькоПеренести > НайденнаяСтрока.Количество Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Вы ввели больше необходимого";
				Сообщение.Сообщить();
				Возврат;
			Иначе
				стрНоменклатура = Новый Структура;
				стрНоменклатура.Вставить("Номенклатура",  НайденнаяСтрока.Номенклатура);
				стрНоменклатура.Вставить("Коэффициент", СколькоПеренести);
				
				ОбработатьВыборНоменклатуры(стрНоменклатура)				
			КонецЕсли;
		КонецЕсли;
		
		ОчиститьНулевыеСтрокиИзКлиента(Параметры.ИдетификаторСтроки)
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ОчиститьНулевыеСтрокиИзКлиента(ИдетификаторСтроки)
	
	ОчиститьНулевыеСтроки(Объект.НужноПринять);	
	
КонецПроцедуры


	
#КонецОбласти 