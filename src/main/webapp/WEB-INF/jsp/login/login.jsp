<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	// 1. 로그인 상태 확인
	String userId = (String) session.getAttribute("userId");
	if (userId != null) {

		response.sendRedirect("/login/notSessionPage.jsp");
		return;
	}
%>
<script type="text/javascript">
$(document).ready(function () {
    $('#login-btn').click(function() {
        var userId = $('#memId').val(); // ID 입력 필드의 ID를 수정
        var password = $('#memPassword').val();
        
        if (!userId || !password) {
            alert('ID와 비밀번호를 입력해주세요');
            return; // 로그인 요청을 보내지 않음
        }
        
        $.ajax({
            type: "POST",
            url: "/login/login.do", // 로그인을 처리하는 URL로 수정
            data: {
                memId: userId,
                pwd: password
            },
            dataType: "text",
            success: function(data) {
                if (data === "true") { 
                    alert('로그인 되었습니다');
                    window.location.href = '/account/accountList.do';
                } else {
                    alert('로그인 실패 ');
                    
                }
            },
            error: function() {
                alert("서버 오류가 발생했습니다");
            }
        });
    });
});
</script>
<script type="text/javascript">

</script>
<form id="sendForm">
	<input type="hidden" id="platform" name="platform" value="">
	<div class="container col-md-offset-2 col-sm-6" style="margin-top: 100px;">
		<div class="input-group">
			<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
			<input id="memId" type="text" class="form-control valiChk" name="memId"
				placeholder="id" title="ID">
		</div>
		<div class="input-group">
			<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
			<input id="memPassword" type="password" class="form-control valiChk"
				name="memPassword" placeholder="Password" title="Password">
		</div>
		<br /> <br>
		<div class="col-md-offset-4">
			<button type="button" id="login-btn" class="btn btn-primary">로그인</button>
			<button type="button" class="btn btn-warning"
				onclick="location.href='/login/login.do'">취소</button>
			<button type="button" class="btn btn-info"
				onclick="location.href='/user/userInsert.do'">회원가입</button>
		</div>
		<div><a href="#none" onclick="kakaoLogin.auth();return false;" class="kakao-login"><img src="//k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg" width="180" alt="카카오 로그인 버튼"/></a></div>
	</div>
</form>

 <div class="wrap-kakao-login">
	
	<h3>인증후 사용자 정보(아이디(고유번호),이메일,닉네임,성별)</h3>
	<ul>
		<li>아이디(고유번호): <input type="text" name="id" value=""></li>
		<li>닉네임: <input type="text" name="nickname" value=""></li>
	</ul>
</div> 

<style>
	 .wrap-kakao-login {
    display: none; /* 해당 요소 숨김 처리 */
  } 
	.kakao-login{ padding:2%; }
</style>
<!-- jquery 라이브러리 : version 2.2.4 -->
<script src="https://code.jquery.com/jquery-2.2.4.min.js" integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44=" crossorigin="anonymous"></script>

<!-- kakao sdk -->
<script src="//developers.kakao.com/sdk/js/kakao.js"></script>

<script type="text/javascript">
	var kakaoLogin = {

		/* 설정 : <수정필요> */
		config : {
			javascriptKey : '#',
			redirectUri : 'http://localhost:8081/account/accountList.do',
			errmsg : new Array('현재 카카오로그인 서비스를 이용할 수 없습니다.','카카오로그인 서비스 인증정보가 올바르지 않습니다.','카카오로그인 정보 호출에 실패하였습니다.','예기치 못한 오류가 발생하였습니다.')
		} ,

		/*초기화*/
		init : function(){
			try{
				var thisEl = this;
				Kakao.init(kakaoLogin.config.javascriptKey);
				if( Kakao.isInitialized() !== true){
					throw thisEl.config.errmsg[0];
				}
			}catch(e){
				return thisEl.debug(e);
			}
		},

		/*로그인인증(팝업)*/
		auth : function(){
			try{
				var thisEl = this;
				Kakao.Auth.login({
					success: function(response) {
						try{
							if(response.access_token) {
								Kakao.Auth.setAccessToken(response.access_token); 
								var accessToken = response.access_token;
								thisEl.getUserInfo();
								
								
							}else{
								throw thisEl.config.errmsg[1];
							}
						}catch(e){return thisEl.debug(e);}

					},
					fail: function(e) {
						return thisEl.debug(e);
					},
				});
			}catch(e){
				return thisEl.debug(e);
			}
		},

		/*로그아웃*/
		logout:function(){
			try{
				if (!Kakao.Auth.getAccessToken()) {
				  alert("로그인중이 아닙니다.");
				  return;
				}
				Kakao.Auth.logout(function() {
					$('input[name="id"]').val('');
					$('input[name="email"]').val('');
				  alert("로그아웃되었습니다.");

				});				
			}catch(e){
				return thisEl.debug(thisEl.errmsg[3]);
			}		
		},

		/*사용자정보가져오기*/
		getUserInfo : function() {
    try {
        var thisEl = this;

        Kakao.Auth.getStatusInfo(({ status }) => {
            try {
                if (status == 'connected') {
                    Kakao.API.request({
                        url: '/v2/user/me',
                        success: function(res) {
                        	if(typeof res.id != 'undefined' && res.id ) $('input[name="id"]').val(res.id);
							if(typeof res.kakao_account.profile.nickname != 'undefined' && res.kakao_account.profile.nickname ) $('input[name="nickname"]').val(res.kakao_account.profile.nickname);
                        	
                                $.ajax({
                                    url: '/login/kakaoLogin.do',
                                    type: 'POST',
                                    data: {
                                        id: res.id,
                                        userName: res.kakao_account.profile.nickname
                                    },
                                    success: function(data) {
                                        if (data === true) {
                                        	
                                            location.href = '/account/accountList.do';
                                        } else {
                                            alert('로그인에 실패하였습니다. 회원 가입을 진행해주세요');
                                            if (confirm('회원 가입을 진행하시겠습니까?')) {
                                            	showPopup();
                                            	}
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        alert('서버 오류가 발생하였습니다.');
                                    }
                                });
                            
                        },
                        fail: function(error) {
                            return thisEl.debug(thisEl.config.errmsg[2]);
                        }
                    });
                } else {
                    return thisEl.debug(thisEl.config.errmsg[2]);
                }
            } catch (e) {
                return thisEl.debug(thisEl.config.errmsg[3]);
            }
        });

    } catch (e) {
        return thisEl.debug(e);
    }
},

		/*디버깅*/
		debug : function(msg){
			try{
				if( typeof msg == 'string'){ alert(msg); }
				else{ console.log(msg); }
			}catch(se){console.log(se);}
			return false;
		}
	}
	
	/*카카오로그인 API 초기화*/
	$(document).ready(function(){
		kakaoLogin.init();
	});

</script>

<script>
function showPopup() {
    // 팝업 창을 띄우는 코드
    var width = 500; // 팝업 창의 너비
    var height = 300; // 팝업 창의 높이
    var left = (screen.width - width) / 2; 
    var top = (screen.height - height) / 2; 

    // 회원가입 폼으로 이동
    var url = '/login/joinKakao.do'; // 회원가입 폼의 URL로 수정
    var popup = window.open(url, "popup", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top);
    var id = $('input[name="id"]').val();
    var nickname = $('input[name="nickname"]').val();
    console.log("id" + id);
    console.log("nickname" + nickname);
    
    
 // 팝업이 열릴 때, 부모 창에서 자식 창(popup)에게 처리 결과를 받을 수 있도록 이벤트 리스너 추가
   if (popup) {
        popup.addEventListener('load', function() {
            popup.document.getElementById("id").value = id;
            popup.document.getElementById("nickname").value = nickname;
        });
   }
}

// 사용자가 회원가입을 클릭할 때 호출되는 함수
function startRegistration() {
    // 아이디(고유번호)와 닉네임을 가져와서 회원가입 폼에 입력
    var id = $('input[name="id"]').val();
    var nickname = $('input[name="nickname"]').val();

    // 회원가입 폼에 입력
    $('#id').val(id);
    $('#nickname').val(nickname);

    // 팝업 창 닫기
    window.close();

    // 회원가입 결과를 부모 창으로 전달
    window.opener.postMessage('success', '*');
}
</script>

