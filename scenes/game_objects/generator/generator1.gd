extends StaticBody2D
const node_type = "generator"
##------------------------------------------------
## Элемент из которого формируются другие динамические элементы на уровне
##------------------------------------------------
# Сигнал о формировании новых элементов
signal generator_clicked (blocks)
#------------------------------------------------
#Точка формирования элементов
@onready var positionPoint = get_node("button/ColorRect/point")
# Ссылка на ноду с уровнем
@onready var node_level= self.get_parent()
#------------------------------------------------
#@export var Rules : Dictionary= {}

## Тип формируемых элементов по умолчанию и их уровень
@export var ElementType:Globals.GO_TYPES = Globals.GO_TYPES.BALL:
	set (value):
		ElementType = value
	get :
		return ElementType

## Параметры создаваемого объекта, уровень или цвет
@export var ElementLevel:int = 1

func serialize():
	return {
		"type": node_type,
		"pos" : {
			"x": global_position.x,
			"y": global_position.y
			},
		"data":{
			"e": Globals.GO_TYPES_as_str(ElementType),
			"l": ElementLevel
		}
	}

func deserialize (data:Dictionary):
	if (data["type"])!= node_type:
		return false
	ElementType  = Globals.GO_TYPES_from_str(data["data"]["e"] )
	
	ElementLevel = data["data"]["l"] 
	position = Vector2(data["pos"]["x"],data["pos"]["y"])
	return true

#------------------------------------------------
## Автозапуск генератора		
var _wait = 0.75
func _process(delta: float):
	_wait += 1*delta
	if (_wait>=1): 
		start()
		_wait =0
	pass



#------------------------------------------------
# Установка типа элементов генератора
func set_elements(elementType:Globals.GO_TYPES,level):
	ElementType = elementType
	ElementLevel = level
#------------------------------------------------
#------------------------------------------------
#------------------------------------------------
# Формируем список новых блоков
func new_items(count:int =1)->Array:
	var items = []
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	for i in count:
		var item = null
	#	match (_type):
	#		"ball":	
		var color = rand.randi_range(1,Globals.Ball_ColorMap.size()-1)
		item = make_new_block(color)
		#	"egg":	
		#		item = make_egg_block()
		#		pass
		items.append(item)	
	return items	
#------------------------------------------------
# Создаем новый блок
func make_new_block(color=""):
	#print("(generator) -> make_new_block")
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var block = null
	match (ElementType):
		Globals.GO_TYPES.BALL:	
			block = Globals.BallItem.instantiate()
			block.set_color (color)
			block.block_die.connect(_on_destroyed_block)
		Globals.GO_TYPES.EGG: 
			block = Globals.EggItem.instantiate()
			block.add_to_group("balls")
		Globals.GO_TYPES.STONE : 
			block = Globals.StoneItem.instantiate()
			block.set_level(ElementLevel)	
		Globals.GO_TYPES.ICE : 
			block = Globals.IceItem.instantiate()
			block.set_level(ElementLevel)		
	
	block.position =positionPoint.global_position
	block.position.x += rand.randi_range(0,20)
	block.position.y -= rand.randi_range(10,40)
	block.sleeping = true
	
	return block
#------------------------------------------------	
#------------------------------------------------
# Для формирования элементов по клику
func _on_Button_pressed():
	var blocks = new_items(5)
	emit_signal("generator_clicked",blocks)
	#get_parent().append_items(blocks) #!!! TODO
	pass # Replace with function body.
	
#------------------------------------------------
#------------------------------------------------
## генерирует без кликов
@export var Active:bool = true:
	set (value):
		Active = value
	get :
		return Active
"""
@export var GenerateRule:Dictionary = { 
	"active_screen":0, # На каком экране активен 
	#"limit":1, 		# сколько раз выбрасывает шарики
	"max":15, # макс кол-во шариков на экране
	"start": 132   # стартовое число генератора, чтоб уровень одинаково проходился
}
	
"""
# Текущий экран
var active_screen =1
# Правила генерации
var GeneratorRules={
	# экран 1
	1:{		
		"max":25, # макс кол-во шариков на экране
		"min":10, 
		"rules":{
			"ball1":{
				"current":0,	#текущее кол-во шариков на экране
				"min":0,		# мин  кол-во шариков на экране
				"max":0, 		# макс кол-во шариков на экране
				"limit":2,		# число за игру 
				"limited":1		# кол-во граничено
				},
			"ball2":{
				"current":0,
				"min":2,
				"max":10,
				"limit":0,
				},
			"ball3":{
				"current":0,
				"min":0,
				"max":0,
				"limit":4,
				},
			"ball4":{
				"current":0,
				"min":0,
				"max":0,
				"limit":5,
				},
			}
		}
	}
# Текущие элементы	
var Elements = Dictionary() 	
var _unlimited = Dictionary()


func _init_element(name,rule):
	var new_item = {
		"count":0,	# Сколько сформировано, для лимитных
		"current":rule['current'],# Текущее количество
		"active":0, # Нужна ли генерация
		"need" :0 	# Сколько не хватает
	}
	Elements.merge({name:new_item}) 
	
# Проверяем элемент, нужна ли ему генерация
func _check_element(element, rule):
	var need = true

	if (element['count']>=rule['limit']): # Проверка доступных элементов
		if (element['current']>=rule['min']): # Проверка нижней границы
			if (element['current']>=rule['max']): # Проверка верхней границы
				element["need"] =0
				return false
	element["need"] =1	
	return true

# обновление информации при уничтожении шарика	
func _on_destroyed_block(item):
	var item_type = item.get_type()
	if (item_type =='ball'):
		item_type = "ball%s" % item.get_color()
	if Elements.has(item_type):
		var element = Elements[item_type]
		element['current'] -= 1
	
func start():
	var activeRules = GeneratorRules[active_screen]['rules']
	var _balls=0
	for ruleName in activeRules:
		var rule = activeRules[ruleName]
		if !Elements.has(ruleName):
			_init_element(ruleName, rule)
		
		var _element = Elements[ruleName]
		if (rule['limit']==0): # Безлимитный	
			_unlimited.merge({ruleName:_element})
		else:		
			if _check_element(_element,rule):
				var lvl = 1
				make_block(ruleName,lvl)
				#ElementType = Globals.GO_TYPES_from_str(ruleName)
				#var blocks = new_items(Elements[ruleName]["need"])
				_element['current'] +=1 
				_element['count'] +=1 
				#emit_signal("generator_clicked",blocks)	
	# Проверяем правила уровня
	for rulename in _unlimited:
		if (_balls< GeneratorRules[active_screen]['min']):
			make_block(rulename)
			pass
	_unlimited = {}	
		
"""
var _current_data = {
	"screen": 0,
	"balls" : 0,
} 

# Запуск генерации по правилам
func start ():
	if Active :
		var blocks = new_items(3)
		var blocks_to_add=[]
		var index =""
		for item in blocks:
			match item.get_type():
				"ball" : index = "ball%s" % item.color
				"stone": index = "stone"
				"ice"  : index = "ice"
			
			if (Elements[current_screen][index]["limit"]>0 or (not Elements[current_screen][index]["limited"])):
				Elements[current_screen][index]["limit"] -=1
				blocks_to_add.append(item)
			#else :
					#blocks.erase(item)
					#item.free()
		emit_signal("generator_clicked",blocks_to_add)
		#Limits -= 1
		print(Elements)
	checklimits()	
	pass

func checklimits():
	var _active = false
	for key in Elements[current_screen]:
		_active = _active  or (Elements[current_screen][key]["limit"]>=0) or (!Elements[current_screen][key]["limited"])
		if (_active):
			break
	Active = _active
"""	
func make_block(go_type,level:int=1):
	ElementType = Globals.GO_TYPES_from_str(go_type)
	ElementLevel = level
	var blocks = new_items(1)
	emit_signal("generator_clicked",blocks)
	pass
