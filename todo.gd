#TODO

# * evidence
# * dialogues
# * level locks
# * helps
# * ending points
# * paper texture
# * debris animation
# * pickup animation
# * sounds
#level animation bug

extends Node
class killer:
	var xp
	var max_xp

func levelup():
	var _killer = killer.new()
	var level
	var xp
	var max_xp
	
	while _killer.xp >= _killer.max_xp: 
		_killer.level += 1 
		_killer.xp -= _killer.max_xp 
		_killer.max_xp += 20 

	SERVER_TO_CLIENT_Allowed_update_level.rpc_id(get_parent().peer_id, level)
	SERVER_TO_CLIENT_Allowed_update_experience.rpc_id(get_parent().peer_id, xp, max_xp)

@rpc("any_peer","call_local","reliable")
func SERVER_TO_CLIENT_Allowed_update_level():
	pass

@rpc("any_peer","call_local","reliable")
func SERVER_TO_CLIENT_Allowed_update_experience():
	pass

	#? now the while loop will check for another loop
	while _killer.xp >= _killer.max_xp: #? your xp is now 2 as stated above, and the new max is now 120. this will be false
		pass #? the rest of the code won run and the while loop ends because you dont have enough xp to level up again

	

