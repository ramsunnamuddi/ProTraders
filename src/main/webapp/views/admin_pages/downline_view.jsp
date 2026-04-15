<div class="content-section d-none container mt-4" id="dlContent">
        <!-- Tabs -->
		<div class="card shadow mb-4">
				<div class="card-body py-2">
					<div class="row g-3 align-items-center">
						<div class="col-md-3 col-6">
							<label class="form-label">Search</label>
							<input type="text" class="form-control form-control-sm" id="dlusrsrch" placeholder="CUST123456">
						</div>
						<div class="col-12 text-end">
							<button class="btn btn-sm btn-primary me-2" id="applyDLFilters">
								<i class="bi bi-funnel me-1"></i> Apply
							</button>
							<button class="btn btn-sm btn-outline-secondary" id="resetDLFilters">
								<i class="bi bi-arrow-counterclockwise me-1"></i> Reset
							</button>
						</div>
					</div>
				</div>
			</div>
        <ul class="nav nav-tabs" id="dldataTabs">
            <li class="nav-item dl-nav-item">
                <a class="nav-link dl-nav-link active disabled" data-tab="au" onclick="switchDlTab(event)">Active Users</a>
            </li>
            <li class="nav-item dl-nav-item">
                <a class="nav-link dl-nav-link" data-tab="ld" onclick="switchDlTab(event)">Level Downline</a>
            </li>
            <li class="nav-item dl-nav-item">
                <a class="nav-link dl-nav-link" data-tab="tt" onclick="switchDlTab(event)">Total Team</a>
            </li>
			<li class="nav-item dl-nav-item">
               <a class="nav-link dl-nav-link" data-tab="gt" onclick="switchDlTab(event)">Genealogy Tree</a>
           </li>
        </ul>
		<!-- Tab Content -->
	    <div class="tab-content mt-3" id="tabContent">
	          <div id="tabData" class="table-responsive">
	              <p class="text-center" id="lodingDv">Loading data...</p>
	          </div>
	      </div>
		  
	  </div>