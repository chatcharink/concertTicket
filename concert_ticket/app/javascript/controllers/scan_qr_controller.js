import { Controller } from "@hotwired/stimulus"

let html5QrCode;

export default class extends Controller {
    
    connect() {
        this.initQrScanner();
    }

    initQrScanner() {
        const qrReaderElem = document.getElementById("qr-reader");
        const qrResult = document.getElementById("qr-result");
        const qrMatched = document.getElementById("matched-path");
        const modalToggle = document.getElementById("toggle-scan-result-modal");
    
        if (!qrReaderElem) return;

        if (html5QrCode) {
            try {
                html5QrCode.stop().then(() => {
                    qrReaderElem.innerHTML = ""; // เคลียร์ div
                    startScanner(qrReaderElem, qrResult, qrMatched);
                });
                return;
            } catch (e) {
                console.warn("Failed to stop old scanner:", e);
            }
        }
        this.startScanner(qrReaderElem, qrResult, qrMatched);

    }

    startScanner(qrReaderElem, qrResult, qrMatched) {
        html5QrCode = new Html5Qrcode("qr-reader");

        function onScanSuccess(decodedText, decodedResult) {
            // qrResult.textContent = decodedText;

            if (decodedText.match(qrMatched.value))
            {
                html5QrCode.stop()
                .then(() => {
                    console.log("QR scanning stopped.");
                })
                .catch(err => {
                    console.error("Failed to stop scanning.", err);
                });
                document.getElementById("qr-loading-icon").style.display = "inline";
		const participate = fetch(decodedText).then(response => {
                    if (response.ok) {
                        return response.text();
                    }
                });
            
                participate.then((data) => {
                    try{
                        result = JSON.parse(data);
                    } catch {
                        $("#div-scan-result-modal").html("");
                        $("#div-scan-result-modal").html(data);
			document.getElementById("qr-loading-icon").style.display = "none";
                        const targetEl = document.getElementById("scan-result-modal");
                        const options = {
                            placement: 'center-center',
                            backdrop: 'static',
                            backdropClasses:
                                'bg-gray-900/50 dark:bg-gray-900/80 fixed inset-0 z-40',
                            closable: false
                        };
                        const modal = new Modal(targetEl, options);
                        modal.show();
                        let btn_close = document.getElementById("close-scan-result-modal");
                        btn_close.addEventListener("click", function() {
                            modal.hide();
                            const html5QrCode = new Html5Qrcode("qr-reader");
                            Html5Qrcode.getCameras().then((devices) => {
                            if (devices && devices.length) {
                                const cameraId = devices[0].id;
                                html5QrCode.start(
                                    cameraId,
                                    { fps: 10, qrbox: 250 },
                                    onScanSuccess,
                                    onScanFailure
                                );
                            }
                            }).catch((err) => {
                                console.error("Camera init error:", err);
                                qrResult.textContent = "ไม่สามารถเข้าถึงกล้องได้";
                            });
                        });
                    }
                });
            }
        }

        function onScanFailure(error) {
            // เงียบ
        }

        Html5Qrcode.getCameras().then((devices) => {
            if (devices && devices.length) {
                const cameraId = devices[0].id;
                html5QrCode.start(
                    cameraId,
                    { fps: 10, qrbox: 250 },
                    onScanSuccess,
                    onScanFailure
                );
            }
        }).catch((err) => {
            console.error("Camera init error:", err);
            qrResult.textContent = "ไม่สามารถเข้าถึงกล้องได้";
        });
    }
}
