extends Area2D
class_name LevelBase 

#------------------------------------------------
# Реализация игровой логики
signal make_step
signal score_changed

var _items = null 
var _world = null

#------------------------------------------------
#------------------------------------------------
func set_item_node(node):
	_items = node
	
func add_item_node(item:Node):	
	_items.add_child(item)
#------------------------------------------------
func set_world_node(node):
	_world = node	
#------------------------------------------------	
# Добавление элементов на поле
func add_world_item(item:Node):	
	#for item in items:
	_world.add_child(item)
	
#------------------------------------------------
#------------------------------------------------
# Перезапуск игры
func reset_level():
	print ("(Level_base) - reset level")
	if (_world != null):
		for n in _world.get_children():
			_world.remove_child(n)
			n.queue_free()
	if (_items !=null):		
		for n in _items.get_children():
			_items.remove_child(n)
			n.queue_free()
	pass
#------------------------------------------------

