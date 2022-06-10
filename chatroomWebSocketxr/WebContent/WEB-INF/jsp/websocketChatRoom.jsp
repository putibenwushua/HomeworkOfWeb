<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="img/chatroom.ico" rel="shortcut icon">
<link rel="stylesheet" href="css/chat.css" />
<link rel="stylesheet" href="css/bootstrap.min.css" />

<title>【${sessionScope.loginName}】's chat room</title>
<script type="text/javascript" src="js/jquery-1.4.3.js"></script>
<script type="text/javascript">
	var ws;
	var ws_url = "ws://localhost:8080/chatroomWebSocketxr/chatroom"

	$(function() {

		ws_connect();
		$("#send").click(function() {
			ws_sendMsg();
		});
		$("#uploadImg").click(function() {

			ws_sendImg();
		});

	});
	function ws_connect() {
		var loginUser = "${sessionScope.loginName}";
		if ('WebSocket' in window) {
			ws = new WebSocket(ws_url + "?loginName=" + loginUser);
		} else if ('MozWebSocket' in window) {
			ws = new MozWebSocket(ws_url + "?loginName=" + loginUser);
		} else {
			console.log('Error: WebSocket is not supported by this browser.');
			return;
		}

		ws.onopen = function() {
			console.log('Info: WebSocket connection opened.');

		};

		ws.onclose = function() {

			console.log('Info: WebSocket closed.');
		};

		ws.onmessage = function(message) {
			if ("string" == typeof (message.data)) {
				//console.log("@@@"+message.data);
				var receiveMsg = message.data;
				var obj = JSON.parse(receiveMsg);
				if (obj.type == "s") {
					$("#record").append(
							"<div style=\"color:red;\">" + obj.msgDateStr + ""
									+ obj.msgInfo + "</div>");
					var userHtml = "";
					var userList = obj.userList;
					for (var i = 0; i < userList.length; i++) {
						userHtml = userHtml + userList[i] + "<br/><br/>";
					}
					$("#userList").html(userHtml);
				} else if (obj.type == "p") {
					$("#record").append(
							"<div style=\"color:green;\">" + obj.msgSender
									+ ":&nbsp;" + obj.msgDateStr
									+ "</div><div>" + "&nbsp;" + "&nbsp;"
									+ obj.msgInfo + "</div>");
				} else if (obj.type == "img") {
					picp = "<div style=\"color:green;\">" + obj.msgSender
							+ ":&nbsp;" + obj.msgDateStr + "</div>";
				}
			} else {
				var reader = new FileReader();
				reader.readAsDataURL(message.data);
				reader.onload = function(evt) {
					if (evt.target.readyState == FileReader.DONE) {
						var url = evt.target.result;
						$("#record").append(picp+ "<div><img src='"+url+"' style='max-height:150px; max-width:150px; vertical-align: middle; align: center;'/></div>");
					}
				}

			}
			console.log(message.data);
		};
	};

	function ws_sendMsg() {
		var msg = $("#msg").val();
		ws.send(msg);
		msg = $("#msg").val("");
	};

	function ws_sendImg() {
		var fObj = $("#img")[0].files[0];
		if (fObj) {
			var reader = new FileReader();
			reader.readAsArrayBuffer(fObj);
			reader.onload = function(evt) {
				ws.send(evt.target.result);
			}
			$("#img").val("");
		} else {
			$("#img").val("");
		}
	};
</script>
</head>
<body>
	<div class="navbar navbar-expand-lg bg-dark navbar-dark" id="fix">
		<h4 class="navbar-brand">Chat Room</h4>
	</div>
	<div id="bg">
		<div class="container">
			<div class="alert alert-info text-center">
				<div class="chatroomtext">
					<h5 style="display: inline;">Welcome ${sessionScope.loginName}</h5>
				</div>
			</div>
			<div class="panel panel-default"
				style="border-radius: 5px; background: rgba(255, 255, 255, 0.3);">
				<div class="panel-body">
					<div class="well" id="chat">
						<div class="cau">
							<div class="chatroom">
								<h4>Chat Message</h4>
								<div>
									<table id="tbRecord" style="display: block;">
										<tbody id="record"
											style="display: block; height: 300px; width: 60vw; overflow: auto; border: #000000 solid 1px; border-radius: 5px; word-break: break-all;" />
									</table>
								</div>
							</div>
							<div class="userlist">
								<h4 style="display: block;">UserList</h4>
								<table id="tbuserList" style="display: block;">
									<tbody id="userList"
										style="display: block; height: 300px; overflow: auto;" />
								</table>
							</div>
						</div>
						<div class="imgfiletransport">
							<div class="btn-group" role="group">
								<div class="File-Box" style="margin-left:600px;">
									<input type="file" id="img"/>
									<div class="Show-Box">
									<div>+</div>
									<span>Open</span>
									</div>
								</div>
							</div>
							<div class="btn-group" role="group">
								<button type="button" id="uploadImg" name="uploadImg"
									style="background-color: #f66f6a; color: white; width: 75px; height: 30px; border: 0; font-size: 15px; box-sizing: content-box; border-radius: 5px;">Send
									IMG</button>
							</div>
						</div>
						<div class="sub">
							<div class="sender">
								<div class="input-group">
									<input type="text" class="form-control" id="msg" name="msg"
										style="height: 50px; margin-top: 1px; overflow: auto;"
										placeholder="Message input" aria-describedby="basic-addon1">
								</div>
								<div class="btn-group btn-group-justified" role="group"
									aria-label="..." style="margin-top: 5px;">
									<div class="btn-group" role="group">
										<button type="button" class="btn btn-default" id="send"
											name="send"
											style="background-color: dodgerblue; color: white; width: 200px; height: 47px; border: 0; font-size: 16px; border-radius: 30px;">Send Message</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>
</body>
</html>