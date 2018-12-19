package com.calvary.file.service;

import java.io.File;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface IFileService {

	/** 
	 * 파일 업로드 
	 * @throws Exception 
	 */
	public File uploadFile(MultipartFile file, String realPath, String filePath, String realFileName) throws Exception;
	
	/** 
	 * 파일정보 생성을 위한 시퀀스 조회
	 */
	public String getFileSequence();
	/** 
	 * 파일정보 DB에 저장 
	 */
	public boolean createFileInfo(String fileSeq, String fileType, String fileSize, String filePath, String fileName, String realFileName);
	
	/** 
	 *  파일정보 조회
	 */
	public Map<String, Object> getSysFileInfo(String fileSeq);
}
