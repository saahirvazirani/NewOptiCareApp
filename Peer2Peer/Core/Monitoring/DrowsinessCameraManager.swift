import AVFoundation
import Vision

class DrowsinessCameraManager: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    
    private var model: VNCoreMLModel?
    private var requests = [VNRequest]()
    private var drowsinessCounts: [String: Int] = ["Not Drowsy": 0, "Little Drowsy": 0, "Very Drowsy": 0]

    override init() {
        super.init()
        setupSession()
        setupVision()
    }
    
    private func setupSession() {
        let newSession = AVCaptureSession()
        newSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get the front camera")
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to create camera input")
            return
        }
        
        if newSession.canAddInput(input) {
            newSession.addInput(input)
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        if newSession.canAddOutput(output) {
            newSession.addOutput(output)
        }
        
        DispatchQueue.main.async {
            self.session = newSession
        }
    }
    
    private func setupVision() {
        // Load the DrowsinessChecker2 model
        guard let model = try? VNCoreMLModel(for: DrowsinessChecker2().model) else {
            print("Failed to load DrowsinessChecker2 model")
            return
        }
        self.model = model
        
        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            if let results = request.results as? [VNClassificationObservation], let self = self {
                if let topResult = results.first {
                    self.handleDrowsinessDetection(result: topResult.identifier)
                }
            }
        }
        self.requests = [request]
    }

    func startMonitoring() {
        drowsinessCounts = ["Not Drowsy": 0, "Little Drowsy": 0, "Very Drowsy": 0] // Reset counts
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func stopMonitoring() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    private func handleDrowsinessDetection(result: String) {
        if drowsinessCounts.keys.contains(result) {
            drowsinessCounts[result, default: 0] += 1
        }
    }

    // Get the most prevalent drowsiness level after the monitoring period
    func getMostPrevalentDrowsinessLevel() -> String? {
        return drowsinessCounts.max(by: { a, b in a.value < b.value })?.key
    }
}

extension DrowsinessCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform(self.requests)
        } catch {
            print("Failed to perform Vision request: \(error.localizedDescription)")
        }
    }
}
