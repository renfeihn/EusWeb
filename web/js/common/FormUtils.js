
Ext.ns('clsys.form.Util');

clsys.form.Util.waitMsg = '���ڼ��أ����Ժ�...';

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
    	Ext.getCmp(id +'-paging-menubutton').setText('ÿҳ' + m.pageSize + '��');
    }
};

/* 
 * Form Grid Paging Tool bar.
 */
clsys.form.Util.PagingToolbar = function(store, renderTo, id) {
	/*����ѯ������ҳ��ʱ���ʹ��*/
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
			text: 'ÿҳ25��',
			id: id + '-paging-menubutton',
			iconCls: 'icon-prop',
			handler: pageSizeChanged.createDelegate(this, [id, store]),
			menu: {
    			id: id + '-paging-menu',
    			cls: id + '-paging-menu',
				items: [{
					id: id + 'pagesize25',
					text: 'ÿҳ25��',
					checked: true,
					checkHandler: function(m, pressed) {
						pageSizeChanged(id, store, m, pressed);
	    			},
	    			group: id + '-group',
	    			pageSize: 25,
	    			scope: this
				}, {
					id: id + 'pagesize50',
					text: 'ÿҳ50��',
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
					text: 'ÿҳ100��',
					checkHandler: function(m, pressed) {
						pageSizeChanged(id, store, m, pressed);
	    			},
	    			group: id + '-group',
	    			pageSize: 100,
	    			scope: this
				}]
    		}
    	}, '-', {
			text: '������:��',
			iconCls: 'icon-remove',
			id: id + '-filter'	
    	}]
	});
};

/*
 * �򿪿ͻ�����.
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
 * �����ۺ�ͬ��Ϣ����.
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
		clsys.message.info('��ѡ�����۵���ȷ�������۵��Ŀͻ�����.');
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
		clsys.message.info('����ѡ���ͬ��ȷ�ϸú�ͬ�а����������۵ĳ���.');
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
		clsys.message.info('����ѡ���Ʒ���Ƽ��ͺ�');
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
