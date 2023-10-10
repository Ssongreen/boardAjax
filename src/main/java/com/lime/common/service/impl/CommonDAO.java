package com.lime.common.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.fdl.cmmn.exception.EgovBizException;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Repository("commonDAO")
public class CommonDAO extends EgovAbstractMapper{

	public List<EgovMap> selectCombo(Map<String, Object> inOutMap) throws EgovBizException{
		return selectList("Common.selectCombo", inOutMap);
	}

	public int serchId(Map<String, Object> inOutMap) throws EgovBizException {
	        return selectOne("Common.checkUserIdExist", inOutMap);
	}

	public int insertUser(Map<String, Object> inOutMap) {
		return insert("Common.insertUser", inOutMap);
	}
	
	public int joinLogin(Map<String, Object> inOutMap) {
		return selectOne("Login.checkLogin", inOutMap);
	}

	public String getUserNameFromDatabase(String userId) {
		return selectOne("Login.findName",userId);
	}

	public Map<String, Object> findIdAndPwd(Map<String, Object> inOutMap) {
		return selectOne("Login.findIdAndPwd",inOutMap);
	}

	public int idDuplicateCheck(Map<String, Object> inOutMap) {
		return selectOne("Login.idDuplicateCheck", inOutMap);
	}

	public int kakaoLogin(Map<String, Object> inOutMap) {
//		System.out.println("service CommonDAO impl" +inOutMap);
		return selectOne("Login.kakaoLogin", inOutMap);
	}

	public int joinKakao(Map<String, Object> inOutMap) {
		System.out.println("service CommonDAO impl" +inOutMap);
		return insert("Login.joinKakao", inOutMap);
	}

	
	
}

