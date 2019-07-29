//
//  GoogleInteractiveMediaAdsAdapter+QBPlayerObserverProtocol.swift
//  GoogleInteractiveMediaAdsTvOS
//
//  Created by Anton Kononenko on 7/25/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappPlugins

extension GoogleInteractiveMediaAdsAdapter: QBPlayerObserverProtocol {
    
    public func playerDidFinishPlayItem(player:QBPlayerProtocol,
                                 completion:@escaping (_ finished:Bool) -> Void) {
        guard let postrollUrl = urlTagData?.postrollUrlString() else {
            adsLoader?.contentComplete()
            completion(true)
            return
        }
        postrollCompletion = completion
        
        requestAd(adUrl:postrollUrl)
        Timer.scheduledTimer(withTimeInterval: 1,
                             repeats: false) { [weak self] (timer) in
                                if ((self?.postrollCompletion) != nil) && self?.adsManager == nil {
                                    self?.postrollCompletion?(true)
                                    self?.postrollCompletion = nil
                                }
        }
    }
    
    public func playerProgressUpdate(player:QBPlayerProtocol,
                                     currentTime:TimeInterval,
                                     duration:TimeInterval) {
        if let currentVideoTime = playerPlugin?.playbackPosition(),
            let url = urlTagData?.requestMiddroll(currentVideoTime:currentVideoTime) {
            requestAd(adUrl: url)
        }

        
    }
    
    public func playerDidDismiss(player: QBPlayerProtocol) {
        playerPlugin = nil
        adsLoader?.delegate = nil
        adsLoader = nil
        contentPlayhead = nil
        adsManager?.delegate = nil
        adsManager = nil
        adRequest = nil
    }
    
    public func playerDidCreate(player:QBPlayerProtocol)  {
        prepareGoogleIMA()
    }
}
