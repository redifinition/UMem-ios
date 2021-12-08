//
//  PhotoCapturerViewModel.swift
//  UMem
//
//  Created by lq on 2021/12/8.
//

import Foundation
import AVFoundation
import Combine


//该viewmodel负责使用cameraservice，完成配置，代表UI来调用方法

class PhotoCapturerViewModel:ObservableObject{
    //存储相应的相机捕捉服务
    private let service = UmemCameraService()
    
    @Published var photo:Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var ErrorAlertion : ErrorAlertion!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(){
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$isShowAlertView.sink { [weak self] (val) in
            self?.ErrorAlertion = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    
    //配置函数
    func configure(){
        service.checkForPermissions()//首先获取权限
        service.configure()
    }
    
    //开始捕捉视频
    func capturePhoto(){
        service.capturePhoto()
    }
    
    //切换前置后置摄像头
    func exchangeUsingCamera(){
        service.changeCamera()
    }
    
    func zoom(with factor:CGFloat){
        service.set(zoom: factor)
    }
    
    //切换闪光灯
    func swithcFlash(){
        service.flashMode = service.flashMode == .on ? .off : .on
    }
    
    //结束相机捕捉
    func stopCapturing(){
        service.stop()
    }
    
    
}
