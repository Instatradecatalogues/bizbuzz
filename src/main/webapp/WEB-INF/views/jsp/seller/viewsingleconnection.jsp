<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/views/includes/taglibs.jsp"%>

<tiles:insertDefinition name="seller">
	<tiles:putAttribute name="title">
		InstaTrade-Groups
	</tiles:putAttribute>

	<tiles:putAttribute name="customJsCode">
		<script type="text/javascript">
			$(document).ready(function() {
			  $('#seller_viewsingleconnection_editgroupform').submit(function(event) {
			  	var json = { "personId" : ${buyer.id},
			  				 "groupId" : $('#seller_viewsingleconnection_changegroupoption').val()
			  				};
			    console.log("test", JSON.stringify(json));
			    $.ajax({
			        url: $("#seller_viewsingleconnection_editgroupform").attr( "action"),
			        data: JSON.stringify(json),
			        type: "POST",
			         
			        beforeSend: function(xhr) {
			            xhr.setRequestHeader("Accept", "application/json");
			            xhr.setRequestHeader("Content-Type", "application/json");
			        },
			        success: function(data) {
			        	$(".loader").remove();
			        	$("#editModal").modal('hide');
			        	$("#groupName a").html(data.groupName);
			        	var base_group_url = "<c:url value='/seller/viewgroup/' />";
			        	$("#groupName a").attr("href", base_group_url+data.groupId);
			        },
			        failure: function(){
			        	$(".loader").remove();
			        	$("#editModal").modal('hide');
			        }
			    }); 
			    event.preventDefault();
			  });
			});
		</script>
	</tiles:putAttribute>

	<tiles:putAttribute name="body">
		<c:url var="base_delete_url" value="/seller/deleteconnection/" />
		<c:url var="base_group_url" value="/seller/viewgroup/" />
		<c:url var="edit_group_url" value="/seller/editconnection/changegroup" />
		<div class="container" role="main">
			<div class="row" id="maincontent">
				<div class="hidden-xs hidden-sm col-md-1 col-lg-2"></div>
				<div class="col-xs-12 col-sm-12 col-md-10 col-lg-8">
					<div class="panel panel-primary">
						<div class="panel-heading center-align-text">${buyer.firstName}
							${buyer.middleName} ${buyer.lastName}</div>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-striped">
									<caption>
										<strong>Connection Details</strong>
									</caption>
									<tr>
										<td>Name</td>
										<td>${buyer.firstName}${buyer.middleName}
											${buyer.lastName}</td>
									</tr>
									<tr>
										<td>Group</td>
										<td id="groupName"><a href="${base_group_url}${privateGroup.id}">${privateGroup.privateGroupName}</a></td>
									</tr>
								</table>
							</div>
							<div class="row">
								<div class="col-xs-12 col-xm-12 col-md-12 col-lg-12">
									<button class="btn btn-primary btn-block" data-toggle="modal"
										data-target="#editModal">Edit Connection</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="hidden-xs hidden-sm col-md-1 col-lg-2"></div>
			</div>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="editModal" tabindex="-1" role="dialog"
			aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">Edit Connection</h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6"></div>
							<div class="col-xs-6 col-sm-6 col-md-6 col-lg-6"></div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">

								<a href="${base_delete_url}${buyer.id}">
									<button class="btn btn-primary btn-block" id="deleteConnection">
										Delete Connection</button>
								</a>
							</div>
						</div>
						<br />
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
								<legend>Edit Group</legend>
								<form role="form" method="POST" class="form-signin"
									action="${edit_group_url}"
									id="seller_viewsingleconnection_editgroupform" class="form">
									<select class="form-control"
										id="seller_viewsingleconnection_changegroupoption">
										<c:forEach var="item" items="${privateGroupList}">
											<option value="${item.id}"
												<c:if test="${item.privateGroupName == 'General' }">
												selected="true" 
											</c:if>>${item.privateGroupName}</option>
										</c:forEach>
									</select> <input class="btn btn-primary btn-block" type="submit"
										id="seller_viewsingleconnection_submiteditgroup"
										value="Change Group" />
								</form>
							</div>
						</div>
					</div>
				</div>
				<!-- /.modal-content -->
			</div>
			<!-- /.modal -->
		</div>
	</tiles:putAttribute>
</tiles:insertDefinition>