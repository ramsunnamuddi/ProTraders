<!-- User Management -->
<div class="content-section d-none" id="usersContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-people me-2"></i>User Management</h2> 
    </div>
	<div class="card shadow mb-4">
		<div class="card-body py-2">
			<div class="row g-3 align-items-center">
				<div class="col-md-3 col-6">
					<label class="form-label">From Date</label>
					<input type="date" class="form-control form-control-sm" id="usersFromDate">
				</div>
				<div class="col-md-3 col-6">
					<label class="form-label">To Date</label>
					<input type="date" class="form-control form-control-sm" id="usersToDate">
				</div>						
				<div class="col-md-3 col-6">
					<label class="form-label">Search</label>
					<input type="text" class="form-control form-control-sm" id="usersSearch" placeholder="Name, Email, ID">
				</div>
				<div class="col-12 text-end">
					<button class="btn btn-sm btn-primary me-2" id="applyUsersFilters">
						<i class="bi bi-funnel me-1"></i> Apply
					</button>
					<button class="btn btn-sm btn-outline-secondary" id="resetUsersFilters">
						<i class="bi bi-arrow-counterclockwise me-1"></i> Reset
					</button>
				</div>
			</div>
		</div>
	</div>
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">All Users</h6>
            <div>
                <button class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-download me-1"></i> Export
                </button>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover" id="usersTBL">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Name</th>
                            <th>Email</th>
							<th>Mobile No.</th>
                            <th>Registered on</th>
							<th>Details</th>
							<th>Bank Details</th>
							<th>Change Password</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
    </div>

    <%--/*<div class="row">
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">New Users (Last 7 Days)</h6>
                </div>
                <div class="card-body">
                    <div class="chart-container" style="height: 250px;">
                        <canvas id="newUsersChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">User Activity</h6>
                </div>
                <div class="card-body">
                    <div class="chart-container" style="height: 250px;">
                        <canvas id="userActivityChart"></canvas>
                    </div>
                </div>
            </div>
        </div>*/--%>
    </div>