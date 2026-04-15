<div class="container mt-4">
        <!-- Filters -->
        <div class="row mb-3" id="bns-fltr">
            <div class="col-md-3">
                <label>From Date:</label>
                <input type="date" id="bnsFromDate" class="form-control">
            </div>
            <div class="col-md-3">
                <label>To Date:</label>
                <input type="date" id="bnsToDate" class="form-control">
            </div>
            <div class="col-md-3" style="display:none;">
                <label>Status:</label>
                <select id="position" class="form-select" >
                    <option value="">All</option>
                    <option value="1">Left</option>
                    <option value="2">Right</option>
                </select>
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <button class="btn btn-primary" onclick="reloadTabData()">Apply Filters</button>
            </div>
        </div>

        <!-- Tabs -->
        <ul class="nav nav-tabs" id="dataTabs">
            <li class="nav-item">
                <a class="nav-link active disabled" data-tab="roibns" onclick="switchBnsTab(event)">ROI Bonus</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-tab="drctbns" onclick="switchBnsTab(event)">Direct Bonus</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-tab="bnrybns" onclick="switchBnsTab(event)">Binary Bonus</a>
            </li>
        </ul>
		<!-- Tab Content -->
	    <div class="tab-content mt-3" id="tabContent">
			<div class="justify-content-between align-items-center mb-4" style="display:none" id="bnswdw" >
                <h5>Total Bonus:<span id="totamt"></span></h5>
                <button class="btn btn-primary" id="bnrywdw" onclick="wdwbnryAmt(this)" data-tot-amt="">Withdraw</button>
            </div>
	     	<div id="tabData" class="table-responsive">
	        	<p class="text-center">Loading data...</p>
	         </div>
	      </div>
		  
	  </div>