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
 * ��Ʒ����(1)= ��Ʒ���� + ��Ʒ���� + ��Ʒ��ѹ + ʪ��ϵ��ָ�� + ��Ʒ���� + ���ȼ�
 * ��Ʒ����(2)= ��Ʒ���� + ��Ʒ��ѹ + ʪ��ϵ��ָ�� + ��Ʒ���� + ���ȼ�
 * ��Ʒ����productCode
 * ��Ʒ����productName
 * ��Ʒ��ѹ voltage
 * ʪ��ϵ��ָ��humidity
 * ��Ʒ����capacity
 * ���ȼ�errorLevel
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
