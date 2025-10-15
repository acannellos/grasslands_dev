extends Control

func _unhandled_input(_event: InputEvent):
	if Input.is_action_just_pressed("start"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if get_tree().paused and Input.is_action_just_pressed("select"):
		get_tree().quit()

#func _input(event):
	#if event.is_action_pressed("save"):
		#data.write_save()
		#shared_data.write_save()
#
#func _process(delta):
	#data.update_playtime(delta)
	#data.character.update_data(delta)
		
		#TODO fix panels, close any then quit menu
		#for panel in get_tree().get_nodes_in_group("panels"):
			#if panel.inventory_interface.visible:
				#panel.toggle_inventory_interface()
				#return
			#else:
				#get_tree().quit()
