ShowList = (List) -> console.log JSON.stringify List,null,"\t"


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

			if (UserSpecific[I] is undefined) or (UserSpecific[I] is null)

				if (typeof Default[I]) is "object"

					if Array.isArray Default[I]

						UserSpecific[I] = []

						UserSpecific[I] = ForList Default[I],UserSpecific[I],type

					else

						if not (Default[I] is null)
							UserSpecific[I] = {}

							CopyDefaults Default[I],UserSpecific[I]

				else


					UserSpecific[I] = Default[I]

			else

				if (typeof Default[I]) is "object"

					if Array.isArray Default[I]

						UserSpecific[I] = ForList Default[I],UserSpecific[I],type

					else

						if not (Default[I] is null)

							CopyDefaults Default[I],UserSpecific[I]


CreateNewFn = (OldFn,Custom) -> (EventOb) -> 

	Custom EventOb

	OldFn EventOb

	return

SingleCompose = (Elem,Custom) ->

	for I in (Object.keys Custom)

		CurrentElem = Elem[I]

		if (CurrentElem is undefined) or (CurrentElem is null)

			Elem[I] = Custom[I]

		else

			OldFn = Elem[I]

			NewFn = CreateNewFn OldFn,Custom[I]
 
			Elem[I] = NewFn

	return

Compose = (Elem,Custom,type) ->

	if Elem[type] is undefined

		Elem[type] = {}

		for I in (Object.keys Custom)

			Elem[type][I] = Custom[I]

	else

		SingleCompose Elem[type],Custom

	return



Normalize = (EventName) ->

	TypeOfEvent = typeof EventName

	switch TypeOfEvent

	| "string" => 

		Output = [(eventName:EventName,children:[])]

	| "object" => 

		if Array.isArray EventName

			Output = []

			for I in EventName

				Output.push Normalize I

		else

			Child = Normalize EventName.children

			EventName.children = Child

			Output = EventName

	Output

Events = (update) -> (EventName) ->

	EventName = Normalize EventName

	(EventOb) ->

		for I in EventName
			update I,arguments[0]

eventReact = (Model) -> 
	
	{onchange} = Model

	if (onchange is null) or (onchange is undefined)

		return

	else

		if Array.isArray onchange
			for I in onchange
				I Model
		else
			onchange Model

	return


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

Main.SingleCompose = SingleCompose

Main.Compose = Compose

Main.Events = Events

Main.eventReact = eventReact

module.exports = Main