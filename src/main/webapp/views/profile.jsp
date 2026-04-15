<div class="container mt-5">
    <h3>Account Settings</h3>
    <div class="row">
        <!-- Sidebar Tabs -->
        <div class="col-md-3">
            <ul class="nav flex-column nav-tabs" id="accountTabs">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" href="#profileTab">General</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#passwordTab">Change Password</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#bankTab">Bank Accounts</a>
                </li>
            </ul>
        </div>

        <!-- Tab Content -->
        <div class="col-md-9">
            <div class="tab-content">
                <!-- General Tab -->
                <div class="tab-pane fade show active" id="profileTab">
                    <div class="card p-4">
                        <h5>General Information</h5>
                        <form id="profileForm">
                            <div class="mb-3">
                                <label class="form-label">Username</label>
                                <input type="text" class="form-control" value="${profileDetails.userId}" readonly disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="${profileDetails.name}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">E-mail</label>
                                <input type="email" class="form-control" id="email" name="email" value="${profileDetails.email}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mobile Number</label>
                                <input type="text" class="form-control" id="number" name="number" value="${profileDetails.number}">
                            </div>
							<input type="hidden" name="type" id="type" value="gnrl">
                        </form>
                        <button class="btn btn-dark" onclick="saveProfile()" id="svusrdtls">Update User details</button>
                    </div>
                </div>

                <!-- Change Password Tab -->
                <div class="tab-pane fade" id="passwordTab">
                    <div class="card p-4">
                        <h5>Change Password</h5>
                        <form id="passwordForm">
                            <div class="mb-3">
                                <label class="form-label">Current Password</label>
                                <input type="password" name="password" class="form-control" id="password">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">New Password</label>
                                <input type="password" class="form-control" name="newpwd" id="newpwd">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Confirm Password</label>
                                <input type="password" class="form-control" name="cnfpwd" id="cnfpwd">
                            </div>

							<input type="hidden" name="type" id="pwdtype" value="pwd">
                        </form>
                        <button class="btn btn-dark" onclick="savePassword()" id="updpwd">Change Password</button>
                    </div>
                </div>

                <!-- Bank Accounts Tab -->
                <div class="tab-pane fade" id="bankTab">
                    <div class="card p-4">
                        <h5>Bank Account Details</h5>
                        <form id="bankForm">
                            <div class="mb-3">
                                <label class="form-label">Account Holder Name</label>
                                <input type="text" class="form-control" id="accountHolderName" name="accountHolderName" value="${profileDetails.accountHolderName}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Account Number</label>
								<input type="text" class="form-control" id="accountNo" name="accountNo" value="${profileDetails.accountNo}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Branch</label>
                                <input type="text" class="form-control" id="accountBranch" name="accountBranch" value="${profileDetails.accountBranch}">
                            </div>
							<div class="mb-3">
                                <label class="form-label">IFSC Code</label>
                                <input type="text" class="form-control" id="ifsCode" name="ifsCode" value="${profileDetails.ifsCode}">
                            </div>
							<div class="mb-3">
                                <label class="form-label">Bank Name</label>
                                <input type="text" class="form-control" id="bankName" name="bankName" value="${profileDetails.bankName}">
                            </div>
							<input type="hidden" name="type" id="bnktype" value="bank">
                        </form>
                        <button class="btn btn-dark" onclick="saveBankDetails()" id="updbnkdtls">Save Changes</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
