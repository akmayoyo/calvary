package com.calvary.main.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;
import com.calvary.common.util.SessionUtil;
import com.calvary.main.service.IMainService;

@Controller
@RequestMapping(MainController.ROOT_URL)
public class MainController {
	/** */
	public static final String ROOT_URL = "/main";
	/** */
	public static final String INDEX_URL = "/index";
	/** */
	public static final String NOTICE_URL = "/notice";

	@Autowired
	private IAdminService adminService;

	@Autowired
	private IMainService mainService;

	@RequestMapping(INDEX_URL)
	public Object indexHandler(HttpServletRequest request, HttpServletResponse response) {
		List<Object> menuList = adminService.getMenuList(SessionUtil.getCurrentUserId());
		ModelAndView mv = new ModelAndView();
		mv.addObject("menuList", menuList);
		mv.setViewName(ROOT_URL + INDEX_URL);
		return mv;
	}

	@RequestMapping(value=NOTICE_URL)
	@ResponseBody
	public Object noticeHandler(HttpServletRequest request) throws Exception {
		Map<String, Object> noticeInfo = new HashMap<String, Object>();
		noticeInfo.put("grave", mainService.getGraveNotice());
		return noticeInfo;
	}
}
