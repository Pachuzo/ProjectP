
extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var high_score_label = $HighScoreLabel

func _ready():
	setup_labels()
	
	# Conectar las señales del ScoreManager
	if ScoreManager:
		ScoreManager.score_updated.connect(_on_score_updated)
		ScoreManager.high_score_updated.connect(_on_high_score_updated)
	
	# Mostrar valores iniciales
	update_score_display(ScoreManager.get_score())
	update_high_score_display(ScoreManager.get_high_score())

func setup_labels():
	# Configura correctamente la apariencia visual de los labels
	
	# 1. Colores de texto (usa add_theme_color_override)
	score_label.add_theme_color_override("font_color", Color.WHITE)
	high_score_label.add_theme_color_override("font_color", Color.YELLOW)
	
	# 2. Borde del texto - tamaño (numero entero)
	score_label.add_theme_constant_override("outline_size", 2)
	high_score_label.add_theme_constant_override("outline_size", 2)
	
	# 3. Borde del texto - color (usa add_theme_color_override)
	score_label.add_theme_color_override("font_outline_color", Color.BLACK)
	high_score_label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	# 4. Tamanos de fuente
	score_label.add_theme_font_size_override("font_size", 24)
	high_score_label.add_theme_font_size_override("font_size", 18)
	
	# Textos iniciales
	score_label.text = "Puntuacion: 0"
	high_score_label.text = "Record: 0"

func _on_score_updated(nueva_puntuacion: int):
	update_score_display(nueva_puntuacion)

func _on_high_score_updated(nuevo_record: int):
	update_high_score_display(nuevo_record)

func update_score_display(puntuacion: int):
	score_label.text = "Puntuacion: " + str(puntuacion)

func update_high_score_display(record: int):
	high_score_label.text = "Record: " + str(record)
