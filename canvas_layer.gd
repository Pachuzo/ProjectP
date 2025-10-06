extends CanvasLayer  # Usa Node2D si no estás usando CanvasLayer

@onready var continue_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_ContinueAdvertise
@onready var restart_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_Restart
@onready var menu_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_GoMenu
 
func _ready():
	hide()  # Ocultar el menú al iniciar

	continue_button.pressed.connect(_on_continue_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_menu():
	show()
	get_tree().paused = true

func _on_continue_pressed():
	# Oculta el menú
	hide()

	# 🔥 Borra todos los obstáculos
	for obstacle in get_tree().get_nodes_in_group("obstacle"):
		obstacle.queue_free()

	# Espera 3 segundos antes de reanudar
	await get_tree().create_timer(3).timeout

	# Reanuda el juego
	get_tree().paused = false

	# Aquí se puede reactivar al jugador si lo habías desactivado

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")  # Cambia esta ruta si tienes otro menú principal
