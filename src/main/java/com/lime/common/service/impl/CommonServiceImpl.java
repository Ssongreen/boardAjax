package com.lime.common.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.lime.common.service.CommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonService")
public class CommonServiceImpl implements CommonService {


	@Resource(name="commonDAO")
	private CommonDAO commonDAO;

	@Override
	public List<EgovMap> selectCombo(Map<String, Object> inOutMap) throws Exception {
		return commonDAO.selectCombo(inOutMap);
	}

	@Override
	public int serchId(Map<String, Object> inOutMap) throws Exception {
		return commonDAO.serchId(inOutMap);
	}

	@Override
	public int userSave(Map<String, Object> inOutMap) throws Exception {
		return commonDAO.insertUser(inOutMap);
	}

	@Override
	public int joinLogin(Map<String, Object> inOutMap) throws Exception {
		
		System.out.println("service " + inOutMap.get("userId"));
		
		String userId = (String) inOutMap.get("userId");
		String pwd = (String) inOutMap.get("pwd");
		
		
		Map<String, Object> result = commonDAO.findIdAndPwd(inOutMap);
		
			
		if (userId.equals(result.get("userId"))) {
		    if (pwd.equals(result.get("pwd"))) {
		        return commonDAO.joinLogin(inOutMap);
		    }
		}
		return 0;
	}

	@Override
	public String getUserNameFromDatabase(String userId) {
		return commonDAO.getUserNameFromDatabase(userId);
	}

	@Override
	public int kakaoLogin(Map<String, Object> inOutMap) {
//		System.out.println("service common impl" +inOutMap);
		return commonDAO.kakaoLogin(inOutMap);
	}

	@Override
	public int joinKakao(Map<String, Object> inOutMap) {
		System.out.println("service common impl" +inOutMap);
		return commonDAO.joinKakao(inOutMap);
	}


}


