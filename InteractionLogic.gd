extends Node

# Function qui permet de savoir si c'est la bonne interaction qui a ete invoquee !
func is_matching_interaction(emiter_interaction_tags, reciver_interaction_tags):
	for interaction_tag in emiter_interaction_tags:
		if reciver_interaction_tags.has(interaction_tag):
			return true
	return false

# Function qui va connecter 
func connect_signals(receiver: Object, emiters: Array):
	for emiter in emiters:
		emiter.connect(emiter.signal_name, receiver, "_signal_handler")
