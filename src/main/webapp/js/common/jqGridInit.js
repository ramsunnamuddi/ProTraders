// jqGridInit.js
function initializeJqGrid(gridId,  colNames, colModel, rowNum, pagerId,dT) {
    $(gridId).jqGrid({
        datatype: "local",  // Data type
		data: dT,
        colNames: colNames,  // Column headers
        colModel: colModel,  // Column model
		rownumbers: false,
		multiselect: false, 
        rowNum: rowNum,  // Number of rows to display per page
        rowList: [10, 20, 30],  // Options for rows per page
        pager: pagerId,  // Pager container ID
        sortorder: "desc",  // Default sort order
        viewrecords: true,  // Show record count
        autowidth: true,  // Auto width
        height: 'auto',  // Set dynamic height
        caption: "",  // Title of the grid
		sortable: false, // Disable sorting
        sortname: '', // No default sorting
        sortorder: '' ,
        loadComplete: function() {
            // You can add custom code to execute after grid loads
            console.log('Grid Loaded');
        },			
		gridComplete: function() {
	        var rowData = $(gridId).jqGrid('getRowData');
	        if (rowData.length === 0) {
	            $(gridId).parent().append("<div class='no-data-message'>No data available</div>");
				$(pagerId).hide();
	        } else {
	            $('.no-data-message').remove(); // Remove if data is available
				$(pagerId).show();
	        }
	    }
    });
    
    // Add a custom search functionality (optional)
    //$("#" + gridId).jqGrid('navGrid', "#" + pagerId, {edit: false, add: false, del: false});
}

function formatNumber(number) {
	if (isNaN(number)) return number;
	number = number.toFixed(2);
	return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}
