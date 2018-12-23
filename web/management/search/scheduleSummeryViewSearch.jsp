<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
    <title>计划欠交汇总查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var scheduleSummeryViewSearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'queryScheduleSummeryView.action',
                totalProperty: 'results',
                root: 'ScheduleSummeryViewList',
                baseParams: {start: 0, limit: 25},
                idProperty: 'id',
                fields: ['id', 'amount', 'finishedAmount', 'restAmount',
                    {name: 'productCombination', mapping: 'product.productCombination'},
                    {name: 'voltage', mapping: 'product.voltage'},
                    {name: 'capacity', mapping: 'product.capacity'},
                    {name: 'productCode', mapping: 'product.productCode.name'},
                    {name: 'humidity', mapping: 'product.humidity.code'},
                    {name: 'errorLevel', mapping: 'product.errorLevel.code'},
                    {name: 'unit', mapping: 'product.unit.name'},
                    {name: 'usageType', mapping: 'product.usageType.name'}],
                sortInfo: {field: 'productCombination', direction: 'ASC'}
            });

            var productCodeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductCode.action',
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var humidityStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var errorLevelStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findErrorLevel.action',
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var usageTypeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findUsageType.action',
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var productTypeStoreForScheduleSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductType.action',
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var txtProductCombinationForScheduleSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForScheduleSummeryViewSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForScheduleSummeryViewSearch'
            };

            //2
            var txtVoltageForScheduleSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForScheduleSummeryViewSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForScheduleSummeryViewSearch'
            };
            //3
            var txtCapacityForScheduleSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForScheduleSummeryViewSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacityForScheduleSummeryViewSearch'
            };

            //9 产品代号下拉列表
            var cbProductCodeForScheduleSummeryViewSearch = {
                xtype: 'combo',
                store: productCodeStoreForScheduleSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForScheduleSummeryViewSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id',
                editable: true
            };

            //10 湿度系数指标
            var cbHumidityForScheduleSummeryViewSearch = {
                xtype: 'combo',
                store: humidityStoreForScheduleSummeryViewSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForScheduleSummeryViewSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id',
                editable: true
            };

            //11 误差等级
            var cbErrorLevelForScheduleSummeryViewSearch = {
                xtype: 'combo',
                store: errorLevelStoreForScheduleSummeryViewSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForScheduleSummeryViewSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id',
                editable: true
            };

            //13  产品品种
            var cbUsageTypeForScheduleSummeryViewSearch = {
                xtype: 'combo',
                store: usageTypeStoreForScheduleSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForScheduleSummeryViewSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id',
                editable: true
            };

            //14  产品类别
            var cbProductTypeForScheduleSummeryViewSearch = {
                xtype: 'combo',
                store: productTypeStoreForScheduleSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForScheduleSummeryViewSearch',
                width: 220,
                blankText: '请选择产品类别',
                valueField: 'id',
                editable: true
            };

            var col1 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductCodeForScheduleSummeryViewSearch, cbErrorLevelForScheduleSummeryViewSearch, txtVoltageForScheduleSummeryViewSearch, txtProductCombinationForScheduleSummeryViewSearch]
            };

            var col2 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForScheduleSummeryViewSearch, cbHumidityForScheduleSummeryViewSearch, cbUsageTypeForScheduleSummeryViewSearch, txtCapacityForScheduleSummeryViewSearch]
            };

            var scheduleSummeryViewSearchGrid = {
                xtype: 'grid',
                id: 'scheduleSummeryViewSearch-grid',
                anchor: '100% 90%',
                store: scheduleSummeryViewSearchStore,
                stripeRows: true,
                autoScroll: true,
                border: false,
                loadMask: true,
                frame: true,
                renderTo: 'scheduleSummeryViewSearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '产品名称及型号', dataIndex: 'productCombination'},
                        {header: '产品代号', width: 40, dataIndex: 'productCode'},
                        {header: '产品品种', width: 40, dataIndex: 'usageType'},
                        {header: '电压', width: 40, dataIndex: 'voltage'},
                        {header: '容量', width: 40, dataIndex: 'capacity'},
                        {header: '湿度', width: 40, dataIndex: 'humidity'},
                        {header: '误差', width: 40, dataIndex: 'errorLevel'},
                        {header: '单位', width: 40, dataIndex: 'unit'},
                        {header: '计划数量合计', width: 50, dataIndex: 'amount'},
                        {header: '完成数量合计', width: 50, dataIndex: 'finishedAmount'},
                        {header: '欠交数量合计', width: 50, dataIndex: 'restAmount'}
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
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForScheduleSummeryViewSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForScheduleSummeryViewSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForScheduleSummeryViewSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForScheduleSummeryViewSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForScheduleSummeryViewSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForScheduleSummeryViewSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForScheduleSummeryViewSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForScheduleSummeryViewSearch').getValue())
                    };

                    //如果不存在一个id为"downForm"的form表单，则执行下面的操作
                    if (!Ext.fly('downForm5')) {

                        //下面代码是在创建一个表单以及添加相应的一些属性
                        var downForm = document.createElement('form');  //创建一个form表单
                        downForm.id = 'downForm5'; 　　//该表单的id为downForm
                        downForm.name = 'downForm5';  //该表单的name属性为downForm
                        downForm.className = 'x-hidden'; //该表单为隐藏的
//                        downForm.action = 'getcontractAction.action'; //表单的提交地址
                        downForm.method = 'POST';  //表单的提交方法

                        document.body.appendChild(downForm); //将form表单追加到body里面
                    }

                    Ext.Ajax.request({
                        disableCaching: true,
                        url: 'getscheduleSummeryViewAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm5'),
                        params: attributes
                    });
                }
            };

            var scheduleSummeryViewQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'scheduleSummeryViewQueryConditionPanel',
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
                            productCombination: Ext.getCmp('txtProductCombinationForScheduleSummeryViewSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForScheduleSummeryViewSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForScheduleSummeryViewSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForScheduleSummeryViewSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForScheduleSummeryViewSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForScheduleSummeryViewSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForScheduleSummeryViewSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForScheduleSummeryViewSearch').getValue()
                        };
                        attributes.start = 0;
                        scheduleSummeryViewSearchStore.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        scheduleSummeryViewQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        scheduleSummeryViewSearchStore.reload();
                    },
                    scope: this
                }, {
                    text: '打印',
                    iconCls: 'icon-printer',
                    handler: function () {
                        var url = 'printQueryScheduleSummeryView.action';
                        var params = {
                            productCombination: Ext.getCmp('txtProductCombinationForScheduleSummeryViewSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForScheduleSummeryViewSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForScheduleSummeryViewSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForScheduleSummeryViewSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForScheduleSummeryViewSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForScheduleSummeryViewSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForScheduleSummeryViewSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForScheduleSummeryViewSearch').getValue()
                        };

                        var strUrl = Ext.urlEncode(params);
                        window.open(url + '?' + strUrl);
                        params.start = 0;
                        scheduleSummeryViewSearchStore.reload({params: params});
                    },
                    scope: this
                }, btnDown]
            });

            var scheduleSummeryViewSearchPanel = Ext.getCmp('ScheduleSummeryViewSearch-mainpanel');
            scheduleSummeryViewSearchPanel.add(scheduleSummeryViewQueryConditionPanel, scheduleSummeryViewSearchGrid);
            clsys.form.Util.PagingToolbar(scheduleSummeryViewSearchStore, scheduleSummeryViewSearchPanel.tbar, 'scheduleSummeryViewSearch-paging');
            scheduleSummeryViewSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="scheduleSummeryViewSearchPanel"></div>
<div id="scheduleSummeryViewSearchGridPanel"></div>
<div id="scheduleSummeryViewSearchItemsPanel"></div>
<div id="scheduleSummeryViewQueryConditionPanel"></div>
</body>
</html>