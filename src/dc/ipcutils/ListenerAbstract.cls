Class dc.ipcutils.ListenerAbstract Extends %RegisteredObject
{

Parameter EVENTTYPE;

Parameter WAITTIMEOUT = 10;

Parameter VERBOSE = 0;

Property ResourceName As %String [ Internal ];

Property Verbose As %Boolean [ InitialExpression = {$Get(%zverbose,..#VERBOSE)}, Internal ];

Property EventType As %String [ InitialExpression = {..#EVENTTYPE} ];

Property Event As %DynamicObject;

/// could be a string or a dynamicobject
Property Data;

Property Context As %DynamicObject;

Property LastState As %Integer [ InitialExpression = 0 ];

Method OnStartListen(Context As %DynamicObject = {{}}) As %Status
{
    Set ..ResourceName = ..GenResourceName()
    Do $SYSTEM.Event.Create(..ResourceName), ##class(dc.ipcutils.Manager).Subscribe(##this, Context)
    Write:..Verbose !, $zdt($h,3,1), " + Listening ", ..EventType, " with resourcename ", ..ResourceName, " started."
    Quit $$$OK
}

Method Listen() As %Status
{
    Set sc = $$$OK

    $$$QuitOnError(..OnStartListen())
    
    Try {
        For  If ..Wait() = -1 $$$ThrowStatus($$$ERROR($$$GeneralError,$$$FormatText("Resource %1 deleted.",..ResourceName)))
    } Catch Ex {
        If Ex.Name '[ "<INTERRUPT>" Set sc = Ex.AsStatus()
    }
    
    Quit $$$ADDSC(sc,..OnStopListen())
}

Method Wait(
	TimeOut As %Integer = {..#WAITTIMEOUT},
	sc As %Status = {$$$OK}) As %Integer
{
    Do:..LastState=1 ..SendAck() ; We have to send a ack before waiting a new incoming message.
    
    Set result = $SYSTEM.Event.WaitMsg(..ResourceName, TimeOut)
    Set ..LastState = $ListGet(result,1)

    If ..LastState < 1 Quit ..LastState
    
    Set ..Event = {}.%FromJSON($ListGet(result,2))
    Set ..Data = ..Event.Data
    Set ..Context = ..Event.Context
    
    Do ..Event.%Remove("Data")
    Do ..Event.%Remove("Context")

    Try {
        Do ..Update(..Event, ..Data, ..Context)
    } Catch (ex) {
        Set sc = ex.AsStatus()
        Set ^Listener.Err("last") = $zdt($h,3,1)_" "_$SYSTEM.Status.GetOneErrorText(sc)
    }

    Quit ..LastState
}

Method SendAck()
{
    Do $SYSTEM.Event.Signal(..Event.PIDSource,..Event.%ToJSON())
}

Method Update(
	EventObject As %DynamicObject,
	Data As %DynamicObject,
	Context As %DynamicObject) As %Status
{
    Quit $$$OK
}

Method WaitEvent(
	Output Event As %DynamicObject,
	TimeOut As %Integer = {..#WAITTIMEOUT}) As %Integer
{
    Set result = $SYSTEM.Event.WaitMsg(..ResourceName, TimeOut), returnCode = $ListGet(result,1), Event = ""

    If returnCode < 1 Quit returnCode
    
    Set ..Event = {}.%FromJSON($ListGet(result,2))
    Set ..Data = Event.Data
    Set ..Context = Event.Context
    Do ..Event.%Remove("Data"), ..Event.%Remove("Context")

    Quit returnCode
}

Method OnStopListen(Context As %DynamicObject = {{}}) As %Status
{
    Write:..Verbose !, $zdt($h,3,1), " - Listening ", ..EventType, " with resourcename ", ..ResourceName, " has been STOPPED."
    Do:$SYSTEM.Event.Defined(..ResourceName) $SYSTEM.Event.Clear(..ResourceName), $SYSTEM.Event.Delete(..ResourceName)
    Quit ##class(dc.ipcutils.Manager).UnSubscribe(##this, Context)
}

Method GenResourceName() As %String [ CodeMode = expression, Private ]
{
$Translate($SYSTEM.Encryption.Base64Encode($Job_$zcrc(..EventType_$ZDT($H,3,1),7)),"=")
}

}
