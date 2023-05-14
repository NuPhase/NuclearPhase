/mob/new_player/proc/get_lobby_browser_html()
	. = {"
	<html>
		<head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<style type='text/css'>
				@font-face {
					font-family: "Fixedsys";
					src: url("FixedsysExcelsior3.01Regular.ttf");
				}

				body, html {
					margin: 0;
					height: 100%;
					overflow: hidden;
					text-align: center;
					background-color: black;
					-ms-user-select: none;
				}

				img {
					display: inline-block;
					width: auto;
					height: 100%;
					-ms-interpolation-mode: nearest-neighbor
				}

				.background {
					position: absolute;
					top: 50%;
					left:50%;
					transform: translate(-50%, -50%);
					z-index: 0;
				}

				.container {
					position: absolute;
					width: auto;
					min-width: 100vmin;
					min-height: 50vmin;
					padding-left: 10vmin;
					padding-top: 60vmin;
					box-sizing: border-box;
					top: 50%;
					left:50%;
					transform: translate(-50%, -50%);
					z-index: 1;
				}

				.container-item {
					display: inline-block;
					font-family: "Fixedsys";
					font-weight: lighter;
					text-decoration: none;
					width: 25%;
					text-align: left;
					color:white;
					margin-right: 100%;
					margin-top: 5px;
					padding-left: 6px;
					font-size: 4vmin;
					line-height: 4vmin;
					height: 4vmin;
					letter-spacing: 1px;
					text-shadow: 2px 2px 0px #000000;
				}

				.container-item:hover {
					font-weight: bolder;
					text-decoration: underline;
				}

			</style>
		</head>
		<body>
	"}

	. += {"<div class="container">"}

	. += {"<a class="container-item" href='?src=\ref[src];lobby_setup=1'>SETUP</a>"}

	if(GAME_STATE <= RUNLEVEL_SETUP)
		. += {"<a id="ready" class="container-item" href='?src=\ref[src];lobby_ready=1'>[ready ? "READY" : "NOT READY"]</a>"}
	else
		. += {"<a class="container-item" href='?src=\ref[src];lobby_crew=1'>CREW MANIFEST</a>"}
		. += {"<a class="container-item" href='?src=\ref[src];lobby_join=1'>JOIN</a>"}

	if(is_admin(src))
		. += {"<a class="container-item" href='?src=\ref[src];lobby_join=1'>OBSERVE</a>"}

	. += "</div>"

	. += "<img src='titlescreen.gif' class='background'>"

	. += {"
		<script>
			var state = 0
			var mark = document.getElementById("ready")
			var marks = \["READY", "NOT READY"\]
			function setReady(new_state) {
				if(new_state) {
					state = new_state
					mark.textContent = marks\[state\]
				}
				else {
					state++
					if(state > marks.length - 1) {
						state = 0
					}
					mark.textContent = marks\[state\]
				}
			}
		</script>
	"}

	. += "</body></html>"
