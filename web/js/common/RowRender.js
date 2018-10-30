
Ext.ns('clsys.grid.rowrender');

clsys.grid.rowrender.contractClasses = [
	'is-grid-row-contract-created',
	'is-grid-row-contract-waiting',
	'is-grid-row-contract-audited',
	'is-grid-row-contract-audit-failed',
	'is-grid-row-contract-executing',
	'is-grid-row-contract-financial-confirmed',
	'is-grid-row-contract-deleted',
	'is-grid-row-contract-finished',
	'is-grid-row-contract-mixed',
	'is-grid-row-contract-unknown',
];

clsys.grid.rowrender.getContractClass = function(state) {
	if (state == -1) {
		return 'is-grid-row-contract-mixed';
	}
	
	if (clsys.grid.rowrender.contractClasses[state]) {
		return clsys.grid.rowrender.contractClasses[state];
	} else {
		return 'is-grid-row-contract-unknown';
	}
};