extends CharacterBody2D


# Variables de movimiento
@export var gravity = 850          # Fuerza de caída (gravedad)
@export var fly_force = -350       # Impulso hacia arriba (jetpack o salto)
@export var speed = 350            # Velocidad horizontal (izq./der.)

# Se ejecuta una vez al iniciar
func _ready():
	# Posiciona el personaje en el centro de la pantalla
	position = get_viewport_rect().size / 2

# Detecta entrada táctil (en móviles)
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Si se toca la pantalla, el personaje sube
		velocity.y = fly_force

# Movimiento general del personaje
func _physics_process(delta):
	# Aplica gravedad (aceleración hacia abajo cada frame)
	velocity.y += gravity * delta

	# Si se pulsa espacio o "Aceptar" (ENTER, por defecto), también sube
	if Input.is_action_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE):
		velocity.y = fly_force

	# Reinicia velocidad horizontal cada frame (para que no se acumule)
	velocity.x = 0

	# Detecta si se pulsa izquierda o derecha (teclado o gamepad)
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed

	# Aplica el movimiento (con detección de colisiones)
	move_and_slide()

	# === LÍMITES DE LA PANTALLA ===

	# Límite superior: no puede subir más de la pantalla
	if position.y < 0:
		position.y = 0
		velocity.y = 0

	# Límite inferior: no puede caer por debajo del borde inferior
	var screen_height = get_viewport_rect().size.y
	if position.y > screen_height - 10:
		position.y = screen_height - 10
		velocity.y = 0

	# Límite izquierdo y derecho: no puede salirse de los lados
	var screen_width = get_viewport_rect().size.x
	if position.x < 0:
		position.x = 0
	elif position.x > screen_width:
		position.x = screen_width

#Detectar la colison y mostrar el menu
func _on_body_entered(body):
	if body.is_in_group("obstacle"):  # o cualquier lógica 
		get_node("/root/Main").show_game_over_menu()
