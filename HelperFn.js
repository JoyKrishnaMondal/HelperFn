// Generated by LiveScript 1.4.0
(function(){
  var ShowList, ForList, CopyDefaults, CreateNewFn, SingleCompose, Compose, Normalize, Events, eventReact, TM, Async, Main;
  ShowList = function(List){
    return console.log(JSON.stringify(List, null, "\t"));
  };
  ForList = function(Default, UserSpecific, type){
    var Combined;
    type == null && (type = "merge-right");
    switch (type) {
    case "merge-left":
      Combined = Default.concat(UserSpecific);
      break;
    case "merge-right":
      Combined = UserSpecific.concat(Default);
    }
    return Combined;
  };
  CopyDefaults = function(Default, UserSpecific, type){
    var Keys, i$, len$, I, results$ = [];
    type == null && (type = "merge-right");
    Keys = Object.keys(Default);
    for (i$ = 0, len$ = Keys.length; i$ < len$; ++i$) {
      I = Keys[i$];
      if (UserSpecific[I] === undefined || UserSpecific[I] === null) {
        if (typeof Default[I] === "object") {
          if (Array.isArray(Default[I])) {
            UserSpecific[I] = [];
            results$.push(UserSpecific[I] = ForList(Default[I], UserSpecific[I], type));
          } else {
            if (!(Default[I] === null)) {
              UserSpecific[I] = {};
              results$.push(CopyDefaults(Default[I], UserSpecific[I]));
            }
          }
        } else {
          results$.push(UserSpecific[I] = Default[I]);
        }
      } else {
        if (typeof Default[I] === "object") {
          if (Array.isArray(Default[I])) {
            results$.push(UserSpecific[I] = ForList(Default[I], UserSpecific[I], type));
          } else {
            if (!(Default[I] === null)) {
              results$.push(CopyDefaults(Default[I], UserSpecific[I]));
            }
          }
        }
      }
    }
    return results$;
  };
  CreateNewFn = function(OldFn, Custom){
    return function(EventOb){
      Custom(EventOb);
      OldFn(EventOb);
    };
  };
  SingleCompose = function(Elem, Custom){
    var i$, ref$, len$, I, CurrentElem, OldFn, NewFn;
    for (i$ = 0, len$ = (ref$ = Object.keys(Custom)).length; i$ < len$; ++i$) {
      I = ref$[i$];
      CurrentElem = Elem[I];
      if (CurrentElem === undefined || CurrentElem === null) {
        Elem[I] = Custom[I];
      } else {
        OldFn = Elem[I];
        NewFn = CreateNewFn(OldFn, Custom[I]);
        Elem[I] = NewFn;
      }
    }
  };
  Compose = function(Elem, Custom, type){
    var i$, ref$, len$, I;
    if (Elem[type] === undefined) {
      Elem[type] = {};
      for (i$ = 0, len$ = (ref$ = Object.keys(Custom)).length; i$ < len$; ++i$) {
        I = ref$[i$];
        Elem[type][I] = Custom[I];
      }
    } else {
      SingleCompose(Elem[type], Custom);
    }
  };
  Normalize = function(EventName){
    var TypeOfEvent, Output, i$, len$, I, Child;
    TypeOfEvent = typeof EventName;
    switch (TypeOfEvent) {
    case "string":
      Output = [{
        eventName: EventName,
        children: []
      }];
      break;
    case "object":
      if (Array.isArray(EventName)) {
        Output = [];
        for (i$ = 0, len$ = EventName.length; i$ < len$; ++i$) {
          I = EventName[i$];
          Output.push(Normalize(I));
        }
      } else {
        Child = Normalize(EventName.children);
        EventName.children = Child;
        Output = EventName;
      }
    }
    return Output;
  };
  Events = function(update){
    return function(EventName){
      EventName = Normalize(EventName);
      return function(EventOb){
        var i$, ref$, len$, I, results$ = [];
        for (i$ = 0, len$ = (ref$ = EventName).length; i$ < len$; ++i$) {
          I = ref$[i$];
          results$.push(update(I, arguments[0]));
        }
        return results$;
      };
    };
  };
  eventReact = function(Model){
    var onchange, i$, len$, I;
    onchange = Model.onchange;
    if (onchange === null || onchange === undefined) {
      return;
    } else {
      if (Array.isArray(onchange)) {
        for (i$ = 0, len$ = onchange.length; i$ < len$; ++i$) {
          I = onchange[i$];
          I(Model);
        }
      } else {
        onchange(Model);
      }
    }
  };
  TM = require("gsap");
  Async = {};
  Async.to = function(Elem, Time, Ob){
    return function(done){
      Ob.onComplete = done;
      return TM.to(Elem, Time, Ob);
    };
  };
  Async.fromTo = function(Elem, Time, From, To){
    return function(done){
      To.onComplete = done;
      return TM.fromTo(Elem, Time, From, To);
    };
  };
  Async.setTimeout = function(t){
    return function(f){
      return setTimeout(f, t);
    };
  };
  Main = {};
  Main.Async = Async;
  Main.ShowList = ShowList;
  Main.CopyDefaults = CopyDefaults;
  Main.SingleCompose = SingleCompose;
  Main.Compose = Compose;
  Main.Events = Events;
  Main.eventReact = eventReact;
  module.exports = Main;
}).call(this);
