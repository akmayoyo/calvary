package com.calvary.common.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.calvary.common.service.ICommonService;
import com.calvary.common.util.SMSUtil;
import com.calvary.common.vo.ResultSmsVo;
import com.calvary.common.vo.SendSmsVo;

@Controller
@RequestMapping(value=CommonRestController.ROOT_URL)
public class CommonRestController {
	
	/** */
	public static final String ROOT_URL = "/commrest";
	
	/** */
	public static final String SEND_SMS_URL = "/sendSms";
	
	@Autowired
	private ICommonService commonService;

	/** */
	@RequestMapping("/getString")
	public List<Object> getString() {
		return null;
	}
	
	@RequestMapping(value=SEND_SMS_URL)
	@ResponseBody
	public ResultSmsVo sendSmsHandler(@RequestBody SendSmsVo vo, HttpServletRequest request, HttpServletResponse response) {
		
		ResultSmsVo resultVo = null;
		
		String msgKey = vo.getMsgKey();
		String msgContents = vo.getMsgContents();
		String msgType = vo.getMsgType();
		String subject = vo.getSubject();
		String receivers = vo.getReceivers();
		String[] sequences = vo.getSequences();
		
		// msg key 가 있을 경우 DB에 등록된 메세지정보 조회
		if(!StringUtils.isEmpty(msgKey)) {
			Map<String, Object> tmp = commonService.getSmsMsg(msgKey);
			if(tmp != null) {
				msgContents = (String)tmp.get("msg_contents");
				msgType = (String)tmp.get("msg_type");
				subject = (String)tmp.get("msg_subject");
			}
		}
		if(!StringUtils.isEmpty(msgContents) && !StringUtils.isEmpty(receivers)) {
			if(sequences != null) {
				msgContents = SMSUtil.getMsgContents(msgContents, sequences);
			}
			vo.setMsgContents(msgContents);
			vo.setMsgType(msgType);
			vo.setSubject(subject);
			
			resultVo = SMSUtil.sendSms(vo);
		}
		return resultVo;
	}
	
}
