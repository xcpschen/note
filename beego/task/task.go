package task

import (
	"time"

	"github.com/astaxie/beego/toolbox"
)

type ITask interface {
	ToName() string
	SpecString() string
	TaskFunc() error
}
type Task struct {
	Tasks map[string]ITask

	tbox    *toolbox.Task
	isRun   bool
	RunTime time.Time
}

var task *Task

func (this *Task) add(t ITask) {
	name := t.ToName()
	if this.Tasks == nil {
		this.Tasks = map[string]ITask{}
	}
	this.Tasks[name] = t
}
func TaskRun() {
	if task.isRun {
		return
	}

	if len(task.Tasks) <= 0 {
		return
	}
	task.isRun = true
	for name, t := range task.Tasks {
		tmp := toolbox.NewTask(name, t.SpecString(), t.TaskFunc)
		toolbox.AddTask(name, tmp)
	}
	task.isRun = true
	task.RunTime = time.Now()
	toolbox.StartTask()
}
func Stop() {
	toolbox.StopTask()
}
func Register(t ITask) {
	if task == nil {
		task = &Task{}
	}
	task.add(t)
}
