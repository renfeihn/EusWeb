
Ext.ns('clsys.message');

clsys.message.confirm = function(msg, fn, scope) {
	Ext.Msg.show({
		title: 'ȷ��',
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
		title: 'ɾ��ȷ��',
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
		title: '��ʾ',
		msg: msg,
		buttons: Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn: fn,
		scope: scope
	});
};

clsys.message.systemerror = function() {
	Ext.Msg.show({
		title: '����',
		msg: 'ϵͳ����.',
		icon: Ext.MessageBox.ERROR
	});
};

clsys.message.error = function(msg) {
	Ext.Msg.show({
		title: '����',
		msg: '����!<br/><b>��Ϣ</b>:' + msg,
		icon: Ext.MessageBox.ERROR
	});
};

clsys.message.info = function(msg) {
	Ext.Msg.show({
		title: '��ʾ',
		msg: msg,
		icon: Ext.MessageBox.INFO
	});
};