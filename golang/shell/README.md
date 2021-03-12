# Golang 调用shell
[shell.go](./shell.go) 简单封装了shell指令的调用。简单例子使用,调用mysql客户端执行sql：
```
// ExecSQLScript 调用mysql 执行sql文件
type ExecSQLScript struct {
	Host      string
	Acc       string
	Pwd       string
	DbName    string
	SQLFile   string
	ErrorMsg  string
	IsSuccess bool
}

func (this *ExecSQLScript) GetComm() string {
	return "mysql"
}
func (this *ExecSQLScript) GetArgv() []string {
	return []string{"-h" + this.Host, "-u" + this.Acc, "-p" + this.Pwd, "-D" + this.DbName}
}
func (this *ExecSQLScript) GetStdin() (io.ReadCloser, error) {
	f, err := os.Open(this.SQLFile)
	if err != nil {
		return nil, err
	}
	return f, nil
}
func (this *ExecSQLScript) GetStdOut() (io.WriteCloser, error) {
	return nil, nil
}
func (this *ExecSQLScript) GetStdErr() (io.WriteCloser, error) {
	return nil, nil
}
func (this *ExecSQLScript) StderrByPipe(rc io.ReadCloser) {
	b, _ := ioutil.ReadAll(rc)
	this.ErrorMsg = string(b)
}
func (this *ExecSQLScript) GetErrorStr() string {
	str := "mysql: [Warning] Using a password on the command line interface can be insecure.\n"
	return strings.Replace(this.ErrorMsg, str, "", -1)
}

func ExecSQL(host, acc, pwd, dbName, sqlFile string) error {
	s := &ExecSQLScript{
		Host:    host,
		Acc:     acc,
		Pwd:     pwd,
		DbName:  dbName,
		SQLFile: sqlFile,
	}
	shell := NewShell(s)
	if err := shell.Run(); err != nil {
		return err
	}
	return nil
}

```