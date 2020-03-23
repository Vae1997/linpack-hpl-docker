# x8664-linpack-hpl
在x86下linpack-hpl测试环境的Dockerfile文件，dockerhub地址：https://hub.docker.com/r/vae2019/x8664-linpack-hpl
## dockerfile构建的参考
https://www.cnblogs.com/zhyantao/p/10614238.html
## 说明
如果需要修改测试参数，可以参考[这篇文章](https://github.com/levinit/itnotes/wiki/high-performance-linpack(hpl)-benchmark)

根据自己的硬件情况修改HPL.dat文件，然后复制到镜像home目录下完成修改。
