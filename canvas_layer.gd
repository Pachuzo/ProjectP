extends CanvasLayer

# REFERENCIAS A LOS BOTONES Y LABELS DE LA INTERFAZ
@onready var continue_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_ContinueAdvertise
@onready var restart_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_Restart
@onready var menu_button = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/Button_GoMenu
@onready var final_score_label = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/final_score_label
@onready var high_score_label = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/high_score_label
@onready var new_record_label = $ColorRect/CenterContainer/PanelContainer/Panel/VBoxContainer/new_record_label

func _ready():
	# Función que se ejecuta cuando el menú se carga
	hide()  # Oculta el menú al inicio (solo se muestra cuando el juego termina)
	
	# DEBUG: Verificar que todos los nodos existen
	print("=== INICIANDO MENÚ GAME OVER ===")
	print("Continue Button: ", continue_button != null)
	print("Restart Button: ", restart_button != null)
	print("Menu Button: ", menu_button != null)
	print("Final Score Label: ", final_score_label != null)
	print("High Score Label: ", high_score_label != null)
	print("New Record Label: ", new_record_label != null)
	
	# CONECTAR SEÑALES DE LOS BOTONES A SUS FUNCIONES
	continue_button.pressed.connect(_on_continue_pressed)  # Cuando se presiona Continuar
	restart_button.pressed.connect(_on_restart_pressed)    # Cuando se presiona Reiniciar
	menu_button.pressed.connect(_on_menu_pressed)          # Cuando se presiona Menú Principal
	
	# Configurar el label de nuevo récord (inicialmente oculto)
	if new_record_label != null:
		new_record_label.hide()  # Oculta el mensaje de nuevo récord al inicio
	else:
		print("ERROR: NewRecordLabel no encontrado!")

func show_menu():
	"""Función para mostrar el menú de Game Over"""
	print("Mostrando menú de Game Over...")
	show()                          # Hace visible el menú
	get_tree().paused = true        # Pausa todo el juego
	
	# Actualiza las puntuaciones en el menú
	set_final_score(ScoreManager.get_score(), ScoreManager.get_high_score())

func set_final_score(score: int, high_score: int):
	"""Actualiza los labels con las puntuaciones finales"""
	
	print("=== ACTUALIZANDO PUNTUACIONES ===")
	print("Puntuación actual: ", score, " metros")
	print("High Score: ", high_score, " metros")
	print("Es nuevo récord: ", ScoreManager.is_new_record_achieved())
	print("NewRecordLabel es null?: ", new_record_label == null)
	
	# Actualizar label de puntuación actual
	if final_score_label != null:
		final_score_label.text = "Puntuacion: " + str(score)+ " metros"
		print("Final Score Label actualizado")
	else:
		print("ERROR: FinalScoreLabel es null")
	
	# Actualizar label de récord histórico
	if high_score_label != null:
		high_score_label.text = "Record: " + str(high_score) + " metros"
		print("High Score Label actualizado")
	else:
		print("ERROR: HighScoreLabel es null")
	
	# CONTROLAR MENSAJE DE NUEVO RÉCORD
	if new_record_label != null:
		# Verificar si en esta partida se consiguió nuevo récord
		if ScoreManager.is_new_record_achieved():
			print("¡NUEVO RÉCORD DETECTADO! Aplicando efectos...")
			new_record_label.show()                    # Muestra el mensaje
			new_record_label.text = "NEW RECORD!!"     # Establece el texto
			
			# 🔥 APLICAR EFECTOS ESPECIALES
			apply_record_effects()  # Llama a la función de efectos
			
		else:
			print("No es nuevo récord, ocultando label...")
			new_record_label.hide()                    # Oculta el mensaje si no hay récord
	else:
		print("ERROR CRÍTICO: NewRecordLabel es null - No se puede mostrar efecto")

func apply_record_effects():
	"""Aplica efectos especiales al mensaje de nuevo récord"""
	
	print("Iniciando efectos de nuevo récord...")
	
	# VERIFICACIÓN EXTRA DE SEGURIDAD
	if new_record_label == null:
		print("ERROR: NewRecordLabel es null en apply_record_effects")
		return  # Salir de la función si es null
	
	# 1. RESETEAR PROPIEDADES ANTES DE ANIMAR
	new_record_label.scale = Vector2(1, 1)          # Escala normal
	new_record_label.modulate = Color(1, 1, 1, 1)   # Color normal, totalmente visible
	
	# 2. CREAR UN TWEEN PARA ANIMACIONES SUAVES
	var tween = create_tween()
	tween.set_parallel(true)  # Hace que todas las animaciones ocurran al mismo tiempo
	
	# 3. EFECTO DE ESCALA (crece y vuelve)
	tween.tween_property(new_record_label, "scale", Vector2(1.8, 1.8), 0.8)
	tween.tween_property(new_record_label, "scale", Vector2(1.3, 1.3), 0.6)
	
	# 4. EFECTO DE COLOR DORADO INTERMITENTE
	tween.tween_property(new_record_label, "modulate", Color(1, 0.2, 0.2, 1), 0.6)   # Rojo
	tween.tween_property(new_record_label, "modulate", Color(1, 0.7, 0.1, 1), 0.6)   # Naranja
	tween.tween_property(new_record_label, "modulate", Color(1, 1, 0.1, 1), 0.6)     # Amarillo
	tween.tween_property(new_record_label, "modulate", Color(0.1, 1, 0.1, 1), 0.6)   # Verde
	tween.tween_property(new_record_label, "modulate", Color(0.1, 0.1, 1, 1), 0.6)   # Azul
	tween.tween_property(new_record_label, "modulate", Color(1, 0.9, 0.1, 1), 0.6)   # Dorado final
	print("Efectos aplicados correctamente!")

func _on_continue_pressed():
	"""Función llamada cuando se presiona el botón Continuar"""
	print("Botón Continuar presionado")
	hide()  # Oculta el menú de game over
	
	# LIMPIAR OBSTÁCULOS DE LA PANTALLA
	for obstacle in get_tree().get_nodes_in_group("obstacle"):
		obstacle.queue_free()  # Elimina todos los obstáculos existentes
	
	# Esperar 3 segundos antes de reanudar el juego
	await get_tree().create_timer(3).timeout
	
	# REANUDAR EL JUEGO
	get_tree().paused = false         # Quita la pausa del juego
	ScoreManager.start_scoring()      # Reactiva el sumado de puntos

func _on_restart_pressed():
	"""Función llamada cuando se presiona el botón Reiniciar"""
	print("Botón Reiniciar presionado")
	#ScoreManager.reset_score()        # Reinicia la puntuación a cero
	get_tree().paused = false         # Quita la pausa del juego
	get_tree().reload_current_scene() # Recarga la escena actual (nueva partida)

func _on_menu_pressed():
	"""Función llamada cuando se presiona el botón Menú Principal"""
	print("Botón Menú Principal presionado")
	get_tree().paused = false         # Quita la pausa del juego
	# Cambia a la escena del menú principal (asegúrate de que existe)
	get_tree().change_scene_to_file("res://MainMenu.tscn")
