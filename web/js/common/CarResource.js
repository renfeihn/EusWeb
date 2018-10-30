
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
		title: '车辆信息',
		id: 'car-information-window',
		buttonAlign: 'center',
		width: 400,
		height: 400,
		plain:true,
		modal:true,
		items: [this.grid],
		buttons: [{
			text: '关闭',
			handler: this.hide.createDelegate(this, [])
		}]
	});
};

Ext.extend(is.window.Car, Ext.Window, {
	open: function(record) {
		if (record) {
			this.grid.setSource({
				'状态': record.get('status'),
				'供应商': record.json.supplier,
				'车型': record.json.model,
				'颜色': record.json.color,
				'内饰': record.json.decoration,
				'车架号': record.get('frame'),
				'发动机号': record.get('engine'),
				'合格证': record.get('certificate'),
				'备注': record.get('memo')
			});
		}
	}
});

Ext.reg('car-information-window', is.window.Car);
