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
    var userName = '<%=userName%>';
	$(document).ready(
			function() {
				$('#profitCost').change(function() {
					console.log("userName = == = = =", userName)
					var selectedCategory = $(this).val();
					// 1단계 카테고리 업데이트
					updateCategory(selectedCategory, 1);
				});

				$('#bigGroup').change(function() {
					var selectedCategory = $(this).val();

					// 2단계 카테고리 업데이트
					updateCategory(selectedCategory, 2);
					
				});
				
				$('#middleGroup').change(function() {
					var selectedCategory = $(this).val();

					// 3단계 카테고리 업데이트
					updateCategory(selectedCategory, 3);
				});
				
				$('#smallGroup').change(function() {
					var selectedCategory = $(this).val();

					// 4단계 카테고리 업데이트
					updateCategory(selectedCategory, 4);
				});

				function updateCategory(category, level) {
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
    $(document).ready(function() {
		$("#saveBtn").click(function() {
			
			var profitCost = $("#profitCost").val();
			var bigGroup = $("#bigGroup").val();
			var middleGroup = $("#middleGroup").val();
			var smallGroup = $("#smallGroup").val();
			var comment1 = $("#comment1").val();
			var comment = $("input[name='comment']").val();
			var transactionMoney = parseInt($("#transactionMoney").val());
			var transactionDate = $("#transactionDate").val();

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

			$.ajax({
				url: '/account/accountInsert.do',
				type: 'POST',
				contentType: 'application/json; charset=UTF-8',
				data: JSON.stringify(formData),
				success: function(data) {
					console.log("저장: " + data);
					alert("저장완료");
					window.location.href = '/account/accountModify.do?accountSeq='+data;
				/* 	$("#editBtn").show();
					$("#saveBtn").hide(); */
				},
				error: function() {
					alert("오류에용");
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
							<option value="">선택</option>
							<c:forEach var="list" items="${resultMap}" varStatus="cnt">
								<option value="${list.code}">${list.comKor}</option>
							</c:forEach>
						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control" id="bigGroup" name="bigGroup"
							title="관">
							<option value="">선택</option>

						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control " id="middleGroup" name="middleGroup"
							title="항">
							<option value="">선택</option>

						</select>
					</div>

					<div class="col-sm-3">
						<select class="form-control " id="smallGroup" name="smallGroup"
							title="목">
							<option value="">선택</option>
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
							<option value="">선택</option>
						</select>
					</div>
					<div class="col-sm-9">
						<input class="form-control " name="comment" id="comment" type="text" value="" placeholder="비용 상세 입력" title="비용 상세">
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
				    	<input class="form-control datepicker" placeholder="YYYY-MM-DD" id="transactionDate" name="transactionDate" type="text" value="" style="width: 80%" title="거래일자">
				    </div>
		 		</div>
	
				<div class="col-sm-12"></div>
				<div class="col-sm-12"></div>
			</div>
					<button id="saveBtn">
						<label for="disabledInput" class="col-sm-12 control-label">저장</label>
					</button>
					<button id="cencel" onclick="redirectToAccountList()">
						<label for="disabledInput" class="col-sm-12 control-label">취소</label>
					</button>
		</div>
	</div>
</div>

<!-- 비용 END -->