
document.addEventListener('DOMContentLoaded', function() {
    const video = document.getElementById('video');
    const captureBtn = document.getElementById('captureBtn');
    const finishBatchBtn = document.getElementById('finishBatchBtn');
    const scannedCount = document.getElementById('scannedCount');
    const previewContainer = document.getElementById('previewContainer');
    
    let stream = null;
    let capturedImages = [];
    
    // Initialize camera
    initCamera();
    
    function initCamera() {
        const constraints = {
            video: {
                facingMode: { ideal: 'environment' },
                width: { ideal: 1280 },
                height: { ideal: 720 }
            }
        };
        
        navigator.mediaDevices.getUserMedia(constraints)
            .then(function(mediaStream) {
                stream = mediaStream;
                video.srcObject = mediaStream;
                video.play();
                captureBtn.classList.remove('d-none');
            })
            .catch(function(error) {
                console.error('Error accessing camera:', error);
                alert('Error accessing camera: ' + error.message);
            });
    }
    
    captureBtn.addEventListener('click', function() {
        const canvas = document.createElement('canvas');
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const context = canvas.getContext('2d');
        context.drawImage(video, 0, 0, canvas.width, canvas.height);
        
        const imageData = canvas.toDataURL('image/png');
        capturedImages.push({
            data: imageData,
            template: document.getElementById('template').value
        });
        
        // Add preview
        const preview = document.createElement('div');
        preview.className = 'preview-item';
        preview.innerHTML = `
            <img src="${imageData}" alt="Captured sheet ${capturedImages.length}" style="max-width: 150px;">
            <div class="mt-1 text-center">Sheet ${capturedImages.length}</div>
        `;
        previewContainer.appendChild(preview);
        
        // Update count and show finish button
        scannedCount.textContent = capturedImages.length;
        if (capturedImages.length > 0) {
            finishBatchBtn.classList.remove('d-none');
        }
    });
    
    finishBatchBtn.addEventListener('click', function() {
        if (capturedImages.length === 0) {
            alert('No sheets have been scanned yet!');
            return;
        }
        
        finishBatchBtn.disabled = true;
        captureBtn.disabled = true;
        
        // Process each image sequentially
        processImages(0);
    });
    
    function processImages(index) {
        if (index >= capturedImages.length) {
            // All images processed, redirect to home
            window.location.href = '/';
            return;
        }
        
        const image = capturedImages[index];
        
        fetch('/process_camera_image', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image_data: image.data,
                template: image.template
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert(`Error processing sheet ${index + 1}: ${data.error}`);
            }
            // Process next image
            processImages(index + 1);
        })
        .catch(error => {
            console.error('Error:', error);
            alert(`Error processing sheet ${index + 1}`);
            processImages(index + 1);
        });
    }
    
    // Clean up when leaving the page
    window.addEventListener('beforeunload', function() {
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
        }
    });
});
