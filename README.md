# ZYLoadAnimator
一个加载视图

##### 效果图
![image](https://github.com/ethanCun/ZYLoadAnimator/blob/master/ZYLoaddingAnimator.gif)

##### 使用
1.手动引入4个文件
2.coocapods
```
pod 'ZYLoaddingAnimator', '~>0.0.1'
```

##### 开始
```
    [[ZYLoadingAnimator shareAnimator] showLoaddingAnimatorInView:self.view tintColor:[UIColor redColor]];
```

##### 结束
```
    [[ZYLoadingAnimator shareAnimator] hiddenLoaddingAnimator];
```
