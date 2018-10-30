Ext.ns('clsys.basic.BizDisplay');
/* PC: Product Combination*/
clsys.basic.BizDisplay.getSinglePC = function(item,split) {
	var strResult = '';
	if (!Ext.isEmpty(item)){
		strResult = item + split;
	}
	return strResult;
};
/*
 * 产品编码(1)= 产品代号 + 产品名称 + 产品电压 + 湿度系数指标 + 产品容量 + 误差等级
 * 产品编码(2)= 产品名称 + 产品电压 + 湿度系数指标 + 产品容量 + 误差等级
 * 产品代号productCode
 * 产品名称productName
 * 产品电压 voltage
 * 湿度系数指标humidity
 * 产品容量capacity
 * 误差等级errorLevel
 * */
clsys.basic.BizDisplay.getPC = function(newName,store,records,Split,hasProductCode){
	for (var i=0;i<store.getCount();i++){
		var strResult = '';
		if (hasProductCode){
			strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('productCode'),Split);
		}
		strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('productName'),Split);
		strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('voltage'),Split);
		strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('humidity'),Split);
		strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('capacity'),Split);
		strResult += clsys.basic.BizDisplay.getSinglePC(records[i].get('errorLevel'),'');
		records[i].set(newName,strResult);
	}	
};
