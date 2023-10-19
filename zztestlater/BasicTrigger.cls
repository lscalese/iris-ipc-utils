Class dc.ipcutils.BasicTrigger Extends dc.ipcutils.TriggerAbstract
{

Parameter EVENTTYPE = "Demo";

/// Do ##class(dc.observer.Manager).Subscribe("dc.observer.BasicTrigger",{"id":"123"})
/// Do ##class(dc.observer.Manager).Notify("Demo:OnTest",{})
ClassMethod Update(
	EventObject As %DynamicObject,
	Data As %DynamicObject,
	Context As %DynamicObject) As %Status
{
    Set key = $Increment(^dc.demo("log"))
    Set ^dc.demo("log", key, "Data") = $Select($IsObject(Data):Data.%ToJSON(),1:Data)
    Set ^dc.demo("log", key, "EventObject") = EventObject.%ToJSON()
    Set ^dc.demo("log", key, "Context") = Context.%ToJSON()
	Quit $$$OK
}

}
