# 安装 mason 失败了

一天我突然遇到报错

![file](assets/ek8ye3z5pji8.png)

解决方法是

```shell
:MasonInstall --force delve gopls goimports
```

我还解锁了一个新的排查问题的方法。

```shell
:MasonLog
```

![image-20250428145221368](assets/image-20250428145221368.png)

