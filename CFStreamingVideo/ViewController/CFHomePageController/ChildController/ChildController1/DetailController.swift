//
//  DetailController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/10/14.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit
import AVFoundation

class DetailController: CFBaseController {

    var playerView: PlayerView!
    var playerItem: AVPlayerItem!
    var avplayer: AVPlayer!
    var link: CADisplayLink!
    
    deinit {
        
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initPlayer()

        link = CADisplayLink(target: self, selector: #selector(updateTime))
        link.add(to: .main, forMode: .default)
    }
    
    func initPlayer()
    {
        playerView = PlayerView.init(frame: CGRect(x: 0, y: STATUSBAR_HEIGHT, width: view.frame.width, height: view.frame.width/16*9))
        playerView.delegate = self
        playerView.backgroundColor = ThemeBlackColor
        view.addSubview(playerView)
        
        let url = URL(string: "https://vd4.bdstatic.com/mda-igqy5ny4sn8uyby6/sc/mda-igqy5ny4sn8uyby6.mp4?auth_key=1564739152-0-0-7c8a2761260c09a1fab436cb2b53e9cc&bcevod_channel=searchbox_feed&pd=bjh&abtest=all")

        playerItem = AVPlayerItem(url: url!)
        //缓冲进度，其他属性可去AVPlayerItem类里面查看
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        //播放状态
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        avplayer = AVPlayer(playerItem: playerItem)
        
        (playerView.layer as! AVPlayerLayer).player = avplayer
        (playerView.layer as! AVPlayerLayer).videoGravity = .resizeAspect
        (playerView.layer as! AVPlayerLayer).contentsScale = UIScreen.main.scale
    }
    
    @objc func updateTime() {
        
        //暂停的时候
        if !playerView.playing{
            return
        }

        let currentTime = CMTimeGetSeconds(avplayer.currentTime())
        let totalTime = TimeInterval(playerItem.duration.value) / TimeInterval(playerItem.duration.timescale)
        let timeStr = "\(formatPlayTime(secounds: currentTime))/\(self.formatPlayTime(secounds: totalTime))"
        playerView.timeLabel.text = timeStr
        if !playerView.sliding{
            // 播放进度
            playerView.slider.value = Float(currentTime/totalTime)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "loadedTimeRanges" {
        
            // 通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
            let loadedTime = avalableDurationWithplayerItem()
            let totalTime = CMTimeGetSeconds(playerItem.duration)
            let percent = loadedTime/totalTime // 计算出比例
            // 改变进度条
            playerView.progressView.progress = Float(percent)
        
        } else if keyPath == "status" {
        
            if  playerItem.status == .readyToPlay {
                
                avplayer.play()

            } else {
                print("加载异常")
            }
        }
    }

    func formatPlayTime(secounds: TimeInterval) -> String{
        
        if secounds.isNaN{
            
            return "00:00"
        }

        let min = Int(secounds / 60)
        let sec = Int(secounds.truncatingRemainder(dividingBy: 60) )
        return String(format: "%02d:%02d", min,sec)
    }
    // 计算当前缓冲进度
    func avalableDurationWithplayerItem() -> TimeInterval{

        guard let loadedTimeRanges = avplayer.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    
    /// 旋转
    func toOrientation(orientation: UIInterfaceOrientation) {
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        playerView.frame.size.width = SCREEN_HEIGHT
        playerView.frame.size.height = SCREEN_WIDTH
        playerView.center = APPDELEGATE.window!.center
        
        playerView.updateUI()
        
    }
    
    /// 获取旋转角度
    private func getTransformRotationAngle() -> CGAffineTransform {
        let interfaceOrientation = UIApplication.shared.statusBarOrientation
        if interfaceOrientation == UIInterfaceOrientation.portrait {
            return CGAffineTransform.identity
        } else if interfaceOrientation == UIInterfaceOrientation.landscapeLeft {
            return CGAffineTransform(rotationAngle: (CGFloat)(Double.pi/2))
        } else if (interfaceOrientation == UIInterfaceOrientation.landscapeRight) {
            return CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        }
        return CGAffineTransform.identity
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension DetailController: PlayerViewDelegate {
    
    func player(playerView: PlayerView, slider: UISlider) {
        
        if avplayer.status == .readyToPlay {
        
            let duration = slider.value * Float(CMTimeGetSeconds(avplayer.currentItem!.duration))
            let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
            avplayer.seek(to: seekTime, completionHandler: { (b) in
                
                playerView.sliding = false
            })
        }
        
    }
    
    func player(playerView: PlayerView, playAndPause playBtn: UIButton) {
        
        if !playerView.playing{
            avplayer.pause()
        } else {
            if  avplayer.status == .readyToPlay {
                avplayer.play()
            }
        }
    }
    
    func player(playerView: PlayerView, backAction backBtn: UIButton) {
        
        if UIDevice.current.orientation == .portrait {
            
            //类似timer，退出时要停止使用
            link.invalidate()
            link = nil
            navigationController?.popViewController(animated: true)
        }
        else {
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            playerView.frame = CGRect(x: 0, y: STATUSBAR_HEIGHT, width: view.frame.width, height: view.frame.width/16*9)
            
            playerView.rotateBtn.isHidden = false
            
            playerView.updateUI()
        }
    }
    
    func player(playerView: PlayerView, rotateAction rotateBtn: UIButton) {
        
        playerView.rotateBtn.isHidden = true
        toOrientation(orientation: .landscapeRight)
    }
    
}
    


