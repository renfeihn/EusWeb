
Ext.ns('is.form.SearchField');

is.form.SearchField = Ext.extend(Ext.form.TwinTriggerField, {
    initComponent : function(){
	    if(!this.store.baseParams){
			this.store.baseParams = {};
		}
	    is.form.SearchField.superclass.initComponent.call(this);
		this.on('specialkey', function(f, e){
	        if(e.getKey() == e.ENTER){
	            this.onTrigger2Click();
	        }
	    }, this);
	},

	tooltip: '输入查询条件,按回车或点击查询.',
	validationEvent:false,
	validateOnBlur:false,
	trigger1Class:'x-form-clear-trigger',
	trigger2Class:'x-form-search-trigger',
	hideTrigger1:true,
	width:180,
	hasSearch : false,
	paramName : 'search',
	
	onTrigger1Click : function(){
	    if(this.hasSearch) {
	    	this.store.baseParams = this.store.baseParams || {};
	        this.store.baseParams[this.paramName] = '';
	        var o = { start: 0 };
	        this.store.reload({params: o});
			this.el.dom.value = '';
	        this.triggers[0].hide();
	        this.hasSearch = false;
	    }
	},
	
	onTrigger2Click : function(){
	    var v = this.getRawValue();
	    if(v.length < 1){
	        this.onTrigger1Click();
	        return;
	    }
	    /*
		if(v.length < 2){
			Ext.Msg.alert('Invalid Search', 'You must enter a minimum of 2 characters to search the API');
			return;
		}
		*/
		this.store.baseParams = this.store.baseParams || {};
		this.store.baseParams[this.paramName] = v;
	    var o = {start: 0};
	    this.store.reload({params:o});
	    this.hasSearch = true;
	    this.triggers[0].show();
	}
});


Ext.reg('is-search-field', is.form.SearchField);