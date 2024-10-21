import AVFoundation
import Vision

class BlinkRateCameraManager: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    
    private var blinkCounter = 0
    private var startTime: Date?
    
    private var lastState: String = "Open" // Track the last state (Open or Closed)
    private var lastBlinkTime: Date? // Track the last time a blink was registered
    private let blinkBufferTime: TimeInterval = 0.3 // Minimum delay between blinks (300 milliseconds)
    
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
        // Load the EyeStateModel
        guard let model = try? VNCoreMLModel(for: EyeStateModel().model) else {
            print("Failed to load EyeStateModel")
            return
        }
        self.model = model
        
        let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
            if let results = request.results as? [VNClassificationObservation], let self = self {
                if let topResult = results.first {
                    self.handleEyeState(state: topResult.identifier, confidence: topResult.confidence)
                }
            }
        }
        self.requests = [request]
    }

    func startMonitoring() {
        blinkCounter = 0
        startTime = Date()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }

    func stopMonitoring() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    private func handleEyeState(state: String, confidence: Float) {
        guard confidence > 0.8 else { return } // Ensure high confidence in the prediction
        
        let now = Date()
        
        if state == "Closed" && lastState == "Open" {
            // Eyes transitioned from Open to Closed, now wait for the transition back to Open
            lastState = "Closed"
        } else if state == "Open" && lastState == "Closed" {
            // Eyes transitioned from Closed back to Open (this completes a blink)
            if let lastBlink = lastBlinkTime {
                let timeSinceLastBlink = now.timeIntervalSince(lastBlink)
                
                // Only count this blink if sufficient time has passed since the last blink
                if timeSinceLastBlink >= blinkBufferTime {
                    blinkCounter += 1
                    lastBlinkTime = now
                    print("Blink detected! Total blinks: \(blinkCounter)")
                }
            } else {
                // This is the first blink being registered
                blinkCounter += 1
                lastBlinkTime = now
                print("First blink detected! Total blinks: \(blinkCounter)")
            }
            lastState = "Open" // Reset to Open after counting the blink
        }
    }

    func getBlinkRate() -> Int? {
        guard let startTime = startTime else { return nil }
        let timeElapsed = Date().timeIntervalSince(startTime)
        return timeElapsed > 60 ? blinkCounter : nil
    }
}

extension BlinkRateCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
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
