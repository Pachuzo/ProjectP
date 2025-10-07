extends Node2D

var game_over_scene = preload("res://GameOverMenu.tscn")
var game_over_menu

func _ready():
	game_over_menu = game_over_scene.instantiate()
	add_child(game_over_menu)
	game_over_menu.hide()
	
	# Reiniciar puntuación al empezar
	ScoreManager.reset_score()
	ScoreManager.start_scoring()

func show_game_over_menu():
# Detener el incremento de puntos
	ScoreManager.stop_scoring()
	
# Pasar la puntuación final al menú 
	game_over_menu.set_final_score(ScoreManager.get_score(), ScoreManager.get_high_score())

# Mostrar menú de game over
	game_over_menu.show_menu()
