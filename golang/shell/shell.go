package gdb

import (
	"bufio"
	"bytes"
	"errors"
	"io"
	"log"
	"os/exec"
	"strings"
)

//IComm 执行shell命令接口
type IComm interface {
	GetComm() string
	GetArgv() []string
	GetStdin() (io.ReadCloser, error)
	GetStdOut() (io.WriteCloser, error)
	GetStdErr() (io.WriteCloser, error)
	StderrByPipe(io.ReadCloser)
}

type Shell struct {
	Comm IComm
}

func NewShell(c IComm) *Shell {
	return &Shell{Comm: c}
}

func (this *Shell) Run() error {
	comm := this.Comm.GetComm()
	argv := this.Comm.GetArgv()
	cmd := exec.Command(comm, argv...)
	log.Printf("【shell】%s %s", comm, strings.Join(argv, " "))
	rc, err := this.Comm.GetStdin()

	if err != nil {
		if err != nil {
			log.Printf("GetStdin Err%s", err.Error())
			return err
		}
	} else {
		if rc != nil {
			cmd.Stdin = rc
			defer rc.Close()
		}
	}

	out, err := this.Comm.GetStdOut()
	if err != nil {
		log.Printf("GetStdOut Err%s", err.Error())
		return err
	} else {
		if out != nil {
			cmd.Stdout = out
			defer out.Close()
		}
	}
	// cmd.Stderr = os.Stdout
	i, err := cmd.StderrPipe()
	if err != nil {
		log.Printf("StderrPipe Err%s", err.Error())
		return err
	}
	if err = cmd.Start(); err != nil {
		return err
	}
	// this.Comm.StderrByPipe(i)
	errbuf := bytes.NewBufferString("")
	scan := bufio.NewScanner(i)
	for scan.Scan() {
		s := scan.Text()
		log.Println("build error: ", s)
		errbuf.WriteString(s)
		errbuf.WriteString("\n")
	}

	cmd.Wait()
	if !cmd.ProcessState.Success() {
		return errors.New(errbuf.String())
	}
	return nil
}
