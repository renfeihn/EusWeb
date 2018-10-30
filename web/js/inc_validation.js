// This set of function are general includes for validation
// They are designed in pairs the validation and the event function
// the event function will call the validation with the event src

var errBgColor='#FFC0C0';
var rightBgColor='#FFFFFF';
function display_name(item) {
	var strDisplay = item.getAttribute("title");
	if (strDisplay==null || strDisplay=="")
		strDisplay="输入框";
	return strDisplay;
}

function trim_string() {
	var ichar, icount;
	var strValue = this;
	ichar = strValue.length - 1;
	icount = -1;
	while (strValue.charAt(ichar)==' ' && ichar > icount)
		--ichar;
	if (ichar!=(strValue.length-1))
		strValue = strValue.slice(0,ichar+1);
	ichar = 0;
	icount = strValue.length - 1;
	while (strValue.charAt(ichar)==' ' && ichar < icount)
		++ichar;
	if (ichar!=0)
		strValue = strValue.slice(ichar,strValue.length);
	return strValue;
}

function date_toSimpleForm() {
	var toSimpleForm = new String;
	toSimpleForm = this.toLocaleString();
	toSimpleForm = toSimpleForm.substring(0,toSimpleForm.indexOf(' '));
	return toSimpleForm;
}

function es_normal() {
        var item = event.srcElement;
	event.returnValue = vs_normal(item);
}

function vs_normal(item) {
	var strErrorMsg ="";
	item.value=item.value.Trim();
	if (item.value.indexOf('"') > -1 || item.value.indexOf("'") > -1 || item.value.indexOf("#") > -1 || item.value.indexOf("@") > -1 || item.value.indexOf("%") > -1 || item.value.indexOf(">") > -1 || item.value.indexOf("<") > -1 ) {
		strErrorMsg = display_name(item) + "不能含有单引号、双引号、大于号、小于号、百分号、@符号、#符号！";
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}
	
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}

function es_non_blank() {
	var item = event.srcElement;
	event.returnValue = vs_non_blank(item);
}
function vs_non_blank(item) {
	var strErrorMsg = display_name(item) + "不能为空！";
	//var strErrorMsg = display_name(item);
	item.value=item.value.Trim();
	if (item.value.length==0) {
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}

	if (item.value.indexOf('"') > -1 || item.value.indexOf("'") > -1 || item.value.indexOf("#") > -1 || item.value.indexOf("@") > -1 || item.value.indexOf("%") > -1 || item.value.indexOf(">") > -1 || item.value.indexOf("<") > -1 ) {
		strErrorMsg = display_name(item) + "不能含有单引号、双引号、大于号、小于号、百分号、@符号、#符号！";
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}
	
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}
function es_non_quote() {
	var item = event.srcElement;
	event.returnValue = vs_non_quote(item);
}
function vs_non_quote(item) {
	if (item.value.length==0)
		return true;
	var strErrorMsg = display_name(item) + "不能含有单引号或双引号！";
	item.value=item.value.Trim();
	//var num = "'\"";
	//for (var intLoop = 0; intLoop < item.value.length; intLoop++) {
		//if (item.value.charAt(intLoop).indexOf(num) > -1) {
		if (item.value.indexOf('"') > -1 || item.value.indexOf("'") > -1) {
			alert(strErrorMsg);
         item.runtimeStyle.backgroundColor=errBgColor;
			item.select();
			return false;
		}
	//}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}
function es_non_doublequote() {
	var item = event.srcElement;
	event.returnValue = vs_non_doublequote(item);
}
function vs_non_doublequote(item) {
	if (item.value.length==0)
		return true;
	var strErrorMsg = display_name(item) + "不能含有双引号！";
	item.value=item.value.Trim();
	//var num = "'\"";
	//for (var intLoop = 0; intLoop < item.value.length; intLoop++) {
		//if (item.value.charAt(intLoop).indexOf(num) > -1) {
		if (item.value.indexOf('"') > -1) {
			alert(strErrorMsg);
         item.runtimeStyle.backgroundColor=errBgColor;
			item.select();
			return false;
		}
	//}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}

function es_valid_number() {
	var item = event.srcElement;
	event.returnValue = vs_valid_number(item);
}
function vs_valid_number(item) {
	if (item.value.length==0)
		return true;
	var strErrorMsg = display_name(item) + "必须为数字！";
	item.value=item.value.Trim();
	var num = ".0123456789";
	for (var intLoop = 0; intLoop < item.value.length; intLoop++) {
		if (num.indexOf(item.value.charAt(intLoop)) == -1) {
			alert(strErrorMsg);
         item.runtimeStyle.backgroundColor=errBgColor;
			item.select();
			return false;
		}
	}
	if (item.value.indexOf(".")!=item.value.lastIndexOf(".")) {
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}

function es_valid_date() {
	var item = event.srcElement;
	event.returnValue = vs_valid_date(item);
}
function vs_valid_date(item) {
	item.value=item.value.Trim();
	if (item.value.length==0)
		return true;
		
	var strErrorMsg = display_name(item);
	
	var re = /[1-9][0-9]*[-][0-1]?[0-9]?[-][0-3]?[0-9]?/
	var strMatch = item.value.match(re);
	if (strMatch != item.value)
	{
		alert(strErrorMsg + "必须是日期格式！");
		item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}
	
	var strMonth;
	var nYear, nMonth, nDay
	var aryDate = item.value.split("-");
	var nYear = parseInt(aryDate[0]);
	if (aryDate[1].length == 0)
		nMonth = 0;
	else if (aryDate[1].length == 1)
		nMonth = parseInt(aryDate[1]);
	else if (aryDate[1].charAt(0) == '0')
		nMonth = parseInt(aryDate[1].charAt(1) + "");
	else
		nMonth = parseInt(aryDate[1]);
			
	if (aryDate[2].length == 0)
		nDay = 0;
	else if (aryDate[2].length == 1)
		nDay = parseInt(aryDate[2]);
	else if (aryDate[2].charAt(0) == '0')
		nDay = parseInt(aryDate[2].charAt(1) + "");
	else
		nDay = parseInt(aryDate[2]);
	
	if (item.getAttribute("format") != "BC")
		nYear += 1911;
		
	if ((nMonth > 12 || nMonth < 1) ||
		(nDay < 1 || nDay > GetDayOfMonth(nYear, nMonth)))
	 {
		alert(strErrorMsg + "必须是日期格式！");
		item.runtimeStyle.backgroundColor=errBgColor;
		item.select();
		return false;
	}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}
function GetDayOfMonth(nYear, nMonth)
{
	var aryMonthDays = new Array( 
   /* Jan */ 31,     /* Feb */ 29, /* Mar */ 31,     /* Apr */ 30, 
   /* May */ 31,     /* Jun */ 30, /* Jul */ 31,     /* Aug */ 31, 
   /* Sep */ 30,     /* Oct */ 31, /* Nov */ 30,     /* Dec */ 31 );
   aryMonthDays[1] = (((!(nYear % 4)) && (nYear % 100) ) || !(nYear % 400)) ? 29 : 28
   return aryMonthDays[nMonth - 1];
}
function es_valid_email() {
	var item = event.srcElement;
	event.returnValue = vs_valid_email(item);
}
/*
function vs_valid_email(item) {
	var strErrorMsg = display_name(item) + "不是有效的 Email 格式！";
	item.value=item.value.Trim();
	if (!(/^[\w\.]+@[a-z\.]+$/.test(item.value))) {
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		return false;
	}
	return true;
}*/

function vs_valid_email(item) {
	var strErrorMsg = display_name(item) + "不是有效的 Email 格式！";
	item.value=item.value.Trim();
	
	var re = /[a-zA-Z0-9][a-zA-Z0-9\-_]*(\.[a-zA-Z0-9][a-zA-Z0-9\-_]*)*@[a-zA-Z0-9][a-zA-Z0-9\-_]*(\.[a-zA-Z0-9][a-zA-Z0-9\-_]*)*/
	var strMatch = item.value.match(re);
	if (strMatch[0] != item.value)
	{
		alert(strErrorMsg);
		item.runtimeStyle.backgroundColor=errBgColor;
		return false;
	}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}
function es_valid_english() {
	var item = event.srcElement;
	event.returnValue = vs_valid_english(item);
}
function vs_valid_english(item) {
	var strErrorMsg = display_name(item) + "不能输入中文！";
	item.value=item.value.Trim();
   for (var i=0;i< item.value.length;i++) {
      if (item.value.charCodeAt(i) > 128) {
		   alert(strErrorMsg);
         item.runtimeStyle.backgroundColor=errBgColor;
		   return false;
      }
   }
   	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}
function es_item_selected() {
	var item = event.srcElement;
	event.returnValue = vs_item_selected(item);
}
function vs_item_selected(item) {
	var strErrorMsg = display_name(item) + "不得为空白选项！";
	if (item.selectedIndex==0) {
		alert(strErrorMsg);
      item.runtimeStyle.backgroundColor=errBgColor;
		return false;
	}
	item.runtimeStyle.backgroundColor=rightBgColor;
	return true;
}

// build the validation object
function validation_setup() {
	this.eventNonBlank = es_non_blank;
	this.nonBlank = vs_non_blank;
	this.eventNormal = es_normal;
	this.normal = vs_normal;
	this.eventNonQuote = es_non_quote;
	this.nonQuote = vs_non_quote;
	this.eventNonDoubleQuote = es_non_doublequote;
	this.nonDoubleQuote = vs_non_doublequote;
	this.eventValidNumber = es_valid_number;
	this.validNumber = vs_valid_number;
	this.eventValidDate = es_valid_date;
	this.validDate = vs_valid_date;
	this.eventValidSelect = es_item_selected;
	this.validSelect = vs_item_selected;
	this.eventValidEmail = es_valid_email;
	this.validEmail = vs_valid_email;
	this.eventValidEnglish = es_valid_english;
	this.validEnglish = vs_valid_english;
	return this;
}

// Extend the string object to include a trim function
String.prototype.Trim = trim_string;
// Extend the date object to include a simple form string conversion
Date.prototype.toSimpleForm = date_toSimpleForm;

// Construct the validation object
var validation = new Object;
validation = validation_setup();

function ValidateForm() {
   var myCheck;
   var i,j;
   // 检查 input textbox
   if (document.all.tags("INPUT").length > 0) {
      var oINPUT=document.all.tags("INPUT");
      for (i=0;i<oINPUT.length;i++) {
         if ((oINPUT[i].type=="text" || oINPUT[i].type=="password") && oINPUT[i].getAttribute("myCheck") > "") {
            myCheck=oINPUT[i].getAttribute("myCheck");
            for (j=0;j<myCheck.length;j++) {
               switch (myCheck.charAt(j)) {
                  case "B": // Blank
                     if (!validation.nonBlank(oINPUT[i])) return false;
                     break;
                  case "L": // Normal
                     if (!validation.normal(oINPUT[i])) return false; 
                     break;                 
                  case "Q": // Quotation mark
                     if (!validation.nonQuote(oINPUT[i])) return false;
                     break;
                  case "q": // Double Quotation mark
                     if (!validation.nonDoubleQuote(oINPUT[i])) return false;
                     break;
                  case "D": // Date
                     if (!validation.validDate(oINPUT[i])) return false;
                     break;
                  case "N": // Number
                     if (!validation.validNumber(oINPUT[i])) return false;
                     break;
                  case "E": // E-Mail
                     if (!validation.validEmail(oINPUT[i])) return false;
                     break;
                  case "e": // english
                     if (!validation.validEnglish(oINPUT[i])) return false;
                     break;
               }
            }
         }
      }
   }   
   // 检查 select
   if (document.all.tags("SELECT").length > 0) {
      var oSELECT=document.all.tags("SELECT");
      for (i=0;i<oSELECT.length;i++) {
         if (oSELECT[i].getAttribute("myCheck") > "") {
            myCheck=oSELECT[i].getAttribute("myCheck");
            for (j=0;j<myCheck.length;j++) {
               switch (myCheck.charAt(j)) {
                  case "S": // select
                     if (!validation.validSelect(oSELECT[i])) return false;
                     break;
               }
            }
         }
      }
   }
   // 检查 textarea
   if (document.all.tags("TEXTAREA").length > 0) {
      var oTextarea=document.all.tags("TEXTAREA");
      for (i=0;i<oTextarea.length;i++) {
         if (oTextarea[i].getAttribute("myCheck") > "") {
            myCheck=oTextarea[i].getAttribute("myCheck");
            for (j=0;j<myCheck.length;j++) {
               switch (myCheck.charAt(j)) {
                  case "B": // Blank
                     if (!validation.nonBlank(oTextarea[i])) return false;
                     break;
                  case "L": // Normal
                     if (!validation.normal(oINPUT[i])) return false;                  
		     break;
                  case "Q": // Quotation mark
                     if (!validation.nonQuote(oTextarea[i])) return false;
                     break;
                  case "q": // Dobule Quotation mark
                     if (!validation.nonDoubleQuote(oTextarea[i])) return false;
                     break;
               }
            }
         }
      }
   }
   //检查通过
   return true;
}
function or_validate(form)
{
      var i ;
      var te=true;
      var ob=form.elements;
      var oINPUT=new Array();
      var k=0;
      
      for(var j=0;j<ob.length;j++)
      {
         if(ob[j].type=="text")
         {
           oINPUT[k]=ob[j];
           k++;
          }
      }

	for (i=0;i<oINPUT.length;i++) 
	 {
	   if (oINPUT[i].type=="text" && oINPUT[i].value!="")
	    {
	     te=false;
	     break;
	     }
       }
	 if(te)
	   {
	    alert("至少要填写一项!");
	    return false;
	    }
	 return true;
}
function and_validate(form)
{
      var i ;
      var te=true;
      var ob=form.elements;
      var oINPUT=new Array();
      var k=0;
      
      for(var j=0;j<ob.length;j++)
      {
         if(ob[j].type=="text")
         {
           oINPUT[k]=ob[j];
           k++;
          }
      }

	for (i=0;i<oINPUT.length;i++) 
	 {
	   if (oINPUT[i].type=="text" && oINPUT[i].value=="")
	    {
	     
	     break;
	     }
       }
	 if(i<oINPUT.length)
	   {
	    alert("所有项都要填写!");
	    return false;
	    }
	 return true;
}