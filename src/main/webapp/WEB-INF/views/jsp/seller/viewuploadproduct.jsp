<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ include file="/WEB-INF/views/includes/taglibs.jsp"%>



<tiles:insertDefinition name="seller">
	<tiles:putAttribute name="title">
		BizBuzz-Category
	</tiles:putAttribute>

	<tiles:putAttribute name="customJsCode">
		<script type="text/javascript">
		$(document).ready(function(){
			/*$('#uploadForm').submit(function(event) {
				$.ajax({
				    url: $("#uploadForm").attr( "action"),
				    data: $("#uploadForm").serialize(),
				    type: "POST",
				    dataType: "json", 
				    beforeSend: function(xhr) {
				        xhr.setRequestHeader("Accept", "application/json");
				        xhr.setRequestHeader("Content-Type", "application/json");
				    },
				    success: function(data) {
				        
				        $(".loader").remove();  
				    },
				    error: function(){
				     	$(".loader").remove();
				       }
				}); 
				event.preventDefault();
			});*/
		
		
			function androidLogger(arg){
				$("#maincontent").append("<div>"+arg+"</div>");
			}
			$('.productuploadform').submit(function onsubmit(event){
				$('.imageuploadinput').val('');
			});
			$('.imageuploadinput').change(function onchange(){
				var imageInput = this;
				var max_height = $(this).attr('data-maxheight');
				var max_width = $(this).attr('data-maxwidth');
				if(max_height === undefined){
					max_height = 800;
				}
				if(max_width === undefined){
					max_width = 600;
				}
				var form = $('.productuploadform');
		
				function processfile(file) {
		
					if( !( /image/i ).test( file.type ) )
					{
						alert( "File "+ file.name +" is not an image." );
						return false;
					}
		
					// read the files
					var reader = new FileReader();
					//reader.readAsArrayBuffer(file);
					reader.readAsDataURL(file);
		
					reader.onload = function (event) {
						// blob stuff
						/*var blob = new Blob([event.target.result]); // create blob...	
						window.URL = window.URL || window.webkitURL;
						var blobURL = window.URL.createObjectURL(blob); // and get it's URL
						*/
		
						// helper Image object
						//var image = new Image();
						var image = document.createElement("img");
						//image.src = blobURL;
						image.src = event.target.result;
						//preview.appendChild(image); // preview commented out, I am using the canvas instead
						image.onload = function() {
							// have to wait till it's loaded
							var resized = resizeMe(image); // send it to canvas
							var newinput = document.createElement("input");
							newinput.type = 'hidden';
							var name = $(imageInput).attr("name");
							var nameArray = name.split('[');
							newinput.name = nameArray[0]+"Hidden["+nameArray[1];
							var index = nameArray[1].split(']');
							newinput.id = nameArray[0]+"Hidden_"+index[0];
							newinput.value = resized; // put result from canvas into new hidden input
							$(form).append(newinput);
							//putting image into thumbnail
							$("#thumbnail_"+nameArray[0]+"_"+index[0]).attr("src", resized);
						}
					};
				}
		
				function readfile() {
					var name = $(imageInput).attr("name");
					var nameArray = name.split('[');
					var index = nameArray[1].split(']');
					var prevInput = $("#"+nameArray[0]+"Hidden_"+index[0]);
					if(prevInput !== undefined){
						$(prevInput).remove();
					}
					
					// remove the existing canvases and hidden inputs if user re-selects new pics
					//var existinginputs = document.getElementsByName('images[]');
					//var existinginput = $($(imageInput).attr("name") + "Hidden");
					//var existingcanvases = document.getElementsByTagName('canvas');
					//while (existinginput.length > 0) { // it's a live list so removing the first element each time
						// DOMNode.prototype.remove = function() {this.parentNode.removeChild(this);}
					//	form.removeChild(existinginput);
						//preview.removeChild(existingcanvases[0]);
					//}
		
					processfile(imageInput.files[0]);
		
					//imageInput.value = ""; //remove the original files from fileinput
					// TODO remove the previous hidden inputs if user selects other files
				}
		
		
				function resizeMe(img) {
		
					var canvas = document.createElement('canvas');
		
					var width = img.width;
					var height = img.height;
		
					// calculate the width and height, constraining the proportions
					if (width > height) {
						if (width > max_width) {
							//height *= max_width / width;
							height = Math.round(height *= max_width / width);
							width = max_width;
						}
					} else {
						if (height > max_height) {
							//width *= max_height / height;
							width = Math.round(width *= max_height / height);
							height = max_height;
						}
					}
		
					// resize the canvas and draw the image data into it
					canvas.width = width;
					canvas.height = height;
					var ctx = canvas.getContext("2d");
					ctx.drawImage(img, 0, 0, width, height);
		
					//preview.appendChild(canvas); // do the actual resized preview
		
					return canvas.toDataURL("image/jpeg", 0.7); // get the data from canvas as 70% JPG (can be also PNG, etc.)
		
				}
				readfile();
		
			});
		});
		</script>

	</tiles:putAttribute>

	<tiles:putAttribute name="body">
		<c:url var="form_upload_url"
			value="/seller/uploadproduct/category/${categoryId}" />
		<c:if test="${not empty itemId }">
			<c:url var="form_upload_url"
				value="/seller/uploadproduct/category/${categoryId}/item/${itemId }" />
		</c:if>
		<c:url var="newProductUpload" value="/seller/uploadproduct/category/${categoryId}" />
		<c:url var="base_image_url" value="/${rootDir}" />
		<c:url var="emptyImageUrl"
			value="/${rootDir}/${sizeDir}/noimage.${imageExtn}" />
		<c:set var="value_count" value="0" scope="page" />
		<div class="container" role="main">
			<div class="row" id="maincontent">
				<div class="col-xs-12 col-md-12 col-sm-12 col-lg-12">
					<div class="panel panel-primary">
						<div class="panel-heading center-align-text">${parentCategoryName}</div>
						<div class="panel-body">
							<c:if test="${not empty itemId }">
								<div class="row">
									<div class="hidden-xs hidden-sm col-md-2 col-lg-3"></div>
									<div class="col-xs-12 col-xs-12 col-md-8 col-lg-6">
										<a href="${newProductUpload}" class="btn btn-success btn-block">Upload another ${parentCategoryName} product</a>
									</div>
									<div class="hidden-xs hidden-sm col-md-2 col-lg-3"></div>
								</div>
								<br/>
							</c:if>
							<form role="form" id="uploadForm" action="${form_upload_url}"
								class="productuploadform" method="POST"
								enctype="multipart/form-data">
 								<div class="row" id="imagecontent">
									<c:forEach var="item" items="${propertyMetadata.imageModels}"
 										varStatus="i">
										<div class="col-xs-12 col-md-6 col-sm-6 col-lg-4">
											<div class="panel panel-default">
												<div class="panel-heading">
													<label>${item.name}</label>
												</div>
												<div class="panel-body">
													<div class="row">
														<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
															<c:choose>
																<c:when
 																	test="${not empty valueImageModelMap[item.id]}">
 																	<input type="hidden" name="imagesValueId[${i.index}]" value="${valueImageModelMap[item.id].id}" />
																	<a class="thumbnail"
 																		href="${base_image_url}/${baseSizeDir}/${valueImageModelMap[item.id].id}.${imageExtn}">
 																		<img class="image-responsive upload-preview"
 																		id="thumbnail_images_${i.index}" alt="..."
																		src="${base_image_url}/${sizeDir}/${valueImageModelMap[item.id].id}.${imageExtn}" />
 																	</a>
 																</c:when>
 																<c:otherwise>
 																	<a href="#" class="thumbnail"> <img
 																		class="image-responsive no-image upload-preview"
 																		id="thumbnail_images_${i.index}" alt=""
 																		src="${emptyImageUrl}"> 
 																	</a>
 																</c:otherwise> 
 															</c:choose> 
 														</div>
 														<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
 															<div>
 																<button class="btn btn-default btn-block pull-right">
 																	Upload File</button>
 																<input type="hidden" name="imagesMetaId[${i.index}]" value="${item.id}" />
 																<input name="images[${i.index}]"
 																	class="imageuploadinput btn btn-default btn-block pull-right"
 																	type="file" id="upload_input"
 																	style="opacity: 0; margin-top: -34px; height: 35px;" />
 															</div>
 														</div>
 													</div>
 												</div>
 											</div>
 										</div>
 									</c:forEach>
 								</div>
								<div class="row" id="propertyContent">
									<div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
										<c:forEach var="group"
											items="${propertyMetadata.propertyGroups}" varStatus="i">
											<div class="panel panel-default">
												<div class="panel-heading">${group.name}</div>
												<div class="panel-body">
													<div class="row">
														<c:forEach var="subgroup"
															items="${group.propertySubGroups}" varStatus="j">
															<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
																<h3>${subgroup.name}</h3>
																<table>
																	<c:forEach var="field"
																		items="${subgroup.propertyFields}" varStatus="k">
																		<c:choose>
																			<c:when test="${not empty newItem}">
																				<tr>
																					<td class="col-xs-6 col-sm-6 col-md-6 col-lg-6"><label>${field.value}</label></td>
																					<input type="hidden" name="fieldIds[${value_count}]" value="${field.id}" />
																					<td class="col-xs-6 col-sm-6 col-md-6 col-lg-6"><input
																						name="values[${value_count}]"
																						value=""
																						type="text" /></td>
																					<c:set var="value_count" value="${value_count + 1}" scope="page"/>
																				</tr>
																			</c:when>
																			<c:otherwise>
																				<tr>
																					<td class="col-xs-6 col-sm-6 col-md-6 col-lg-6"><label>${field.value}</label></td>
																					<input type="hidden" name="valueIds[${value_count}]" value="${propertyValueMap[field.id].id}" />
																					<td class="col-xs-6 col-sm-6 col-md-6 col-lg-6"><input
																						name="values[${value_count}]"
																						value="${propertyValueMap[field.id].value}"
																						type="text" /></td>
																					<c:set var="value_count" value="${value_count + 1}" scope="page"/>
																				</tr>
																			</c:otherwise>
																		</c:choose>
																	</c:forEach>
																</table>
															</div>
														</c:forEach>
													</div>
												</div>
											</div>
										</c:forEach>
									</div>
								</div>
								<br />
								<div class="row" id="submit">
									<div class="hidden-xs hidden-sm col-md-2 col-lg-3"></div>
									<div class="col-xs-12 col-xs-12 col-md-8 col-lg-6">
										<button type="submit" class="btn btn-primary btn-block">Upload
											Product</button>
									</div>
									<div class="hidden-xs hidden-sm col-md-2 col-lg-3"></div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</tiles:putAttribute>
</tiles:insertDefinition>