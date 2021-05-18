# GridFS
GridFS 用于存储和恢复那些超过16M（BSON文件限制）的文件(如：图片、音频、视频等)。

GridFS 也是文件存储的一种方式，但是它是存储在MonoDB的集合中。

GridFS 可以更好的存储大于16M的文件。

GridFS 会将大文件对象分割成多个小的chunk(文件片段),一般为256k/个,每个chunk将作为MongoDB的一个文档(document)被存储在chunks集合中。

GridFS 用两个集合来存储一个文件：fs.files与fs.chunks。

每个文件的实际内容被存在chunks(二进制数据)中,和文件有关的meta数据(filename,content_type,还有用户自定义的属性)将会被存在files集合中。

## 添加文件
调用 MongoDB 安装目录下bin的 mongofiles工具。put指令进行添加:
```
mongofiles -d gridfs put 文件
```

`-d gridfs` 指定存储文件的数据库名称，如果不存在该数据库，MongoDB会自动创建。如果不存在该数据库，MongoDB会自动创建。

命令来查看数据库中文件的文档：
```
db.fs.files.find()

```

根据这个 _id 获取区块(chunk)的数据：
```
db.fs.chunks.find({files_id:ObjectId('xxx')})
```