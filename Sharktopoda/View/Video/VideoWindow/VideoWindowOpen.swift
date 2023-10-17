//
//  VideoWindowOpen.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

extension VideoWindow {
  static func open(url: URL) {
    open(id: url.path, url: url, alert: true)
  }
  
  static func open(id: String, url: URL, alert: Bool = false) {
    let id = SharktopodaData.normalizedId(id)
    
    Task {
      let videoState = await UDP.sharktopodaData.openVideoState(id: id)
      
      switch videoState {
        case .loading:
          return
          
        case .loaded:
          guard let videoWindow = UDP.sharktopodaData.window(for: id) else { return }
          onMain { [weak videoWindow] in
            videoWindow?.bringToFront()
          }
          openDone(id: id)
        
        case .notOpen:
          await openVideo(id: id, url: url, alert: alert)
      }
    }
  }
  
  private static func openVideo(id: String, url: URL, alert: Bool) async {
    do {
      await UDP.sharktopodaData.openingVideo(id: id)

      let videoAsset = try await VideoAsset(id: id, url: url)
      let videoWindow = VideoWindow(for: videoAsset, with: UDP.sharktopodaData)
      await UDP.sharktopodaData.windowOpened(videoWindow: videoWindow)
      onMain { [weak videoWindow] in
        videoWindow?.windowData.timeSlider.setupControlViewAnimation()
        videoWindow?.bringToFront()
      }
      
      openDone(id: id)
    } catch {
      await UDP.sharktopodaData.releaseVideo(id: id)
      
      guard let openVideoError = error as? OpenVideoError else {
        UDP.log(error.localizedDescription)
        return
      }
      openFailed(id: id, url: url, openVideoError: openVideoError, alert: alert)
    }
  }
  
  private static func openDone(id: String) {
    UDP.sharktopodaData.mainViewWindow?.miniaturize(nil)
    
    guard let client = UDP.sharktopodaData.udpClient else { return }
    
    let openDoneMessage = ClientMessageOpenDone(uuid: id)
    client.process(openDoneMessage)
  }

  private static func openFailed(id: String, url: URL, openVideoError: OpenVideoError, alert: Bool) {
    UDP.log(openVideoError.description)
    if alert {
      onMain { OpenAlert(path: url.absoluteString, error: openVideoError).show() }
    } else {
      guard let client = UDP.sharktopodaData.udpClient else { return }
      let cause = openVideoError.alertMessage.filter { $0 != "\n" }
      let openDoneMessage = ClientMessageOpenDone(uuid: id, cause)
      client.process(openDoneMessage)
    }
  }
  
  static func onMain(_ fn: @escaping () -> Void) {
    DispatchQueue.main.async { fn() }
  }
}
