package com.lime.account.controller;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections4.map.HashedMap;
import org.apache.logging.log4j.core.tools.picocli.CommandLine.Help.TextTable.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.lime.account.service.AccountService;
import com.lime.account.service.Impl.AccountDTO;
import com.lime.common.service.CommonService;
import com.lime.util.CommUtils;

import egovframework.example.sample.service.SampleDefaultVO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;


@Controller
public class AccountController {


	@Resource(name = "jsonView")
	private MappingJackson2JsonView jsonView;

	@Resource(name="accountService")
	private AccountService accountService;

	@Resource(name="commonService")
	private CommonService commonService;
	
	private Map<String, Long> requestTimestamps = new ConcurrentHashMap<>();
	
	SampleDefaultVO sampleDefaultVO = new SampleDefaultVO();
	
	/**
	 *
	 * @param searchVO - 조회할 정보가 담긴 SampleDefaultVO
	 * @param model
	 * @return "egovSampleList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/account/accountList.do")
	public String selectSampleList(
			@RequestParam Map<String,Object> inOutMap,
			HttpServletRequest request, 
			ModelMap model) throws Exception {
		
		String userId = (String) request.getSession().getAttribute("userId");
		String userName = (String) request.getSession().getAttribute("userName");
		
		PaginationInfo paginationInfo = new PaginationInfo();
		
		int pageNo = 1; //현재 페이지 번호
		int listScale = 10; // 한 페이지에 나올 글 수
		int pageScale = 10; // 페이지 개수
		
		try {
            if(inOutMap.size() > 0) {
                pageNo = Integer.parseInt((String)inOutMap.get("pageNo"));//현재 페이지 번호
            }
        
//            System.out.println("pageNo" + pageNo);
            
            paginationInfo.setCurrentPageNo(pageNo); // 현재
            paginationInfo.setRecordCountPerPage(listScale); //한페이지 보여줄
            paginationInfo.setPageSize(pageScale); 
            
            int startPage = paginationInfo.getFirstRecordIndex(); //시작 페이지
            int lastPage = paginationInfo.getLastRecordIndex(); //마지막 페이지
            
            inOutMap.put("userName", userName);
            inOutMap.put("startPage", startPage);
            inOutMap.put("lastPage", lastPage);
            
//            System.out.println("위에 start" + startPage);
//            System.out.println("위에 last" + lastPage);
            
            int totalList  = accountService.searchCount(inOutMap); //전체 페이지
            
            paginationInfo.setTotalRecordCount(totalList);//전체 글 개수
            
//            System.out.println("totalList"+totalList);
            
            List<EgovMap> result  = accountService.serchAll(inOutMap);
            
//            System.out.println("getTotalPageCount " + paginationInfo.getTotalPageCount());
//            System.out.println("getTotalRecordCount " + paginationInfo.getTotalRecordCount());
//            System.out.println("getLastPageNoOnPageList " + paginationInfo.getLastPageNoOnPageList());
//            System.out.println("getFirstPageNo " + paginationInfo.getFirstPageNo());
//            System.out.println("getLastPageNo " + paginationInfo.getLastPageNo());
//            System.out.println("getFirstRecordIndex " + paginationInfo.getFirstRecordIndex());
//            System.out.println("getLastRecordIndex " + paginationInfo.getLastRecordIndex());
            
            System.out.println("result ++" + result);
//            System.out.println("아래 start" + startPage);
//            System.out.println("아래 last" + lastPage);
            
            model.addAttribute("pageNo",pageNo);
            model.addAttribute("result",result);
            model.addAttribute("totalList",totalList);
            model.addAttribute("paginationInfo",paginationInfo);
		} catch (Exception e) {
        }
		return "/account/accountList";
	}
	
	

	/**
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/account/accountInsert.do")
	public String accountSave(HttpServletRequest request,
			ModelMap model) throws Exception{
		
		Map<String, Object> inOutMap = new HashMap<>();

		inOutMap.put("category", "A000000");
		
		List<EgovMap> resultMap= commonService.selectCombo(inOutMap);

//		System.out.println(resultMap);
		model.put("resultMap", resultMap);

		return "/account/accountInsert";
	}

	/**
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */

		@RequestMapping(value="/account/selectCombo.do")
		public ModelAndView ajaxtest(HttpServletRequest request
				) throws Exception{

			Map<String, Object> inOutMap  = CommUtils.getFormParam(request);

			List<EgovMap> result = commonService.selectCombo(inOutMap);
			ModelAndView modelAndView = new ModelAndView(jsonView);
			modelAndView.addObject("result", result);
			
			return modelAndView;
		}
		
		@RequestMapping(value="/account/accountInsert.do", method = RequestMethod.POST)
		@ResponseBody
		public int accountInsert(HttpServletRequest request, @RequestBody AccountDTO formData, ModelMap model) throws Exception{
			
			String profitCost = formData.getProfitCost();
		    String bigGroup = formData.getBigGroup();
		    String middleGroup = formData.getMiddleGroup();
		    String smallGroup = formData.getSmallGroup();
		    String detailGroup = formData.getComment1();
		    String comment = formData.getComment();
		    Integer transactionMoney = formData.getTransactionMoney();
		    String transactionDate = formData.getTransactionDate();
//		    System.out.println("위 detailGroup" + detailGroup);
			String userName = (String) request.getSession().getAttribute("userName");
			
			Map<String, Object> inOutMap = new HashMap<>();
			
			inOutMap.put("profitCost", profitCost);
			inOutMap.put("bigGroup", bigGroup);
			inOutMap.put("middleGroup", middleGroup);
			inOutMap.put("smallGroup", smallGroup);
			inOutMap.put("detailGroup", detailGroup);
			inOutMap.put("comment", comment);
			inOutMap.put("transactionMoney", transactionMoney);
			inOutMap.put("userName", userName);
			inOutMap.put("transactionDate", transactionDate);
			
			accountService.accountSave(inOutMap);
			
//			System.out.println("위에 " +  inOutMap.get("accountSeq"));
//			System.out.println(" 위에 " + inOutMap.toString());
			
			int accountSeq = (int) inOutMap.get("accountSeq");
//			System.out.println(" 위에 " + accountSeq);
			
			return accountSeq;
			  
			}
		
		@RequestMapping(value="/account/accountModify.do")
		public String accountModify(HttpServletRequest request,
				@RequestParam (value = "accountSeq") Integer accountSeq,
				ModelMap model) throws Exception{
			
			Map<String, Object> inOutMap = accountService.selectCategory(accountSeq);
			
			
			model.addAttribute("inOutMap",inOutMap);
//			System.out.println("아래 " + inOutMap);
			
			return "/account/accountModify" ;
		}
		
		@ResponseBody
		@RequestMapping(value="/account/accountModify.do" , 
				method = RequestMethod.POST )
		public int accountModify(HttpServletRequest request,
				@RequestBody AccountDTO formData,
				ModelMap model) throws Exception{
			
			String userName = (String) request.getSession().getAttribute("userName");
			
			int accountSeq = (int)formData.getAccountSeq();
			String profitCost = formData.getProfitCost();
		    String bigGroup = formData.getBigGroup();
		    String middleGroup = formData.getMiddleGroup();
		    String smallGroup = formData.getSmallGroup();
		    String detailGroup = formData.getComment1();
		    String comment = formData.getComment();
		    Integer transactionMoney = formData.getTransactionMoney();
		    String transactionDate = formData.getTransactionDate();
		    
		    System.out.println(accountSeq);
		    System.out.println(profitCost);
		    System.out.println(bigGroup);
		    System.out.println(middleGroup);
		    System.out.println(smallGroup);
		    System.out.println("아래 detailGroupdetailGroup "+detailGroup);
		    System.out.println(comment);
		    System.out.println(transactionMoney);
		    System.out.println(transactionDate);
		    
		    Map<String, Object> inOutMap = new HashMap<>();
		    inOutMap.put("accountSeq", accountSeq);
		    inOutMap.put("profitCost", profitCost);
			inOutMap.put("bigGroup", bigGroup);
			inOutMap.put("middleGroup", middleGroup);
			inOutMap.put("smallGroup", smallGroup);
			inOutMap.put("detailGroup", detailGroup);
			inOutMap.put("comment", comment);
			inOutMap.put("transactionMoney", transactionMoney);
			inOutMap.put("userName", userName);
			inOutMap.put("transactionDate", transactionDate);
			
			System.out.println("수정 inOUtMap" + inOutMap);
			int result = accountService.updateModify(inOutMap);
			System.out.println("result 결과 "+result);
			
			return result;
			}
		
}// end of calss
