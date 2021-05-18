# Encoding

编码类型对照表：
|Type|Meaning|Used For|
|----|-------|---------|
|0	|Varint	|int32, int64, uint32, uint64, sint32, sint64, bool, enum|
|1	|64-bit	|fixed64, sfixed64, double|
|2	|Length-delimited|	string, bytes, embedded messages, packed repeated fields|
|3	|Start group|	groups (deprecated)|
|4	|End group|	groups (deprecated)|
|5	|32-bit	|fixed32, sfixed32, float|

流消息中的每个键都是具有值的varint，`(field_number << 3) | wire_type`换句话说，数字的最后三位存储类型。

## Varint
类型为`0`,使用一个或多个字节序列化整数，除最后一个字节外，其他的一位都设置为1，称为msb ，表示后面还有的意思。
- 8位，高1位为msb，剩下为值
- 序列化后，是原来数字二进制反转得来
- 针对小数字

## 有符号整数编码-ZigZag
类型为`0`，通过映射方式，实现有符号整数无无符化
sint32编码方式：
```
(n<<1)^(n>>31)
```
sint64编码方式:
```
(n<<1)^(n>>64)
```

## non-Varint
类型为`1` or `5`
编码类型为1的，后面64位是其内容，例如fixed64, sfixed64, double；同理类型为5的，后面32位为他的内容。

## 字符串类型 
类型为 `2`
```
[(field_number << 3) | wire_type] [长度] [内容]
```

