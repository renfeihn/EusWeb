
Ext.ns('clsys.grid.columnrender');

/*
 * Car Status render.
 */
clsys.grid.columnrender.CarStatusRender = function(value) {
	switch (value) {
	case 0:
		return '<img height="12" src="images/inherited.gif"></img><span>������</span>';
	case 1:
		return '<img height="12" src="images/inherited.gif"></img><span>��;</span>';
	case 2:
		return '<img height="12" src="images/inherited.gif"></img><span>�ѵ���</span>';
	case 3:
		return '<img height="12" src="images/drop-yes.gif"></img><span>�½�</span>';
	case 4:
		return '<img height="12" src="images/inherited.gif"></img><span>�½����</span>';
	case 5:
		return '<img height="12" src="images/inherited.gif"></img><span>�����</span>';
	case 6:
		return '<img height="12" src="images/inherited.gif"></img><span>�����</span>';
	case 7:
		return '<img height="12" src="images/inherited.gif"></img><span>�����</span>';
	case 8:
		return '<img height="12" src="images/inherited.gif"></img><span>������</span>';
	case 9:
		return '<img height="12" src="images/inherited.gif"></img><span>���۳�</span>';
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
		return '<img height="12" src="images/inherited.gif"></img><span>�Ѷ���</span>';
	case 1:
		return '<img height="12" src="images/drop-yes.gif"></img><span>�����</span>';
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
		return '<img height="12" src="images/inherited.gif"></img><span>��;</span>';
	case 1:
		return '<img height="12" src="images/drop-yes.gif"></img><span>�ѵ�</span>';
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
			return '<img height="12" src="images/drop-add.gif"></img><span>�½�</span>';
		case 1:
			return '<img height="12" src="images/icon-active.gif"></img><span>�����</span>';
		case 2:
			return '<img height="12" src="images/hd-check.gif"></img><span>�����</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>���δͨ��</span>';
		case 4:
			return '<img height="12" src="images/drop-event.gif"></img><span>������</span>';
		case 5:
			return '<img height="12" src="images/drop-event.gif"></img><span>�����</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>δ֪</span>';
	}
};

/*
 * contact render.
 */
clsys.grid.columnrender.ContactRender = function(value){
	switch(value){		
		case 0:
			return '<img height="12" src="images/user.gif"></img><span>˽��</span>';
		case 1:
			return '<img height="12" src="images/users.gif"></img><span>��˾</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>δ֪</span>';	
	}
};

/*
 * resource status render.
 */
clsys.grid.columnrender.ResourceStatusRender = function(value){
	switch(value){		
		case 0:
			return '<img height="12" src="images/drop-add.gif"></img><span>δ��</span>';
		case 1:
			return '<img height="12" src="images/drop-add.gif"></img><span>��Ԥ��</span>';
		case 2:
			return '<img height="12" src="images/drop-add.gif"></img><span>����δ��</span>';
		case 3:
			return '<img height="12" src="images/drop-add.gif"></img><span>�Ѹ�����δ��</span>';
		case 4:
			return '<img height="12" src="images/drop-add.gif"></img><span>�Ѹ�ȫ��δ��</span>';
		case 5:
			return '<img height="12" src="images/drop-add.gif"></img><span>�Ѹ���������</span>';
		case 6:
			return '<img height="12" src="images/drop-add.gif"></img><span>����</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>δ֪</span>';	
	}
};

/*
 * contract status render.
 */
clsys.grid.columnrender.ContractStatusRender = function(value) {
	switch (value) {
		case 0:
			return '<img height="12" src="images/drop-add.gif"></img><span>�½�</span>';
		case 1:
			return '<img height="12" src="images/loading.gif"></img><span>�����</span>';
		case 2:
			return '<img height="12" src="images/drop-yes.gif"></img><span>�����</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>���δͨ��</span>';
		case 4:
			return '<img height="12" src="images/drop-no.gif"></img><span>ִ����</span>';
		case 5:
			return '<img height="12" src="images/drop-event.gif"></img><span>������</span>';
		case 6:
			return '<img height="12" src="images/drop-event.gif"></img><span>�����</span>';
		default:
			return '<img height="12" src="images/hide-inherited.gif"></img><span>δ֪</span>';
	}
};

/*
 * car resource situation render.
 */
clsys.grid.columnrender.SituationRender = function(situation) {
	switch (situation) {
	case 0:
		return '<span>�ڶ�</span>';
	case 1:
		return '<span>��;</span>';
	case 2:
		return '<span>�ڿ�</span>';
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
			return '<img height="12" src="images/hmenu-unlock.gif"></img><span>����</span>';
		case 1:
			return '<img height="12" src="images/hmenu-lock.gif"></img><span>����</span>';
		case 2:
			return '<img height="12" src="images/drop-add.gif"></img><span>ɾ��</span>';
		default:
			return '<img height="12" src="images/drop-add.gif"></img><span>δ֪</span>';
	}
};

/*
 * Contract render(DataStatus).
 */
clsys.grid.columnrender.ContractDeletedRender = function(value){
	value = parseInt(value);
	switch (value) {
		case 0:
			return '��Ч';
		case 1:
			return '����';
		case 2:
			return '����';
		default:
			return 'δ֪';
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
 * ��Ʒ���� render function 
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
 * ���� renderer function
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
 * ��� renderer function
 * Written by Roec Luo 2010/6/30
 */
clsys.grid.columnrender.StorageIncomingStatusRender = function(value) {

	switch (value) {
		case 0:
			return '<img height="12" src="images/loading.gif"></img><span>���������</span>';
		case 1:
			return '<img height="12" src="images/drop-no.gif"></img><span>����ʧ��</span>';
		case 2:
			return '<img height="12" src="images/loading.gif"></img><span>����Ʒ�����</span>';
		case 3:
			return '<img height="12" src="images/drop-no.gif"></img><span>��Ʒ�����ʧ��</span>';
		case 4:
			return '<img height="12" src="images/drop-yes.gif"></img><span>��˳ɹ�</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>δ֪</span>';
	}
};

clsys.grid.columnrender.StorageOutcomingStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '<img height="12" src="images/loading.gif"></img><span>�����</span>';
		case 1:
			return '<img height="12" src="images/drop-no.gif"></img><span>���ʧ��</span>';
		case 2:
			return '<img height="12" src="images/drop-yes.gif"></img><span>��˳ɹ�</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>δ֪</span>';
	}
};

clsys.grid.columnrender.ScheduleStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '�ѱ���';	
		case 1:
			return '�����';
		case 2:
			return '���ʧ��';
		case 3:
			return 'δ���';
		case 4:
			return '�������';
		case 5:
			return 'ȫ�����';
		case 6:
			return '��ֹ';
		default:
			return 'δ֪';
	}
};

clsys.grid.columnrender.ScheduleTypeRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return 'ԤͶ';	
		case 1:
			return '��ͬ';
		default:
			return 'δ֪';
	}
};

clsys.grid.columnrender.ContractStatusRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return '<img height="12" src="images/out.gif"></img><span>�ѱ���</span>';	
		case 1:
			return '<img height="12" src="images/loading.gif"></img><span>�����</span>';
		case 2:
			return '<img height="12" src="images/drop-no.gif"></img><span>���ʧ��</span>';
		case 3:
			return '<img height="12" src="images/prop.gif"></img><span>δ���</span>';
		case 4:
			return '<img height="12" src="images/drop-add.gif"></img><span>�������</span>';
		case 5:
			return '<img height="12" src="images/drop-yes.gif"></img><span>ȫ�����</span>';
		default:
			return '<img height="12" src="images/drop-yes.gif"></img><span>δ֪</span>';
	}
};

clsys.grid.columnrender.InWarehouseFlagRender = function(value) {
	value = parseInt(value);
	switch (value) {
		case 0:
			return 'ֱ�����';	
		case 1:
			return 'ֱ�ӳ���';
		case 2:
			return '���ƻ����';
		default:
			return 'δ֪';
	}
};

clsys.grid.columnrender.varAmountRender = function(value) {
	value = parseInt(value);
	if (value <=0) return '��Ƿ';
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

//TODO:FireFox����zh-cn�Ķ���Ϊ��д�Ժ��޸�
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
