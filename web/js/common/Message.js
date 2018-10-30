
Ext.ns('clsys.message');

clsys.message.confirm = function(msg, fn, scope) {
	Ext.Msg.show({
		title: '确认',
		msg: msg,
		buttons: Ext.Msg.YESNOCANCEL,
		icon: Ext.MessageBox.QUESTION,
		fn: fn,
		scope: scope
	});
};

/* Added by Roec Luo 2010-06-09*/
clsys.message.confirmDelete = function(msg, fn, scope) {
	Ext.Msg.show({
		title: '删除确认',
		msg: msg,
		buttons: Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn: fn,
		scope: scope
	});
};
/* Added by Roec Luo 2010-06-30*/
clsys.message.confirmInfo = function(msg, fn, scope) {
	Ext.Msg.show({
		title: '提示',
		msg: msg,
		buttons: Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn: fn,
		scope: scope
	});
};

clsys.message.systemerror = function() {
	Ext.Msg.show({
		title: '错误',
		msg: '系统错误.',
		icon: Ext.MessageBox.ERROR
	});
};

clsys.message.error = function(msg) {
	Ext.Msg.show({
		title: '错误',
		msg: '错误!<br/><b>消息</b>:' + msg,
		icon: Ext.MessageBox.ERROR
	});
};

clsys.message.info = function(msg) {
	Ext.Msg.show({
		title: '提示',
		msg: msg,
		icon: Ext.MessageBox.INFO
	});
};