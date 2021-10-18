from random import choice

class RandomWalk():
    """一个生成随机漫步数据的类"""
    #将默认点数设置为5000
    def __init__(self, num_points=5000):
        """初始化随机漫步的属性"""
        self.num_points=num_points

        #所有随机漫步都始于(0,0)
        self.x_values=[0]
        self.y_values=[0]

    def fill_walk(self):
        """计算随机漫步包含的所有点"""

        #不断漫步，直到列表达到指定的长度
        while len(self.x_values)<self.num_points:
            # 决定前进方向以及沿这个方向前进的距离
            # choice([1,-1])表示在1或-1中，随机返回一个值，返回1表示向右走，-1表示向左走
            x_direction=choice([1,-1])
            # 随机返回0~4之间的任意一个整数，表示走多远
            x_distance=choice([0,1,2,3,4])
            #将移动方向乘以移动距离，得到沿x轴移动的距离
            x_step=x_direction*x_distance

            y_direction=choice([1,-1])
            y_distance=choice([0,1,2,3,4])
            y_step=y_direction*y_distance

            #拒绝原地踏步
            if x_step==0 and y_step==0:
                continue

            #计算下一个点的x和y的值，获取x_values中的最后一个值并相加
            next_x=self.x_values[-1]+x_step
            next_y=self.y_values[-1]+y_step

            self.x_values.append(next_x)
            self.y_values.append(next_y)

