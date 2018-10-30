<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
<script type="text/javascript">
Ext.onReady(function(){
	var groupDS = new Ext.data.JsonStore({
		autoDestroy: true,
        autoLoad:true,
		url: 'userGroup.action',
		root: 'UserGroup',
		idProperty: 'id',
		fields: 
			['id', 'name', 'description']
	});
	
	var groupsGrid = new Ext.grid.GridPanel({
		title:'�û����б�',
		store: groupDS,
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
 			         { id: 'id', header: 'ID', sortable: true, dataIndex: 'id'},
 	  	            {id: 'name', header: '����', dataIndex: 'name'},
 	 	  	            {id: 'description', header:'����', dataIndex:'description'}
 	 	  	]
 		}),
 		listeners: {
 			'render': function(grpgrid) {
				grpgrid.getSelectionModel().on('selectionchange', function(model) {
					if (model.getSelected()) {
						userDS.removeAll();
						userDS.baseParams = {'groupId' :model.getSelected().id};
						userDS.load();
					}
				})
			}
		},
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
 	    //width: 400,
 	    autoHeight:true,
 	    border:true,
 	    renderTo: 'grouplist'
	});

	var userDS = new Ext.data.JsonStore({
		autoDestroy: true,
        //autoLoad:true,
		url: 'user.action',
		id: 'usergroup-datastore',
		root: 'Users',
		idProperty: 'id',
		fields: 
			[{name:'id', type:'int'}, 'name']		
	});
	
	var usersGrid = new Ext.grid.GridPanel({
		id: 'usersGrid',
		title:'�û��б�',
		store: userDS,
 		colModel: new Ext.grid.ColumnModel({
 	        defaults: {
 	            width: 120,
 	            sortable: true
 	        },
 	        columns: [
 			         { id: 'id', header: 'ID', sortable: true, dataIndex: 'id'},
 	  	            {id: 'name', header: '����', sortable: true, dataIndex: 'name'}
 	 	  	]
 		}),    
 		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
 	    //width: 400,
 	    autoHeight:true,
 	    border:true,
 	    renderTo: 'userlist'		
	});

	var groupPanel = new Ext.Panel({
		border:false,
		//layout: 'column',
		renderTo: 'userGroupPanel',
		tbar:[{
			text:'����û���'
		},{
			text:'ɾ���û���'
		},'-',{
			text:'����û�'
		},{
			text:'ɾ���û�'
		}],
		items: [groupsGrid, usersGrid ]
	});
});
</script>
</head>
<body>
<div id="userGroupPanel"></div>
<div id="grouplist">�û����б�</div>
<div id="userlist">�û��б�</div>
</body>
</html>