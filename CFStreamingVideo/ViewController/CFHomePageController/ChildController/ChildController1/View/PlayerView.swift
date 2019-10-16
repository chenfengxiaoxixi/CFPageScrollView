//
//  PlayerView.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/10/15.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol PlayerViewDelegate {

    func player(playerView: PlayerView, slider: UISlider)
    func player(playerView: PlayerView, playAndPause playBtn: UIButton)
    func player(playerView: PlayerView, backAction backBtn: UIButton)
    func player(playerView: PlayerView, rotateAction rotateBtn: UIButton)
}

class PlayerView: UIView {

    var playerLayer: AVPlayerLayer!
    var timeLabel: UILabel!
    var slider: UISlider!
    var progressView: UIProgressView!
    var playBtn: UIButton!
    var backBtn: UIButton!
    var rotateBtn: UIButton!
    var sliding = false
    var playing = true
    weak var delegate: PlayerViewDelegate?
    
    //重载layerClass，把CALayer替换成AVPlayerLayer
    override open class var layerClass: AnyClass {
        get {
            return AVPlayerLayer().classForCoder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        
        backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 15, y: 10, width: 40, height: 30)
        backBtn.setImage(UIImage(named: "ykcomic_icon_back_white_24x24_"), for: .normal)
        addSubview(self.backBtn)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        
        rotateBtn = UIButton.init(type: .custom)
        rotateBtn.frame = CGRect(x: frame.width - 30 - 15, y: 10, width: 30, height: 30)
        rotateBtn.setImage(UIImage(named: "sv_rotation_24x24_"), for: .normal)
        addSubview(self.rotateBtn)
        rotateBtn.addTarget(self, action: #selector(rotateBtnAction), for: .touchUpInside)
        
        playBtn = UIButton.init(type: .custom)
        playBtn.frame = CGRect(x: 5, y: frame.height - 60, width: 30, height: 30)
        playBtn.setImage(UIImage(named: "detail_player_control_pause_new1_24x24_"), for: .normal)
        addSubview(self.playBtn)
        playBtn.addTarget(self, action: #selector(playBtnAction), for: .touchUpInside)
        
        slider = UISlider.init(frame: CGRect(x: playBtn.frame.maxX + 5, y: frame.height - 45, width: frame.width - 140, height: 1))
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = ThemeBlueColor
        slider.setThumbImage(UIImage(named:"detail_player_red_progress_indicator_16x16_"), for: .normal)
        addSubview(self.slider)
        
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown), for: .touchDown)
      
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut), for: .touchCancel)
        
        progressView = UIProgressView.init(frame: CGRect(x: playBtn.frame.maxX + 9, y: frame.height - 45, width: frame.width - 144, height: 1))
        progressView.backgroundColor = .lightGray
        insertSubview(self.progressView, belowSubview: self.slider)
        progressView.tintColor = .white
        progressView.progress = 0

        timeLabel = UILabel.init(frame: CGRect(x: slider.frame.maxX + 10, y: frame.height - 53, width: 80, height: 20))
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.text = "00:00/00:00"
        addSubview(self.timeLabel)
        
        timeLabel.sizeToFit()
    }
    
    @objc func sliderTouchDown() {
        sliding = true
    }
    
    @objc func sliderTouchUpOut() {
        // 代理处理
        delegate?.player(playerView: self, slider: self.slider)
    }

    @objc func rotateBtnAction() {
        // 代理方法
        delegate?.player(playerView: self, rotateAction: rotateBtn)
    }
    
    @objc func backBtnAction() {
        // 代理方法
        delegate?.player(playerView: self, backAction: backBtn)
    }
    
    @objc func playBtnAction() {
        playing = !playing // 改变状态
        
        // 根据状态设定图片
        if playing {
            playBtn.setImage(UIImage(named: "detail_player_control_pause_new1_24x24_"), for: .normal)
        }else{
            playBtn.setImage(UIImage(named: "detail_player_control_play_new2_24x24_"), for: .normal)
        }
        // 代理方法
        delegate?.player(playerView: self, playAndPause: playBtn)
    }
    
    func updateUI() {
            
            backBtn.frame = CGRect(x: 15, y: 10, width: 40, height: 30)
            rotateBtn.frame = CGRect(x: frame.width - 30 - 15, y: 10, width: 30, height: 30)
            playBtn.frame = CGRect(x: 5, y: frame.height - 60, width: 30, height: 30)
            slider.frame = CGRect(x: playBtn.frame.maxX + 5, y: frame.height - 45, width: frame.width - 140, height: 1)
            progressView.frame = CGRect(x: playBtn.frame.maxX + 9, y: frame.height - 45, width: frame.width - 144, height: 1)
            timeLabel.frame = CGRect(x: slider.frame.maxX + 10, y: frame.height - 53, width: 80, height: 20)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
