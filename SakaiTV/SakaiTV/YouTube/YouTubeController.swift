//
//  YouTubeController.swift
//  SakaiTV
//
//  Created by yuyuanyuan on 11/20/18.
//  Copyright © 2018 yuyuanyuan. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit
import AVFoundation

#if swift(>=3.0)
struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}
#else
typealias Error = NSError
struct YouTubeVideoQuality {
static let hd720 = NSNumber(unsignedLong: XCDYouTubeVideoQuality.HD720.rawValue)
static let medium360 = NSNumber(unsignedLong: XCDYouTubeVideoQuality.Medium360.rawValue)
static let small240 = NSNumber(unsignedLong: XCDYouTubeVideoQuality.Small240.rawValue)
}
#endif

/*reference: https://github.com/0xced/XCDYouTubeKit
 *This Controller is used to control the youtube video. It used AVPlayer to
 *play or stop the video.It used XCDYouTubeKit to get the youtube video from Youtube
 */
class YouTubeController: ViewController {
    
    @IBOutlet weak var Movie: UIView!

    @IBAction func Play(_ sender: UIButton) {
        self.player.play()
    }
    @IBAction func Pause(_ sender: UIButton) {
        self.player.pause()
    }
    var videotoken: String = ""
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setenv("XCDYouTubeKitLogLevel", "0", 1)
        
        let client = XCDYouTubeClient(languageIdentifier: "en")
        //"6v2L2UGZJAM"
        client.getVideoWithIdentifier(videotoken) { (video: XCDYouTubeVideo?, error: Error?) -> Void in
            if let video = video {
               /* video.description
                video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming]
                video.streamURLs[YouTubeVideoQuality.hd720]
                video.streamURLs[YouTubeVideoQuality.medium360]
                video.streamURLs[YouTubeVideoQuality.small240]*/
                
                let videoURL = video.streamURLs[YouTubeVideoQuality.small240]
                self.player = AVPlayer(url: videoURL!)
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.frame = self.Movie.bounds
                self.Movie.layer.addSublayer(playerLayer)
                
            } else {
               // error?.localizedDescription
            }
        }
    }
}
