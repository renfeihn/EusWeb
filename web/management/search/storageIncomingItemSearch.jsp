<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>入库查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var storageIncomingItemSearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'queryStorageIncomingItem.action',
                totalProperty: 'results',
                root: 'StorageIncomingItemList',
                baseParams: {status: ['Using'], start: 0, limit: 25},
                idProperty: 'id',
                fields: ['id', 'sicItemNo', 'amount', 'jobCmdNo', 'productionDate', 'createTime',
                    {name: 'schedule', mapping: 'schedule.scheduleNo'},
                    {name: 'productCombination', mapping: 'product.productCombination'},
                    {name: 'voltage', mapping: 'product.voltage'},
                    {name: 'capacity', mapping: 'product.capacity'},
                    {name: 'humidity', mapping: 'product.humidity.code'},
                    {name: 'errorLevel', mapping: 'product.errorLevel.code'}
                ],
                sortInfo: {field: 'createTime', direction: 'ASC'}
            });

            var productCodeStoreForSicItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductCode.action',
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var humidityStoreForSicItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var errorLevelStoreForSicItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findErrorLevel.action',
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var usageTypeStoreForSicItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findUsageType.action',
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var productTypeStoreForSicItemSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductType.action',
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var txtProductCombinationForSicItemSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForSicItemSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForSicItemSearch'
            };

            var txtVoltageForSicItemSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForSicItemSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForSicItemSearch'
            };
            var txtCapacityForSicItemSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForSicItemSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacityForSicItemSearch'
            };

            var cbProductCodeForSicItemSearch = {
                xtype: 'combo',
                store: productCodeStoreForSicItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForSicItemSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id',
                editable: true
            };

            var cbHumidityForSicItemSearch = {
                xtype: 'combo',
                store: humidityStoreForSicItemSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForSicItemSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id',
                editable: true
            };

            var cbErrorLevelForSicItemSearch = {
                xtype: 'combo',
                store: errorLevelStoreForSicItemSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForSicItemSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id',
                editable: true
            };

            var cbUsageTypeForSicItemSearch = {
                xtype: 'combo',
                store: usageTypeStoreForSicItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForSicItemSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id',
                editable: true
            };

            var cbProductTypeForSicItemSearch = {
                xtype: 'combo',
                store: productTypeStoreForSicItemSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForSicItemSearch',
                width: 220,
                blankText: '请选择产品类别',
                valueField: 'id',
                editable: true
            };

            var txtDateStartForSicItemSearch = {
                xtype: 'datefield',
                id: 'txtDateStartForSicItemSearch',
                fieldLabel: '入库日期(开始)',
                width: 220,
                name: 'txtDateStartForSicItemSearch'
            };

            var txtDateEndForSicItemSearch = {
                xtype: 'datefield',
                id: 'txtDateEndForSicItemSearch',
                fieldLabel: '入库日期(结束)',
                width: 220,
                name: 'txtDateEndForSicItemSearch'
            };

            var col1 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [txtProductCombinationForSicItemSearch, cbProductCodeForSicItemSearch, cbErrorLevelForSicItemSearch, txtVoltageForSicItemSearch, txtDateStartForSicItemSearch]
            };

            var col2 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForSicItemSearch, cbHumidityForSicItemSearch, cbUsageTypeForSicItemSearch, txtCapacityForSicItemSearch, txtDateEndForSicItemSearch]
            };

            var storageIncomingItemSearchGrid = {
                xtype: 'grid',
                id: 'storageIncomingItemSearch-grid',
                anchor: '100% 90%',
                store: storageIncomingItemSearchStore,
                stripeRows: true,
                autoScroll: true,
                hidden: false,
                loadMask: true,
                border: false,
                frame: true,
                renderTo: 'storageIncomingItemSearchItemsPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '产品名称及型号', width: 150, dataIndex: 'productCombination'},
                        {header: '工作令号', width: 50, dataIndex: 'jobCmdNo'},
                        {header: '电压(V)', width: 50, dataIndex: 'voltage'},
                        {header: '容量(PF)', width: 50, dataIndex: 'capacity'},
                        {header: '组别', width: 30, dataIndex: 'humidity'},
                        {header: '等级', width: 30, dataIndex: 'productCode'},
                        {header: '数量', width: 50, dataIndex: 'amount'},
                        {header: '生产日期', width: 80, dataIndex: 'productionDate'},
                        {header: '入库时间', width: 80, dataIndex: 'createTime'},
                        {header: '备注', width: 80, dataIndex: 'schedule'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForSicItemSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForSicItemSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForSicItemSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForSicItemSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForSicItemSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForSicItemSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForSicItemSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForSicItemSearch').getValue()),
                        dateStartForSicItemSearch: encodeURI(Ext.getCmp('txtDateStartForSicItemSearch').getValue()),
                        dateEndForSicItemSearch: encodeURI(Ext.getCmp('txtDateEndForSicItemSearch').getValue())
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
                        url: 'getstorageIncomingItemAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm6'),
                        params: attributes
                    });
                }
            };

            var storageIncomingQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'storageIncomingQueryConditionPanel',
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
                            productCombination: Ext.getCmp('txtProductCombinationForSicItemSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForSicItemSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForSicItemSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForSicItemSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForSicItemSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForSicItemSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForSicItemSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForSicItemSearch').getValue(),
                            dateStartForSicItemSearch: Ext.getCmp('txtDateStartForSicItemSearch').getValue(),
                            dateEndForSicItemSearch: Ext.getCmp('txtDateEndForSicItemSearch').getValue()
                        };
                        attributes.start = 0;
                        storageIncomingItemSearchStore.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        storageIncomingQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        storageIncomingItemSearchStore.reload();
                    },
                    scope: this
                }, btnDown]
            });

            var storageIncomingItemSearchPanel = Ext.getCmp('StorageIncomingItemSearch-mainpanel');
            storageIncomingItemSearchPanel.add(storageIncomingQueryConditionPanel, storageIncomingItemSearchGrid);
            clsys.form.Util.PagingToolbar(storageIncomingItemSearchStore, storageIncomingItemSearchPanel.tbar, 'storageIncomingItemSearch-paging');
            storageIncomingItemSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="storageIncomingItemSearchPanel"></div>
<div id="storageIncomingItemSearchGridPanel"></div>
<div id="storageIncomingItemSearchItemsPanel"></div>
<div id="storageIncomingQueryConditionPanel"></div>
</body>
</html>