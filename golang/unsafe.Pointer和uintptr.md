## unsafe.Pointer
定义在**go安装目录/unsafe/unsafe.go**
```
type ArbitraryType int
type Pointer *ArbitraryType
func Sizeof(x ArbitraryType) uintptr
func Offsetof(x ArbitraryType) uintptr
func Alignof(x ArbitraryType) uintptr
```
- 类似C语言的Void*
- 没有兼容性的保证
- 必须要有有效指针引用着，否则被回收
## uintptr
## 两者直接的关联
## 经典使用场景