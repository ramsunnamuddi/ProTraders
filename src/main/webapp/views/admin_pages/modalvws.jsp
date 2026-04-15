<!-- Add Package Modal -->
   <div class="modal fade" id="addPackageModal" tabindex="-1" aria-hidden="true">
       <div class="modal-dialog">
           <div class="modal-content">
               <div class="modal-header">
                   <h5 class="modal-title">Add New Package</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>
               <div class="modal-body">
                   <form id="addPackage">
                       <div class="mb-3">
                           <label class="form-label">Customer Id</label>
                           <input type="text" class="form-control" placeholder="e.g., ABC123456" name="custId">
                       </div>
                       <div class="mb-3">
                           <label class="form-label">Package Amount (₹)</label>
                           <input type="number" class="form-control" placeholder="e.g., 2999" name="amt" >
                       </div>
					<div class="modal-footer">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                    <button type="submit" class="btn btn-primary">Purchase</button>
	                </div>
                   </form>
               </div>
               
           </div>
       </div>
   </div>

<!-- Add Funds Modal -->
   <div class="modal fade" id="addFundsModal" tabindex="-1" aria-hidden="true">
       <div class="modal-dialog">
           <div class="modal-content">
               <div class="modal-header">
                   <h5 class="modal-title">Add New Funds</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>
               <div class="modal-body">
                   <form id="addFnds">
                       <div class="mb-3">
                           <label class="form-label">Customer Id</label>
                           <input type="text" class="form-control" name="custId">
                       </div>
                       <div class="mb-3">
                           <label class="form-label">Amount (₹)</label>
                           <input type="number" name="amt" class="form-control" placeholder="e.g., 2999">
                       </div> 
					<div class="modal-footer">
					    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
					    <button type="submit" class="btn btn-primary">Add Funds</button>
					</div>                                             
                   </form>
               </div>
           </div>
       </div>
   </div>

<div class="modal fade" id="bankDtls" tabindex="-1" aria-hidden="true">
       <div class="modal-dialog">
           <div class="modal-content">
               <div class="modal-header">
                   <h5 class="modal-title">Add User Bank Details</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>
               <div class="modal-body">
                   <form id="svbnkdtl">
                       <div class="mb-3">
                           <label class="form-label">Customer Id</label>
                           <input type="text" class="form-control" name="custId" placeholder="e.g., CUST123">
                       </div>
                       <div class="mb-3">
                           <label class="form-label">Account Number</label>
						<input type="text" class="form-control" name="accountNo" placeholder="e.g., 0123456789">	                            
                       </div>
					<div class="mb-3">
                           <label class="form-label">Account Holder name</label>
						<input type="text" class="form-control" name="accountHolderName" placeholder="e.g., abc">	                            
                       </div>
					<div class="mb-3">
                           <label class="form-label">Branch Name</label>
						<input type="text" class="form-control" name="accountBranch" placeholder="e.g., abc">	                            
                       </div>
					<div class="mb-3">
					    <label class="form-label">IFSC code</label>
						<input type="text" class="form-control" name="ifsCode" placeholder="e.g., abc000123">	                            
					</div>
					<div class="mb-3">
					    <label class="form-label">Bank Name</label>
						<input type="text" class="form-control" name="bankName" placeholder="e.g., abc">	                            
					</div>
					<div class="modal-footer">
	                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                    <button type="submit" class="btn btn-primary">Save</button>
	                </div>
                   </form>
               </div>
           </div>
       </div>
 </div>
 
<div class="modal fade" id="chngPwdModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Change Password</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="chngpwd">
                    <div class="mb-3">
                        <label class="form-label">Customer Id</label>
                        <input type="text" class="form-control" name="custId">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Enter New password</label>
                        <input type="password" name="password" value="" class="form-control">
                    </div>  
				 <div class="mb-3">
                        <label class="form-label">Confirm New password</label>
                        <input type="password"  name="newpwd" value="" class="form-control">
                    </div>                                             
				 <div class="modal-footer">
	                     <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	                     <button type="submit" class="btn btn-primary">Update</button>
	                 </div>
                </form>
            </div>
        </div>
    </div>
</div>

 
<div class="modal fade" id="usrDtlsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog  modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
				<div class="table-responsive">
					<table class="table table-hover">
		                <thead>
		                    <tr>
		                        <th>User</th>
		                        <th>Active Directives</th>
		                        <th>Account Balance</th>
								<th>Left Business</th>
								<th>Right Business</th>
								<th>Withdrawal Amount</th>
		                    </tr>
		                </thead>
		                <tbody></tbody>
					</table>
				</div>
            </div>
        </div>
    </div>
</div>