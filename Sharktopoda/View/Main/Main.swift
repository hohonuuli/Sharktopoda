//
//  Main.swift
//  Created for Sharktopoda on 9/15/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import SwiftUI

struct Main: View {
  private static var height: CGFloat = 425
  private static var width = CGFloat(Main.height * 1.618)

  var port = "'CxInc'"
  
  var body: some View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    HStack {
      VStack(spacing: 10) {
        Image("Sharktopoda")
          .resizable()
          .scaledToFit()
          .aspectRatio(contentMode: .fit)
        Text("Sharktopoda")
          .font(.largeTitle)
        Text(appVersion)
          .font(.title3)
      }
      .frame(width: 256, height: 256)
      .padding(.bottom, 80)
      
      Divider()
      
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text("Open ...")
            .font(.title2)
          Spacer()
          Text("⌘ o")
            .padding(.trailing, 20)
            .font(.title2)
        }
        HStack {
          Text("Open URL ...")
            .font(.title2)
          Spacer()
          Text("⇧ ⌘ o")
            .padding(.trailing, 20)
            .font(.title2)
        }
        
        Spacer()
        
        Text("Listening on port \(port)")
          .font(.title3)
      }
      .padding(20)
      .frame(maxWidth: .infinity)
    }
    .frame(width: Main.width, height: Main.height)
  }
}

struct Main_Previews: PreviewProvider {
  static var previews: some View {
    Main()
  }
}
