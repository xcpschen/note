# beego orm paging
利用`orm.QueryBuilder` 接口快速实现分页，需要对`orm.QueryBuilder`改造，新增`GetTokens() []string` 方法，把所有的原始数据返回，每个实现都必须实现，然后在`PagingQueryBuilder` 里 替换生成`count(*)`sql 语句。