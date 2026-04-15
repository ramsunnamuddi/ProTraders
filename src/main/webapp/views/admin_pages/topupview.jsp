<!-- Top-Up Packages -->
<div class="content-section d-none" id="topupContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-coin me-2"></i>Top-Up Packages</h2>
		<div class="btn-group">
			<button class="btn btn-outline-primary export-btn" id="topuppdf">
                <i class="bi bi-download me-1"></i> Export
            </button>&nbsp;
			<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPackageModal">
				<i class="bi bi-plus-circle me-1"></i> Add Package
			</button>
        </div>
    </div>
	<div class="card shadow mb-4">
		<div class="card-body py-2">
			<div class="row g-3 align-items-center">
				<div class="col-md-3 col-6">
					<label class="form-label">From Date</label>
					<input type="date" class="form-control form-control-sm" id="topupFromDate">
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">To Date</label>
					<input type="date" class="form-control form-control-sm" id="topupToDate">
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">Status</label>
					<select class="form-select form-select-sm" id="topupStatus">
						<option value="">All</option>
						<option value="Active">Active</option>
						<option value="In Progress">In Progress</option>
						<option value="Withdrawan">Withdrawan</option>
					</select>
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">Package</label>
					<select class="form-select form-select-sm" id="topupPackage">
						<option value="">All Packages</option>
						<c:choose>
							<c:when test="${not empty dshbrdDtls.topupPieChart.pkg_amt}">
								<c:set var="count" value="0" />

								<c:forEach var="amt" items="${dshbrdDtls.topupPieChart.pkg_amt}">
									 <option value="${fn:replace(amt, '\"', '')}">${fn:replace(amt, '\"', '')}</option>
								</c:forEach>
							</c:when>

							<c:otherwise>
								<tr>
									<td colspan="4" style="text-align:center;border:none;">No data available</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</select>
				</div>
				<div class="col-12 text-end">
					<button class="btn btn-sm btn-primary me-2" id="applyTopupFilters">
						<i class="bi bi-funnel me-1"></i> Apply
					</button>
					<button class="btn btn-sm btn-outline-secondary" id="resetTopupFilters">
						<i class="bi bi-arrow-counterclockwise me-1"></i> Reset
					</button>
				</div>
			</div>
		</div>
	</div>

    <div class="row mb-4" >
        <div class="col-md-6" >
            <div class="card shadow h-100">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Package Configuration</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="topupPkgsTBL">
                            <thead>
                                <tr>
                                    <th>Package</th>
                                    <th>Amount</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card shadow h-100">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Top-Up History</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover" id="topupHisTBL">
                            <thead>
                                <tr>
                                    <th>Customer Name</th>
									<th>Customer ID</th>
									<th class='text-right'>Amount</th>
									<th>Status</th>
									<th>Date/Time</th>
									<th>Expiry Date</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
						<div id="topupPagination" class="mt-3 text-center paging"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="card shadow">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Package Performance</h6>
        </div>
        <div class="card-body">
            <div class="chart-container" style="height: 300px;">
                <canvas id="packagePerformanceChart"></canvas>
            </div>
        </div>
    </div>
</div>