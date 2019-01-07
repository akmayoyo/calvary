<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ page isErrorPage="true" %> <%@ page import="java.io.PrintWriter"%> 
<%@ page import="java.io.ByteArrayOutputStream"%> 
<!DOCTYPE html> 
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<title>에러 발생</title> 
</head> 
<h3>요청 처리 과정에서 에러가 발생하였습니다.</h3> 
<pre> 
에러 타입 : <%= exception.getClass().getName() %> 
에러 메세지 : <%= exception.getMessage() %> 
스택 트레이스 : <% ByteArrayOutputStream baos = null; PrintWriter pw = null; try { baos = new ByteArrayOutputStream(); pw = new PrintWriter(baos); exception.printStackTrace(pw); pw.flush(); out.print(baos.toString()); } catch(Exception e) { e.printStackTrace(); } finally { if(pw != null) try { pw.close(); } catch(Exception igonre) {} if(baos != null) try { baos.close(); } catch(Exception ignore) {} } %> 
</pre> 
</body> 
</html>