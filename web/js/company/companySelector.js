Ext.ns('eus.window.CompanySelector');

eus.window.CompanySelector = function() {
	/*提供插入和修改两种操作，默认为插入操作*/
	this.mode = 'add';
	this.companyID = '';
	
	this.companySelectorStore = new Ext.data.JsonStore({
		autoDestroy:true,
	  	url:'findCompany.action',
	  	baseParams:{status:['Using'],start:0,limit:25},
	  	totalProperty:'results',
	  	root:'CompanyList',
	  	idProperty:'id',
	  	fields:['id','code','name','address','commAddress','delegatee','contract','tele',
	  		   {name:'province',mapping:'province.name'},
	  	       {name:'city',mapping:'city.name'}]
  	});
	
	this.provinceStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProvince.action',
		baseParams:{status:['Using'],start:0,limit:25},
		root:'ProvinceList',
		fields:['id','name']
	});
	
	this.provinceItemStore = new Ext.data.JsonStore({
		url:'getProvince.action',
		root:'Province',
		fields:['id','cities']
	});
	
	this.cityStore = new Ext.data.JsonStore({
		root:'cities',
		fields:['id','name']
	});
	
	this.companyStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'getCompany.action',
		baseParams:{status:'Using'},
		root:'Company',
		fields:['id','code','name','address','commAddress',
		        'bank','contract','account','tax',
		        'zipCode','tele','delegatee','email','fax','memo']
	});
	
	var txtCode = {
		xtype:'textfield',
		id:'txtCode',
		fieldLabel:'厂商编号',
		width:220,
		name:'code'
	};

	var txtName = {
		xtype:'textfield',
		id:'txtName',
		fieldLabel:'厂商名称',
		width:220,
		name:'name'
	};	
	
	var txtAddress = {
		xtype:'textfield',
		id:'txtAddress',
		fieldLabel:'厂商地址',
		width:220,
		name:'address'
	};
	
	var txtCommAddress = {
		xtype:'textfield',
		id:'txtCommAddress',
		fieldLabel:'通讯地址',
		width:220,
		name:'commAddress'
	};
	
	var txtBank = {
		xtype:'textfield',
		id:'txtBank',
		fieldLabel:'开户银行',
		width:220,
		name:'bank'
	};
	
	var txtContract = {
		xtype:'textfield',
		id:'txtContract',
		fieldLabel:'合同号',
		width:220,
		name:'contract'
	};
	
	var txtAccount = {
		xtype:'textfield',
		id:'txtAccount',
		fieldLabel:'帐号',
		width:220,
		name:'account'
	};
	
	var txtTax = {
		xtype:'textfield',
		id:'txtTax',
		fieldLabel:'税号',
		width:220,
		name:'tax'
	};
	
	var txtZipCode = {
		xtype:'textfield',
		id:'txtZipCode',
		fieldLabel:'邮编',
		width:220,
		name:'zipCode'
	};
	
	var txtTele = {
		xtype:'textfield',
		id:'txtTele',
		fieldLabel:'电话号码',
		width:220,
		name:'Tele'
	};
	
	var txtDelegatee = {
		xtype:'textfield',
		id:'txtDelegatee',
		fieldLabel:'代表人',
		width:220,
		name:'delegatee'
	};
	
	var txtEmail = {
		xtype:'textfield',
		id:'txtEmail',
		fieldLabel:'电子邮件',
		width:220,
		name:'email'
	};
	
	var txtFax = {
		xtype:'textfield',
		id:'txtFax',
		fieldLabel:'传真号码',
		width:220,
		name:'fax'
	};
	
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'备注',
		width:220,
		name:'memo'
	};
	
	var loadCityHandler = function(combo,record,index){
		this.provinceItemStore.removeAll();
		this.cityStore.removeAll();
		Ext.getCmp('cbCity').setValue(null);	
		var id = Ext.getCmp('cbProvince').getValue();

		if (id){
			this.provinceItemStore.load({					
				params:{'id':id},
				callback:function(r,o,s){
					var rc = this.provinceItemStore.getAt(0);
					if (rc){
						this.cityStore.loadData(rc.json);
					}
				},
				scope:this
			});
		}
	};
	
	/*如果通过输入改变省，并且没有选中的情况下，需要将市的信息全部清空*/
	var blurHandle = function(field){
		var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvince').getValue());
		if (isEmptyProvince) {
			this.provinceItemStore.removeAll();
			this.cityStore.removeAll();
		}
	};
	
	var cbProvince = {
		xtype:'combo',
		store:this.provinceStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择',
		fieldLabel:'所在省',
		selectOnFocus:true,
		id:'cbProvince',
		valueField:'id',
		listeners:{'select':loadCityHandler,'blur':blurHandle,scope:this},
		width:220
	};	
	
	var focusHandler= function(field) {
		var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvince').getValue());
		if (this.cityStore.getCount()<1){
			if (isEmptyProvince){
				clsys.message.info('请先选择所在省');
			}			
		}
	};
	
	var cbCity = {
		xtype:'combo',
		store:this.cityStore,
		displayField:'name',
		typeAhead:true,
		mode:'local',
		forceSelection:true,
		triggerAction:'all',
		emptyText:'请选择',
		fieldLabel:'所在市',
		selectOnFocus:true,
		id:'cbCity',
		valueField:'id',
		listeners:{'focus':focusHandler,scope:this},
		width:220
	};	
	
	var col1 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtName,cbProvince,txtAddress,txtCommAddress,txtBank,txtContract]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtCode,cbCity,txtTax,txtZipCode,txtTele,txtDelegatee]		
	};
	
	/* 窗口中的按钮 */
	var btnSubmit = {
			text:'查询',
			iconCls: 'icon-examine',
			id:'company-selector-window-submit',
			handler:function(){
				var attributes = {
						id:this.companyID,
						name:Ext.getCmp('txtName').getValue(),
						code:Ext.getCmp('txtCode').getValue(),
						address:Ext.getCmp('txtAddress').getValue(),
						commAddress:Ext.getCmp('txtCommAddress').getValue(),
						bank:Ext.getCmp('txtBank').getValue(),
						contract:Ext.getCmp('txtContract').getValue(),
						tax:Ext.getCmp('txtTax').getValue(),
						zipCode:Ext.getCmp('txtZipCode').getValue(),
						tele:Ext.getCmp('txtTele').getValue(),
						delegatee:Ext.getCmp('txtDelegatee').getValue(),
						province:Ext.getCmp('cbProvince').getValue(),
						city:Ext.getCmp('cbCity').getValue()
					};
				/*更换查询条件的时候，需要指向第一页*/
				attributes.start = 0;
				this.companySelectorStore.reload({params:attributes});	
		},
			scope:this
		};
	
	var btnReset = {
		text:'重置',
		iconCls: 'icon-prop',
		id:'company-selector-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'关闭',
		iconCls: 'icon-remove',
		id:'company-selector-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};

	this.companySelectorGrid = {
			xtype:'grid',
			id:'company-selector-grid',
			store:this.companySelectorStore,
			stripeRows:true,
			autoScroll:true,
			height:230,
			width:880,
			loadMask:true,
			border:false,
			listeners:{
				dblclick:function(){
					/*只有选中资料时才可以操作*/
		  			var sm = Ext.getCmp('company-selector-grid').getSelectionModel();
		  			if (sm.getCount()<1) return;
		  			var attributes = {id:sm.getSelected().get('id')};
		  			this.fireEvent("companySelected",attributes);
				},
				scope:this},
			tbar:[btnSubmit,btnReset,btnCancel],
			colModel:new Ext.grid.ColumnModel({
				defaults:{sortable:true},
				columns:[
					{header:'厂商名称',width:200,dataIndex:'name'},
					{header:'代表人',width:40,dataIndex:'delegatee'},
					{header:'合同号',width:40,dataIndex:'contract'},
					{header:'省',width:30,dataIndex:'province'},
				    {header:'市',width:30,dataIndex:'city'}		
				]
			}),
			viewConfig:{forceFit:true},
			sm:new Ext.grid.RowSelectionModel({singleSelect:true})
	};
	
	
	this.companyForm = new Ext.form.FormPanel({
		id:'company-selector-window-form',
		autoWidth:true,
		frame:false,
		border:false,
		labelAlign:'right',
		items:[{		
			layout:'column',
			frame:false,
			border:false,
			items:[col1,col2]
		}]
	});
		
	/*设置窗口属性和含有控件*/
	eus.window.CompanySelector.superclass.constructor.call(this, {
		id:'company-selector-window',
		title:'厂商综合查询',
		buttonAlign:'center',
		height:500,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		items:[this.companyForm,this.companySelectorGrid]
	});
	/*添加窗口相应的事件*/
	this.addEvents({'companySelected':true});
};

var config = {
	/*重置*/
	reset:function(){
		var resetFunc = function(btn){
			if (btn == 'yes' && this.mode == 'add'){
				this.companyForm.getForm().reset();
				/*清除掉cbCity中的资料*/
				this.cityStore.removeAll();
				Ext.getCmp('cbCity').setValue(null);
			}
			if (this.mode == 'update'){
				this.open(this.companyID);
			}
		};
		Ext.MessageBox.show({
			titile:'确认重置', 
			buttons:Ext.MessageBox.YESNO,
			msg:'是否重置产品信息', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	/*只有新增的时需要auto-load*/
	doAutoReload:function(){
		this.initComponet();
		this.provinceStore.baseParams = {status:['Using']};
		this.provinceStore.reload();
	},
	initComponet:function(){
		Ext.Container.superclass.initComponent.call(this);
		this.add(clsys.form.Util.PagingToolbar(this.companySelectorStore, this.companyForm.bbar, 'companySelector-paging'))
	}
};

Ext.extend(eus.window.CompanySelector,Ext.Window,config);

Ext.reg('eus-company-selector-window',eus.window.CompanySelector);
