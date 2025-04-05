extends Control

var holding := false

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index in [MOUSE_BUTTON_MIDDLE, MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_LEFT] :
			holding = event.pressed
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if holding else Input.MOUSE_MODE_VISIBLE
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN] :
			var ncz = %Camera3D.position.z - (.8 if event.button_index==MOUSE_BUTTON_WHEEL_UP else -.8)
			if  ncz >=2 and ncz<=30:
				%Camera3D.position.z -= .8 if event.button_index==MOUSE_BUTTON_WHEEL_UP else -.8
	if event is InputEventMouseMotion :
		if not holding : return
		%CameraPivotY.rotation_degrees.y -= event.relative.x*.1
		if %CameraPivotX.rotation_degrees.x - event.relative.y*.1 > -40:
			if %CameraPivotX.rotation_degrees.x - event.relative.y*.1 < 0:
				%CameraPivotX.rotation_degrees.x -= event.relative.y*.1
				%CameraPivotX.rotation_degrees.x = clampf(%CameraPivotX.rotation_degrees.x, -40, 0)

func _physics_process(delta: float) -> void:
	var speed: float = 10+((%Camera3D.position.z-2)/28.)*15
	if Input.is_action_pressed("ui_up") :
		%CameraPivotY.global_position -= delta*speed*(%Camera3D.global_basis.z*Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_down") :
		%CameraPivotY.global_position += delta*speed*(%Camera3D.global_basis.z*Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_left") :
		%CameraPivotY.global_position -= delta*speed*(%Camera3D.global_basis.x*Vector3(1,0,1)).normalized()
	if Input.is_action_pressed("ui_right") :
		%CameraPivotY.global_position += delta*speed*(%Camera3D.global_basis.x*Vector3(1,0,1)).normalized()
	
	%Camera3D.position.z = clampf(%Camera3D.position.z, 2, 30)
	%CameraPivotY.global_position.y = 2
