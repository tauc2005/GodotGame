extends StaticBody2D

#------------------------------------------------
# Элемент из которого формируются другие динамические элементы на уровне
#------------------------------------------------
# Сигнал о формировании новых элементов
signal generator_clicked (blocks)
#------------------------------------------------
#Точка формирования элементов
@onready var positionPoint = get_node("button/ColorRect/point")
# Ссылка на ноду с уровнем
@onready var node_level= self.get_parent()
#------------------------------------------------
# Тип формируемых элементов по умолчанию и их уровень
var _type = "ball"
var _item_lvl =1
#------------------------------------------------
# Установка типа элементов генератора
func set_type(value,level):
	_type = value
	_item_lvl = level
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
func make_new_block(color):
	#print("(generator) -> make_new_block")
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	
	var block = null
	match (_type):
		"ball":	
			block = Globals.BallItem.instantiate()
			block.set_color (color)
			
		"egg" : 
			block = Globals.EggItem.instantiate();
				#block.add_to_group("balls")
		"stone" : 
			block = Globals.StoneItem.instance()
			block.set_level(_item_lvl)	
		"ice" : 
			block = Globals.IceItem.instance()
			block.set_level(_item_lvl)		
	
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
	pass # Replace with function body.
