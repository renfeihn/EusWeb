<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>直接出入库查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();
            var warehouseSearch_Store = new Ext.data.JsonStore({
                autoDestroy: true,
                baseParams: {status: ['Using'], start: 0, limit: 25},
                url: 'queryInWarehouse.action',
                totalProperty: 'results',
                root: 'InWarehouseList',
                idProperty: 'id',
                fields: ['id', 'totalAmount', 'flag', 'createTime',
                    {name: 'productCombination', mapping: 'product.productCombination'},
                    {name: 'productName', mapping: 'product.productName'},
                    {name: 'voltage', mapping: 'product.voltage'},
                    {name: 'capacity', mapping: 'product.capacity'},
                    {name: 'productCode', mapping: 'product.productCode.name'},
                    {name: 'humidity', mapping: 'product.humidity.code'},
                    {name: 'errorLevel', mapping: 'product.errorLevel.code'},
                    {name: 'unit', mapping: 'product.unit.name'},
                    {name: 'usageType', mapping: 'product.usageType.name'}
                ],
                sortInfo: {field: 'createTime', direction: 'DESC'}

            });

            productCodeStoreForWarehouseSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findProductCode.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            humidityStoreForWarehouseSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: {status: 'Using'},
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            errorLevelStoreForWarehouseSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findErrorLevel.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            usageTypeStoreForWarehouseSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findUsageType.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            productTypeStoreForWarehouseSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findProductType.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var txtProductCombinationForWarehouseSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForWarehouseSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForWarehouseSearch'
            };

            //2
            var txtVoltageForWarehouseSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForWarehouseSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForWarehouseSearch'
            };
            //3
            var txtCapacityForWarehouseSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForWarehouseSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacityForWarehouseSearch'
            };

            //9 产品代号下拉列表
            var cbProductCodeForWarehouseSearch = {
                xtype: 'combo',
                store: productCodeStoreForWarehouseSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForWarehouseSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id'
            };

            //10 湿度系数指标
            var cbHumidityForWarehouseSearch = {
                xtype: 'combo',
                store: humidityStoreForWarehouseSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForWarehouseSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id'
            };

            //11 误差等级
            var cbErrorLevelForWarehouseSearch = {
                xtype: 'combo',
                store: errorLevelStoreForWarehouseSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForWarehouseSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id'
            };

            //13  产品品种
            var cbUsageTypeForWarehouseSearch = {
                xtype: 'combo',
                store: usageTypeStoreForWarehouseSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForWarehouseSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id'
            };

            //14  产品类别
            var cbProductTypeForWarehouseSearch = {
                xtype: 'combo',
                store: productTypeStoreForWarehouseSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForWarehouseSearch',
                width: 220,
                blankText: '请选择产品类别',
                valueField: 'id'
            };

            var cbDirectionState = {
                xtype: 'combo',
                id: 'cbDirectionState',
                fieldLabel: '出入库状态',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['', '全部'],
                        ['0', '直接入库'],
                        ['2', '超计划入库'],
                        ['1', '直接出库']
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

            var txtIWSearchSavedDateStart = {
                xtype: 'datefield',
                id: 'txtIWSearchSavedDateStart',
                fieldLabel: '保存日期(开始)',
                width: 220,
                name: 'txtIWSearchSavedDateStart'
            };

            var txtIWSearchSavedDateEnd = {
                xtype: 'datefield',
                id: 'txtIWSearchSavedDateEnd',
                fieldLabel: '保存日期(结束)',
                width: 220,
                name: 'txtIWSearchSavedDateEnd'
            };

            var col1 = {
                columnWidth: .50,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [txtProductCombinationForWarehouseSearch, cbProductCodeForWarehouseSearch, cbUsageTypeForWarehouseSearch, txtVoltageForWarehouseSearch, txtIWSearchSavedDateStart, cbDirectionState]
            };

            var col2 = {
                columnWidth: .50,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForWarehouseSearch, cbHumidityForWarehouseSearch, cbErrorLevelForWarehouseSearch, txtCapacityForWarehouseSearch, txtIWSearchSavedDateEnd]
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        warehouseSearchSearch: 1,
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForWarehouseSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForWarehouseSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForWarehouseSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForWarehouseSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForWarehouseSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForWarehouseSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForWarehouseSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForWarehouseSearch').getValue()),
                        flag: encodeURI(Ext.getCmp('cbDirectionState').getValue()),
                        SavedDateStart: Ext.getCmp('txtIWSearchSavedDateStart').getValue(),
                        SavedDateEnd: Ext.getCmp('txtIWSearchSavedDateEnd').getValue()
                    };

                    //如果不存在一个id为"downForm"的form表单，则执行下面的操作
                    if (!Ext.fly('downForm8')) {

                        //下面代码是在创建一个表单以及添加相应的一些属性
                        var downForm = document.createElement('form');  //创建一个form表单
                        downForm.id = 'downForm8'; 　　//该表单的id为downForm
                        downForm.name = 'downForm8';  //该表单的name属性为downForm
                        downForm.className = 'x-hidden'; //该表单为隐藏的
//                        downForm.action = 'getcontractAction.action'; //表单的提交地址
                        downForm.method = 'POST';  //表单的提交方法

                        document.body.appendChild(downForm); //将form表单追加到body里面
                    }

                    Ext.Ajax.request({
                        disableCaching: true,
                        url: 'getinWarehouseAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm8'),
                        params: attributes
                    });
                }
            };

            var warehouseSearchStoreQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'warehouseSearchStoregQueryConditionPanel',
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
                            warehouseSearchSearch: 1,
                            productCombination: Ext.getCmp('txtProductCombinationForWarehouseSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForWarehouseSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForWarehouseSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForWarehouseSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForWarehouseSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForWarehouseSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForWarehouseSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForWarehouseSearch').getValue(),
                            flag: Ext.getCmp('cbDirectionState').getValue(),
                            SavedDateStart: Ext.getCmp('txtIWSearchSavedDateStart').getValue(),
                            SavedDateEnd: Ext.getCmp('txtIWSearchSavedDateEnd').getValue()

                        };
                        attributes.start = 0;
                        warehouseSearch_Store.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        warehouseSearchStoreQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        warehouseSearch_Store.reload();
                    },
                    scope: this
                }, btnDown]
            });

            var warehouseSearchGrid = {
                xtype: 'grid',
                id: 'warehouseSearch-grid',
                anchor: '100% 65%',
                store: warehouseSearch_Store,
                stripeRows: true,
                autoScroll: true,
                border: false,
                loadMask: true,
                frame: true,
                renderTo: 'warehouseSearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '产品名称及型号', width: 150, dataIndex: 'productCombination'},
                        {header: '产品代号', width: 80, dataIndex: 'productCode'},
                        {header: '产品品种', width: 40, dataIndex: 'usageType'},
                        {header: '电压', width: 40, dataIndex: 'voltage'},
                        {header: '容量', width: 40, dataIndex: 'capacity'},
                        {header: '湿度', width: 40, dataIndex: 'humidity'},
                        {header: '误差', width: 40, dataIndex: 'errorLevel'},
                        {header: '数量', width: 50, dataIndex: 'totalAmount'},
                        {
                            header: '状态',
                            width: 50,
                            dataIndex: 'flag',
                            renderer: clsys.grid.columnrender.InWarehouseFlagRender
                        },
                        {header: '时间', width: 80, dataIndex: 'createTime'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var warehouseSearchPanel = Ext.getCmp('WarehouseSearch-mainpanel');
            warehouseSearchPanel.add(warehouseSearchStoreQueryConditionPanel, warehouseSearchGrid);
            clsys.form.Util.PagingToolbar(warehouseSearch_Store, warehouseSearchPanel.tbar, 'warehouseSearch-paging');
            warehouseSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="warehouseSearchGridPanel"></div>
<div id="warehouseSearchStoregQueryConditionPanel"></div>
</body>
</html>