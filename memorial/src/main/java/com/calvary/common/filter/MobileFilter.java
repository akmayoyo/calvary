package com.calvary.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;
import org.springframework.web.util.WebUtils;

import com.calvary.account.controller.AccountController;
import com.calvary.account.service.IAccountService;
import com.calvary.admin.vo.BunyangUserVo;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SessionVo;

public class MobileFilter implements Filter {

	@Autowired
	private ICommonService commonService;
	@Autowired
	private IAccountService accountService;
	
	private static final Logger logger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		String loginUrl = AccountController.ROOT_URL + AccountController.MOBILE_LOGIN_URL;
		HttpServletRequest hRequest = (HttpServletRequest)request;
		SessionVo sessionVo =  SessionUtil.getSessionVo(hRequest);
		String query = hRequest.getQueryString();
		String requestUrl = hRequest.getServletPath();
		String contextPath = hRequest.getContextPath();
		if(sessionVo != null && sessionVo.getBunyangUserVo() != null) {
			try {
				// 메뉴접속이력 생성
				String menuId = hRequest.getParameter("_menuId");
				if(!StringUtils.isEmpty(menuId)) {
					String userId = sessionVo.getBunyangUserVo().getUserId();
					String loginIP = SessionUtil.getRequestIP(hRequest);
					String deviceType = SessionUtil.isMobile(hRequest) ? "MOBILE" : "WEB";
					commonService.createMenuAccessLog(userId, loginIP, deviceType, menuId);
				}
			} catch(Exception e) {
				logger.error("createMenuAccessLog Error!!", e);
			}
			chain.doFilter(request, response);
		} else {
			// 자동로그인처리
			Cookie cookie = WebUtils.getCookie(hRequest, AccountController.COOKIE_KEEP_LOGIN);
			BunyangUserVo bunyangUserVo = null;
			if(cookie != null) {
				String sessionId = cookie.getValue();
				bunyangUserVo = accountService.getKeepLoginInfo(sessionId);
			}
			if(bunyangUserVo != null) {
				if(sessionVo == null) {
					sessionVo = new SessionVo();
				}
				sessionVo.setBunyangUserVo(bunyangUserVo);
				hRequest.getSession().setAttribute("sessionVo", sessionVo);
				
				chain.doFilter(request, response);
				
			} else {
				if(!StringUtils.isEmpty(query)) {
					requestUrl += "?" + query;
				}
				hRequest.getSession().setAttribute("requestUrl", requestUrl);
				((HttpServletResponse)response).sendRedirect(contextPath + loginUrl);
			}
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this,
	            filterConfig.getServletContext());
	}

}
