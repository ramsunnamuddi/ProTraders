<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<div class="content-section" id="withdrawalContent">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="bi bi-cash-stack me-2"></i>Withdrawal Management</h2>
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
								<option value="Approved">Approved</option>
								<option value="Pending">Pending</option>
								<option value="Rejected">Rejected</option>
							</select>
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

            <div class="tab-content" id="withdrawalTabsContent">
                <div class="tab-pane fade show active" id="pending" role="tabpanel">
                    <div class="card shadow">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover" id="withdrawalTBL">
                                    <thead>
                                        <tr>
                                            <th>Request ID</th>
											<th>Topup Id</th>
											<th>Package</th>
											<th>Interest Amount</th>											
                                            <th>Withdrawan Amount</th>											
											<th>Actions</th>
                                            <th>Request Date</th>
                                            
                                        </tr>
                                    </thead>
                                    <tbody>
										<c:choose>
								            <c:when test="${not empty wdws}">
								                <c:forEach var="transaction" items="${wdws}">
								                    <tr>
								                        <td><c:out value="${transaction[0]}" /></td>
														<td><c:out value="${transaction[5]}" /></td>
								                        <td>₹<c:out value="${transaction[6]}" /></td>
														<td>₹<c:out value="${transaction[7]}" /></td>
														<td>₹<c:out value="${transaction[1]}" /></td>														
								                        <td>
															<c:set var="statusClass" value="" />
								                            <c:choose>
								                                <c:when test="${transaction[2] eq 'Approved'}">
								                                    <c:set var="statusClass" value="badge bg-success" />
								                                </c:when>
								                                <c:when test="${transaction[2] eq 'Rejected'}">
								                                    <c:set var="statusClass" value="badge bg-danger" />
								                                </c:when>
								                                <c:when test="${transaction[2] eq 'Pending'}">
								                                    <c:set var="statusClass" value="badge bg-warning" />
								                                </c:when>
								                            </c:choose>
															<span class="${statusClass}"><c:out value="${transaction[2]}" /></span>
														</td>
								                        <td><c:out value="${transaction[4]}" /></td>
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
        </div>
		<div id="withdrawalPagination" class="mt-3 text-center">
		    <c:if test="${totalPages > 1}">
		        <c:forEach var="i" begin="1" end="${totalPages}">
		            <button 
		                class="btn btn-sm ${currentPage == i ? 'btn-primary' : 'btn-outline-primary'} m-1"
		                onclick="wdwhdlPgn(${i})"
		                ${currentPage == i ? 'disabled aria-current="page"' : ''}
		            >
		                ${i}
		            </button>
		        </c:forEach>
		    </c:if>
		</div>