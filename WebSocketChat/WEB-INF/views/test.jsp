<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>

<link href="<c:url value="/resource/css/bootstrap.css" />" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="<c:url value="/resource/js/bootstrap.min.js" /> "></script>

</head>
<body>

<div id="wrapper">
	<!-- navigation -->
	<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom:0">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="/home">SB Admin v2.0</a>
		</div>
		<!-- /.navbar-header -->
		
		<ul class="nav navbar-top-links navbar-right">
			<li class="dropdown">
				<a class="dropdown-toggle" data-toggle="dropdown" href="#">
					<i class="fa fa-envelop fa-fw"></i>
					<i class="fa fa-caret-down"></i>
				</a>
				<ul class="dropdown-menu dropdown-messages">
					<li>
						<a href="#">
							<div>
								<strong>John Smith</strong>
								<span class="pull-right text-muted">
									<em>Yesterday</em>
								</span>
							</div>
							<div>Lorem ipsum asldkfj...</div>
						</a>
					</li>
					<li class="divider"></li>
				</ul>
				<!-- /.dropdown-messages -->
			</li>
			<!-- /.dropdown -->
		</ul>	
		<!-- /.navbar-top-links -->
		
		<div class="navbar-default sidebar" role="navigation">
			<div class="sidebar-nav navbar-collapse">
				<ul class="nav" id="side-menu">
				<li>
					<a class="active" href="/home"><i class="fa fa-dashboard fa-fw"></i>home</a>
				</li>
				<li>
					<a href="#">
						<i class="fa fa-bar-chart-o fa-fw"></i>Charts<span class="fa arrow"></span>
						<ul class="nav nav-second-level">
							<li>
								<a href="/test1">test1</a>
							</li>
							<li>
								<a href="/test2">test21</a>
							</li>
						</ul>
						<!-- /nav-second-level  -->
					</a>
				</li>
				</ulbootstrap.min.js>
			</div>
		</div>
	</nav>
</div>

<div id="page-wrapper">
	<div class="row">
		<div class="col-xs-12">
			<textarea id="ta_chat" class="form-control"></textarea>
			<input type="text" id="text_chat" class="form-control" />
		</div>
	</div>
</div>

<script type="text/javascript">
var controller;
var wsController;
var view;
var model;

function Controller(){
	
} //Controller

function WsController(){
	this.socket=new WebSocket("ws://${pageContext.request.serverName}:${1235}/websocket/ws/server/1235")
	
	this.socket.onopen=function(){
		console.log("[WebSocket->onopen]");
	} //onopen
	
	this.socket.onmessage=function(e){
		console.log("[WebSocket->onmessage] " + e.data);
		var jsonObj=JSON.parse(e.data);
		var sender=jsonObj.sender;
		var msg=jsonObj.msg;
		if(sender==model.nick)
			return;
		view.addMsg(sender, msg);
	} //onmessage
	
	this.socket.onclose=function(){
		console.log("[WebSocket->onclose]");
	} //onclose
	
	this.sendMsg=function(msg){
		jsonMsg=new Object();
		jsonMsg.kind="chatMsg";
		jsonMsg.msg=msg;
		this.socket.send(JSON.stringify(jsonMsg));
	} //send
	
	this.setNick=function(nick){
		jsonMsg=new Object();
		jsonMsg.kind="setNick";
		jsonMsg.nick=nick;
		this.waitForSocketConnection(function(){
			wsController.socket.send(JSON.stringify(jsonMsg));
		});
	} //setNick
	 
	this.stop=function(){
		this.socket.close();
	} //stop
	
	this.waitForSocketConnection=function(callback){
		setTimeout(function(){
			if(wsController.socket.readyState==WebSocket.OPEN){
				console.log("connection is made");
				if(callback!=null)
					callback();
			} else{
				console.log("wait for connection");
				this.waitForSocketConnection(callback);
			} //if
		}, 100);
	} //waitForSocketConnection
} //WsController

function View(){
	this.addMsg=function(sender, msg){
		$("#ta_chat").val($("#ta_chat").val() + sender + " : " + msg + "\n");
	} //addMsg
} //View

function Model(){
	this.nick="${nick}";
} //Model

controller=new Controller();
wsController=new WsController();
view=new View();
model=new Model();
</script>

<script type="text/javascript">
wsController.setNick(model.nick);

$("#text_chat").keypress(function(e){
	if(e.which!=13)
		return;
	var textChat=$("#text_chat");
	var msg=textChat.val();
	view.addMsg(model.nick, msg);
	wsController.sendMsg(msg);
	textChat.val("");
});
</script>

</body>
</html>