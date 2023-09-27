Class dc.observer.demo.WebSocketTrigger Extends dc.observer.TriggerAbstract
{

Parameter EVENTTYPE = "Demo";

ClassMethod Update(
	Event As %DynamicObject,
	Data As %DynamicObject,
	Context As %DynamicObject) As %Status
{
    Set ws = ##class(%CSP.WebSocket).%New()
    Set sc = ws.OpenServer(Context.WebSocketID)
    If $$$ISERR(sc) Quit sc
    Quit ws.Write($Select($IsObject(Data):Data.%ToJSON(),1:Data))
}

ClassMethod ToClean(
	Event As %DynamicObject,
	Context As %DynamicObject) As %Boolean
{
    Quit $$$ISERR(##class(%CSP.WebSocket).%New().OpenServer(Context.WebSocketID))
}

}
