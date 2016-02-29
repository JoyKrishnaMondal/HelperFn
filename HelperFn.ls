

ForList = (Default,UserSpecific,type = "merge-right") ->

	switch type
	| "merge-left" =>
		Combined = Default.concat UserSpecific
	| "merge-right" =>
		Combined = UserSpecific.concat Default

	Combined

CopyDefaults = (Default,UserSpecific,type = "merge-right")->

	Keys = Object.keys Default

	for I in Keys

		if UserSpecific[I] is undefined

			if (typeof Default[I]) is "object"

				if Array.isArray Default[I]

					UserSpecific[I] = []

					UserSpecific[I] = ForList Default[I],UserSpecific[I],type

				else

					UserSpecific[I] = {}

					CopyDefaults Default[I],UserSpecific[I]

			else

				UserSpecific[I] = Default[I]

		else

			if (typeof Default[I]) is "object"

				if Array.isArray Default[I]

					UserSpecific[I] = ForList Default[I],UserSpecific[I],type

				else

					CopyDefaults Default[I],UserSpecific[I]



Main = {}

Main.ShowList = (List) -> console.log JSON.stringify List,null,"\t"

Main.CopyDefaults = CopyDefaults

module.exports = Main
