<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Page Title</title>
<!-- Include jQuery -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">
$(document).ready(function () {
	
    var isIdAvailable = false;
    
    $("#memId").on("input", function () {
        isIdAvailable = false; // 아이디가 변경되면 다시 중복 검사를 진행해야 하므로 isIdAvailable을 false로 설정
        $("#saveBtn").prop("disabled", true); // 아이디가 변경되면 저장 버튼을 비활성화
    });
    
    $("#idcked").click(function () {
        var userId = $("#memId").val();
        if (!userId || userId.length < 6) {
            alert("ID는 6글자 이상이어야 합니다.");
            return;
        }
        
        if (userId !== $.trim($("#memId").val())) {
            alert("아이디 공백이 있습니다.");
            return;
        }   
        if (userId !== $("#memId").val().replace(/\s/g, '')) {
            alert("중간에 공백이 있습니다.");
            return;
        }
        
        $.ajax({
            url: "/user/checkUserIdAvailability.do",
            type: "POST",
            data: { memId: userId },
            success: function (data) { 
                console.log(data.result);
                if (data.result === 1) {
                    alert("다른 아이디로 작성해주세요 !");
                    isIdAvailable = false;
                } else {
                    alert("가능합니다!");
                    isIdAvailable = true;
                    $("#saveBtn").prop("disabled", false);
                }
            },
            error: function () {
                alert("서버 오류가 발생했습니다.");
            }
        });
    });
    
	
    $("#saveBtn").click(function () {
        var userId = $("#memId").val();
        var password = $("#pwd").val();
        var pwdCheck = $("#pwdck").val();
        var userName = $("#memName").val();
        var identify = parseInt($("#identify").val());
        var identifyNum = parseInt($("#identifyNum").val());
        var gender = $("#gender").val(); 
        var userEmail1 = $("#userEmail1").val();
        var userEmail2 = $("#userEmail2").val();
        var zipCode = parseInt($("#zipCode").val()); // 수정: parseInt 제거
        var address = $("#adress").val(); // 수정: 변수명 수정
        var addressDetail = $("#adressDetail").val();
        var phoneNum =  $('#phone1').val() + $('#phone2').val() + $('#phone3').val();
        // ID와 패스워드 유효성 검사
        
        if (!userId || !password || !pwdCheck || !userName || !identify || !identifyNum || !zipCode
            || !gender  || !address || !addressDetail ) { 
            alert("모든 값을 입력하세요.");
            return;
        }
        
        // 모든 입력 필드에 대한 공백 검사 추가
        if (userId !== $.trim($("#memId").val()) || 
            password !== $.trim($("#pwd").val()) || 
            userName !== $.trim($("#memName").val()) 
        ) {
            alert("저장중 공백이 있습니다.");
            return;
        }
        if (userId !== $("#memId").val().replace(/\s/g, '') || 
                password !== $("#pwd").val().replace(/\s/g, '') || 
                userName !== $("#memName").val().replace(/\s/g, '') 
                
        ) {
                alert("중간에 공백이 있습니다.");
                return;
            }
        
        if (!userId) {
            alert("ID를 입력하세요.");
            $("#saveBtn").prop("disabled", true);
            return;
        }
        
        if (!phone1 || !phone2 || !phone3) {
            alert("핸드폰번호를 입력하세요.");
            $("#saveBtn").prop("disabled", true);
            return;
        }
        

        if (!isValidPassword(password)) {
            alert("패스워드는 6자리에서 12자리 사이의 영문, 숫자, 특수문자 조합이어야 합니다.");
            return;
        }
        
        if (!userId || userId.length < 6) {
            alert("ID는 6글자 이상이어야 합니다.");
            return;
        }
		
        
        // 서버로 사용자 정보 저장 요청 (예: /saveUser.do 경로)
        
        $.ajax({
            type: "POST",
            url: "/user/userInsertProcess.do",
            data: {
                memId: userId,
                pwd: password, // 수정: 변수 사용
                memName: userName,
                identify: identify, // 수정: 변수명 수정
                identifyNum: identifyNum, // 수정: 변수명 수정
                gender: gender, // 수정: 변수명 수정
                userEmail: userEmail1 + userEmail2, // 수정: 변수명 수정
                zipCode: zipCode, // 수정: 변수명 수정
                address: address, // 수정: 변수명 수정
                addressDetail: addressDetail, 
                phoneNum: phoneNum 
            },
            success: function (data) {
                // 등록 완료 후 필요한 작업 수행
                alert("사용자 등록이 완료되었습니다.");
                window.location.href = '/login/login.do';
            },
            error: function () {
                alert("서버 오류가 발생했습니다.");
            }
        });
    });

    function isValidPassword(password) {
        var regex = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,12}$/;
        return regex.test(password);
    }
    
});

</script>
<script type="text/javascript">
<!-- 주소 //-->
var isadressAvailable = false;

$("#adress").on("input", function () {
	isadressAvailable = false; // 아이디가 변경되면 다시 중복 검사를 진행해야 하므로 isIdAvailable을 false로 설정
    $("#saveBtn").prop("disabled", true); // 아이디가 변경되면 저장 버튼을 비활성화
});

if($("#adress").val() != null || $("#adress").val() != "" ){
	isadressAvailable = true; // 아이디가 변경되면 다시 중복 검사를 진행해야 하므로 isIdAvailable을 false로 설정
    $("#saveBtn").prop("disabled", false); // 아이디가 변경되면 저장 버튼을 비활성화
}

function exePost() {
     new daum.Postcode({
       oncomplete: function(data) {
          // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

          // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
          // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
          var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
          var extraRoadAddr = ''; // 도로명 조합형 주소 변수

          // 법정동명이 있을 경우 추가한다. (법정리는 제외)
          // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
          if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
              extraRoadAddr += data.bname;
          }
          // 건물명이 있고, 공동주택일 경우 추가한다.
          if(data.buildingName !== '' && data.apartment === 'Y'){
             extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
          if(extraRoadAddr !== ''){
              extraRoadAddr = ' (' + extraRoadAddr + ')';
          }
          // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
          if(fullRoadAddr !== ''){
              fullRoadAddr += extraRoadAddr;
          }

          // 우편번호와 주소 정보를 해당 필드에 넣는다.
          console.log(data.zonecode);
          console.log(fullRoadAddr);
          console.log(fullRoadAddr);
          
          //바꿔줘야 하는 부분~
          $("[name=m_address_postcode]").val(data.zonecode);
          $("[name=m_address_primary]").val(fullRoadAddr);
          
          /* document.getElementById('signUpUserPostNo').value = data.zonecode; //5자리 새우편번호 사용
          document.getElementById('signUpUserCompanyAddress').value = fullRoadAddr;
          document.getElementById('signUpUserCompanyAddressDetail').value = data.jibunAddress; */
      }
   }).open();
}
</script>
<script  type="text/javascript">
var isidentifyNumAvailable = false;

$("#identifyNum").on("input", function () {
	isidentifyNumAvailable = false; 
    $("#saveBtn").prop("disabled", true); 
});

if($("#identifyNum").val() != null || $("#identifyNum").val() != "" ){
	isidentifyNumAvailable = true; 
    $("#saveBtn").prop("disabled", false); 
}

    function validate() {
        var re = /^[a-zA-Z0-9]{4,12}$/ 
        var re2 = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

        var num1 = document.getElementById("identify");
        var num2 = document.getElementById("identifyNum");
        var gender = document.getElementById("gender");
		
        var arrNum1 = new Array(); // 주민번호 앞자리숫자 6개를 담을 배열
        var arrNum2 = new Array(); // 주민번호 뒷자리숫자 7개를 담을 배열

        // -------------- 주민번호 -------------

        for (var i=0; i<num1.value.length; i++) {
            arrNum1[i] = num1.value.charAt(i);
        } // 주민번호 앞자리를 배열에 순서대로 담는다.

        for (var i=0; i<num2.value.length; i++) {
            arrNum2[i] = num2.value.charAt(i);
        } // 주민번호 뒷자리를 배열에 순서대로 담는다.

        var tempSum=0;

        for (var i=0; i<num1.value.length; i++) {
            tempSum += arrNum1[i] * (2+i);
        } // 주민번호 검사방법을 적용하여 앞 번호를 모두 계산하여 더함

        for (var i=0; i<num2.value.length-1; i++) {
            if(i>=2) {
                tempSum += arrNum2[i] * i;
            }
            else {
                tempSum += arrNum2[i] * (8+i);
            }
        } // 같은방식으로 앞 번호 계산한것의 합에 뒷번호 계산한것을 모두 더함

        if((11-(tempSum%11))%10!=arrNum2[6]) {
            alert("올바른 주민번호가 아닙니다.");
            num1.value = "";
            num2.value = "";
            num1.focus();
            return false;
        } else {
            alert("올바른 주민등록번호 입니다.");
            
            // 주민번호 뒷자리를 확인하여 성별 설정
            var identifyNum = parseInt(num2.value.charAt(0));
            if (identifyNum === 1 || identifyNum === 3) {
            	gender.value = "남자";
            } else if (identifyNum === 2 || identifyNum === 4) {
            	gender.value = "여자";
            }
        }
    }
</script>

<script type="text/javascript">

$(document).ready(function () {
var isemailAvailable = false;

$("#userEmail1").on("input", function () {
	isemailAvailable = false; 
    $("#saveBtn").prop("disabled", true); 
});

if($("#userEmail1").val() != null || $("#userEmail1").val() != "" ){
	isemailAvailable = true; 
    $("#saveBtn").prop("disabled", false); 
}
	$('#mail-Check-Btn').click(function() {
		
		var  email1 = $('#userEmail1').val();
		var  email2 = $('#userEmail2').val();
		
		if (!email1) { 
            alert("이메일을 입력하세요.");
            return;
        }
		
		const eamil = email1 + email2; // 이메일 주소값 얻어오기!
		console.log('완성된 이메일 : ' + eamil); // 이메일 오는지 확인
		
		const checkInput = $('.mail-check-box') // 인증번호 입력하는곳 
		
		$.ajax({
			type : 'get',
			url : '<c:url value ="/user/mailCheck.do?email="/>'+eamil, // GET방식이라 Url 뒤에 email을 뭍힐수있다.
			success : function (data) {
				console.log("data : " +  data);
				checkInput.attr('disabled',false);
				code =data;
				alert('인증번호가 전송되었습니다.')
			}			
		}); // end ajax
	}); // end send eamil
	
	// 인증번호 비교 
	// blur -> focus가 벗어나는 경우 발생
	$('.mail-check-box').blur(function () {
		
		const inputCode = $(this).val();
		const $resultMsg = $('#mail-check-warn');
		
		if(inputCode === code){
			$resultMsg.html('인증번호가 일치합니다.');
			$resultMsg.css('color','green');
			$('#mail-Check-Btn').attr('disabled',true);
			$('#userEamil1').attr('readonly',true);
			$('#userEamil2').attr('readonly',true);
			$('#userEmail2').attr('onFocus', 'this.initialSelect = this.selectedIndex');
	        $('#userEmail2').attr('onChange', 'this.selectedIndex = this.initialSelect');
	        isemailAvailable = true; 
	        $("#saveBtn").prop("disabled", false); 
		}else{
			$resultMsg.html('인증번호가 불일치 합니다. 다시 확인해주세요!.');
			$resultMsg.css('color','red');
		}
	});
});
</script>
<script type="text/javascript">
var $validateNum;
var $checkValidate = false;
 
$(document).ready(function(){
	var isephoneAvailable = false;

	$("#phone2").on("input", function () {
		isephoneAvailable = false; 
	    $("#saveBtn").prop("disabled", true); 
	});
	
	$("#phone3").on("input", function () {
		isephoneAvailable = false; 
	    $("#saveBtn").prop("disabled", true); 
	});

	if($("#phone2").val() != null || $("#phone2").val() != "" ){
		isephoneAvailable = false; 
	    $("#saveBtn").prop("disabled", true); 
	}
	
	if($("#phone3").val() != null || $("#phone3").val() != "" ){
		isephoneAvailable = false; 
	    $("#saveBtn").prop("disabled", true); 
	}
	
	
	
    $('#phone-Ck-Msg').click(function(){
    	
    	var phone1 = $('#phone1').val();
    	var phone2 = $('#phone2').val();
    	var phone3 = $('#phone3').val();
    			
    	if (!phone1 || !phone2 || !phone3) { 
                alert("핸드폰 값을 입력하세요.");
                isephoneAvailable = false; 
        	    $("#saveBtn").prop("disabled", true); 
                return;
            }
    	
    	if (phone2.length !== 4 || phone3.length !== 4) {
            alert("핸드폰 전부 입력해주세요.");
            isephoneAvailable = false; 
    	    $("#saveBtn").prop("disabled", true); 
            return;
        }
    	
    	if (phone2 !== $.trim($("#phone2").val()) || 
    			phone3 !== $.trim($("#phone3").val()) 
            ) {
                alert("핸드폰 공백이 있습니다.");
                isephoneAvailable = false; 
        	    $("#saveBtn").prop("disabled", true); 
                return;
            }
    	if (phone2 !== $("#phone2").val().replace(/\s/g, '') || 
    			phone3 !== $("#phone3").val().replace(/\s/g, '')
                
        ) {
                alert("중간에 공백이 있습니다.");
                isephoneAvailable = false; 
        	    $("#saveBtn").prop("disabled", true); 
                return;
            }
    	
    	if (phone1 !== $.trim($("#phone1").val()) || 
    	        phone2 !== $.trim($("#phone2").val()) || 
    	        phone3 !== $.trim($("#phone3").val())
    	    ) {
    	        alert("숫자만 기록해주세요.");
    	        isephoneAvailable = false; 
    		    $("#saveBtn").prop("disabled", true); 
    	        return;
    	    }
    	
        	const phoneNum = (phone1 + phone2 + phone3).replace(/[^0-9]/g, '');
        	
            console.log("완성된 핸드폰 번호 validateNum" + validateNum);
            
            $.ajax({
            	type: 'POST',
            	url: '/user/phoneCheck.do',
                data: {
                    phone: phoneNum
                },
                success: function(data){
            	console.log("전송 성공" + data);
                    alert('인증번호 전송 완료!');
                    $validateNum = data;
                    isephoneAvailable = true; 
                    $("#saveBtn").prop("disabled", false); 
                },
                error: function(){
                    alert('서버 오류!');
                }
            });					
    });

    $('#phone-Ch-Num').click(function()
    {
        var userInput = $("#validateNum").val();
        if ($validateNum === userInput)
        {
            $checkValidate = true; 
            $("#validateMsg").text("인증이 완료되었습니다!");
            $("#validateMsg").css("color", "green");
            $("#validateBtn").prop("disabled", true);
            $("#requestBtn").prop("disabled", true);
            $("#validateBtn").css("background", "gray");
            $("#requestBtn").css("background", "gray");
        }
        else 
        {
            $checkValidate = false;
            $("#validateMsg").text("인증번호가 일치하지 않습니다.");
            $("#validateMsg").css("color", "red");
        }
    });
});
</script>
</head>
<body>
    <div class="container" style="margin-top: 50px">
        <form class="form-horizontal" id="sendForm">
            <div class="form-group">
                <label class="col-sm-2 control-label">ID</label>
                <div class="col-sm-4">
                    <input class="form-control" id="memId" name="memId" type="text" title="ID">
                </div>

                <div class="container">
                    <button type="button" id="idcked" class="btn btn-default"
                        style="display: block;">ID 중복 체크</button>
                </div>

            </div>

            <div class="form-group">
                <label for="pwd" class="col-sm-2 control-label">패스워드</label>
                <div class="col-sm-4">
                    <input class="form-control" id="pwd" name="pwd" type="password"
                        title="패스워드">
                </div>
                <label for="pwdck" class="col-sm-2 control-label">패스워드 확인</label>
                <div class="col-sm-4">
                    <input class="form-control" id="pwdck" name="pwdck" type="password"
                        title="패스워드 확인">
                </div>
            </div>
            
            <div class="form-group">
	      			<label for="disabledInput" class="col-sm-2 control-label">이름</label>
	      		<div class="col-sm-4">
	        		<input class="form-control" id="memName" name="memName" type="text" value="" title="이름" >
	      	</div>
	    	</div>
	    	
            <div class="form-group">
                <label for="identify" class="col-sm-2 control-label">주민번호</label>
                <div class="col-sm-2">
                    <input class="form-control" id="identify" name="identify" type="text" title="주민번호">
                </div>
                <div class="col-sm-2">
                    <input class="form-control" id="identifyNum" name="identifyNum" type="password" title="주민번호 뒷자리">
                </div>
                 <br/>
  					<input type="button" value="검사" style="border-radius:5px; font-s" onclick="validate();" />
            </div>
        
            <div class="form-group">
                <label for="eMail" class="col-sm-2 control-label">성별</label>
                <div class="col-sm-4">
                    <input class="form-control" id="gender" name="gender" type="text" title="성별" readonly>
                </div>
            </div>
            
            <div class="form-group">
   		 <div class="col-sm-4">
        <label for="email" class="col-sm-3 control-label">이메일</label>
        <div class="input-group">
            <input type="text" class="form-control" name="userEmail1" id="userEmail1" placeholder="이메일">
            <select class="form-control" name="userEmail2" id="userEmail2">
                <option>@gmail.com</option>
                <option>@naver.com</option>
                <option>@daum.net</option>
            </select>
        </div>
    </div>
    <div class="col-sm-4">
        <div class="input-group">
            <button type="button" class="btn btn-primary" id="mail-Check-Btn">본인인증</button>
        </div>
    </div>
    <div class="col-sm-4">
        	<div class="mail-check-box">
            	<input class="form-control mail-check-box" placeholder="인증번호 6자리를 입력해주세요!" disabled="disabled" maxlength="6">
            </div>
        
    </div>
    <span id="mail-check-warn"></span>
</div>

            <div class="form-group">
                    <tr>
                    <td><label for="adress" class="col-sm-2 control-label">주소</label></td>
                    <td><input type="text" size="30" id="zipCode" name="m_address_postcode" readonly="readonly" placeholder="우편번호"></td>
                    <td><input type="button" value="주소검색" onclick="exePost()"></td>
                    </tr>
                    <tr>
                    <td></td>
                    <td colspan="2"><input type="text" id="adress" name="m_address_primary" size="50" readonly="readonly" placeholder="기본주소"></td>
        
                    </tr>
    
                    <tr>
                    <td></td><td colspan="2"><input type="text" size="50" name="m_address_detail" id="adressDetail" placeholder="나머지 주소(선택 사항)"></td>
                    </tr>
            </div>
             <div class="form-group">
    		<div class="col-sm-4">
    		<label for="MOD_TEXTFORM_TelField">휴대폰 번호 </label>
    			<input id="phone1" type="tel" name="phone1" size="1" maxlength="3" value=010  readonly="readonly"> 
    			<input id="phone2" type="tel" name="phone2" size="3" maxlength="4" > 
   				<input id="phone3" type="tel" name="phone3" size="3" maxlength="4">
    		<span class="input-phone">
            	<button type="button" class="btn btn-phone" id="phone-Ck-Msg" >본인인증</button>
        	</span>
    		</div>
			<div id="phoneMsg"></div>
    			<div class="col-sm-4">
    			<label for="MOD_TEXTFORM_EmailField">인증번호 </label>
    				<input type="text" name="validateNum" id="validateNum">
    				
    			<span class="input-phone-check">
    				<button type="button" id="phone-Ch-Num" class="btn btn-phoneCk" >인증번호 확인</button>
    			</span>
    			</div>
			<div id="validateMsg"></div>
             </div>
            <div class="col-md-offset-4">
                <button type="button" id="saveBtn" class="btn btn-primary">저장</button>
                <button type="button" id="cancel" class="btn btn-danger" onclick="window.location.href='/login/login.do'">취소</button>
                
            </div>
            
        </form>
    </div>
</body>
</html>
