//
//  CameraCapturingView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/8.
//

import SwiftUI

struct CameraCapturingView: View {
    
    //视频捕捉的viewModel
    @StateObject var model = PhotoCapturerViewModel()
    
    @State private var isShowingDetailView = false
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    var flipCameraButton: some View {
        Button(action: {
            model.exchangeUsingCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60, alignment: .center)
                .overlay(
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .foregroundColor(.white))
        })
    }
    
    var capturedPhotoThumbnail: some View {
        Group {
            if model.photo != nil {
                Image(uiImage: model.photo.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring())
                
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 60, alignment: .center)
                    .foregroundColor(.black)
            }
        }
    }
    
    //next step
    var nextStepButton: some View{
        
        NavigationLink(destination: PictureResultView()
                        .environmentObject(model)) {
            // Button design
            Image(systemName: "arrowshape.turn.up.right.circle")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
        }
        .foregroundColor(.white)
    }
//        NavigationLink(destination: PictureResultView()) {
//            Button(action: {
//            }) {
//                // Button design
//                Image(systemName: "arrowshape.turn.up.right.circle")
//                    .resizable()
//                    .renderingMode(.template)
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 40, height: 40)
//            }
//        }
//        .foregroundColor(.white)
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack{
                        Button(action: {
                            model.swithcFlash()
                        }, label: {
                            Image(systemName: model.isFlashOn ? "bolt.circle" : "bolt.slash.circle")
                                .font(.system(size: 40, weight: .medium, design: .default))
                        })
                        .accentColor(model.isFlashOn ? .yellow : .white)
                        Spacer()
                        nextStepButton

                        
                        Button(action: {
                            print(model.getPhotoList())
                            print(model.photo!)
                        }, label: {Text("click")})
                    }
                    
                    CameraCapturingPreview(session: model.session)
                        .gesture(
                            DragGesture().onChanged({ (val) in
                                //  Only accept vertical drag
                                if abs(val.translation.height) > abs(val.translation.width) {
                                    //  Get the percentage of vertical screen space covered by drag
                                    let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                    //  Calculate new zoom factor
                                    let calc = currentZoomFactor + percentage
                                    //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                    //  Store the newly calculated zoom factor
                                    currentZoomFactor = zoomFactor
                                    //  Sets the zoom factor to the capture device session
                                    model.zoom(with: zoomFactor)
                                }
                            })
                        )
                        .onAppear {
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.ErrorAlertion.title), message: Text(model.ErrorAlertion.message), dismissButton: .default(Text(model.ErrorAlertion.primaryButtonTitle), action: {
                                model.ErrorAlertion.primaryAction?()
                            }))
                        })
                        .overlay(
                            Group {
                                if model.willCapturePhoto {
                                    Color.black
                                }
                            }
                        )
                        .animation(.easeInOut)
                    
                    
                    HStack {
                        capturedPhotoThumbnail
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                        flipCameraButton
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
        
}

struct CameraCapturingView_Previews: PreviewProvider {
    static var previews: some View {
        CameraCapturingView()
    }
}
