Ext.ns('eus.window.Company');

eus.window.Company = function() {
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
		allowBlank:false,
		blankText:'�����볧�̱��',
		width:220,
		name:'txtCode'
	};

	var txtName = {
		xtype:'textfield',
		id:'txtName',
		fieldLabel:'��������',
		allowBlank:false,
		blankText:'�����볧������',
		width:220,
		name:'txtName'
	};	
	
	var txtAddress = {
		xtype:'textfield',
		id:'txtAddress',
		fieldLabel:'���̵�ַ',
		width:220,
		name:'txtAddress'
	};
	
	var txtCommAddress = {
		xtype:'textfield',
		id:'txtCommAddress',
		fieldLabel:'ͨѶ��ַ',
		width:220,
		name:'txtCommAddress'
	};
	
	var txtBank = {
		xtype:'textfield',
		id:'txtBank',
		fieldLabel:'��������',
		width:220,
		name:'txtBank'
	};
	
	var txtContract = {
		xtype:'textfield',
		id:'txtContract',
		fieldLabel:'��ͬ��',
		width:220,
		name:'txtContract'
	};
	
	var txtAccount = {
		xtype:'textfield',
		id:'txtAccount',
		fieldLabel:'�ʺ�',
		width:220,
		name:'txtAccount'
	};
	
	var txtTax = {
		xtype:'textfield',
		id:'txtTax',
		fieldLabel:'˰��',
		width:220,
		name:'txtTax'
	};
	
	var txtZipCode = {
		xtype:'textfield',
		id:'txtZipCode',
		fieldLabel:'�ʱ�',
		width:220,
		name:'txtZipCode'
	};
	
	var txtTele = {
		xtype:'textfield',
		id:'txtTele',
		fieldLabel:'�绰����',
		width:220,
		name:'txtTele'
	};
	
	var txtDelegatee = {
		xtype:'textfield',
		id:'txtDelegatee',
		fieldLabel:'������',
		width:220,
		name:'txtDelegatee'
	};
	
	var txtEmail = {
		xtype:'textfield',
		id:'txtEmail',
		fieldLabel:'�����ʼ�',
		width:220,
		name:'txtEmail'
	};
	
	var txtFax = {
		xtype:'textfield',
		id:'txtFax',
		fieldLabel:'�������',
		width:220,
		name:'txtFax'
	};
	
	var txtMemo = {
		xtype:'textfield',
		id:'txtMemo',
		fieldLabel:'��ע',
		width:220,
		name:'txtMemo'
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
		allowBlank:false,
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
		allowBlank:false,
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
	
	this.companyForm = new Ext.form.FormPanel({
		id:'company-window-form',
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
		text:'����',
		id:'company-window-submit',
		handler:this.upsert,
		scope:this
	};
	
	var btnReset = {
		text:'����',
		id:'company-window-reset',
		handler:this.reset,
		scope:this		
	};
	
	var btnCancel = {
		text:'�ر�',
		id:'company-window-cancel',
		handler:this.destroy.createDelegate(this,[]),
		scope:this		
	};
		
	/*���ô������Ժͺ��пؼ�*/
	eus.window.Company.superclass.constructor.call(this, {
		id:'company-window',
		title:'��������',
		buttonAlign:'center',
		autoHeight:true,
		width:750,
		resizable:true,
		plain:true,
		autoScroll: true,
		buttons:[btnSubmit,btnReset,btnCancel],
		items:[this.companyForm]
	});
	/*��Ӵ�����Ӧ���¼�*/
	this.addEvents({'companySaved':true});
};

var config = {
	/*�������޸�*/
	upsert:function(){
		if (!this.companyForm.getForm().isValid()) return;
		var url = this.mode == 'add' ? 'addCompany.action' : 'updateCompany.action';
		var params = {
			id:this.companyID,
			name:Ext.getCmp('txtName').getValue(),
			code:Ext.getCmp('txtCode').getValue(),
			address:Ext.getCmp('txtAddress').getValue(),
			commAddress:Ext.getCmp('txtCommAddress').getValue(),
			bank:Ext.getCmp('txtBank').getValue(),
			contract:Ext.getCmp('txtContract').getValue(),
			account:Ext.getCmp('txtAccount').getValue(),
			tax:Ext.getCmp('txtTax').getValue(),
			zipCode:Ext.getCmp('txtZipCode').getValue(),
			tele:Ext.getCmp('txtTele').getValue(),
			delegatee:Ext.getCmp('txtDelegatee').getValue(),
			email:Ext.getCmp('txtEmail').getValue(),
			fax:Ext.getCmp('txtFax').getValue(),
			memo:Ext.getCmp('txtMemo').getValue(),
			province:Ext.getCmp('cbProvince').getValue(),
			city:Ext.getCmp('cbCity').getValue()
		};
		
		this.companyForm.getForm().submit({
			url: url,
			params:params,
			success:function(form, action) {
				this.fireEvent('companySaved',{});
				this.destroy();
			},
			failure:function(form, action) {
				clsys.message.error(action.result.msg);
			},
			waitMsg: '�����ύ���ݣ����Ժ�...',
			scope: this
		});
	},
	/*�޸�ʱ�򿪴���*/
	open:function(companyID){
		
		this.companyID = companyID;
		this.mode = 'update';
		this.title = '�޸ĳ���';
		
		var callbackFunc = function(){
			if (this.companyStore.getCount()<1) return;
			var record = this.companyStore.getAt(0);
			Ext.getCmp('txtName').setValue(record.get('name'));
			Ext.getCmp('txtCode').setValue(record.get('code'));
			Ext.getCmp('txtAddress').setValue(record.get('address'));
			Ext.getCmp('txtCommAddress').setValue(record.get('commAddress'));
			Ext.getCmp('txtBank').setValue(record.get('bank'));
			Ext.getCmp('txtContract').setValue(record.get('contract'));
			Ext.getCmp('txtAccount').setValue(record.get('account'));
			Ext.getCmp('txtTax').setValue(record.get('tax'));
			Ext.getCmp('txtZipCode').setValue(record.get('zipCode'));
			Ext.getCmp('txtTele').setValue(record.get('tele'));
			Ext.getCmp('txtDelegatee').setValue(record.get('delegatee'));
			Ext.getCmp('txtEmail').setValue(record.get('email'));
			Ext.getCmp('txtFax').setValue(record.get('fax'));
			Ext.getCmp('txtMemo').setValue(record.get('memo'));
			/*ʡ���е�����*/
			clsys.form.Util.updateCombo('cbProvince',record.json.province.id);
			this.provinceItemStore.removeAll();
			this.provinceItemStore.load({					
				params:{'id':record.json.province.id},
				callback:function(r,o,s){
					var rc = this.provinceItemStore.getAt(0);
					if (rc){
						this.cityStore.loadData(rc.json);
						Ext.getCmp('cbCity').setValue(record.json.city.id);
					}
				},
				scope:this
			});
		};

		this.companyStore.load({
			params:{id:companyID},
			callback:callbackFunc,
			scope:this
		});
	},
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
		this.provinceStore.baseParams = {status:['Using']};
		this.provinceStore.reload();
	}
};

Ext.extend(eus.window.Company,Ext.Window,config);

Ext.reg('eus-company-window',eus.window.Company);
