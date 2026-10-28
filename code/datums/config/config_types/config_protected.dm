/decl/configuration_category/protected
	name = "Protected"
	desc = "Configuration options protected from manipulation on-server."
	associated_configuration = list(
		/decl/config/text/comms_password,
		/decl/config/text/ban_comms_password,
		/decl/config/text/login_export_addr,
		/decl/config/text/translate_url,
		/decl/config/text/translate_token
	)

/decl/config/text/comms_password
	uid = "comms_password"
	protected = TRUE
	desc = "Password used for authorizing ircbot and other external tools."

/decl/config/text/translate_url
	uid = "translate_url"
	protected = TRUE
	desc = "URL used for translation. DeepL API."

/decl/config/text/translate_token
	uid = "translate_token"
	protected = TRUE
	desc = "Token used for translation. DeepL API."

/decl/config/text/ban_comms_password
	uid = "ban_comms_password"
	protected = TRUE
	desc = "Password used for authorizing external tools that can apply bans."

/decl/config/text/login_export_addr
	uid = "login_export_addr"
	protected = TRUE
	desc = "Export address where external tools that monitor logins are located."
