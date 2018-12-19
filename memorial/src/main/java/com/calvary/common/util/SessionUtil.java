package com.calvary.common.util;

import javax.servlet.http.HttpSession;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;

import com.calvary.common.vo.SessionVo;

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
	public static SessionVo getSessionVo(HttpServletRequest request) {
		SessionVo sessionVo = null;
		if(request != null) {
			HttpSession session = request.getSession();
			if(session != null) {
				sessionVo = (SessionVo)session.getAttribute("sessionVo");
			}
		}
		return sessionVo;
	}
}
