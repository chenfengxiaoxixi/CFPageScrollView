//
//  SearchController.swift
//  CFStreamingVideo
//
//  Created by chenfeng on 2019/9/6.
//  Copyright © 2019 chenfeng. All rights reserved.
//

import UIKit

class SearchController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = RGB(r: 29.0, g: 32.0, b: 41.0, a: 1.0)
       
        let grayView = UIView.init(frame: CGRect(x: 15, y: STATUS_AND_NAV_BAR_HEIGHT - 35, width: SCREEN_WIDTH - 30 - 60, height: 35))
        grayView.backgroundColor = RGB(r: 44.0, g: 47.0, b: 55.0, a: 1.0);
        grayView.layer.masksToBounds = true
        grayView.layer.cornerRadius = 17;
        view.addSubview(grayView)
        
        let searchImage = UIImageView.init(frame: CGRect(x: 10, y: 2, width: 30, height: 30))
        searchImage.image = UIImage.init(named: "home_icon_search_white_30x30_")
        grayView.addSubview(searchImage)
        
        let textField = UITextField(frame: CGRect(x: searchImage.frame.maxX + 5, y: 0, width:grayView.mj_w - 10 - searchImage.mj_w - 5, height: 35))
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.placeholder = "请输入查询内容"
        textField.returnKeyType = .search
        textField.delegate = self
        grayView.addSubview(textField)
        
        //textField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        //textField.becomeFirstResponder()
    
        let cancelButton = UIButton(type: .custom);
        cancelButton.frame = CGRect(x: grayView.frame.maxX + 15, y: STATUS_AND_NAV_BAR_HEIGHT - 35, width: 40, height: 35)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        view.addSubview(cancelButton)
        
    }
    
    @objc func cancelAction() {
        
        dismiss(animated: true) {
            
        }
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

// MARK: - UISearchBarDelegate

extension SearchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
