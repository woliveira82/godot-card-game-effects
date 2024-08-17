extends Control

const card_x_offset: float = 50.0

@export var card_scene: PackedScene

var tween: Tween
var original_pos: Vector2
var enter_position: Vector2


func _ready():
	original_pos = position
	enter_position = original_pos - Vector2(0.0, 160.0)


func add_card(card_value: String):
	var instance: Card = card_scene.instantiate()
	instance.value = card_value
	add_child(instance)
	instance.set_card_texture()
	
	instance.card_texture.material.set("shader_parameter/y_rot", 90.0)
	instance.global_position = enter_position
	instance.flip_from_right()
	order_hand()


func order_hand():
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	var cards_in_hand: Array = get_children()
	for i in range(cards_in_hand.size()):
		var new_position = original_pos - Vector2((cards_in_hand.size() - 1) * card_x_offset / 2, 0.0)
		tween.parallel().tween_property(self, "position", new_position, 0.3)
		var card_pos_x = card_x_offset * i
		# var rot_radians: float = lerp_angle(-0.5, 0.5, float(i) / float(cards_in_hand.size() - 1))
		
		tween.parallel().tween_property(cards_in_hand[i], "position", Vector2(card_pos_x, 0.0), 0.3 + (i * 0.1))
		# tween.parallel().tween_property(cards_in_hand[i], "rotation", rot_radians, 0.3 + (i * 0.1))
