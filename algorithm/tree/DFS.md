# 回溯算法DFS
回溯实际就是一个决策树的遍历，需要考虑：
- 路径：做出选择的
- 选择列表：当前可以做选择的
- 结束条件：到达决策树底层，无法再选择的条件

## 回溯算法框架
回溯算法也是个多叉树的遍历问题，关键就是在前序遍历和后序遍历的位置做一些操作，算法框架如下：
```
result = []
def backtrack(路径，选择列表):
    if 满足结束条件:
        result.add(路径)
        return
    
    for 选择 in 选择列表:
        做选择
        backtrack(路径，选择列表)
        撤销选择
```
## 经典问题
### 全排列问题
`n`个不重复的数，全排列共有 n! 个。
```
List<List<Integer>> res = new LinkedList<>();

/* 主函数，输入一组不重复的数字，返回它们的全排列 */
List<List<Integer>> permute(int[] nums) {
    // 记录「路径」
    LinkedList<Integer> track = new LinkedList<>();
    backtrack(nums, track);
    return res;
}

// 路径：记录在 track 中
// 选择列表：nums 中不存在于 track 的那些元素
// 结束条件：nums 中的元素全都在 track 中出现
void backtrack(int[] nums, LinkedList<Integer> track) {
    // 触发结束条件
    if (track.size() == nums.length) {
        res.add(new LinkedList(track));
        return;
    }

    for (int i = 0; i < nums.length; i++) {
        // 排除不合法的选择
        if (track.contains(nums[i]))
            continue;
        // 做选择
        track.add(nums[i]);
        // 进入下一层决策树
        backtrack(nums, track);
        // 取消选择
        track.removeLast();
    }
}
```
### N皇后问题
```
vector<vector<string>> res;

/* 输入棋盘边长 n，返回所有合法的放置 */
vector<vector<string>> solveNQueens(int n) {
    // '.' 表示空，'Q' 表示皇后，初始化空棋盘。
    vector<string> board(n, string(n, '.'));
    backtrack(board, 0);
    return res;
}

// 路径：board 中小于 row 的那些行都已经成功放置了皇后
// 选择列表：第 row 行的所有列都是放置皇后的选择
// 结束条件：row 超过 board 的最后一行
void backtrack(vector<string>& board, int row) {
    // 触发结束条件
    if (row == board.size()) {
        res.push_back(board);
        return;
    }

    int n = board[row].size();
    for (int col = 0; col < n; col++) {
        // 排除不合法选择
        if (!isValid(board, row, col)) 
            continue;
        // 做选择
        board[row][col] = 'Q';
        // 进入下一行决策
        backtrack(board, row + 1);
        // 撤销选择
        board[row][col] = '.';
    }
}
/* 是否可以在 board[row][col] 放置皇后？ */
bool isValid(vector<string>& board, int row, int col) {
    int n = board.size();
    // 检查列是否有皇后互相冲突
    for (int i = 0; i < n; i++) {
        if (board[i][col] == 'Q')
            return false;
    }
    // 检查右上方是否有皇后互相冲突
    for (int i = row - 1, j = col + 1; 
            i >= 0 && j < n; i--, j++) {
        if (board[i][j] == 'Q')
            return false;
    }
    // 检查左上方是否有皇后互相冲突
    for (int i = row - 1, j = col - 1;
            i >= 0 && j >= 0; i--, j--) {
        if (board[i][j] == 'Q')
            return false;
    }
    return true;
}

// 函数找到一个答案后就返回 true
bool backtrack(vector<string>& board, int row) {
    // 触发结束条件
    if (row == board.size()) {
        res.push_back(board);
        return true;
    }
    ...
    for (int col = 0; col < n; col++) {
        ...
        board[row][col] = 'Q';

        if (backtrack(board, row + 1))
            return true;

        board[row][col] = '.';
    }

    return false;
}
```
### 子集
输入一个不包含重复数字的数组，要求算法输出这些数字的所有子集:
比如输入 nums = [1,2,3]，你的算法应输出 8 个子集，包含空集和本身，顺序可以不同：
[ [],[1],[2],[3],[1,3],[2,3],[1,2],[1,2,3] ]
![](../assets/algorithm/subset.png)
```
vector<vector<int>> res;

vector<vector<int>> subsets(vector<int>& nums) {
    // 记录走过的路径
    vector<int> track;
    backtrack(nums, 0, track);
    return res;
}

void backtrack(vector<int>& nums, int start, vector<int>& track) {
    res.push_back(track);
    // 注意 i 从 start 开始递增
    for (int i = start; i < nums.size(); i++) {
        // 做选择
        track.push_back(nums[i]);
        // 回溯
        backtrack(nums, i + 1, track);
        // 撤销选择
        track.pop_back();
    }
}
```

### 组合
输入两个数字 n, k，算法输出 [1..n] 中 k 个数字的所有组合。
回溯算法，k 限制了树的高度，n 限制了树的宽度，
```
vector<vector<int>> res;
vector<vector<int>> combine(n,k){
    vector<int> track;
    backtrack(nums,k,1,track);
    return res;
}
void backtrack(int n, int k, int start, vector<int>& track) {
    // 到达树的底部
    if (k == track.size()) {
        res.push_back(track);
        return;
    }
    // 注意 i 从 start 开始递增
    for (int i = start; i <= n; i++) {
        // 做选择
        track.push_back(i);
        backtrack(n, k, i + 1, track);
        // 撤销选择
        track.pop_back();
    }
}
```

### 排列
输入一个不包含重复数字的数组 nums，返回这些数字的全部排列。

```
res:=[][]int{}
func permute(nums []int) [][]int{
    track :=[]int{}
    backtrack(nums,0,track)
    return res
}
func backtrack(nums []int, track []int){
    if len(tack)==len(nums){
        res = append(res,track)
        return
    }
    for i:=0;i<len(nums);i++{
        if inArr(nums[i],track){
            continue
        }

        track = append(track,nums[i])
        backtrack(nums,track)
        l:=len(track)
        track = track[0:l]
    }
}
```
### 数独
输入是一个9x9的棋盘，空白格子用点号字符.表示，算法需要在原地修改棋盘，将空白格子填上数字，得到一个可行解。

数独的要求，大家想必都很熟悉了，每行，每列以及每一个 3×3 的小方格都不能有相同的数字出现

```
void solveSudoku(char[][] board){
    backtrack(board,0,0);
}
//穷举所有的解
vodi backtrack(char[][] board,int r, int c){
    int m = 9,n = 9;
    if (c==m){
        backtrack(board,r+1,0);
        return;
    }
    for (int x=r;x<m;x++){
        for (int y=c;y<n;y++){
            if (board[x][y]!='.'){
                backtrack(board,r,c+1);
                return;
            }
            for (char ch='1';ch<='9';ch++){
                
                if (!isVaild(board,ch,x,y)){
                    continue;
                }
                board[x][y] = ch;
                backtrack(board,r,c+1);
                board[x][y] = '.'
            }
        }
    }
}
boolean isVaild(char[][] board,char ch,int r,int c){
    for(int x=0;i<9;i++){
        if (board[r][x]==ch) return false;
        if (board[x][c]==ch) return false;
        // 判断 3 x 3 方框是否存在重复
        if (board[(r/3)*3 + i/3][(c/3)*3 + i%3] == ch)
            return false;
    }
    return true
}
// 找到一个解
boolean backtrack(char[][] board, int r, int c) {
    int m = 9, n = 9;
    if (c == n) {
        // 穷举到最后一列的话就换到下一行重新开始。
        return backtrack(board, r + 1, 0);
    }
    if (r == m) {
        // 找到一个可行解，触发 base case
        return true;
    }
    // 就是对每个位置进行穷举
    for (int i = r; i < m; i++) {
        for (int j = c; j < n; j++) {

            if (board[i][j] != '.') {
                // 如果有预设数字，不用我们穷举
                return backtrack(board, i, j + 1);
            } 

            for (char ch = '1'; ch <= '9'; ch++) {
                // 如果遇到不合法的数字，就跳过
                if (!isValid(board, i, j, ch))
                    continue;

                board[i][j] = ch;
                // 如果找到一个可行解，立即结束
                if (backtrack(board, i, j + 1)) {
                    return true;
                }
                board[i][j] = '.';
            }
            // 穷举完 1~9，依然没有找到可行解，此路不通
            return false;
        }
    }
    return false;
}
```
### 合法括号生成
括号问题分俩类：
- 合法性问题：利用栈来解决
- 生成问题：回溯递归

输入是一个正整数n，输出是n对儿括号的所有合法「组合」== 现在有2n个位置，每个位置可以放置字符(或者)，组成的所有括号组合中，有多少个是合法的？
```
vector<string> res;
vector<string> generateParenthesis(int n){
    if (n==0) return res;
    string track
    backtrack(n,n,track);
    return res;
}
void backtrack(int left,int right,string& track string){
    if (right < left|| left<0||right<0) return;
    if (left == 0 && right == 0) {
        res.push_back(track);
        return;
    }
    track.push_back('(');
    backtrack(left-1,right,track);
    track.pop_back();

    track.push_back(')');
    backtrack(left,right-1,track);
    track.pop_back();
}
```
