import AVFoundation
import Vision
import CoreML

class CameraManager: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var eyeStrainScore = 0
    private var blinkCounter = 0
    private var lastBlinkTime: Date?
    
    private var model: VNCoreMLModel?
    private var requests = [VNRequest]()
    
    override init() {
        super.init()
        setupSession()
        setupVision()
    }
    
    private func setupSession() {
        let newSession = AVCaptureSession()
        newSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get the camera device")
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
        guard let model = try? VNCoreMLModel(for: EyeStateModel().model) else {
            print("Failed to load CoreML model")
            return
        }
        self.model = model
        
        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            if let results = request.results as? [VNClassificationObservation], let self = self {
                if let topResult = results.first {
                    print("Detected state: \(topResult.identifier) with confidence: \(topResult.confidence)")
                    if topResult.identifier == "Closed" && topResult.confidence > 0.8 { // Ensuring confidence level
                        self.handleBlink()
                    }
                }
            }
        }
        
        self.requests = [request]
    }
    
    private func handleBlink() {
        let now = Date()
        blinkCounter += 1
        print("Blink detected! Total blinks: \(blinkCounter)") // Debugging to ensure blinks are detected
        
        if let lastBlink = lastBlinkTime {
            let timeInterval = now.timeIntervalSince(lastBlink)
            
            DispatchQueue.main.async {
                if timeInterval > 3 { // Adjusted threshold to detect blink intervals
                    self.eyeStrainScore += 10 // Increase strain score
                } else {
                    self.eyeStrainScore = max(self.eyeStrainScore - 2, 0) // Decrease strain, but never below 0
                }
                print("Eye Strain Score: \(self.eyeStrainScore)")  // For debugging
            }
        }
        
        lastBlinkTime = now
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
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
