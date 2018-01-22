//
//  GuidePageView.swift
//  GuidePageView
//
//  Created by lisilong on 2018/1/4.
//  Copyright © 2018年 tuandai. All rights reserved.
//

import UIKit

public class GuidePageView: UIView {
    private var imageArray: Array<String>?
    private var isHiddenSkipBtn: Bool = false           // 是否隐藏跳过按钮(true 隐藏; false 不隐藏)，default: false
    private var isHiddenStartBtn: Bool = false          // 是否隐藏立即体验按钮(true 隐藏; false 不隐藏)，default: false
    private lazy var guideScrollView: UIScrollView = {
        let view = UIScrollView.init()
        view.backgroundColor = UIColor.lightGray
        view.bounces = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        return view
    }()
    private lazy var pageControl: UIPageControl = {
        var page = UIPageControl.init()
        page.currentPage = 0
        page.pageIndicatorTintColor = UIColor.gray
        page.currentPageIndicatorTintColor = UIColor.white
        return page
    }()
    /// 跳过按钮
    public lazy var skipButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.setTitle("跳 过", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(skipBtnClicked), for: .touchUpInside)
        return btn
    }()
    /// 登录注册按钮
    public lazy var logtinButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("注册/登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.sizeToFit()
        btn.setBackgroundImage(imageFromBundle(name: "start_btn_bg.png"), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        return btn
    }()
    /// 立即体验按钮
    public lazy var startButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("随便看看 ＞", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.sizeToFit()
        btn.addTarget(self, action: #selector(startBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    var startCompletion: (() -> ())?
    var loginCompletion: (() -> ())?
    let pageControlHeight: CGFloat = 40.0
    let startHeigth: CGFloat = 30.0
    let loginHeight: CGFloat = 50.0
    
    // MARK: - life cycle
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// App启动引导页
    ///
    /// - Parameters:
    ///   - frame: 引导页大小
    ///   - images: 引导页图片（gif/png/jpeg...）注意：gif图不可放在Assets中，否则加载不出来（建议引导页的图片都不要放在Assets文件中，因为使用imageName加载时，系统会缓存图片，造成内存暴增）
    ///   - isHiddenSkipBtn: 是否隐藏跳过按钮
    ///   - isHiddenStartBtn: 是否隐藏立即体验按钮
    ///   - loginRegistCompletion: 登录/注册回调
    ///   - startCompletion: 立即体验回调
    public convenience init(frame: CGRect = UIScreen.main.bounds,
                     images: Array<String>,
                     isHiddenSkipBtn: Bool = false,
                     isHiddenStartBtn: Bool = false,
                     loginRegistCompletion: (() -> ())?,
                     startCompletion: (() -> ())?) {
        self.init(frame: frame)
        
        self.imageArray       = images
        self.isHiddenSkipBtn  = isHiddenSkipBtn
        self.isHiddenStartBtn = isHiddenStartBtn
        self.startCompletion  = startCompletion
        self.loginCompletion  = loginRegistCompletion
        
        setupSubviews(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    private func setupSubviews(frame: CGRect) {
        let size = UIScreen.main.bounds.size
        guideScrollView.frame = frame
        guideScrollView.contentSize = CGSize.init(width: frame.size.width * CGFloat(imageArray?.count ?? 0), height: frame.size.height)
        self.addSubview(guideScrollView)
        
        skipButton.frame = CGRect.init(x: size.width - 80.0 , y: 30.0, width: 50.0, height: 24.0)
        skipButton.isHidden = isHiddenSkipBtn
        self.addSubview(skipButton)
        
        pageControl.frame = CGRect.init(x: 0.0, y: size.height - pageControlHeight, width: size.width, height: pageControlHeight)
        pageControl.numberOfPages = imageArray?.count ?? 0
        self.addSubview(pageControl)
        
        guard imageArray != nil, imageArray?.count ?? 0 > 0 else { return }
        for index in 0..<(imageArray?.count ?? 1) {
            let name        = imageArray![index]
            let imageFrame  = CGRect.init(x: size.width * CGFloat(index), y: 0.0, width: size.width, height: size.height)
            let filePath    = Bundle.main.path(forResource: name, ofType: nil) ?? ""
            let data: Data? = try? Data.init(contentsOf: URL.init(fileURLWithPath: filePath), options: Data.ReadingOptions.uncached)
            var view: UIView
            let type = GifImageOperation.checkDataType(data: data)
            if type == DataType.gif {   // gif
                view = GifImageOperation.init(frame: imageFrame, gifData: data!)
            } else {                    // 其它图片
                // Warning: 假如说图片是放在Assets中的，使用Bundle的方式加载不到，需要使用init(named:)方法加载。
                view = UIImageView.init(frame: imageFrame)
                (view as! UIImageView).image = (data != nil ? UIImage.init(data: data!) : UIImage.init(named: name))
            }
            // 添加“立即体验”按钮和登录/注册按钮
            if imageArray?.last == name {
                view.isUserInteractionEnabled = true
                if !isHiddenStartBtn {
                    let y = size.height - pageControlHeight - startHeigth
                    let width = size.width * 0.35
                    startButton.frame = CGRect.init(x: (size.width - width) * 0.5, y: y, width: width, height: startHeigth)
                    startButton.alpha = imageArray?.count == 1 ? 1.0 : 0.0
                    view.addSubview(startButton)
                    
                    let w = size.width * 0.6
                    logtinButton.frame = CGRect.init(x: (size.width - w) * 0.5, y: y - loginHeight - 20, width: w, height: loginHeight)
                    logtinButton.alpha = imageArray?.count == 1 ? 1.0 : 0.0
                    view.addSubview(logtinButton)
                }
            }
            guideScrollView.addSubview(view)
        }
    }

    // MARK: - actions
    private func removeGuideViewFromSupview(_ completion: (() -> ())?) {
        UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
            if completion != nil {
                completion!()
            }
        }
    }
    
    /// 点击“跳过”按钮事件，立即退出引导页
    @objc private func skipBtnClicked() {
        self.removeGuideViewFromSupview {
            if self.startCompletion != nil {
                self.startCompletion!()
            }
        }
    }
    
    /// 点击“立即体验”按钮事件，退出引导页
    @objc private func startBtnClicked() {
        self.removeGuideViewFromSupview {
            if self.startCompletion != nil {
                self.startCompletion!()
            }
        }
    }
    
    /// 点击登录注册按钮
    @objc private func loginBtnClicked() {
        self.removeGuideViewFromSupview {
            if self.loginCompletion != nil {
                self.loginCompletion!()
            }
        }
    }
    
    /// 作为 pod 第三方库取图片资源
    ///
    /// - Parameter name: 图片名
    /// - Returns: 图片
    private func imageFromBundle(name: String) -> UIImage {
        let podBundle = Bundle(for: self.classForCoder)
        let bundleURL = podBundle.url(forResource: "GuideImage", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)
        let image = UIImage(named: String(name), in: bundle, compatibleWith: nil)
        return image!
    }
}

// MARK: - <UIScrollViewDelegate>
extension GuidePageView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        // 设置指示器
        pageControl.currentPage = page
        
        // 显示“立即体验”按钮 
        if !isHiddenStartBtn, (imageArray?.count ?? 0) - 1 == page {
            UIView.animate(withDuration: 1.25, animations: {
                self.startButton.alpha  = 1.0
                self.logtinButton.alpha = 1.0
            })
        }
    }
}
