# Algorithm

## DFS

### 回溯算法
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

### 决策树的遍历

### 递归

### 前后序位置操作

### 路径&选择

### 线路径遍历

### 经典问题

- 全排列问题

	- 没有重复

		- 当次选择集去重处理

	- 包含重复数字，按任意顺序返回不重复

		- 先排序，上下索引可以解决重复问题

- N皇后问题

	- 所有解的
	- 解的数量

		- 基于所有解
		- 基于位运算的回溯

- 子集

	- 空集合与本身也是子集
	- 加入结果结合不用判断

- 组合

	- 组合总和

		- 每个数字在每个组合中只使用一次

			- 先排序，然后解决重复问题

		- 数字不限制

- 数独

	- 特点

		- 同行不存在相同数字
		- 同列不存在相同数字
		- 3x3内不存在相同数字

			- board[(r/3)*3 + i/3][(c/3)*3 + i%3] 

- 合法括号生成

	- 先）进入,然后DFS，再退
	- 后( 进入，然后DFS,再腿

- 累加数

	- 第三个数开始，是前面两位的和

## BFS

### 齐头并进的「图」遍历

- 队列实现齐头并进
- map 避免重复走

### 穷举最解

### 经典问题

- 二叉树最小/大高度
- 解开密码锁最小次数
- 拼图滑块｜华容道
- 走迷宫
- 两单词，一个最少几次替换可以变成另外一个
- 连连看

## 树

### 遍历算法

- 前序
- 中序
- 后续
- 同层
```
  void tracverse(TreeNode root) {
      if (root == null) return "";
      StringBuilder sb = new StringBuilder();
      // 初始化队列，将 root 加入队列
      Queue<TreeNode> q = new LinkedList<>();
      q.offer(root);
  
      while (!q.isEmpty()) {
          TreeNode cur = q.poll();
  
          /* 层级遍历代码位置 */
          ....
          /*****************/
  
          q.offer(cur.left);
          q.offer(cur.right);
      }
  }
```
	- 队列利用

### 二叉树

- 特征

	- 度最多为2
	- 节点高，树高
	- 第I层，最多有2^(i-1)个节点
	- 高度为h的二叉树，最多含有2^(h-1)个节点
	- 若在任意一棵二叉树中，有n0个叶子节点，有n2个度为2的节点，则必有 $n0=n2+1$

- 分类

	- 完全二叉树

		- 普通二叉树和满和二叉树结合体

	- 满二叉树

		- 左右节点相等
		- 总节点为2^h-1,h为树高

	- 二叉树搜索树

- 经典问题

	- 快速排序
	- 翻转二叉树
	- 填充二叉树节点的右侧指针
	- 数组构造最大二叉树
	- 构造二叉树
	- 二叉树节点数

		- 求完全二叉树节点

			- 普通二叉树
			- 满二叉树

	- 判断BST的合法性

		- 左边<=当前>=右边

	- 寻找第K小的元素
	  ```
	  func kthSmallest(root *TreeNode, k int) int {
	      idx:=0
	      res :=0
	      var traverse func (*TreeNode)
	      traverse=func(root *TreeNode) {
	          if root==nil{
	              return 
	          }
	          traverse(root.Left)
	          idx++
	          if k==idx{
	              res = root.Val
	              return
	          }
	          traverse(root.Right)
	      }
	      traverse(root)
	      return res
	  }
	  ```

		- 另解

			- 最小堆
			- 快速选择算法详解

	- BST转化累加树

		- 先左后右得到升序
		- 先右后左得到降序
		- 最右边的值最大，最左边的值最小，中间平衡 转成累加树后，最大值一定在最左边，中间小于等于左边，最小右边

	- 寻找二叉树重复子树

		- map记录是否遍历过的路径&重复次数

	- 二叉树的最近公共祖先LCA

		- 两个节点的公共祖先是根，即为左右树，则返回回root
		- 两个节点都不在根节点，返回null
		- 可能是两个节点其中一个,返回确定那个

	- 序列化&反序列化

		- 前序访问时

			- 字符串最左元素就是树的根节点，#除外，递归处理左树，右树，每次缩小字符串去除构建好的根字符

		- 后续访问

			- 字符串最后个元素就是树的根节点，递归处理右树，左树，每次缩小字符串去除构建好的根字符

		- 层级访问

			- 每个非空节点都会对应两个左右节点，利用队列进行层级遍历，同时用索引`i`记录对应节点的位置

## 动态规划

### 算法框架

- 暴力递归

	- 低效率

- 带备忘录递归

	- 自上而下

- dp数组迭代

	- 正向遍历
	  ```
	  int[][] dp = new int[m][n];
	  for (int i = 0; i < m; i++)
	      for (int j = 0; j < n; j++)
	          // 计算 dp[i][j]
	  ```

	- 反向遍历
	  ```
	  for (int i = m - 1; i >= 0; i--)
	      for (int j = n - 1; j >= 0; j--)
	          // 计算 dp[i][j]
	  ```

	- 斜向遍历
	  ```
	  // 斜着遍历数组
	  for (int l = 2; l <= n; l++) {
	      for (int i = 0; i <= n - l; i++) {
	          int j = l + i - 1;
	          // 计算 dp[i][j]
	      }
	  }
	  ```
		- dp[i][0]&d[0][j]是base
		- dp[i][j] 从dp[i-1][j],dp[i][j-1],dp[i-1][j-1]转换而来

- dp函数迭代

### 特点

- 存在重叠子问题
- 有最优子结构
- 状态转移方程

	- 明确状态
	- 定义dp数组/函数含义
	- 明确选择
	- 基本case

### 经典问题

#### 线性DP
##### LIS系列
Longes Increasing Subsequence 最长子序列

子序列特点：`不连续`
  
解决思路：
- 一维dp数组
  - dp 定义：在子数组array[0..i]中，以array[i]结尾的目标子序列（最长递增子序列）的长度是dp[i]。

```
int n = array.length;
int[] dp = new int[n];

for (int i = 1; i < n; i++) {
    for (int j = 0; j < i; j++) {
        dp[i] = 最值(dp[i], dp[j] + ...)
    }
}
```
- 二维dp数组
  - 设计两个字符串/数组的子序列
  - dp含义分为`只设计一个字符串`和`涉及两个字符串`：
    - 两个字符串：在子数组arr1[0..i]和子数组arr2[0..j]中，我们要求的子序列（最长公共子序列）长度为dp[i][j]。
    - 一个字符串/数组时：在子数组array[i..j]中，我们要求的子序列（最长回文子序列）的长度为dp[i][j]
	
	```
	int n = arr.length;
	int[][] dp = new dp[n][n];

	for (int i = 0; i < n; i++) {
		for (int j = 1; j < n; j++) {
			if (arr[i] == arr[j]) 
				dp[i][j] = dp[i][j] + ...
			else
				dp[i][j] = 最值(...)
		}
	}
	```

###### 最长上升子序列
###### 递增的三元子序列
###### 最长递增子序列个数
- dp 初始化为1
  - dp[i] 表示以 nums[i] 这个数结尾的最长递增子序列的长度。
  - 斜遍历
```
function lengthOfLIS(int [] nums){
  int[] dp = new int[nums.length]
   for i=0;i<nums.length;i++ {dp[i]=1}
   
   for i=0;i<nums.length;i++{
        for j=0;j<i;j++;j++{
            if nums[j]<nums[i] 
               dp[i] = math.max(dp[i],dp[j]+1)
        }
   }
   ret = 0
   for i=0;i<dp.length;i++{
     res = math.max(res,dp[i])
   }
  return res
}
```

###### 俄罗斯套娃信封问题
- 先按特定的规则排序，在转为最长递增子序列问题
  - 信封（w,h）,二维数组
  - w生序
  - w相同的，按h降序列
  - 对h做最长递增子序列个数算法
```
function maxEnvelopes(int [][] envelopes){
  int n = envelopes.length
  // 按宽度生序，宽度一样则按高度降序
  sort(envelopes)
  int [] height = new int[n]
  for (i=0;i<n;i++){
      height[i] = envelopes[i][1]
  }
  return lengthOfLIS(height)
}
```

###### 删列造序III
###### 堆叠长方体的最长高度
###### 得到子序列的最少操作数

##### LCS系列
###### 最长公共子序列
- 涉及两个字符串
- 用两指针i，j分别指向两个字符串，从后往前遍历，逐步缩小问题规模
- dp数组，1维为s2,二维为s1
  - 定义dp[i][j]:s2[0..i] 和s1[0...j]的LCS长度
  - base case
    - dp[0][..]和dp[..][0]都应该初始化为 0
  - 状态转移
    - s1[i-1]==s2[j-1]，都前进
    - 否则，max(dp[i-1][j],dp[i][j-1])
  - 答案 dp[i][j]
递归：
```
func LCS(s1,s2 string) int{
	var dp func(int,int) int{
		if i==-1||j==-1{
			return 0
		}
		if s1[i]==s2[j]{
			return dp(i-1,j-1)+1
		}else{
			return max(dp(i-1,j),dp(i,j-1))
		}
	}
	return dp(len(s1)-1,len(s2)-1)
}
```
dp数组：
```
func LCS(s1,s2 string) int{
	n,m:=len(s1),len(s2)
	dp :=make([][]int,n+1)
	dp[0] = make([]int,m+1)
	for i:=1;i<n+1;i++{
		dp[i] = make([]int,m+1)
		for j:=1;j<m+1;j++{
			if s1[i-1]==s2[j-1]{
				dp[i][j] = 1+dp[i-1][j-1]
			}else{
				dp[i][j] = max(dp[i-1][j],dp[i][j-1])
			}
		}
	}
	return dp[n][m]
}
```

###### 最长重复子数组

###### 不相交的线

###### 最短公共超序列

###### 编辑距离
- i,j s1,s2指针，逐渐缩小规模
- 选择
  - 相等跳过
  - 插入
  - 删除
  - 替换
- 自顶而下递归
  
```
 memo =map[string]int
 function dp(i,j) {
    if memo[(i,j)] { return memo[(i,j)]}
    if i==-1 {return j+1}
    if j==-1 {return i+1}
    if s1[i]==s[j]{
        a = dp(i-1,j-1)
         memo[(i,j)] = a
        return a
    }else {
       a= min(
            // 插入
             dp(i,j-1) +1 ，
           // 删除
            dp(i-1,j)+1,
          // 替换
            dp(i-1,j-1)+1,
       ) +1 
      memo[(i,j)] = a
      return a
    }
 }
```
- 自底而下dp二维数组 
  - dp[len(s1)+1][len(s2)+1]
  - dp[i+1][0]=i+1
  - dp[0][j+1]=j+1

```
 +----------+------------+
 |replace or|  delete    |
 |skip  _\| |      \|/   |
 +-------+---------------+
 |insert    |     now    |
 |      ->  |            |
 +----------+------------+
 
 function minDistance(s1,s2){
     m = s1.length
     n = s2.length
     int[][] dp = new int[m+1][n+1]
     //  base
     for i=1;i<=m;i++ { dp[i][0] = i}
     for j=1;i<=n;j++ { dp[0][j] = j}
 
     //自顶而下
     for i=1;i<=m;i++{
       for j=1;j<=n;j++{
           if s1[i-1]==s2[j-1]{
                dp[i][j] = dp[i-1][j-1]
          }else {
                 dp[i][j]= min(
                      // 删除
                     dp[i-1][j]+1，
                      //替换
                     dp[i-1][j-1]+1,
                      // 插入
                     dp[i][j-1]+1,
                  )+1
          }
       }
    }
 }
```

###### 买股票
  - dp[I天][交易次数][有无股票0，1]
  - 变种
  	- 交易次数的限制
  		- 不限制
  		  ```
  		  func maxProfit(prices []int) int {
  		      dp0:=0
  		      dp1:=1<<32*-1
  		      var max func(int,int)int
  		      max = func(a,b int) int{
  		          if a>b{
  		              return a
  		          }
  		          return b
  		      }
  		      for _,n:=range prices{
  		          tmp:=dp0
  		          dp0 = max(dp0,dp1+n)
  		          dp1 = max(dp1,tmp-n)
  		      }
  		      return dp0
  		  }
  		  ```
  		- 1次
  		- 2次
  		  ```
  		  // 第1次买出
  		  dp_i10 = 0,
  		  //第1次买入
  		  dp_i11 = min
  		  // 第二次卖出：max(上次卖出，上次买入+加上现在收益)
  		  dp_i20 =0,
  		  // 第2次买入
  		  dp_i21=min
  		  
  		  for price:pirces{
  		    // 
  		    dp_i20 = max(dp_i20,dp_i21+price)
  		   dp_i21 = max(dp_i21,dp_i10-price)
  		   dp_i10 = max(dp_i10,dp_i11+price)
  		   dp_i11 = max(dp_i11,-price)
  		  }
  		  return dp_i20
  		  ```
  	- 交易费
  	- 不限制交易次数，隔天后才能卖出
	```
	func maxProfit(prices []int) int {
		dp0:=0
		dp1:=1<<32*-1
		dpPre0 =
		var max func(int,int)int
		max = func(a,b int) int{
			if a>b{
				return a
			}
			return b
		}
		for _,n:=range prices{
			tmp:=dp0
			dp0 = max(dp0,dp1+n)
			dp1 = max(dp1,dpPre0-n)
			dpPre0 = tmp
		}
		return dp0
	}
	```

###### 打劫
- 屋子只有一排
- 环形屋子


###### 字符串匹配

###### 通配符匹配

###### 正则表达式匹配
- `.` 可以为任意字符
- `*`可以匹配0个或多个`前面`的元素
- 递归
```
func isMatch(text,pattern string) bool{
	memo :=map[string]bool{}
	var toString func(int,int) string
	toString = func(i,j int) string {
		return fmt.Sprintf("%d%d",i,j)
	}
	var dp func(int,int) bool
	dp = func(i,j int) bool{
		key:=toString(i,j)
		if v,ok:=memo[key];ok{
			return v
		}
		if j==len(pattern){
			if i==len(text){
				return true
			}else{
				return false
			}
		}
		first:=false
		//处理 `.`
		if i<len(text)&& pattern[j]==text[i]&&pattern[j]=='.'{
			first = true
		}
		if j<=len(pattern)-2 && pattern[j+1]=='*'{
			memo[key] = dp(i,j+2)| first&dp(i+1,j)
		}else{
			memo[key] = first|dp(i+1,j+1)
		}
		return memo[key]
	}
	return dp(0,0)
}
```
- dp
```
func isMatch(s string, p string) bool {
    m, n := len(s), len(p)
    matches := func(i, j int) bool {
        if i == 0 {
            return false
        }
        if p[j-1] == '.' {
            return true
        }
        return s[i-1] == p[j-1]
    }

    f := make([][]bool, m + 1)
    for i := 0; i < len(f); i++ {
        f[i] = make([]bool, n + 1)
    }
    f[0][0] = true
    for i := 0; i <= m; i++ {
        for j := 1; j <= n; j++ {
            if p[j-1] == '*' {
				// 匹配p[j-2]==s[i]
                f[i][j] = f[i][j] || f[i][j-2]
                if matches(i, j - 1) {
                    f[i][j] = f[i][j] || f[i-1][j]
                }
            } else if matches(i, j) {
                f[i][j] = f[i][j] || f[i-1][j-1]
            }
        }
    }
    return f[m][n]
}
```
#### 区间DP

##### 扰乱字符串
- 具有对称性
  - S1==S2
  - s1中的某字符数量在s2的是一致的
- 在i分割后情况：
  - 没交换
    - s1(0,i)==s2(0,1)
    - s1(i,n-i)==s2(i,n-i)
  - 有交换
    - s1(o,i)==s2(n-i,i)
    - s1(i,n-i)==s2(o,n-i)
 ```
 func isScramble(s1, s2 string) bool {
     n := len(s1)
     dp := make([][][]int8, n)
     for i := range dp {
         dp[i] = make([][]int8, n)
         for j := range dp[i] {
             dp[i][j] = make([]int8, n+1)
             for k := range dp[i][j] {
                 dp[i][j][k] = -1
             }
         }
     }
 
     // 第一个字符串从 i1 开始，第二个字符串从 i2 开始，子串的长度为 length
     // 和谐返回 1，不和谐返回 0
     var dfs func(i1, i2, length int) int8
     dfs = func(i1, i2, length int) (res int8) {
         d := &dp[i1][i2][length]
         if *d != -1 {
             return *d
         }
         defer func() { *d = res }()
 
         // 判断两个子串是否相等
         x, y := s1[i1:i1+length], s2[i2:i2+length]
         if x == y {
             return 1
         }
 
         // 判断是否存在字符 c 在两个子串中出现的次数不同
         freq := [26]int{}
         for i, ch := range x {
             freq[ch-'a']++
             freq[y[i]-'a']--
         }
         for _, f := range freq[:] {
             if f != 0 {
                 return 0
             }
         }
 
         // 枚举分割位置
         for i := 1; i < length; i++ {
             // 不交换的情况
             if dfs(i1, i2, i) == 1 && dfs(i1+i, i2+i, length-i) == 1 {
                 return 1
             }
             // 交换的情况
             if dfs(i1, i2+length-i, i) == 1 && dfs(i1+i, i2, length-i) == 1 {
                 return 1
             }
         }
 
         return 0
     }
     return dfs(0, 0, n) == 1
 }
 ```
 
##### 最长回文子序列
- dp定义：在子串s[i..j]中，最长回文子序列的长度为dp[i][j]
- 斜遍历
  - d[0][n-1] 是最终答案
  - dp[i][j] 从dp[i+1][j],dp[i][j-1],dp[i+1][j-1]

```
 +----------+------------+
 |s2back    |  now       |
 |      ->  |            |
 +-------+---------------+
 |s1skip  _ |     /|\    |
 |s2back  /||    s1跳过   |
 +----------+------------+
int longestPalindromeSubseq(string s) {
    int n = s.size();
    // dp 数组全部初始化为 0
    vector<vector<int>> dp(n, vector<int>(n, 0));
    // base case
    for (int i = 0; i < n; i++)
        dp[i][i] = 1;
    // 反着遍历保证正确的状态转移
    for (int i = n - 2; i >= 0; i--) {
        for (int j = i + 1; j < n; j++) {
            // 状态转移方程
            if (s[i] == s[j])
                dp[i][j] = dp[i + 1][j - 1] + 2;
            else
                dp[i][j] = max(dp[i + 1][j], dp[i][j - 1]);
        }
    }
    // 整个 s 的最长回文子串长度
    return dp[0][n - 1];
}
```

##### 统计不同回文子字符串

##### 多边形三角剖分的最低得分

##### 奇怪的打印机
##### 扔鸡蛋
###### N楼K个鸡蛋
求最坏需要扔几次，才知道鸡蛋恰好没摔碎
- 状态转移,第i层楼扔下:
  - 碎了
    - 鸡蛋K--
    - 楼层区间[1...n]->[1...i-1]
  - 没碎
    - 鸡蛋K
    - 楼层区间[1...n]->[i+1...N]
base case
- N==0 时 不需要扔，为0
- K==1 时，只能逐层时，最多N
- 最坏情况 状态转移间求最小


递归备忘录：
```
func superEggDrop(k,n int) int{
	m:=make[string]int
	var toStr func(k,n int) string
	var max func(k,n int) int
	var min func(k,n int) int
	toStr=func(k,n int) string{
		return fmt.Sprintf("%d%d",kn)
	}
	max = func(k,n int) int {
		if k>n{
			return k
		}
		return n
	}
	min = func(k,n int) min {
		if k<n{
			return k
		}
		return n
	}
	var dp func(k,n int) int
	dp=func(k,n int) int{
		if k==1 {return n}
		if n==0 {return 0}
		key :=toStr(k,n)
		if v,ok:=m[key];ok{
			return v
		}
		res = 0
		for i:=1;i<n+1;i++{
			res = min(res,
			    // 取操作的最大值
				max(
					//碎了
					dp(k,n-1)
					// 没碎
					dp(k-1,i-1)
				)+1
			)
		}
	}
	return dp(k,n)
}
```
##### 戳气球
- 变化数组，新增数组points[n+2],points[0]=points[n+1] = 1
- dp定义:dp[i][j]=x 表示戳破(i,j)之间的所有气球获得最高分x
- 当k为最后一个气球：dp[i][j] = dp[i][k] + dp[k][j] + points[i]*points[k]*points[j]
- 斜遍历
```
func maxCoins(nums []int) int{
	n = len(nums)
	points:=make([]int,n+2)
	for i:=1;i<=n;i++{
		points[i] = nums[i-1]
	}
	points[0] = points[n+1]=1
	dp:=make([][]int,n+2)
	for i:=0;i<n+2;i++{
		dp[i] = make([]int,n+2)
	}
	for i:=n;i>=0;i++{
		for j:=i+1;j<n+2;j++{
			for k:=i+1;k<j;k++{
				dp[i][k] = max(
					dp[i][j],
					dp[i][k]+dp[k][j]+points[i]*points[j]*points[k]
				)
			}
		}
	}
	return dp[0][n+1]
}
```
#### 背包DP
##### 01背包
- dp 定义： dp[i][j] = x,背包装i个物品，当前容量为j，x为当前背包装的最大价值
- dp[n][w]是答案
- 状态转移
  - 状态
    - 背包的容量j
    - 可选择的物品i
  - 选择
    - 选择 dp[i][j] = dp[i-1][j-容量[i-1]]+价值[i]
    - 不选择 dp[i][j] = dp[i-1][j]
```
int knapsack(int W, int N, vector<int>& wt, vector<int>& val) {
    // vector 全填入 0，base case 已初始化
    vector<vector<int>> dp(N + 1, vector<int>(W + 1, 0));
    for (int i = 1; i <= N; i++) {
        for (int w = 1; w <= W; w++) {
            if (w - wt[i-1] < 0) {
                // 当前背包容量装不下，只能选择不装入背包
                dp[i][w] = dp[i - 1][w];
            } else {
                // 装入或者不装入背包，择优
                dp[i][w] = max(dp[i - 1][w - wt[i-1]] + val[i-1], 
                               dp[i - 1][w]);
            }
        }
    }

    return dp[N][W];
}
```

##### 完全背包
- 零钱兑换2:金币面额无限个
- 等价：有一个背包，最大容量为amount，有一系列物品coins，每个物品的重量为coins[i]，每个物品的数量无限。请问有多少种方法，能够把背包恰好装满？
- dp定义：dp[i][j]：前i个硬币的面值，金额为j的组合数量
- base case 
  - dp[0][...]=0:0个硬币，金额为j的组合都为0
  - dp[...][0]=1:凑出0元的硬币组合，只有一种
- dp[n][amount] 为答案
```
func change(amount int,coins []int) int{
	n:=len(coins)
	dp :=make([][]int,n+1)
	for i:=0;i<=n;i++{
		dp[i] = make([]int,amount+1)
		dp[i][0] = 1
	}
	for i:=1;i<=n;i++{
		for j:=1;j<=amount;j++{
			if j-coins[i-1]>=0{
				// 上一次+这次
				dp[i][j] = dp[i-1][j]+dp[i][j-coins[i-1]]
			}else{
				dp[i][j] = dp[i-1][j]
			}
		}
	}
	return dp[n][amount]
}
```
压缩状态：
```
func change(amount int ,coins []int) int{
	n:=len(coins)
	dp :=make([]int,amount+1)
	dp[0] = 1
	for i:=1;i<=n;i++{
		for j:=1;j<=amount;j++{
			if j-coins[i]>=0{
				dp[j] = dp[j]+dp[j-coins[i]]
			}
		}
	}
	return dp[amount]
}
```

##### 分割等和子集
- 01背包的变体
- 状态压缩
- 先对集合求和`sum`,把问题转变01背包问题:给一个可装载重量为sum/2的背包和N个物品，每个物品的重量为nums[i]。现在让你装物品，是否存在一种装法，能够恰好将背包装满？
```
func canPatition(nums []int) boole{
	sum:=0
	for _,n:=range nums {sum+=n}
	// 和为奇数时，不可能划分成两个和相等的集合
	if sum%2!=0 {return false}
	n:=len(nums)
	sum = sum<<1
	dp :=make([][]bool,n+1)
	// base case
	for i:=0;i<=n;i++ {
		dp[i] = make([]bool,sum+1)
		dp[i][0] = true
	}
	for i:=1;i<=n;i++{
		for j:=1;j<=sum;j++{
			if j-nums[i-1]<0{
				dp[i][j] = dp[i-1][j]
			}else{
				dp[i][j] = dp[i-1][j]|dp[i-1][j-nums[i-1]
			}
		}
	}
	return dp[n][sum]
}
```
状态压缩：
```
func cpartition(nums []int) bool{
	sum:=0
	for _,n:=range nums {sum+=n}
	// 和为奇数时，不可能划分成两个和相等的集合
	if sum%2!=0 {return false}
	n:=len(nums)
	sum = sum<<1
	dp :=make([]bool,sum+1)
	// base case
    dp[0] = true;
	for i:=1;i<n;i++{
		for j=sum;j>=0;j--{
			if j-nums[i]>=0{
				dp[j] = dp[j]|dp[j-nums[i]]
			}
		}
	}
	return dp[sum]
}
```

##### 凑零钱到m
- 备忘录递归
  ```
  def coinChange(coins: List[int], amount: int):
      # 备忘录
      memo = dict()
      def dp(n):
          # 查备忘录，避免重复计算
          if n in memo: return memo[n]
  
          if n == 0: return 0
          if n < 0: return -1
          res = float('INF')
          for coin in coins:
              subproblem = dp(n - coin)
              if subproblem == -1: continue
              res = min(res, 1 + subproblem)
  
          # 记入备忘录
          memo[n] = res if res != float('INF') else -1
          return memo[n]
  
      return dp(amount)
  ```
- dp数组
  - 初始化dp[m+1] = m+1
  - dp[0]=0
  - dp[i]=min(dp[i],1+dp[i-coin])
  ```
  int coinChange(vector<int>& coins, int amount) {
      // 数组大小为 amount + 1，初始值也为 amount + 1
      vector<int> dp(amount + 1, amount + 1);
      // base case
      dp[0] = 0;
      for (int i = 0; i < dp.size(); i++) {
          // 内层 for 在求所有子问题 + 1 的最小值
          for (int coin : coins) {
              // 子问题无解，跳过
              if (i - coin < 0) continue;
              dp[i] = min(dp[i], 1 + dp[i - coin]);
          }
      }
      return (dp[amount] == amount + 1) ? -1 : dp[amount];
  }
  ```

##### 目标和
给定非负数组，和目标数s,用`+`,`-`对数组中任意一个元素进行添加，求这样的数组和等于s的方式有多少个
- DFS求解
  - 效率低
- 动态规划求解
  - 子集划分问题
动态规划思路：

nums 划分成两个子集 A 和 B，分别代表分配 + 的数和分配 - 的数，那么他们和 target 存在如下关系：
```
sum(A) - sum(B) = target
sum(A) = target + sum(B)
sum(A) + sum(A) = target + sum(B) + sum(A)
2 * sum(A) = target + sum(nums)
```
问题转化成：`nums 中存在几个子集 A，使得 A 中元素的和为 (target + sum(nums)) / 2` or `有一个背包，容量为 sum，现在给你 N 个物品，第 i 个物品的重量为 nums[i - 1]（注意 1 <= i <= N），每个物品只有一个，请问你有几种不同的方法能够恰好装满这个背包？`

- dp定义：dp[i][j]=x,若只在前 i 个物品中选择，若当前背包的容量为 j，则最多有 x 种方法可以恰好装满背包。
- base case 
  - dp[0][...]=0 没有物品时就是没有
  - dp[...][0] = 1 什么都不装，就背包本身
- dp[n][sum] 答案
```
func Csum(nums []int,sum int) int{
	n:=len(nums)
	dp:=make([]int,sum+1)
	dp[0] = 1
	for i:=0;i<n;i++{
		for j:=1;j<=sum;j++{
			if j-nums[i]>=0{
				dp[j] = dp[j-1]+dp[j-nums[i-1]]
			}else{
				dp[j] = dp[j-1]
			}
		}
	}
	return dp[sum]
}
```

#### 树形DP

##### 二/多叉树上的问题

##### 二叉树中最大路径和

##### 树的直径

##### 二叉树的直径

##### 最大BST子树

##### 二叉树抢劫

##### 状态压缩DP
  - f(x)函数里的x是原始数组A的子集
  - A的元素可选，可不选
  	- 0，1
  - 无法直接用哈希或者数组表达f(x)
  	- 用等长的二进制整数表示

##### A并不会很长

##### 我能赢吗

##### 优美的排列

##### 骑士拨号器

##### 参加考试的最大学生数

#### 数型DP

##### 数字1的个数

##### 最大为N的数字组合

##### 可被K整除的最小整数

##### 计算数型DP

##### 不同路径

##### 不同二叉搜索树

##### 不相交的握手

##### 递推型DP

##### 爬楼梯

##### 斐波那契数
- dp
```
  int fib(int n) {
      if (n == 2 || n == 1) 
          return 1;
      int prev = 1, curr = 1;
      for (int i = 3; i <= n; i++) {
          int sum = prev + curr;
          prev = curr;
          curr = sum;
      }
      return curr;
  }
```
- 递归
```
  int fib(int N) {
      if (N < 1) return 0;
      // 备忘录全初始化为 0
      vector<int> memo(N + 1, 0);
      // 初始化最简情况
      return helper(memo, N);
  }
  
  int helper(vector<int>& memo, int n) {
      // base case 
      if (n == 1 || n == 2) return 1;
      // 已经计算过
      if (memo[n] != 0) return memo[n];
      memo[n] = helper(memo, n - 1) + 
                  helper(memo, n - 2);
      return memo[n];
  }
```
##### 骑士拨号器
##### N天后的牢房
##### 第N个斐波那契数

#### 博弈型DP
##### 翻转游戏
##### NIM游戏
##### 石子游戏
##### 井字棋
###### 判定胜负
###### 有效井字游戏
###### 找出井字棋获胜者

#### 概率型DP
##### 分汤
##### 新21点
## 贪心算法

### 动态规划特例

### 每个局部解的集合是全局的最优解

### 经典问题

- 区间调度
	- 变种
		- 无重叠区间
		- 用最少的箭头射爆气球
- 到达最后一个问题

## 滑动窗口

### 子串问题
#### 最长回文子串

```
func longestPalindrome(s string) string{
	res :=""
	n:=len(s)
	// 从中间向两边扩散
	var palindrome func(,int,int) string
	palindrome=func(start,end int) string{
		for start>0&&end<n&&s[l]==s[r]{
			l--
			r++
		}
		return s[l+1:r-l-1]
	}
	for i:=0;i<n;i++{
		// 以s[i]为中心的回文
		s1:=palindrome(i,i)
		// 以s[i]和s[i+1]为中心的回文
		s2:=palindrome(i,i+1)
		if len(s1)>len(s2){
			res = s1
		}else{
			res =s2
		}
	}
	return res
}
```

#### 找所有字母异位词

#### 字符串排序

#### 最小覆盖字符串

#### 最长无重复子串

### 框架算法
```
int left = 0, right = 0;
while (right < s.size()) {
    // 增大窗口
    window.add(s[right]);
    right++;

    while (window needs shrink) {
        // 缩小窗口
        window.remove(s[left]);
        left++;
    }
}
```

/* 滑动窗口算法框架 */
```
void slidingWindow(string s, string t) {
    unordered_map<char, int> need, window;
    for (char c : t) need[c]++;

    int left = 0, right = 0;
    int valid = 0; 
    while (right < s.size()) {
        // c 是将移入窗口的字符
        char c = s[right];
        // 右移窗口
        right++;
        // 进行窗口内数据的一系列更新
        ...

        /*** debug 输出的位置 ***/
        printf("window: [%d, %d)\n", left, right);
        /********************/

        // 判断左侧窗口是否要收缩
        while (window needs shrink) {
            // d 是将移出窗口的字符
            char d = s[left];
            // 左移窗口
            left++;
            // 进行窗口内数据的一系列更新
            ...
        }
    }
}
```

### 双指针

#### 快慢指针

##### 是否包含环
  - 中间节点
    - 链表进行归并排序
  
##### 链表第k个节点

#### 左右指针

##### 二分查找

##### 反转数组

##### 两数之和得到对应的连续数组
- 先排序
  
##### x数之和
- 2
  - 直接遍历，_,ok:=map[traget-nums[i]] = nums[y]
- 3
  - 先排序，使得左边<=traget=<右边
  - 外层从零遍历，遇到nums[i]>traget结束
  - 大于零&相邻重复的跳过
  - 开始左右指针，遍历获取第二，第三个数
  - 等于这存储答案，左右两边继续去重
  - 大于时，右边移动；小于时左边移动
```
// 三数
func threeSum(nums []int) [][]int {
    res :=[][]int{}
    n:=len(nums)-1
    if  n < 2 {return res}
    sort.Ints(nums)
    // 排序后，左边<右边，要达成为0，则 负数｜ 整数
    for i:=0;i<n;i++{
        // 只遍历小于0且不重复的左边
        if nums[i]> 0 {break}
        if i>0&&nums[i]==nums[i-1] {continue}
        //双指针操作
        l,r:=i+1,n
        for l<r {
            sum :=nums[i]+nums[l]+nums[r]
            if sum==0{
                res = append(res,[]int{nums[i],nums[l],nums[r]})
                for l<r&& nums[l]==nums[l+1] {l++}
                for l<r&& nums[r]==nums[r-1] {r--}
                l++
                r--
            }else if sum<0{
                //左边负数多
                l++
            }else {
                //右边正数大
                r--
            }
        }
    }
    return res
}
```

##### 最接近3数之和
- 类似3，但是判断标准需要绝对值来判断
```
func threeSumClosest(nums []int, target int) int {

    n:=len(nums)-1
    res :=1<<32
    var abs func(a int) int
    abs =func(a int)int {
        if a<0{
            return a*-1
        }
        return a
    }
    var best func(cur int) 
    best=func(cur int) {
        if abs(cur-target)<abs(res-target){
            res = cur
        }
    }
    sort.Ints(nums)
    for i:=0;i<n;i++{
        if i>0&&nums[i]==nums[i-1] {continue}
        l,r:=i+1,n
        for l<r{
            sum := nums[i]+nums[l]+nums[r]
            if sum==target{
                return sum
            }
            best(sum)
            if sum>target{
                for l<r && nums[r]==nums[r-1]{r--}
                r--
            }else{
                for l<r && nums[l]==nums[l-1]{l++}
                l++
            }
        }
    }
    return res
}
```

##### 接雨水
- 当前接到雨水 = min(左边最高，右边最高)-当前高度
- 左边高，右边移动，加入刚才接到的雨水
- 右边高，左边移动，加入刚才接到的雨水
```
 当前雨水 += min(lmax,rmax)-height
 func trap(height []int) int {
     if len(height)==0 {return 0}
     l,r:=0,len(height)-1
     lmax,rmax:=height[0],height[r]
     res :=0
     var max func (a,b int) int
     max =func(a,b int) int{
         if a>b{
             return a
         }
         return b
     }
     for l<=r{
         lmax = max(lmax,height[l])
         rmax = max(rmax,height[r])
         // res +=min(lmax,rmax)-height
         if lmax>rmax{
             res += rmax-height[r]
             r--
         }else{
             res += lmax-height[l]
             l++
         }
     }
     return res
 }
```

##### 盛最多水的容器
- 当前最大面积 = min(左边最高，右边最高)*固定长度
- 左边高，右边移动
- 右边高，左边移动
```
当前最大面积 = 最小的高度*固定长度
func maxArea(height []int) int {
   res :=0
   left ,right:=0,len(height)-1
   var max func(int,int) int
   var min func(int,int) int
   max = func(a,b int) int{
       if a>b{
           return a
       }
       return b
   }
   min = func(a,b int) int{
       if a<b{
           return a
       }
       return b
   }
   for left<right{
       var area = min(height[left],height[right])*(right-left)
       res = max(res,area)
       if height[left]<height[right]{
           left++
       }else{
           right--
       }
   }
   return res
}
```

## 分治

### 进度问题

- 归并排序
- 添加括号的可能性

### 算法框架
```
function A(...){
    int mid = (lo + hi) / 2;
    /****** 分 ******/
    // 对数组的两部分分别排序
    A(...);
    A(...);
    /****** 治 ******/
   .....
}
```

- 后续递归
- 备忘录解决重复剪枝

## 数学技巧

### 位操作

## 数组技巧

### 前缀数组

### 差分数组

## 二分法技巧

### 数组有序是前提

### 框架
```
int binarySearch(int[] nums, int target) {
    int left = 0, right = ...;

    while(...) {
        int mid = (right + left) / 2;
        if (nums[mid] == target) {
            ...
        } else if (nums[mid] < target) {
            left = ...
        } else if (nums[mid] > target) {
            right = ...
        }
    }
    return ...;
}
```

### 场景

- 寻找一个数
```
  int binarySearch(int[] nums, int target) {
      int left = 0; 
      int right = nums.length - 1; // 注意
  
      while(left <= right) { // 注意
          int mid = (right + left) / 2;
          if(nums[mid] == target)
              return mid; 
          else if (nums[mid] < target)
              left = mid + 1; // 注意
          else if (nums[mid] > target)
              right = mid - 1; // 注意
          }
      return -1;
  }
```

- 寻找左边界
```
  int left_bound(int[] nums, int target) {
      if (nums.length == 0) return -1;
      int left = 0;
      int right = nums.length; // 注意
  
      while (left < right) { // 注意
          int mid = (left + right) / 2;
          if (nums[mid] == target) {
              right = mid;
          } else if (nums[mid] < target) {
              left = mid + 1;
          } else if (nums[mid] > target) {
              right = mid; // 注意
          }
      }
      return left;
  }
```
  - Koko吃香蕉问题
  - 货物运输问题

- 寻找左边界
```
  int right_bound(int[] nums, int target) {
      if (nums.length == 0) return -1;
      int left = 0, right = nums.length;
  
      while (left < right) {
          int mid = (left + right) / 2;
          if (nums[mid] == target) {
              left = mid + 1; // 注意
          } else if (nums[mid] < target) {
              left = mid + 1;
          } else if (nums[mid] > target) {
              right = mid;
          }
      }
      return left - 1; // 注意
  
  }
```
  

### 最长递增子序列个数
```
function lengthOfLIS(int [] nums){
  int [] top = new int[nums.length]
  int plies = 0
  for i=0;i<nums.length;i++{
      p = num[i]
      left,right=0,plies;
      while (left < right){
          mid = left+right/2
          if top[mid]>p {
             right = mid
          } else if (top[mid]<p){
             left = mid+1
         } else {
             right = mid;
         }
      }
       if left==piles {piles ++}
       top[left] = p
  }
 return piles
}
```

- patience game 的纸牌游戏

## 图

### 遍历算法

- 深入遍历
- 广度遍历

## 队列

### IFIO

### 类型

- 单调队列
- 环形队列

## 栈

### 单调栈

### 先进后出

## 堆

### 最大堆

### 最小堆

## 其他

### 编码

- 格雷编码
  ```
  func grayCode(n int) []int {
      m:=1<<n
      res:=make([]int,m)
      for i:=0;i<m;i++{
          res[i] = i^i>>1
      }
      return res
  }
  ```
  

### 数字反转
```
func reverse(x int) int {
    res :=0
    max:=(1<<31)-1
    min:=(1<<31)*-1
    for x!=0{
        tmp :=x%10
        res = res*10+tmp
        if x>0&&res>max||x<0&&res<min{
            return 0
        }
        x/=10
    }
    return res
}
```
