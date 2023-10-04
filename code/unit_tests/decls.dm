/datum/unit_test/decl_validation
	name = "DECL: UIDs shall be unique and valid"
	var/static/list/mandatory_uid_types = list(
		/decl/material
	)

// Handled manually to avoid initializing decls unnecessarily.
#define DECL_TYPE_IS_ABSTRACT(DECL, DTYPE) (initial(DECL.abstract_type) == DTYPE)
/datum/unit_test/decl_validation/start_test()

	var/list/failures = list()

	// Check decl validation.
	var/list/decls_to_validate = decls_repository.get_decls_of_type(/decl)
	for(var/decl_type in decls_to_validate)
		var/decl/decl = decls_to_validate[decl_type]
		var/list/validation_results = decl.validate()
		if(length(validation_results))
			failures[decl_type] = validation_results

	// Report failures.
	if(length(failures))
		fail("[length(failures)] /decl\s failed UID validation:\n[jointext(failures, "\n")]")
	else
		pass("All /decl UIDs were validated successfully.")
	return 1
#undef DECL_TYPE_IS_ABSTRACT
