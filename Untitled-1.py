# coding=utf-8
#中文文档声明注释 必须第一行
'''
 a=100
 b=20
 print(a-b)
'''
'''
num=input('幸运数字')
int(num)
print('幸运数字是'+num)
'''

'''
luck_number=7
print('幸运数字是',luck_number)
luck_number='数字'
print('幸运数字是'+luck_number)
'''
# 允许多个变量指向同一个值  ————>地址相同，两个变量指向同一个地址
# 动语变量，变量的格式动态变化


'''
num=987             #默认十进制
num1=0b110101       #二进制
num2=0o137          #八进制
num3=0x987          #十六进制  
num4=13.4           #浮点
round(0.1+0.2,2)  #num+mun数据相加,保留几位数据
x=123+23j           #复数
print('实数部分',x.real)
print('虚数部分',x.imagx)
'''

'''
str1='字符串'
str12="字符串"       # ' ' 和 " " 同效果
str123="""字符串"""  #多行字符串
'''

# 字符串的索引和切片
# 顺数从0开始，倒数从-1开始
# 切片时[N:M] 从下标N到M-1的字符显示

'''
int(x)      #x转换为整数
float(x)    #x转换为浮点数
str(x)      #x转换为字符串
chr(x)      #整数x转换为字符
ord(x)      #x转换为整数值
hex(x)      #x转换为十六进制字符串
oct(x)      #x转换为八进制字符串
bin(x)      #x转换为二进制字符串
'''

# eval() #用于去掉字符串最外面的引号，并执行命令
# eval经常与input()函数使用，用来获取用户输入的数值
# age=eval(input('输入你的年龄：'))  #将字符串转换为int型并保存用来进行运算

# x**=y   x=x**y 幂赋值
# x//=y   x=x//y 整除赋值

'''
if n%2:
    a=1

if not n%2:
    a=0
'''

''' 
# 判断字符串是否为空字符串
x=input('请输入一个字符串：')
if x : #在python中一切皆对象,而非空字符串的值为真
    a=1
if not x :
    a=0
'''

'''
#for历遍元素
#range(),产生数列100-999不包含1000
for i in range(100,1000):
    sd=i%10 #取个位的数字 153%10=3
    tens=i//10%10 #取十位的数字 153//10=15%10=5 
    hunder=i//100 #取百位的数字 153//100=1
    print(i)
'''

'''
#for...else...循环正常执行完毕后执行else
#range(),产生数列100-999不包含1000
for i in range(100,1000):
    sd=i%10 #取个位的数字 153%10=3
    tens=i//10%10 #取十位的数字 153//10=15%10=5 
    hunder=i//100 #取百位的数字 153//100=1
else:
    print(i)
'''

'''
i=0
s=0
while i<=100 :  #while循环

    s+=i
    i+=1
else:
    print(i,s)
'''

'''
# (1)初始化变量
i=0
while i<3 :  #(2)条件判断
    #(3)语句块
    User_name=input('输入你的用户名:')
    pwd=input('输入你的密码:')
    #登陆操作
    if User_name=='111111' and pwd==888888 :
        print(成功)
        i=8 #退出登录界面
    else:
        if i<2:
            print('用户名不正确,你还有',2-i,'次机会')
            i+=1
if i==3 :
    print('登陆失败')
'''

'''
i=0
while i<3 :  #(2)条件判断
    #(3)语句块
    User_name=input('输入你的用户名:')
    pwd=input('输入你的密码:')
    #登陆操作
    if User_name=='111111' and pwd==888888 :
        print(成功)
        break           #break跳出循环
    else: 
        if i<2:
            print('用户名不正确,你还有',2-i,'次机会')
            i+=1
else :                  #若无跳出或其他,当程序正常结束时会执行else
    print('登陆失败')  
'''

'''
#continue         #跳出本次循环
i=0
while i<3 :  #(2)条件判断
    #(3)语句块
    User_name=input('输入你的用户名:')
    pwd=input('输入你的密码:')
    #登陆操作
    if User_name=='111111' and pwd==888888 :
        print(成功)
        continue         #跳出本次循环
    else: 
        if i<2:
            print('用户名不正确,你还有',2-i,'次机会')
            i+=1
else :                  #若无跳出或其他,当程序正常结束时会执行else
    print('登陆失败')  
'''

''''
for i in range(100,1000) :
    pass        #pass空语句
''' 

# 切片操作    序列[start:end:step] 
# start开始索引(包含)    end结束索引(不包含)    step步长(不写时默认为1)]
'''
x in s      #如果x是s的元素结果为true否则结果为files
x ont in s  #如果x不是s的元素结果为true否则结果为files
len(s)      #序列S中元素的个数
max(s)      #序列S中元素的最大值
min(s)      #序列S中元素的最小值
s.index(x)  #序列S中第一次出现元素x的位置
s.count(x)  #序列S中x元素出现的个数
'''

'''
#列表创建,列表是可变序列,元素可以是任意类型
#列表名=[x,s,a,c,v,r] 
#列表名=list(序列)
#del 列表名  #列表的删除

#enumerate函数 --->枚举
#for index,item in enumerate(lst):  -->输出index和item
#index序号  item元素
#列表是序列的一种，对序列的操作符运算符函数都可以对列表来使用
#print(lst+lst1+lst2)
#print(lst*3)
'''
'''
lst=['sts','sts1','word','sie']
#for循环遍历列表元素
for i in lst:
    print(i)
'''
'''
lst=['sts','sts1','word','sie']
#for循环,range()函数,len()根据索引遍历列表元素
for i in range(0,len(lst)):
    print(i,lst[i])
'''
'''
lst=['sts','sts1','word','sie']
#for循环,enumerate()函数
for index,item in enumerate(lst):
    print(index,item)  #index是序号,不是索引
'''

'''
lst=['sts','sts1','word','sie']
# for循环,enumerate()函数,手动修改序号起始值
for index,item in enumerate(lst,start=1):
# for index,item in enumerate(lst,1):  #同上省略start也可以
    print(index,item)  
'''
'''
# 列表生成方法
#lst=[item for item in range(1,11)]
#lst=[random.randin(a:1,b:100) for _ in range(10)] #随机生成十个数
#lst=[i for i in range(10) if i%2==0]  #偶数作为元素
'''

'''
# 二维列表的产生
lst=[
    [],
    [],
    [],
    []
]
# 列表生产4行5列的二维列表
lst=[ [j for j in range(5)]  for i in range(4)  ]

'''

# 二维列表的遍历
'''
for row in 二维列表:
    for item in row :
        pass
'''

# 元组
# 元组是 不可变序列 ,无增删改操作 只可以索引和遍历 
# 序列的一种序列函数也可以用
# 元组使用()或tuple()函数来定义,只有一个元素也不能省略,
# del删除
# 可作为字典的键,列表不可用作为字典的键
 
# 字典 #可变元素不能作为 '键' 
#  无整数索引
# 字典的'键 key'相同时'值 value'会被覆盖
# zip()函数映射结果为zip对象,通过list转换为列表(元组类型)才能print
# zip对象通过dict()函数才能转换为字典类型 
'''
#第一种,直接创建
d={key1:value,key2:value,key3:value....}
#第二种,映射创建
zip(lst1,lst2) #lst1作为键,lst2作为值
#语法结构
dict(key1=value,key2=value....)
#元组可以做为键
t=(1,2,3)
d={t:10}  #print={(1,2,3):10}
'''
# 字典元素取值 d[key]或d.get(key)
# 字典遍历 
#------------------------
# 遍历出key与value
#for element in d.items()
#   pass
#------------------------
# 分别遍历key与value
#  for key.Value in d.items()
#   pass
#------------------------

# 字典函数
# d.keys()           # 获取所有key数据
# d.values()         # 获取所有value数据
# d.pop(key,default) # key存在获取相应的value,同时删除key-value对,否则获取默认值
# d.popirem()        # 随机取出key-value对,结果为元组型,同时在字典删除该'对'
# d.clear()          # 清空所有key-value对

# 字典生产式
# d={ key:value for item in range }
# d={ key:value for key,value in zip(lst1,lst2) } 


# 集合类型 --->只能存储不可变数据类型 --->无序
# 集合是一个无序的不重复元素序列
# 集合是序列的一种,对于序列的方法集合都可以使用 
# 与列表字典一样都是可变数据类型
# s={1,2,3,4}
# s=set(s) #----->使用set()创建集合,否则s默认为字典
# set()可以对列表使用 
# 集合与数学概念基本相同, 交集(&)并集(|)差集(-)补集(^)
# 增删改 :
# s.add()       # 如果无,则添加
# s.remove()    # 如果有,则删除,如果集合无则报错
# s.clear()     # 清除集合中所有元素

# python3.11新特性
# 1).模式匹配------>结构模式匹配
'''
match data :
    case{} :
        pass
    case[] :
        pass
    case() :
        pass
    case _ :
        pass
'''
# 2).字典合并运算符|
# 3).同步迭代
'''
match data1 data2 :
    case data1,data2 :
        pass
'''

# 异常处理
# try...except
'''
try :
    # 可能会出现异常的代码
except 异常类型 :
    异常处理代码(报错后执行的代码)    
'''
# try...except...except
'''
try :
    # 可能会出现异常的代码
except 异常类型A :
    异常处理代码(报错后执行的代码)
except 异常类型B :
    异常处理代码(报错后执行的代码)
'''
# try...except...else
'''
try :
    # 可能会出现异常的代码
except 异常类型 :
    异常处理代码(报错后执行的代码)
else :
    没有异常要执行的代码
'''
# try...except...else...finally
'''
try :
    # 可能会出现异常的代码
except 异常类型 :
    异常处理代码(报错后执行的代码)
else :
    没有异常要执行的代码
finally :
    无论是否异常都要执行的代码
'''

# raise #抛出一个异常从而提醒程序出现异常情况
# raise [[Exception类型(异常描述信息)]] 
'''
try :
    gender=input('请输入您的性别:')# 可能会出现异常的代码
    if gender!='男' and gender!='女' :
        rise Exception('性别只能是男或女')
except Exception as e :
    print(e)
'''

# 异常类型
# ZeroDivisionError     #当除数为0时引发异常
# lndexError            #所以超出范围所引发的异常
# KeyError              #字典取值K不存在的异常
# NameError             #使用一个没有声明的变量时引发的异常
# SyntaxError           #Python中语法错误
# ValueError            #传入的值错误

# 自定义函数
'''
def 函数名称 (参数列表) :
    函数体
    [return返回值列表]
'''
# 函数调用
'''
    函数名 (参数列表) 
'''

# 函数的参数传递 
# 位置参数      ---> 只调用参数使个数与顺序必须与定义时相同
# 关键字参数    ---> 在调用时使用 '形参名称=值'  的方式传参
# 默认值参数    ---> 在定义时使用形式参数进行赋值
# 例: def 函数名称 (参数=值)  #默认值参数
#位置传参参数在前,关键字传参在后

# 可变参数
''' # 可变参数
个数可变的位置参数和个数可变的关键字参数两种,
其中个数可变的位置参数是在参数前加一颗星 (*para) ,
para 形式参数的名称，函数调用时可接收任意个数的实
际参数，并放到一个元组中.个数可变的关键字参数是在
参数前加两颗星（** para),在函数调用时可接收任意多
个"参数=值"形式的参数，并放到一个字典中.

# 例: def 函数名称 (*para)   --->个数可变的位置传参
# 列表的解包传递,列表加'一颗星*' # 例: 函数名称 (*[11,22,33]])  
  传参时若不解包会将列表作为一个元素存入元组
# 例: def 函数名称 (**para)  --->个数可变的关键字传参
# 列表的解包传递,字典加'两颗星**' # 例: 函数名称 (**[11,22,33]])  
'''

# 一个变量存储函数reture多个数据时以元组形式存储
# 多个变量存储函数reture多个数据时则一一对应存储

# 全局变量和局部变量名称一致时,局部变量优先级高
# 全局变量修饰词 'global'  

# lambda--->匿名函数 只能使用一次
# 结构  ---> result=lambda 参数列表: 表达式 
# 例: s=lambda a,b: a+b  ---->s为匿名函数,参数a,b,reture a+b
'''
for i in range(len(lst)) :      #lst为列表
    resule = lambda x : x[i]    #x为形参
    print( resule(lst) )        #lst为实参
'''
'''
# 排序
student_scores=[
    {'name':'我常常','score':98},
    {'name':'dcj','score':95},
    {'name':'cab','score':90},
    {'name':'bac','score':100}
    ]
 # student_scores列表类型数据,列表内元素为字典
# 对列表进行排序,排序的规则是成绩的高低
student_scores.sort(key=lambda x:x.get('score'),reverse=True)  #降序
print(student_scores)
'''
#------数据类型转换函数----------
# bool(obj)       ---->获取指定对象obj的布尔值
# str(obj)        ---->将指定对象obj转成字符串类型
# int(x)          ---->将x转成int类型
# float(x)        ---->将x转成float类型
# list(sequence)  ---->将序列转成列表类型
# tuple(sequence) ---->将序列转成元组类型
# set(sequence)   ---->将序列转成集合类型

#------常用的数学函数-----------
# abs(x)        ----->获取×的绝对值
# divmod(x,y)   ----->获取 x 与 y 的商和余数
# max(sequence) ----->获取 sequence 的最大值
# min(sequence) ----->获取 sequence 的最小值
# sum(iter)     ----->对可迭代对象进行求和运算
# pow(X,Y)      ----->获取×的 y 次幂
# round(x,d)    ----->对×进行保留 d 位小数，结果四舍五入

#------常用的迭代器操作函数-----------
# sorted(iter)     ----->对可迭代对象进行排序
# reversed(sequence) ----->反转序列生成新的迭代器对象
# zip(iter1,iter2)   ----->将 iter1 与 iter2 打包成元组并返回一个可迭代的 zip 对象
# enumerate(iter) ----->根据 iter 对象创建一个 enumerate 对象
# all(iter)  ----->判断可迭代象 iter 中所有元素的布尔值是否都为 True
# any(iter) ----->判断可迭代对象 iter 中所有元素的布尔值是否都为 False
# next(iter)  ----->获取迭代器的下一个元素
# filter(function,iter)   ----->通过指定条件过滤序列并返回一个迭代器对象
# map(function,iter)  ----->通过函数 function 对可迭代对象 iter 的操作返回一个迭代器对象

#------常用的其他内置函数-----------
# format(value,format_spec)  ----->将 value 以 format_spec格式进行显示
# len(s)   ----->获取 s 的长度或 s 元素的个数
# id(obJ)  ----->获取对象的内存地址
# type(x)  ----->获取×的数据类型
# eval(s)  ----->执s这个字符串所表示的Python代码

# #  —————————————————————类————————————————————
# 类是模板
# 类属性      ------>直接定义在类中,方法外的'变量'
# 实例属性    ------>直接定义在_init_方法中,使用self打点的'变量'
# 实例方法    ------>定义在类中的函数,而且自带参数self
# 静态方法    ------>使用装饰器 @staticmethod 修饰的方法
# 类方法      ------>使用装饰器 @classmethod 修饰的方法

# 类方法,类属性,静态方法 都使用 '''类名调用'''
# 实例方法,实例属性,  跟实例有关的 都使用 ''' 对象名.XX 调用'''

# 类定义 class
'''
class xxx:
    # 类属性:定义在类中,方法外的变量
    school='csd'

    # 方法的初始化
    def __init__(self,xm,age): #xm,age是方法的参数,局部变量,作用域在__init__
        self.name=xm # '='左侧是实例属性, xm是局变量 ,将局部变量xm赋值给实例属性self.name
        self.age=age # 实例的名称和局部变量的名称可以相同

    # 定义在类中的函数,称为方法,自带一个参数self
    # 方法体
    def show(self):
        print(f'我是:{self.name},今年:{self.age}')  
        #--->print(f 等价于print('a={}, b={}, c={}'.format(a, b, c))

    # 静态方法 --->也是方法
    #不能调用实例属性,也不能调用实例方法
    @staticmethod
    def sm():
        print('静态方法')

    # 类方法
    #不能调用实例属性,也不能调用实例方法
    @classmethod
    def cm(cls):  # cls -----> clsass 缩写
        print('类方法')

# 创建类对象
stu=xxx('ssss',18) #__init__方法有两个形参,self为自带参数无需输入
# ' 实例属性 ',使用 ' 对象名. '调用
print(stu.name,stu.age)
# ' 类属性 ',使用 '类名. '调用
print(xxx.school)
# ' 实例方法 ',使用' 对象名. '调用
stu.show()
# ' 静态方法 ',@staticmethod进行修饰的方法,直接使用 '类名. '调用
xxx.cm()
# ' 类方法 ',@classmethod进行修饰的方法,使用 '类名. '调用
xxx.sm()

'''

# -----------动态绑定属性-----------------
# 格式: 类对象.新实例属性= '值'   #直接对类对象赋 '值'
# 调用: 类对象.新实例属性

# -----------动态绑定方法-----------------
# 格式: 类对象.新实例方法= '方法(函数)'   #直接对类对象赋 '方法(函数)'
# 调用: 类对象.新实例方法
'''
例: def introduce(): #定义一个函数
    print('动态绑定方法')
stu.fun=introduce  #函数的赋值,fun和introduce函数不能加(),加了就成函数调用
# fun 就是 stu 对象的方法
# 调用
stu.fun()
'''

# 面向对象的三大特征
# 1.封装 ------->隐藏内部细节,提供对外操作方式 
# 2.继承 ------->函数调用时使用 '形参名称=值'传参 
# 3.多态 ------->定义直接对形参赋值,调用时参数不传值则使用定义的赋值来当作默认值 

'''
1.封装
单下划线开头:受保护成员,'仅内部使用,允许类本身和子类进行访问' 但实际可以被外部代码访问
双下划线开头:表示private私有成员,这一类成员只允许定义该属性或方法的类本身进行访问
首尾双下划线:一般表示特殊方法
'''
# 私有实例属性和方法访问方法 --->不推荐
# 访问格式:对象名._类名__方法
# 调用格式:对象名._类名__方法()
'''
printf(stu._Student__age)
stu._Student__fun2()

print(dir(stu)) #展示stu所有属性和方法
'''

# 装饰器 @property 访问私有实例属性和方法
# 将方法转换为属性使用---->只能看不能修改
# 修改方法需要设置 settre

'''
class xxx:
    # 方法的初始化
    def __init__(self,xm,age): 
        self.name=xm 
        self.__age=age # 私有

    # 使用@property ,将方法转成属性访问
    # 一般习惯函数名与变量名一致
    @property    #关键字 --->只能访问不能修改
    def age(self):
        return self.__age

    # 修改为可写属性
    @age.settre   # '属性名称.settre'
    def age(self,value)
        self.__age=value
'''

# --------------继承-----------------------
# 继承 ----->一个子类可以继承多个父类一个父类也可以拥有多个子类
# 如果没有继承任何类,那么默认继承object类
# super().XXX调用父类的方法
'''
 语法结构:
class 类名 (父类1,父类2,.....父类N) :
    pass 
'''
'''
class xxx:
    # 方法的初始化
    def __init__(self,name,age): 
        self.name=name 
        self.__age=age # 私有
    # 方法体
    def show(self):
        print(f'我是:{self.name},今年:{self.age}')  
        #--->print(f 等价于print('a={}, b={}, c={}'.format(a, b, c))

class sss(xxx):
    # 方法的初始化
    def __init__(self,name,age,stuno): 
        super().__init__(name,age)     #调用父类初始化方法
        self.stuno=stuno                #自有参数赋值

class ppp(xxx):
    # 方法的初始化
    def __init__(self,name,age,ardas): 
        super().__init__(name,age)     #调用父类初始化方法
        self.ardas=ardas                #自有参数赋值
'''
'''
class ppp(FatherA,FatherB,FatherC....):
    # 方法的初始化
    def __init__(self,name,age,ardas): 
        FatherA.__init__(name)     #调用父类初始化方法
        FatherB.__init__(age)     #调用父类初始化方法
        FatherC.__init__(ardas)     #调用父类初始化方法
        #不能使用super()函数
        #继承父类ABC的 方法体(函数)
'''
# --------------方法重写----------------------
# 在子类中更改父类的方法
# 方法重写时候一定注意名称要保持一致
'''
class xxx(FatherA):
    # 方法的初始化
    def __init__(self,name,age,ardas): 
        super().__init__(name,age)     #调用父类初始化方法
        self.ardas=ardas # 私有
    # 方法体
    def show(self):
        super().show()     #调用父类中的方法 
        # 可以不掉用父类的方法直接重写
        print(f'我是XXX大学,今年:{self.ardas}')  
        #--->print(f 等价于print('a={}, b={}, c={}'.format(a, b, c))
'''

#    没有实例属性可以不写初始化方法

#  --------------------多态-----------------------
'''
多态指的是'多种形态'
即不知道一个变量所引用的对象到底是什么类型仍可以通过这个变量调用对象的方法.
在程序运行过程中根据变量所引用的对象数据类型 '动态决定' 调用哪个对象方法
'''
# ---------不关心数据类型,只关心对象是否有同名方法-------
'''
class Person():
    # 方法的初始化
    def eat(self): 
        print('人吃五谷杂粮')     #调用父类初始化方法

class cat():
    # 方法的初始化
    def eat(self): 
        print('猫吃鱼')     #调用父类初始化方法

class dog():
    # 方法的初始化
    def eat(self): 
        print('狗吃骨头')     #调用父类初始化方法

# 这三个类中都有同名方法 eat
# 编写函数
def fun(obj): # obj形参
    obj.eat() # 通过变量obj(对象)调用erat方法

# 创建三个对象
per=Person()
cat=cat()
dog=dog()

# 调用fun()函数
fun(per)  #python中的多态,不关心数据类型,只关心对象是否有同名方法
fun(cat)
fun(dog)
'''

# -------------object类--------------
# __new__()  # 由系统调用,用于创建对象
# __init__() # 创建对象时手动调,用于初始化对象属性值
# __str__()  # 对象的描述,返回值是str类型,默认输出对象内存地址
# __str__() 可以重写,以用来描述对象
'''
# 修改方法
class Person():
    # 方法的初始化
    def __init__(self,xm,age): 
        self.name=xm 
        self.age=age 

    # 方法重写    __str__()以用来描述对象
    def __str__(self):
        return '__str__修改方法'

# 创建Person类对象
per=Person(111,222)
print(per)  # 自动调用 __str__()方法
# 默认输出 per 内存地址 ,此例中已修改显示   输出='__str__修改方法'

'''

# -----------特殊属性------------
# obj.__dict__         对象的属性字典
# obj.__class__        对象所属的类
# cals.__bases__       类的父类元组
# cals.__base__        类的父类
# cals.__mor__         类的层次结构
# cals.__subclasses__  类的子类列表
# --=----------------------------


# 变量赋值 ---> 形成两个变量,实际上指向同一个对象
# 浅拷贝  ---->拷贝时对象的子对象内容不拷贝,源对象与拷贝对象引用同一个子对象
# 深拷贝  ---->使用copy模块的deepcopy函数,递归拷贝对象中包含的子对象

# 函数split使用方法 ----> 对象.split(条件)  = 输出以条件分割的'字符串数组' 






































