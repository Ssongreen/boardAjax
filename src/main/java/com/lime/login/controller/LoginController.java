package com.lime.login.controller;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.lime.common.service.CommonService;
import com.lime.util.CommUtils;

@Controller
public class LoginController {


	@Resource(name = "jsonView")
	private MappingJackson2JsonView jsonView;

	@Resource(name="commonService")
	private CommonService commonService;

	@RequestMapping(value="/login/login.do",method = {RequestMethod.GET, RequestMethod.POST})
	public String loginview(HttpServletRequest request ) {
		return "/login/login";
	}
	
	@RequestMapping(value="/login/")
	public ModelAndView idCkedAjax(HttpServletRequest request 
			) throws Exception {
		Map<String, Object> inOutMap  = CommUtils.getFormParam(request);
		
		return new ModelAndView(jsonView, inOutMap);
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/login/kakaoLogin.do", method = RequestMethod.POST)
	public boolean kakaoLogin(HttpServletRequest request, 
			HttpSession session,
			ModelMap model)throws Exception {
		
		
		String id =request.getParameter("id");
		String userName =request.getParameter("userName");
		
//		System.out.println("id" + id);
//		System.out.println("userName" + userName);
		
		
		Map<String, Object> inOutMap = new HashMap<>();
	    
		inOutMap.put("id", id);
		inOutMap.put("userName", userName);
	    
	    System.out.println("inOutMap kakao" + inOutMap);
	    
	    int result = commonService.kakaoLogin(inOutMap);
	    
	    System.out.println("result  " + result);
	    
	    if (result == 1) {
	    	System.out.println("컨트롤러 성공 !");
	    	session.setAttribute("userName", userName);
	    	
	        return true;
	        
	    } else {
	    	
	        return false; 
	    }
	}
	
	@RequestMapping(value = "/login/joinKakao.do")
	public String joinKakao(HttpSession session) {
		
	    return "/login/joinKakao";
	}

	@ResponseBody
	@RequestMapping(value = "/login/joinKakao.do", method = RequestMethod.POST)
	public boolean joinKakao(HttpServletRequest request, 
	        HttpSession session,
	        ModelMap model)throws Exception {
	    String id = request.getParameter("id");
	    String userName = request.getParameter("nickname");
	    
	    System.out.println("id" + id);
	    System.out.println("userName" + userName);
	    Map<String, Object> inOutMap = new HashMap<>();
	    
	    inOutMap.put("id", id);
	    inOutMap.put("userName", userName);
	    
	    int result = commonService.joinKakao(inOutMap);
	    
	    System.out.println("result" + result);
	    
	    if (result == 1) {
	        // 회원가입 성공 시 부모 창에 결과를 전달
	        return true;
	    } else {
	        return false; 
	    }
	}
	
	
	@ResponseBody
	@RequestMapping(value = "/login/login.do", method = RequestMethod.POST)
	public boolean userInsertProcess(
			HttpServletRequest request, 
			HttpSession session,
			ModelMap model) throws Exception {
		
	    String userId = request.getParameter("memId");
	    String pwd = request.getParameter("pwd");
	    
	    
	    Map<String, Object> inOutMap = new HashMap<>();
	    
	    inOutMap.put("userId", userId);
	    inOutMap.put("pwd", pwd);
	    
	    System.out.println("inOutMap con" + inOutMap);
	    
	    int result = commonService.joinLogin(inOutMap);
	    
	    System.out.println("result  " + result);
	    
	    if (result == 1) {
	    	
	    	String userName = commonService.getUserNameFromDatabase(userId);
	    	session.setAttribute("userName", userName);
	        session.setAttribute("userId", userId);
	        model.put("result con", result);
	        return true;
	        
	    } else {
	    	
	        return false; // 로그인 실패
	    }
	}
	
	@RequestMapping(value = "/login/logout.do")
	public ModelAndView logout(HttpServletRequest request) throws Exception {
	    // 세션을 종료하여 로그아웃
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        session.invalidate();
	    }

	    // 로그아웃 후 리다이렉트 또는 다른 작업을 수행할 수 있습니다.
	    // 이 예제에서는 로그아웃 후 메인 페이지로 리다이렉트하는 코드를 추가했습니다.
	    return new ModelAndView("redirect:/login/login.do"); // "/"는 메인 페이지 경로입니다.
	}
	



}// end of class

