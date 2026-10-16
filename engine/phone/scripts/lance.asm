LancePhoneCallerScript:
; Once, after the first Hall of Fame: Lance asks the
; player to recruit Kanto's gym leaders for the Open League.
	farwritetext LancePhoneOpenLeagueText
	setevent EVENT_LANCE_CALLED_ABOUT_OPEN_LEAGUE
	specialphonecall SPECIALCALL_NONE
	end

LancePhoneOpenLeagueText:
	text "<PLAY_G>, this is"
	line "LANCE."

	para "I have a favor to"
	line "ask of you."

	para "Since your"
	line "performance at the"
	cont "INDIGO PLATEAU,"
	cont "it got me"
	cont "thinking."

	para "I don't want the"
	line "ELITE FOUR to"
	cont "stagnate."

	para "Will you visit"
	line "KANTO and recruit"
	cont "the GYM LEADERS"
	cont "for the ELITE FOUR"
	cont "challenge?"

	para "Don't worry about"
	line "the JOHTO GYM"
	cont "LEADERS, I can"
	cont "handle them."

	para "Come find me at"
	line "the INDIGO PLATEAU"
	cont "when you're done."
	done
