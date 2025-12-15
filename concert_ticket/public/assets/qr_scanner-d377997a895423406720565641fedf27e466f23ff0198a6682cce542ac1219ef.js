// To use Html5Qrcode (more info below)
import {Html5Qrcode} from "html5-qrcode";

document.addEventListener("DOMContentLoaded", () => {
    const qrResult = document.getElementById("qr-result");
  
    function onScanSuccess(decodedText, decodedResult) {
      qrResult.textContent = decodedText;
      console.log(`Code matched = ${decodedText}`, decodedResult);
    }
  
    function onScanFailure(error) {
      // console.log(error); // debug ได้
    }
  
    const html5QrCode = new Html5Qrcode("qr-reader");
  
    html5QrCode.getCameras().then((devices) => {
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
