package com.calvary.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.servlet4preview.http.HttpServletRequest;

import com.calvary.account.controller.AccountController;
import com.calvary.common.util.SessionUtil;
import com.calvary.common.vo.SessionVo;

public class MemberFilter implements Filter {

	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		SessionVo sessionVo = SessionUtil.getSessionVo((HttpServletRequest)request);		
		if(sessionVo != null) {
			chain.doFilter(request, response);
		} else {
			((HttpServletResponse)response).sendRedirect(AccountController.ROOT_URL + AccountController.LOGIN_URL);
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
	}

}
