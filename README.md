 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/observer-pattern)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fobserver-pattern&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fobserver-pattern)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fobserver-pattern&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fobserver-pattern)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)
# observer-pattern


## Description

This is an example of implementation of observer pattern for objectscript.  

A DC article is availalbe in FR and EN.  

## Installation

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/lscalese/observer-pattern-for-objectscript.git
```

```
$ docker-compose up -d
```

## Usage

## With a listener

Open a terminal a start to listen the event "Demo"

```Objectscript
IRISAPP>Do ##class(dc.observer.BasicListener).%New().Listen()
```

Open a second terminal to send a notification : 

```Objectscript
Do ##class(dc.observer.Manager).Notify("Demo:OnTest",{"Message":"My FirstTest"}.%ToJSON())
```

Now you see the result in the first terminal:

```Objectscript
IRISAPP>Do ##class(dc.observer.BasicListener).%New().Listen()

2023-09-27 20:43:46 + Listening Demo with resourcename ODYzMjAxNTAwNTAwMQ started.
2023-09-27 20:43:46 + Type < ctrl+c > to stop listening.
2023-09-27 20:45:58 = Event received: 
{
  "Event":"Demo:OnTest",
  "EventType":"Demo",
  "EventName":"OnTest",
  "PIDSource":"710",
  "Timestamp":"2023-09-27 20:45:58",
  "Context":{
  },
  "Data":"{\"Message\":\"My FirstTest\"}"
}
```

## With a subscribed class

```
; Subscribe the triggeer class
Do ##class(dc.observer.Manager).Subscribe("dc.observer.BasicTrigger",{"id":"123"})

; Notify a Demo event
Do ##class(dc.observer.Manager).Notify("Demo:OnTest",{})

; the result
zw ^dc.demo

```