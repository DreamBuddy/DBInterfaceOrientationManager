# DBInterfaceOrientationManager
> App横竖屏旋转一句话管理 Just One Line

#### 痛点:
一般我们在开发App的时候在info.plist中`Supported interface orientations`会默认只选中`Portrait`，也就是竖屏这样能适应绝大多数情景，因为一般页面都是设计单竖屏的，但但但是在视频播放时全屏播放需要数横屏播放..这时候在`plist`中多添加一个横屏字段App又会胡乱旋转，真是头疼，mmp
####我们有一个更便捷的解决方案:
在需要开启设备自动旋转的时候使用

```
[DBInterfaceOrientationManager allowRotation:YES];
```
需要关闭的时候:

```
[DBInterfaceOrientationManager allowRotation:NO];
```
强制旋转屏幕方向:

```
[DBInterfaceOrientationManager forceInterfaceOrientation:UIInterfaceOrientationPortrait];
```

