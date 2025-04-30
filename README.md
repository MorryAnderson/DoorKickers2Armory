# DoorKickers2Armory

## 简介

这是一个用于分析《破门而入2》这款游戏中枪械参数的Matlab App。

## 运行

运行此程序需要先安装Matlab Runtime （2022a）

下载release中的压缩包for_redistribution_files_only.zip，解压。

请先修改steam_path.txt中的路径

​	第一行写你的电脑上Steam的安装路径（该路径下应该有steam.exe文件）。

​	不要写错，否则程序会出错。

确保doctrines.csv和gun_length.csv放在DoorKickers2Armory.exe同目录下，这两个文件需要手动更新数据。

## 开发

若要开发此程序，请先确保你安装了Matlab（建议2022a以及之后的版本）。

在Matlab中打开.m源文件和DoorKickersArmory.mlapp文件修改源代码，

在Matlab中打开DoorKickersArmory.prj以将最新程序重新打包为exe。

## 提示

曲线类型中的击杀耗时指的是：

从枪线碰到敌人开始计时，经过瞄准、射击、到最终击杀敌人所需时间（单位为毫秒）。

击杀耗时取决于：

瞄准时间（aimTime）、子弹伤害（damage）、射速（roundsPerSecond）、恢复时间（resetTime）、最小射击次数（minShots）、最大射击次数（maxShots）

当勾选了“暴击即死”，则在暴击率为100%时，击杀耗时 = 瞄准时间。
