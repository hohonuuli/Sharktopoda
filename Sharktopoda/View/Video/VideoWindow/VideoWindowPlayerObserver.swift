//
//  VideoWindowPlayerObserver.swift
//  Created for Sharktopoda on 11/22/22.
//
//  Apache License 2.0 — See project LICENSE file
//

import AVFoundation

extension VideoWindow {
  func setLocalizationsObserver() {
    let interval = CMTimeMultiplyByFloat64(videoAsset.frameDuration, multiplier: 0.66)

    playerControl.player.addPeriodicTimeObserver(forInterval: interval, queue: queue) { [weak self] time in
      guard self?.playerView.showLocalizations ?? false else { return }
      
      guard let localizations = self?.localizations,
            let playerControl = self?.playerControl,
            let playerView = self?.playerView else { return }

      let elapsedTime = time.asMillis()
      let direction = playerControl.playDirection
      let opposite = direction.opposite()

      playerView.display(localizations: localizations.fetch(direction, at: elapsedTime))
      playerView.clear(localizations: localizations.fetch(opposite, at: elapsedTime))
    }
  }
}
