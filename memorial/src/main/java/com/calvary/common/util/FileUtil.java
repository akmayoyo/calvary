package com.calvary.common.util;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.util.StringUtils;

public class FileUtil {

	/** */
	public static String appendCurrDtToFileName(String fileName) {
		String currentDt = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
		return appendToFileName(fileName, currentDt);
	}
	
	/** */
	public static String appendToFileName(String fileName, String addVal) {
		String newFileName = fileName;
		if(!StringUtils.isEmpty(newFileName)) {
			int dot = newFileName.lastIndexOf(".");
			String ext = newFileName.substring(dot);
			newFileName = newFileName.substring(0, dot);
			newFileName += "_" + addVal;
			newFileName += ext;
		}
		return newFileName;
	}
}
