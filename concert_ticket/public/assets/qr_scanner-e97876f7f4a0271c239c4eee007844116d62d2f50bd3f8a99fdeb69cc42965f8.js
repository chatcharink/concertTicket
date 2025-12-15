import "html5-qrcode";

document.addEventListener("DOMContentLoaded", () => {
    const qrResult = document.getElementById("qr-result");

    function onScanSuccess(decodedText, decodedResult) {
        qrResult.textContent = decodedText;
        console.log(`Code matched = ${decodedText}`, decodedResult);
    }

    function onScanFailure(error) {
        // เงียบไว้ก็ได้ หรือจะ console.log(error);
    }

    const html5QrCode = new Html5Qrcode("qr-reader");

    // เริ่มกล้องอัตโนมัติทันที
    Html5Qrcode.getCameras().then((devices) => {
        if (devices && devices.length) {
        const cameraId = devices[0].id; // ใช้กล้องแรก
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
