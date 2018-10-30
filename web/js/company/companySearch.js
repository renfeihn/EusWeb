Ext.ns('eus.window.CompanySearch');

eus.window.CompanySearch = function() {
	/*�ṩ������޸����ֲ�����Ĭ��Ϊ�������*/
	this.mode = 'add';
	this.companyID = '';
	
	this.provinceStore = new Ext.data.JsonStore({
		autoDestroy:true,
		url:'findProvince.action',
		baseParams:{status:['Using']},
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
		items:[txtName,cbProvince,txtAddress,txtCommAddress,txtBank,txtContract,txtAccount,txtFax]		
	};
	
	var col2 = {
		columnWidth: .5,
		layout: 'form',
		frame: false,
		border: false,
		defaultType: 'textfield',
		items:[txtCode,cbCity,txtTax,txtZipCode,txtTele,txtDelegatee,txtEmail,txtMemo]		
	};
	
	this.companySearchForm = new Ext.form.FormPanel({
		id:'company-search-search-window-form',
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
	
	/* �����еİ�ť */
	var btnSubmit = {
		text:'��ѯ',
		id:'company-search-window-submit',
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
			this.fireEvent('companySearching',attributes);
		},
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'company-search-window-reset',
		handler:function(){this.companySearchForm.getForm().reset();},
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'company-search-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.CompanySearch.superclass.constructor.call(this, {
		id:'company-search-window',
		title:'�����ۺϲ�ѯ',
		buttonAlign:'center',
		autoHeight:true,
		width:750,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.companySearchForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'companySearching':true});
};

var config = {
	/*ֻ��������ʱ��Ҫauto-load*/
	doAutoReload:function(){
		this.provinceStore.baseParams = {status:['Using']};
		this.provinceStore.reload();
	}
};

Ext.extend(eus.window.CompanySearch,Ext.Window,config);

Ext.reg('eus-company-search-window',eus.window.CompanySearch);
