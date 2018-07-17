# GuidePageView 引导页组件
## 介绍
App启动引导页，支持播放gif/png/jpg等类型的资源数组。


> Swift 4.2
>
> iOS 8.0
>
> Xcode 10.0
>

版本：
1.0.0版本  Xcode 9，  Swift 4.0
1.1.0版本  Xcode 10，  Swift 4.1~4.2

## Gif演示：

![GuidePageView.gif](http://upload-images.jianshu.io/upload_images/877439-71f9a9a8c30aa7ec.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 可配置接口介绍

### 实例化接口及可配置参数

```Swift
/// 指示器
public lazy var pageControl: PageControl

/// 跳过按钮
public lazy var skipButton: UIButton { get set }

/// 立即体验按钮
public lazy var startButton: UIButton { get set }

/// 登录注册按钮
public lazy var logtinButton: UIButton { get set }

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
startCompletion: (() -> ())?)

```

### 新增控件
#### PageControl（指示器）
- 通过(setImage:forState:)方法可以设置指示器的默认和选中样式；
- 通过itemSpacing属性可以设置指示器之间的间距；
- 。。。（具体的可看源码）

## Example

### 配置Podfile

```Swift
pod 'GuidePageView'
```

### 执行pod命令，导入组件

```Swift
pod install
```
### 案例

```Swift
// gif和jpg类型的资源数组
let imageGifArray = ["guideImage1.jpg","guideImage6.gif", "guideImage8.gif", "guideImage2.jpg","guideImage7.gif", "guideImage5.jpg"]
let guideView = GuidePageView.init(images: imageGifArray, loginRegistCompletion: {
    print("登录/注册")}
}) {
    print("开始使用app")
}
self.view.addSubview(guideView)
```
