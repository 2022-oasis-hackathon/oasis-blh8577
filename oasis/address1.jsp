<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<!-- jquery 사용 -->
<script src="./jquery.js"></script> 
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<form action="./address2" method="post">
		<table>
		
			<tr>
				<td>도착지 주소</td>
				<td><input type="text" name="destination" id="address1"></td>
				<td><button type="button" id="searchBtn">검색</button></td>
			</tr>
			<tr>
				<td>상세 주소</td>
				<td><input type="text" name="details_destination"></td>
				<td></td>
			</tr>
		</table>
		<input type="submit" value="send">
		</form>
		
		<div id="map" style="width:100%;height:350px;"></div>
   
	<!-- kakao API -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=	2401d2f452bb0400c1c01728cb403312&libraries=services"></script>
	<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  
	
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	
	var markers = [];
	var infowindows = [];
	
	// 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
	function setMarkers(map) {
	    for (var i = 0; i < markers.length; i++) {
	        markers[i].setMap(map);
	        infowindows[i].close();
	    }            
	}
	
	if (navigator.geolocation) {
	    
	    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
	    navigator.geolocation.getCurrentPosition(function(position) {
	        
	        var lat = position.coords.latitude, // 위도
	            lon = position.coords.longitude; // 경도
	        
	        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
	            message = '<div style="padding:5px;">현재위치</div>'; // 인포윈도우에 표시될 내용입니다
	        
	            
	        getAddr(lat,lon);
	        function getAddr(lat,lon){
	            let geocoder = new kakao.maps.services.Geocoder();

	            let coord = new kakao.maps.LatLng(lat, lon);
	            let callback = function(result, status) {
	                if (status === kakao.maps.services.Status.OK) {
	                    $('#address1').val(result[0].road_address.address_name);
	                    
	                    
	                    
	                }
	            }
	            geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
	        }
	            
	        // 마커와 인포윈도우를 표시합니다
	        displayMarker(locPosition, message);
	            
	      });
	    
	} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
	    
	    var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
	        message = 'geolocation을 사용할수 없어요..'
	        
	    displayMarker(locPosition, message);
	}

	// 지도에 마커와 인포윈도우를 표시하는 함수입니다
	function displayMarker(locPosition, message) {

	    // 마커를 생성합니다
	    var marker = new kakao.maps.Marker({  
	        map: map, 
	        position: locPosition
	    }); 
	    
	    
	    var iwContent = message, // 인포윈도우에 표시할 내용
	        iwRemoveable = true;

	    // 인포윈도우를 생성합니다
	    var infowindow = new kakao.maps.InfoWindow({
	        content : iwContent,
	        removable : iwRemoveable
	    });
	    
	    // 인포윈도우를 마커위에 표시합니다 
	    infowindow.open(map, marker);
	    
	    markers.push(marker);
	    infowindows.push(infowindow);
	    
	    // 지도 중심좌표를 접속위치로 변경합니다
	    map.setCenter(locPosition);      
	}  
	
	
	
	$('#searchBtn').click(function(){
		// 버튼을 click했을때
		
		setMarkers(null);
		
		// 주소로 좌표를 검색합니다
		geocoder.addressSearch($('#address1').val(), function(result, status) {
	
		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {
		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
		        
		        // 추출한 좌표를 통해 도로명 주소 추출
		        let lat = result[0].y;
		        let lng = result[0].x;
		        getAddr(lat,lng);
		        function getAddr(lat,lng){
		            let geocoder = new kakao.maps.services.Geocoder();
	
		            let coord = new kakao.maps.LatLng(lat, lng);
		            let callback = function(result, status) {
		                if (status === kakao.maps.services.Status.OK) {
		                	// 추출한 도로명 주소를 해당 input의 value값으로 적용
		                    $('#address1').val(result[0].road_address.address_name);
		                }
		            }
		            geocoder.coord2Address(coord.getLng(), coord.getLat(), callback);
		        }
		        

		        displayMarker(coords, '<div style="padding:5px;">현재위치</div>');
		        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
		        map.setCenter(coords);
		    } 
		});  
	});
	  
	</script>
</body>
</html>