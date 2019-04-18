package com.calvary.anonymous.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.calvary.admin.service.IAdminService;

@Controller
@RequestMapping(value=AnonymousController.ROOT_URL)
public class AnonymousController {
	
	@Autowired
	private IAdminService adminService;

	/** */
	public static final String ROOT_URL = "/anonymous";
	
	/** */
	public static final String BUNYANG_STATUS_URL = "/bunyangStatus";
	
	/** 추모동산 사용현황 리스트 조회  URL */
	public static final String GET_GRAVE_USE_LIST = "/getGraveUseList";
	
	/** 특정 구역에 배정된 정보 조회  URL */
	public static final String GET_GRAVE_ASSIGN_INFO = "/getGraveAssignInfo";
	
	/**
	 * 
	 */
	@RequestMapping(value=BUNYANG_STATUS_URL)
	public Object bunyangStatusHandler() {
		ModelAndView mv = new ModelAndView();
		Map<String, Object> statusByGraveType = adminService.getStatusByGraveType();
		Map<String, Object> statusByProductType = adminService.getStatusByProductType();
		Map<String, Object> statusByProgress = adminService.getStatusByProgress();
		mv.addObject("statusByGraveType", statusByGraveType);
		mv.addObject("statusByProductType", statusByProductType);
		mv.addObject("statusByProgress", statusByProgress);
		mv.addObject("currDate", new SimpleDateFormat("yy.MM.dd").format(new Date()));
		mv.setViewName(ROOT_URL + BUNYANG_STATUS_URL);
		return mv;
	}
	
	/** 
	 * 추모동산 사용현황 리스트 조회
	 */
	@RequestMapping(value=GET_GRAVE_USE_LIST)
	@ResponseBody
	public List<Object> getGraveUseListHandler() {
		List<Object> graveUseList = adminService.getGraveUseList();
		return graveUseList;
	}
	
	/** 
	 * 특정 구역에 배정된 정보 조회
	 */
	@RequestMapping(value=GET_GRAVE_ASSIGN_INFO)
	@ResponseBody
	public List<Object> getGraveAssignInfoHandler(String sectionSeq, int rowSeq, int colSeq) {
		List<Object> graveAssignList = adminService.getGraveAssignInfo(sectionSeq, rowSeq, colSeq);
		return graveAssignList;
	}
	
}
