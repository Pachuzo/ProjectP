extends Node


# SEÑALES - Para comunicación entre nodos
signal score_updated(score)           # Se emite cuando la puntuación cambia
signal high_score_updated(high_score) # Se emite cuando hay nuevo récord
signal new_record_achieved(score)     # Se emite específicamente cuando hay NUEVO récord

# VARIABLES DE PUNTUACIÓN
var score = 0                         # Puntuación actual del jugador
var high_score = 0                    # Mejor puntuación histórica
var score_timer = 0.0                 # Temporizador para controlar cuándo sumar puntos
var score_interval = 0.1              # Cada 0.1 segundos suma 1 punto
var is_active = true                  # Controla si el juego está sumando puntos
var is_new_record = false             # Indica si en esta partida se batió récord

func _ready():
	# Función que se ejecuta cuando el nodo se carga
	load_high_score()                  # Carga el récord guardado de partidas anteriores
	print("Score Manager iniciado. High Score: ", high_score)  # Mensaje de depuración

func _process(delta):
	# Función que se ejecuta en cada frame (60 veces por segundo)
	
	# Solo suma puntos si el scoring está activo Y el juego no está pausado
	if is_active and not get_tree().paused:
		score_timer += delta  # Aumenta el temporizador con el tiempo transcurrido
		
		# Cuando el temporizador alcanza el intervalo definido...
		if score_timer >= score_interval:
			score_timer = 0.0  # Reinicia el temporizador
			add_score(1)       # Suma 1 punto a la puntuación

func add_score(points: int):
	"""Función para añadir puntos a la puntuación actual"""
	score += points                    # Suma los puntos a la puntuación actual
	score_updated.emit(score)          # Avisa a otros nodos que la puntuación cambió
	
	# VERIFICAR SI ES NUEVO RÉCORD
	if score > high_score:
		is_new_record = true           # Marca que esta partida tiene nuevo récord
		high_score = score             # Actualiza el récord histórico
		high_score_updated.emit(high_score)  # Avisa que el récord cambió
		new_record_achieved.emit(score)      # Avisa específicamente que hay NUEVO récord
		save_high_score()              # Guarda el nuevo récord en archivo

func reset_score():
	"""Reinicia la puntuación para una nueva partida"""
	score = 0                          # Pone la puntuación actual a cero
	score_timer = 0.0                  # Reinicia el temporizador
	is_new_record = false              # Resetea la bandera de nuevo récord
	score_updated.emit(score)          # Avisa que la puntuación se reinició

func stop_scoring():
	"""Detiene el incremento de puntos (cuando el juego termina)"""
	is_active = false                  # Desactiva el sumado de puntos

func start_scoring():
	"""Reanuda el incremento de puntos (cuando el juego comienza)"""
	is_active = true                   # Reactiva el sumado de puntos

func load_high_score():
	"""Carga el récord desde un archivo de guardado"""
	# Verifica si existe el archivo de guardado
	if FileAccess.file_exists("user://highscore.save"):
		var file = FileAccess.open("user://highscore.save", FileAccess.READ)  # Abre archivo para lectura
		high_score = file.get_32()      # Lee el número guardado (32 bits)
		file.close()                    # Cierra el archivo
	else:
		high_score = 0                  # Si no existe archivo, récord es 0

func save_high_score():
	"""Guarda el récord en un archivo"""
	var file = FileAccess.open("user://highscore.save", FileAccess.WRITE)  # Abre archivo para escritura
	file.store_32(high_score)           # Guarda el número del récord (32 bits)
	file.close()                        # Cierra el archivo
	print("High Score guardado: ", high_score)  # Mensaje de confirmación

func get_score() -> int:
	"""Devuelve la puntuación actual"""
	return score                        # Retorna el valor de la puntuación actual

func get_high_score() -> int:
	"""Devuelve el récord histórico"""
	return high_score                   # Retorna el valor del récord histórico

func is_new_record_achieved() -> bool:
	"""Indica si en esta partida se consiguió nuevo récord"""
	return is_new_record                # Retorna true si hay nuevo récord, false si no
