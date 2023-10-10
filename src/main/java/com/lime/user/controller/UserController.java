package com.lime.user.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.lime.common.service.CommonService;
import com.lime.common.service.SmsService;
import com.lime.login.controller.MailSendService;
import com.lime.util.CommUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/user")
public class UserController {

    @Resource(name = "jsonView")
    private MappingJackson2JsonView jsonView;

    @Resource(name = "commonService")
    private CommonService commonService;

    @RequestMapping(value = "/userInsert.do")
    public String userInsertPage() {
        return "/user/userInsert";
    }

    @ResponseBody
    @RequestMapping(value = "/userInsertProcess.do", method = RequestMethod.POST)
    public String userInsertProcess(HttpServletRequest request, ModelMap model) throws Exception {
        
        String userId = request.getParameter("memId");
        String pwd = request.getParameter("pwd");
        String userName = request.getParameter("memName");
        String identifyParam = request.getParameter("identify");
        String identifyNumParam = request.getParameter("identifyNum");
        String gender = request.getParameter("gender");
        String userEmail = request.getParameter("userEmail");
        String zipCodeParam = request.getParameter("zipCode");
        String address = request.getParameter("address");
        String addressDetail = request.getParameter("addressDetail");
        String phoneNum = request.getParameter("phoneNum");
        
        
        int identify = Integer.parseInt(identifyParam);
        int identifyNum = Integer.parseInt(identifyNumParam);
        int zipCode = Integer.parseInt(zipCodeParam);
        
        System.out.println("userId" + userId);
        System.out.println("userName" + userName);
        System.out.println("pwd" + pwd);
        System.out.println("identify" + identify);
        System.out.println("identifyNum" + identifyNum);
        System.out.println("gender" + gender);
        System.out.println("userEmail1" + userEmail);
        System.out.println("zipCode" + zipCode);
        System.out.println("address" + address);
        System.out.println("addressDetail" + addressDetail);
        System.out.println("phoneNum" + phoneNum);
        
        Map<String, Object> inOutMap = new HashMap<>();
        inOutMap.put("userId", userId);
        inOutMap.put("pwd", pwd);
        inOutMap.put("userName", userName);
        inOutMap.put("identify", identify);
        inOutMap.put("identifyNum", identifyNum);
        inOutMap.put("gender", gender);
        inOutMap.put("userEmail", userEmail);
        inOutMap.put("zipCode", zipCode);
        inOutMap.put("address", address);
        inOutMap.put("addressDetail", addressDetail);
        inOutMap.put("phoneNum", phoneNum);
        
        System.out.println("inOutMap con"+inOutMap);
        
        int result = commonService.userSave(inOutMap);
        
        System.out.println("result  " + result);
        model.put("resultMap", result);
        
        return "redirect:login/login"; 
    }
    
    @ResponseBody
    @RequestMapping(value = "/checkUserIdAvailability.do", 
    method = RequestMethod.POST)
    public ModelAndView checkId(
    		HttpServletRequest request
    		
    		) throws Exception {
        
        String userId = request.getParameter("memId");
        
        Map<String, Object> inOutMap = new HashMap<>();
        
        inOutMap.put("userId", userId);
        
        int result = commonService.serchId(inOutMap);
        
        return new ModelAndView(jsonView, "result", result);
    }
    
    @Autowired
    private MailSendService mailService;
//    private SmsService smsService;
	
	@ResponseBody
	@RequestMapping(value = "/mailCheck.do", method = RequestMethod.GET)
	public String mailCheck(String email) {
		System.out.println("이메일 인증 요청이 들어옴!");
		System.out.println("이메일 인증 이메일 : " + email);
		
		return mailService.joinEmail(email);
	}
	
	@ResponseBody
	@RequestMapping(value = "/phoneCheck.do", method = RequestMethod.POST)
    public void validatePhone(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=utf-8");
		
		SmsService smsService = new SmsService();
		
        PrintWriter out = response.getWriter();
        
        System.out.println("out" + out);
        
        String phone =request.getParameter("phone");
        System.out.println("phone" + phone);
        int validateNum = smsService.sendSms(phone);
        
        System.out.println("핸드폰 인증 전달됨");
        System.out.println("핸드폰 번호 " + validateNum);
        out.print(validateNum);
        
        out.close();
    }
	
	
	
}
