package com.calvary.account.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import com.calvary.account.service.IAccountService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.constant.CalvaryConstants;
import com.calvary.common.service.ICommonService;
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
	
	public static final String SAVE_JOIN_INFO_URL = "/saveJoinInfo";
	/** */
	public static final String CHECK_LOGIN_URL = "/checklogin";
	/** */
	public static final String MOBILE_LOGIN_URL = "/mobile/login";
	/** */
	public static final String MOBILE_LOGOUT_URL = "/mobile/logout";
	/** */
	public static final String CHECK_MOBILE_LOGIN_URL = "/checkMobilelogin";
	/** */
	public static final String SEND_AUTH_NO_URL = "/sendAuthNo";
	
	public static final String CHECK_AUTH_AND_FIND_ID_URL = "/checkAuthAndFindId";
	
	public static final String CHECK_AUTH_AND_FIND_PWD_URL = "/checkAuthAndFindPwd";
	
	public static final String CHECK_USER_ID_URL = "/checkUserId";
	
	public static final String RESET_PWD_URL = "/resetPwd";
	
	public static final String CHECK_DUPLICATE_USER_ID_URL = "/checkDuplicateUserId";
	
	public static final String COOKIE_KEEP_LOGIN = "keepLoginCookie";
	
	public static final int KEEP_LOGIN_AGE_DAYS = 1000;
	
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");
	private static final Logger infoLogger = LoggerFactory.getLogger(AccountController.class);
	
	@Autowired
	private IAccountService accountService;
	@Autowired
	private IMobileService mobileService;
	@Autowired
	private ICommonService commonService;
	
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
		mv.addObject("yearList", commonService.getYearList());
		mv.addObject("officerList", commonService.getChildCodeList(CalvaryConstants.CODE_SEQ_CHURCH_OFFICER));// 직분코드
		return mv;
	}
	
	@RequestMapping(SAVE_JOIN_INFO_URL)
	@ResponseBody
	public Object saveJoinInfoHandler(@RequestBody UserVo userVo) throws Exception {
		int iRslt = accountService.createUserInfo(userVo);
		boolean bRtn = iRslt > 0;
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		rtnMap.put("result", bRtn);
		return rtnMap;
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
	public Object checkMobileLoginHandler(HttpServletRequest request, HttpSession session, HttpServletResponse response, String userName, String birthDate, String keepLogin) {
		Map<String, Object> rtnMap = new HashMap<String, Object>();
		boolean bRslt = false;
		BunyangUserVo userVo = mobileService.getBunyangUserVo(userName, birthDate);
		if(userVo != null) {
			bRslt = true;
			SessionVo sessionVo = SessionUtil.getSessionVo();
			if(sessionVo == null) {
				sessionVo = new SessionVo();
			}
			sessionVo.setBunyangUserVo(userVo);
			session.setAttribute("sessionVo", sessionVo);
			
			infoLogger.info("================== mobile login info ==================");
			String loginIP = SessionUtil.getRequestIP(request);
			String deviceType = SessionUtil.isMobile(request) ? "MOBILE" : "WEB";
			infoLogger.info("loginIP : " + loginIP);
			infoLogger.info("deviceType : " + deviceType);
			infoLogger.info("userId : " + userVo.getUserId());
			
			// 로그인 유지
			if("1".equals(keepLogin)) {
				String sessionId = session.getId();
				Cookie cookie = new Cookie(COOKIE_KEEP_LOGIN, sessionId);
                cookie.setPath("/");
                cookie.setMaxAge(60*60*24*KEEP_LOGIN_AGE_DAYS);
                response.addCookie(cookie);
                infoLogger.info("keepLogin SessionId : " + sessionId);
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
	
	@RequestMapping(SEND_AUTH_NO_URL)
	@ResponseBody
	public Object sendAuthNoHandler(String userId, String userName, String mobile) throws Exception {
		int iRslt = 0;
		UserVo userVo = accountService.getUserByNameAndMobile(userId, userName, mobile);
		if(userVo != null) {
			String authUserId = userVo.getUserId();
			String authNo = genAuthNo();
			iRslt = accountService.createUserAuthInfo(authUserId, authNo);
		}
		return iRslt;
	}
	
	@RequestMapping(CHECK_AUTH_AND_FIND_ID_URL)
	@ResponseBody
	public Object checkAuthAndFindIdHandler(String userName, String mobile, String authNo) {
		String userId = null;
		UserVo userVo = accountService.getUserByAuthNo(userName, mobile, authNo);
		if(userVo != null) {
			userId = userVo.getUserId();
		}
		return userId;
	}
	
	@RequestMapping(CHECK_AUTH_AND_FIND_PWD_URL)
	@ResponseBody
	public Object checkAuthAndFindPwdHandler(String userId, String userName, String mobile, String authNo) {
		UserVo userVo = accountService.getUserByAuthNo(userId, userName, mobile, authNo);
		String rtn = null;
		if(userVo != null) {
			rtn = userVo.getUserId();
		}
		return rtn;
	}
	
	@RequestMapping(CHECK_USER_ID_URL)
	@ResponseBody
	public Object checkUserIdHandler(String userId) {
		String result = null;
		UserVo userVo = accountService.getUserVo(userId);
		if(userVo != null) {
			result = userVo.getUserId();
		}
		return result;
	}
	
	@RequestMapping(RESET_PWD_URL)
	@ResponseBody
	public Object resetPwdHandler(String userId, String password) throws Exception {
		int iRslt = accountService.updatePassword(userId, password);
		return iRslt;
	}
	
	@RequestMapping(CHECK_DUPLICATE_USER_ID_URL)
	@ResponseBody
	public Object checkDuplicateUserIdHandler(String userId) throws Exception {
		String existUserId = null;
		UserVo userVo = accountService.getUserVo(userId);
		if(userVo != null) {
			existUserId = userVo.getUserId();
		}
		return existUserId;
	}
	
	/**
	 * 6자리 인증번호 생성
	 */
	private String genAuthNo() {
		Random rand = new Random();
        String numStr = "";
        int len = 6;
        for(int i=0;i<len;i++) {
        	String ran = Integer.toString(rand.nextInt(10));
        	if(!numStr.contains(ran)) {
                numStr += ran;
            }else {
                i-=1;
            }
        }
        return numStr;
	}
	
	
}
