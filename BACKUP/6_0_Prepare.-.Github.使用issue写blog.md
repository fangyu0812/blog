# [0_Prepare - Github 使用issue写blog](https://github.com/fangyu0812/blog/issues/6)


# 1. 看大神怎么用github记录

参考bilibili up： 
https://www.bilibili.com/video/BV1S4411m7kf/?spm_id_from=333.337.search-card.all.click



用issue写的好处：
	1. 可以设定多个标签；
	2. 可以把link贴进去；
	3. 可以把标题印到README中；

# Step by step 设定

参考 <https://zhuanlan.zhihu.com/p/400962805>
 
核心是 使用github action 帮忙自动生成REAME；

## **01. 下载整个项目文件**

  

点击项目首页的绿色按钮 Code，在弹出的面板中，选择 **Download ZIP**，以压缩包的形式下载整个项目文件。

  

![](https://pica.zhimg.com/v2-99c5945c039bf1540700db3097f4fffc_1440w.png)

  

下载解压得到的文件，对解压得到的文件进行修改。BACKUP 文件夹存放的是项目作者之前发布的博客的备份文件，你可以将这个文件夹删除。

  

![](https://pic1.zhimg.com/v2-f372412193b87179ae49c694449d1ec2_1440w.png)

  

打开 `.github` 文件夹，里面有一个 workflows 子文件夹，继续打开，可以看到一个名为 `generate_readme.yml` 的文件，在**记事本**或**代码编辑器**中打开这个文件。

  

![](https://pica.zhimg.com/v2-db9845e26f7106beebb86aa75c648958_1440w.png)

  

这里我使用代码编辑器 **[VS Code](https://zhida.zhihu.com/search?content_id=177232994&content_type=Article&match_order=1&q=VS+Code&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NjIzNDYxMzksInEiOiJWUyBDb2RlIiwiemhpZGFfc291cmNlIjoiZW50aXR5IiwiY29udGVudF9pZCI6MTc3MjMyOTk0LCJjb250ZW50X3R5cGUiOiJBcnRpY2xlIiwibWF0Y2hfb3JkZXIiOjEsInpkX3Rva2VuIjpudWxsfQ.KwJROK0Hlu7Mr30s0SijprIZbYhm9F18zYgsiefwXmc&zhida_source=entity)** 打开这个文件，需要修改两个地方，一个是 **branches** 的值，将其由原来的 master 更改为 **main**。

  

另一个是分别将下面的 **GITHUB_NAME** 和 **GITHUB_EMAIL** 替换成自己的 **GitHub 账号的 ID** 和**邮箱**。

  

![](https://pic2.zhimg.com/v2-9a48a4231ebf3456fba2f835255b525b_1440w.png)

  

还没有 GitHub 账号的朋友，请出门右转先注册一个 GitHub 账号：

_[https://github.com/signup](https://link.zhihu.com/?target=https%3A//github.com/signup)_

  

修改好上面两处地方之后，记得在关闭文件之前保存一下文件。

  

## **02. 在 GitHub 创建一个新的仓库**

  

回到浏览器中的 GitHub 个人主页，点击右上角的加号，选择 **New repository** 创建一个新的仓库。

  

![](https://pic2.zhimg.com/v2-eee609347c8cc7ccafa8ce44a8ef29ad_1440w.png)

  

为你的新仓库起一个名字，名字可以是英文，也可以是英文与数字的组成，暂不支持中文仓库名。

  

![](https://pic2.zhimg.com/v2-5d015807eeba7bf42c8b840af5fdd9c5_1440w.png)

  

接着勾选下方的 **Choose a license**，从内置的许可证中选择一个**协议**，因为我们使用的是别人写好的代码，因此这里最好使用与原来相同的 **[MIT 开源协议](https://zhida.zhihu.com/search?content_id=177232994&content_type=Article&match_order=1&q=MIT+%E5%BC%80%E6%BA%90%E5%8D%8F%E8%AE%AE&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NjIzNDYxMzksInEiOiJNSVQg5byA5rqQ5Y2P6K6uIiwiemhpZGFfc291cmNlIjoiZW50aXR5IiwiY29udGVudF9pZCI6MTc3MjMyOTk0LCJjb250ZW50X3R5cGUiOiJBcnRpY2xlIiwibWF0Y2hfb3JkZXIiOjEsInpkX3Rva2VuIjpudWxsfQ.4JL_Taw9cg_rh073iFT2k4QquATs5fCGcgJk2gEoozk&zhida_source=entity)**。

  

最后点击底部的绿色按钮 **Create repository**，完成新仓库的创建。

  

![](https://pic3.zhimg.com/v2-ca978ed290a3318b87b1596865ea6e2c_1440w.png)

  

在新仓库中，点击右上角的 **Add file**，选择 **Upload files**，将之前下载到本地的文件上传到仓库中。

  

![](https://pic4.zhimg.com/v2-b95a9692d66d99c13093b5a9a89a8261_1440w.png)

  

上传本地文件，和平常上传文件到其他网站是一样的，这里需要上传的文件有 `main.py` 和 `requirements.txt`。

  

![](https://pic1.zhimg.com/v2-f372412193b87179ae49c694449d1ec2_1440w.png)

  

本地的文件夹 `.github` 中有一个名为 `generate_readme.yml` 的文件，由于 GitHub 网页版不支持直接上传文件夹，我们要使用另外一个选项 **Create new file**。

  

![](https://picx.zhimg.com/v2-5ebffc707eabf7f465cf0bcad10afae1_1440w.png)

  

在左上角的文件名输入 `.github/` 才能创建一个文件夹路径，按照本地的文件夹路径，后面继续输入 `workflows/generate_readme.yml`。

  

![](https://pic1.zhimg.com/v2-b7da6044efe8d91995dd075828a54d74_1440w.png)

  

最终得到的**文件路径**和**文件名**如下图，接着将本地的 `generate_readme.yml` 文件的内容复制到下方的编辑窗口中。

  

![](https://pic4.zhimg.com/v2-a44f28d7701a1dc408fbcc30e87d9f7d_1440w.png)

  

复制过来之后，滑动到页面底部的绿色按钮 **Commit new file**，点击确认创建文件。

  

![](https://picx.zhimg.com/v2-6137668b2c41d650d654709d20184f29_1440w.png)

  

## **03. 获取 Token 并配置参数**

  

为了让我们前面创建的 `generate_readme.yml` 可以顺利运行，我们还需要获取一个 **Token** 参数，并将其配置到仓库的 **Secrets** 中。

  

在浏览器打开网页 `https://github.com/settings/tokens` ，点击右上角的 **Generate new token**。

  

![](https://pic4.zhimg.com/v2-ba7eeb87fb9e4ec66cda9d27ffc3ee65_1440w.png)

  

Note 这里需要我们为即将生成的 Token **添加一个备注信息**，你可以随意填，也可以填入一点比较有意义的信息，譬如下图的 blog_token。

  

接着下方还要**开启权限**，为了避免后面程序运行时出错，这里建议**勾选所有复选框**，最后点击底部的绿色按钮 **Generate token**，生成一个 Token。

  

![](https://pica.zhimg.com/v2-de612e5d5b087a3f4be1e1332705a3b2_1440w.png)

  

生成的 Token 是一长串数字和字母的组合，我们不需要记住它，只需要点击 Token 右侧的**复制**按钮，将其复制到剪贴板。

  

![](https://pica.zhimg.com/v2-ad48e0bb293805441f0528434696ff46_1440w.png)

  

接着回到我们前面创建的博客仓库，点击 **Settings** >> **Secrets** >> **New repository secret**。

  

![](https://picx.zhimg.com/v2-f84631d6c2e0f9d45d6b9f59a25e8fcd_1440w.png)

  

这里需要填入两个值，**Name** 填入 **G_T**，这个值是固定的，它与之前的 `generate_readme.yml` 文件中定义的**变量名**有关，变量名没有改变的话，值就是这一个。

  

下方的 **Value** 就填入刚刚我们复制到剪贴板的 Token 值，最后点击下方的 **Add secret** 即可。

  

![](https://pic4.zhimg.com/v2-9b3f0371dafb7d4906ca94a8e06289b3_1440w.png)

  

## **04. 使用 Issues 发布第一篇博客**

  

完成上面的操作，就可以说是完成了写博客之前的所有配置，点击仓库顶部的 **Issues** 选项卡，接着点击右侧的 **New issue**。

  

![](https://pic3.zhimg.com/v2-1585d6eef7521a15004dd70f977af7d8_1440w.png)

  

在打开的新页面中，可以看两个文本框，一个是用来**添加博客文章标题的 Title 区域**，一个**用来输入或粘贴内容的编辑区**，Issues 这种设计也很符合我们平时写文章的习惯。

  

编辑好之后，点击右下角的 **Submit new issue**，就完成了文章的发布。

  

![](https://picx.zhimg.com/v2-2447b36485d6ab6353640affc59dca45_1440w.png)

  

对于已发布的文章，如果想在发布后进行修改，可以点击右侧的 … 按钮，选择 **Edit** 切换到编辑模式，**编辑没有次数和字符数的限制**，不像已经诞生 9 年的公众号，每篇文章最多只能修改 20 个字。

  

![](https://pic3.zhimg.com/v2-6120ce96c4d2a73c0eb18981122c0854_1440w.png)

  

由于项目的作者用到了 GitHub 的另外一个功能——**[GitHub Actions](https://zhida.zhihu.com/search?content_id=177232994&content_type=Article&match_order=1&q=GitHub+Actions&zd_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ6aGlkYV9zZXJ2ZXIiLCJleHAiOjE3NjIzNDYxMzksInEiOiJHaXRIdWIgQWN0aW9ucyIsInpoaWRhX3NvdXJjZSI6ImVudGl0eSIsImNvbnRlbnRfaWQiOjE3NzIzMjk5NCwiY29udGVudF90eXBlIjoiQXJ0aWNsZSIsIm1hdGNoX29yZGVyIjoxLCJ6ZF90b2tlbiI6bnVsbH0.-LgRSJASAswTvzAmmZPFwd35imB_cgp46LN5JsjhpNY&zhida_source=entity)**，这是一个自动化操作，当我们创建或修改 Issues 中的文章时，它都会运行一次写好的程序，在仓库的首页生成或**更新 README 文件**。

  

这里就体现为，它会在下方的「**最近更新**」自动生成我们最近更新的文章列表，方便访问我们博客仓库的人第一时间看到。

  

![](https://pica.zhimg.com/v2-17a2223bff22e49edcacb631e2815256_1440w.png)

  

因为我这个是今天刚建的博客，看起来还不够壮观，这里放一下项目的原作者 @yihong 创建已久的博客，这或许才能真正让人感受到记录 的意义：

  

![](https://pica.zhimg.com/v2-91a7b153640312795eadbfa10ee4a560_1440w.png)


# 遇见的问题

## 1. 始终无法自动gen出来README
```
remote: Permission to sirekanian/sirekanian.github.io.git denied to github-actions[bot].
fatal: unable to access 'https://github.com/sirekanian/sirekanian.github.io/': The requested URL returned error: 403
Error: Process completed with exit code 128.
```
解决方法：
<https://stackoverflow.com/questions/73687176/permission-denied-to-github-actionsbot-the-requested-url-returned-error-403>
You have to configure your repository - `Settings -> Action -> General -> Workflow permissions` and choose `read and write permissions`