extends Node2D

var game_over_scene = preload("res://GameOverMenu.tscn")
var game_over_menu

func _ready():
	game_over_menu = game_over_scene.instantiate()
	add_child(game_over_menu)
	game_over_menu.hide()

func show_game_over_menu():
	game_over_menu.show_menu()
