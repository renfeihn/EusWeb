
Ext.ns('clsys.grid.columnrender');

/*
 * Car Status render.
 */
clsys.grid.columnrender.CarStatusRender = function(value) {
	switch (value) {
	case 0:
		return '<img height="12" src="images/inherited.gif"></img><span>订购中</span>';
	case 1:
		return '<img height="12" src="images/inherited.gif"></img><span>在途</span>';
	case 2:
		return '<img height="12" src="images/inherited.gif"></img><span>已到货</span>';
	case 3:
		return '<img height="12" src="images/drop-yes.gif"></img><span>新建</span>';
	case 4:
		return '<img height="12" src="images/inherited.gif"></img><span>新建入库</span>';
	case 5:
		return '<img height="12" src="images/inherited.gif"></img><span>已审核</span>';
	case 6:
		return '<img height="12" src="images/inherited.gif"></img><span>入库中</span>';
	case 7:
		return '<img height="12" src="images/inherited.gif"></img><span>库存中</span>';
	case 8:
		return '<img height="12" src="images/inherited.gif"></img><span>已销售</span>';
	case 9:
		return '<img height="12" src="images/inherited.gif"></img><span>已售出</span>';
	default:
		break;
	}
};

/*
 * Order Status render.
 */
clsys.grid.columnrender.OrderStatusRender = function(value) {
	switch (value) {
	case 0:
		return '<img height="12" src="images/inherited.gif"></img><span>已订购</span>';
	case 1:
		return '<img height="12" src="images/drop-yes.gif"></img><span>已完成</span>';
		default:
			break;
	}
};

/*
 * shipment status render.
 */
clsys.grid.columnrender.ShipmentStatusRender = function(value) {
	switch (value) {
	case 0:
		return '<img height="12" src="images/inherited.gif"></img><span>在途</span>';
	case 1:
		return '<img height="12" src="images/drop-yes.gif"></img><span>已到</span>';
		default:
			break;
	}
};

/*
 * Date render.
 */
clsys.grid.columnrender.DateRender = function(value) {
	if (!value) {
		return '<span></span>';
	}
	return '<span>' + value.toLocaleString() + '</span>';
};

/*
 * checkin status render.
 */
clsys.grid.columnrender.CheckinStatusRender = function(value) {
	switch (value) {
		case 0:
			return '<img height="12" src="images/drop-add.gif"></img><span>新建</span>';
		case 1:
			return '<img height="12" src="images/icon-active.gif"></img><span>待审核</span>';
		case 2:
			return '<img height="12" src="images/hd-check.gif"></img><span>已审核</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>审核未通过</span>';
		case 4:
			return '<img height="12" src="images/drop-event.gif"></img><span>已作废</span>';
		case 5:
			return '<img height="12" src="images/drop-event.gif"></img><span>已入库</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>未知</span>';
	}
};

/*
 * contact render.
 */
clsys.grid.columnrender.ContactRender = function(value){
	switch(value){		
		case 0:
			return '<img height="12" src="images/user.gif"></img><span>私人</span>';
		case 1:
			return '<img height="12" src="images/users.gif"></img><span>公司</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>未知</span>';	
	}
};

/*
 * resource status render.
 */
clsys.grid.columnrender.ResourceStatusRender = function(value){
	switch(value){		
		case 0:
			return '<img height="12" src="images/drop-add.gif"></img><span>未售</span>';
		case 1:
			return '<img height="12" src="images/drop-add.gif"></img><span>已预定</span>';
		case 2:
			return '<img height="12" src="images/drop-add.gif"></img><span>已售未提</span>';
		case 3:
			return '<img height="12" src="images/drop-add.gif"></img><span>已付部分未提</span>';
		case 4:
			return '<img height="12" src="images/drop-add.gif"></img><span>已付全款未提</span>';
		case 5:
			return '<img height="12" src="images/drop-add.gif"></img><span>已付部分已提</span>';
		case 6:
			return '<img height="12" src="images/drop-add.gif"></img><span>已提</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>未知</span>';	
	}
};

/*
 * contract status render.
 */
clsys.grid.columnrender.ContractStatusRender = function(value) {
	switch (value) {
		case 0:
			return '<img height="12" src="images/drop-add.gif"></img><span>新建</span>';
		case 1:
			return '<img height="12" src="images/loading.gif"></img><span>待审核</span>';
		case 2:
			return '<img height="12" src="images/drop-yes.gif"></img><span>已审核</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>审核未通过</span>';
		case 4:
			return '<img height="12" src="images/drop-no.gif"></img><span>执行中</span>';
		case 5:
			return '<img height="12" src="images/drop-event.gif"></img><span>已作废</span>';
		case 6:
			return '<img height="12" src="images/drop-event.gif"></img><span>已完成</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>未知</span>';
	}
};

/*
 * car resource situation render.
 */
clsys.grid.columnrender.SituationRender = function(situation) {
	switch (situation) {
	case 0:
		return '<span>在订</span>';
	case 1:
		return '<span>在途</span>';
	case 2:
		return '<span>在库</span>';
		default:
			break;
	}
	return '';
}

/*
 * position render.
 */
clsys.grid.columnrender.PositionRender = function(position) {
	if (position && position.name) {
		return '<span>' + position.name + '</span>';
	} else {
		return '<span></span>';
	}
};

/*
 * level render.
 */
clsys.grid.columnrender.LevelRender = function(level) {
	if (level && level.name) {
		return '<span>' + level.name + '</span>';
	} else {
		return '<span></span>';
	}
};

/*
 * department render.
 */
clsys.grid.columnrender.DepartmentRender = function(department) {
	if (department && department.name) {
		return '<span>' + department.name + '</span>';
	} else {
		return '<span></span>';
	}
};

/*
 * General State render(DataStatus).
 */
clsys.grid.columnrender.StateRender = function(value){
	switch (value) {
		case 0:
			return '<img height="12" src="images/hmenu-unlock.gif"></img><span>启用</span>';
		case 1:
			return '<img height="12" src="images/hmenu-lock.gif"></img><span>禁用</span>';
		case 2:
			return '<img height="12" src="images/drop-add.gif"></img><span>删除</span>';
		default:
			return '<img height="12" src="images/drop-add.gif"></img><span>未知</span>';
	}
};

/*
 * Contract render(DataStatus).
 */
clsys.grid.columnrender.ContractDeletedRender = function(value){
	value = parseInt(value);
	switch (value) {
		case 0:
			return '有效';
		case 1:
			return '禁用';
		case 2:
			return '作废';
		default:
			return '未知';
	}
};

/*
 * Client render.
 */
clsys.grid.columnrender.ClientRender = function(client) {
	if (client.id) {
		return '<span><a href="#" onclick="gridOpenClientInfo(\'' + client.id + '\');">' + client.name + '</a></span>';
	} else {
		return '<span></span>';
	}
};

/*
 * Employee render.
 */
clsys.grid.columnrender.EmployeeRender = function(employee) {
	if (employee.id) {
		return '<span><a href="#" onclick="gridOpenEmployeeInfo(\'' + employee.id + '\');">' + employee.name + '</a></span>';
	} else {
		return '<span></span>';
	}
};

/*
 * Contract render.
 */
clsys.grid.columnrender.ContractRender = function(contract) {
	if (contract.id) {
		return '<span><a href="#" onclick="gridOpenContractInfo(\'' + contract.id + '\');">' + contract.code + '</a></span>';
	} else {
		return '<span></span>';
	}
};


/*
 * Contract render.
 */
clsys.grid.columnrender.ContractIdRender = function(id, meta, record, row, col, store) {
	var record = store.getById(id);
	if (record) {
		return '<span><a href="#" onclick="gridOpenContractInfo(\'' + id + '\');">' +  record.get('code') + '</a></span>';
	} else {
		return '<span></span>';
	}
};

/**
 * 产品编码 render function 
 * Written by Roec Luo 2010/6/16
 */
clsys.grid.columnrender.ProductCombination = function(value,metadata,record,rowIndex,colIndex,store){
	var record = store.getById(value);
	var strSplit = '-';
	var strStyle = '';
	strStyle += clsys.basic.BizDisplay.getSinglePC(record.get('productName'),strSplit);
	strStyle += clsys.basic.BizDisplay.getSinglePC(record.get('voltage'),strSplit);
	strStyle += clsys.basic.BizDisplay.getSinglePC(record.get('humidity'),strSplit);
	strStyle += clsys.basic.BizDisplay.getSinglePC(record.get('capacity'),strSplit);
	strStyle += clsys.basic.BizDisplay.getSinglePC(record.get('errorLevel'),strSplit);
	strStyle = strStyle.substr(0,strStyle.length-1);
	return strStyle;
};

/**
 * 季度 renderer function
 * Written by Roec Luo 2010/6/23
 */
clsys.grid.columnrender.Quarter = function (value,metadata,record,rowIndex,colIndex,store){
	if (0 == value){
		return '<img height="12" src="images/s.gif"></img>';	
	}
	
	if (1 == value){
		return '<img height="12" src="images/hd-check.gif"></img>';
	}
}

/**
 * 入库 renderer function
 * Written by Roec Luo 2010/6/30
 */
clsys.grid.columnrender.StorageIncomingStatusRender = function(value) {

	switch (value) {
		case 0:
			return '<img height="12" src="images/loading.gif"></img><span>待检验审核</span>';
		case 1:
			return '<img height="12" src="images/drop-no.gif"></img><span>检验失败</span>';
		case 2:
			return '<img height="12" src="images/loading.gif"></img><span>待成品库审核</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>成品库审核失败</span>';
		case 4:
			return '<img height="12" src="images/drop-yes.gif"></img><span>审核成功</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>未知</span>';
	}
};

clsys.grid.columnrender.StorageOutcomingStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '<img height="12" src="images/loading.gif"></img><span>待审核</span>';
		case 1:
			return '<img height="12" src="images/drop-no.gif"></img><span>审核失败</span>';
		case 2:
			return '<img height="12" src="images/drop-yes.gif"></img><span>审核成功</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>未知</span>';
	}
};

clsys.grid.columnrender.ScheduleStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '已保存';	
		case 1:
			return '待审核';
		case 2:
			return '审核失败';
		case 3:
			return '未完成';
		case 4:
			return '部分完成';
		case 5:
			return '全部完成';
		case 6:
			return '终止';
		default:
			return '未知';
	}
};

clsys.grid.columnrender.ScheduleTypeRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '预投';	
		case 1:
			return '合同';
		default:
			return '未知';
	}
};

clsys.grid.columnrender.ContractStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '<img height="12" src="images/out.gif"></img><span>已保存</span>';	
		case 1:
			return '<img height="12" src="images/loading.gif"></img><span>待审核</span>';
		case 2:
			return '<img height="12" src="images/drop-no.gif"></img><span>审核失败</span>';
		case 3:
			return '<img height="12" src="images/prop.gif"></img><span>未完成</span>';
		case 4:
			return '<img height="12" src="images/drop-add.gif"></img><span>部分完成</span>';
		case 5:
			return '<img height="12" src="images/drop-yes.gif"></img><span>全部完成</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>未知</span>';
	}
};

clsys.grid.columnrender.InWarehouseFlagRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '直接入库';	
		case 1:
			return '直接出库';
		case 2:
			return '超计划入库';
		default:
			return '未知';
	}
};

clsys.grid.columnrender.varAmountRender = function(value) {
	value = parseInt(value);
	if (value <=0) return '不欠';
	return value;
};

clsys.grid.columnrender.varStyle = function(value){
    if(value > 0){
        return '<span style="color:lime;font-weight:bold;">+' + value + '</span>';
    }else if(value < 0){
        return '<span style="color:red;font-weight:bold;">' + value + '</span>';
    }
    return value;
};

clsys.grid.columnrender.coOwnedAmount = function(value){
    if(value > 0){
        return '<span style="color:red;font-weight:bold;">' + value + '</span>';
    }else if(value <= 0){
        return '<span style="color:lime;font-weight:bold;">' + 0 + '</span>';
    }
    return value;
};

//TODO:FireFox对于zh-cn的定义为大写以后修改
clsys.grid.columnrender.DateRender = function(date) {
	if (!date) {
		return '<span></span>';
	}
	if ((navigator.language && navigator.language == 'zh-cn')
			||(navigator.browserLanguage && navigator.browserLanguage == 'zh-cn') 
			|| (navigator.systemLanguage && navigator.systemLanguage == 'zh-cn')
			|| (navigator.userLanguage && navigator.userLanguage == 'zh-cn')) {
		var ls = date.toLocaleString();
		return '<span>' + ls.substring(0, ls.indexOf(' ')) + '</span>';
	} else {
		return '<span>' + date.toString() + '</span>';
	}
};
