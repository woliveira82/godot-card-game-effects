extends Control

const max_rot_angle: float = 15.0

var mouse_hover: bool = false
var mouse_drag: bool = false
var angle_x_max: float = 0.01
var angle_y_max: float = 0.01
var max_offset_shadow: float = 30.0

var last_pos: Vector2
var spring: float = 150.0
var damp: float = 10.0
var velocity_multiplier: float = 2.0
var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_hover: Tween
var tween_handle: Tween
var tween_scale: Tween
var tween_rotation: Tween

@onready var card_texture = $CardTexture
@onready var shadow = $Shadow


func _process(delta: float):
	_tilt_card()
	_drag_card(delta)
	_handle_shadow()


func _tilt_card():
	if not mouse_hover: return
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = mouse_pos
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	card_texture.material.set_shader_parameter("x_rot", rot_y)
	card_texture.material.set_shader_parameter("y_rot", rot_x)


func _tilt_card_back():
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_hover.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_hover.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)


func _drag_card(delta: float):
	if not mouse_drag: return
	
	global_position = get_global_mouse_position()

	var velocity = (position - last_pos) / delta
	last_pos = position
	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	rotation = displacement


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT: return
		
		if event.is_pressed():
			mouse_drag = true
			
		else:
			mouse_drag = false
			if tween_handle and tween_handle.is_running():
				tween_handle.kill()
				
			tween_handle = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween_handle.tween_property(self, "rotation", 0.0, 0.3)


func _scale_up_tween():
	tween_scale = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_scale.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)


func _scale_down_tween():
	if tween_scale and tween_scale.is_running():
		tween_scale.kill()
	
	tween_scale = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_scale.tween_property(self, "scale", Vector2.ONE, 0.55)


func _handle_shadow():
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float = global_position.x - center.x
	var offset = remap(distance, -center.x, center.x, max_offset_shadow, -max_offset_shadow)
	shadow.position.x = offset - shadow.size.x / 2


func _on_mouse_entered():
	mouse_hover = true
	_scale_up_tween()


func _on_mouse_exited():
	mouse_hover = false
	_scale_down_tween()
	_tilt_card_back()
