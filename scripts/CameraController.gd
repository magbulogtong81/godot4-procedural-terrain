extends Node3D


var _mouse_sensitivity = 0.5
# Called when the node enters the scene tree for the first time.


func _unhandled_input(event):
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if (event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		
		var move_value_x = deg_to_rad(event.relative.y * _mouse_sensitivity * -1)
		var move_value_y = deg_to_rad(event.relative.x * _mouse_sensitivity * -1)
		$"../".rotate_y(move_value_y)
		$FPP.rotate_x(move_value_x)
		var rotation = $FPP.rotation_degrees
		rotation.x = clamp( rotation.x, -70.0, 70.0)
		$FPP.rotation_degrees = rotation
		
		
		
		pass
