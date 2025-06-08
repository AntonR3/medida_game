extends Control

func get_container(container_id: int):
	for child in get_children():
		if child.get_number() == container_id:
			return child
	push_error("That is not right. The container is missing for number: ", container_id)
