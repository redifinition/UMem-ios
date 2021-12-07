//
//  CameraService.swift
//  相机服务类，负责连接到相机设备
//  用到了AVFoundation
//  UMem
//
//  Created by lq on 2021/12/7.
//

import Foundation
import AVFoundation
import UIKit
import Photos
import Combine



public class UmemCameraService{
    
    //使用类型别名，用string存储相机捕捉会话id
    typealias PhotoCaptureSessionId = String
    
    //闪光灯打开还是关闭
    @Published public var flashMode : AVCaptureDevice.FlashMode = .off
    
    //是否显示提示视图
    @Published public var isShowAlertView = false
    
    //是否显示加载图标告知展示正在处理照片
    @Published  public var isShowSpinner = false
    
    //是否要显示提示已经开始拍摄的动画
    @Published public var willCapturePhoto = false
    
    //是否显示拍照按钮，在初始化完成之前默认false
    @Published public var isCameraButtonDisabled = true
    
    @Published public var isCameraUnavaliable = true
    
    //输出的照片结构体，用于存放照片
    @Published public var photo: Photo?
    
    // 相应的警告结构体成员变量
    public var alertError:ErrorAlertion = ErrorAlertion()
    
    // 会话
    public let session = AVCaptureSession()
    
    //会话是否运行
    private var isSessionRunning = false
    
    private var isConfigured = false
    
    // 会话设置情况
    private var setupResult: SessionSetupResult = .success
    
    //使用调度队列处理捕捉会话的进程
    private let sessionFifoQueue = DispatchQueue(label: "Camera Session Queue")
    
    //捕捉图像的设备
    @objc dynamic var vieoDeviceInput: AVCaptureDeviceInput!
    
    // 设备发现会话，寻找符合要求的设备
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera ,.builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    // 图片捕捉相关配置
    private let photoOutput = AVCapturePhotoOutput()
    
    private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
    
    // 相机使用权限检查
    public func checkForPermissions(){
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                //用户以前已经对相机权限授权
                break;
        case .notDetermined: // The user has not yet been asked for camera access.
                //此时暂停会话队列
                sessionFifoQueue.suspend()
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {granted in
                if !granted{
                    self.setupResult = .notAuthorized
                }
                self.sessionFifoQueue.resume()
            })
            
        default:
            setupResult = .notAuthorized
            
            //异步
            DispatchQueue.main.async {
                self.alertError = ErrorAlertion(title: "Camera Access", message: "Umem doesn't have access to use your camera, please update your privacy settings.", primaryButtonTitle: "Settings", secondaryButtonTitle: nil, primaryAction: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                                  options: [:], completionHandler: nil)
                    
                }, secondaryAction: nil)
                self.isShowAlertView = true
                self.isCameraUnavaliable = true
                self.isCameraButtonDisabled = true
            }
        }
    }
    
    
    //在会话队列中调用此函数
    private func configureCaptureSession(){
        if setupResult != .success{
            return
        }
        
        session.beginConfiguration()
        
        session.sessionPreset = .photo
        
        //add photo input
        do{
            var defaultVideoDevice:AVCaptureDevice?
            
            if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                // If a rear dual camera is not available, default to the rear wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // If the rear wide angle camera isn't available, default to the front wide angle camera.
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let videoDevice = defaultVideoDevice else{
                print("Default video device is unavailable!")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(vieoDeviceInput){
                session.addInput(videoDeviceInput)
                self.vieoDeviceInput = videoDeviceInput
            }else{
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        }catch{
            print("Couldn't create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
            
        }
        
        // 加入图片的输出
        if session.canAddOutput(photoOutput){
            session.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.maxPhotoQualityPrioritization = .quality
        }else{
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
        self.isConfigured = true
        self.start()
    }
    
    public func start() {
//        We use our capture session queue to ensure our UI runs smoothly on the main thread.
        sessionFifoQueue.async {
            if !self.isSessionRunning && self.isConfigured {
                switch self.setupResult {
                case .success:
                    self.session.startRunning()
                    self.isSessionRunning = self.session.isRunning
                    
                    if self.session.isRunning {
                        DispatchQueue.main.async {
                            self.isCameraButtonDisabled = false
                            self.isCameraUnavaliable = false
                        }
                    }
                    
                case .configurationFailed, .notAuthorized:
                    print("Application not authorized to use camera")

                    DispatchQueue.main.async {
                        self.alertError = ErrorAlertion(title: "Camera Error", message: "Camera configuration failed. Either your device camera is not available or its missing permissions", primaryButtonTitle: "Accept", secondaryButtonTitle: nil, primaryAction: nil, secondaryAction: nil)
                        self.isShowAlertView = true
                        self.isCameraButtonDisabled = true
                        self.isCameraUnavaliable = true
                    }
                }
            }
        }
    }
    
    
    public func stop(completion: (() -> ())? = nil)
    {
        sessionFifoQueue.async {
            if self.isSessionRunning {
                if self.setupResult == .success {
                    self.session.stopRunning()
                    self.isSessionRunning = self.session.isRunning
                    
                    if !self.session.isRunning {
                        DispatchQueue.main.async {
                            self.isCameraButtonDisabled = true
                            self.isCameraUnavaliable = true
                            completion?()
                        }
                    }
                }
            }
        }
    }
    
    public func changeCamera() {
        DispatchQueue.main.async {
            self.isCameraButtonDisabled = true
        }
        //
        
        sessionFifoQueue.async {
            let currentVideoDevice = self.vieoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            
            let preferredPosition: AVCaptureDevice.Position
            let preferredDeviceType: AVCaptureDevice.DeviceType
            
            switch currentPosition {
            case .unspecified, .front:
                preferredPosition = .back
                preferredDeviceType = .builtInWideAngleCamera
                
            case .back:
                preferredPosition = .front
                preferredDeviceType = .builtInWideAngleCamera
                
            @unknown default:
                print("Unknown capture position. Defaulting to back, dual-camera.")
                preferredPosition = .back
                preferredDeviceType = .builtInWideAngleCamera
            }
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice? = nil
            
            // First, seek a device with both the preferred position and device type. Otherwise, seek a device with only the preferred position.
            if let device = devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType }) {
                newVideoDevice = device
            } else if let device = devices.first(where: { $0.position == preferredPosition }) {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    self.session.beginConfiguration()
                    
                    // Remove the existing device input first, because AVCaptureSession doesn't support
                    // simultaneous use of the rear and front cameras.
                    self.session.removeInput(self.vieoDeviceInput)
                    
                    if self.session.canAddInput(videoDeviceInput) {
                        self.session.addInput(videoDeviceInput)
                        self.vieoDeviceInput = videoDeviceInput
                    } else {
                        self.session.addInput(self.vieoDeviceInput)
                    }
                    
                    if let connection = self.photoOutput.connection(with: .video) {
                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                    
                    self.photoOutput.maxPhotoQualityPrioritization = .quality
                    
                    self.session.commitConfiguration()
                } catch {
                    print("Error occurred while creating video device input: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                self.isCameraButtonDisabled = false
            }
        }
    }
    
    //实现相机的放大功能,传入放大系数
    public func set(zoom: CGFloat){
        let zoomValue = zoom < 1 ? 1 : zoom
        let device = self.vieoDeviceInput.device
        
        do{
            try device.lockForConfiguration()
            device.videoZoomFactor = zoomValue
            device.unlockForConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    public func focus(at focusPoint: CGPoint){
//        let focusPoint = self.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: point)

        let device = self.vieoDeviceInput.device
        do {
            try device.lockForConfiguration()
            if device.isFocusPointOfInterestSupported {
                device.focusPointOfInterest = focusPoint
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .continuousAutoExposure
                device.focusMode = .continuousAutoFocus
                device.unlockForConfiguration()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    //实现照片的捕获功能
    public func capturePhoto(){
        if self.setupResult != .configurationFailed{
            self.isCameraButtonDisabled = true
            
            sessionFifoQueue.async {
                if let photoOutputConnection = self.photoOutput.connection(with: .video){
                    photoOutputConnection.videoOrientation = .portrait
                }
                var photoSetting = AVCapturePhotoSettings()
                
                if self.vieoDeviceInput.device.isFlashAvailable{
                    photoSetting.flashMode = self.flashMode
                }
                
                //在设备支持时捕捉helf格式的照片
                if self.photoOutput.availablePhotoCodecTypes.contains(.hevc){
                    photoSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
                }
                
                photoSetting.isHighResolutionPhotoEnabled = true
                
                //设置预览缩略图像素格式
                if !photoSetting.__availablePreviewPhotoPixelFormatTypes.isEmpty{
                    photoSetting.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSetting.__availablePreviewPhotoPixelFormatTypes.first!]
                }
                
                photoSetting.photoQualityPrioritization = .quality
                
                let photoCaptureProcessor = PhotoCaptureProcessor(with: photoSetting, willCapturePhotoAnimation: {
                    DispatchQueue.main.async {
                        self.willCapturePhoto.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                        self.willCapturePhoto.toggle()
                    }
                }, completionHandler: {(PhotoCaptureProcessor) in
                    if let data = PhotoCaptureProcessor.photoData{
                        self.photo = Photo(originalData: data)
                    }else{
                        print("no photo data")
                    }
                    
                    self.isCameraButtonDisabled = false
                    self.sessionFifoQueue.async {
                        self.inProgressPhotoCaptureDelegates[PhotoCaptureProcessor.requestedPhotoSettings.uniqueID] = nil
                    }
                    
                }, photoProcessingHandler: {animate in
                    // animate a spinner
                    if animate{
                        self.isShowSpinner = true
                    }else{
                        self.isShowSpinner = false
                    }
                    
                })
                
                self.inProgressPhotoCaptureDelegates[photoCaptureProcessor.requestedPhotoSettings.uniqueID] = photoCaptureProcessor
                self.photoOutput.capturePhoto(with: photoSetting, delegate: photoCaptureProcessor)
            }
        }
    }
}




//照片结构体
public struct Photo: Identifiable,Equatable{
    
    //捕捉到的图片id
    public var id: String
    
    //捕捉到的图片数据
    public var originalPhotoData:Data
    
    public init(id: String = UUID().uuidString, originalData: Data) {
            self.id = id
            self.originalPhotoData = originalData
        }
    
}


public struct ErrorAlertion{
    public var title: String = ""
        public var message: String = ""
        public var primaryButtonTitle = "Accept"
        public var secondaryButtonTitle: String?
        public var primaryAction: (() -> ())?
        public var secondaryAction: (() -> ())?
        
        public init(title: String = "", message: String = "", primaryButtonTitle: String = "Accept", secondaryButtonTitle: String? = nil, primaryAction: (() -> ())? = nil, secondaryAction: (() -> ())? = nil) {
            self.title = title
            self.message = message
            self.primaryAction = primaryAction
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryAction = secondaryAction
        }
}

// 会话设置情况
enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}

extension Photo {
    public var compressedData: Data? {
        ImageResizer(targetWidth: 800).resize(data: originalPhotoData)?.jpegData(compressionQuality: 0.5)
    }
    public var thumbnailData: Data? {
        ImageResizer(targetWidth: 100).resize(data: originalPhotoData)?.jpegData(compressionQuality: 0.5)
    }
    public var thumbnailImage: UIImage? {
        guard let data = thumbnailData else { return nil }
        return UIImage(data: data)
    }
    public var image: UIImage? {
        guard let data = compressedData else { return nil }
        return UIImage(data: data)
    }
}


extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}

extension AVCaptureDevice.DiscoverySession {
    var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
}
