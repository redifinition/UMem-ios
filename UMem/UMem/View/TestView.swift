//
//  TestView.swift
//  UMem
//
//  Created by Jwy John on 2021/12/24.
//

import SwiftUI

struct TestView: View {
    @State var showCard = true
    var body: some View {

        ZStack{
            checkBlockView
            ZStack{

                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 180, height:200)
                    .foregroundColor(Color(.sRGB, red: 230/255, green: 230/255, blue: 230/255, opacity: 1))
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 0)
                            .frame(width: 180, height:120)
                            .foregroundColor(Color(.sRGB, red: 255/255, green: 223/255, blue: 201/255, opacity: 1))
                        Image("failurePhoto")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 120)
                    }

                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.callout)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            HStack{
                                Image(systemName: "bookmark.circle.fill")
                                ForEach(0..<2, id:\.self){i in

                                    ZStack{
                                        RoundedRectangle(cornerRadius: 0)
                                            .frame(width: 45, height:15)
                                            .foregroundColor(.gray.opacity(0.1))
                                            .cornerRadius(10)
                                            .shadow(color: .gray.opacity(0.6), radius: 20, x: 20, y: 20)
                                        
                                        
                                        Text("tag")
                                            .font(.custom("", size: 9))
                                            .fontWeight(.medium)
                                            .foregroundColor(.gray)

                                    }
                                    
                                    }

                            }
                            HStack{
                                Image(systemName: "face.smiling")
                            ZStack{
                                RoundedRectangle(cornerRadius: 0)
                                    .frame(width: 45, height:15)
                                    .foregroundColor(Color(.sRGB, red: 100/255, green: 100/255, blue: 100/255, opacity: 0.1))
                                    .cornerRadius(10)
                                
                                Text("mood")
                                    .font(.custom("", size: 9))
                                    .fontWeight(.medium)
                                    .foregroundColor(.gray)
                                

                            }
                                Spacer()
                                Text("2021-01-01")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 5)
                        .frame(width: 170, height:70)
                        

                }

            }
            .contentShape(Rectangle()) //Define a tappable area
        .cornerRadius(10)
        .padding([.top, .horizontal,.bottom],10)
        .shadow(color: .gray.opacity(0.6), radius: 20, x: 20, y: 20)
        //.offset(x: showCard ? 0 : -50)
        .rotationEffect(Angle(degrees: showCard ? 0 : 10))
        .rotation3DEffect(Angle(degrees: showCard ? 0 : 10), axis: (x: 0,y:10, z:0))
        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.1))
        .onTapGesture {
            self.showCard.toggle()
        }
        }


    }
    
    var checkBlockView:some View{
        VStack{
        Spacer()
            HStack{
                Spacer()
                VStack{
                    Button(action: {
                        print("111")
                    }, label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                    })
                Button(action: {
                    
                }, label: {
                    Image(systemName: "delete.left.fill")
                })
                }
            }
        }
        .padding()
        .frame(width: 180, height:200)
        .offset(x: showCard ? 0 : 15)
        .rotationEffect(Angle(degrees: showCard ? 0 : -10))
        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0).delay(0.2))
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


