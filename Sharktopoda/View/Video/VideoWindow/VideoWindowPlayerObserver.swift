//
//  VideoWindowPlayerObserver.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension VideoWindow {
  func setPlayerObserver(_ pollingInterval: CMTime) {
    windowData.player.addPeriodicTimeObserver(forInterval: pollingInterval,
                                              queue: playerTimeQueue) { [weak self] time in
      guard let windowData = self?.windowData else { return }

      guard windowData.playerView.showLocalizations else { return }
      
      DispatchQueue.main.async { [weak windowData] in
        guard let windowData else { return }

        windowData.playerTime = time

        windowData.playerView.clear()
        windowData.displaySpanned()
      }
    }
    
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(playerHitEnd),
                   name: .AVPlayerItemDidPlayToEndTime,
                   object: nil
      )
  }
  
  @objc func playerHitEnd(_: NSNotification) {
    windowData.playerDirection = .paused
  }
}
