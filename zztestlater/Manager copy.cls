Include ipcutils

Class dc.ipcutils.Manager copy
{

Parameter ACKTIMEOUT = 3;

ClassMethod Subscribe(
	Observer As %String,
	Context As %DynamicObject = {{}}) As %Status
{
    If $IsObject(Observer) {
        Set $$$Subscribed(Observer.EventType, $Classname(Observer), Observer.ResourceName) = $ListBuild(Observer.EventType,Observer.ResourceName,$zdt($H,3,1),$Job,Context.%ToJSON(),1)
        Quit $$$OK
    }
    
    Set Event = $Parameter(Observer, "EVENTTYPE")
    Set $$$Subscribed(Event, Observer, ..HashContext(Context)) = $ListBuild(Event,Observer,$zdt($H,3,1),$Job,Context.%ToJSON(),0)
    Quit $$$OK
}

ClassMethod UnSubscribe(
	Observer As %String,
	Context As %DynamicObject) As %Status
{
    If $IsObject(Observer) {
        Kill $$$Subscribed(Observer.EventType, $Classname(Observer), Observer.ResourceName)
        Quit $$$OK
    }
    
    Set Event = $Parameter(Observer, "EVENTTYPE")
    Kill $$$Subscribed(Event, Observer, ..HashContext(Context))
    Quit $$$OK
}

ClassMethod Notify(
	Event As %String,
	Data As %DynamicObject) As %Status
{
    #def1arg IsListener(%val)       +$ListGet(%val,6)
    #def1arg ResourceName(%val)     $QSubscript(%val,3)
    #def1arg Context(%val)          {}.%FromJSON($ListGet(%val,5))
    #def1arg Class(%val)            $QSubscript(%val,2)
    
    #dim NotifyObject As %DynamicObject
    
    Set NotifyObject = ##class(dc.ipcutils.Manager).GenEventObject(Event)
    Set sc = $$$OK

    Set node = $Name($$$Subscribed(NotifyObject.EventType))
    For  {
        Set node = $Query(@node,1,value)
        Quit:node=""||(NotifyObject.EventType'=$QSubscript(node,1))
        
        If $$$IsListener(value) {
            Set resourceName = $$$ResourceName(node)
            Set NotifyObject.Context = $$$Context(value), NotifyObject.Data = Data
            
            If '$System.Event.Defined(resourceName) || '$Data(^$JOB($ListGet(value, 4))) Do UnSubscribe Continue
            Do $SYSTEM.Event.Signal(resourceName, NotifyObject.%ToJSON())
            Do WaitAck

            Do NotifyObject.%Remove("Context"), NotifyObject.%Remove("Data")            
            
        } Else {
            If $ClassMethod($$$Class(node), $$$ToCleanMethod, NotifyObject, $$$Context(value)) Kill @node Continue
            Set sc = $$$ADDSC(sc,$ClassMethod($$$Class(node), $$$TriggerMethod, NotifyObject, Data, $$$Context(value)))
        }
    }
    Quit sc

UnSubscribe
    Do:$SYSTEM.Event.Defined(resourceName) $SYSTEM.Event.Clear(resourceName), $SYSTEM.Event.Delete(resourceName)
    Kill @node
    Quit

WaitAck
    Set start = $zh, match = $$$NO
    Do {
        Set syncResult = $SYSTEM.Event.WaitMsg("", ..#ACKTIMEOUT)
        Set syncStatus = $ListGet(syncResult, 1)
        If syncStatus < 1 Do UnSubscribe Quit    
        Set msg = {}.%FromJSON($ListGet(syncResult, 2))
        Set match = msg.MessageID = NotifyObject.MessageID ; Ok this the expected ack
        Quit:match
    } While (start + ..#ACKTIMEOUT > $zh)

    Do:'match UnSubscribe

    Quit
}

ClassMethod GenEventObject(Event As %String) As %DynamicObject
{
    Quit {
        "Event":(Event),
        "EventType":($Piece(Event,":",1)),
        "EventName":($Piece(Event,":",2)),
        "PIDSource":($JOB),
        "Timestamp":($ZDateTime($Horolog,3,1)),
        "MessageID":($Increment(^dc.ipcutils.msg)) 
    }
}

ClassMethod HashContext(Context As %DynamicObject) As %String [ CodeMode = expression, Internal, Private ]
{
$ZCRC($Select($IsObject(Context):Context.%ToJSON(),1:Context),7)
}

ClassMethod ShowSubscribed()
{
    Set node = $Name($$$Subscribed)
    For  {
        Set node = $Query(@node,1,value)
        Quit:node=""
        Write !," * Event: ", $QSubscript(node,1), "  ClassName: ", $QSubscript(node,2)
        Write !,"   Date time: ",$Lg(value,3)
        Write !,"   PID: ", $Lg(value,4)
        Write !,"   Context: ",$Lg(value,5)
        If $ListGet(value,6)=1 Write !,"   ResourceName: ",$QSubscript(node,3)
    }
    Quit
}

ClassMethod Kill() [ Internal ]
{
    Kill $$$Subscribed
}

}
