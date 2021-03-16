package paging

import (
	"strings"

	"github.com/astaxie/beego/orm"
)

// PagingQueryBuilder to generate sql for paging
type PagingQueryBuilder struct {
	QueryBuilder orm.QueryBuilder
}

// NewPagingQueryBuilder new PagingQueryBuilder
func NewPagingQueryBuilder(qb orm.QueryBuilder) *PagingQueryBuilder {
	return &PagingQueryBuilder{QueryBuilder: qb}
}

// GetCountSQL return a sql for count query table
func (qb *PagingQueryBuilder) GetCountSQL() string {
	tokens := qb.QueryBuilder.GetTokens()
	if len(tokens) == 0 {
		return ""
	}
	for i, val := range tokens {
		if val == "FROM" {
			tokens = tokens[i:]
			break
		}
	}
	newTokens := []string{}
	newTokens = append(newTokens, "SELECT", "COUNT(*) AS total")
	isU := true
	for _, val := range tokens {
		if val == "ORDER BY" || val == "LIMIT" || val == "OFFSET" || val == "ASC" || val == "DESC" {
			isU = false
			continue
		}
		if isU {
			newTokens = append(newTokens, val)
		} else {
			// 下一个为上面关键字后面的数据，重新设置isU为true
			isU = true
		}

	}
	return strings.Join(newTokens, " ")
}

// GetSQL return a sql for paging
func (qb *PagingQueryBuilder) GetSQL() string {
	return qb.QueryBuilder.String()
}
