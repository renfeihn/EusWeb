<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>出库明细查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var storageOutcomingItemSearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'queryStorageOutcomingItem.action',
                totalProperty: 'results',
                root: 'StorageOutcomingItemList',
                baseParams: {status: ['Using'], start: 0, limit: 25},
                idProperty: 'id',
                fields: ['id', 'createTime',
                    {name: 'socItemNo', type: 'int'},
                    {name: 'socNo', mapping: 'soc.socNo'},
                    {name: 'socState', mapping: 'soc.state'},
                    {name: 'company', mapping: 'contractItem.contract.company.name'},
                    {name: 'contractNo', mapping: 'contractItem.contract.contractNo'},
                    {name: 'productCombination', mapping: 'product.productCombination'},
                    {name: 'unit', mapping: 'product.unit.name'},
                    {name: 'voltage', mapping: 'product.voltage'},
                    {name: 'capacity', mapping: 'product.capacity'},
                    {name: 'humidity', mapping: 'product.humidity.code'},
                    {name: 'errorLevel', mapping: 'product.errorLevel.code'},
                    'amount', 'price', 'subTotal', 'subTotalWithoutTax', 'priceWithoutTax', 'taxAmount', 'tax', 'memo'
                ],
                sortInfo: {field: 'socItemNo', direction: 'ASC'}
            });

            var productCodeStoreForSocItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductCode.action',
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var humidityStoreForSocItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var errorLevelStoreForSocItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findErrorLevel.action',
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var usageTypeStoreForSocItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findUsageType.action',
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var productTypeStoreForSocItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductType.action',
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var txtSOCNoForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtSOCNoForSocItemSearch',
                fieldLabel: '出库单号',
                width: 220,
                name: 'txtSOCNoForSocItemSearch'
            };

            var txtContractForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtContractForSocItemSearch',
                fieldLabel: '合同号',
                width: 220,
                name: 'txtContractForSocItemSearch'
            };

            var txtCompanyForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtCompanyForSocItemSearch',
                fieldLabel: '合同厂商',
                width: 220,
                name: 'txtCompanyForSocItemSearch'
            };

            var txtProductCombinationForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForSocItemSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForSocItemSearch'
            };

            var txtVoltageForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForSocItemSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForSocItemSearch'
            };
            var txtCapacityForSocItemSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForSocItemSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacity'
            };

            var cbProductCodeForSocItemSearch = {
                xtype: 'combo',
                store: productCodeStoreForSocItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForSocItemSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id',
                editable: true
            };

            var cbHumidityForSocItemSearch = {
                xtype: 'combo',
                store: humidityStoreForSocItemSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForSocItemSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id',
                editable: true
            };

            var cbErrorLevelForSocItemSearch = {
                xtype: 'combo',
                store: errorLevelStoreForSocItemSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForSocItemSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id',
                editable: true
            };

            var cbUsageTypeForSocItemSearch = {
                xtype: 'combo',
                store: usageTypeStoreForSocItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForSocItemSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id',
                editable: true
            };

            var cbProductTypeForSocItemSearch = {
                xtype: 'combo',
                store: productTypeStoreForSocItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForSocItemSearch',
                width: 220,
                blankText: '请选择产品类别',
                valueField: 'id',
                editable: true
            };

            var txtDateStartForSocItemSearch = {
                xtype: 'datefield',
                id: 'txtDateStartForSocItemSearch',
                fieldLabel: '出库日期(开始)',
                width: 220,
                name: 'txtDateStartForSocItemSearch'
            };

            var txtDateEndForSocItemSearch = {
                xtype: 'datefield',
                id: 'txtDateEndForSocItemSearch',
                fieldLabel: '出库日期(结束)',
                width: 220,
                name: 'txtDateEndForSocItemSearch'
            };

            var cbSocStateForSocItemSearch = {
                xtype: 'combo',
                id: 'cbSocStateForSocItemSearch',
                emptyText: '请选择出库单状态',
                fieldLabel: '出库单状态',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['', '全部状态'],
                        ['Checking', '待审核'],
                        ['Failed', '审核失败'],
                        ['Success', '审核成功']
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
                items: [txtProductCombinationForSocItemSearch, cbProductCodeForSocItemSearch, cbErrorLevelForSocItemSearch, txtVoltageForSocItemSearch, txtSOCNoForSocItemSearch, txtDateStartForSocItemSearch, txtContractForSocItemSearch]
            };

            var col2 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForSocItemSearch, cbHumidityForSocItemSearch, cbUsageTypeForSocItemSearch, txtCapacityForSocItemSearch, cbSocStateForSocItemSearch, txtDateEndForSocItemSearch, txtCompanyForSocItemSearch]
            };

            var storageOutcomingItemSearchGrid = {
                xtype: 'grid',
                id: 'storageOutcomingItemSearch-grid',
                anchor: '100% 90%',
                store: storageOutcomingItemSearchStore,
                stripeRows: true,
                autoScroll: true,
                hidden: false,
                loadMask: true,
                border: false,
                frame: true,
                renderTo: 'storageOutcomingItemSearchItemsPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '出库单号', width: 120, dataIndex: 'socNo'},
                        {header: '序号', width: 40, dataIndex: 'socItemNo'},
                        {header: '产品名称及型号', width: 220, dataIndex: 'productCombination'},
                        {header: '单位', width: 40, dataIndex: 'unit'},
                        {header: '数量', width: 100, dataIndex: 'amount'},
                        {header: '单价', width: 100, dataIndex: 'price'},
                        {header: '不含税单价', width: 100, dataIndex: 'priceWithoutTax'},
                        {header: '金额', width: 100, dataIndex: 'subTotal'},
                        {header: '不含税金额', width: 100, dataIndex: 'subTotalWithoutTax'},
                        {header: '税率', width: 100, dataIndex: 'tax'},
                        {header: '税额', width: 100, dataIndex: 'taxAmount'},
                        {header: '合同厂商', width: 500, dataIndex: 'company'},
                        {header: '合同号', width: 150, dataIndex: 'contractNo'},
                        {
                            header: '状态',
                            width: 80,
                            dataIndex: 'socState',
                            renderer: clsys.grid.columnrender.StorageOutcomingStatusRender
                        },
                        {header: '备注', width: 80, dataIndex: 'memo'}
                    ]
                }),
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        socNo: encodeURI(Ext.getCmp('txtSOCNoForSocItemSearch').getValue()),
                        companyName: encodeURI(Ext.getCmp('txtCompanyForSocItemSearch').getValue()),
                        contractNo: encodeURI(Ext.getCmp('txtContractForSocItemSearch').getValue()),
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForSocItemSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForSocItemSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForSocItemSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForSocItemSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForSocItemSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForSocItemSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForSocItemSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForSocItemSearch').getValue()),
                        dateStartForSocItemSearch: encodeURI(Ext.getCmp('txtDateStartForSocItemSearch').getValue()),
                        dateEndForSocItemSearch: encodeURI(Ext.getCmp('txtDateEndForSocItemSearch').getValue()),
                        socState: encodeURI(Ext.getCmp('cbSocStateForSocItemSearch').getValue())
                    };

                    //如果不存在一个id为"downForm"的form表单，则执行下面的操作
                    if (!Ext.fly('downForm6')) {

                        //下面代码是在创建一个表单以及添加相应的一些属性
                        var downForm = document.createElement('form');  //创建一个form表单
                        downForm.id = 'downForm6'; 　　//该表单的id为downForm
                        downForm.name = 'downForm6';  //该表单的name属性为downForm
                        downForm.className = 'x-hidden'; //该表单为隐藏的
//                        downForm.action = 'getcontractAction.action'; //表单的提交地址
                        downForm.method = 'POST';  //表单的提交方法

                        document.body.appendChild(downForm); //将form表单追加到body里面
                    }

                    Ext.Ajax.request({
                        disableCaching: true,
                        url: 'getstorageOutcomingItemAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm6'),
                        params: attributes
                    });
                }
            };

            var storageOutcomingQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'storageOutcomingQueryConditionPanel',
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
                            socNo: Ext.getCmp('txtSOCNoForSocItemSearch').getValue(),
                            companyName: Ext.getCmp('txtCompanyForSocItemSearch').getValue(),
                            contractNo: Ext.getCmp('txtContractForSocItemSearch').getValue(),
                            productCombination: Ext.getCmp('txtProductCombinationForSocItemSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForSocItemSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForSocItemSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForSocItemSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForSocItemSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForSocItemSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForSocItemSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForSocItemSearch').getValue(),
                            dateStartForSocItemSearch: Ext.getCmp('txtDateStartForSocItemSearch').getValue(),
                            dateEndForSocItemSearch: Ext.getCmp('txtDateEndForSocItemSearch').getValue(),
                            socState: Ext.getCmp('cbSocStateForSocItemSearch').getValue()

                        };
                        attributes.start = 0;
                        storageOutcomingItemSearchStore.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        storageOutcomingQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        storageOutcomingItemSearchStore.reload();
                    },
                    scope: this
                }, btnDown]
            });

            var storageOutcomingItemSearchPanel = Ext.getCmp('StorageOutcomingItemSearch-mainpanel');
            storageOutcomingItemSearchPanel.add(storageOutcomingQueryConditionPanel, storageOutcomingItemSearchGrid);
            clsys.form.Util.PagingToolbar(storageOutcomingItemSearchStore, storageOutcomingItemSearchPanel.tbar, 'storageOutcomingItemSearch-paging');
            storageOutcomingItemSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="storageOutcomingItemSearchPanel"></div>
<div id="storageOutcomingItemSearchGridPanel"></div>
<div id="storageOutcomingItemSearchItemsPanel"></div>
<div id="storageOutcomingQueryConditionPanel"></div>
</body>
</html>