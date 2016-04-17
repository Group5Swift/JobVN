//
//  RecordJobViewController.swift
//  SwiftFinalProject
//
//  Created by Dam Vu Duy on 4/10/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

enum CameraState {
    case Front
    case Back
}

enum CameraRecordingState {
    case Recording
    case Free
}

protocol RecordVideoCompleteDelegate: NSObjectProtocol {
    func onRecordComplete(output: NSURL)
}

class RecordJobViewController: UIViewController {

    @IBOutlet weak var headView: UIView!
    
    var session: AVCaptureSession?
    let preset = AVCaptureSessionPreset352x288
    
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoOutput: AVCaptureMovieFileOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var lastInput: AVCaptureDeviceInput?
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var microphone: AVCaptureDevice?
    var currentCameraState: CameraState = .Back
    var cameraRecordingState: CameraRecordingState = .Free
    let maxTimeRecording: Double = 60 // second
    var maxDuration: CMTime?
    let fpsRecording: Int32 = 24 // FPS
    
    weak var delegate: RecordVideoCompleteDelegate?
    
    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headView.frame.size.width = view.frame.size.width
        headView.frame.size.height = headView.frame.size.width * 352 / 288
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // NOTE: If you plan to upload your photo to Parse,
        // you will likely need to change your preset to AVCaptureSessionPresetHigh or AVCaptureSessionPresetMedium to keep the size under the 10mb Parse max.
        
        session = AVCaptureSession()
        session!.sessionPreset = preset
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo) {
                if device.position == AVCaptureDevicePosition.Back {
                    self.backCamera = device as? AVCaptureDevice
                }
                else if device.position == AVCaptureDevicePosition.Front {
                    self.frontCamera = device as? AVCaptureDevice
                }
            }
            else if device.hasMediaType(AVMediaTypeAudio) {
                self.microphone = device as? AVCaptureDevice
            }
        }
        
        let inputVideo: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: self.backCamera)
        
        lastInput = inputVideo
        
        if session!.canAddInput(inputVideo) {
            session!.addInput(inputVideo)
            // The remainder of the session setup will go here...
        }
        
        let inputAudio: AVCaptureInput = try! AVCaptureDeviceInput(device: self.microphone)
        
        if session!.canAddInput(inputAudio) {
            session!.addInput(inputAudio)
        }
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        videoOutput = AVCaptureMovieFileOutput()
        maxDuration = CMTimeMakeWithSeconds(maxTimeRecording, fpsRecording)
        videoOutput?.maxRecordedDuration = maxDuration!
        videoOutput?.maxRecordedFileSize = Int64(9.8*1024*1024)
        
        if session!.canAddOutput(videoOutput) {
            session!.addOutput(videoOutput)
            // Configure the Live Preview here...
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        if let videoPreviewLayer = videoPreviewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
            videoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
            headView.layer.addSublayer(videoPreviewLayer)
        }
//        setupCameraProperties()
        session!.startRunning()
//        setupCameraProperties()
    }
    
    func setupCameraProperties() {
//        let connection: AVCaptureConnection? = (videoOutput?.connectionWithMediaType(AVMediaTypeVideo))
//        
//        if (connection!.active) {
//            print("connection active")
//        }
//        else {
//            print("connection not active yet")
//        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = headView.bounds
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        session?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onChangeCamera(sender: AnyObject) {
        if cameraRecordingState == .Free {
            switch currentCameraState {
            case .Back:
                session?.stopRunning()
                let input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: self.frontCamera)
                session?.removeInput(lastInput)
                lastInput = input
                if session!.canAddInput(input) {
                    session!.addInput(input)
                    // The remainder of the session setup will go here...
                }
                session?.startRunning()
                currentCameraState = .Front
            case .Front:
                session?.stopRunning()
                let input: AVCaptureDeviceInput = try! AVCaptureDeviceInput(device: self.backCamera)
                session?.removeInput(lastInput)
                lastInput = input
                if session!.canAddInput(input) {
                    session!.addInput(input)
                    // The remainder of the session setup will go here...
                }
                session?.startRunning()
                currentCameraState = .Back
            }
        }
    }
    
    @IBAction func onRecordPress(sender: AnyObject) {
//        capturePhoto()
        recordVideo(sender)
    }
    
    func capturePhoto() {
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            // Code for photo capture goes here...
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(
                videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                    // Process the image data (sampleBuffer) here to get an image file
                    // we can put in our captureImageView
                    guard sampleBuffer != nil else {
                        print("captureStillImageAsynchronouslyFromConnection error", error.description)
                        return}
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.previewImage.image = image
                    print(sizeofValue(image))
            })
        }
    }
    
    func recordVideo(sender: AnyObject) {
        switch cameraRecordingState {
        case .Free:
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            var filePath = documentsURL.URLByAppendingPathComponent("temp", isDirectory: false)
            filePath = filePath.URLByAppendingPathExtension("mp4")
            // Do recording and save the output to the `filePath`
            
            let mananger = NSFileManager()
            if mananger.fileExistsAtPath(filePath.path!) {
                try! mananger.removeItemAtPath(filePath.path!)
            }
            
            videoOutput?.startRecordingToOutputFileURL(filePath, recordingDelegate: self)
            
            let button = sender as! UIButton
            button.titleLabel?.text = "Stop Record"
            
            cameraRecordingState = .Recording
            
            return
        case .Recording:
            
            videoOutput?.stopRecording()
            
            let button = sender as! UIButton
            button.titleLabel?.text = "Record"
            
            cameraRecordingState = .Free
            
            return
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecordJobViewController: AVCaptureFileOutputRecordingDelegate {
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print ("start recording")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        
        print ("end recording \(outputFileURL)")
        
        if error != nil {
            print(error)
            return
        }
        
        self.delegate?.onRecordComplete(outputFileURL!)
        
    }
}
