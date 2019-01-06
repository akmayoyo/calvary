package com.calvary.file.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.calvary.common.service.ICommonService;
import com.calvary.common.util.FileUtil;
import com.calvary.file.service.IFileService;

@Controller
@RequestMapping(value=FileController.ROOT_URL)
public class FileController {

	/** */
	public static final String ROOT_URL = "/file";
	
	/** */
	public static final String ROOT_DIR = "/file/upload";
	
	private static final Logger logger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Autowired
	private IFileService fileService;
	
	@Autowired
	private ICommonService commonService;
	
	@RequestMapping(value="/uploadFile", method=RequestMethod.POST)
	public ResponseEntity<String> uploadFile(MultipartHttpServletRequest request) throws Exception{
		MultipartFile file = request.getFile("file");
		String fileName = file.getOriginalFilename();
		String cateDir = request.getParameter("cateDir");
		String dosave = request.getParameter("dosave");
		String realPath = request.getSession().getServletContext().getRealPath("/");
		String filePath = "";
		File fileDir = null;
		// root directory 없으면 생성
		filePath += ROOT_DIR;
		fileDir = new File(realPath + filePath);
		if(!fileDir.isDirectory()) {
			fileDir.mkdir();
		}
		// 파일 category directory 없으면 생성
		if(!StringUtils.isEmpty(cateDir)) {
			filePath += "/" + cateDir;
			fileDir = new File(realPath + filePath);
			if(!fileDir.isDirectory()) {
				fileDir.mkdir();
			}
		}
		// 실제 파일명_현재시간 으로 rename
		String realFileName = FileUtil.appendCurrDtToFileName(fileName);
		File newFile = fileService.uploadFile(file, realPath, filePath, realFileName);
		String result = "";
		if(newFile != null){
			if(Boolean.valueOf(dosave)) {
				String fileSeq = String.valueOf(commonService.getSeqNexVal("FILE_SEQ"));
				String fileType = Files.probeContentType(newFile.toPath());
				String fileSize = Long.toString(newFile.length());
				boolean bRslt = fileService.createFileInfo(fileSeq, fileType, fileSize, filePath, fileName, realFileName);
				if(bRslt) {
					result = fileSeq;
				}
			}
		}
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-Type", "text/html;charset=UTF-8");
		return new ResponseEntity<String>(result, headers, HttpStatus.CREATED) ;
	}
	
	@RequestMapping(value="/downloadFile")
	public void downloadFile(String fileSeq, HttpServletRequest request, HttpServletResponse response) throws Exception{
		Map<String, Object> fileInfo = fileService.getSysFileInfo(fileSeq);
		String realPath = request.getSession().getServletContext().getRealPath("/");
		String filePath = (String)fileInfo.get("file_path");
		String realFileName = (String)fileInfo.get("real_file_name");
		filePath = realPath + filePath + "/" + realFileName;
		File file = new File(filePath);
		download(request, response, file);
	}
	
	/** */
	public void download(HttpServletRequest request, HttpServletResponse response, File file) throws ServletException, IOException {
		String mime = request.getSession().getServletContext().getMimeType(file.getName());
		String fileName = file.getName();
		long fileSize = file.length();
	    if (mime == null || mime.length() == 0) {
	    	mime = "application/octet-stream;";
	    }
	    byte[] buffer = new byte[8192];
	    response.setContentType(mime + "; charset=utf-8");
	    fileName = URLEncoder.encode(fileName,"UTF-8").replaceAll("\\+", "%20");
	    String userAgent = request.getHeader("User-Agent");
	    if (userAgent != null && userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
	      response.setHeader("Content-Disposition", "filename=" + fileName + ";");
	    } else if (userAgent != null && userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
	      response.setHeader("Content-Disposition", "attachment; filename="
	          + fileName + ";");
	    } else { // 모질라나 오페라
	      response.setHeader("Content-Disposition", "attachment; filename="
	          + fileName + ";");
	    }
	    

	    if (fileSize > 0) {
	      response.setHeader("Content-Length", "" + fileSize);
	    }
	    
	    BufferedInputStream bis = null;
	    BufferedOutputStream bos = null;
	    InputStream is = null;
	    try {
	    	is = new FileInputStream(file);
	    	bis = new BufferedInputStream(is);
	    	bos = new BufferedOutputStream(response.getOutputStream());
	    	int read = 0;
	    	while ((read = bis.read(buffer)) != -1) {
	    		bos.write(buffer, 0, read);
	    	}
	    } catch (IOException e) {
	    	logger.error("download error occured!!", e);
	    } finally {
	    	try {
	    		if(is != null)is.close();
	    	} catch (Exception ex1) {}
	    	try {
	    		if(bos != null)bos.close();
	    	} catch (Exception ex1) {}
	    	try {
	    		if(bis != null)bis.close();
	    	} catch (Exception ex2) {}
	    }
	}
	
}
