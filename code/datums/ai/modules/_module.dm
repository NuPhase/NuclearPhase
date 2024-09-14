/*
Any modules are executed in their process_priority in a sorted 'modules' list.
A given module executes its submodules however it needs to, modules are mostly for modes of action and submodules for special actions,
like attacks or interactions with objects.
*/

#define AI_TARGET_TIMEOUT 20 SECONDS

/decl/ai_module
	var/list/submodules = list() // execute these however your ass wishes
	var/process_priority = 0

// return TRUE if handled
/decl/ai_module/proc/process(datum/ai/parent)
	return FALSE

// Лучшее вино - красное каберне