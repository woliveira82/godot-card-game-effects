extends Control

@export var card_scene: PackedScene

var _drawing: bool = false
var tween: Tween


func _input(event):
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.is_pressed(): return
	
	if not _drawing:
		draw_cards(5)


func draw_cards(amount: int):
	_drawing = true
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for i in range(amount):
		var instance = card_scene.instantiate()
		add_child(instance)
		print("moving")
