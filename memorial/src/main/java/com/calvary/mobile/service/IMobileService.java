package com.calvary.mobile.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangUserVo;

public interface IMobileService {

	public BunyangUserVo getBunyangUserVo(String userName, String birthDate);
	
	public List<Object> getReservedGraveInfo(String bunyangSeq, int userSeq, int coupleSeq, String graveType);
	
	public Map<String, Object> getFamilyGraveRequestInfo(String bunyangSeq);
	
	public List<Object> getContractMinister(String bunyangSeq);
	
	public Map<String, Object> getContract(String codeSeq);
	
	public List<Object> getContractList(String codeSeq);
	
	public int getRequiredGraveCount(String bunyangSeq);
	
	public List<Object> getRequiredGraveList(String bunyangSeq);
	
	public List<Object> getAvailableGraveInfoAll(String graveType, int cnt);
	
	public int assignGrave(String productType, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int isReserved) throws Exception;
	
	public int requestGrave(String productType, String groupSeq, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int firstColSeq, int isReserved) throws Exception;
	
	public List<Object> getBunyangSeqOfGrave(String section_seq, String row_seq, String col_seq);
	
	public List<Object> getFirstReservedInfo(String bunyang_seq);
	
	public int updateGraveBunyangSeq(String section_seq, String row_seq, String col_seq, String bunyang_seq) throws Exception;
}
