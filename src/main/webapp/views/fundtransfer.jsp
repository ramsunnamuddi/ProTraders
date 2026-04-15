<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="content-section" id="fundTransferContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-qr-code me-2"></i>Fund Transfer Management</h2>
        <button class="btn btn-primary" data-bs-toggle="modal"  data-bs-target="#addFundsModal">
            <i class="bi bi-plus-circle me-1"></i> Add Funds
        </button>
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
                            <th>Transaction ID</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date/Time</th>
                        </tr>
                    </thead>
                    <tbody>
						<c:choose>
				            <c:when test="${not empty fundRequests}">
				                <c:forEach var="transaction" items="${fundRequests}">
				                    <tr>
				                        <td><c:out value="${transaction[0]}" /></td>
				                        <td><c:out value="${transaction[1]}" /></td>
				                        <td>
											<c:set var="statusClass" value="" />
				                            <c:choose>
				                                <c:when test="${transaction[2] eq 'SUCCESS'}">
				                                    <c:set var="statusClass" value="badge bg-success" />
				                                </c:when>
				                                <c:when test="${transaction[2] eq 'FAILED'}">
				                                    <c:set var="statusClass" value="badge bg-danger" />
				                                </c:when>
				                                <c:when test="${transaction[2] eq 'PENDING'}">
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
				                    <td colspan="4" class="text-center">No data found</td>
				                </tr>
				            </c:otherwise>
				        </c:choose>
					</tbody>
                </table>
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
                        <label class="form-label">Select payment method:</label>
                        <div class="row g-3">
                            <c:forEach items="${qrCodesList}" var="qrCode">
                            <div class="col-md-6 col-12">
                                <div class="qr-code-container position-relative" 
                                     onclick="showEnlargedQR('${qrCode}')">
                                    <c:choose>
                                        <c:when test="${fn:contains(qrCode, 'image/')}">
                                            <img src="${qrCode}" alt="QR Code" class="img-fluid rounded">
                                            <div class="qr-overlay position-absolute top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center">
                                                <span class="text-white fw-bold fs-5 bg-dark bg-opacity-75 px-3 py-1 rounded">Click Here</span>
                                            </div>
                                        </c:when>
                                        <c:when test="${fn:contains(qrCode, 'application/pdf')}">
                                            <div class="pdf-placeholder bg-light rounded p-4 text-center position-relative">
                                                <i class="bi bi-file-earmark-pdf fs-1 text-danger"></i>
                                                <p class="mt-2">PDF Document</p>
                                                <div class="qr-overlay position-absolute top-0 start-0 w-100 h-100 d-flex justify-content-center align-items-center">
                                                    <span class="text-white fw-bold fs-5 bg-dark bg-opacity-75 px-3 py-1 rounded">Click Here</span>
                                                </div>
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                    </div>                                           
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Enlarged QR Modal -->
<div class="modal fade" id="enlargedQRModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Scan QR Code</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body text-center" style="align-self:center;">
                <img id="enlargedQRImage" src="" alt="Enlarged QR Code" class="img-fluid" style="display:none;">
                <iframe id="enlargedPDF" src="" width="100%" height="600px" style="display:none;"></iframe>
            </div>
        </div>
    </div>
</div>
	<div id="fundTransferPagination" class="mt-3 text-center">
	    <c:if test="${totalPages > 1}">
	        <c:forEach var="i" begin="1" end="${totalPages}">
	            <button 
	                class="btn btn-sm ${currentPage == i ? 'btn-primary' : 'btn-outline-primary'} m-1"
	                onclick="fndrqhdlPgn(${i})"
	                ${currentPage == i ? 'disabled aria-current="page"' : ''}
	            >
	                ${i}
	            </button>
	        </c:forEach>
	    </c:if>
	</div>
<style>
	.qr-code-container {
	    cursor: pointer;
	    transition: all 0.3s ease;
	    border-radius: 8px;
	    overflow: hidden;
	    height: 200px;
	    margin-bottom: 15px;
	}

	.qr-code-container img {
	    width: 100%;
	    height: 100%;
	    object-fit: cover;
	}

	.qr-overlay {
	    background-color: rgba(0, 0, 0, 0.4);
	    display: flex;
	    justify-content: center;
	    align-items: center;
	}

	.pdf-placeholder {
	    height: 100%;
	    display: flex;
	    flex-direction: column;
	    justify-content: center;
	    align-items: center;
	    cursor: pointer;
	    position: relative;
	}

	.qr-code-container:hover {
	    transform: scale(1.02);
	    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
	}
</style>