extends Camera3D

func _process(delta):
	# Obțineți rotația curentă a camerei
	var current_rotation = global_transform.basis.get_euler()
	
	# Limitați rotația camerei în jurul axei Y
	current_rotation.y = 0
	
	# Setează noua rotație a camerei
	global_transform.basis = Basis().rotated(Vector3(0, 1, 0), current_rotation.y)
