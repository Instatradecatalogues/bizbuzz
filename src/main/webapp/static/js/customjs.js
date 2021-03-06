function loaderAnimation(){
	var element = document.createElement("div");
	$(element).addClass("loader");
	$("body").append(element);
	$(element).show();
}

function loadDivLoader(parentObj){
	var divElem = document.createElement("div");
	$(divElem).addClass("div-loader");
	$(parentObj).append(divElem);
}

$(window).load(function(){
	$(".loader").remove();
});

$(document).ready(function (){
	$(".loader").remove();
	$("a").click(function(e){
		e.preventDefault();
		var href = $(this).attr("href");
		if(href=="" || href=="#"){
			return;
		}
		loaderAnimation();
		setTimeout(function(){
	         window.location = href;
	    },30);  
	});

	$("form").submit(function(){
		loaderAnimation();
	});

	/*$(".header-nav-item").click(function(e){
		$(".header-nav-item").removeClass("active");
		$(this).addClass("active");
	});*/
});

function getTenDigitPhoneNumber(phonenumber){
	var tenDigit = /^\d{10}$/;  
	if(tenDigit.test(phonenumber))  
	{  
		return phonenumber;  
	}  
	else
	{   
		// Return only digits without any special character
		var phoneno = phonenumber.replace(/[^0-9\s]/gi, '').replace(/\s+/g, '');       
		var lengthOfPhoneno = phoneno.length;
		if(lengthOfPhoneno==10){
			return phoneno;
		}
		else if(lengthOfPhoneno>10){
			return phoneno.substring(lengthOfPhoneno-10);
		}
		else{
			return false;
		}

	}  
}	

function displayQuickNotification(message ,timeout){
	var divElem = document.createElement("div");
	$("body").append(divElem);
	$(divElem).addClass("quicknotification");
	$(divElem).text(message).fadeIn("fast");
	setTimeout( function(){
		$(divElem).fadeOut("fast");
		$(divElem).remove();
	}, timeout);
}

/*
function validatePhonenumber(phonenumber){
	var number = phonenumber.replace(/\s+/g, '');
	var codeFromDropDown = $("li.active").find(".dial-code").text();
	var lengthOfCode = codeFromDropDown.length;
	var codeFromUserInput = number.substring(0,lengthOfCode);

	if(codeFromDropDown!=codeFromUserInput){
		return false;
	}

	var tenDigitNumber = number.substring(lengthOfCode);

	var phoneno = /^\d{10}$/;  
	  if(phoneno.test(tenDigitNumber))  
	  {  
	      return true;  
	  }  
	  else
	  {   
	     return false;  
	  }  

//	return codeFromUserInput +"<>" +number+"<>"+codeFromDropDown+"<>"+lengthOfCode;
}
 */