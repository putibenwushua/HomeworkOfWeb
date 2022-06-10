package com.dw.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void service(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		   request.setCharacterEncoding("utf-8");
		   response.setContentType("text/html;charset=utf-8");
		 String userName=request.getParameter("userName");
		 String userPwd=request.getParameter("userPwd");
		 System.out.println(userName+"||"+userPwd);
		 HttpSession session=request.getSession();
		 session.setAttribute("loginName", userName);
		 System.out.println("sessionId:"+session.getId());
		 
		 request.getRequestDispatcher("/WEB-INF/jsp/websocketChatRoom.jsp").forward(request, response);
	}

}
