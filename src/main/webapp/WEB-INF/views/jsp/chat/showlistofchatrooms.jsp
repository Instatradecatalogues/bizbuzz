<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/views/includes/taglibs.jsp"%>
<c:url var="static_base_url" value="/static" />

<div class="panel-heading chat-header">
	<span>Chat</span>
	<span class="glyphicon glyphicon-arrow-left pull-right chat-back"></span>
</div>
<div class="panel-body chat-body">
	<c:if test="${!empty sortedchats}">
		<c:set var="totalMessages"  />
		<c:forEach var="chat" items="${sortedchats}" varStatus="i">
		    <c:set var="noOfNewChatsOfChatrooms" />
			<c:url var="post_url"
				value="/chat/showchatroom/chatroomid/${chat.chatRoom.id}" />
			<c:forEach var="chatroomMember" items="${chat.chatRoom.members}">
				<c:if test="${chatroomMember.member.id ne userid}">
					<c:set var="showperson" value="${chatroomMember.member}" />
				</c:if>
			</c:forEach>
  		 <c:if test="${!empty noOfChatsWithPersonIdDTOList}">
		    	      <c:forEach var="noOfChatsWithPersonIdDTO" items="${noOfChatsWithPersonIdDTOList}" >	   
						  <c:if test="${showperson.id == noOfChatsWithPersonIdDTO.personId}">
			           	   <c:set var="noOfNewChatsOfChatrooms" value="${noOfChatsWithPersonIdDTO.noOfNewMessages}" />
		                   </c:if>
			          </c:forEach>
		  </c:if>
			
			<div class="media chat-room-container" 
			   onclick='loadNormalChatRoom("${post_url}")' id="${chat.chatRoom.id}">
				<img class="media-object pull-left"
					src="${static_base_url}/css/images/icons/user.png" height="60"
					width="60" alt="...">

				<div class="media-body chat-room-body">
					<h4 class="media-heading"> ${showperson.firstName} 
						${showperson.middleName} ${showperson.lastName} ${chat.createdAt}  
                       <c:if test="${!empty noOfNewChatsOfChatrooms}" >
                         <span class="chat-room-message-notification"> <span id="noOfNewChats">${noOfNewChatsOfChatrooms}</span> new messages</span>
                         <c:set var="totalMessages" value="${totalMessages + noOfNewChatsOfChatrooms}" /> 
                      </c:if>
					</h4>
					<p class="chat-room-first-line">${chat.message}</p>
				</div>
			</div>
		</c:forEach>
		<div id="totalnewchats" style="display: none;">${totalMessages}</div>
	</c:if>
	<c:if test="${!empty sortedChatrooms}">
		<c:forEach var="chatroom" items="${sortedChatrooms}">
			<c:url var="post_url"
				value="/chat/showchatroom/chatroomid/${chatroom.id}" />
			<c:forEach var="chatroomMember" items="${chatroom.members}">
				<c:if test="${chatroomMember.member.id ne userid}">
					<c:set var="showperson" value="${chatroomMember.member}" />
				</c:if>
			</c:forEach>
			<div class="media chat-room-container"
				onclick="loadNormalChatRoom('${post_url}')" id="${chat.chatRoom.id}">
				<img class="media-object pull-left"
					src="${static_base_url}/css/images/icons/user.png" height="60"
					width="60" alt="...">

				<div class="media-body chat-room-body">
					<h4 class="media-heading">${showperson.firstName}
						${showperson.middleName} ${showperson.lastName} ${chat.createdAt}</h4>
					<p class="chat-room-first-line">No conversation yet</p>
				</div>
			</div>
		</c:forEach>
	</c:if>
	<script type="text/javascript">
		$(document).ready(function(){
			changeState('<%= session.getAttribute("chatpage") %>',0);
			
			setChatPanelToggleCallback();
			setChatBackButtonCallback();
			setChatPanelResizeCallback();
		});
	</script>
</div>