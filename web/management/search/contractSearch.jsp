<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>合同查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var contractSearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'queryContract.action',
                totalProperty: 'results',
                root: 'ContractList',
                baseParams: {status: ['Using'], start: 0, limit: 25},
                idProperty: 'id',
                fields: ['id', 'contractNo', 'contractDate', 'items', 'status', 'state', 'createTime',
                    'totalFinishedAmount', 'totalCheckingAmount', 'totalAmount', 'totalSum',
                    {name: 'company', mapping: 'company.name'},
                    {name: 'empName', mapping: 'creator.name'},
                    {name: 'empCode', mapping: 'creator.code'}],
                sortInfo: {field: 'createTime', direction: 'ASC'}
            });

            var contractGetItemsStore = new Ext.data.JsonStore({
                url: 'getContract.action',
                root: 'Contract',
                fields: ['id', 'items']
            });

            var contractSearchItemsStore = new Ext.data.JsonStore({
                autoDestroy: true,
                root: 'items',
                fields: ['id', 'amount', 'price', 'originalPrice', 'subTotal', 'finishedAmount', 'checkingAmount',
                    {name: 'contractItemNo', type: 'int'},
                    {name: 'productCombination', mapping: 'product.productCombination'}],
                sortInfo: {field: 'contractItemNo', direction: 'ASC'}
            });

            var provinceStoreForContractSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findProvince.action',
                autoLoad: {status: ['Using']},
                baseParams: {status: ['Using']},
                root: 'ProvinceList',
                fields: ['id', 'name']
            });

            var provinceItemStoreForContractSearch = new Ext.data.JsonStore({
                url: 'getProvince.action',
                root: 'Province',
                fields: ['id', 'cities']
            });

            var cityStoreForContractSearch = new Ext.data.JsonStore({
                root: 'cities',
                fields: ['id', 'name']
            });

            var companyStoreForContractSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'getCompany.action',
                baseParams: {status: 'Using'},
                root: 'Company',
                fields: ['id', 'code', 'name', 'address', 'commAddress',
                    'bank', 'contract', 'account', 'tax',
                    'zipCode', 'tele', 'delegatee', 'email', 'fax', 'memo']
            });

            var txtCodeForContractSearch = {
                xtype: 'textfield',
                id: 'txtCodeForContractSearch',
                fieldLabel: '厂商编号',
                width: 220,
                name: 'txtCodeForContractSearch'
            };

            var txtNameForContractSearch = {
                xtype: 'textfield',
                id: 'txtNameForContractSearch',
                fieldLabel: '厂商名称',
                width: 220,
                name: 'txtNameForContractSearch'
            };

            var txtAddressForContractSearch = {
                xtype: 'textfield',
                id: 'txtAddressForContractSearch',
                fieldLabel: '厂商地址',
                width: 220,
                name: 'txtAddressForContractSearch'
            };

            var txtCommAddressForContractSearch = {
                xtype: 'textfield',
                id: 'txtCommAddressForContractSearch',
                fieldLabel: '通讯地址',
                width: 220,
                name: 'txtCommAddressForContractSearch'
            };

            var txtBankForContractSearch = {
                xtype: 'textfield',
                id: 'txtBankForContractSearch',
                fieldLabel: '开户银行',
                width: 220,
                name: 'txtBankForContractSearch'
            };

            var txtContractForContractSearch = {
                xtype: 'textfield',
                id: 'txtContractForContractSearch',
                fieldLabel: '合同号',
                width: 220,
                name: 'txtContractForContractSearch'
            };

            var txtAccountForContractSearch = {
                xtype: 'textfield',
                id: 'txtAccountForContractSearch',
                fieldLabel: '帐号',
                width: 220,
                name: 'txtAccountForContractSearch'
            };

            var txtTaxForContractSearch = {
                xtype: 'textfield',
                id: 'txtTaxForContractSearch',
                fieldLabel: '税号',
                width: 220,
                name: 'txtTaxForContractSearch'
            };

            var txtZipCodeForContractSearch = {
                xtype: 'textfield',
                id: 'txtZipCodeForContractSearch',
                fieldLabel: '邮编',
                width: 220,
                name: 'txtZipCodeForContractSearch'
            };

            var txtTeleForContractSearch = {
                xtype: 'textfield',
                id: 'txtTeleForContractSearch',
                fieldLabel: '电话号码',
                width: 220,
                name: 'txtTeleForContractSearch'
            };

            var txtDelegateeForContractSearch = {
                xtype: 'textfield',
                id: 'txtDelegateeForContractSearch',
                fieldLabel: '代表人',
                width: 220,
                name: 'txtDelegateeForContractSearch'
            };

            var txtEmailForContractSearch = {
                xtype: 'textfield',
                id: 'txtEmailForContractSearch',
                fieldLabel: '电子邮件',
                width: 220,
                name: 'txtEmailForContractSearch'
            };

            var txtFaxForContractSearch = {
                xtype: 'textfield',
                id: 'txtFaxForContractSearch',
                fieldLabel: '传真号码',
                width: 220,
                name: 'txtFaxForContractSearch'
            };

            var txtMemoForContractSearch = {
                xtype: 'textfield',
                id: 'txtMemoForContractSearch',
                fieldLabel: '备注',
                width: 220,
                name: 'txtMemoForContractSearch'
            };

            var loadCityHandler = function (combo, record, index) {
                provinceItemStoreForContractSearch.removeAll();
                cityStoreForContractSearch.removeAll();
                Ext.getCmp('cbCityForContractSearch').setValue(null);
                var id = Ext.getCmp('cbProvinceForContractSearch').getValue();

                if (id) {
                    provinceItemStoreForContractSearch.load({
                        params: {'id': id},
                        callback: function (r, o, s) {
                            var rc = provinceItemStoreForContractSearch.getAt(0);
                            if (rc) {
                                cityStoreForContractSearch.loadData(rc.json);
                            }
                        },
                        scope: this
                    });
                }
            };

            /*如果通过输入改变省，并且没有选中的情况下，需要将市的信息全部清空*/
            var blurHandle = function (field) {
                var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvinceForContractSearch').getValue());
                if (isEmptyProvince) {
                    provinceItemStoreForContractSearch.removeAll();
                    cityStoreForContractSearch.removeAll();
                }
            };

            var cbProvinceForContractSearch = {
                xtype: 'combo',
                store: provinceStoreForContractSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择',
                fieldLabel: '所在省',
                selectOnFocus: true,
                id: 'cbProvinceForContractSearch',
                valueField: 'id',
                listeners: {'select': loadCityHandler, 'blur': blurHandle, scope: this},
                width: 220
            };

            var focusHandler = function (field) {
                var isEmptyProvince = Ext.isEmpty(Ext.getCmp('cbProvinceForContractSearch').getValue());
                if (cityStoreForContractSearch.getCount() < 1) {
                    if (isEmptyProvince) {
                        clsys.message.info('请先选择所在省');
                    }
                }
            };

            var cbCityForContractSearch = {
                xtype: 'combo',
                store: cityStoreForContractSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择',
                fieldLabel: '所在市',
                selectOnFocus: true,
                id: 'cbCityForContractSearch',
                valueField: 'id',
                listeners: {'focus': focusHandler, scope: this},
                width: 220
            };

            var txtContractForContractSearchDateStart = {
                xtype: 'datefield',
                id: 'txtContractForContractSearchDateStart',
                fieldLabel: '交货日期(开始)',
                width: 220,
                name: 'txtContractForContractSearchDateStart'
            };

            var txtContractForContractSearchDateEnd = {
                xtype: 'datefield',
                id: 'txtContractForContractSearchDateEnd',
                fieldLabel: '交货日期(结束)',
                width: 220,
                name: 'txtContractForContractSearchDateEnd'
            };

            var txtContractForContractSearchSavedDateStart = {
                xtype: 'datefield',
                id: 'txtContractForContractSearchSavedDateStart',
                fieldLabel: '保存日期(开始)',
                width: 220,
                name: 'txtContractForContractSearchSavedDateStart'
            };

            var txtContractForContractSearchSavedDateEnd = {
                xtype: 'datefield',
                id: 'txtContractForContractSearchSavedDateEnd',
                fieldLabel: '保存日期(结束)',
                width: 220,
                name: 'txtContractForContractSearchSavedDateEnd'
            };

            var txtContractForContractSearchMin = {
                xtype: 'numberfield',
                id: 'txtContractForContractSearchMin',
                fieldLabel: '金额范围(最小)',
                width: 220,
                allowDecimals: true, // 允许小数点
                allowNegative: false, // 允许负数
                minValue: 0.00,
                allowBlank: false,
                name: 'txtContractForContractSearchMin'
            };

            var txtContractForContractSearchMax = {
                xtype: 'numberfield',
                id: 'txtContractForContractSearchMax',
                fieldLabel: '金额范围(最大)',
                width: 220,
                allowDecimals: true, // 允许小数点
                allowNegative: false, // 允许负数
                minValue: 0.00,
                allowBlank: false,
                name: 'txtContractForContractSearchMax'
            };

            var cbContractState = {
                xtype: 'combo',
                id: 'cbContractState',
                emptyText: '请选择合同状态',
                fieldLabel: '合同状态',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['', '全部状态'],
                        ['Saved', '已保存'],
                        ['WaitForAduilt', '待审核'],
                        ['AduitFailed', '审核失败'],
                        ['None', '未完成'],
                        ['Part', '部分完成'],
                        ['Complete', '全部完成'],
                        ['Terminated', '终止']
                    ]
                }),
                mode: 'local',
                triggerAction: 'all',
                displayField: 'name',
                valueField: 'id',
                width: 220,
                selectOnFocus: true,
                forceSelection: true,
                editable: true
            };

            var cbContractStatus = {
                xtype: 'combo',
                id: 'cbContractStatus',
                emptyText: '请选择合同是否作废',
                fieldLabel: '是否作废',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['', '全部'],
                        ['Using', '有效'],
                        ['Deleted', '作废']
                    ]
                }),
                mode: 'local',
                triggerAction: 'all',
                displayField: 'name',
                valueField: 'id',
                width: 220,
                selectOnFocus: true,
                forceSelection: true,
                editable: true
            };

            var col1 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [txtNameForContractSearch, cbProvinceForContractSearch, txtAddressForContractSearch, txtCommAddressForContractSearch, txtBankForContractSearch, txtContractForContractSearch, txtContractForContractSearchDateStart, txtContractForContractSearchDateEnd, cbContractStatus, txtContractForContractSearchMin]
            };

            var col2 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [txtCodeForContractSearch, cbCityForContractSearch, txtTaxForContractSearch, txtZipCodeForContractSearch, txtTeleForContractSearch, txtDelegateeForContractSearch, txtContractForContractSearchSavedDateStart, txtContractForContractSearchSavedDateEnd, cbContractState, txtContractForContractSearchMax]
            };

            var showItems = function (sm) {
                Ext.getCmp('contract-search-showitems-button').setDisabled(sm.getCount() < 1);
                contractGetItemsStore.removeAll();
                contractSearchItemsStore.removeAll();

                /*如果详细数据的GridPanel是隐藏的，则不进行细节信息查询*/
                if (Ext.getCmp('contractSearchItems-grid').hidden) return;

                if (sm.getCount() > 0) {
                    var record = sm.getSelected();
                    if (record) {
                        var id = record.get('id');
                        contractGetItemsStore.reload({
                            params: {'id': id},
                            callback: function (r, o, s) {
                                var rc = contractGetItemsStore.getAt(0);
                                if (rc) {
                                    contractSearchItemsStore.loadData(rc.json);
                                }
                            },
                            scope: this
                        });

                    }
                }
            };

            var btnShowItems = {
                text: '详细信息',
                id: 'contract-search-showitems-button',
                iconCls: 'icon-preview',
                enableToggle: true,
                disabled: true,
                scope: this,
                toggleHandler: function (btn, pressed) {
                    var preview = Ext.getCmp('contractSearchItems-grid');
                    if (pressed) {
                        preview.show();
                        showItems(Ext.getCmp('contractSearch-grid').getSelectionModel());
                    } else {
                        preview.hide();
                    }
                    contractSearchPanel.doLayout();
                }
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        companyName: encodeURI(Ext.getCmp('txtNameForContractSearch').getValue()),
                        companyCode: encodeURI(Ext.getCmp('txtCodeForContractSearch').getValue()),
                        companyAddress: encodeURI(Ext.getCmp('txtAddressForContractSearch').getValue()),
                        companyCommAddress: encodeURI(Ext.getCmp('txtCommAddressForContractSearch').getValue()),
                        companyBank: encodeURI(Ext.getCmp('txtBankForContractSearch').getValue()),
                        companyTax: encodeURI(Ext.getCmp('txtTaxForContractSearch').getValue()),
                        companyZipCode: encodeURI(Ext.getCmp('txtZipCodeForContractSearch').getValue()),
                        companyTele: encodeURI(Ext.getCmp('txtTeleForContractSearch').getValue()),
                        companyDelegatee: encodeURI(Ext.getCmp('txtDelegateeForContractSearch').getValue()),
                        companyProvince: Ext.getCmp('cbProvinceForContractSearch').getValue(),
                        companyCity: Ext.getCmp('cbCityForContractSearch').getValue(),
                        contractNo: encodeURI(Ext.getCmp('txtContractForContractSearch').getValue()),
                        contractDateStart: Ext.getCmp('txtContractForContractSearchDateStart').getValue(),
                        contractDateEnd: Ext.getCmp('txtContractForContractSearchDateEnd').getValue(),
                        status: encodeURI(Ext.getCmp('cbContractStatus').getValue()),
                        states: encodeURI(Ext.getCmp('cbContractState').getValue()),
                        contractSavedDateStart: Ext.getCmp('txtContractForContractSearchSavedDateStart').getValue(),
                        contractSavedDateEnd: Ext.getCmp('txtContractForContractSearchSavedDateEnd').getValue(),
                        min: encodeURI(Ext.getCmp('txtContractForContractSearchMin').getValue()),
                        max: encodeURI(Ext.getCmp('txtContractForContractSearchMax').getValue())
                    };

                    //如果不存在一个id为"downForm"的form表单，则执行下面的操作
                    if (!Ext.fly('downForm')) {

                        //下面代码是在创建一个表单以及添加相应的一些属性
                        var downForm = document.createElement('form');  //创建一个form表单
                        downForm.id = 'downForm'; 　　//该表单的id为downForm
                        downForm.name = 'downForm';  //该表单的name属性为downForm
                        downForm.className = 'x-hidden'; //该表单为隐藏的
//                        downForm.action = 'getcontractAction.action'; //表单的提交地址
                        downForm.method = 'POST';  //表单的提交方法

                        document.body.appendChild(downForm); //将form表单追加到body里面
                    }

                    Ext.Ajax.request({
                        disableCaching: true,
                        url: 'getcontractAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm'),
                        params: attributes
                    });
                }
            };
            var contractSearchItemsGrid = {
                xtype: 'grid',
                id: 'contractSearchItems-grid',
                anchor: '100% 35%',
                store: contractSearchItemsStore,
                stripeRows: true,
                autoScroll: true,
                hidden: true,
                loadMask: true,
                border: false,
                frame: true,
                renderTo: 'contractSearchItemsPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '序号', width: 30, dataIndex: 'contractItemNo'},
                        {header: '产品名称及型号', width: 250, dataIndex: 'productCombination'},
                        {header: '合同数量', width: 70, dataIndex: 'amount'},
                        {header: '完成数量', width: 40, dataIndex: 'finishedAmount'},
                        {header: '审核数量', width: 40, dataIndex: 'checkingAmount'},
                        {header: '合同价格', width: 70, dataIndex: 'price'},
                        {header: '原始价格', width: 70, dataIndex: 'originalPrice'},
                        {header: '金额小计', width: 70, dataIndex: 'subTotal'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true}),
                tbar: ['<b>预览</b>', {
                    iconCls: 'icon-remove',
                    text: '关闭预览',
                    handler: function () {
                        Ext.getCmp('contract-search-showitems-button').toggle();
                    }
                }]
            };

            var contractSearchGrid = {
                xtype: 'grid',
                id: 'contractSearch-grid',
                anchor: '100% 65%',
                store: contractSearchStore,
                stripeRows: true,
                autoScroll: true,
                border: false,
                frame: true,
                renderTo: 'contractSearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '合同号', width: 120, dataIndex: 'contractNo'},
                        {header: '保存时间', width: 120, dataIndex: 'createTime', hidden: true},
                        {header: '合同厂商', width: 150, dataIndex: 'company'},
                        {header: '数量总计', width: 50, dataIndex: 'totalAmount'},
                        {header: '完成总计', width: 50, dataIndex: 'totalFinishedAmount'},
                        {header: '审核总计', width: 50, dataIndex: 'totalCheckingAmount'},
                        {header: '金额总计', width: 50, dataIndex: 'totalSum'},
                        {header: '交货期', width: 80, dataIndex: 'contractDate'},
                        {header: '人员编号', width: 70, dataIndex: 'empCode', hidden: true},
                        {header: '姓名', width: 50, dataIndex: 'empName', hidden: true},
                        {
                            header: '有效',
                            width: 50,
                            dataIndex: 'status',
                            renderer: clsys.grid.columnrender.ContractDeletedRender
                        },
                        {
                            header: '状态',
                            width: 50,
                            renderer: clsys.grid.columnrender.ScheduleStatusRender,
                            dataIndex: 'state'
                        }
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var contractQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'contractQueryConditionPanel',
                items: [{
                    layout: 'column',
                    frame: false,
                    border: false,
                    items: [col1, col2]
                }],
                buttonAlign: 'left',
                buttons: [{
                    text: '查询',
                    iconCls: 'icon-examine',
                    handler: function () {
                        var attributes = {
                            companyName: Ext.getCmp('txtNameForContractSearch').getValue(),
                            companyCode: Ext.getCmp('txtCodeForContractSearch').getValue(),
                            companyAddress: Ext.getCmp('txtAddressForContractSearch').getValue(),
                            companyCommAddress: Ext.getCmp('txtCommAddressForContractSearch').getValue(),
                            companyBank: Ext.getCmp('txtBankForContractSearch').getValue(),
                            companyTax: Ext.getCmp('txtTaxForContractSearch').getValue(),
                            companyZipCode: Ext.getCmp('txtZipCodeForContractSearch').getValue(),
                            companyTele: Ext.getCmp('txtTeleForContractSearch').getValue(),
                            companyDelegatee: Ext.getCmp('txtDelegateeForContractSearch').getValue(),
                            companyProvince: Ext.getCmp('cbProvinceForContractSearch').getValue(),
                            companyCity: Ext.getCmp('cbCityForContractSearch').getValue(),
                            contractNo: Ext.getCmp('txtContractForContractSearch').getValue(),
                            contractDateStart: Ext.getCmp('txtContractForContractSearchDateStart').getValue(),
                            contractDateEnd: Ext.getCmp('txtContractForContractSearchDateEnd').getValue(),
                            status: Ext.getCmp('cbContractStatus').getValue(),
                            states: Ext.getCmp('cbContractState').getValue(),
                            contractSavedDateStart: Ext.getCmp('txtContractForContractSearchSavedDateStart').getValue(),
                            contractSavedDateEnd: Ext.getCmp('txtContractForContractSearchSavedDateEnd').getValue(),
                            min: Ext.getCmp('txtContractForContractSearchMin').getValue(),
                            max: Ext.getCmp('txtContractForContractSearchMax').getValue()
                        };
                        attributes.start = 0;
                        contractSearchStore.reload({params: attributes});
                    }
                }, {
                    text: '打印',
                    iconCls: 'icon-printer',
                    handler: function () {
                        var url = 'printContract.action';
                        var params = {
                            companyName: Ext.getCmp('txtNameForContractSearch').getValue(),
                            companyCode: Ext.getCmp('txtCodeForContractSearch').getValue(),
                            companyAddress: Ext.getCmp('txtAddressForContractSearch').getValue(),
                            companyCommAddress: Ext.getCmp('txtCommAddressForContractSearch').getValue(),
                            companyBank: Ext.getCmp('txtBankForContractSearch').getValue(),
                            companyTax: Ext.getCmp('txtTaxForContractSearch').getValue(),
                            companyZipCode: Ext.getCmp('txtZipCodeForContractSearch').getValue(),
                            companyTele: Ext.getCmp('txtTeleForContractSearch').getValue(),
                            companyDelegatee: Ext.getCmp('txtDelegateeForContractSearch').getValue(),
                            companyProvince: Ext.getCmp('cbProvinceForContractSearch').getValue(),
                            companyCity: Ext.getCmp('cbCityForContractSearch').getValue(),
                            contractNo: Ext.getCmp('txtContractForContractSearch').getValue(),
                            contractDateStart: Ext.getCmp('txtContractForContractSearchDateStart').getValue(),
                            contractDateEnd: Ext.getCmp('txtContractForContractSearchDateEnd').getValue(),
                            status: Ext.getCmp('cbContractStatus').getValue(),
                            states: Ext.getCmp('cbContractState').getValue(),
                            contractSavedDateStart: Ext.getCmp('txtContractForContractSearchSavedDateStart').getValue(),
                            contractSavedDateEnd: Ext.getCmp('txtContractForContractSearchSavedDateEnd').getValue(),
                            min: Ext.getCmp('txtContractForContractSearchMin').getValue(),
                            max: Ext.getCmp('txtContractForContractSearchMax').getValue()
                        };

                        var strUrl = Ext.urlEncode(params);
                        window.open(url + '?' + strUrl);
                        params.start = 0;
                        contractSearchStore.reload({params: params});
                    },
                    scope: this
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        contractQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        contractSearchStore.reload();
                    },
                    scope: this
                }, btnShowItems, btnDown]
            });

            var contractSearchPanel = Ext.getCmp('ContractSearch-mainpanel');
            contractSearchPanel.add(contractQueryConditionPanel, contractSearchGrid, contractSearchItemsGrid);
            clsys.form.Util.PagingToolbar(contractSearchStore, contractSearchPanel.tbar, 'contractSearch-paging');
            contractSearchPanel.doLayout();

            Ext.getCmp('contractSearch-grid').getSelectionModel().on('selectionchange', function (sm) {
                showItems(sm);
            });
        });
    </script>
</head>
<body>
<div id="contractSearchPanel"></div>
<div id="contractSearchGridPanel"></div>
<div id="contractSearchItemsPanel"></div>
<div id="contractQueryConditionPanel"></div>
</body>
</html>