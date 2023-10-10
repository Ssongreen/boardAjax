package com.lime.common.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonService {

	List<EgovMap> selectCombo(Map<String, Object> inOutMap) throws Exception;
	
	int serchId(Map<String, Object> inOutMap) throws Exception;
	
	int userSave(Map<String, Object> inOutMap) throws Exception;
	
	int joinLogin(Map<String, Object> inOutMap) throws Exception;

	String getUserNameFromDatabase(String userId);

	int kakaoLogin(Map<String, Object> inOutMap);
	
	int joinKakao(Map<String, Object> inOutMap);

	
}
