<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
<script type="text/javascript" src="js/common/ClientInfo.js"></script>
<script type="text/javascript" src="js/common/ClientSelector.js"></script>
<script type="text/javascript" src="js/common/ClientDataview.js"></script>
<script type="text/javascript" src="js/common/CarResourceSelector.js"></script>
<script type="text/javascript" src="js/common/EmployeeSelector.js"></script>
<script type="text/javascript" src="js/common/EmployeeInfo.js"></script>
<script type="text/javascript" src="js/common/EmployeeDataview.js"></script>
<script type="text/javascript" src="js/common/ContactSelector.js"></script>
<script type="text/javascript" src="js/common/ContractInfo.js"></script>
<script type="text/javascript" src="js/sales/Contract.js"></script>
<%--
<script type="text/javascript" src="js/ContractExcel.js"></script>
<script type="text/javascript" src="js/ContractExcelPreview.js"></script>
 --%>
<script type="text/javascript">

/*-------------------------------------------
 * Main.
 */
Ext.onReady(function() {
	var states = ['Created', 'Waiting', 'Audited', 'AuditFaild', 'Executing']; 
	/*
	 * contact store.
	 */
	var contractStore = new Ext.data.JsonStore({
        autoDestroy:true,
        autoLoad: {params: { states: states, status: ['Using'], start:0, limit:25 }},
        baseParams: {states: states, status: ['Using'], start:0, limit:25},
		url: 'findContract.action',		
		root: 'ContractList',
		totalProperty: 'results',
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

	//get panel of this page.
	var contractPanel = Ext.getCmp('Contract-mainpanel');
	
	contractPanel.add({
		xtype: 'grid',
		id: 'contract-grid',
		stripeRows: true,
		border: false,
		frame: false,
		autoScroll: true,
		autoHeight: true,
		store: contractStore,
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
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
 			forceFit: true
		},
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	/*
	 * remove contract.
	 */
	var removeContract = function() {
		var selected = Ext.getCmp('contract-grid').getSelectionModel().getSelected();
		if (!selected) return;
		var id = selected.get('id');
		Ext.Ajax.request({
			url: 'removeContract.action',
			params: { id: id },
			success: function(response, opt) {
				//Ext.Msg.alert('��Ϣ', 'ɾ���ɹ�!');
				contractStore.reload();
			},
			failure: function(response, opt) {
				Ext.Msg.alert('����', 'ɾ��������Ϣ:' + response.responseText);
			}
		});
	};

	/*
	 * apply contract.
	 */
	var applyContract = function() {
		var selected = Ext.getCmp('contract-grid').getSelectionModel().getSelected();
		if (!selected) return;
		var id = selected.get('id');
		Ext.Ajax.request({
			url: 'applyContract.action',
			params: { 'id': id },
			success: function(response, opt) {
				var result = Ext.decode(response.responseText);
				if (result.success) {
					contractStore.reload();
				} else {
					clsys.message.error(result.msg);
				}
			},
			failure: function(response, opt) {
				clsys.message.systemerror();
			}
		});
	};
	
	contractPanel.getTopToolbar().add({
			text: '����',
			iconCls: 'icon-add',
			handler: function(button) {
				var window = Ext.getCmp('contract-window');
				if (!window) {
					window = new is.window.Contract();
					window.on('contractSaved', function(attr) {
						contractStore.reload();
					});
				}
				window.show();
			},
			scope: this
		}, {
			text: '��ϸ/����',
			id: 'contract-detail',
			iconCls: 'icon-update',
			handler: function(button) {
				var window = Ext.getCmp('contract-window');
				if (!window) {
					window = new is.window.Contract();
					window.on('contractSaved', function(attr) {
						contractStore.reload();
					});
				}
				window.show();
				window.open(Ext.getCmp('contract-grid').getSelectionModel().getSelected().get('id'));
			},
			scope: this
		}, {
			text: '����',
			iconCls: 'icon-remove',
			id: 'contract-remove',
			disabled: true,
			handler: function() {
				clsys.message.confirm('ȷ�ϳ������ۺ�ͬ?', function(buttonId) {
					if (buttonId == 'yes') {
						removeContract();
					}
				});
			},
			scope: this
		}, '-', {
			text: '�ύ����',
			id: 'contract-apply-2-audition',
			disabled: true,
			iconCls: 'icon-prop',
			handler: function(button) {
				clsys.message.confirm('ȷ���ύ����ⵥ?', function(buttonId) {
					if (buttonId == 'yes') {
						applyContract();
					}
				});					
			},
			scope: this
		}, {
			text: 'ˢ��',
			iconCls: 'icon-refresh',
			handler: function() {
				contractStore.reload();
			},
			scope: this
		}, '->', ' ', {
			xtype: 'is-search-field',
			id: 'contract-search',
			store: contractStore,
			paramName: 'search'
		}, ' '
	);

	//add paging toolbar.
	clsys.form.Util.PagingToolbar(contractStore, contractPanel.bbar, 'contract-paging');
	contractPanel.getBottomToolbar().hide();
	contractPanel.doLayout();
	
	var contractLoadMask = new Ext.LoadMask(contractPanel.body, {
		store: contractStore,
		removeMask: true,
		msg: '���ڼ��أ����Ժ�...'
	});
	
	Ext.getCmp('contract-grid').getSelectionModel().on('selectionchange', function(sm) {
		if (sm.getCount() > 0) {
			Ext.getCmp('contract-apply-2-audition').setDisabled(sm.getSelected().get('state') != 0);
		}
		//Ext.getCmp('traceContract').setDisabled(sm.getCount() > 1);
		Ext.getCmp('contract-remove').setDisabled(sm.getCount() > 1);
		Ext.getCmp('contract-detail').setDisabled(sm.getCount() > 1);
	});

});
</script>
</head>
<body>
<div id="contractPanel"></div>
<div id="contractWindow"></div>
<div id="contractGridPanel"></div>
<div id="contractExcelUploadForm"></div>
<div id="contractExcelUpload"></div>
<div id="contractExelUploadPreviewForm"></div>
<div id="contractExportExcelForm"></div>
</body>
</html>