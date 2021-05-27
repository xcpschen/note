package pro

//  使用第三变量交换a,b值
func swap(a *int, b *int) {
	tem := *a
	*a = *b
	*b = tem
	return
}

//  使用第三变量交换a,b值:go 直接交换值
func swapTwo(a *int, b *int) {
	*a, *b = *b, *a
}

//  不使用第三变量交换a,b值：直接返回
func swapReturn(a int, b int) (int, int) {
	return b, a
}

//  不使用第三变量交换a,b值：数学运算
func swapThree(a *int, b *int) {
	*a = *a + *b
	*b = *a - *b
	*a = *a - *b
}

//  不使用第三变量交换a,b值：位异或运算
func swapFour(a *int, b *int) {
	*a = *a ^ *b
	*b = *a ^ *b
	*a = *a ^ *b
}
