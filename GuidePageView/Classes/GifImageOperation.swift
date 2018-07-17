//
//  GifImageOperation.swift
//  TDGuidePageView
//
//  Created by lisilong on 2018/1/4.
//  Copyright © 2018年 tuandai. All rights reserved.
//

import UIKit

public enum DataType: String {
    case gif    = "gif"
    case png    = "png"
    case jpeg   = "jpeg"
    case tiff   = "tiff"
    case defaultType
}

public class GifImageOperation: UIView {
    private var gifTimer: DispatchSourceTimer?  // GIF播放定时器
    
    /// 播放gif图片
    ///
    /// - Parameters:
    ///   - frame: 显示大小
    ///   - gifData: gif数据
    public convenience init(frame: CGRect = UIScreen.main.bounds, gifData: Data) {
        self.init(frame: frame)
        
        let gifProperties  = NSDictionary.init(object: NSDictionary.init(object: NSNumber.init(value: 0),
                                                                         forKey: kCGImagePropertyGIFLoopCount as! NSCopying),
                                               forKey: kCGImagePropertyGIFDictionary as! NSCopying)
        guard let gifDataSource  = CGImageSourceCreateWithData(gifData  as CFData, gifProperties) else {
            return
        }
        // gif 总帧数
        let gifImagesCount = CGImageSourceGetCount(gifDataSource)
        // gif 图片组
        var images = [UIImage]()
        // gif 播放时长
        var gifDuration = 0.0
        for i in 0 ..< gifImagesCount {
            guard let imageRef = CGImageSourceCreateImageAtIndex(gifDataSource, i, gifProperties) else {
                return
            }
            if gifImagesCount == 1 {    // 单帧
                gifDuration = Double.infinity
            } else {                    // 获取到 gif每帧时间间隔
                guard let properties = CGImageSourceCopyPropertiesAtIndex(gifDataSource, i, nil),
                    let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                    let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                    return
                }
                gifDuration += frameDuration.doubleValue
                let image = UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up)
                images.append(image)
            }
        }
        
        // 根据总时长和总帧数，计算平均播放时长
        var repeating = gifDuration / Double(gifImagesCount)
        // 规则一： 如果平均时长超过1.2秒, 按0.1计算
        repeating = repeating > 1.2 ? 0.1 : repeating
        // 规则二： 如果总帧数超过30并且时长超过0.06，按0.06计算
        repeating = (gifImagesCount > 30 && repeating > 0.06) ? 0.06 : repeating
        // 规则三： 如果总帧数超过50并且时长超过0.04，按0.04计算
        repeating = (gifImagesCount > 50 && repeating > 0.04) ? 0.04 : repeating
        gifTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        gifTimer?.schedule(deadline: .now(), repeating: repeating)
        var index = 0
        gifTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                index = index % gifImagesCount
                let imageref: CGImage? = CGImageSourceCreateImageAtIndex(gifDataSource, index, nil)
                self?.layer.contents = imageref
                index += 1
            }
        })
        gifTimer?.resume()
    }
    
    // MARK: - actions
    
    /// 验证资源的格式
    ///
    /// - Parameter data: 资源
    /// - Returns: 返回资源格式（png/gif/jpeg...）
    public class func checkDataType(data: Data?) -> DataType {
        guard data != nil else {
            return .defaultType
        }
        let c = data![0]
        switch (c) {
        case 0xFF:
            return .jpeg
        case 0x89:
            return .png
        case 0x47:
            return .gif
        case 0x49, 0x4D:
            return .tiff
        default:
            return .defaultType
        }
    }
}
