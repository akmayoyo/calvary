package com.calvary.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.calvary.common.vo.SessionVo;
import com.calvary.common.vo.UserVo;

public class SessionUtil {

	/** */
	public static boolean checkSession(HttpServletRequest request) {
		boolean bValid = false;
		SessionVo sessionVo = getSessionVo(request);
		if(sessionVo != null) {
			bValid = true;
		}
		return bValid;
	}
	
	/** */
	public static SessionVo getSessionVo() {
		SessionVo sessionVo = null;
		ServletRequestAttributes servletRequestAttribute = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
		if(servletRequestAttribute != null) {
			HttpServletRequest request = servletRequestAttribute.getRequest();
			sessionVo = getSessionVo(request);
		}
		return sessionVo;
	}
	
	/** */
	public static SessionVo getSessionVo(HttpServletRequest request) {
		SessionVo sessionVo = null;
		if(request == null) {
			ServletRequestAttributes servletRequestAttribute = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
			if(servletRequestAttribute != null) {
				request = servletRequestAttribute.getRequest();
			}
		}
		if(request != null) {
			HttpSession session = request.getSession();
			if(session != null) {
				sessionVo = (SessionVo)session.getAttribute("sessionVo");
			}
			// TODO
//			if(sessionVo == null) {
//				sessionVo = new SessionVo();
//				UserVo userVo = new UserVo();
//				userVo.setUserId("calvaryadmin");
//				userVo.setUserName("Admin");
//				sessionVo.setUserVo(userVo);
//			}
		}
		return sessionVo;
	}
	
	/** 
	 * 현재 접속 사용자 정보 반환 
	 */
	public static UserVo getCurrentUser() {
		SessionVo sessionVo = getSessionVo();
		UserVo uservo = null;
		if(sessionVo != null) {
			uservo = sessionVo.getUserVo();
		}
		return uservo;
	}
	
	/** 
	 * 현재 접속 사용자 아이디 반환 
	 */
	public static String getCurrentUserId() {
		UserVo userVo = getCurrentUser();
		String userId = "";
		if(userVo != null) {
			userId = userVo.getUserId();
		}
		return userId;
	}
}
