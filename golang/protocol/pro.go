package protocol

import (
	"bytes"
	"encoding/binary"
)

const (
	// ConstHeader 消息头部标示数据
	ConstHeader = "www.01happy.com"
	// ConstHeaderLength 消息头部长度
	ConstHeaderLength = 15
	// ConstSaveDataLength 消息的最大长度 1<<32 4294967296
	ConstSaveDataLength = 4
)

//Packet 封包
func Packet(message []byte) []byte {
	return append(append([]byte(ConstHeader), IntToBytes(len(message))...), message...)
}

//Unpack 解包
func Unpack(buffer []byte, readerChannel chan []byte) []byte {
	length := len(buffer)

	var i int
	for i = 0; i < length; i = i + 1 {
		//消息长度小于头部信息，则丢弃
		if length < i+ConstHeaderLength+ConstSaveDataLength {
			break
		}
		if string(buffer[i:i+ConstHeaderLength]) == ConstHeader {
			// 获取消息长度
			messageLength := BytesToInt(buffer[i+ConstHeaderLength : i+ConstHeaderLength+ConstSaveDataLength])
			// 当前消息长度小于完整消息长度
			if length < i+ConstHeaderLength+ConstSaveDataLength+messageLength {
				break
			}
			// 获取完整消息长度
			data := buffer[i+ConstHeaderLength+ConstSaveDataLength : i+ConstHeaderLength+ConstSaveDataLength+messageLength]
			readerChannel <- data
			// 下一条消息开始地方
			i += ConstHeaderLength + ConstSaveDataLength + messageLength - 1
		}
	}

	if i == length {
		return make([]byte, 0)
	}
	//缓冲返回buffer
	return buffer[i:]
}

//IntToBytes 整形转换成大端字节
func IntToBytes(n int) []byte {
	x := int32(n)

	bytesBuffer := bytes.NewBuffer([]byte{})
	binary.Write(bytesBuffer, binary.BigEndian, x)
	return bytesBuffer.Bytes()
}

//BytesToInt 网络大端字节转换成整形
func BytesToInt(b []byte) int {
	bytesBuffer := bytes.NewBuffer(b)

	var x int32
	binary.Read(bytesBuffer, binary.BigEndian, &x)

	return int(x)
}
