<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String button = request.getParameter("button");
    String loginMessage = "", emailMessage = "", realNameMessage = "";
    String loginValue = "", emailValue = "", passwordValue = "", confirmPasswordValue = "", realNameValue = "";

    if (button != null) {
        String login = request.getParameter("login");

        if (login == null || login.isEmpty()) {
            loginMessage = "Login shell not be empty";
        } else {
            if (login.equalsIgnoreCase("user1") || login.equalsIgnoreCase("user2")) {
                loginMessage = "Login in use";
            }
        }

        String email = request.getParameter("email");

        if (email == null || email.isEmpty()) {
            emailMessage = "Email shell not be empty";
        }

        String realName = request.getParameter("realName");

        if (realName == null || realName.isEmpty()) {
            realNameMessage = "Real name shell not be empty";
        } else {
            if (realName.length() < 2) {
                realNameMessage = "Real name shell not be shorter than 2 symbols";
            }
        }
    }

    if (!loginMessage.equals("") || !emailMessage.equals("") || !realNameMessage.equals("")) {
        loginValue = request.getParameter("login");
        emailValue = request.getParameter("email");
        passwordValue = request.getParameter("password");
        confirmPasswordValue = request.getParameter("confirmPassword");
        realNameValue = request.getParameter("realName");
    } else {
        loginValue = "";
        emailValue = "";
        passwordValue = "";
        confirmPasswordValue = "";
        realNameValue = "";
    }
%>

<html>
<head>
    <title>JSP</title>
</head>
<body>
<form method="post">
    <div>
        <label>Login:</label>
        <input name="login" value="<%= loginValue %>" required/>
        <i><%= loginMessage %>
        </i>
    </div>
    <div>
        <label>Email:</label>
        <input name="email" value="<%= emailValue %>" type="email" required/>
        <i><%= emailMessage %>
        </i>
    </div>
    <div>
        <label>Password:</label>
        <input type="password" value="<%= passwordValue %>" name="password" required/>

    </div>
    <div>
        <label>Confirm Password:</label>
        <input type="password" value="<%= confirmPasswordValue %>" name="confirmPassword" required/>
    </div>
    <div>
        <label>Real name:</label>
        <input name="realName" value="<%= realNameValue %>" required/>
        <%= realNameMessage %>
    </div>
    <input type="submit" value="Register" name="button"/>
</form>
</body>
</html>
