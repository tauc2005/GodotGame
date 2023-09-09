extends Node
#class_name Loader

var LevelData :Dictionary:
		get: return LevelData
	

#------------------------------------------------
# Загрузка json уровня
#------------------------------------------------
# Выдача данных настроек уровня
func get_level_data(type:String=""):
	if (type==""):
		return Loader.LevelData
	if (Loader.LevelData.has(type)):
		var data = Loader.LevelData[type]
		return data
	return false	

#------------------------------------------------	
func load_level_data(level_id:int):
	var level_name = _load_level_name(level_id)
	var res = _load_from_json(level_name)
	if (not res): 
		return false
	else:  
		LevelData = res
		return true
	
# Загрузка файла json
func _load_from_json(filename):
	if (not FileAccess.file_exists(filename)):
		printerr("Файл не найден - %s"%[filename])	
		return false
		
	var file = FileAccess.open(filename,FileAccess.READ)
	var json = JSON.new()
	var json_string = file.get_as_text()
	file.close()
	
	var parse_result = json.parse(json_string)	
	if not parse_result == OK:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return false
	var data = json.get_data()
	if typeof(data)==TYPE_DICTIONARY:
		return data
	else:
		printerr("Ошибка в данных файла %s"%[filename])	
		return false

	
# Формирования названия файла для загрузки
func _load_level_name(number:int):
	if Globals.DEBAG: print("(loader) ->  load_level_name")
	if Globals.DEBAG: print("	load name for level: ",number)
	var l_name = ""
	if (Globals.DEBAG_LOCAL==true):
		l_name = "%s/lvl%s.json" % [Globals.LEVELS_PATH_LOCAL,number]
	
	if Globals.DEBAG: print("path:" +l_name)		
	return l_name		
#------------------------------------------------

#------------------------------------------------
## Загрузка пользовательских данных
#------------------------------------------------
func load_userdata():
	Player.Level =1
	Player.Lives =5
	Player.Money = 1580
