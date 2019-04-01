//
//  ViewController.swift
//  GuidePageView
//
//  Created by lisilong on 01/06/2018.
//  Copyright (c) 2018 lisilong. All rights reserved.
//

import UIKit
import GuidePageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 首页背景图
        let imageView = UIImageView.init(image: UIImage.init(named: "view_bg_image.png"))
        imageView.frame = self.view.bounds
        self.view.addSubview(imageView)
        
        // 引导页案例
//        let gifArray = ["shopping.gif", "guideImage6.gif", "guideImage7.gif", "guideImage8.gif", "adImage3.gif", "adImage4.gif"]
//        let imageArray = ["guideImage1.jpg", "guideImage2.jpg", "guideImage3.jpg", "guideImage4.jpg", "guideImage5.jpg"]
        var imageGifArray = ["guideImage1.jpg","guideImage6.gif","guideImage7.gif","guideImage3.jpg", "guideImage5.jpg"]
        let guideView = GuidePageView.init(images: imageGifArray, loginRegistCompletion: {
            print("登录/注册")
        }) {
            print("开始使用app")
        }
        guideView.isSlipIntoHomeView = true
        self.view.addSubview(guideView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

