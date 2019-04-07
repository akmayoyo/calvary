package com.calvary.mobile.service;

import java.util.List;
import java.util.Map;

import com.calvary.admin.vo.BunyangUserVo;

public interface IMobileService {

	public BunyangUserVo getBunyangUserVo(String userName, String birthDate);
	
	public Map<String, Object> getReservedGraveInfo(String bunyangSeq, int userSeq, int coupleSeq);
	
	public List<Object> getContractMinister(String bunyangSeq);
	
	public Map<String, Object> getContract(String codeSeq);
	
	public List<Object> getContractList(String codeSeq);
	
	public int getRequiredGraveCount(String bunyangSeq);
	
	public List<Object> getAvailableGraveInfoAll(String graveType, int cnt);
	
	public int assignGrave(String productType, String bunyangSeq, int coupleSeq, int userSeq, String sectionSeq, int rowSeq, int colSeq, int isReserved) throws Exception;
}
