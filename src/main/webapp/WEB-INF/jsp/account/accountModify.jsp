<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	String userName = (String) session.getAttribute("userName");

	if (userName == null) {
		// 로그인 정보가 없는 경우 처리
		response.sendRedirect("/login/login.do");
		return;
	}
%>
<script src="/js/common.js"></script>
<script>
    /* console.log('${inOutMap.smallGroupCodeKor}'); */
        let userName = '<%= userName %>';
        const category = "A000000";
        let profitCostValue = '${inOutMap.profitCost}';
        let bigGroupValue = '${inOutMap.bigGroup}';
        let middleGroupValue = '${inOutMap.middleGroup}';
        let smallGroupValue = '${inOutMap.smallGroup}';
        let ditailGroupValue = '${inOutMap.detailGroup}';
        
    $(document).ready(function() {
    	
    	             
        if (category) {
        	updateCategory(category, "#profitCost");
        } 
        
        if (profitCostValue) {
            updateCategory(profitCostValue, "#bigGroup");
        } 
        
        if (bigGroupValue) {
        	/* $('#middleGroup').val(bigGroupValue).prop("selected", true); */
            updateCategory(bigGroupValue , "#middleGroup");
        } 
        
        if (middleGroupValue) {
        	/* $('#smallGroup').val(middleGroupValue).prop("selected", true); */
            updateCategory(middleGroupValue , "#smallGroup");
        } 
        if (smallGroupValue) {
        	 /* $('#comment1').val(smallGroupValue).prop("selected", true); */
            updateCategory(smallGroupValue , "#comment1");
        } 
        if (ditailGroupValue ) {
        	 /* $('#comment1').val(smallGroupValue).prop("selected", true); */
            updateCategory(ditailGroupValue , "#comment1");
        } 
        function updateCategory(category, inoutId) {
            $.ajax({
                url: '/account/selectCombo.do',
                method: 'GET',
                data: {
                    category: category
                },
                success: function(data) {
                	
                    $.each(data, function(index, items) {
                        $.each(items, function(itemIndex, item) {
                            $(inoutId).append($('<option>', {
                                value: item.code,
                                text: item.comKor
                            }));
                            $('#profitCost').val(profitCostValue).prop("selected", true);
                            $('#bigGroup').val(bigGroupValue).prop("selected", true);
                            $('#middleGroup').val(middleGroupValue).prop("selected", true);
                            $('#smallGroup').val(smallGroupValue).prop("selected", true);
                            $('#comment1').val(ditailGroupValue).prop("selected", true);
                            
                        });
                    });
                    

            	    if (!smallGroupValue) {
            	        $('#smallGroup').empty();
            	        $('#smallGroup').append($('<option>', {
            	            value: '',
            	            text: '선택'
            	        }));
            	    }
            	    if (!ditailGroupValue) {
            	        $('#comment1').empty();
            	        $('#comment1').append($('<option>', {
            	            value: '',
            	            text: '선택'
            	        }));
            	    }
                }
            });
        }
    });
</script>
<script>
	$(document).ready(
			function() {
				$('#profitCost').change(function() {
					console.log("userName = == = = =", userName)
					var selectedCategory = $(this).val();
					// 1단계 카테고리 업데이트
					changeCategory(selectedCategory, 1);
				});

				$('#bigGroup').change(function() {
					var selectedCategory = $(this).val();

					// 2단계 카테고리 업데이트
					changeCategory(selectedCategory, 2);
					
				});
				
				$('#middleGroup').change(function() {
					var selectedCategory = $(this).val();

					// 3단계 카테고리 업데이트
					changeCategory(selectedCategory, 3);
				});
				
				$('#smallGroup').change(function() {
					var selectedCategory = $(this).val();

					// 4단계 카테고리 업데이트
					changeCategory(selectedCategory, 4);
				});

				function changeCategory(category, level) {
					$.ajax({
						url : '/account/selectCombo.do',
						method : 'GET',
						data : {
							category : category
						},
						success : function(data) {
							var targetSelect;
							if (level === 1) {
							    targetSelect = $('#bigGroup');
							} else if (level === 2) {
							    targetSelect = $('#middleGroup');
							} else if (level === 3) {
							    targetSelect = $('#smallGroup');
							} else if (level === 4) {
							    targetSelect = $('#comment1');
							}
							
							if(level === 1){
								$('#smallGroup').empty();
								// 선택 옵션 추가
								$('#smallGroup').append($('<option>', {
									value : '',
									text : '선택'
								}));
							}
							
							if(targetSelect !== 4){
								$('#comment1').empty();
								// 선택 옵션 추가
								$('#comment1').append($('<option>', {
									value : '',
									text : '선택'
								}));
							}
							
							targetSelect.empty();
							// 선택 옵션 추가
							targetSelect.append($('<option>', {
								value : '',
								text : '선택'
							}));
							
							$.each(data, function(index, items) {
								$.each(items, function(itemIndex, item) {
									targetSelect.append($('<option>', {
										value : item.code,
										text : item.comKor
									}));

									// 다음 레벨의 카테고리 업데이트 (3단계까지만 업데이트)
									var nextLevel = level + 1;
									if (nextLevel <= 4) {
										var nextSelectId = '';
										if (nextLevel === 2) {
											nextSelectId = 'middleGroup';
										} else if (nextLevel === 3) {
											nextSelectId = 'smallGroup';
										} else if (nextLevel === 4){
											nextSelectId = 'comment1';
										}
										
										if (nextSelectId) {
											var nextSelect = $('#'
													+ nextSelectId);
											nextSelect.empty();

											// 선택 옵션 추가
											nextSelect.append($('<option>', {
												value : '',
												text : '선택'
											}));
										}
									}
								});
							});
						}
					});
				}
			});
</script>

<script>
function formatDate(inputDate) {
    var date = new Date(inputDate);
    var year = date.getFullYear();
    var month = String(date.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하므로 1을 더하고 두 자리로 포맷
    var day = String(date.getDate()).padStart(2, '0');
    var formattedDate = year+ month + day;
    return formattedDate;
}
$(document).ready(function() {
	let accountSeq = parseInt('${inOutMap.accountSeq}');
	/* console.log(accountSeq); */
	$("#edtBtn").click(function() {
	    
		var profitCost = $("#profitCost").val();
		var bigGroup = $("#bigGroup").val();
		var middleGroup = $("#middleGroup").val();
		var smallGroup = $("#smallGroup").val();
		var comment1 = $("#comment1").val();
		var comment = $("input[name='comment']").val();
		var transactionMoney = $("#transactionMoney").val();
		var transactionDate = formatDate($("#transactionDate").val());
		
		if ((profitCost === null || profitCost === "") || 
			    (bigGroup === null || bigGroup === "") ||
			    (middleGroup === null || middleGroup === "") ||
			    (comment === null || comment === "") || // Check for null or empty string
			    isNaN(transactionMoney) || 
			    (transactionDate === null || transactionDate === "")
			) {
			    alert("비용, 관, 항, 비용 상세, 금액, 거래 일자는 필수로 넣어주세요!");
			    return;
			}
		if (comment !== $.trim($("#comment").val())) {
	            alert("상세 비용에 공백이 있습니다.");
	            return;
	        }
		
		saveFormData(profitCost, bigGroup, middleGroup, smallGroup, comment1, comment, transactionMoney, transactionDate);
	});


	function saveFormData(profitCost, bigGroup, middleGroup, smallGroup, comment1, comment, transactionMoney, transactionDate) {
		var userName = $("#userName").val();
		var formData = {
			accountSeq: accountSeq,
			userName: userName,
			profitCost: profitCost,
			bigGroup: bigGroup,
			middleGroup: middleGroup,
			smallGroup: smallGroup,
			comment1: comment1,
			comment: comment,
			transactionMoney: transactionMoney,
			transactionDate: transactionDate
		};
		
		console.log("forData" + formData);
		
		$.ajax({
		    url: '/account/accountModify.do',
		    type: 'POST',
		    contentType: 'application/json; charset=UTF-8',
		    data: JSON.stringify(formData),
		    success: function(data) {
		    	if (data === 1) { 
                    alert('수정 되었습니다');
                    window.location.href = '/account/accountList.do';
                } else {
                    alert('수정 실패');
                }
		    },
		    error: function(error) {
		        alert("시스템 오류");
		        // 오류 처리 코드
		    }
		});

		
	}
});
</script>
<script>
    // JavaScript 함수 정의
    function redirectToAccountList() {
        // 원하는 URL로 이동합니다. 여기서는 /account/accountList.do로 이동하도록 설정했습니다.
        window.location.href = "/account/accountList.do";
    }
</script>
<!-- 비용 START -->
<div class="container" style="margin-top: 50px">
	<div class="col-sm-12">
		<label for="disabledInput" class="col-sm-12 control-label"></label>
	</div>
	<div class="col-sm-12">
		<label for="disabledInput" class="col-sm-12 control-label"></label>
	</div>
	<div class="col-sm-12">
		<label for="disabledInput" class="col-sm-12 control-label"></label>
	</div>
	<div class="col-sm-12">
		<label for="disabledInput" class="col-sm-12 control-label"></label>
	</div>

	<div class="col-sm-11" id="costDiv">
		<div>
			<div class="col-sm-11">
				<div class="col-sm-12">
					<div class="col-sm-3">
						<select class="form-control" id="profitCost" name="profitCost"
							title="비용">
							<c:forEach var="list" items="${resultMap}" varStatus="cnt">
								<option value="${list.code}">${list.comKor}</option>
							</c:forEach>
						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control" id="bigGroup" name="bigGroup"
							title="관">

						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control " id="middleGroup" name="middleGroup"
							title="항">

						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control " id="smallGroup" name="smallGroup"
							title="목">
						</select>
					</div>
				</div>

				<div class="col-sm-12">
					<label for="disabledInput" class="col-sm-12 control-label">
					</label>
				</div>
				<div class="col-sm-12">
					<div class="col-sm-3">
						<select class="form-control " id="comment1" name="comment1"
							title="과">
						</select>
					</div>
					<div class="col-sm-9">
						<input class="form-control " id="comment" name="comment" type="text" value="${inOutMap.comments}"
							placeholder="비용 상세 입력" title="비용 상세">
					</div>
				</div>

				<div class="col-sm-12">
					<label for="disabledInput" class="col-sm-12 control-label"></label>
				</div>
				<div class="col-sm-12">  
					<label for="disabledInput" class="col-sm-12 control-label"> </label>
				</div>
		 		<div class="col-sm-12">
		 			<label for="disabledInput" class="col-sm-1 control-label"><font size="1px">금액</font></label>
			    	<div class="col-sm-3">
			        	<input class="form-control" id="transactionMoney" name="transactionMoney"  value="0" title="금액">
			 	    </div>
			 		<label for="disabledInput" class="col-sm-1 control-label"><font size="1px">거래일자</font></label>
				    <div class="col-sm-3">
				    	<input class="form-control datepicker" id="transactionDate" name="transactionDate" type="text" value="${inOutMap.transactionDate}" style="width: 80%" title="거래일자">
				    </div>
		 		</div>
	
				<div class="col-sm-12"></div>
				<div class="col-sm-12"></div>
			</div>
					<button id="edtBtn">
						<label for="disabledInput" class="col-sm-12 control-label">수정</label>
					</button>
					<button id="cencel" onclick="redirectToAccountList()">
						<label for="disabledInput" class="col-sm-12 control-label" >취소</label>
					</button>
		</div>
	</div>
</div>

<!-- 비용 END -->