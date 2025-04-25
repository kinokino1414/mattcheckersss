document.addEventListener('DOMContentLoaded', function() {
    // File upload preview
    const fileInput = document.getElementById('fileInput');
    const previewContainer = document.getElementById('previewContainer');
    
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            previewContainer.innerHTML = '';
            
            if (this.files && this.files[0]) {
                const file = this.files[0];
                const reader = new FileReader();
                
                if (file.type.startsWith('image/')) {
                    reader.onload = function(e) {
                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.className = 'img-fluid mt-3 mb-3 border';
                        img.style.maxHeight = '300px';
                        previewContainer.appendChild(img);
                    }
                    reader.readAsDataURL(file);
                } else if (file.type === 'application/pdf') {
                    const pdfPreview = document.createElement('div');
                    pdfPreview.className = 'alert alert-info mt-3';
                    pdfPreview.innerHTML = `<i class="fa fa-file-pdf-o"></i> PDF file selected: ${file.name}`;
                    previewContainer.appendChild(pdfPreview);
                }
                
                // Show upload button
                document.getElementById('uploadButton').classList.remove('d-none');
            }
        });
    }
    
    // Results chart
    const resultsChart = document.getElementById('resultsChart');
    if (resultsChart) {
        const labels = [];
        const correctData = [];
        const incorrectData = [];
        
        // Extract data from the answers table
        const answerRows = document.querySelectorAll('#answersTable tbody tr');
        answerRows.forEach(row => {
            const questionNumber = row.querySelector('td:nth-child(1)').textContent;
            const isCorrect = row.classList.contains('table-success');
            
            labels.push(`Q${questionNumber}`);
            if (isCorrect) {
                correctData.push(1);
                incorrectData.push(0);
            } else {
                correctData.push(0);
                incorrectData.push(1);
            }
        });
        
        // Create chart
        new Chart(resultsChart, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Correct',
                        data: correctData,
                        backgroundColor: 'rgba(40, 167, 69, 0.7)',
                        borderColor: 'rgba(40, 167, 69, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Incorrect',
                        data: incorrectData,
                        backgroundColor: 'rgba(220, 53, 69, 0.7)',
                        borderColor: 'rgba(220, 53, 69, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        stacked: true
                    },
                    y: {
                        stacked: true,
                        ticks: {
                            beginAtZero: true,
                            stepSize: 1
                        }
                    }
                }
            }
        });
    }
});
