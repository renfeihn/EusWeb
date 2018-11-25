<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
    <title>厂商管理</title>
    <script type="text/javascript" src="js/company/company.js"></script>
    <script type="text/javascript" src="js/company/companySearch.js"></script>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var companyStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findCompany.action',
                baseParams: {status: ['Using'], start: 0, limit: 25},
                totalProperty: 'results',
                root: 'CompanyList',
                idProperty: 'id',
                fields: ['id', 'code', 'name', 'address', 'commAddress', 'delegatee', 'contract', 'tele',
                    {name: 'province', mapping: 'province.name'},
                    {name: 'city', mapping: 'city.name'}]
            });

            var addNew = function () {
                var wnd = Ext.getCmp('company-window');
                if (!wnd) {
                    var wnd = new eus.window.Company();
                    wnd.on('companySaved', function (attr) {
                        companyStore.reload();
                    });
                }
                wnd.doAutoReload();
                wnd.show();
            };

            var Update = function () {
                /*只有选中资料时才可以进行修改操作*/
                var sm = Ext.getCmp('company-grid').getSelectionModel();
                if (sm.getCount() < 1) return;

                var companyID = sm.getSelected().get('id');
                var wnd = Ext.getCmp('company-window');
                if (!wnd) {
                    var wnd = new eus.window.Company();
                    wnd.on('companySaved', function (attr) {
                        companyStore.reload();
                    });
                }
                wnd.open(companyID);
                wnd.show();
            };

            var DeleteHandler = function (companyID) {
                var url = 'removeCompany.action';
                var params = {id: companyID};
                /*成功时的处理函数*/
                var successFunc = function (response, opts) {
                    var result = Ext.decode(response.responseText);
                    if (result.success) {
                        companyStore.reload();
                    }
                    else {
                        clsys.message.error(result.msg);
                    }
                };
                /*失败时的处理函数*/
                var failureFunc = function (response, opts) {
                    clsys.message.systemerror(response.responseText.msg);
                };
                /*使用AJAX完成请求*/
                Ext.Ajax.request({
                    url: url,
                    success: successFunc,
                    failure: failureFunc,
                    params: params,
                    scope: this
                });
            };

            var Delete = function () {
                var sm = Ext.getCmp('company-grid').getSelectionModel();
                if (sm.getCount() < 1) return;

                var companyID = sm.getSelected().get('id');
                var strName = sm.getSelected().get('name');
                var strMessage = '确定是否删除厂商名称为 [' + strName + '] 的厂商';

                clsys.message.confirmDelete(strMessage, function (buttonId) {
                    if (buttonId == 'yes') {
                        DeleteHandler(companyID);
                    }
                });
            };

            var companyGrid = {
                xtype: 'grid',
                id: 'company-grid',
                anchor: '100% 85%',
                store: companyStore,
                stripeRows: true,
                autoScroll: true,
                listeners: {dblclick: Update, scope: this},
                border: false,
                renderTo: 'companyGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '厂商名称', width: 200, dataIndex: 'name'},
                        {header: '代表人', width: 40, dataIndex: 'delegatee'},
                        {header: '合同号', width: 40, dataIndex: 'contract'},
                        {header: '厂商地址', width: 200, dataIndex: 'address'},
                        {header: '省', width: 30, dataIndex: 'province'},
                        {header: '市', width: 30, dataIndex: 'city'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var btnAddNew = {
                text: '新增厂商',
                iconCls: 'icon-add',
                handler: addNew,
                scope: this
            };

            var btnUpdate = {
                text: '修改厂商',
                iconCls: 'icon-prop',
                handler: Update,
                id: 'company-update',
                scope: this
            };

            var btnDelete = {
                text: '删除厂商',
                iconCls: 'icon-remove',
                handler: Delete,
                id: 'company-remove',
                scope: this
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    window.open('getcompanyAction.action');
                }
            };

            var btnRefresh = {
                text: '全部厂商',
                iconCls: 'icon-refresh',
                handler: function () {
                    companyStore.reload();
                },
                scope: this
            };

            var companyPanel = Ext.getCmp('CompanyInfoMan-mainpanel');
            companyPanel.add(companyGrid);
            companyPanel.getTopToolbar().add(btnAddNew, btnUpdate, btnDelete, {
                        text: '综合查询',
                        iconCls: 'icon-examine',
                        handler: function () {
                            var wnd = Ext.getCmp('company-search-window');
                            if (!wnd) {
                                var wnd = new eus.window.CompanySearch();
                                wnd.on('companySearching', function (attr) {
                                    /*更换查询条件的时候，需要指向第一页*/
                                    attr.start = 0;
                                    Console(attr);
                                    companyStore.reload({params: attr});
                                });
                            }
                            wnd.doAutoReload();
                            wnd.show();
                        },
                        scope: this
                    }, btnDown, '->',
                    {
                        xtype: 'is-search-field',
                        emptyText: '输入条件',
                        width: 300,
                        store: companyStore
                    });
            clsys.form.Util.PagingToolbar(companyStore, companyPanel.bbar, 'company-paging');
            companyPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="companyPanel"></div>
<div id="companyGridPanel"></div>
</body>
</html>