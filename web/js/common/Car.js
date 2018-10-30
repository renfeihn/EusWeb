
/*-----------------------------------------------------
 * Car Information Window.
 */
Ext.ns('is.window.Car');

is.window.Car = function() {
	this.grid = new Ext.grid.PropertyGrid({
		stripeRows: true,
		autoHeight: true,
		viewConfig: {
			forceFit: true,
			scrollOffset: 2 
		},
		store: new Ext.data.JsonStore()
	});
	
	is.window.Car.superclass.constructor.call(this, {
		title: '������Ϣ',
		id: 'car-information-window',
		buttonAlign: 'center',
		width: 400,
		height: 400,
		plain:true,
		modal:true,
		items: [this.grid],
		buttons: [{
			text: '�ر�',
			handler: this.hide.createDelegate(this, [])
		}]
	});
};

Ext.extend(is.window.Car, Ext.Window, {
	open: function(record) {
		if (record) {
			this.grid.setSource({
				'״̬': record.get('status'),
				'��Ӧ��': record.json.supplier,
				'����': record.json.model,
				'��ɫ': record.json.color,
				'����': record.json.decoration,
				'���ܺ�': record.get('frame'),
				'��������': record.get('engine'),
				'�ϸ�֤': record.get('certificate'),
				'��ע': record.get('memo')
			});
		}
	}
});

Ext.reg('car-information-window', is.window.Car);
