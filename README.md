# GuessPictureDemo
一个猜图的的小游戏


开发过程遇到的难点：

1，将button按钮添加到父视图imageView上，导致按钮的不能触发。

解决方案：把按钮添加到了交互性为NO的控件上,比如imageView; 将imageview上的interaction：user interaction enabled选上。
 