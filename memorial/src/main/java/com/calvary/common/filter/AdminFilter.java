package com.calvary.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.calvary.account.controller.AccountController;
import com.calvary.common.util.SessionUtil;

public class AdminFilter implements Filter {

	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		boolean bValid =  SessionUtil.checkSession((javax.servlet.http.HttpServletRequest)request);
		String requestUrl = ((HttpServletRequest)request).getServletPath();
		if(bValid) {
			chain.doFilter(request, response);
		} else {
			request.setAttribute("requestUrl", requestUrl);
			((HttpServletResponse)response).sendRedirect(AccountController.ROOT_URL + AccountController.LOGIN_URL);
		}
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
	}

}
