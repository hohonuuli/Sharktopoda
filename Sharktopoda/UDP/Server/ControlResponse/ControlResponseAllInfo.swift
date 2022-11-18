//
//  ControlResponseAllInfo.swift
//  Created for Sharktopoda on 9/30/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import Foundation

struct ControlResponseAllInfo: ControlResponse {
  var response: ControlCommand
  var status: ControlResponseStatus
  var videos: [ControlResponseInfo.VideoInfo]
  
  // CxInc
  init(using videoWindows: [VideoWindow]) {
    response = .all
//    status = .ok
//    videos = videoWindows.map({ ControlResponseInfo.VideoInfo(using: $0) })
    
    status = .failed
    videos = []
  }
}
  
