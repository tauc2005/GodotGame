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
		Globals.GO_TYPES.EGG: 
			block = Globals.EggItem.instantiate()
				#block.add_to_group("balls")
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

