<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!-- Add Package Modal -->
<!-- Top-Up Packages -->
        <div class="content-section" id="topupContent">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-coin me-2"></i>Top-Up Packages</h2>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                    <i class="bi bi-plus-circle me-1"></i> Purchange Package
                </button>
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
								<option value="Processing">In process</option>
								<option value="Completed">Completed</option>
								<option value="Withdrawan">Withdrawan</option>
								
							</select>
						</div>
						<div class="col-md-3 col-6">
							<label class="form-label">Package</label>
							<select class="form-select form-select-sm" id="topupPackage">
								<option value="">All Packages</option>
								<c:choose>
									<c:when test="${not empty pkgs}">
										<c:set var="count" value="0" />
	
										<c:forEach var="pkg" items="${pkgs}">
											 <option value="${fn:replace(pkg.pkg_amt, '\"', '')}">${fn:replace(pkg.pkg_amt, '\"', '')}</option>
										</c:forEach>
									</c:when>
	
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
                <div class="col-md-6" style="width:100%">
                    <div class="card shadow h-100">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Top-Up History</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="topupHisTBL">
                                    <thead>
                                        <tr>
                                            <th>Transaction ID</th>
											<th>Amount</th>
											<th>Status</th>
											<th>Date/Time</th>
											<th>Expiry Date/Time</th>
											
											
                                        </tr>
                                    </thead>
                                    <tbody>
										<c:choose>
								            <c:when test="${not empty topups}">
								                <c:forEach var="transaction" items="${topups}">
								                    <tr>
								                        <td><c:out value="${transaction[0]}" /></td>
								                        <td>₹<c:out value="${transaction[1]}" /></td>
								                        <td>
															<c:set var="statusClass" value="" />
								                            <c:choose>
								                                <c:when test="${transaction[2] eq 'Active'}">
								                                    <c:set var="statusClass" value="badge bg-success" />
								                                </c:when>
								                                <c:when test="${transaction[2] eq 'Processing'}">
								                                    <c:set var="statusClass" value="badge bg-warning" />
								                                </c:when>
								                                <c:when test="${transaction[2] eq 'Completed'}">
								                                    <c:set var="statusClass" value="badge bg-dark" />
								                                </c:when>
																<c:when test="${transaction[2] eq 'Withdrawan'}">
								                                    <c:set var="statusClass" value="badge bg-secondary" />
								                                </c:when>
																<c:when test="${transaction[2] eq 'In Progress'}">
								                                    <c:set var="statusClass" value="badge bg-warning" />
								                                </c:when>
																<c:when test="${transaction[2] eq 'Expired'}">
																    <c:set var="statusClass" value="badge badge-info" />
																</c:when>
								                            </c:choose>
															<span class="${statusClass}"><c:out value="${transaction[2]}" /></span>
														</td>
								                        <td><c:out value="${transaction[4]}" /></td>
														<td><c:out value="${transaction[5]}" /></td>
								                    </tr>
								                </c:forEach>
								            </c:when>

											<c:otherwise>
												<tr>
													<td colspan="4" style="text-align:center;border:none;">No data available</td>
												</tr>
											</c:otherwise>
								        </c:choose>
									</tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

   <div class="modal fade" id="addPackageModal" tabindex="-1" aria-hidden="true">
       <div class="modal-dialog">
           <div class="modal-content">
               <div class="modal-header">
                   <h5 class="modal-title">Add New Package</h5>
                   <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
               </div>
               <div class="modal-body">
					<div class="mb-3">top
                       <label class="form-label">Available Balance</label>
                       <input type="text" class="form-control" value="${balance}" disabled id="availbal">
                   </div>
                   <form id="purchasepkgFrm" >
                       <div class="mb-3">
                           <label class="form-label">Amount (₹)</label>
						   <select class="form-select form-select-sm" id="purchagepkg" name="amount">
						   <c:choose>
								<c:when test="${not empty pkgs}">
									<c:set var="count" value="0" />
									<c:forEach var="pkg" items="${pkgs}">
										<c:if test="${balance >= pkg.pkg_amt}">
					                       <option value="${fn:replace(pkg.pkg_amt, '\"', '')}">
					                           ${fn:replace(pkg.pkg_amt, '\"', '')}
					                       </option>
					                   </c:if>
									</c:forEach>
								</c:when>
							</c:choose>
							</select>
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
   <div id="topupPagination" class="mt-3 text-center">
	    <c:if test="${totalPages > 1}">
	        <c:forEach var="i" begin="1" end="${totalPages}">
	            <button 
	                class="btn btn-sm ${currentPage == i ? 'btn-primary' : 'btn-outline-primary'} m-1"
	                onclick="tpuphdlPgn(${i})"
	                ${currentPage == i ? 'disabled aria-current="page"' : ''}
	            >
	                ${i}
	            </button>
	        </c:forEach>
	    </c:if>
	</div>
