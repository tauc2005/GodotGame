extends RigidBody2D
class_name IceItem 

const node_type = "ice"
signal item_destroyed(node)

@export var level:int =1
@export var delete = false

@onready var image = get_node("img")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Globals.GO_GROUPS_NAMES[Globals.GO_TYPES.ICE])

#------------------------------------------------
func destroy():
	_level_down()
	delete = false
	if level==0:
		emit_signal("item_destroyed",self)
		queue_free()
	else:
		_update_sprite()	
#------------------------------------------------
# Получение типа
func get_type()-> String:
	return node_type
#------------------------------------------------	
# Сложность
#------------------------------------------------
func set_level(value):
	level = value	

func _level_down():
	print_debug("(ice) -> level down")
	level -=1	

# Изменение изображения спрайта
func _update_sprite():#TODO1
	pass	
#------------------------------------------------
#------------------------------------------------
# Мышь попала в зону объекта
func check_inside(pos)->bool:
	var size = 25
	if pos.x >position.x - size and pos.x<position.x+size and pos.y >position.y - size and pos.y<position.y+size:
		return true
	return false	
#------------------------------------------------
func serialize():
	return {
		"type": node_type,
		"pos" : {
			"x": global_position.x,
			"y": global_position.y
			},
		"lvl": level	
	}

func deserialize (data:Dictionary):
	if (data["type"])!= node_type:
		return false
	position = Vector2(data["pos"]["x"],data["pos"]["y"])
	level =data["lvl"] 
	return true
