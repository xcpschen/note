# beego task 
beego 自带定时任务拓展，原先每新加入一个任务，都需要手动：
```
tk1 := task.NewTask("tk1", "0 12 * * * *", func(ctx context.Context) error { fmt.Println("tk1"); return nil })

task.AddTask("tk1", tk1)
```

每次都需要重复编写，不方便，且不够优雅。[task.go](./task.go)封装了task的添加功能,这样新的task只需要实现`ITask` 接口，然后在文件中把task 注册到`Register`就可以了