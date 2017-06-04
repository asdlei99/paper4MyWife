# CFX

请问各位，如果实验中管系末端如下图所示：

![现场实物图](https://github.com/czyt1988/paper4MyWife/blob/master/question/01-cfx%E8%BE%B9%E7%95%8C%E6%9D%A1%E4%BB%B6%E8%AE%BE%E7%BD%AE/pic.png)

![示意图](https://github.com/czyt1988/paper4MyWife/blob/master/question/01-cfx%E8%BE%B9%E7%95%8C%E6%9D%A1%E4%BB%B6%E8%AE%BE%E7%BD%AE/pic2.png)

管系末端安装一个蝶阀，通过调节阀门开度改变管系内压力。管系起始端与一台往复式空气压缩机相连接，阀门用来控制管系的压力大小。

**1.阀门处如何模拟？**

实验为了使管道有一定压力，需要把阀门的开度设置的比较小。如果要模拟这种情况，管系末端在建模时有什么通常的做法么？我目前是让管道流道的流通面积变小，通过一个挡板挡住流体，其模型如下图：

![阀门处建模](https://github.com/czyt1988/paper4MyWife/blob/master/question/01-cfx%E8%BE%B9%E7%95%8C%E6%9D%A1%E4%BB%B6%E8%AE%BE%E7%BD%AE/pic3.png)

大致的流体流线效果可能是：

![阀门处建模流场](https://github.com/czyt1988/paper4MyWife/blob/master/question/01-cfx%E8%BE%B9%E7%95%8C%E6%9D%A1%E4%BB%B6%E8%AE%BE%E7%BD%AE/pic4.png)

不知这样设置是否符合，大家是如何应对这种情况的？

**2.阀门后是放空接大气，这里的边界条件如何设置，是直接设置压力为大气压就行吗？**

因为实际实验时，阀门开度很小，阀门后气体流速不会迅速变为零，压力也不会迅速变为大气压，我不太清楚怎么建模和设置边界条件能够最大程度接近实际的边界情况，请求各位虫友帮帮忙！急！谢谢！