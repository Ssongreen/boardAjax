package com.lime.account.service.Impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Repository("accountDAO")
public class AccountDAO extends EgovAbstractMapper{

	
	public int insertAccount(Map<String, Object> inOutMap) {
		System.out.println("DAO  " +inOutMap);
        return insert("Account.accountInsert", inOutMap);
	}

	public Map<String, Object> getAccountDataBySeq(int accountSeq) {
		System.out.println("DAO  acc" + accountSeq);
		return selectOne("Account.getAccountDataBySeq", accountSeq);
	}

	public int updateAccount(Map<String, Object> inOutMap) {
		System.out.println("DAO  +++ "  +inOutMap);
		return update("Account.accountUpdate", inOutMap);
	}

	public Map<String, Object> selectCategory(int inOutMap) {
		return selectOne("Account.selectCategory", inOutMap);
	}

	public List<EgovMap> serchAll(Map<String, Object> inOutMap) {
		return selectList("Account.serchAll", inOutMap);
	}
	public int serchCount(Map<String, Object> inOutMap) {
		return selectOne("Account.serchCount", inOutMap);
	}
	
	
}
