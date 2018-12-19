package com.calvary.file.controller;

import java.io.File;
import java.nio.file.Files;

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

import com.calvary.common.util.FileUtil;
import com.calvary.file.service.IFileService;

@Controller
@RequestMapping(value=FileController.ROOT_URL)
public class FileController {

	/** */
	public static final String ROOT_URL = "/file";
	
	/** */
	public static final String ROOT_DIR = "/file/upload";
	
	@Autowired
	private IFileService fileService;
	
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
				String fileSeq = fileService.getFileSequence();
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
	
}
