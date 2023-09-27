Class dc.observer.demo.WebSocket Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
    Set sc = $$$OK
    If ..WebSocketID = "" Quit sc
    Set ..SharedConnection = 1
    Do ##class(dc.observer.Manager).Subscribe("dc.observer.demo.WebSocketTrigger",{"WebSocketID":(..WebSocketID)})
    Quit sc
}

Method Server() As %Status
{
   Quit $$$OK
}

Method OnPostServer() As %Status
{
    Do ##class(dc.observer.Manager).UnSubscribe("dc.observer.demo.WebSocketTrigger",{"WebSocketID":(..WebSocketID)})
	Quit $$$OK
}

}
