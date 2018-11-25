<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
    <title>���̹���</title>
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
                /*ֻ��ѡ������ʱ�ſ��Խ����޸Ĳ���*/
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
                /*�ɹ�ʱ�Ĵ�����*/
                var successFunc = function (response, opts) {
                    var result = Ext.decode(response.responseText);
                    if (result.success) {
                        companyStore.reload();
                    }
                    else {
                        clsys.message.error(result.msg);
                    }
                };
                /*ʧ��ʱ�Ĵ�����*/
                var failureFunc = function (response, opts) {
                    clsys.message.systemerror(response.responseText.msg);
                };
                /*ʹ��AJAX�������*/
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
                var strMessage = 'ȷ���Ƿ�ɾ����������Ϊ [' + strName + '] �ĳ���';

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
                        {header: '��������', width: 200, dataIndex: 'name'},
                        {header: '������', width: 40, dataIndex: 'delegatee'},
                        {header: '��ͬ��', width: 40, dataIndex: 'contract'},
                        {header: '���̵�ַ', width: 200, dataIndex: 'address'},
                        {header: 'ʡ', width: 30, dataIndex: 'province'},
                        {header: '��', width: 30, dataIndex: 'city'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var btnAddNew = {
                text: '��������',
                iconCls: 'icon-add',
                handler: addNew,
                scope: this
            };

            var btnUpdate = {
                text: '�޸ĳ���',
                iconCls: 'icon-prop',
                handler: Update,
                id: 'company-update',
                scope: this
            };

            var btnDelete = {
                text: 'ɾ������',
                iconCls: 'icon-remove',
                handler: Delete,
                id: 'company-remove',
                scope: this
            };

            var btnDown = {
                text: 'Excel����',
                iconCls: 'icon-down',
                handler: function () {
                    window.open('getcompanyAction.action');
                }
            };

            var btnRefresh = {
                text: 'ȫ������',
                iconCls: 'icon-refresh',
                handler: function () {
                    companyStore.reload();
                },
                scope: this
            };

            var companyPanel = Ext.getCmp('CompanyInfoMan-mainpanel');
            companyPanel.add(companyGrid);
            companyPanel.getTopToolbar().add(btnAddNew, btnUpdate, btnDelete, {
                        text: '�ۺϲ�ѯ',
                        iconCls: 'icon-examine',
                        handler: function () {
                            var wnd = Ext.getCmp('company-search-window');
                            if (!wnd) {
                                var wnd = new eus.window.CompanySearch();
                                wnd.on('companySearching', function (attr) {
                                    /*������ѯ������ʱ����Ҫָ���һҳ*/
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
                        emptyText: '��������',
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