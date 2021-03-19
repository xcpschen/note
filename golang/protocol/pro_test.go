package protocol_test

import (
	"fmt"
	"regexp"
	"tanrge/protocol"
	"testing"
)

func TestPacket(t *testing.T) {
	words := "{\"Id\":1,\"Name\":\"golang\",\"Message\":\"message\"}"
	p := protocol.Packet([]byte(words))
	fmt.Println([]byte(protocol.ConstHeader))
	fmt.Println(protocol.IntToBytes(len([]byte(words))))
	fmt.Println([]byte(words))
	fmt.Println(p)
}

func TestParsePacket(t *testing.T) {

	PFiles := "(?P<files>((.)*))"
	// RegNum := `^(0|[1-9][0-9]*)$`
	Blank := `\s*`
	// PLimit := "(?P<limit>(limit " + RegNum + "|" + RegNum + Blank + "," + Blank + RegNum + "){0,1})"
	PFrom := "(?P<from>(" + Blank + "from(.)*))"
	PWhere := "(?P<where>(^where (.)*" + Blank + "){0,1})"
	POrder := "(?P<order>(order" + Blank + "by" + Blank + "(.)" + Blank + "(desc|ace)$){0,1})"
	repstr := "(?is:((?P<select>(select ))" + PFiles + PFrom + PWhere + POrder + "))"
	reg, err := regexp.Compile(repstr)
	if err != nil {
		t.Error(err.Error())
	}
	sqls := []string{
		"select a,f,d from table ",
		"select a,f,d from table where a=1 and b=3c",
		"select a,f,d from table where a=1 and b=3c order by f desc",
		"select a,f,d from table where a=1 and b=3c order by f desc limit 1",
		"select a,f,d from table where a=1 and b=3c order by f desc limit 1,100",
		"select a,f,d from table where a=1 and b=3c order by f desc group by a limit 1,100",
		"select a,f,d from table where a=1 and b=3c order by f desc group by a,b limit 1,100",
	}
	for _, sql := range sqls {
		fmt.Println(reg.ReplaceAllString(sql, "$select"))
	}
}

func TestMatchJson(t *testing.T) {
	r_int := `-?\d+`           //整数: 100, -23
	r_blank := `\s*`           //空白
	r_obj_l := "\\{" + r_blank // {

	r_obj_r := r_blank + "\\}"         // }
	r_arr_l := "\\[" + r_blank         // [
	r_arr_r := r_blank + "\\]"         // [
	r_comma := r_blank + "," + r_blank //逗号
	r_colon := r_blank + ":" + r_blank //冒号

	//基础数据类型
	r_str := `"(?:\\\\\\"|\\"|[^"])+"`                            //双引号字符串
	r_num := r_int + "(?:\\" + r_int + ")?(?:[eE]" + r_int + ")?" //数字(整数,小数,科学计数): 100,-23 12.12,-2.3 2e9,1.2E-8
	r_bool := "(?:true|false)"                                    //bool值
	r_null := "null"                                              //null

	//衍生类型
	r_key := r_str                                                                     //json中的key
	r_val := "(?:(?P>json)|" + r_str + "|" + r_num + "|" + r_bool + "|" + r_null + ")" //json中val: 可能为 json对象,字符串,num, bool,null
	r_kv := r_key + r_colon + r_val                                                    //json中的一个kv结构

	r_arr := r_arr_l + r_val + "(?:" + r_comma + r_val + ")*" + r_arr_r //数组: 由val列表组成
	r_obj := r_obj_l + r_kv + "(?:" + r_comma + r_kv + ")*" + r_obj_r   //对象: 有kv结构组成

	reg := "(?:s)(?P<json>(?:" + r_obj + "|" + r_arr + "))" //数组或对象
	words := "{\"Id\":1,\"Name\":\"golang\",\"Message\n\":\"message\"}\n{\"Id\":1,\"Name\":\"golang\",\"Message\":\"message\"}\n"
	rg := regexp.MustCompile(reg)
	a := rg.FindAllString(words, -1)
	fmt.Printf("%q,%d\n", a, len(a))
}
