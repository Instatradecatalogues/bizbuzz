<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/views/includes/taglibs.jsp"%>

<tiles:insertDefinition name="seller">
	<tiles:putAttribute name="title">
		InstaTrade-Groups
	</tiles:putAttribute>

	<tiles:putAttribute name="customJsCode">
		<script type="text/javascript">
		var debug=false;
		var baseStaticUrl = "/static";
		var contactAndroidObj;
		$(document).ready(function() {
			//call the specific function on document ready
			
			/***************************************************************************************
			* code for mobile devices
			***************************************************************************************/
			var ua = navigator.userAgent.toLowerCase();   
			var isAndroid = ua.indexOf("android") > -1; //&& ua.indexOf("mobile");
			if(isAndroid) {
				if(debug)
					alert("This is android platform.");
			
				$("#phonebookbox").show();
				//As Per Native Code----------------------------------------------------------------
				contactAndroidObj = {
						// Application Constructor
						initialize: function() {
					if(debug)
						alert("Inside contact initialization");
					this.bindEvents();
				},
				bindEvents: function() {
					document.addEventListener('deviceready', this.onDeviceReady(), false);
				},
				onDeviceReady: function() {
					if(debug)
						alert("OnDeviceReady: ");
					var options = new ContactFindOptions();
					if(debug)
						alert("OnDeviceReady: Sending contact request");
					options.filter = "";
					options.multiple = true;
					var filter = ["displayName", "phoneNumber"];
					navigator.contacts.find(filter, this.onSuccess , this.onError , options);
				},
				onSuccess: function(contacts){
					if(debug)
						alert("contact length: " + contacts.length);
					//for (var i = 0; i < contacts.length; i++) {
					//alert("contact:"+contacts[i].displayName);
					var validContacts = [];
					$(contacts).each(function (i) { //populate contact_selection options 
						if(contacts[i].phoneNumbers!=null){
							validContacts.push(contacts[i]);
						}
					});
					validContacts.sort(function(a, b) {
						var aID = a.displayName;
						var bID = b.displayName;
						return (aID == bID) ? 0 : (aID > bID) ? 1 : -1;
					});
			
					$("#contact_selection").html(""); //reset contact_selection options
					var strVar="";
					$(validContacts).each(function (i) { //populate contact_selection options
						strVar += "<div class=\"row list-group-item\" onclick='contactAndroidObj.processContact(this);' >";
						strVar += "	<div class=\"col-xs-8 col-sm-8 col-md-8 col-lg-8\">";
						strVar += 		validContacts[i].displayName+"<\/div>";
						strVar += "	<div class=\"col-xs-4 col-sm-4 col-md-4 col-lg-4\">";
						strVar += 		validContacts[i].phoneNumbers[0].value+"<\/div>";
						strVar += "<\/div>";
					});
					$("#contact_selection").append(strVar);
				},
				onError: function(error){
					if(debug)
						alert("mobileadaptation.js.loadmobileconnectionmodule.Contacts Error : "+error);
					console.log("Contacts Error : "+error);
				},
				processContact: function (event){
					var children = $(event).children();
					if(typeof children !== 'undefined' && children.length==2){
						var number = $(children[1]).html();
						$("#seller_viewconnection_phonenumber").attr("value",number);
						$('#phonebookModal').modal('toggle');
					}
				}
				};
			
				function onCordovaLoad(){
					if(debug)
						alert("cordova Loaded");
					onContactsObjectAvailable();
				}
			
				function onContactsObjectAvailable() {
					if (typeof(ContactFindOptions) !== 'undefined') {
						contactAndroidObj.initialize();
					} else {
						setTimeout(function () {
							onContactsObjectAvailable();
						}, 500);
					}
				}
				
				loadjsfile(baseStaticUrl+"/js/cordova/cordova-combined-<spring:message code="git_hash" />.min.js", onCordovaLoad);
			}
			else{
				$("#phonebookbox").hide();
			}
			
			function loadjsfile(filename, onload){	
				if(debug)
					alert("mobileadaptation.js/loadjsfile:filename->"+filename);
				var script=document.createElement('script');
				script.setAttribute("type","text/javascript");
			
				script.setAttribute("src", filename);
				if (typeof script!="undefined")
					document.getElementsByTagName("head")[0].appendChild(script);
			
				if (script.readyState){  //IE
					script.onreadystatechange = function(){
						if (script.readyState == "loaded" || script.readyState == "complete"){
							script.onreadystatechange = null;
							//do your stuff
						}
					};
				} else {  //Others
					script.onload = onload;
				}
			}			

			/***************************************************************************************
			* code for mobile devices ends
			***************************************************************************************/

			$('#seller_viewconnection_form').submit(function(event) {
				var json = { "userId" : $('#seller_viewconnection_phonenumber').val(),
						"groupId" : $('#seller_viewconnection_privategroupoption').val()
				};
				console.log("test", JSON.stringify(json));
				$.ajax({
					url: $("#seller_viewconnection_form").attr( "action"),
					data: JSON.stringify(json),
					type: "POST",
		
					beforeSend: function(xhr) {
					xhr.setRequestHeader("Accept", "application/json");
					xhr.setRequestHeader("Content-Type", "application/json");
				},
				success: function(data) {
					var baseUrl = "/seller/viewconnection/";
					var baseDeleteUrl = "/seller/deleteconnection/";
					var baseGroupUrl = "/seller/viewgroup/";
					var respContent="";
		
					var linkElement = document.createElement('a');
					$(linkElement).addClass("list-group-item");
					$(linkElement).attr("href", "<c:url value='/seller/viewconnection/'/>"+data.id);
					var divOut = document.createElement('div');
					$(divOut).addClass('row');
					var divInner = document.createElement('div');
					$(divInner).addClass('col-xs-4 col-sm-4 col-md-4 col-lg-4');
					$(divInner).html(data.firstName + " " + data.middleName + " " + data.lastName);
					$(divOut).append(divInner);
		
					var divInner = document.createElement('div');
					$(divInner).addClass('col-xs-4 col-sm-4 col-md-4 col-lg-4');
					$(divInner).html(data.phoneNumber);
					$(divOut).append(divInner);
		
					var divInner = document.createElement('div');
					$(divInner).addClass('col-xs-4 col-sm-4 col-md-4 col-lg-4');
					$(divInner).html(data.groupName);
					$(divOut).append(divInner);
		
					$(linkElement).append(divOut);
		
					$(linkElement).insertAfter($(".list-group-item").filter(".heading").first());
					$(".loader").remove();
				},
				error: function(){
					$(".loader").remove();
				}
				}); 
				event.preventDefault();
			});
		});
		</script>
	</tiles:putAttribute>

	<tiles:putAttribute name="body">
		<c:url var="post_url" value="/seller/addconnection" />
		<c:url var="base_delete_url" value="/seller/deleteconnection/" />
		<c:url var="base_url" value="/seller/viewconnection/" />
		<c:url var="base_group_url" value="/seller/viewgroup/" />

		<div class="container" role="main">
			<div class="row" id="maincontent">
				<div class="hidden-xs hidden-sm col-md-1 col-lg-2"></div>
				<div class="col-xs-12 col-sm-12 col-md-10 col-lg-8">
					<div class="panel panel-primary">
						<div class="panel-heading center-align-text">Connections</div>
						<div class="panel-body">
							<legend>Add new connection</legend>
							<form method="POST" role="form" class="form-signin"
								action="${post_url}" id="seller_viewconnection_form"
								class="form">
								<label for="seller_viewconnection_phonenumber">Phonenumber
									of the person</label> <input class="form-control"
									id="seller_viewconnection_phonenumber" type="text" value="+91"
									placeholder="" />
								<div id="phonebookbox">
									<div style="text-align:center">OR</div>
									<br/>
									<input id="phonebook_button" type="button" data-toggle="modal"
										data-target="#phonebookModal" class="btn btn-primary btn-block" value="Select from Phonebook" />
								</div>

								<label for="seller_viewconnection_groupname">Group Name</label>
								<select class="form-control"
									id="seller_viewconnection_privategroupoption">

									<c:forEach var="item" items="${privateGroupList}">
										<option value="${item.id}"
											<c:if test="${item.privateGroupName == 'General' }">
											selected="true" 
										</c:if>>${item.privateGroupName}</option>
									</c:forEach>
								</select> <input id="seller_viewconnection_connect" type="submit"
									class="btn btn-primary btn-block" value="Connect" /> <br />

							</form>
							<br />
							<div class="list-group">
								<a href="#" class="list-group-item active">
									<h4 class="list-group-item-heading">Existing Connections</h4>
								</a> <a href="#" class="list-group-item heading">
									<div class="row">
										<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
											<h4 class="list-group-item-heading">Name</h4>
										</div>
										<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
											<h4 class="list-group-item-heading">Phone Number</h4>
										</div>
										<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
											<h4 class="list-group-item-heading">Group</h4>
										</div>
									</div>
								</a>
								<c:forEach items="${connectionList}" var="item">
									<a href="${base_url}${item.toParty.id}" class="list-group-item">
										<div class="row">
											<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
												${item.toParty.firstName} ${item.toParty.middleName}
												${item.toParty.lastName}</div>
											<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
												${item.toParty.userId.id}</div>
											<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
												${item.fromParty.privateGroupName }</div>
										</div>
									</a>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
				<div class="hidden-xs hidden-sm col-md-1 col-lg-2"></div>
			</div>
		</div>
		<div class="modal fade" id="phonebookModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Select Contact</h4>
					</div>
					<div class="modal-body">
						<div id="contact_selection">
						</div>
					</div>
				</div>
				<!-- /.modal-content -->
			</div>
			<!-- /.modal -->
		</div>
	</tiles:putAttribute>
</tiles:insertDefinition>