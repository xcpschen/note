package pro_test

import (
	"fmt"
	"math/rand"
	"sort"
	"testing"
)

func TestMapSort(t *testing.T) {
	mapsSort := pro.MapsSort{}
	mapsSort.Key = "data"
	maps := make([]map[string]interface{}, 0)
	for i := 0; i < 10; i++ {
		data := rand.Float64()
		mapTemp := make(map[string]interface{})
		mapTemp["data"] = data
		mapTemp["aaa"] = fmt.Sprintf("aaa%d", i)
		maps = append(maps, mapTemp)
	}

	mapTemp := make(map[string]interface{})
	mapTemp["data"] = "1.001"
	mapTemp["aaa"] = fmt.Sprintf("aaa")
	maps = append(maps, mapTemp)
	fmt.Println(maps)
	mapsSort.MapList = maps
	fmt.Println(mapsSort)
	sort.Sort(&mapsSort)
	fmt.Println(mapsSort)
}
