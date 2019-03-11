package com.calvary.account.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import com.calvary.account.service.IAccountService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SessionVo;
import com.calvary.common.vo.UserVo;
import com.calvary.mobile.service.IMobileService;

@Controller
@RequestMapping(AccountController.ROOT_URL)
public class AccountController {

	/** */
	public static final String ROOT_URL = "/account";
	/** */
	public static final String LOGIN_URL = "/login";
	/** */
	public static final String LOGOUT_URL = "/logout";
	/** */
	public static final String JOIN_URL = "/join";
	/** */
	public static final String CHECK_LOGIN_URL = "/checklogin";
	/** */
	public static final String MOBILE_LOGIN_URL = "/mobile/login";
	/** */
	public static final String MOBILE_LOGOUT_URL = "/mobile/logout";
	/** */
	public static final String CHECK_MOBILE_LOGIN_URL = "/checkMobilelogin";
	
	public static final String COOKIE_KEEP_LOGIN = "keepLoginCookie";
	
	public static final int KEEP_LOGIN_AGE_DAYS = 1000;
	
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Autowired
	private IAccountService accountService;
	@Autowired
	private IMobileService mobileService;
	
	/** */
	@RequestMapping(LOGIN_URL)
	public Object loginHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + LOGIN_URL);
		return mv;
	}
	
	/** */
	@RequestMapping(LOGOUT_URL)
	@ResponseBody
	public Object logoutHandler(HttpSession session) {
		session.invalidate();
		boolean bRtn = true;
		return bRtn;
	}
	
	/** */
	@RequestMapping(JOIN_URL)
	public Object joinHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(ROOT_URL + JOIN_URL);
		return mv;
	}
	
	@RequestMapping(CHECK_LOGIN_URL)
	@ResponseBody
	public Object checkLoginHandler(HttpSession session, String userId, String password) {
		UserVo userVo = accountService.getUserVo(userId, password);
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRtn = false;
		if(userVo != null) {
			bRtn = true;
			SessionVo sessionVo = SessionUtil.getSessionVo();
			if(sessionVo == null) {
				sessionVo = new SessionVo();
			}
			sessionVo.setUserVo(userVo);
			session.setAttribute("sessionVo", sessionVo);
		}
		rtnMap.put("result", bRtn);
		return rtnMap;
	}
	
	/** */
	@RequestMapping(MOBILE_LOGIN_URL)
	public Object mobileLoginHandler() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName(MOBILE_LOGIN_URL);
		return mv;
	}
	
	/** */
	@RequestMapping(MOBILE_LOGOUT_URL)
	@ResponseBody
	public Object mobileLogoutHandler(HttpSession session, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Cookie cookie = WebUtils.getCookie(request, COOKIE_KEEP_LOGIN);
		if(cookie != null) {
			accountService.deleteKeepLoginInfo(cookie.getValue());
			cookie.setPath("/");
			cookie.setMaxAge(0);
            response.addCookie(cookie);
		}
		session.invalidate();
		boolean bRtn = true;
		return bRtn;
	}
	
	@RequestMapping(CHECK_MOBILE_LOGIN_URL)
	@ResponseBody
	public Object checkMobileLoginHandler(HttpSession session, HttpServletResponse response, String userName, String mobile, String birthDate, String keepLogin) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		BunyangUserVo userVo = mobileService.getBunyangUserVo(userName, mobile, birthDate);
		if(userVo != null) {
			bRslt = true;
			SessionVo sessionVo = SessionUtil.getSessionVo();
			if(sessionVo == null) {
				sessionVo = new SessionVo();
			}
			sessionVo.setBunyangUserVo(userVo);
			session.setAttribute("sessionVo", sessionVo);
			
			// 로그인 유지
			if("1".equals(keepLogin)) {
				String sessionId = session.getId();
				Cookie cookie = new Cookie(COOKIE_KEEP_LOGIN, sessionId);
                cookie.setPath("/");
                cookie.setMaxAge(60*60*24*KEEP_LOGIN_AGE_DAYS);
                response.addCookie(cookie);
                try {
                	accountService.saveKeepLoginInfo(userVo.getUserId(), sessionId, KEEP_LOGIN_AGE_DAYS);
                } catch (Exception e) {
                	errLogger.error("error occured to saveKeepLoginInfo!!", e);
				}
			}
		}
		rtnMap.put("result", bRslt);
		return rtnMap;
	}
	
	
	
}
