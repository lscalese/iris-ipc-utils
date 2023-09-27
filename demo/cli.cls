Class dc.observer.demo.cli Extends (%Net.WebSocket.IEventListener, %RegisteredObject)
{

Method OnMessage(pContent As %Stream.Object)
{
    Write !,$ZDateTime($Horolog, 3, 1), " = Message received: ", !, pContent.Read()
    Quit
}

ClassMethod DemoWs(url As %String = "http://127.0.0.1:52773/csp/observerdemo/dc.observer.demo.WebSocket.cls")
{
    Set o = ..%New()
    Set wsClient = ##class(%Net.WebSocket.Client).%New(url, , o)
    Write !,"Start web socket client "
    For  do wsClient.Next()
    Quit
}

}
