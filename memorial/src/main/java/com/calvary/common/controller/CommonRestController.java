package com.calvary.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.calvary.common.dao.CommonDao;

@RestController
public class CommonRestController {
	
	@Autowired
	private CommonDao commonDao;

	/** */
	@RequestMapping("/getString")
	public List<Object> getString() {
		return null;
	}
}
