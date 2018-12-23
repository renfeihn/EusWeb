<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>库存资源查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();
            var storageResourceSearch_Store = new Ext.data.JsonStore({
                autoDestroy: true,
                baseParams: {status: ['Using'], start: 0, limit: 25},
                url: 'queryStorageResourceView.action',
                totalProperty: 'results',
                root: 'StorageResourceViewList',
                idProperty: 'id',
                fields: ['id', 'amount', 'totalAmount', 'advancedAmount', 'restAmount', 'varAmount',
                    {name: 'productCombination', mapping: 'product.productCombination'},
                    {name: 'memo', mapping: 'product.memo'},
                    {name: 'productName', mapping: 'product.productName'},
                    {name: 'voltage', mapping: 'product.voltage'},
                    {name: 'capacity', mapping: 'product.capacity'},
                    {name: 'productCode', mapping: 'product.productCode.name'},
                    {name: 'humidity', mapping: 'product.humidity.code'},
                    {name: 'errorLevel', mapping: 'product.errorLevel.code'},
                    {name: 'unit', mapping: 'product.unit.name'},
                    {name: 'usageType', mapping: 'product.usageType.name'}
                ],
                sortInfo: {field: 'productCombination', direction: 'ASC'}
            });

            productCodeStoreForStorageResourceSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findProductCode.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            humidityStoreForStorageResourceSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: {status: 'Using'},
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            errorLevelStoreForStorageResourceSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findErrorLevel.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            usageTypeStoreForStorageResourceSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findUsageType.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            productTypeStoreForStorageResourceSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'findProductType.action',
                autoLoad: {status: 'Using'},
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name'],
                sortInfo: {field: 'name', direction: 'ASC'}
            });

            var txtProductCombinationForStorageResourceSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForStorageResourceSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForStorageResourceSearch'
            };

            //2
            var txtVoltageForStorageResourceSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForStorageResourceSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForStorageResourceSearch'
            };
            //3
            var txtCapacityForStorageResourceSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForStorageResourceSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacityForStorageResourceSearch'
            };

            //9 产品代号下拉列表
            var cbProductCodeForStorageResourceSearch = {
                xtype: 'combo',
                store: productCodeStoreForStorageResourceSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForStorageResourceSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id'
            };

            //10 湿度系数指标
            var cbHumidityForStorageResourceSearch = {
                xtype: 'combo',
                store: humidityStoreForStorageResourceSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForStorageResourceSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id'
            };

            //11 误差等级
            var cbErrorLevelForStorageResourceSearch = {
                xtype: 'combo',
                store: errorLevelStoreForStorageResourceSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForStorageResourceSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id'
            };

            //13  产品品种
            var cbUsageTypeForStorageResourceSearch = {
                xtype: 'combo',
                store: usageTypeStoreForStorageResourceSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForStorageResourceSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id'
            };

            //14  产品类别
            var cbProductTypeForStorageResourceSearch = {
                xtype: 'combo',
                store: productTypeStoreForStorageResourceSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForStorageResourceSearch',
                width: 220,
                blankText: '请选择产品类别',
                valueField: 'id'
            };

            var col1 = {
                columnWidth: .50,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [txtProductCombinationForStorageResourceSearch, cbProductCodeForStorageResourceSearch, cbUsageTypeForStorageResourceSearch, txtVoltageForStorageResourceSearch]
            };

            var col2 = {
                columnWidth: .50,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForStorageResourceSearch, cbHumidityForStorageResourceSearch, cbErrorLevelForStorageResourceSearch, txtCapacityForStorageResourceSearch]
            };

            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        storageResourceSearchSearch: 1,
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForStorageResourceSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForStorageResourceSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForStorageResourceSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue())
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
                        url: 'getstorageResourceViewAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm8'),
                        params: attributes
                    });
                }
            };

            var storageResourceSearchStoreQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'storageResourceSearchStoregQueryConditionPanel',
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
                            storageResourceSearchSearch: 1,
                            productCombination: Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForStorageResourceSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForStorageResourceSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForStorageResourceSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue()
                        };
                        attributes.start = 0;
                        storageResourceSearch_Store.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        storageResourceSearchStoreQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        storageResourceSearch_Store.reload();
                    },
                    scope: this
                }, {
                    text: '打印',
                    hidden: true,
                    iconCls: 'icon-printer',
                    handler: function () {
                        var url = 'printQueryStorageResource.action';
                        var params = {
                            productCombination: Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForStorageResourceSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForStorageResourceSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForStorageResourceSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue()
                        };

                        var strUrl = "";
                        strUrl += 'productCombination=' + Ext.getCmp('txtProductCombinationForStorageResourceSearch').getValue() + "&";
                        strUrl += 'productCode=' + Ext.getCmp('cbProductCodeForStorageResourceSearch').getValue() + "&";
                        strUrl += 'errorLevel=' + Ext.getCmp('cbErrorLevelForStorageResourceSearch').getValue() + "&";
                        strUrl += 'voltage=' + Ext.getCmp('txtVoltageForStorageResourceSearch').getValue() + "&";
                        strUrl += 'capacity=' + Ext.getCmp('txtCapacityForStorageResourceSearch').getValue() + "&";
                        strUrl += 'productType=' + Ext.getCmp('cbProductTypeForStorageResourceSearch').getValue() + "&";
                        strUrl += 'humidity=' + Ext.getCmp('cbHumidityForStorageResourceSearch').getValue() + "&";
                        strUrl += 'usageType=' + Ext.getCmp('cbUsageTypeForStorageResourceSearch').getValue();

                        //window.open(url + '?' + strUrl);
                        params.start = 0;
                        storageResourceSearch_Store.reload({params: params});
                    },
                    scope: this
                }, btnDown]
            });

            var storageResourceSearchGrid = {
                xtype: 'grid',
                id: 'storageResourceSearch-grid',
                anchor: '100% 65%',
                store: storageResourceSearch_Store,
                stripeRows: true,
                autoScroll: true,
                border: false,
                loadMask: true,
                frame: true,
                renderTo: 'storageResourceSearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '产品名称及型号', width: 150, dataIndex: 'productCombination'},
                        {header: '库存数量', width: 50, dataIndex: 'totalAmount'},
                        {header: '待发数量', width: 50, dataIndex: 'advancedAmount'},
                        {header: '结余数量', width: 50, dataIndex: 'restAmount'},
                        {header: '资源数量', width: 50, dataIndex: 'amount'},
                        {header: '最低资源数量', width: 60, dataIndex: 'memo'},
                        {header: '产品代号', width: 80, dataIndex: 'productCode'},
                        {header: '产品品种', width: 40, dataIndex: 'usageType'},
                        {header: '误差', width: 40, dataIndex: 'errorLevel'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            };

            var storageResourceSearchPanel = Ext.getCmp('StorageResourceSearch-mainpanel');
            storageResourceSearchPanel.add(storageResourceSearchStoreQueryConditionPanel, storageResourceSearchGrid);
            clsys.form.Util.PagingToolbar(storageResourceSearch_Store, storageResourceSearchPanel.tbar, 'storageResourceSearch-paging');
            storageResourceSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="storageResourceSearchGridPanel"></div>
<div id="storageResourceSearchStoregQueryConditionPanel"></div>
</body>
</html>