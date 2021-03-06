var socket;
var pageStat;
var subSocket;
var chatroomid;
var itemid;
var broadcasterIncrement=0;
var totalUnreadChats;
var chatVisible;

function initializeChatPanel(){
	$(".chat-content").height(Math.floor($(window).height()*0.8));
	$(".chat-panel").height(Math.floor($(".chat-content").height()));
	var maxHeight = Math.floor($(".chat-panel").height())-70;
	$(".chat-body").css({"max-height": maxHeight+"px"});
}

function initializeChatPanel(bodyBottomOffset){
	$(".chat-content").height(Math.floor($(window).height()*0.8));
	$(".chat-panel").height(Math.floor($(".chat-content").height()));
	var maxHeight = Math.floor($(".chat-panel").height())-bodyBottomOffset;
	$(".chat-body").css({"max-height": maxHeight+"px"});
}

function changeNameOfChatButtonOnClick(chatVisible){
	if(chatVisible=="true" || chatVisible==true){
		if(itemid==0 || itemid===undefined){
			$( ".chat-toggle-btn" ).text("Hide Chat");		
		}
		else{
			$( ".chat-toggle-btn" ).text("Hide Product Inquiry");
		}	
	}
	else{
		if(itemid==0 || itemid===undefined){
			$( ".chat-toggle-btn" ).text("Show Chat");		
		}
		else{
			$( ".chat-toggle-btn" ).text("Show Product Inquiry");
		}

	}
}
function setChatPanelToggleCallback(){
	$( ".chat-toggle-btn" ).click(function() {
		$( ".chat-content" ).animate({
			height: "toggle"
		}, 200, function() {
			// Animation complete.
			// Send info of chat visibility state
			var url = "/chat/controller";
			var parentObj = $(".chat-panel");
			var isChatPanelVisible = "false";
			if($(".chat-content").length && $(".chat-content").is(":visible")){
				isChatPanelVisible = "true";
			}
			$.ajax({
				url: url,
				type: "GET",
				data: {chatpage: "savevisibilitystate", ischatpanelvisible: isChatPanelVisible},
				success: function(data) {
				},
				error: function(){
				}
			});
			changeNameOfChatButtonOnClick(isChatPanelVisible);
		});
	});
}

function setChatBackButtonCallback(){
	$(".chat-back").click(function(){
		var url = "/chat/controller";
		var parentObj = $(".chat-panel");

		//$(".chat-panel").addClass("div-loader");
		loadDivLoader(parentObj);
		$.ajax({
			url: url,
			type: "GET",
			data: {chatpage: "back"},
			success: function(data) {
				$(".chat-panel").removeClass("div-loader");
				removeChatPanelToggleCallback();
				removeChatBackButtonCallback();
				$(parentObj).children().remove();
				$(parentObj).append(data);
			},
			error: function(){
			}
		});

	});
	totalUnreadChats=Number($("#totalUnreadChats").text());
	if(totalUnreadChats>0){
		$(".badge1").attr("data-badge",totalUnreadChats);
	}
	else{
		$(".badge1").removeAttr("data-badge");
	}

}

function removeChatPanelToggleCallback(){
	$( ".chat-toggle-btn").unbind("click");
}

function removeChatBackButtonCallback(){
	$(".chat-back").unbind("click");
}

/**
 * This function sets ui changes on chat-panel when window is resized
 * @return
 */
function setChatPanelResizeCallback(){
	$(window).resize(function(){
		$(".chat-content").height(Math.floor($(window).height()*0.8));
		$(".chat-panel").height(Math.floor($(".chat-content").height()));
		var maxHeight = Math.floor($(".chat-panel").height())-70;
		$(".chat-body").css({"max-height": maxHeight+"px"});
	});
}

/**
 * This function sets ui changes on chat-panel when window is resized when there is a bottom margin for 
 * chat body. This function is used when there is chat-input-area.
 * @param bodyBottomOffset: How much margin from chat-panel bottom does chat-body ends
 * @return
 */
function setChatPanelResizeCallback(bodyBottomOffset){
	$(window).resize(function(){
		$(".chat-content").height(Math.floor($(window).height()*0.8));
		$(".chat-panel").height(Math.floor($(".chat-content").height()));
		var maxHeight = Math.floor($(".chat-panel").height())-bodyBottomOffset;
		$(".chat-body").css({"max-height": maxHeight+"px"});
	});
}

function removeChatPanelResizeCallback(){
	$(window).unbind("resize");
}

/**
 * 
 * @param isShow: Do we have to make chat-panel visible after loading the current state.
 * @param itemId: If it is item-chat then this parameter contains itemid else undefined.
 * @param secondPersonId: In relevant cases this parameter contains id of the other person in chatroom.
 * @return
 */
function loadCurrentChatRoomState(isShow, itemId, secondPersonId){
	itemid=itemId;
	changeNameOfChatButtonOnClick(isShow);
	var url = "/chat/controller";
	var data;
	if(itemId===undefined){//that means it is in normal chat mode and chatcontroller has to determine the state using session state variables
		data = {chatpage:"determine"};
	}else if(secondPersonId===undefined){//we have to load all chat rooms of that particular item
		data = {chatpage:"itemchatroomlist", itemId:itemId};
	}
	else{//we have to load individual item chat room
		data = {chatpage:"itemchatroom", itemId:itemId, secondPersonId:secondPersonId};
	}
	var parentObj = $(".chat-panel");
	$.ajax({
		url: url,
		type: "GET",
		data: data,
		success: function(data) {
		$(parentObj).append(data);
		if(isShow){
			$(".chat-content").show();
		}
		//		totalUnreadChats=Number($("#totalUnreadChats").text());
		if(totalUnreadChats>0){
			$(".badge1").attr("data-badge",totalUnreadChats);
		}
		else{
			$(".badge1").removeAttr("data-badge");
		}

	},
	error: function(){
	}
	});
}

/**
 * Load all chat rooms of the person.
 * @return
 */
function loadChatRoomList(){
	var url = "/chat/controller";
	var parentObj = $(".chat-panel");
	var params = 'chatpage=listofchatrooms';
	$.ajax({
		url: url,
		type: "GET",
		data: {chatpage: "listofchatrooms"},
		success: function(data) {
			$(parentObj).append(data);
		},
		error: function(){
		}
	});
}

/**
 * Load particular chatroom
 * @param url
 * @return
 */
function loadNormalChatRoom(url){
	var parentObj = $(".chat-panel");
	//$(".chat-panel").addClass("div-loader");
	loadDivLoader(parentObj);
	$.ajax({
		url: url,
		type: "GET",
		success: function(data) {
		$(".chat-panel").removeClass("div-loader");
		removeChatPanelToggleCallback();
		removeChatBackButtonCallback();
		removeChatPanelResizeCallback();
		$(parentObj).children().remove();
		$(parentObj).append(data);
		$(".chat-body").scrollTop(1000000);
	},
	error: function(){
	}
	});
}

/**
 * Load particular item chat room
 * @param chatroomId
 * @param itemId
 * @param fromPage
 * @return
 */
function loadItemChatRoom(chatroomId, itemId, fromPage){
	var parentObj = $(".chat-panel");
	//$(".chat-panel").addClass("div-loader");
	loadDivLoader(parentObj);
	var url = "/chat/showitemchatroom/chatroomid/"+chatroomId+"/itemid/"+itemId+"/frompage/"+fromPage;
	$.ajax({
		url: url,
		type: "GET",
		success: function(data) {
		$(".chat-panel").removeClass("div-loader");
		removeChatPanelToggleCallback();
		removeChatBackButtonCallback();
		removeChatPanelResizeCallback();
		$(parentObj).children().remove();
		$(parentObj).append(data);
		$(".chat-body").scrollTop(1000000);
	},
	error: function(){
	}
	});
}

/**
 * Insert chat message after person enters chat or when chat is received from other person.
 * @param msg
 * @param isSelf
 * @return
 */
function insertChatMessage(msg, isSelf){
	var lines = msg.split("\n");
	var str = "";
	if(isSelf==true){
		str += "<div class=\"ind-chat-panel ind-chat-panel-right\">";
	}
	else{
		str += "<div class=\"ind-chat-panel ind-chat-panel-left\">";
	}
	str += "<div class=\"arrow\"><\/div>";
	str += "<div class=\"ind-chat-body\">";
	str += "<p>";
	for (var i=0; i<lines.length; i++){
		str += "<span>"+lines[i]+"<\/span>";
	}
	str += "<\/p>";
	str += "<\/div>";
	str += "<\/div>";
	$(".chat-body").append(str);
	$(".chat-body").scrollTop(1000000);
}

function changeStateOfPage(stateOfPage,idOfChatroom,idOfItem){
	pageStat=stateOfPage;
	chatroomid=idOfChatroom;
	itemid=idOfItem;
	if(pageStat=='singlechatroom'  ||  pageStat=='singleitemchatroom'){
		$(".chat-body").addClass("chat-body-chatroom");
	}
	else{
		$(".chat-body").removeClass("chat-body-chatroom");
	}
}
function changeTotalNoOfUnreadChats(totalNoOfUnreadMessages){
	totalUnreadChats=totalNoOfUnreadMessages;
	if(totalUnreadChats>0){
		$(".badge1").attr("data-badge",totalUnreadChats);
	}
	else{
		$(".badge1").removeAttr("data-badge");
	}
} 
function showNotificationBox(senderName,itemId){
	setTimeout( function() {
		var message;
		if(itemId==0){
			message='<p>'+senderName+' messages you .</p>'
		}
		else{
			message='<p>'+senderName+' messages you about Product : '+itemId+'.</p>'
		}

		// create the notification
		var notification = new NotificationFx({
			message : message,
			layout : 'growl',
			effect : 'scale',
			type : 'notice', // notice, warning, error or success
			onClose : function() {

		}
		});
		// show the notification
		notification.show();
	}, 200 );
}

/**
 * Initialize the chat room. It can be used for both normal chat room and item chatroom. It initializes the socket.
 * @param socketUrl
 * @param senderId
 * @return
 */

function initializeSocket(socketUrl,senderId){
	socket = $.atmosphere; //global variable
	var request = new $.atmosphere.AtmosphereRequest();        
	request.url = socketUrl;
	request.contentType = "application/json";
	request.transport = 'websocket';
	request.fallbackTransport = 'long-polling';

	console.log("socketUrl : " +socketUrl +"<>senderId : " +senderId);
	/**
	 * When the connection opens for the first time.
	 */
	request.onOpen = function(response){
		console.log('onOpen: connection opened using transport:' + response.transport);	
		if(broadcasterIncrement==0){
			console.log('To Create the broadcaster...');
			setTimeout(function(){
				subSocket.push(JSON.stringify({"message":"0Open0","personId": senderId,"chatroomId":0,"itemId":0}));
			},500);
			broadcasterIncrement=broadcasterIncrement+1;
		}
	}

	request.pollingInterval = '10';

	request.onReconnect = function(request, response){
		console.log('onReconnect:');
		socket.info("Reconnecting");
	}

	request.onClose = function(response) {               
		console.log('onClose ' + response);
	}
	/**
	 * On receiving message from other person
	 */
	request.onMessage = function(response){
		var message = response.responseBody;
		console.log("Message : " +message);
		var result;
		try {
			result =  $.parseJSON(message);
		} catch (e) {
			console.log("An error ocurred while parsing the JSON Data: " + message.data + "; Error: " + e);
			return;
		}
		if(result.senderId==senderId){
		}
		else{
			if(pageStat!='singlechatroom'  &&  pageStat!='singleitemchatroom')
			{
				showNotificationBox(result.senderName,result.itemId);
				totalUnreadChats=totalUnreadChats+1;
				$(".badge1").attr("data-badge",totalUnreadChats);		
				var noOfUnreadChatsOfChatroom = Number($("[id="+result.chatRoomId+"]").find("#noOfUnreadChats").text());	
				if(noOfUnreadChatsOfChatroom==0){
					$("[id="+result.chatRoomId+"]").find("#noOfUnreadChats").css("display","block");
				}  
				$("[id="+result.chatRoomId+"]").find("#noOfUnreadChats").text(noOfUnreadChatsOfChatroom+1);
				$("[id="+result.chatRoomId+"]").find("#latestChat").text(result.message);
				if($("[id="+result.chatRoomId+"]").find("#latestChatDate").text().length==0) {
					$("[id="+result.chatRoomId+"]").find("#latestChatDate").html(result.day+"<sup>th</sup> ");
					$("[id="+result.chatRoomId+"]").find("#latestChatHours").text(result.hour+":");
				}
				else{
					$("[id="+result.chatRoomId+"]").find("#latestChatDate").text(result.day);
					$("[id="+result.chatRoomId+"]").find("#latestChatHours").text(result.hour);
				}
				$("[id="+result.chatRoomId+"]").find("#latestChatMonth").text(result.showMonth);
				$("[id="+result.chatRoomId+"]").find("#latestChatMinutes").text(result.minute);
			}
			else if(chatroomid!=result.chatRoomId){
				showNotificationBox(result.senderName,result.itemId);
				totalUnreadChats=totalUnreadChats+1;
				$(".badge1").attr("data-badge",totalUnreadChats);
			}
			else if(chatroomid==result.chatRoomId && itemid!=0 && itemid!=result.itemId){
				showNotificationBox(result.senderName,result.itemId);
				totalUnreadChats=totalUnreadChats+1;
				$(".badge1").attr("data-badge",totalUnreadChats);
			}
			else if(chatroomid==result.chatRoomId && itemid!=result.itemId){
				loadNormalChatRoom("/chat/showchatroom/chatroomid/"+result.chatRoomId);
			}
			else{
				insertChatMessage(result.message, false);
				$.ajax({
					url: '/chat/updatechatroommember',
					type: "GET",
					data: { "chatRoomId" :result.chatRoomId ,
					"receiverId" : result.receiverId,
					"year" :result.year ,
					"month" : result.month,
					"day" : result.day,
					"hour" : result.hour,
					"minute" :result.minute ,
					"seconds" : result.seconds	     
				},
				success: function(data) {	
					console.log(data);
				}, 
				error: function(){
				}
				});
			}
		}
	}
	request.onError = function(response){
		console.log("An error ocurred in web socket: " + response.responseBody);
		return;
	}
	subSocket = socket.subscribe(request);               //subSocket is used to push messages to the server.

}


function initializeNormalChatRoom(senderId, chatroomId, itemId){
	/*
	if($("#newchats").length>0){		
		if(newChats>=Number($("#newchats").text())){
			newChats=newChats-Number($("#newchats").text());
			alert("After subtract new chats: " +newChats);
		}
	}                          */
	console.log("After starting the socket , OR creating broadcaster");
	var bottomOffset = 100;
	var baseInputHeight = 50;
	initializeChatPanel(bottomOffset);
	setChatPanelResizeCallback(bottomOffset);
	setChatPanelToggleCallback();
	setChatBackButtonCallback();
	$(".chat-body").scrollTop(1000000);

	/****Code for handling variable height for text area***/
	var previouslines = 2;
	var baseMessageFieldHeight;
	var baseMessageButtonHeight;
	//var baseChatInputAreaHeight = baseInputHeight;
	var baseBottomOffset = bottomOffset;
	$("textarea").on("keydown", function(e) {
		/*if ($("textarea").attr("cols")) {
	        var cols = parseInt($("textarea").attr("cols")),
	            curPos = $('textarea').prop("selectionStart"),
	            result = Math.floor(curPos/cols);
	        var msg = (result < 1) ? "Cursor is on the First line!" : "Cursor is on the line #"+(result+1);
	        console.log($("p").text(msg).text());
	    }*/
		if(e.keyCode == '13') {
			sendChatCallback();
			return;
		}

		var lht = parseInt($('textarea').css('lineHeight'),10);		
		var lines = Math.round($('textarea').prop('scrollHeight') / lht);		
		if(!!window.chrome){
			lines = Math.round(($('textarea').prop('scrollHeight') - 26) / lht);
		}
		if(lines==2){
			baseMessageFieldHeight = $("#message-field").height();
			baseMessageButtonHeight = $("#message-button").height();
		}
		if(lines>5){
			lines=2;
		}
		if(lines>previouslines){
			previouslines = lines;
			bottomOffset = bottomOffset+lht;          // .. comment this to avoid scrolling ...
			initializeChatPanel(bottomOffset);
			removeChatPanelResizeCallback();
			setChatPanelResizeCallback(bottomOffset);
			$("#message-field").height($("#message-field").height()+lht);         
			$("#message-button").height($("#message-button").height()+lht);
			//$(".chat-input-area").height($(".chat-input-area").height()+lht);
			$(".chat-body").scrollTop(1000000);
		}
		console.log(lines);
	});

	/****websocket code starts***/
	if (!window.console) {
		console = {log: function() {}};
	}
	function refresh() {
		console.log("Refreshing data tables...");
	}
//	Put the socket initialzing code here ---------------------------------//
	/**
	 * Send the chat.
	 */
	function sendChatCallback(){
		var message = $('#message-field').val();
		var strippedStr = message.trim();
		if(strippedStr == ""){
			console.log('SentMessage: '+'Empty String');
			$('#message-field').val("");
			return;
		}
		console.log('SentMessage:'+message);
		$('#message-field').val("");
		insertChatMessage(message, true);
		if(previouslines>2){
			previouslines = 2;
			bottomOffset = baseBottomOffset;
			initializeChatPanel(bottomOffset);
			removeChatPanelResizeCallback();
			setChatPanelResizeCallback(bottomOffset);
			$("#message-field").height(baseMessageFieldHeight);         
			$("#message-button").height(baseMessageButtonHeight);   

			//$(".chat-input-area").height(baseChatInputAreaHeight);			
		}
		$("#message-field").focus();
		subSocket.push(JSON.stringify({"message":message,"personId": senderId,"chatroomId":chatroomId,"itemId":itemId}));
	}
	$('#message-button').click(function(){
		sendChatCallback();
	});
	//sendChatCallback on pressing enterkey is handled in onkeyup
	/****web socket code ends***/
}
