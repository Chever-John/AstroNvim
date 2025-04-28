# 这里我记录一下所有的快捷键

没办法,我的快捷键太多了，很多时候,用了一会，过段时间如果不使用这些快捷键，那么就会遗忘掉。

总之还是得多用。

## AstroNvim 本身

其实这个可以看官网。请点击 [link](https://docs.astronvim.com/mappings/)

### General Mappings

| Action                      | Mappings       | Explanation                                                |
| --------------------------- | -------------- | ---------------------------------------------------------- |
| Leader key                  | `Space`        |                                                            |
| Local Leader key            | `,`            |                                                            |
| Resize up                   | `Ctrl + Up`    |                                                            |
| Resize Down                 | `Ctrl + Down`  |                                                            |
| Resize Left                 | `Ctrl + Left`  |                                                            |
| Resize Right                | `Ctrl + Right` |                                                            |
| Up Window                   | `Ctrl + k`     | 在各个小窗口 buffer 之间互相跳转                           |
| Down Window                 | `Ctrl + j`     | 在各个小窗口 buffer 之间互相跳转                           |
| Left Window                 | `Ctrl + h`     | 在各个小窗口 buffer 之间互相跳转                           |
| Right Window                | `Ctrl + l`     | 在各个小窗口 buffer 之间互相跳转                           |
| Force Write                 | `Ctrl + s`     | 强制存储                                                   |
| Force Quit                  | `Ctrl + q`     | 强制退出                                                   |
| New File                    | `Leader + n`   |                                                            |
| Rename Current File         | `Leader + R`   | 重命名当前所在的文件的名字                                 |
| Close Buffer                | `Leader + c`   | 关闭当前的 buffer                                          |
| Next Tab (real vim tab)     | `]t`           |                                                            |
| Previous Tab (real vim tab) | `[t`           |                                                            |
| Horizontal Split            | `\`            | 水平，向下创建一个当前一模一样的，使用 leader + q 可以退出 |
| Vertical Split              | `|`            | 左右，向右创建一个当前一模一样的，使用 leader + q 可以退出 |

### Buffers

| Action                                                       | Mappings       | Explanation |
| ------------------------------------------------------------ | -------------- | ----------- |
| Next Buffer                                                  | `]b`           | 在不同的 buffer 的 tab 之间切换 |
| Previous Buffer                                              | `[b`           | 在不同的 buffer 的 tab 之间切换 |
| Move Buffer Right                                            | `>b`           | 将当前的 buffer 向后移动一个位置 |
| Move Buffer Left                                             | `<b`           | 将当前的 buffer 向前移动一个位置 |
| Navigate to buffer tab with interactive picker               | `Leader + bb`  | 当运行之后，然后可以看到 tab 各个都有一个自己的单词，这样可以快速选择你所需要的 buffer tab |
| Close all buffers except the current                         | `Leader + bc`  | 好理解哈，关闭除了自己当前以外的其他的 buffers |
| Close all buffers                                            | `Leader + bC`  | 关闭所有的 buffers |
| Delete a buffer tab with interactive picker                  | `Leader + bd`  | 交互关闭指定的 buffer tab |
| Close all buffers to the left of the current                 | `Leader + bl`  | 关闭当前到左边的所有的 buffer tab |
| Go to the previous buffer                                    | `Leader + bp`  | 去前一个历史 buffer tab |
| Close all buffers to the right of the current                | `Leader + br`  | 关闭当前到右边的所有的 buffer tab |
| Sort buffers by extension                                    | `Leader + bse` |             |
| Sort buffers by buffer number                                | `Leader + bsi` |             |
| Sort buffers by last modification                            | `Leader + bsm` |             |
| Sort buffers by full path                                    | `Leader + bsp` |             |
| Sort buffers by relative path                                | `Leader + bsr` |             |
| Open a buffer tab in a new horizontal split with interactive picker | `Leader + b\`  |             |
| Open a buffer tab in a new vertical split with interactive picker | `Leader + b|`  |             |

### Commenting Mappings

| Action                            | Mappings     | Explanation |
| --------------------------------- | ------------ | ----------- |
| Toggle comment of current line    | `Leader + /` |             |
| Insert comment below current line | `gco`        |             |
| Insert comment above current line | `gcO`        |             |

### List Management

| Action                    | Mappings      | Explanation |
| ------------------------- | ------------- | ----------- |
| Open Quickfix List        | `Leader + xq` |             |
| Next Quickfix Entry       | `]q`          |             |
| Previous Quickfix Entry   | `[q`          |             |
| Last Quickfix Entry       | `]Q`          |             |
| First Quickfix Entry      | `[Q`          |             |
| Open Local List           | `Leader + xl` |             |
| Next Local List Entry     | `]l`          |             |
| Previous Local List Entry | `[l`          |             |
| Last Local List Entry     | `]L`          |             |
| First Local List Entry    | `[L`          |             |
