package pro

import (
	"fmt"
	"strconv"
)

type MapsSort struct {
	Key     string
	MapList []map[string]interface{}
}

func (m *MapsSort) Len() int {
	return len(m.MapList)
}

func (m *MapsSort) Less(i, j int) bool {
	var ivalue float64
	var jvalue float64
	var err error
	switch m.MapList[i][m.Key].(type) {
	case string:
		ivalue, err = strconv.ParseFloat(m.MapList[i][m.Key].(string), 64)
		if err != nil {
			fmt.Printf("map数组排序string转float失败：%v\n", err)
			return true
		}
	case int:
		ivalue = float64(m.MapList[i][m.Key].(int))
	case float64:
		ivalue = m.MapList[i][m.Key].(float64)
	case int64:
		ivalue = float64(m.MapList[i][m.Key].(int64))
	}

	switch m.MapList[j][m.Key].(type) {
	case string:
		jvalue, err = strconv.ParseFloat(m.MapList[j][m.Key].(string), 64)
		if err != nil {
			fmt.Printf("map数组排序string转float失败：%v\n", err)
			return true
		}
	case int:
		jvalue = float64(m.MapList[j][m.Key].(int))
	case float64:
		jvalue = m.MapList[j][m.Key].(float64)
	case int64:
		jvalue = float64(m.MapList[j][m.Key].(int64))
	}
	return ivalue > jvalue
}

func (m *MapsSort) Swap(i, j int) {
	m.MapList[i], m.MapList[j] = m.MapList[j], m.MapList[i]
}
