<div class="content-section d-none" id="uploadContent">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="bi bi-upload me-2"></i> File Upload</h2>
    </div>

    <div class="card shadow">
        <div class="card-body">
            <!-- File Upload Form -->
            <form id="uploadForm" enctype="multipart/form-data">
                <div class="file-upload-wrapper mb-4">
                    <input type="file" id="fileUpload" name="file" class="file-upload-input" accept="image/*">
                    <label for="fileUpload" class="file-upload-label w-100 d-block">
                        <div class="mb-3">
                            <i class="bi bi-cloud-arrow-up fs-1 text-primary"></i>
                        </div>
                        <h5>Drag & drop files here</h5>
                        <p class="text-muted mb-0">or click to browse</p>
                        <small class="text-muted">Supports: Images (Max 10MB)</small>
                    </label>
                </div>

                <!-- Progress Bar -->
                <div class="progress d-none" id="uploadProgress">
                    <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 0%"></div>
                </div>

                <!-- Upload Button -->
                <div class="d-grid mt-3">
                    <button type="button" class="btn btn-primary" id="uploadBtn" disabled>
                        <i class="bi bi-upload me-2"></i> Upload Files
                    </button>
                </div>
            </form>
        </div>
    </div>
	<h5 class="mt-5">Uploaded History</h5>
	<div id="uploadedImages" class="d-flex flex-wrap gap-3 mt-3"></div>
</div>

