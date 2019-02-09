package com.calvary.file.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.calvary.common.dao.CommonDao;

@Service
public class FileServiceImpl implements IFileService {

	@Autowired
	private CommonDao commonDao;
	
	/** 
	 * 파일 업로드 
	 * @throws Exception 
	 */
	@Override
	public File uploadFile(MultipartFile file, String realPath, String filePath, String realFileName) throws Exception {
		File newFile = null;
		try {
			newFile = new File(realPath + filePath, realFileName);
			file.transferTo(newFile);
		} catch (IllegalStateException e) {
			throw e;
		} catch (IOException e) {
			throw e;
		} finally {
			
		}
		return newFile;
	}
	
	/** 
	 * 파일정보 생성을 위한 시퀀스 조회
	 */
	@SuppressWarnings("unchecked")
	public String getFileSequence() {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("common.getFileSequence", ""); 
		return (String)rtnMap.get("seq");
	}

	/** 
	 * 파일정보 DB에 저장 
	 */
	@Override
	public boolean createFileInfo(String fileSeq, String fileType, String fileSize, String filePath, String fileName, String realFileName) {
		Map<String, Object> parameter = new HashMap<String, Object>();
		parameter.put("fileSeq", fileSeq);
		parameter.put("fileType", fileType);
		parameter.put("fileSize", fileSize);
		parameter.put("filePath", filePath);
		parameter.put("fileName", fileName);
		parameter.put("realFileName", realFileName);
		int iRslt = 0;
		try {
			iRslt = commonDao.insert("common.createFileInfo", parameter);
		} catch (Exception e) {
			LoggerFactory.getLogger("ERROR_LOGGER").error("error occured to createFileInfo!!", e);
		}
		return iRslt > 0;
	}
	
	/** 
	 *  파일정보 조회
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> getSysFileInfo(String fileSeq) {
		Map<String, Object> rtnMap = (HashMap<String, Object>)commonDao.selectOne("common.getSysFileInfo", fileSeq); 
		return rtnMap;
	}

}
