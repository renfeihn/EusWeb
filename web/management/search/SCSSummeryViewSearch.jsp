<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
    <title>资源汇总查询</title>
    <script language="javascript">
        Ext.onReady(function () {

            Ext.QuickTips.init();

            var cbVarAmount = {
                xtype: 'combo',
                id: 'cbVarAmount',
                emptyText: '',
                fieldLabel: '差额状态',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['0', '全部'],
                        ['1', '等于0'],
                        ['2', '大于0'],
                        ['3', '小于0']
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

            var srAmount1 = {
                xtype: 'combo',
                id: 'srAmount1',
                emptyText: '',
                fieldLabel: '资源数',
                store: new Ext.data.ArrayStore({
                    fields: ['id', 'name'],
                    data: [
                        ['0', '全部'],
                        ['1', '等于0'],
                        ['2', '大于0'],
                        ['3', '小于0']
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


            var SCSSummerySearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'querySummerySCSSummeryView.action',
                root: 'SCSSumeryList',
                totalProperty: 'results',
                fields: ['srTotalAmount', 'srAmount', 'coCheckingAmount', 'coUnfinishedAmount', 'coOwnedAmount', 'ssRestAmount', 'varAmount']
            });

            var SCSSummeryViewSearchStore = new Ext.data.JsonStore({
                autoDestroy: true,
                url: 'querySCSSummeryView.action',
                totalProperty: 'results',
                root: 'SCSSummeryViewList',
                baseParams: {start: 0, limit: 25},
                idProperty: 'id',
                fields: ['id',
                    'coAmount', 'coFinishedAmount', 'coCheckingAmount', 'coUnfinishedAmount', 'coRestAmount', 'coOwnedAmount',
                    'srAmount', 'srAdvancedAmount', 'srTotalAmount', 'srRestAmount', 'srVarAmount',
                    'ssAmount', 'ssFinishedAmount', 'ssRestAmount', 'varAmount',
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

            var productCodeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductCode.action',
                baseParams: {status: 'Using'},
                root: 'ProductCodeList',
                fields: ['id', 'code', 'name'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var humidityStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findHumidity.action',
                baseParams: {status: 'Using'},
                root: 'HumidityList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var errorLevelStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findErrorLevel.action',
                baseParams: {status: 'Using'},
                root: 'ErrorLevelList',
                fields: ['id', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var usageTypeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findUsageType.action',
                baseParams: {status: 'Using'},
                root: 'UsageTypeList',
                fields: ['id', 'name', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var productTypeStoreForSCSSummeryViewSearch = new Ext.data.JsonStore({
                autoDestroy: true,
                autoLoad: true,
                url: 'findProductType.action',
                baseParams: {status: 'Using'},
                root: 'ProductTypeList',
                fields: ['id', 'name', 'code'],
                sortInfo: {field: 'code', direction: 'ASC'}
            });

            var txtMinForSCSSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtMinForSCSSummeryViewSearch',
                fieldLabel: '差额(最小)',
                width: 220,
                name: 'txtMinForSCSSummeryViewSearch'
            };

            var txtMaxForSCSSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtMaxForSCSSummeryViewSearch',
                fieldLabel: '差额(最大)',
                width: 220,
                name: 'txtMaxForSCSSummeryViewSearch'
            };

            var txtProductCombinationForSCSSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtProductCombinationForSCSSummeryViewSearch',
                fieldLabel: '产品名称及型号',
                width: 220,
                name: 'txtProductCombinationForSCSSummeryViewSearch'
            };

            //2
            var txtVoltageForSCSSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtVoltageForSCSSummeryViewSearch',
                fieldLabel: '产品电压',
                width: 220,
                name: 'txtVoltageForSCSSummeryViewSearch'
            };
            //3
            var txtCapacityForSCSSummeryViewSearch = {
                xtype: 'textfield',
                id: 'txtCapacityForSCSSummeryViewSearch',
                fieldLabel: '产品容量',
                width: 220,
                name: 'txtCapacityForSCSSummeryViewSearch'
            };

            //9 产品代号下拉列表
            var cbProductCodeForSCSSummeryViewSearch = {
                xtype: 'combo',
                store: productCodeStoreForSCSSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品代号',
                fieldLabel: '产品代号',
                selectOnFocus: true,
                id: 'cbProductCodeForSCSSummeryViewSearch',
                width: 220,
                blankText: '请选择产品代号',
                valueField: 'id',
                editable: true
            };

            //10 湿度系数指标
            var cbHumidityForSCSSummeryViewSearch = {
                xtype: 'combo',
                store: humidityStoreForSCSSummeryViewSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择湿度系数指标',
                fieldLabel: '湿度系数指标',
                selectOnFocus: true,
                id: 'cbHumidityForSCSSummeryViewSearch',
                width: 220,
                blankText: '请选择湿度系数指标',
                valueField: 'id',
                editable: true
            };

            //11 误差等级
            var cbErrorLevelForSCSSummeryViewSearch = {
                xtype: 'combo',
                store: errorLevelStoreForSCSSummeryViewSearch,
                displayField: 'code',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择误差等级',
                fieldLabel: '误差等级',
                selectOnFocus: true,
                id: 'cbErrorLevelForSCSSummeryViewSearch',
                width: 220,
                blankText: '请选择误差等级',
                valueField: 'id',
                editable: true
            };

            //13  产品品种
            var cbUsageTypeForSCSSummeryViewSearch = {
                xtype: 'combo',
                store: usageTypeStoreForSCSSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品品种',
                fieldLabel: '产品品种',
                selectOnFocus: true,
                id: 'cbUsageTypeForSCSSummeryViewSearch',
                width: 220,
                blankText: '请选择产品品种',
                valueField: 'id',
                editable: true
            };

            //14  产品类别
            var cbProductTypeForSCSSummeryViewSearch = {
                xtype: 'combo',
                store: productTypeStoreForSCSSummeryViewSearch,
                displayField: 'name',
                typeAhead: true,
                mode: 'local',
                forceSelection: true,
                triggerAction: 'all',
                emptyText: '请选择产品类别',
                fieldLabel: '产品类别',
                selectOnFocus: true,
                id: 'cbProductTypeForSCSSummeryViewSearch',
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
                items: [cbProductCodeForSCSSummeryViewSearch, cbErrorLevelForSCSSummeryViewSearch, txtVoltageForSCSSummeryViewSearch, txtProductCombinationForSCSSummeryViewSearch, txtMinForSCSSummeryViewSearch, cbVarAmount, srAmount1]
            };

            var col2 = {
                columnWidth: .5,
                layout: 'form',
                frame: false,
                border: false,
                defaultType: 'textfield',
                items: [cbProductTypeForSCSSummeryViewSearch, cbHumidityForSCSSummeryViewSearch, cbUsageTypeForSCSSummeryViewSearch, txtCapacityForSCSSummeryViewSearch, txtMaxForSCSSummeryViewSearch]
            };

            var SCSSummeryViewSearchGrid = new Ext.grid.EditorGridPanel({
                xtype: 'grid',
                id: 'SCSSummeryViewSearch-grid',
                anchor: '100% 75%',
                store: SCSSummeryViewSearchStore,
                stripeRows: true,
                autoScroll: true,
                clicksToEdit: 1,
                border: false,
                loadMask: true,
                frame: true,
                renderTo: 'SCSSummeryViewSearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '产品名称及型号', width: 150, dataIndex: 'productCombination', editor: {xtype: 'textfield'}},
                        {header: '库存数', width: 50, dataIndex: 'srTotalAmount'},
                        {header: '资源数', width: 50, dataIndex: 'srAmount'},
                        {header: '合同审核数', width: 60, dataIndex: 'coCheckingAmount'},
                        {header: '合同欠交数', width: 60, dataIndex: 'coUnfinishedAmount'},
                        {
                            header: '合同对库欠交数',
                            width: 80,
                            dataIndex: 'coOwnedAmount',
                            renderer: clsys.grid.columnrender.coOwnedAmount
                        },
                        {header: '计划欠交数', width: 60, dataIndex: 'ssRestAmount'},
                        {header: '差额', width: 50, dataIndex: 'varAmount', renderer: clsys.grid.columnrender.varStyle},
                        {header: '产品代号', width: 50, dataIndex: 'productCode'},
                        {header: '产品品种', width: 50, dataIndex: 'usageType'},
                        {header: '电压', width: 40, dataIndex: 'voltage'},
                        {header: '容量', width: 40, dataIndex: 'capacity'},
                        {header: '湿度', width: 40, dataIndex: 'humidity'},
                        {header: '误差', width: 40, dataIndex: 'errorLevel'},
                        {header: '单位', width: 40, dataIndex: 'unit'}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            });

            var SCSSummerySearchGrid = new Ext.grid.EditorGridPanel({
                xtype: 'grid',
                id: 'SCSSummerySearch-grid',
                anchor: '100% 15%',
                store: SCSSummerySearchStore,
                stripeRows: true,
                autoScroll: true,
                clicksToEdit: 1,
                border: false,
                loadMask: true,
                frame: true,
                renderTo: 'SCSSummerySearchGridPanel',
                colModel: new Ext.grid.ColumnModel({
                    defaults: {sortable: true},
                    columns: [
                        {header: '库存数合计', width: 50, dataIndex: 'srTotalAmount'},
                        {header: '资源数合计', width: 50, dataIndex: 'srAmount'},
                        {header: '合同审核数合计', width: 60, dataIndex: 'coCheckingAmount'},
                        {header: '合同欠交数合计', width: 60, dataIndex: 'coUnfinishedAmount'},
                        {
                            header: '合同对库欠交数合计',
                            width: 80,
                            dataIndex: 'coOwnedAmount',
                            renderer: clsys.grid.columnrender.coOwnedAmount
                        },
                        {header: '计划欠交数合计', width: 60, dataIndex: 'ssRestAmount'},
                        {header: '差额合计', width: 50, dataIndex: 'varAmount', renderer: clsys.grid.columnrender.varStyle}
                    ]
                }),
                viewConfig: {forceFit: true},
                sm: new Ext.grid.RowSelectionModel({singleSelect: true})
            });


            var btnDown = {
                text: 'Excel导出',
                iconCls: 'icon-down',
                handler: function () {
                    var attributes = {
                        varAmount: encodeURI(Ext.getCmp('cbVarAmount').getValue()),
                        minAmount: encodeURI(Ext.getCmp('txtMinForSCSSummeryViewSearch').getValue()),
                        maxAmount: encodeURI(Ext.getCmp('txtMaxForSCSSummeryViewSearch').getValue()),
                        productCombination: encodeURI(Ext.getCmp('txtProductCombinationForSCSSummeryViewSearch').getValue()),
                        productCode: encodeURI(Ext.getCmp('cbProductCodeForSCSSummeryViewSearch').getValue()),
                        errorLevel: encodeURI(Ext.getCmp('cbErrorLevelForSCSSummeryViewSearch').getValue()),
                        voltage: encodeURI(Ext.getCmp('txtVoltageForSCSSummeryViewSearch').getValue()),
                        capacity: encodeURI(Ext.getCmp('txtCapacityForSCSSummeryViewSearch').getValue()),
                        productType: encodeURI(Ext.getCmp('cbProductTypeForSCSSummeryViewSearch').getValue()),
                        humidity: encodeURI(Ext.getCmp('cbHumidityForSCSSummeryViewSearch').getValue()),
                        usageType: encodeURI(Ext.getCmp('cbUsageTypeForSCSSummeryViewSearch').getValue()),
                        srAmount: encodeURI(Ext.getCmp('srAmount1').getValue())
                    };

                    //如果不存在一个id为"downForm"的form表单，则执行下面的操作
                    if (!Ext.fly('downForm10')) {

                        //下面代码是在创建一个表单以及添加相应的一些属性
                        var downForm = document.createElement('form');  //创建一个form表单
                        downForm.id = 'downForm10'; 　　//该表单的id为downForm
                        downForm.name = 'downForm10';  //该表单的name属性为downForm
                        downForm.className = 'x-hidden'; //该表单为隐藏的
//                        downForm.action = 'getcontractAction.action'; //表单的提交地址
                        downForm.method = 'POST';  //表单的提交方法

                        document.body.appendChild(downForm); //将form表单追加到body里面
                    }

                    Ext.Ajax.request({
                        disableCaching: true,
                        url: 'getSCSSummeryViewAction.action',
                        method: 'POST',
                        isUpload: true,
                        form: Ext.fly('downForm10'),
                        params: attributes
                    });
                }
            };

            var SCSSummeryViewQueryConditionPanel = new Ext.FormPanel({
                frame: true,
                bodyStyle: 'padding:5px 5px 0',
                collapsible: true,
                collapsed: false,
                title: '查询条件',
                labelWidth: 150,
                renderTo: 'SCSSummeryViewQueryConditionPanel',
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
                            varAmount: Ext.getCmp('cbVarAmount').getValue(),
                            minAmount: Ext.getCmp('txtMinForSCSSummeryViewSearch').getValue(),
                            maxAmount: Ext.getCmp('txtMaxForSCSSummeryViewSearch').getValue(),
                            productCombination: Ext.getCmp('txtProductCombinationForSCSSummeryViewSearch').getValue(),
                            productCode: Ext.getCmp('cbProductCodeForSCSSummeryViewSearch').getValue(),
                            errorLevel: Ext.getCmp('cbErrorLevelForSCSSummeryViewSearch').getValue(),
                            voltage: Ext.getCmp('txtVoltageForSCSSummeryViewSearch').getValue(),
                            capacity: Ext.getCmp('txtCapacityForSCSSummeryViewSearch').getValue(),
                            productType: Ext.getCmp('cbProductTypeForSCSSummeryViewSearch').getValue(),
                            humidity: Ext.getCmp('cbHumidityForSCSSummeryViewSearch').getValue(),
                            usageType: Ext.getCmp('cbUsageTypeForSCSSummeryViewSearch').getValue(),
                            srAmount: Ext.getCmp('srAmount1').getValue()
                        };
                        attributes.start = 0;
                        SCSSummeryViewSearchStore.reload({params: attributes});
                        SCSSummerySearchStore.reload({params: attributes});
                    }
                }, {
                    text: '清除',
                    iconCls: 'icon-remove',
                    handler: function () {
                        SCSSummeryViewQueryConditionPanel.getForm().reset();
                    }
                }, {
                    text: '刷新',
                    iconCls: 'icon-refresh',
                    handler: function () {
                        SCSSummeryViewSearchStore.reload();
                    },
                    scope: this
                }, btnDown]
            });

            var SCSSummeryViewSearchPanel = Ext.getCmp('SCSSummeryViewSearch-mainpanel');
            SCSSummeryViewSearchPanel.add(SCSSummeryViewQueryConditionPanel, SCSSummerySearchGrid, SCSSummeryViewSearchGrid);
            clsys.form.Util.PagingToolbar(SCSSummeryViewSearchStore, SCSSummeryViewSearchPanel.tbar, 'SCSSummeryViewSearch-paging');
            SCSSummeryViewSearchPanel.doLayout();

        });
    </script>
</head>
<body>
<div id="SCSSummeryViewSearchPanel"></div>
<div id="SCSSummerySearchGridPanel"></div>
<div id="SCSSummeryViewSearchGridPanel"></div>
<div id="SCSSummeryViewSearchItemsPanel"></div>
<div id="SCSSummeryViewQueryConditionPanel"></div>
</body>
</html>