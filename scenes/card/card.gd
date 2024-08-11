extends Button

var following_mouse: bool = false
var angle_x_max: float = 0.01
var angle_y_max: float = 0.01

var tween_rot: Tween

@onready var card_texture = $CardTexture


func _on_gui_input(event):
	
	if following_mouse: return
	if not event is InputEventMouseMotion: return
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	print("Mouse: ", mouse_pos)
	print("Card: ", position + size)
	var diff: Vector2 = mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)


func _on_mouse_exited():
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
		
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)
