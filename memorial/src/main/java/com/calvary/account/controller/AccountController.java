package com.calvary.account.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.account.service.IAccountService;

@Controller
@RequestMapping(AccountController.ROOT_URL)
public class AccountController {

	/** */
	public static final String ROOT_URL = "/account";
	/** */
	public static final String LOGIN_URL = "/login";
	
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
	
}
