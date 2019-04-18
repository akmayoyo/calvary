package com.calvary.common.vo;

import java.util.Arrays;

public class SendSmsVo {

	private String msgKey;
	private String msgType;
	private String msgContents;
	private String sender;
	private String receivers;
	private String subject;
	private String[] sequences;
	
	public String getMsgKey() {
		return msgKey;
	}
	public void setMsgKey(String msgKey) {
		this.msgKey = msgKey;
	}
	public String getMsgType() {
		return msgType;
	}
	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}
	public String getMsgContents() {
		return msgContents;
	}
	public void setMsgContents(String msgContents) {
		this.msgContents = msgContents;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public String getReceivers() {
		return receivers;
	}
	public void setReceivers(String receivers) {
		this.receivers = receivers;
	}
	public String[] getSequences() {
		return sequences;
	}
	public void setSequences(String[] sequences) {
		this.sequences = sequences;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	@Override
	public String toString() {
		return "SendSmsVo [msgKey=" + msgKey + ", msgType=" + msgType + ", msgContents=" + msgContents + ", sender="
				+ sender + ", receivers=" + receivers + ", subject=" + subject + ", sequences="
				+ Arrays.toString(sequences) + "]";
	}
	
}
