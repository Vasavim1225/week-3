package snippet;

public class Snippet {
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>Chat Login</title>
	
	<style>
	    * {
	        box-sizing: border-box;
	    }
	
	    body {
	        margin: 0;
	        min-height: 100vh;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	        font-family: "Segoe UI", Arial, sans-serif;
	        background:
	            linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	        overflow: hidden;
	    }
	
	    /* Background decorative circles */
	    body::before,
	    body::after {
	        content: "";
	        position: fixed;
	        border-radius: 50%;
	        filter: blur(2px);
	        opacity: .25;
	        pointer-events: none;
	    }
	
	    body::before {
	        width: 300px;
	        height: 300px;
	        background: #fff;
	        top: -100px;
	        left: -80px;
	    }
	
	    body::after {
	        width: 350px;
	        height: 350px;
	        background: #ff9a9e;
	        right: -120px;
	        bottom: -120px;
	    }
	
	    .box {
	        position: relative;
	        width: 370px;
	        padding: 42px 38px;
	        border-radius: 24px;
	        background: rgba(255, 255, 255, 0.96);
	        box-shadow: 0 25px 70px rgba(0, 0, 0, 0.25);
	        text-align: center;
	    }
	
	    .logo {
	        width: 70px;
	        height: 70px;
	        margin: 0 auto 20px;
	        border-radius: 22px;
	        display: flex;
	        align-items: center;
	        justify-content: center;
	        font-size: 30px;
	        color: #fff;
	        background: linear-gradient(135deg, #667eea, #764ba2);
	        box-shadow: 0 10px 25px rgba(102, 126, 234, .35);
	    }
	
	    h2 {
	        margin: 0;
	        color: #222;
	        font-size: 28px;
	        font-weight: 700;
	    }
	
	    p {
	        margin: 8px 0 28px;
	        color: #777;
	        font-size: 14px;
	    }
	
	    .input-group {
	        text-align: left;
	        margin-bottom: 18px;
	    }
	
	    .input-group label {
	        display: block;
	        margin-bottom: 8px;
	        color: #444;
	        font-size: 13px;
	        font-weight: 600;
	    }
	
	    input {
	        width: 100%;
	        height: 50px;
	        padding: 0 17px;
	        border: 1px solid #e0e0e0;
	        border-radius: 12px;
	        outline: none;
	        background: #f8f9fc;
	        color: #333;
	        font-size: 14px;
	        transition: .25s ease;
	    }
	
	    input::placeholder {
	        color: #aaa;
	    }
	
	    input:focus {
	        background: #fff;
	        border-color: #667eea;
	        box-shadow: 0 0 0 4px rgba(102, 126, 234, .12);
	    }
	
	    button {
	        width: 100%;
	        height: 50px;
	        margin-top: 8px;
	        border: none;
	        border-radius: 12px;
	        background: linear-gradient(135deg, #667eea, #764ba2);
	        color: #fff;
	        font-size: 15px;
	        font-weight: 600;
	        cursor: pointer;
	        box-shadow: 0 10px 20px rgba(102, 126, 234, .25);
	        transition: .25s ease;
	    }
	
	    button:hover {
	        transform: translateY(-2px);
	        box-shadow: 0 14px 25px rgba(102, 126, 234, .35);
	    }
	
	    button:active {
	        transform: translateY(0);
	    }
	
	    .err {
	        margin-bottom: 15px;
	        padding: 10px 12px;
	        border-radius: 10px;
	        background: #fff0f0;
	        color: #d9534f;
	        font-size: 13px;
	        text-align: left;
	    }
	
	    .footer {
	        margin-top: 22px;
	        color: #aaa;
	        font-size: 12px;
	    }
	
	    @media (max-width: 480px) {
	        .box {
	            width: calc(100% - 32px);
	            padding: 35px 25px;
	        }
	    }
	</style>
	</head>
	
	<body>
	
	<form class="box" action="LoginServlet" method="post">
	
	    <div class="logo">💬</div>
	
	    <h2>Welcome Back</h2>
	    <p>Enter your username to start chatting.</p>
	
	    <% if (request.getParameter("error") != null) { %>
	        <div class="err">Please enter a username.</div>
	    <% } %>
	
	    <div class="input-group">
	        <label for="username">Username</label>
	        <input
	            type="text"
	            id="username"
	            name="username"
	            placeholder="Enter your username"
	            required
	            autofocus>
	    </div>
	
	    <button type="submit">Start Chatting →</button>
	
	    <div class="footer">
	        Connect • Chat • Enjoy
	    </div>
	
	</form>
	
	</body>
	</html>
	
}

