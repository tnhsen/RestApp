//
//  Screen.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct Screen: View {
    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    
                    
                    
                    Rectangle()
                        .fill(Color(hex: colorLevel1))
                        .frame(width: geometry.size.width, height: geometry.size.height / 2, alignment: Alignment.top)
                        .position(x: geometry.size.width / 2, y: 0)
                    
                    
                    

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.8,
                               height: geometry.size.height * 0.8)
                        .cornerRadius(15)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    
                    
                }
                
                
            }
        
    }
}

struct Screen2: View {
    var body: some View {
        GeometryReader {geometry in
            ZStack {
                BackgroundGradient.gradient
                    .edgesIgnoringSafeArea(.all)
                
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.8)
                    .cornerRadius(15)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}


struct Screen3: View {
    var body: some View {
        BackgroundGradient.gradient
            .edgesIgnoringSafeArea(.all)
    }
}

struct Screen4: View {
    var body: some View {
        GeometryReader{ geometryReader in
            BackgroundBlueGradient.gradient.edgesIgnoringSafeArea(.all)
        }
    }
}

struct Screen_Previews: PreviewProvider {
    static var previews: some View {
        Screen4()
    }
}
