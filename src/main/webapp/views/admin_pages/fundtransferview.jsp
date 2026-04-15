<!-- Fund Transfer -->
        <div class="content-section d-none" id="fundTransferContent">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-qr-code me-2"></i>Fund Transfer Management</h2>
				<div class="btn-group">
					<button class="btn btn-outline-primary export-btn" id="fndtrnspdf">
		                <i class="bi bi-download me-1"></i> Export
		            </button>&nbsp;
	                <button class="btn btn-primary" data-bs-toggle="modal"  data-bs-target="#addFundsModal">
	                    <i class="bi bi-plus-circle me-1"></i> Add Funds
	                </button>
		        </div>
				
            </div>
			<div class="card shadow mb-4">
				<div class="card-body py-2">
					<div class="row g-3 align-items-center">
						<div class="col-md-3 col-6">
							<label class="form-label">From Date</label>
							<input type="date" class="form-control form-control-sm" id="fundTransferFromDate">
						</div>
						<div class="col-md-3 col-6">
							<label class="form-label">To Date</label>
							<input type="date" class="form-control form-control-sm" id="fundTransferToDate">
						</div>
						<div class="col-md-3 col-6">
							<label class="form-label">Status</label>
							<select class="form-select form-select-sm" id="fundTransferStatus">
								<option value="">All</option>
								<option value="SUCCESS">Success</option>
								<option value="PENDING">Pending</option>
								<option value="FAILED">Failed</option>
							</select>
						</div>
						<div class="col-12 text-end">
							<button class="btn btn-sm btn-primary me-2" id="applyFundTransferFilters">
								<i class="bi bi-funnel me-1"></i> Apply
							</button>
							<button class="btn btn-sm btn-outline-secondary" id="resetFundTransferFilters">
								<i class="bi bi-arrow-counterclockwise me-1"></i> Reset
							</button>
						</div>
					</div>
				</div>
			</div>
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Transfer History</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="fundTransferTBL">
                            <thead>
                                <tr>
                                    <th>Customer Name</th>
                                    <th>Customer ID</th>
                                    <th class='text-right'>Amount</th>
                                    <th>Status</th>
                                    <th>Date/Time</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
		<div id="fundTransferPagination" class="mt-3 text-center paging"></div>