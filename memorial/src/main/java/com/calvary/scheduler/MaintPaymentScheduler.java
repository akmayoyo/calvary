package com.calvary.scheduler;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.calvary.common.dao.CommonDao;
import com.calvary.common.service.ICommonService;
import com.calvary.common.util.CommonUtil;

@Component
public class MaintPaymentScheduler {

	private static final Logger logger = LoggerFactory.getLogger(MaintPaymentScheduler.class);
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	@Autowired
	private CommonDao commonDao;
	
	@Autowired
	private ICommonService commonService;
	
	/**
	 * 매일 0시1분에 실행
	 */
	@SuppressWarnings("unchecked")
	@Scheduled(cron="0 10 0 * * *")
	public void run() {
		logger.info("======================== 관리비납부정보생성 시작 ========================");
		
		List<Object> targetList = commonDao.selectList("admin.getRemakePaymentInfo", null);
		
		if(targetList != null && targetList.size() > 0) {
			for(int i = 0; i < targetList.size(); i++) {
				Map<String, Object> tmp = (HashMap<String, Object>)targetList.get(i);
				String bunyangSeq = (String)tmp.get("bunyang_seq");
				String bunyangNo = (String)tmp.get("bunyang_no");
				String maintEndDate = (String)tmp.get("maint_end_date");
				String paymentType = (String)tmp.get("payment_type");
				String userName = (String)tmp.get("user_name");
				int userSeq = CommonUtil.convertToInt(tmp.get("user_seq"));
				String maintStartDate = getIntervalDay(maintEndDate, 1);
				String result = "";
				try {
					String maintSeq = String.valueOf(commonService.getSeqNexVal("MAINT_SEQ"));
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("bunyangSeq", bunyangSeq);
					param.put("userSeq", userSeq);
					param.put("maintSeq", maintSeq);
					param.put("maintStartDate", maintStartDate);
					param.put("paymentType", paymentType);
					int iRslt = commonDao.insert("admin.createAutoMaintPaymentInfo", param);
					result = iRslt > 0 ? "정상" : "실패";
				} catch(Exception e) {
					result = "에러";
					errLogger.error("관리비납부정보 생성 에러발생!!", e);
				}
				logger.info(String.format("분양번호:%s, 납부자명:%s, 납부종료일:%s, 납부유형:%s, 생성결과:%s", bunyangNo, userName, maintEndDate, paymentType, result));
			}
		}
		
		logger.info("======================== 관리비납부정보생성 종료 ========================");
	}
	
	private String getIntervalDay(String targetDate, int interval) {
		String sRtn = "";
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar c = Calendar.getInstance();
			c.setTime(sdf.parse(targetDate));
			c.add(Calendar.DATE, interval);
			sRtn = sdf.format(c.getTime());
		} catch (ParseException e) {
			errLogger.error("error occured to getIntervalDay!!", e);
		}
		return sRtn;
	}
}
