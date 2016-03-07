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

CreateNewFn = (OldFn,Custom) -> (EventOb) -> 

	Output = Custom EventOb

	if Output is undefined
		OldFn EventOb
	else
		OldFn EventOb,Output

Compose = (Elem,Custom,type) ->

	if Elem[type] is undefined

		Elem[type] = {}

		for I in (Object.keys Custom)

			Elem[type][I] = Custom[I]

	else

		for I in (Object.keys Custom)

			if Elem[type][I] is undefined

				Elem[type][I] = Custom[I]

			else

				OldFn = Elem[type][I]

				NewFn = CreateNewFn OldFn,Custom[I]
 
				Elem[type][I] = NewFn

Events = (update) -> (EventName) -> ->

	if arguments.length is 1
			update EventName,arguments[0]

	else
			update arguments[0],arguments[1]



ShowList = (List) -> console.log JSON.stringify List,null,"\t"


TM = require "gsap"

Async = {}

Async.to = (Elem,Time,Ob) -> (done) ->

	Ob.onComplete = done

	TM.to Elem,Time,Ob

Async.fromTo = (Elem,Time,From,To) -> (done) ->

	To.onComplete = done

	TM.fromTo Elem,Time,From,To


Async.setTimeout = (t)-> (f)-> setTimeout f,t


Main = {}

Main.Async = Async

Main.ShowList = ShowList

Main.CopyDefaults = CopyDefaults

Main.Compose = Compose

Main.Events = Events

module.exports = Main
