<!-- Withdrawal Management -->
<div class="content-section d-none" id="withdrawalContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-cash-stack me-2"></i>Withdrawal Management</h2>
        <div class="btn-group">
            <button class="btn btn-outline-primary export-btn" id="wdwpdf">
                <i class="bi bi-download me-1"></i> Export
            </button>
        </div>
    </div>
	<div class="card shadow mb-4">
		<div class="card-body py-2">
			<div class="row g-3 align-items-center">
				<div class="col-md-3 col-6">
					<label class="form-label">From Date</label>
					<input type="date" class="form-control form-control-sm" id="withdrawalFromDate">
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">To Date</label>
					<input type="date" class="form-control form-control-sm" id="withdrawalToDate">
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">Status</label>
					<select class="form-select form-select-sm" id="withdrawalStatus">
						<option value="">All</option>
						<option value="APPROVED">Approved</option>
						<option value="PENDING">Pending</option>
						<option value="REJECTED">Rejected</option>
					</select>
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">Search</label>
					<input type="text" class="form-control form-control-sm" id="wdwSearch" placeholder="Name, Email, ID">
				</div>
				<div class="col-12 text-end">
					<button class="btn btn-sm btn-primary me-2" id="applyWithdrawalFilters">
						<i class="bi bi-funnel me-1"></i> Apply
					</button>
					<button class="btn btn-sm btn-outline-secondary" id="resetWithdrawalFilters">
						<i class="bi bi-arrow-counterclockwise me-1"></i> Reset
					</button>
				</div>
			</div>
		</div>
	</div>
	<div id="bulkActions" class="col-12 text-end" style="display:none; margin: 10px 0px 10px 0px">
	    <button class="btn btn-sm btn-success" onclick="swBulkCnfMdl('Approved')">Approve</button>
	    <button class="btn btn-sm btn-danger" onclick="swBulkCnfMdl('Rejected')">Reject</button>
	</div>
    <div class="tab-content" id="withdrawalTabsContent">
        <div class="tab-pane fade show active" id="pending" role="tabpanel">
            <div class="card shadow">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="withdrawalTBL">
                            <thead>
                                <tr>
									<th>Serial No#</th>
                                    <th>Customer Name</th>
                                    <th>Customer ID</th>
									<th class='text-right'>Package</th>
									<th class='text-right'>Interest Amount</th>
									<th class='text-right'>Withdrawan Amount</th>
									<th>Status</th>
                                    <th>Request Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="withdrawalPagination" class="mt-3 text-center paging"></div>