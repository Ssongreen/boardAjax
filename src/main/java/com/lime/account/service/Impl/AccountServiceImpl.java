package com.lime.account.service.Impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import com.lime.account.service.AccountService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("accountService")
public class AccountServiceImpl implements AccountService {

	@Resource(name="accountDAO")
	private AccountDAO accountDAO;

	@Override
	public int accountSave(Map<String, Object> inOutMap) {
		System.out.println("impl  "+ inOutMap);
		return accountDAO.insertAccount(inOutMap);
	}

	@Override
	public Map<String, Object> getAccountDataBySeq(int accountSeq) {
		System.out.println("service + " + accountSeq);
		System.out.println("accountSeq의 타입 ssss : " + ((Object)accountSeq).getClass().getName());
		return accountDAO.getAccountDataBySeq(accountSeq);
	}

	@Override
	public int updateModify(Map<String, Object> inOutMap) {
		System.out.println("service + " + inOutMap);
		return accountDAO.updateAccount(inOutMap);
	}
	
	@Override
	public Map<String, Object> selectCategory(int inOutMap) throws Exception {
		System.out.println("service  acc selectCategory impl" +inOutMap);
		return accountDAO.selectCategory(inOutMap);
	}

	@Override
	public List<EgovMap> serchAll(Map<String, Object> inOutMap) {
		return accountDAO.serchAll(inOutMap);
	}

	@Override
	public int searchCount(Map<String, Object> inOutMap) {
		return accountDAO.serchCount(inOutMap);
	}
	

}
