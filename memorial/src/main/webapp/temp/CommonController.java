package com.cs.site.common.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.cs.site.common.service.CommonService;
import com.cs.site.common.util.FtpUtils;
import com.cs.site.warrReceipt.service.WarrReceiptService;



@Controller
public class CommonController {

	@Autowired
    CommonService commonService;

	@Autowired
	WarrReceiptService warrReceiptService;

	@Resource(name="ftpUtils")
    private FtpUtils ftpUtils;

	@Value("${ftp.uploadFilePath}")
	private String uploadFilePath;

	@RequestMapping("common/protoType2")
	public ModelAndView protoType2() {

		ModelAndView mav = new ModelAndView();

		return mav;

	}

	//LOV 화면 호출.
	@RequestMapping("common/commLovReg")
	public ModelAndView commLovReg() {

		ModelAndView mav = new ModelAndView();

		return mav;

	}


	//파일 첨부 화면 호출.
	@RequestMapping("common/commAtchReg")
	public ModelAndView commAtchReg() {

		ModelAndView mav = new ModelAndView();

		return mav;

	}

	//리스트 조회.
	@RequestMapping("common/getLovList")
	public ModelAndView getLovList(@RequestBody Map<String, Object> params) {

		List<Map<String, Object>> result =  commonService.getLovList(params);

		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.setViewName("jsonView");

		return mav;
	}

	//현장명 검색리스트 조회.
	@RequestMapping("common/getSiteList")
	public ModelAndView getSiteList(@RequestBody Map<String, Object> params) {

		List<Map<String, Object>> result =  commonService.getSiteList(params);

		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.setViewName("jsonView");

		return mav;
	}

	// 고객사명 검색리스트
		@RequestMapping("/common/getCustList")
		public ModelAndView getCustList(@RequestBody(required = false) Map<String, Object> params) {
			ModelAndView mav = new ModelAndView();

			List<Map<String, Object>> result = commonService.getCustList(params);

			mav.addObject("result", result);
			mav.setViewName("jsonView");
			return mav;
		}

	// 감리사명 검색리스트
		@RequestMapping("/common/getSuperNameList")
		public ModelAndView getSuperNameList(@RequestBody(required = false) Map<String, Object> params) {
			ModelAndView mav = new ModelAndView();

			List<Map<String, Object>> result = commonService.getSuperNameList(params);

			mav.addObject("result", result);
			mav.setViewName("jsonView");
			return mav;
		}
	// 감리공종명 검색리스트
		@RequestMapping("/common/getSuperGongList")
		public ModelAndView getSuperGongList(@RequestBody(required = false) Map<String, Object> params) {
			ModelAndView mav = new ModelAndView();

			List<Map<String, Object>> result = commonService.getSuperGongList(params);

			mav.addObject("result", result);
			mav.setViewName("jsonView");
			return mav;
		}

	//신규 추가.
	@Transactional
	@RequestMapping("common/insertLovData")
	public ModelAndView insertLovData(@RequestBody Map<String, Object> params, HttpServletRequest request) {

		int cnt = commonService.checkDuplication(params);

		int result = 0;

		if(cnt == 0) {
			HttpSession httpSession = request.getSession();
			Map<String, Object> userInfo = (Map<String, Object>) httpSession.getAttribute("userInfo");

			params.put("repId", userInfo.get("userId"));

			result = commonService.insertLovData(params);
		}

		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.setViewName("jsonView");

		return mav;
	}

	//수정.
	@Transactional
	@RequestMapping("common/updateLovData")
	public ModelAndView updateLovData(@RequestBody List<Map<String, Object>> paramList, HttpServletRequest request) {
		HttpSession httpSession = request.getSession();
		Map<String, Object> userInfo = (Map<String, Object>) httpSession.getAttribute("userInfo");

		int result = 0;

		for(Map<String, Object> params : paramList) {
			params.put("repId", userInfo.get("userId"));

			result += commonService.updateLovData(params);
		}

		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.setViewName("jsonView");

		return mav;
	}

	//삭제.
	@Transactional
	@RequestMapping("common/deleteLovData")
	public ModelAndView deleteLovData(@RequestBody List<Map<String, Object>> paramList) {

		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		//삭제 불가 코드가 있는 지 확인.
		for(Map<String, Object> params : paramList) {
			int count = commonService.selectCodeCheck(params);

			if(count == 1) {
				mav.addObject("result", "fail");
				mav.addObject("codeId", params.get("codeId"));
				return mav;
			}
		}

		//없다면 삭제.
		for(Map<String, Object> params : paramList) {
			commonService.deleteLovData(params);
		}


		return mav;
	}

	//FTP 파일 업로드.
	@Transactional
	@RequestMapping(value="common/uploadFile")
	public ModelAndView uploadFile(HttpServletRequest request) throws Exception{

		MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;

		String allAtchId = request.getParameter("allAtchId");
		String [] atchIdArr = allAtchId.split(",");

//		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmss");
//		Date nowDate = new Date();
//		String datetime = datetimeFormat.format(nowDate);

		for(int i=0; i<atchIdArr.length; i++) {
			List<MultipartFile> fileList = multipartHttpServletRequest.getFiles("file" + atchIdArr[i]);

			if(fileList != null && fileList.size() > 0) {

				MultipartFile temp = fileList.get(0);
				String checkFileName = temp.getOriginalFilename();

				//첩부파일 이 있는 경우
				if(checkFileName != null && !checkFileName.equals("")) {

					SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
					Date nowDate = new Date();
					String datetime = datetimeFormat.format(nowDate);

					String taskId = request.getParameter("taskId" + atchIdArr[i]);

					for (MultipartFile mf : fileList) {
						String originFileName = mf.getOriginalFilename();				// 원본 파일 명

						//String extension = FilenameUtils.getExtension(originFileName).toLowerCase();	// 파일 확장자

						String addPath = "/" + taskId;

						String filePath = uploadFilePath + addPath; 					// 리모트 파일 경로

						File file = new File(mf.getOriginalFilename());

						mf.transferTo(file); // 서버에 임시 파일 생성

						String fileName = datetime + "_" + originFileName;

						try {
							ftpUtils.upload(file, filePath, fileName, request);

							file.delete(); // 서버에 생성된 임시 파일 삭제
						} catch (Exception e) {
							e.printStackTrace();
						}

					}

					commonService.uploadFile(multipartHttpServletRequest, uploadFilePath, datetime, atchIdArr[i]);
				}

			}

		}

		ModelAndView mv = new ModelAndView("jsonView");
		return mv;
	}

	//FTP 파일 업로드.
		@Transactional
		@RequestMapping(value="common/uploadFileNew")
		public ModelAndView uploadFileNew(HttpServletRequest request) throws Exception{

			MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest)request;

			String allAtchId = request.getParameter("allAtchId");
			String [] atchIdArr = allAtchId.split(",");
			String result = "";

			HttpSession httpSession = request.getSession();
			Map<String, Object> userInfo = (Map<String, Object>) httpSession.getAttribute("userInfo");

			//params.put("repId", userInfo.get("userId"))

			int i = 0;

			String[] extText = new String[] {".txt",".url"};
			String[] extDoc = new String[] {".csv",".doc",".docm",".docx",".dot",".dotm",".dotx",".eps",".fdf",".key",".keynote",".kth",".mpd",".mpp",".mpt",".mpx",".nmbtemplate",".numbers",".odc",".odg",".odp",".ods",".odt",".pages",".pdf",".pot",".potm",".potx",".ppa",".ppam",".pps",".ppsm",".ppsx",".ppt",".pptm",".pptx",".prn",".ps",".pwz",".rtf",".tab",".template",".tsv",".txt",".vdx",".vsd",".vss",".vst",".vsx",".vtx",".wbk",".wiz",".wpd",".wps",".xdf",".xdp",".xlam",".xll",".xlr",".xls",".xlsb",".xlsm",".xlsx",".xltm",".xltx",".xps",".hwp"};
			String[] extImg = new String[] {".bmp",".cr2",".gif",".ico",".ithmb",".jpeg",".jpg",".nef",".png",".raw",".svg",".tif",".tiff",".wbmp",".webp",".psd",".ai",".eps",".dwg",".dxf",".dwt",".dwf",".sldprt",".sldasm",".ipt",".iam",".catpart",".catproduct",".prt",".asm",".x_t",".x_b",".xmt",".xmt_txt",".3dm",".pkg",".bdl",".3ds",".skp",".wrl",".vrml",".cgr",".dae",".stp",".step",".igs",".igesmodel",".dlv",".exp",".session",".iso"};
			String[] extVideo = new String[] {".3g2",".3gp",".3gpp",".3gpp2",".asf",".avi",".dv",".dvi",".flv",".m2t",".m4v",".mkv",".mov",".mp4",".mpeg",".mpg",".mts",".ogv",".ogx",".rm",".rmvb",".ts",".vob",".webm",".mov",".avi",".wmv",".mpe",".asx"};
			String[] extAudio = new String[] {".aac",".aif",".aifc",".aiff",".au",".flac",".m4a",".m4b",".m4p",".m4r",".mid",".mp3",".oga",".ogg",".opus",".ra",".ram",".spx",".wav"};
			String[] extEbook = new String[] {".acsm",".aeh",".azw",".cb7",".cba",".cbr",".cbt",".cbz",".ceb",".chm",".epub",".fb2",".ibooks",".kf8",".lit",".lrf",".lrx",".mobi",".opf",".oxps",".pdf",".pdg",".prc",".tebr",".tr2",".tr3",".xeb"};
			String[] extExtract = new String[] {".ace",".alz",".bz2",".gz",".jar",".rar",".tar",".xz",".zip","7z"};

			boolean isExistForbiddenFile = false;
			List<String> allowedFileExtensions = new ArrayList<String>(Arrays.asList(extText));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extDoc)));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extImg)));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extVideo)));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extAudio)));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extEbook)));
			allowedFileExtensions.addAll(new ArrayList<String>(Arrays.asList(extExtract)));

			List<String> forbiddenFiles = new ArrayList<String>();

			// 파일명 체크
			for(i = 0; i < atchIdArr.length; i++) {
				List<MultipartFile> fileList = multipartHttpServletRequest.getFiles("addedFile" + atchIdArr[i]);
				if(fileList != null && fileList.size() > 0) {
					for (MultipartFile mf : fileList) {
						String originFileName = mf.getOriginalFilename();// 원본 파일 명
						String extension = "." + FilenameUtils.getExtension(originFileName).toLowerCase();// 파일 확장자
						if(!allowedFileExtensions.contains(extension)) {
							isExistForbiddenFile = true;
							forbiddenFiles.add(originFileName);
						}
					}
				}
			}

			if(isExistForbiddenFile) {
				result = "ERROR_EXT";// 금지된 파일 확장자
			} else {

				boolean successDelete = true;
				boolean successUpload = false;

				int iRslt = 0;

				// 삭제 파일이 있는 경우 삭제
				String[] deletedFileSeqs = request.getParameterValues("deletedFileSeqs");
				if(deletedFileSeqs != null && deletedFileSeqs.length > 0) {
					for(String deletedFileSeq : deletedFileSeqs) {
						Map<String, Object> params = new HashMap<String, Object>();
						params.put("seq", deletedFileSeq);
						Map<String, Object> fileInfo = commonService.getFileInfo(params);
						try {
							iRslt = ftpUtils.delete(fileInfo);
							successDelete = successDelete && iRslt > 0;
						} catch (Exception e) {
							successDelete = false;
							 e.printStackTrace();
						}
						iRslt = commonService.deleteFile(params);
						iRslt += commonService.updateAtchIdInfo(fileInfo);
						successDelete = successDelete && iRslt > 0;
					}
				}

				for(i = 0; i < atchIdArr.length; i++) {

					String atchId = atchIdArr[i];

					List<MultipartFile> fileList = multipartHttpServletRequest.getFiles("addedFile" + atchId);

					if(fileList != null && fileList.size() > 0) {

						MultipartFile temp = fileList.get(0);
						String checkFileName = temp.getOriginalFilename();

						//첩부파일 이 있는 경우
						if(checkFileName != null && !checkFileName.equals("")) {

							SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
							Date nowDate = new Date();
							String datetime = datetimeFormat.format(nowDate);

							String taskId = request.getParameter("taskId" + atchId);

							List<Map<String, Object>> insertFileList = new ArrayList<Map<String, Object>>();

							for (MultipartFile mf : fileList) {

								String originFileName = mf.getOriginalFilename();				// 원본 파일 명

								String addPath = "/" + taskId;

								String filePath = uploadFilePath + addPath; 					// 리모트 파일 경로

								File file = new File(originFileName);

								mf.transferTo(file); // 서버에 임시 파일 생성

								String fileName = datetime + "_" + originFileName;

								try {
									iRslt = ftpUtils.upload(file, filePath, fileName, request);

									successUpload = successUpload && iRslt > 0;

									file.delete(); // 서버에 생성된 임시 파일 삭제
								} catch (Exception e) {
									e.printStackTrace();
								}

								Map<String, Object> map = new HashMap<String,Object>();
								map.put("siteId", request.getParameter("siteId" + atchId));
								map.put("key1", request.getParameter("key1" + atchId));
								map.put("key2", request.getParameter("key2" + atchId));
								map.put("key3", request.getParameter("key3" + atchId));
								map.put("key4", request.getParameter("key4" + atchId));
								map.put("atchId", request.getParameter("atchId" + atchId));
								map.put("taskId", request.getParameter("taskId" + atchId));
								map.put("currTime", datetime);
								map.put("fileName", originFileName);
								map.put("filePath", uploadFilePath + "/" + request.getParameter("taskId" + atchId) + "/" + fileName);
								map.put("crNameId",  userInfo.get("userId"));
								insertFileList.add(map);
							}
							commonService.insertFileList(insertFileList);
						}
					}
				}
				result = "SUCCESS";
			}

			ModelAndView mv = new ModelAndView("jsonView");
			mv.addObject("result", result);
			mv.addObject("forbiddenFiles", forbiddenFiles);
			return mv;
		}

	//FTP 파일 다운로드.
	@RequestMapping(value="common/downloadFile")
	public void downloadFile(HttpServletRequest request, HttpServletResponse response) throws Exception{

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("seq", request.getParameter("seq"));

		Map<String, Object> fileInfo = commonService.getFileInfo(params);

		try {
			ftpUtils.download(fileInfo, request, response);
		} catch (Exception e) {
			 e.printStackTrace();
		}

	}

	//FTP 파일 삭제.
	@Transactional
	@RequestMapping("common/deleteFile")
	public ModelAndView deleteFile(@RequestBody List<Map<String, Object>> paramList) throws Exception{

		for(Map<String, Object> params : paramList) {
			//파일 정보 조회
			Map<String, Object> fileInfo = commonService.getFileInfo(params);

			//FTP 파일 삭제
			try {
				ftpUtils.delete(fileInfo);
			} catch (Exception e) {
				 e.printStackTrace();
			}

			//파일 삭제 로직
			commonService.deleteFile(params);

			//삭제이후 각각의 atch_id에 따라 해당되는 테이블 컬럼값 업데이트
			//첨부파일이 있는지 확인후 있을 경우  해당되는 첨부 ID를 넣어주고 없으면 NULL로 업데이트
			commonService.updateAtchIdInfo(fileInfo);
		}

		ModelAndView mav = new ModelAndView();
		mav.setViewName("jsonView");

		return mav;
	}

	//FTP 파일 목록 조회.
	@RequestMapping("common/getFileList")
	public ModelAndView getFileList(@RequestBody Map<String, Object> params) {

		List<Map<String, Object>> result = commonService.getFileList(params);

		ModelAndView mav = new ModelAndView();
		mav.addObject("result", result);
		mav.setViewName("jsonView");

		return mav;
	}

	//서명 화면 호출.
	@RequestMapping("common/commSign")
	public ModelAndView commSign() {

		ModelAndView mav = new ModelAndView();

		return mav;

	}

	//서명 이미지 FTP 업로드.
	@Transactional
	@RequestMapping("common/uploadSign")
	public ModelAndView uploadSign(HttpServletRequest request) {

		String sign = StringUtils.split(request.getParameter("sign"), ",")[1];

		SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	    Date nowDate = new Date();
	    String datetime = datetimeFormat.format(nowDate);

		String fileName =  datetime + "_sign" + ".png";

		try {
			commonService.uploadSign(request, fileName, sign, uploadFilePath);
		} catch (Exception e) {
			e.printStackTrace();
		}

		ModelAndView mav = new ModelAndView();
		mav.addObject("fileName", fileName);
		mav.setViewName("jsonView");

		return mav;

	}

	//업로드된 이미지 보기.
	@RequestMapping(value="common/showImage")
	public void showImage(HttpServletRequest request, HttpServletResponse response) throws Exception{

		String maxSeq = commonService.getMaxIdx();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("seq", maxSeq);

		Map<String, Object> fileInfo = commonService.getFileInfo(params);

		try {
			ftpUtils.download(fileInfo, request, response);
		} catch (Exception e) {
			 e.printStackTrace();
		}

	}

}
