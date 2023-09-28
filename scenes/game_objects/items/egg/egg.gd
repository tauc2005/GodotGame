extends RigidBody2D
class_name EggItem 

const node_type = "egg"
signal egg_catched 

func _ready():
	body_entered.connect(collision_callback)
	#var _err = connect("body_entered",self,"collision_callback")

#------------------------------------------------
# Получение типа
func get_type()-> String:
	return node_type
#------------------------------------------------
func collision_callback(node):
	if node.name == "StaticBody2D":
		var p = node.get_parent()
		if (not p == null):
			if (p.has_method("get_type")):
				var _type = p.get_type()
				if _type == "grass":
					if Globals.DEBAG: print ("Яйцо попало на траву")
					if Globals.DEBAG: print (" EMIT signal 'egg_catch'")
					emit_signal("egg_catched",self)
					queue_free()


func serialize():
	return {
		"type": node_type,
		"pos" : {
			"x": global_position.x,
			"y": global_position.y
			},
	}

func deserialize (data:Dictionary):
	if (data["type"])!= node_type:
		return false
	position = Vector2(data["pos"]["x"],data["pos"]["y"])
	return true
