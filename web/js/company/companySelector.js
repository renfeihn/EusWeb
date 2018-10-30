Ext.ns('eus.window.CompanySelector');

eus.window.CompanySelector = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
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
		fieldLabel:'���̱��',
		width:220,
		name:'code'
	};

	var txtName = {
		xtype:'textfield',
		id:'txtName',
		fieldLabel:'��������',
		width:220,
		name:'name'
	};	
	
	var txtAddress = {
		xtype:'textfield',
		id:'txtAddress',
		fieldLabel:'���̵�ַ',
		width:220,
		name:'address'
	};
	
	var txtCommAddress = {
		xtype:'textfield',
		id:'txtCommAddress',
		fieldLabel:'ͨѶ��ַ',
		width:220,
		name:'commAddress'
	};
	
	var txtBank = {
		xtype:'textfield',
		id:'txtBank',
		fieldLabel:'��������',
		width:220,
		name:'bank'
	};
	
	var txtContract = {
		xtype:'textfield',
		id:'txtContract',
		fieldLabel:'��ͬ��',
		width:220,
		name:'contract'
	};
	
	var txtAccount = {
		xtype:'textfield',
		id:'txtAccount',
		fieldLabel:'�ʺ�',
		width:220,
		name:'account'
	};
	
	var txtTax = {
		xtype:'textfield',
		id:'txtTax',
		fieldLabel:'˰��',
		width:220,
		name:'tax'
	};
	
	var txtZipCode = {
		xtype:'textfield',
		id:'txtZipCode',
		fieldLabel:'�ʱ�',
		width:220,
		name:'zipCode'
	};
	
	var txtTele = {
		xtype:'textfield',
		id:'txtTele',
		fieldLabel:'�绰����',
		width:220,
		name:'Tele'
	};
	
	var txtDelegatee = {
		xtype:'textfield',
		id:'txtDelegatee',
		fieldLabel:'������',
		width:220,
		name:'delegatee'
	};
	
	var txtEmail = {
		xtype:'textfield',
		id:'txtEmail',
		fieldLabel:'�����ʼ�',
		width:220,
		name:'email'
	};
	
	var txtFax = {
		xtype:'textfield',
		id:'txtFax',
		fieldLabel:'�������',
		width:220,
		name:'fax'
	};
	
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'��ע',
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
	
	/*���ͨ������ı�ʡ������û��ѡ�е�����£���Ҫ���е���Ϣȫ�����*/
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
		emptyText:'��ѡ��',
		fieldLabel:'����ʡ',
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
				clsys.message.info('����ѡ������ʡ');
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
		emptyText:'��ѡ��',
		fieldLabel:'������',
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
	
	/* �����еİ�ť */
	var btnSubmit = {
			text:'��ѯ',
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
				/*������ѯ������ʱ����Ҫָ���һҳ*/
				attributes.start = 0;
				this.companySelectorStore.reload({params:attributes});	
		},
			scope:this
		};
	
	var btnReset = {
		text:'����',
		iconCls: 'icon-prop',
		id:'company-selector-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
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
					/*ֻ��ѡ������ʱ�ſ��Բ���*/
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
					{header:'��������',width:200,dataIndex:'name'},
					{header:'������',width:40,dataIndex:'delegatee'},
					{header:'��ͬ��',width:40,dataIndex:'contract'},
					{header:'ʡ',width:30,dataIndex:'province'},
				    {header:'��',width:30,dataIndex:'city'}		
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
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.CompanySelector.superclass.constructor.call(this, {
		id:'company-selector-window',
		title:'�����ۺϲ�ѯ',
		buttonAlign:'center',
		height:500,
		width:900,
		resizable:true,
		plain:true,
		autoScroll: true,
		items:[this.companyForm,this.companySelectorGrid]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'companySelected':true});
};

var config = {
	/*����*/
	reset:function(){
		var resetFunc = function(btn){
			if (btn == 'yes' && this.mode == 'add'){
				this.companyForm.getForm().reset();
				/*�����cbCity�е�����*/
				this.cityStore.removeAll();
				Ext.getCmp('cbCity').setValue(null);
			}
			if (this.mode == 'update'){
				this.open(this.companyID);
			}
		};
		Ext.MessageBox.show({
			titile:'ȷ������', 
			buttons:Ext.MessageBox.YESNO,
			msg:'�Ƿ����ò�Ʒ��Ϣ', 
			fn:resetFunc,
			icon:Ext.MessageBox.QUESTION,
			scope:this
		});
	},
	/*ֻ��������ʱ��Ҫauto-load*/
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
