/obj/item/book/manual
	icon = 'icons/obj/library.dmi'
	unique = 1   // 0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/url // Using full url or just tittle, example - Standard_Operating_Procedure (https://wiki.baystation12.net/index.php?title=Standard_Operating_Procedure)

/obj/item/book/manual/Initialize()
	. = ..()
	if(url)		// URL provided for this manual
		// If we haven't wikiurl or it included in url - just use url
		if(get_config_value(/decl/config/text/wikiurl) && !findtextEx(url, get_config_value(/decl/config/text/wikiurl), 1, length(get_config_value(/decl/config/text/wikiurl))+1))
			// If we have wikiurl, but it hasn't "index.php" then add it and making full link in url
			if(get_config_value(/decl/config/text/wikiurl) && !findtextEx(get_config_value(/decl/config/text/wikiurl), "/index.php", -10))
				if(findtextEx(get_config_value(/decl/config/text/wikiurl), "/", -1))
					url = get_config_value(/decl/config/text/wikiurl) + "index.php?title=" + url
				else
					url = get_config_value(/decl/config/text/wikiurl) + "/index.php?title=" + url
			else	//Or just making full link in url
				url = get_config_value(/decl/config/text/wikiurl) + "?title=" + url
		dat = {"
			<html>
				<head>
				</head>
				<body>
					<iframe width='100%' height='100%' src="[url]&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
				</body>
			</html>
			"}
