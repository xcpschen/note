# 接口
interface{} 分两种，里面为定义子类信息为非空接口，一般用来实现多态，未定子类信息的则是空接口
## 空接口
空接口，底层结构体：
```
type eface struct {
    _type *_type
    data  unsafe.Pointer
}
```
## 非空接口
底层结构体实现：
```
// 非空接口
type iface struct {
    tab  *itab
    data unsafe.Pointer
}
// 非空接口的类型信息
type itab struct {
    inter  *interfacetype        // 接口定义的类型信息
    _type  *_type                // 接口实际指向值的类型信息
    link   *itab  
    // 来自_type.hash
    hash   uint32
    bad    int32
    inhash int32
    unused [2]byte
    fun    [1]uintptr             // 接口方法实现列表，即函数地址列表，按字典序排序，按指针偏移可得到下一个实现函数
}

// runtime/type.go
// 非空接口类型，接口定义，包路径等。真正类型定义存储结构体
type interfacetype struct {
   typ     _type
   pkgpath name
   mhdr    []imethod      // 接口方法声明列表，按字典序排序
}

// 接口的方法声明 
type imethod struct {
   name nameOff          // 方法名
   ityp typeOff                // 描述方法参数返回值等细节
}
```
![](../assets/golang/iface.png)

### 编译器如何检测类型是否实现接口
这其实是一个接口转换的原理，在iface源码中，类型 interfacetype 和 实体类型的类型 _type，这两者都是 iface 的字段 itab 的成员。也就是说生成一个 itab 同时需要接口的类型和实体的类型。Go语言中维护一个全局的itab的哈希表，其hash_key= itabhash(*interfacetype, _type),检测流程：
1. 调用getitab，*interfacetype, _type作为参数，生成hash_key
2. 上锁，在全局的itab的哈希表查找itab
3. 有则直接返回对应的itab
4. 没有则生成一个新的itab,调用additab添加到全局itab哈希表
   1. 检查itab持有的`interfacetype` 和` _type `是否符合,_type是否实现了interfacetype的方法

### 值&指针接口接收者接口使用
值类型接收者 定义函数时，使用的是值，类似传值一样，只是拷贝的副本，其实现接口时必须都是值类型
指针接收者 定义函数时，使用的是值指针，指向引用的值，，其实现接口时必须都是指针类型
### 与其他语言借口区别
接口定义了一种规范，描述了类的行为和功能，而不做具体实现。

- C++接口，是入侵式，Go 采用的是 “非侵入式”，不需要显式声明，只需要实现接口定义的函数，编译器自动会识别
- 底层实现不同，C++ 通过虚函数表来实现基类调用派生类的函数；而 Go 通过 itab 中的 fun 字段来实现接口变量调用实体类型的函数，
- 虚函数表在编译期间生成，Go的itab中的fun字段在运行期间动态生成，Go可以实现多个接口的函数，C++不行
