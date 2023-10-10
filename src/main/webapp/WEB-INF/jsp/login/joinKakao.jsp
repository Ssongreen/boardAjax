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

// 부모 창에서 전달된 값 가져오기
var idFromParent = window.opener.document.getElementById("id").value;
var nicknameFromParent = window.opener.document.getElementById("nickname").value;

opener.document.getElementById("id").value = idFromParent;
opener.document.getElementById("nickname").value = nicknameFromParent;

console.log("1111" + document.getElementById("id").value);
console.log("222" + document.getElementById("nickname").value);
// 가져온 값으로 필요한 작업 수행

// 예: 입력 필드에 설정


</script>
<script type="text/javascript">
//카카오 회원가입 정보를 서버에 전송하는 함수

function sendKakaoRegistration() {
 var id = $('input[name="id"]').val();
 var nickname = $('input[name="nickname"]').val();

 // 아이디와 닉네임을 서버로 전송하고 회원가입 처리를 합니다.
 $.ajax({
     type: "POST",
     url: "/login/joinKakao.do", // 회원가입을 처리하는 URL로 수정
     data: {
         id: id,
         nickname: nickname
     },
     dataType: "text",
     success: function(data) {
         if (data === "true") {
             // 회원가입 성공 시 메시지를 표시하고 팝업을 닫습니다.
             alert('회원가입이 완료되었습니다.');
             window.opener.postMessage('success', '*');
             window.close();
         } else {
             // 회원가입 실패 시 메시지를 표시합니다.
             alert('회원가입에 실패하였습니다. 다시 시도해주세요.');
         }
     },
     error: function() {
         // 서버 오류 발생 시 메시지를 표시합니다.
         alert("서버 오류가 발생했습니다");
     }
 });
}

$(document).ready(function() {
 // "회원가입" 버튼 클릭 시 회원가입 함수 호출
 $('#saveBtn').click(function() {
     sendKakaoRegistration();
 });
});
</script>

</head>
<body>
   <div class="wrap-kakao-login">
	<h3>카카오 회원가입</h3>
	<ul>
		<li>아이디(고유번호): <input type="text" id="id" name="id" value="" readonly="readonly"></li>
		<li>닉네임: <input type="text" id="nickname" name="nickname" value="" readonly="readonly"></li>
		<button type="button" id="saveBtn" class="btn btn-primary">회원가입</button>
	</ul>
</div>
</body>
</html>
