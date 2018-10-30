<%@page contentType="text/html; charset=GBK" %>
<head>
<script type="text/javascript" src="js/sales/ContractAudit.js"></script>
<script type="text/javascript" src="js/common/EmployeeInfo.js"></script>
<script type="text/javascript" src="js/common/ContractInfo.js"></script>
<script type="text/javascript" src="js/common/ClientInfo.js"></script>
<script type="text/javascript" src="js/common/EmployeeDataview.js"></script>
<script type="text/javascript" src="js/common/ClientDataview.js"></script>
<script type="text/javascript" src="js/sales/FinancialConfirm.js"></script>
<script type="text/javascript">

/*-----------------------------------------------------
 * Main Window.
 */
Ext.onReady(function() {
	Ext.QuickTips.init();

	var states = ['Audited', 'Executing']; 
	/*
	 * check in (sheet)store.
	 */
	var financialConfirmStore = new Ext.data.JsonStore({
        autoDestroy: true,
        autoLoad: { params: { states:states, status: ['Using'], start: 0, limit: 25} },
        baseParams: {states:states, status: ['Using'], start: 0, limit: 25 },
		url: 'findContract.action',
		totalProperty: 'results',
		root: 'ContractList',
		idProperty: 'id',
		fields: ['id','code','name', 'memo',
			{name:'signdate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'deliverydate', type:'date', dateFormat: 'Y-m-d'}, 
			{name:'state', type:'int'}, 
			{name:'prepayed', type:'float'},
			'employee',
			{name:'payment', mapping:'payment.name'},
			'client',
			'cars']
	});
	
	var financialConfirmPanel = Ext.getCmp('FinancialConfirm-mainpanel');

	financialConfirmPanel.getTopToolbar().add({
			text: '����ȷ��',
			id: 'financial-confirm-confirm',
			iconCls: 'icon-audit',
			disabled: true,
			handler: function(button) {
				var win = Ext.getCmp('financial-confirm-form-window');
				if (!win) {
					win = new is.window.FinancialConfirm();
					win.on('financialConfirmed', function(attr) {
						financialConfirmStore.reload();
					});
					var grid = Ext.getCmp('financial-confirm-grid');
					win.create(grid.getSelectionModel().getSelected().json.id);
				}
				win.show();
			},
			scope: this
		}, '-', {
			text: '����',
			iconCls: 'icon-pkg',
			id: 'financial-confirm-trace',
			disabled: true,
			handler: function() {
			},
			scope: this
		}, '-', {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				financialConfirmStore.reload();
			},
			scope: this
		}, '->', ' ', {
			xtype: 'is-search-field',
			id: 'financial-confirm-search',
			//emptyText: '�����ѯ����,���س�������ѯ',
			store: financialConfirmStore,
			paramName: 'search',
			tooltip: '�����ѯ����,���س�������ѯ.'
		}, ' '
	);

	/*
	 * Contract render.
	 */
	 financialConfirmRender = function(id) {
		var record = financialConfirmStore.getById(id);
		if (record) {
			return '<span><a href="#" onclick="gridOpenContractInfo(\'' + id + '\');">' +  record.get('code') + '</a></span>';
		} else {
			return '<span></span>';
		}
	};
	
	financialConfirmPanel.add({
		xtype: 'grid',
		id: 'financial-confirm-grid',
		store: financialConfirmStore,
		autoHeight: true,
		border: false,
 	    renderTo: 'financialConfirmGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            //width: 120, 	            
 	            sortable: true
 	        },
 	        columns: [
  	            {header: '��ͬ���', renderer: financialConfirmRender, dataIndex: 'id' },
      	        {header: '���㷽ʽ', dataIndex: 'payment'},
      	        {header: '�ͻ�', renderer: clsys.grid.columnrender.ClientRender, dataIndex: 'client'},
      	        {header: 'Ԥ����', dataIndex: 'prepayed'},
      	        {header: 'ǩ������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'signdate'},
      	        {header: '��������', renderer: clsys.grid.columnrender.DateRender, dataIndex: 'deliverydate'},
      	        {header: '���۹���', renderer: clsys.grid.columnrender.EmployeeRender, dataIndex: 'employee'},
      	        {header: '״̬', renderer:clsys.grid.columnrender.ContractStatusRender, dataIndex: 'state'}
  	 	    ]
 		}),
 		viewConfig: {
 			forceFit: true
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	financialConfirmPanel.getBottomToolbar().hide();
	clsys.form.Util.PagingToolbar(financialConfirmStore, financialConfirmPanel.bbar, 'financial-confirm-paging');
	
	financialConfirmPanel.doLayout();

	Ext.getCmp('financial-confirm-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('financial-confirm-trace').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			Ext.getCmp('financial-confirm-confirm').setDisabled(sm.getSelected().get('state') != 2);
		}
	});
});
</script>
</head>
<body>
<div id="financialConfirm"></div>
<div id="financialConfirmGridPanel"></div>
</body>
