package com.calvary.account.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.account.service.IAccountService;
import com.calvary.common.vo.SessionVo;
import com.calvary.common.vo.UserVo;
import com.calvary.main.controller.MainController;

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
	
	private static final Logger logger = LoggerFactory.getLogger(AccountController.class);
	
	@Autowired
	private IAccountService accountService;
	
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
			SessionVo sessionVo = new SessionVo();
			sessionVo.setUserVo(userVo);
			session.setAttribute("sessionVo", sessionVo);
		}
		rtnMap.put("result", bRtn);
		return rtnMap;
	}
	
}
