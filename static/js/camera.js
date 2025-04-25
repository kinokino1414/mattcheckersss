
document.addEventListener('DOMContentLoaded', function() {
    const video = document.getElementById('video');
    const finishBatchBtn = document.getElementById('finishBatchBtn');
    const scannedCount = document.getElementById('scannedCount');
    const previewContainer = document.getElementById('previewContainer');
    const processingIndicator = document.getElementById('processingIndicator');

    let stream = null;
    let capturedImages = [];
    let isProcessing = false;
    let scanInterval = null;
    let lastProcessedTime = 0;
    const SCAN_COOLDOWN = 2000; // 2 seconds cooldown between scans

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
                startAutoScan();
            })
            .catch(function(error) {
                console.error('Error accessing camera:', error);
                alert('Error accessing camera: ' + error.message);
            });
    }

    function startAutoScan() {
        scanInterval = setInterval(() => {
            const currentTime = Date.now();
            if (!isProcessing && currentTime - lastProcessedTime > SCAN_COOLDOWN) {
                captureAndProcess();
            }
        }, 500); // Check every 500ms
    }

    function captureAndProcess() {
        const canvas = document.createElement('canvas');
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        const context = canvas.getContext('2d');
        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        const imageData = canvas.toDataURL('image/png');

        // Process the captured image
        isProcessing = true;

        // Process the captured image
        fetch('/process_camera_image', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                image_data: imageData,
                template: document.getElementById('template').value
            })
        })
        .then(response => response.json())
        .then(data => {
            if (!data.error && data.success) {
                // Only process if an exam sheet was successfully detected
                lastProcessedTime = Date.now();
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

                // Update results display
                const resultsDiv = document.getElementById('scanResults');
                const result = data.result;
                
                const resultHtml = `
                    <div class="card mb-3">
                        <div class="card-header bg-success text-white">
                            Scan Result #${result.scan_id}
                        </div>
                        <div class="card-body">
                            <h5 class="card-title">${result.student.name}</h5>
                            <p class="card-text">
                                Score: ${result.score.correct}/${result.score.total} (${result.score.percentage}%)
                            </p>
                            <a href="/result/${result.scan_id}" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                `;
                
                resultsDiv.insertAdjacentHTML('afterbegin', resultHtml);
                
                // Play success sound
                const audio = new Audio('/static/sounds/success.mp3');
                audio.play();
            }
            isProcessing = false;
            processingIndicator.classList.add('d-none');
        })
        .catch(error => {
            console.error('Error:', error);
            isProcessing = false;
            processingIndicator.classList.add('d-none');
        });
    }

    finishBatchBtn.addEventListener('click', function() {
        if (capturedImages.length === 0) {
            alert('No sheets have been scanned yet!');
            return;
        }

        // Clear scan interval
        if (scanInterval) {
            clearInterval(scanInterval);
        }

        // Stop camera
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
        }

        // Redirect to home
        window.location.href = '/';
    });

    // Clean up when leaving the page
    window.addEventListener('beforeunload', function() {
        if (scanInterval) {
            clearInterval(scanInterval);
        }
        if (stream) {
            stream.getTracks().forEach(track => track.stop());
        }
    });
});
