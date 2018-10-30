<%@page contentType="text/html; charset=GBK" %>
<head>
<script type="text/javascript" src="js/sales/ContractAudit.js"></script>
<script type="text/javascript" src="js/common/EmployeeInfo.js"></script>
<script type="text/javascript" src="js/common/ContractInfo.js"></script>
<script type="text/javascript" src="js/common/ClientInfo.js"></script>
<script type="text/javascript" src="js/common/EmployeeDataview.js"></script>
<script type="text/javascript" src="js/common/ClientDataview.js"></script>
<script type="text/javascript">

/*-----------------------------------------------------
 * Main Window.
 */
Ext.onReady(function() {
	Ext.QuickTips.init();	
	/*
	 * check in (sheet)store.
	 */
	var contract4AuditStore = new Ext.data.JsonStore({
        autoDestroy: true,
        autoLoad: { params: { status: ['Using'], start: 0, limit: 25} },
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
	
	var contractAuditPanel = Ext.getCmp('ContractAudit-mainpanel');

	contractAuditPanel.getTopToolbar().add({
			text: '���',
			id: 'contractAudit-audit',
			iconCls: 'icon-audit',
			disabled: true,
			handler: function(button) {
				var win = Ext.getCmp('contractAudit-form-window');
				if (!win) {
					win = new is.window.ContractAudit();
					win.on('contractAudited', function(attr) {
						contract4AuditStore.reload();
					});
					var grid = Ext.getCmp('contract-audit-grid');
					win.create(grid.getSelectionModel().getSelected().json.id);
				}
				win.show();
			},
			scope: this
		}, '-', {
			text: '����',
			iconCls: 'icon-pkg',
			id: 'contractAudit-trace',
			disabled: true,
			handler: function() {
			},
			scope: this
		}, '-', {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				contract4AuditStore.reload();
			},
			scope: this
		}, '->', ' ', {
			xtype: 'is-search-field',
			id: 'contractAudit-search',
			//emptyText: '�����ѯ����,���س�������ѯ',
			store: contract4AuditStore,
			paramName: 'search',
			tooltip: '�����ѯ����,���س�������ѯ.'
		}, ' '
	);
	
	contractAuditPanel.add({
		xtype: 'grid',
		id: 'contract-audit-grid',
		store: contract4AuditStore,
		autoHeight: true,
		border: false,
		stripeRows: true,
 	    renderTo: 'contractAuditGridPanel',
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            //width: 120, 	            
 	            sortable: true
 	        },
 	        columns: [
  	            {header: '��ͬ���', renderer: clsys.grid.columnrender.ContractIdRender, dataIndex: 'id' },
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
 			forceFit: true,
 			getRowClass: function(record, index, rowParams, store) {
				return clsys.grid.rowrender.getContractClass(record.get('state'));
			}
		},    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	contractAuditPanel.getBottomToolbar().hide();
	clsys.form.Util.PagingToolbar(contract4AuditStore, contractAuditPanel.bbar, 'contract-audit-paging');
	
	contractAuditPanel.doLayout();

	Ext.getCmp('contract-audit-grid').getSelectionModel().on('selectionchange', function(sm) {
		Ext.getCmp('contractAudit-trace').setDisabled(sm.getCount() < 1);
		if (sm.getCount() > 0) {
			Ext.getCmp('contractAudit-audit').setDisabled(sm.getSelected().get('state') != 1);
		} else {
			Ext.getCmp('contractAudit-audit').setDisabled(false);
		}
	});

});
</script>
</head>
<body>
<div id="contractAudit"></div>
<div id="contractAuditGridPanel"></div>
</body>
