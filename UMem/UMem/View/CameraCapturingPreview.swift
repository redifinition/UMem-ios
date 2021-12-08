//
//  CameraCapturingPreview.swift
//  UMem
//
//  Created by lq on 2021/12/8.
//

import Foundation
import AVFoundation
import SwiftUI

//一个负责与图片捕捉视图模型对接的视图
struct CameraCapturingPreview:UIViewRepresentable{
    
    //内部类，定义视频捕获预览相关的图层
    class CameraPreviewView:UIView{
        
        //将原来的图层转换为了AVFoundation提供的视频预览图层
        override class var layerClass: AnyClass{
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer{
            return layer as! AVCaptureVideoPreviewLayer
        }
        
        let focusView: UIView = {
            let focusView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            focusView.layer.borderColor = UIColor.white.cgColor
            focusView.layer.borderWidth = 1.5
            focusView.layer.cornerRadius = 25
            focusView.layer.opacity = 0
            focusView.backgroundColor = .clear
            return focusView
        }()
        
        @objc func focusAndExposeTap(gestureRecognizer: UITapGestureRecognizer) {
            let layerPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let devicePoint = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: layerPoint)
            
            self.focusView.layer.frame = CGRect(origin: layerPoint, size: CGSize(width: 50, height: 50))
            
            
            NotificationCenter.default.post(.init(name: .init("UserDidRequestNewFocusPoint"), object: nil, userInfo: ["devicePoint": devicePoint] as [AnyHashable: Any]))
            
            UIView.animate(withDuration: 0.3, animations: {
                self.focusView.layer.opacity = 1
            }) { (completed) in
                if completed {
                    UIView.animate(withDuration: 0.3) {
                        self.focusView.layer.opacity = 0
                    }
                }
            }
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            self.layer.addSublayer(focusView.layer)
            
            let gRecognizer = UITapGestureRecognizer(target: self, action: #selector(CameraPreviewView.focusAndExposeTap(gestureRecognizer:)))
            self.addGestureRecognizer(gRecognizer)
        }
    }
    
    let session:AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        
    }
    
}


struct CameraCapturingPreview_Previews: PreviewProvider {
    static var previews: some View {
        CameraCapturingPreview(session: AVCaptureSession())
            .frame(height: 300)
    }
}
