#### 软件分析测试 homework 2.0

**学号：MF1933128**  	**姓名：周慧聪**

***

##### 使用框架

**LLVM 6.0**

##### 环境

Ubuntun 18.40

***

##### 源代码

![源代码](https://github.com/abbycc/course/blob/master/SAT/%E6%BA%90%E4%BB%A3%E7%A0%81.png)

通过循环结构，判断分支和goto语句来实现程序的跳转。

***

##### LLVM的IR表示

![ir](https://github.com/abbycc/course/blob/master/SAT/ir.png)

上图为源代码通过LLVM的$ clang -S -emit-llvm for.cpp -o for.ll命令生成的.ll文件。

***

##### 无法转化为SSA的部分

![SSA](https://github.com/abbycc/course/blob/master/SAT/SSA.png)

图中由于判断分支和循环，所以红色框中，%2地址中的数值被写入了两次，黄色框中的%3地址被写入两次。根据SSA的定义，一个内存位置一旦赋值就不会发生改变。所以被store两次的内存地址不完全符合SSA。
