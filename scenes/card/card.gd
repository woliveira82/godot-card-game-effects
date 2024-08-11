extends Control

var mouse_hover: bool = false
var mouse_drag: bool = false
var angle_x_max: float = 0.01
var angle_y_max: float = 0.01

var tween_rot: Tween
var tween_handle: Tween


@onready var card_texture = $CardTexture


func _process(_delta):
	if mouse_hover: _rotate_card()
	if mouse_drag: _drag_card()


func _rotate_card():
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)


func _rotate_card_back():
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)


func _drag_card():
	var mouse_pos: Vector2 = get_global_mouse_position()
	global_position = mouse_pos


func _on_gui_input(event: InputEvent):
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	mouse_drag = event.is_pressed()


func _on_mouse_entered():
	mouse_hover = true


func _on_mouse_exited():
	mouse_hover = false
	_rotate_card_back()
