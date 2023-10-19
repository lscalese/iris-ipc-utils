 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/observer-pattern-for-objectscript)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fobserver-pattern-for-objectscript&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fobserver-pattern-for-objectscript)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fobserver-pattern-for-objectscript&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fobserver-pattern-for-objectscript)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)
# observer-pattern


## Description

This is an example of $SYSTEM.Event usage.  

A DC article is availalbe in [FR here](https://fr.community.intersystems.com/node/550801) and EN soon.  

## Installation

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/lscalese/iris-ipc-utils.git
```

```
$ docker-compose up -d
```

## Usage

## With a listener

Open a terminal a start to listen the event "Demo"

```Objectscript
IRISAPP>Do ##class(dc.ipcutils.BasicListener).%New().Listen()
```

Open a second terminal to send a notification : 

```Objectscript
Do ##class(dc.ipcutils.Manager).Notify("Demo:OnTest",{"Message":"My FirstTest"}.%ToJSON())
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
