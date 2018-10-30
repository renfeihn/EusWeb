
Ext.ns('clsys.form.Util');

clsys.form.Util.waitMsg = '正在加载，请稍候...';

/*
 * get combo value and raw value.
 */
clsys.form.Util.getComboValues = function(comboid) {
	var combo = Ext.getCmp(comboid);
	if (combo) {
		var id = combo.getValue();
		var name = combo.getRawValue();
		result = {
			id: id ? id : '',
			name: name ? name : ''
		};
		return result;
	}
	return {};
};

/*
 * get field raw value.
 */
clsys.form.Util.getFieldValue = function(id) {
	var field = Ext.getCmp(id);
	if (field) {
		var value = field.getRawValue();
		return value ? value: '';
	}
	return '';
};

/*
 * update combo value async.
 */
clsys.form.Util.updateCombo = function(comboid, value, fn, target) {
	var combo = Ext.getCmp(comboid);
	if (combo) {
		combo.getStore().load({
			callback : function(records, opt, success) {
				if (success) {
					combo.setValue(value);
					if (fn) {
						fn(combo.getStore(), target);
					}
				}
			}
		});
	}
};

clsys.form.Util.updateComboWithGet = function(comboid, value) {
	var combo = Ext.getCmp(comboid);
	if (combo) {
		combo.getStore().load({
			params: {id:value},
			callback : function(records, opt, success) {
				if (success) {
					if (combo.getStore().getCount()<1) return;
					var record = combo.getStore().getAt(0);
					combo.setValue(value);
				}
			}
		});
	}
};

/*
 * update field with raw value.
 */
clsys.form.Util.updateField = function(id, value) {
	var field = Ext.getCmp(id);
	if (field) {
		field.setValue(value);
	}
};

pageSizeChanged = function(id, store, m, pressed) {
		
    if(!m){ // cycle if not a menu item click
    	var menuid = id + '-paging-menu';
        var items = Ext.menu.MenuMgr.get(menuid).items.items;
        var b = items[0], r = items[1], h = items[2];
        if(b.checked){
            r.setChecked(true);
        }else if(r.checked){
            h.setChecked(true);
        }else if(h.checked){
            b.setChecked(true);
        }
        return;
    }

    if(pressed) {
    	store.lastOptions.params.start = 0;
    	store.lastOptions.params.limit = m.pageSize;
    	store.reload();
    	Ext.getCmp(id).pageSize = m.pageSize;
    	Ext.getCmp(id +'-paging-menubutton').setText('每页' + m.pageSize + '条');
    }
};

/* 
 * Form Grid Paging Tool bar.
 */
clsys.form.Util.PagingToolbar = function(store, renderTo, id) {
	/*带查询条件翻页的时候会使用*/
	store.on("beforeload", function(thiz, options) {
		thiz.baseParams = thiz.lastOptions.params;
	});
	return new Ext.PagingToolbar({
		id: id,
    	store: store,
    	pageSize: 25,
    	displayInfo:true,
    	renderTo: renderTo,
    	items: [ '-', {
    		split: true,
			text: '每页25条',
			id: id + '-paging-menubutton',
			iconCls: 'icon-prop',
			handler: pageSizeChanged.createDelegate(this, [id, store]),
			menu: {
    			id: id + '-paging-menu',
    			cls: id + '-paging-menu',
				items: [{
					id: id + 'pagesize25',
					text: '每页25条',
					checked: true,
					checkHandler: function(m, pressed) {
						pageSizeChanged(id, store, m, pressed);
	    			},
	    			group: id + '-group',
	    			pageSize: 25,
	    			scope: this
				}, {
					id: id + 'pagesize50',
					text: '每页50条',
					checked: false,
					checkHandler: function(m, pressed) {
						pageSizeChanged(id, store, m, pressed);
	    			},
	    			group: id + '-group',
	    			pageSize: 50,
	    			scope: this
				}, {
					id: id + 'pagesize100',
					checked: false,
					text: '每页100条',
					checkHandler: function(m, pressed) {
						pageSizeChanged(id, store, m, pressed);
	    			},
	    			group: id + '-group',
	    			pageSize: 100,
	    			scope: this
				}]
    		}
    	}, '-', {
			text: '过滤器:无',
			iconCls: 'icon-remove',
			id: id + '-filter'	
    	}]
	});
};

/*
 * 打开客户窗口.
 */
gridOpenClientInfo = function(id) {
	var window = Ext.getCmp('client-info-window');
	if (!window) {
		window = new is.window.ClientInfo();
	}
	window.show();
	window.open(id);
};

/*
 * 打开销售合同信息窗口.
 */
gridOpenContractInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('contract-info-window');
		if (!win) {
			win = new is.window.ContractInfo();
		}
		win.show();
		win.open(id);
	}
};

/*
 * Open Client information window.
 */
dataviewOpenClientSelector = function(id) {
	var dataview = Ext.getCmp(id);
	var callback = dataview.onClientSelected;
	var win = Ext.getCmp('client-selector-window');
	if (!win) {
		win = new is.window.ClientSelector(true);
		win.on('clientsSelected', callback, dataview);
	}
	win.show();
};

/*
 * dataview open client information window(READONLY mode).
 */
dataviewOpenClientInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('client-info-window');
		if (!win) {
			win = new is.window.ClientInfo();
		}
		win.show();
		win.open(id);
	}
};

/*
 * data view open contact selector.
 */
dataviewOpenContactSelector = function(id) {
	var dataview = Ext.getCmp(id);
	var callback = dataview.onContactSelected;
	var contact = dataview.getClientId();
	if (!contact) {
		clsys.message.info('先选择销售单并确定该销售单的客户存在.');
		return;
	}
	var win = Ext.getCmp('contact-selector');
	if (!win) {
		win = new is.window.ContactSelector();
		win.open(contact);
		win.on('contactSelected', callback, dataview);
	}
	win.show();
};

/*
 * Open Car information window.
 */
dataviewOpenContractCarSelector = function(id) {
	var dataview = Ext.getCmp(id);
	var contract = dataview.getContractId();
	if (!contract) {
		clsys.message.info('请先选择合同并确认该合同中包含可以销售的车辆.');
		return;
	}
	var callback = dataview.onCarSelected;
	var win = Ext.getCmp('contract-car-selector-window');
	if (!win) {
		win = new is.window.ContractCarSelector();
		win.open(contract);
		win.on('contractCarSelected', callback, dataview);
	}
	win.show();
};

/*
 * Open Contract information window.
 */
dataviewOpenContractSelector = function(id, states) {
	var dataview = Ext.getCmp(id);
	var callback = dataview.onContractSelected;
	var win = Ext.getCmp('contract-selector-window');
	if (!win) {
		win = new is.window.ContractSelector(states);
		win.on('contractSelected', callback, dataview);
	}
	win.show();
};

/*
 * data view open contact information window.
 */
dataviewOpenContactInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('contact-info-window');
		if (!win) {
			win = new is.window.ContactInfo();
		}
		win.show();
		win.open(id);
	}
};

/*
 * Open Employee information window.
 */
dataviewOpenEmployeeSelector = function(id) {
	var dataview = Ext.getCmp(id);
	var callback = dataview.onEmployeeSelected;
	var win = Ext.getCmp('employee-selector-window');
	if (!win) {
		win = new is.window.EmployeeSelector();
		win.on('employeeSelected', callback, dataview);
	}
	win.show();
};

/*
 * dataview open employee information window.
 */
dataviewOpenEmployeeInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('employee-info-window');
		if (!win) {
			win = new is.window.EmployeeInfo();
		}
		win.show();
		win.open(id);
	}
};

/*
 * data view open contract information window.
 */
dataviewOpenContractInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('contract-info-window');
		if (!win) {
			win = new is.window.ContractInfo();
		}
		win.show();
		win.open(id);
	}
};

/*
 * Open Sales information window.
 */
dataviewOpenSalesSelector = function(id, states) {
	var dataview = Ext.getCmp(id);
	var callback = dataview.onSalesSelected;
	var win = Ext.getCmp('sales-selector-window');
	if (!win) {
		win = new is.window.SalesSelector(states);
		win.on('salesSelected', callback, dataview);
	}
	win.show();
};


/*
 * Open Employee information window.
 */
gridOpenEmployeeInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('employee-info-window');
		if (!win) {
			win = new is.window.EmployeeInfo();
		}
		win.open(id);
		win.show();
	}
};

/*
 * Open Schedule information window.
 */
dataviewOpenScheduleSelector = function(id) {
	var dataview = Ext.getCmp(id);
	var productID = Ext.getCmp('cbStorageIncomingItem_ProductCombination').getValue();
	if (Ext.isEmpty(productID)) {
		clsys.message.info('请先选择产品名称及型号');
		return;
	}
	var callback = dataview.onScheduleSelected;
	var wnd = Ext.getCmp('schedule-selector-window');
	if (!wnd) {
		wnd = new clsys.window.ScheduleSelector(true);
		wnd.on('schedulesSelected', callback, dataview);
	}
	wnd.doAutoReload(productID);
	wnd.show();
};

/*
 * dataview open schedule information window(READONLY mode).
 */
dataviewOpenScheduleInfo = function(id) {
	if (id) {
		var win = Ext.getCmp('schedule-info-window');
		if (!win) {
			win = new clsys.window.ScheduleInfo();
		}
		win.show();
		win.open(id);
	}
};
