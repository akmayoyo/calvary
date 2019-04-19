package com.calvary.common.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Random;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import com.calvary.common.vo.ResultSmsVo;
import com.calvary.common.vo.SendSmsVo;

import sun.misc.BASE64Encoder;

public class SMSUtil {

	public static final String SMS_TYPE_SMS = "S";
	public static final String SMS_TYPE_LMS = "L";
	public static final String SMS_TYPE_MMS = "M";
	
	public static final String SMS_URL = "https://sslsms.cafe24.com/sms_sender.php";
	public static final String SMS_USER_ID = "mparkcalvary";
	public static final String SMS_SECURE = "0ab3e384e97e239ce9f61a248f85f74a";
	public static final String SMS_SENDER = "010-8951-1042";
	
	private static final Logger logger = LoggerFactory.getLogger(SMSUtil.class);
	private static final Logger errLogger = LoggerFactory.getLogger("ERROR_LOGGER");
	
	public static ResultSmsVo sendSms(SendSmsVo smsVo) {
		ResultSmsVo resultVo = new ResultSmsVo();
		
		Socket socket = null;
		BufferedWriter wr = null;
		BufferedReader rd = null;
		try {
			String sms_url = SMS_URL;// SMS 전송요청 URL
			String[] sender = SMS_SENDER.split("-");
	        String user_id = base64Encode(SMS_USER_ID); // SMS아이디
	        String secure = base64Encode(SMS_SECURE);//인증키
	        String msg = base64Encode(smsVo.getMsgContents());
	        String rphone = base64Encode(smsVo.getReceivers());
	        String sphone1 = base64Encode(sender[0]);
	        String sphone2 = base64Encode(sender[1]);
	        String sphone3 = base64Encode(sender[2]);
	        String rdate = base64Encode("");
	        String rtime = base64Encode("");
	        String mode = base64Encode("1");
	        String subject = base64Encode("");
	        String testflag = base64Encode("");
	        String destination = base64Encode("");
	        String repeatFlag = base64Encode("");
	        String repeatNum = base64Encode("");
	        String repeatTime = base64Encode("");
	        String smsType = base64Encode(smsVo.getMsgType());
	        
	        if(SMS_TYPE_LMS.equals(smsVo.getMsgType())) {
	            subject = base64Encode(smsVo.getSubject());
	        }
	        
	        String[] host_info = sms_url.split("/");
	        String host = host_info[2];
	        String path = "/" + host_info[3];
	        int port = 80;

	        // 데이터 맵핑 변수 정의
	        String arrKey[]
	            = new String[] {"user_id","secure","msg", "rphone","sphone1","sphone2","sphone3","rdate","rtime"
	                        ,"mode","testflag","destination","repeatFlag","repeatNum", "repeatTime", "smsType", "subject"};
	        String valKey[]= new String[arrKey.length] ;
	        valKey[0] = user_id;
	        valKey[1] = secure;
	        valKey[2] = msg;
	        valKey[3] = rphone;
	        valKey[4] = sphone1;
	        valKey[5] = sphone2;
	        valKey[6] = sphone3;
	        valKey[7] = rdate;
	        valKey[8] = rtime;
	        valKey[9] = mode;
	        valKey[10] = testflag;
	        valKey[11] = destination;
	        valKey[12] = repeatFlag;
	        valKey[13] = repeatNum;
	        valKey[14] = repeatTime;
	        valKey[15] = smsType;
	        valKey[16] = subject;
	        
	        String boundary = "";
	        Random rnd = new Random();
	        String rndKey = Integer.toString(rnd.nextInt(32000));
	        MessageDigest md = MessageDigest.getInstance("MD5");
	        byte[] bytData = rndKey.getBytes();
	        md.update(bytData);
	        byte[] digest = md.digest();
	        for(int i =0;i<digest.length;i++)
	        {
	            boundary = boundary + Integer.toHexString(digest[i] & 0xFF);
	        }
	        boundary = "---------------------"+boundary.substring(0,11);

	        // 본문 생성
	        String data = "";
	        String index = "";
	        String value = "";
	        for (int i=0;i<arrKey.length; i++)
	        {
	            index =  arrKey[i];
	            value = valKey[i];
	            data +="--"+boundary+"\r\n";
	            data += "Content-Disposition: form-data; name=\""+index+"\"\r\n";
	            data += "\r\n"+value+"\r\n";
	            data +="--"+boundary+"\r\n";
	        }

	        socket = new Socket(host, port);
	        
	        // 헤더 전송
	        wr = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream(), "UTF-8"));
	        wr.write("POST "+path+" HTTP/1.0\r\n");
	        wr.write("Content-Length: "+data.length()+"\r\n");
	        wr.write("Content-type: multipart/form-data, boundary="+boundary+"\r\n");
	        wr.write("\r\n");

	        // 데이터 전송
	        wr.write(data);
	        wr.flush();

	        // 결과값 얻기
	        rd = new BufferedReader(new InputStreamReader(socket.getInputStream(), "UTF-8"));
	        String line;
	        ArrayList<String> tmpArr = new ArrayList<String>();
	        while ((line = rd.readLine()) != null) {
	            tmpArr.add(line);
	        }
	        wr.close();
	        rd.close();

	        String tmpMsg = (String)tmpArr.get(tmpArr.size()-1);
	        String[] rMsg = tmpMsg.split(",");
	        
	        if(rMsg.length > 0) {
	        	String result = rMsg[0]; //발송결과
		        String count = ""; //잔여건수
		        if(rMsg.length > 1) {
		        	count = rMsg[1]; 
		        }
		        resultVo.setResult(result);
		        resultVo.setCount(count);
		        logger.info("================ SEND SMS ================");
		        logger.info(smsVo.toString());
		        logger.info(resultVo.toString());
	        }
		} catch(Exception e) {
			errLogger.error("sendSms error occured!!", e);
		} finally {
			if(socket != null) {
				try {
					socket.close();
				} catch (IOException e) {}
			}
			if(wr != null) {
				try {
					wr.close();
				} catch (IOException e) {}
			}
			if(rd != null) {
				try {
					rd.close();
				} catch (IOException e) {}
			}
		}
		return resultVo;
	}
	
	/** */
	public static String getMsgContents(String msgContents, String[] sequences) {
		String sRtn = msgContents;
		if(sequences != null && !StringUtils.isEmpty(sRtn)) {
			for(int i = 0; i < sequences.length; i++) {
				String seq = sequences[i];
				sRtn = sRtn.replace("{" + i + "}", seq);
			}
		}
		return sRtn;
	}
	
	/** */
	public static String base64Encode(String str)  throws IOException {
		String result = "";
		if(!StringUtils.isEmpty(str)) {
			BASE64Encoder encoder = new BASE64Encoder();
	        byte[] strByte = str.getBytes();
	        result = encoder.encode(strByte);
		}
        return result ;
    }
}
