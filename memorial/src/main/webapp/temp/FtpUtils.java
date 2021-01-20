package com.cs.site.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Component("ftpUtils")
public class FtpUtils {

	@Value("${ftp.url}")
	private String url;

	@Value("${ftp.id}")
	private String id;

	@Value("${ftp.pwd}")
	private String pwd;

	@Value("${ftp.port}")
	private String port;

	public int upload(File file, String filePath, String fileName, HttpServletRequest request) throws Exception {

		FTPClient ftp = null; // FTP Client 객체
		FileInputStream fis = null; // File Input Stream
		File uploadFile = file;

	    String remoteFilePath = filePath; // 리모트 파일 경로

		int result = -1;

		try{
			ftp = new FTPClient();
			ftp.setControlEncoding("UTF-8"); // 문자 코드를 UTF-8로 인코딩
			ftp.connect(url, Integer.parseInt(port)); // 서버접속 " "안에 서버 주소 입력 또는 "서버주소", 포트번호
			ftp.login(id, pwd); // FTP 로그인 ID, PASSWORLD 입력
			//ftp.enterLocalPassiveMode(); // Passive Mode 접속일때

			String[] paths = remoteFilePath.split("/");
			String tempPath = "";

			for(int i=0; i<paths.length; i++) { //폴더 생성 여부 확인후 없으면 폴더 생성
				tempPath += "/" + paths[i];

				if(ftp.changeWorkingDirectory(tempPath)) {
					ftp.changeWorkingDirectory("/");
				}
				else {
					ftp.makeDirectory(tempPath);
				}
			}

			ftp.changeWorkingDirectory(remoteFilePath); // 작업 디렉토리 변경
			ftp.setFileType(FTP.BINARY_FILE_TYPE); // 업로드 파일 타입 셋팅

			try{
				fis = new FileInputStream(uploadFile); // 업로드할 File 생성
				boolean isSuccess = ftp.storeFile(fileName, fis); // File 업로드

				if (isSuccess){
					result = 1; // 성공
				}
				else{
					throw new Exception("파일 업로드를 할 수 없습니다.");
				}
			}
			catch(IOException ex){
				System.out.println("IO Exception : " + ex.getMessage());
			}
			finally{
				if (fis != null){
					try{
						fis.close(); // Stream 닫기
						return result;
					}
					catch(IOException ex){
						System.out.println("IO Exception : " + ex.getMessage());
					}
				}
			}

			ftp.logout(); // FTP Log Out
		}
		catch(IOException e){
			System.out.println("IO:"+e.getMessage());
		}
		finally{
			if (ftp != null && ftp.isConnected()){
				try{
					ftp.disconnect(); // 접속 끊기
					return result;
				}
				catch (IOException e){
					System.out.println("IO Exception : " + e.getMessage());
				}
			}
		}
		return result;
	}

	public List<Map<String,Object>> parseInsertFileInfo(HttpServletRequest request, String uploadFilePath, String datetime, String atchId) throws Exception {

		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;

		List<MultipartFile> fileList = multipartHttpServletRequest.getFiles("file" + atchId);

		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();

		HttpSession httpSession = request.getSession();
		Map<String, Object> userInfo = (Map<String, Object>) httpSession.getAttribute("userInfo");

		for (MultipartFile mf : fileList) {
			Map<String, Object> map = new HashMap<String,Object>();

			map.put("siteId", request.getParameter("siteId" + atchId));
			map.put("key1", request.getParameter("key1" + atchId));
			map.put("key2", request.getParameter("key2" + atchId));
			map.put("key3", request.getParameter("key3" + atchId));
			map.put("key4", request.getParameter("key4" + atchId));
			map.put("atchId", request.getParameter("atchId" + atchId));
			map.put("taskId", request.getParameter("taskId" + atchId));
			map.put("currTime", datetime);
			map.put("fileName", mf.getOriginalFilename());
			map.put("filePath", uploadFilePath + "/" + request.getParameter("taskId" + atchId) + "/" + datetime + "_" + mf.getOriginalFilename());
			//map.put("crNameId", userInfo.get("userId"));

			list.add(map);
		}

		return list;
	}


	@SuppressWarnings("finally")
	public int download(Map<String, Object> fileInfo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		FTPClient client = null;

		String originName = (String) fileInfo.get("originName");
		String fileName = (String) fileInfo.get("fileName");
		String remoteFilePath = (String) fileInfo.get("filePath");

		int result = -1;

		try{
			client = new FTPClient();
			client.setControlEncoding("UTF-8");
			client.connect(url, Integer.parseInt(port));

			int resultCode = client.getReplyCode();

			if (FTPReply.isPositiveCompletion(resultCode) == false){
				client.disconnect();
				throw new Exception("FTP 서버에 연결할 수 없습니다.");
			}
			else
			{
				client.setSoTimeout(5000);
				boolean isLogin = client.login(id, pwd);

			    if (isLogin == false){
			    	throw new Exception("FTP 서버에 로그인 할 수 없습니다.");
			    }

			    client.setFileType(FTP.BINARY_FILE_TYPE);
			    client.changeWorkingDirectory(remoteFilePath);

			    InputStream is = client.retrieveFileStream(fileName);

                File file = File.createTempFile(fileName, null);

                IOUtils.copy(is, new FileOutputStream(file));

				if (file.exists() && file.isFile()) {
					String browser = getBrowser(request);
					String disposition = getDisposition(originName, browser);

					response.setContentType("application/octet-stream; charset=utf-8");
					response.setContentLength((int) file.length());
					response.setHeader("Content-Disposition", disposition);
					response.setHeader("Content-Transfer-Encoding", "binary");

					OutputStream out = response.getOutputStream();
					FileInputStream fis = new FileInputStream(file);
					FileCopyUtils.copy(fis, out);

					if (fis != null)
						fis.close();

					out.flush();
					out.close();

					result = 1; // 성공
			    }
			    else{
			    	throw new Exception("파일 다운로드를 할 수 없습니다.");
			    }

			    client.logout();
			} // if ~ else
		}
		catch (IOException e){
			throw new Exception("FTP Exception : " + e);
		}
		finally{
			if (client != null && client.isConnected()) try {client.disconnect();} catch (Exception e) {}

			return result;
		}
	}

	public static String getBrowser(HttpServletRequest request) {

		String header = request.getHeader("User-Agent");

		if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1)
			return "MSIE";
		else if (header.indexOf("Chrome") > -1)
			return "Chrome";
		else if (header.indexOf("Opera") > -1)
			return "Opera";

		return "Firefox";
	}

	public static String getDisposition(String filename, String browser) throws UnsupportedEncodingException {

		String dispositionPrefix = "attachment;filename=";

		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		}
		else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			sb.append("\"");
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				}
				else {
					sb.append(c);
				}
			}
			sb.append("\"");
			encodedFilename = sb.toString();
		}

		return dispositionPrefix + encodedFilename;
	}

	public int delete(Map<String, Object> fileInfo) throws Exception {

		FTPClient ftp = null; // FTP Client 객체
		//FileInputStream fis = null; // File Input Stream

		String fileName = (String) fileInfo.get("fileName");
		String remoteFilePath = (String) fileInfo.get("filePath");

		int result = -1;
		try{
			ftp = new FTPClient(); // FTP Client 객체 생성
			ftp.setControlEncoding("UTF-8"); // 문자 코드를 UTF-8로 인코딩
			ftp.connect(url, Integer.parseInt(port)); // 서버접속
			ftp.login(id, pwd);	// FTP 로그인
			//ftp.enterLocalPassiveMode(); // Passive Mode 접속일때
			ftp.changeWorkingDirectory(remoteFilePath); // 작업 디렉토리 변경
			ftp.setFileType(FTP.BINARY_FILE_TYPE); // 업로드 파일 타입 셋팅

			try{
				boolean isSuccess = ftp.deleteFile(fileName);	// 파일 삭제

				FTPFile[] files = ftp.listFiles();

				if( files.equals(null) || files.length <= 0){	// 빈 폴더 삭제
					ftp.removeDirectory(remoteFilePath);
				}

				if (isSuccess){
					result = 1; // 성공
				}
				else{
					throw new Exception("파일을 삭제 할 수 없습니다.");
				}
			}
			catch(IOException ex){
				System.out.println("IO Exception : " + ex.getMessage());
			}
//			finally{
//				if (fis != null){
//					try{
//						fis.close(); // Stream 닫기
//						return result;
//					}
//					catch(IOException ex){
//						System.out.println("IO Exception : " + ex.getMessage());
//					}
//				}
//			}

			ftp.logout(); // FTP Log Out
		}catch(IOException e){
			System.out.println("IO:"+e.getMessage());
		}
		finally{
			if (ftp != null && ftp.isConnected()){
				try{
					ftp.disconnect(); // 접속 끊기
					return result;
				}
				catch (IOException e){
					System.out.println("IO Exception : " + e.getMessage());
				}
			}
		}

		return result;
	}

}