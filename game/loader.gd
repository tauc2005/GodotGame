extends Node
#class_name Loader

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





#------------------------------------------------
# Загрузка json уровня
#------------------------------------------------
# Загрузка файла json
func load_from_json(filename):
	if (not FileAccess.file_exists(filename)):
		printerr("Файл не найден - %s"%[filename])	
		return null
		
	var file = FileAccess.open(filename,FileAccess.READ)
	var json = JSON.new()
	var json_string = file.get_as_text()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
	var data = json.get_data()
	file.close()
	if typeof(data)==TYPE_DICTIONARY:
		return data
	else:
		printerr("Ошибка в данных файла %s"%[filename])	

	

func load_level_from_file(number:int):
	var level_name = _load_level_name(number)
	var data = load_from_json(level_name)
	return data

func _load_level_name(number:int):
	if Globals.DEBAG: print("(loader) ->  load_level_name")
	if Globals.DEBAG: print("	load name for level: ",number)
	var l_name = ""
	if (Globals.DEBAG_LOCAL==true):
		l_name = "%s/lvl%s.json"%[Globals.LEVELS_PATH_LOCAL,number]
	
	if Globals.DEBAG: print("path:" +l_name)		
	return l_name		

#------------------------------------------------
# Загрузка пользовательских данных
#------------------------------------------------
func load_userdata():
	Player.Level =2
	Player.Lives =3
	Player.Money = 1580
