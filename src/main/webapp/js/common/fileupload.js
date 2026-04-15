// Upload Section Variables
let uploadFiles = []; // Store files globally

// Initialize Upload Section
function initUploadSection() {
    const fileUpload = document.getElementById('fileUpload');
    const uploadLabel = document.querySelector('#uploadContent .file-upload-label');
    const previewContainer = document.getElementById('previewContainer');
    const uploadBtn = document.getElementById('uploadBtn');
    const uploadProgress = document.getElementById('uploadProgress');
    
    // Reset any existing state
    uploadFiles = [];
    if (previewContainer) previewContainer.innerHTML = '';
    if (uploadBtn) uploadBtn.disabled = true;
    if (uploadProgress) {
        uploadProgress.classList.add('d-none');
        const progressBar = uploadProgress.querySelector('.progress-bar');
        progressBar.style.width = '0%';
        progressBar.textContent = '';
        progressBar.classList.remove('bg-danger');
    }

    // Setup event listeners if elements exist
    if (uploadLabel && fileUpload) {
        uploadLabel.addEventListener('dragover', handleDragOver);
        uploadLabel.addEventListener('dragleave', handleDragLeave);
        uploadLabel.addEventListener('drop', handleDrop);
        fileUpload.addEventListener('change', handleFileSelect);
    }

    if (uploadBtn) {
        uploadBtn.addEventListener('click', handleUpload);
    }
	loadUploadedImages();
}

// Event Handlers
function handleDragOver(e) {
    e.preventDefault();
    e.stopPropagation();
    const uploadLabel = document.querySelector('#uploadContent .file-upload-label');
    if (uploadLabel) uploadLabel.classList.add('dragover');
}

function handleDragLeave(e) {
    e.preventDefault();
    e.stopPropagation();
    const uploadLabel = document.querySelector('#uploadContent .file-upload-label');
    if (uploadLabel) uploadLabel.classList.remove('dragover');
}

function handleDrop(e) {
    e.preventDefault();
    e.stopPropagation();
    const uploadLabel = document.querySelector('#uploadContent .file-upload-label');
    if (uploadLabel) uploadLabel.classList.remove('dragover');
    
    const fileUpload = document.getElementById('fileUpload');
    if (fileUpload && e.dataTransfer.files.length) {
        fileUpload.files = e.dataTransfer.files;
        handleFileSelect({ target: fileUpload });
    }
}

function handleFileSelect(e) {
    const files = Array.from(e.target.files);
    if (!validateFiles(files)) return;
    
    uploadFiles = files;
    renderPreviews();
    updateUploadButton();
}

function handleUpload() {
	const fileInput = document.getElementById('fileUpload');    
	const uploadProgress = document.getElementById('uploadProgress');
	const progressBar = uploadProgress?.querySelector('.progress-bar');

	if (!fileInput.files.length) {
		showUploadError("Please select a file to upload.");
	    return;
	}
	const file = fileInput.files[0]; // Get the selected file
	const qrData = '1'; // Get the QR data
	const idxFrm = document.getElementById('index');
	
	if (!file) {
		showUploadError("No file selected.");
	    return;
	}
	if (uploadProgress && progressBar) {
		// Reset progress bar
	    uploadProgress.classList.remove('d-none');
	    progressBar.style.width = '0%';
	    progressBar.textContent = '0%';
	    progressBar.classList.remove('bg-danger');
	    progressBar.classList.add('progress-bar-striped', 'progress-bar-animated');
	        
	    // Prepare FormData
	    const formData = new FormData();
		formData.append('file', file);
		formData.append('data', qrData); 
		formData.append('sid', idxFrm.sid.value); 
		formData.append('pid', idxFrm.pid.value); 
		// AJAX call
	    const xhr = new XMLHttpRequest();
	        
	    // Progress tracking
	    xhr.upload.addEventListener('progress', (e) => {
	    	if (e.lengthComputable) {
	        	const percentComplete = Math.round((e.loaded / e.total) * 100);
	            progressBar.style.width = `${percentComplete}%`;
	            progressBar.textContent = `${percentComplete}%`;
	        }
	    });
	        
	     xhr.onreadystatechange = function() {
	     	if (xhr.readyState === XMLHttpRequest.DONE) {
	        	if (xhr.status === 200) {
	            	// Success response
	                try {
	                	const response = JSON.parse(xhr.responseText);
	                    if (response.success) {
							showUploadSuccess(response.message || 'Files uploaded successfully!');
	                        resetUploader();
							loadUploadedImages();
						} else {
	                    	showUploadError(response.message || 'Upload failed');
	                    }
					} catch (e) {
	                	showUploadSuccess('Files uploaded successfully!');
	                    resetUploader();
	                }
	            } else {
	            	// Error response
	                try {
	                	const errorResponse = JSON.parse(xhr.responseText);
	                    showUploadError(errorResponse.message || `Upload failed (Status: ${xhr.status})`);
	                } catch (e) {
	                	showUploadError(`Upload failed (Status: ${xhr.status})`);
	                }
	            }
	       	}
	    };        
        xhr.open('POST', 'admin/dt/upload', true);
        xhr.send(formData);
    }
}

// Reset form after successful upload
function resetUploader() {
    document.getElementById('fileUpload').value = ''; // Reset file input
    document.getElementById('uploadProgress').classList.add('d-none'); // Hide progress bar
}


// Helper Functions
function validateFiles(files) {
    const maxSize = 10 * 1024 * 1024; // 10MB
    const allowedTypes = [
        'image/jpeg', 'image/png', 'image/gif',
        'application/pdf',
        'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'text/csv'
    ];
    
    for (const file of files) {
        if (file.size > maxSize) {
            alert(`File ${file.name} exceeds 10MB limit`);
            return false;
        }
        if (!allowedTypes.includes(file.type) && !file.name.match(/\.(pdf|docx?|xlsx?|csv)$/i)) {
            alert(`File type not supported: ${file.name}`);
            return false;
        }
    }
    return true;
}

function renderPreviews() {
    const previewContainer = document.getElementById('previewContainer');
    if (!previewContainer) return;
    
    previewContainer.innerHTML = '';
    
    uploadFiles.forEach((file, index) => {
        const previewItem = document.createElement('div');
        previewItem.className = 'preview-item';
        previewItem.dataset.index = index;
        
        if (file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewItem.innerHTML = `
                    <img src="${e.target.result}" alt="${file.name}">
                    <div class="remove-btn" onclick="removeUploadFile(${index})">
                        <i class="bi bi-x"></i>
                    </div>
                `;
            };
            reader.readAsDataURL(file);
        } else {
            const fileType = file.name.split('.').pop().toUpperCase();
            previewItem.innerHTML = `
                <div class="h-100 d-flex flex-column align-items-center justify-content-center bg-light">
                    <i class="bi bi-file-earmark-${getFileIcon(fileType)} fs-3"></i>
                    <small class="mt-2 text-truncate px-2">${file.name}</small>
                </div>
                <div class="remove-btn" onclick="removeUploadFile(${index})">
                    <i class="bi bi-x"></i>
                </div>
            `;
        }
        
        previewContainer.appendChild(previewItem);
    });
}

function getFileIcon(fileType) {
    const icons = {
        'PDF': 'pdf',
        'DOC': 'word',
        'DOCX': 'word',
        'XLS': 'excel',
        'XLSX': 'excel',
        'CSV': 'excel'
    };
    return icons[fileType] || 'text';
}

function updateUploadButton() {
    const uploadBtn = document.getElementById('uploadBtn');
    if (uploadBtn) {
        uploadBtn.disabled = uploadFiles.length === 0;
    }
}

function resetUploader() {
    uploadFiles = [];
    const fileUpload = document.getElementById('fileUpload');
    if (fileUpload) fileUpload.value = '';
    
    const previewContainer = document.getElementById('previewContainer');
    if (previewContainer) previewContainer.innerHTML = '';
    
    updateUploadButton();
    
    const uploadProgress = document.getElementById('uploadProgress');
    if (uploadProgress) {
        uploadProgress.classList.add('d-none');
    }
}

function showUploadSuccess(message) {
    const uploadProgress = document.getElementById('uploadProgress');
    const progressBar = uploadProgress?.querySelector('.progress-bar');
    
    if (progressBar) {
        progressBar.classList.remove('progress-bar-striped', 'progress-bar-animated');
        progressBar.classList.add('bg-success');
        progressBar.textContent = '✓ ' + message;
    }
	showToast('uploaded successfully!', 'success');
}

function showUploadError(message) {
    const uploadProgress = document.getElementById('uploadProgress');
    const progressBar = uploadProgress?.querySelector('.progress-bar');
    
    if (progressBar) {
        progressBar.classList.remove('progress-bar-striped', 'progress-bar-animated');
        progressBar.classList.add('bg-danger');
        progressBar.textContent = '✗ ' + message;
    }

	showToast('upload unsuccessfull', 'danger');
}

// Global function to remove files
window.removeUploadFile = function(index) {
    uploadFiles.splice(index, 1);
    
    // Update file input
    const fileUpload = document.getElementById('fileUpload');
    if (fileUpload) {
        const dataTransfer = new DataTransfer();
        uploadFiles.forEach(file => dataTransfer.items.add(file));
        fileUpload.files = dataTransfer.files;
    }
    
    // Update preview
    renderPreviews();
    updateUploadButton();
};
function loadUploadedImages() {
    const container = document.getElementById('uploadedImages');
    container.innerHTML = ''; // Clear previous

    fetch('admin/dt/gtFls') // Expecting: [{ id, filename, content, type }]
        .then(res => res.json())
        .then(files => {
            files.forEach(file => {
                const card = document.createElement('div');
                card.className = 'position-relative border rounded shadow-sm m-2 p-2 text-center';
                card.style.width = '200px';

                let preview;
                if (file.type.startsWith('image/')) {
                    preview = document.createElement('img');
                    preview.src = file.content;
                    preview.alt = file.filename;
                    preview.className = 'img-fluid rounded';
                    preview.style.maxHeight = '150px';
                } else if (file.type === 'application/pdf') {
                    preview = document.createElement('iframe');
                    preview.src = file.content;
                    preview.className = 'w-100';
                    preview.style.height = '150px';
                } else {
                    preview = document.createElement('div');
                    preview.innerHTML = `
                        <i class="bi bi-file-earmark-text fs-1 text-secondary"></i>
                        <p class="small mt-1">${file.filename}</p>
                    `;
                }

                const filename = document.createElement('div');
                filename.className = 'small mt-1 text-truncate';
                filename.title = file.filename;
                filename.textContent = file.filename;

                const delBtn = document.createElement('button');
                delBtn.className = 'btn btn-danger btn-sm position-absolute top-0 end-0 m-1';
                delBtn.innerHTML = '<i class="bi bi-trash"></i>';
                delBtn.title = 'Delete file';
                 delBtn.onclick = () => dltFle(file.id);

                card.appendChild(preview);
                card.appendChild(filename);
                card.appendChild(delBtn);
                container.appendChild(card);
            });
        })
        .catch(err => {
            console.error('Error fetching files:', err);
            showToast('Could not load files', 'danger');
        });
}

async function dltFle(id) {
	const form = document.getElementById('index');
	let sid=form.sid.value;
	let pid=form.pid.value;
	const payload = {
		sid: sid,
		pid: pid,
		id: id
	};
	try {
        const loadingOverlay = document.getElementById('loadingOverlay');
        showLoading(true, null, loadingOverlay);  // Show loading overlay

        const response = await fetch('admin/dt/dltFl', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            },
			body: JSON.stringify(payload) 
        });

        if (!response.ok) {
            if (response.status === 401) {
                showToast("Invalid Session, Redirecting to home page", 'danger');
                setTimeout(() => {
                    window.location.href = 'admin'; // Redirect to home
                }, 2000);
            } else {
                throw new Error('Failed to delete image');
            }
        }

        const result = await response.json();

        // Handling the success response
        if (result.eC === '0') {
            showToast(result.eM, 'success');
            // Optionally, remove the image from the UI
           loadUploadedImages();
        } else showToast(result.eM || 'Failed to delete image', 'danger');

    } catch (err) {
        console.error('Error:', err);
        showToast('Something went wrong while deleting the image', 'danger');
    } finally {
        showLoading(false, null, loadingOverlay);  // Hide loading overlay
    }
}



