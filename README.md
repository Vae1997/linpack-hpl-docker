# linpack-hpl
[x86_64](https://github.com/Vae1997/x8664-linpack-hpl/tree/master/x86_64):适用于x86架构下HPL环境的Dockerfile

[default_HPL.dat](https://github.com/Vae1997/linpack-hpl-docker/blob/master/default_HPL.dat)：环境搭建完成后，默认的测试参数

[aarch64](https://github.com/Vae1997/linpack-hpl-docker/tree/master/aarch64):适用于aarch64架构下HPL环境的Dockerfile

[test.sh](https://github.com/Vae1997/linpack-hpl-docker/blob/master/test.sh)：对于Linpack测试结果的简单二次处理，需进一步修改:muscle:

:speech_balloon:当测试参数Ns或NBs超过8个后，原始的输出结果会出现换行，有效数据起始行将发生改变

:speech_balloon:当测试参数随便输入后，测试结果可能出现0或异常情况
