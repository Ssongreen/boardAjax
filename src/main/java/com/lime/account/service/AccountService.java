package com.lime.account.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface AccountService {

	int accountSave(Map<String, Object> inOutMap);

	Map<String, Object> getAccountDataBySeq(int accountSeq);
	
	int updateModify(Map<String, Object> inOutMap);
	
	Map<String, Object> selectCategory(int inOutMap) throws Exception;
	
	List<EgovMap> serchAll(Map<String, Object> inOutMap);

	int searchCount(Map<String, Object> inOutMap);

	
}
