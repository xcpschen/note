# BFS核心思想
把问题抽象成图，从一点开始，向四周扩散。用`队列`数据结构，每次将一个节点周围的所有节点加入队列。BFS一般是找到「最短」的路径，代价是空间复杂度高于DFS。

借用队列特效，一次一步齐头并进，不用完整遍历，单线进行，DFS则是需要在堆栈中递归所有的路径才可以，全面查找。

BFS 本身是个暴力搜索算法，穷举得到优解。

常见场景就是在一幅图中，从起点到终点最近的距离，例如：
- 走迷宫，
- 两个单词，要求你通过某些替换，把其中一个变成另一个，每次只能替换一个字符，最少要替换几次？
- 连连看游戏
- 二叉树最小高度
- 解开密码锁的最少次数
- 滑动拼图游戏｜华容道

## 算法框架

```
// 计算从起点 start 到终点 target 的最近距离
int BFS(Node start, Node target) {
    Queue<Node> q; // 核心数据结构
    
    Set<Node> visited; // 避免走回头路,对于数组，但是像二叉树结构的没有父节点指针的就不需要

    q.offer(start); // 将起点加入队列
    visited.add(start);
    int step = 0; // 记录扩散的步数

    while (q not empty) {
        int sz = q.size();
        /* 将当前队列中的所有节点向四周扩散 */
        for (int i = 0; i < sz; i++) {
            Node cur = q.poll();
            /* 划重点：这里判断是否到达终点 */
            if (cur is target)
                return step;
            /* 将 cur 的相邻节点加入队列 */
            for (Node x : cur.adj())
                
                if (x not in visited) {
                    q.offer(x);
                    visited.add(x);
                }
        }
        /* 划重点：更新步数在这里 */
        step++;
    }
}
```

### 二叉树最小高度
给定二叉树，找出最小深度，即root到叶子节点的最小高度：
```
if cur.left==null&&cur.right==null
```
利用BFS框架：
```
int minDepth(TreeNode root) {
    if (root == null) return 0;
    Queue<TreeNode> q = new LinkedList<>();
    q.offer(root);
    // root 本身就是一层，depth 初始化为 1
    int depth = 1;

    while (!q.isEmpty()) {
        int sz = q.size();
        /* 将当前队列中的所有节点向四周扩散 */
        for (int i = 0; i < sz; i++) {
            TreeNode cur = q.poll();
            /* 判断是否到达终点 */
            if (cur.left == null && cur.right == null) 
                return depth;
            /* 将 cur 的相邻节点加入队列 */
            if (cur.left != null)
                q.offer(cur.left);
            if (cur.right != null) 
                q.offer(cur.right);
        }
        /* 这里增加步数 */
        depth++;
    }
    return depth;
}
```

### 解开密码锁的最少次数
旋转密码锁共N位，由`0~9`个数字，自由旋转，每次只选择一次，初始化为特定组合，例如全零。旋转到特殊组合target时是解决；遇到特殊组合集deadlist时，则再无法选择。

思路：共N位，每次只能向上或向下2种操作，每旋转一次后，共有2N种密码，2N为一次的向前推进。
```
// 向上旋转
String plusOne(String s, int j){

}
// 向下旋转
String minusOne(String s ,int j){

}

void BFS(String target,String begin,String[] deadends){
    // 记录需要跳过的死亡密码
    Set<String> deads = new HashSet<>();
    for (String s : deadends) deads.add(s);

    // 记录已经穷举过的密码，防止走回头路
    Set<String> visited = new HashSet<>();

    Queue<string> q = new LinkedList<>();
    q.offer(begin);
    visited.add(begin");
    int step = 0
    while(!q.isEmpty()){
        int qz = q.size();
        for (int i=0;i<qz;i++){
            string cur = q.poll()
            /* 判断是否到达终点 */
            if (deads.contains(cur))
                continue;
            if (cur.equals(target))
                return step;
            for (int k=0;k<4;k++){
                String up = plusOne(cur, j);
                if (!visited.contains(up)) {
                    q.offer(up);
                    visited.add(up);
                }
                String down = minusOne(cur, j);
                if (!visited.contains(down)) {
                    q.offer(down);
                    visited.add(down);
                }
            }
        }
        step++
    }
    return;
}
```
因为终点明确，使用双向BFS，从两边交替扩散，进行优化：比单向BFS少走一般的路径：
```
int openLock(String[] deadends, String target，String begin) {
    Set<String> deads = new HashSet<>();
    for (String s : deadends) deads.add(s);
    // 用集合不用队列，可以快速判断元素是否存在
    Set<String> q1 = new HashSet<>();
    Set<String> q2 = new HashSet<>();
    Set<String> visited = new HashSet<>();

    int step = 0;
    q1.add(begin);
    q2.add(target);

    while (!q1.isEmpty() && !q2.isEmpty()) {
        // 哈希集合在遍历的过程中不能修改，用 temp 存储扩散结果
        if (q1.size() > q2.size()) {
            // 最后交换 q1 和 q2，轮训q2
            temp = q1;
            q1 = q2;
            q2 = temp;
        }
        Set<String> temp = new HashSet<>();

        /* 将 q1 中的所有节点向周围扩散 */
        for (String cur : q1) {
            /* 判断是否到达终点 */
            if (deads.contains(cur))
                continue;
            if (q2.contains(cur))
                return step;
            visited.add(cur);

            /* 将一个节点的未遍历相邻节点加入集合 */
            for (int j = 0; j < 4; j++) {
                String up = plusOne(cur, j);
                if (!visited.contains(up))
                    temp.add(up);
                String down = minusOne(cur, j);
                if (!visited.contains(down))
                    temp.add(down);
            }
        }
        /* 在这里增加步数 */
        step++;
        // temp 相当于 q1
        // 这里交换 q1 q2，下一轮 while 就是扩散 q2
        q1 = q2;
        q2 = temp;
    }
    return -1;
}
```

### 滑动拼图
给你一个 2x3 的滑动拼图，用一个 2x3 的数组board表示。拼图中有数字 0~5 六个数，其中数字 0 就表示那个空着的格子，你可以移动其中的数字，当board变为[[1,2,3],[4,5,0]]时，赢得游戏。

请你写一个算法，计算赢得游戏需要的最少移动次数，如果不能赢得游戏，返回 -1。
按BFS的思维，抽象成图，每次0只能上下左右变动：
```
                    +--+--+--+
                    |2 |4 |1 |
     +--------------+--+--+--+----------------+
     |              |5 |0 |3 |                |
     |              +--+--+--+                |
     |                    |                   |
     |                    |                   |
    \|/                  \|/                 \| /
+--+--+--+          +--+--+--+           +--+--+--+
|2 |0 |1 |          |2 |4 |1 |           |2 |4 |1 |
+--+--+--+          +--+--+--+           +--+--+--+
|5 |4 |3 |          |0 |5 |3 |           |5 |3 |0 |
+--+--+--+          +--+--+--+           +--+--+--+
   /|\                  /|\                 /|\
  .....                .....                .....
```
把二维数组压缩成一维数组A，这样就可以当作一个点来用，用一个二维数组B/map[string][]int 来映射A下标索引所指元素在原来二维数组「上下左右」的元素下标，一次来解决上下左右移动的检索操作。
```
+--+--+--+           0   1  2  3  4  5
|2 |4 |1 |          +--+--+--+--+--+--+
+--+--+--+   -----> |2 |4 |1 |5 |0 |3 |
|5 |0 |3 |          +--+--+--+--+--+--+
+--+--+--+
   OA                        A
   A[0] = B[0][]int{1,3}
   A[1] = B[1]int{0,1,2}
   A[2] = B[2]int{1,5}
   A[3] = B[3]int{0,4}
   A[4] = B[4]int{3,1,5}
   A[5] = B[4]int{4,2}
```

```
int slidingPuzzle(vector<vector<int>>& board) {
    int m = 2, n = 3;
    string start = "";
    string target = "123450";
    // 将 2x3 的数组转化成字符串
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            start.push_back(board[i][j] + '0');
        }
    }
    // 记录一维字符串的相邻索引
    vector<vector<int>> neighbor = {
        { 1, 3 },
        { 0, 4, 2 },
        { 1, 5 },
        { 0, 4 },
        { 3, 1, 5 },
        { 4, 2 }
    };

    queue<string> q;
    unordered_set<string> visited;
    q.push(start);
    visited.insert(start);

    int step = 0;
    while (!q.empty()) {
        int sz = q.size();
        for (int i = 0; i < sz; i++) {
            string cur = q.front(); 
            q.pop();
            // 判断是否达到目标局面
            if (target == cur) {
                return step;
            }
            // 找到数字 0 的索引
            int idx = 0;
            for (; cur[idx] != '0'; idx++);
            // 将数字 0 和相邻的数字交换位置
            for (int adj : neighbor[idx]) {
                string new_board = cur;
                swap(new_board[adj], new_board[idx]);
                // 防止走回头路
                if (!visited.count(new_board)) {
                    q.push(new_board);
                    visited.insert(new_board);
                }
            }
        }
        step++;
    }
    return -1;
}
```
