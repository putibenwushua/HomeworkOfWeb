
  <%@ page contentType="text/html;charset=UTF-8" language="java" %>
 <html lang="en">
<head>
    <meta charset="UTF-8">
    <title>welcome to chatroom</title>
<link rel="stylesheet" href="./css/login.css">
<link rel="icon" href="./favicon.ico" type="image/x-icon">
</head>
<body>
<div class="container right-panel-active">
    <!-- 登录 -->
    <div class="container_form container--signin">
        <form action="<%=request.getContextPath()%>/LoginServlet" method="post" class="form" id="form2">
            <h2 class="form_title">Sign In</h2>
            <input type="text" placeholder="Email" class="input"  name="userName"/>
            <input type="password" placeholder="Password" class="input" name="userPwd"/>
            <a href="#" class="link">Forgot your password?</a>
            <input class="btn"  type="submit" value="Sign in">
        </form>
    </div>
    
        <!-- 浮层 -->
    <div class="container_overlay">
        <div class="overlay">
                    <div class="overlay_panel overlay--left">
                <button class="btn" id="signIn">Sign UP</button>
            </div>
        </div>
    </div>
 </div>

<!-- 背景 -->
<div class="slidershow">
    <div class="slidershow--image" style="background-image:url(./img/bg5.jpeg)"></div>
    <div class="slidershow--image" style="background-image:url(./img/bg2.jpg)"></div>
    <div class="slidershow--image" style="background-image:url(./img/bg3.jpeg)"></div>
    <div class="slidershow--image" style="background-image:url(./img/bg6.jpg)"></div>
</div>

<!-- partial -->
</body>
</html>