package com.calvary.common.util;

import javax.servlet.http.HttpSession;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;

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
	public static SessionVo getSessionVo(HttpServletRequest request) {
		SessionVo sessionVo = null;
		if(request != null) {
			HttpSession session = request.getSession();
			if(session != null) {
				sessionVo = (SessionVo)session.getAttribute("sessionVo");
			}
			// TODO
			if(sessionVo == null) {
				sessionVo = new SessionVo();
				UserVo userVo = new UserVo();
				userVo.setUserId("calvaryadmin");
				userVo.setUserName("Admin");
				sessionVo.setUserVo(userVo);
			}
		}
		return sessionVo;
	}
}
