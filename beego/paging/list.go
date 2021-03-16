package paging

import (
	"github.com/beego/beego/v2/client/orm"
)

// List paging result struct
type List struct {
	Rows  interface{} `json:"rows"`
	Page  int64       `json:"page"`
	Total int64       `json:"total"`
	Limit int64       `json:"limit"`
}

// Paging get paging data
// @param obj interface{} Rows struct
// @param qb PagingQueryBuilder sql query builder
// @param (args ...interface)
func (l *List) Paging(obj interface{}, qb *PagingQueryBuilder, args ...interface{}) error {
	o := orm.NewOrm()
	if err := o.Raw(qb.GetCountSQL(), args...).QueryRow(l); err != nil {
		if err == orm.ErrNoRows {
			return nil
		}
		return err
	}
	if l.Page == 0 {
		l.Page = 1
	}
	if l.Limit == 0 {
		l.Limit = 20
	}
	if l.Page == 1 {
		qb.QueryBuilder.Limit(int(l.Limit)).Offset(0)
	} else {
		qb.QueryBuilder.Limit(int(l.Limit)).Offset(int((l.Page - 1) * l.Limit))
	}
	if err := o.Raw(qb.GetSQL(), args...).QueryRow(obj); err != nil {
		if err == orm.ErrNoRows {
			return nil
		}
		return err
	}
	l.Rows = obj
	return nil
}
