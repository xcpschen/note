# BinaryTree 二叉树
## 特性
- 每个节点最多有两个子节点/子叶,即度最多为2
- 节点多，则树高
- 二叉树的第i层上至多有$2^i-1（i≥1)$ 个节点
- 深度为h的二叉树中至多含有 $2^h-1$ 个节点
- 若在任意一棵二叉树中，有n0个叶子节点，有n2个度为2的节点，则必有 $n0=n2+1$
- 具有n个节点的完全二叉树深为$\log_2{x}+1$（其中x表示不大于n的最大整数）
- 若对一棵有n个节点的完全二叉树进行顺序编号（1≤i≤n），那么，对于编号为i（i≥1）的节点：
  - 当i=1时，该节点为根，它无双亲节点 
  - 当i>1时，该节点的双亲节点的编号为i/2 
  - 若2i≤n，则有编号为2i的左节点，否则没有左节点
  - 若2i+1≤n，则有编号为2i+1的右节点，否则没有右节点

### Complete Binary Tree 完全二叉树
深度为k，有n个结点的二叉树当且仅当其每一个结点都与深度为k的满二叉树中编号从1到n的结点一一对应。

完全二叉树的特点是叶子结点只可能出现在层序最大的两层上，并且某个结点的左分支下子孙的最大层序与右分支下子孙的最大层序相等或大1

###  Perfect Binary Tree 满二叉树
如果一棵二叉树只有度为0的结点和度为2的结点，并且度为0的结点在同一层上。

### Binary Search Tree(BST) 二叉搜索树
- 每个节点，左子树的值小于当前节点，右子树节点值都大于当前节点的值。
- 每个节点node，它的左侧子树和右侧子树都是BST。
- BST的中序遍历结果都是有序。
- 拥有了自平衡性质 ，$log{N}$级别查询

#### 基于BST的数据结构
- AVL树
- 红黑树
- B-树
- B+树

## 遍历代码
```
void traverse(TreeNode root){
    // 前序遍历
    traverse(root.left)
    // 中序遍历
    traverse(root.right)
    // 后序遍历
}
```

## 经典算法
### 快速排序使用前序遍历
找点临界点P，再分别排序，使得左边小于P,右边大于P
```
void sort(int[] nums, int lo, int hi) {
    /****** 前序遍历位置 ******/
    // 通过交换元素构建分界点 p
    int p = partition(nums, lo, hi);
    /************************/
    sort(nums, lo, p - 1);
    sort(nums, p + 1, hi);
}
```
### 归并排序-后续遍历
排序好两段子数组，再合并
```
void sort(int[] nums, int lo, int hi) {
int mid = (lo + hi) / 2;
sort(nums, lo, mid);
sort(nums, mid + 1, hi);

/****** 后序遍历位置 ******/
// 合并两个排好序的子数组
merge(nums, lo, mid, hi);
/************************/
}
```
### 计算一棵二叉树共有几个节点
根节点1 + 左树节点数 + 右树节点树
```
// 定义：count(root) 返回以 root 为根的树有多少节点
int count(TreeNode root) {
    // base case
    if (root == null) return 0;
    // 自己加上子树的节点数就是整棵树的节点数
    return 1 + count(root.left) + count(root.right);
}

```

### 翻转二叉树-前序遍历
除根外，左右互换
```
// 将整棵树的节点翻转
TreeNode invertTree(TreeNode root) {
    // base case
    if (root == null) {
        return null;
    }

    /**** 前序遍历位置 ****/
    // root 节点需要交换它的左右子节点
    TreeNode tmp = root.left;
    root.left = root.right;
    root.right = tmp;

    // 让左右子节点继续翻转它们的子节点
    invertTree(root.left);
    invertTree(root.right);

    return root;
}
```

### 填充二叉树节点的右侧指针-前序遍历
二叉树定义如下：
```
struct Node{
    int val;
    Node *left;
    Node *right;
    Node *next;
}
```
让左边的`next`指向右边的节点/子叶，没有同层右边元素时，指向NULL

```
// 主函数
Node connect(Node root) {
    if (root == null) return null;
    connectTwoNode(root.left, root.right);
    return root;
}

// 定义：输入两个节点，将它俩连接起来
void connectTwoNode(Node node1, Node node2) {
    if (node1 == null || node2 == null) {
        return;
    }
    /**** 前序遍历位置 ****/
    // 将传入的两个节点连接
    node1.next = node2;

    // 连接相同父节点的两个子节点
    connectTwoNode(node1.left, node1.right);
    connectTwoNode(node2.left, node2.right);
    // 连接跨越父节点的两个子节点
    connectTwoNode(node1.right, node2.left);
}
```

### 将二叉树展开为链表-后续遍历
例如把：
```
     1
    / \
   2   5
  / \   \
 3   4   6
//转变成
1
 \
  2
   \
    3
     \
      4
       \
        5
         \
          6
```
```
// 定义：将以 root 为根的树拉平为链表
void flatten(TreeNode root) {
    // base case
    if (root == null) return;

    flatten(root.left);
    flatten(root.right);

    /**** 后序遍历位置 ****/
    // 1、左右子树已经被拉平成一条链表
    TreeNode left = root.left;
    TreeNode right = root.right;

    // 2、将左子树作为右子树
    root.left = null;
    root.right = left;

    // 3、将原先的右子树接到当前右子树的末端
    TreeNode p = root;
    while (p.right != null) {
        p = p.right;
    }
    p.right = right;
}

```

### 数组构造最大二叉树-前序
不存在重复元素数组构建最大二叉树：
- 根元素最大
- 左树元素是根元素在数组左边部分构造.(如果数组左边部分没有元素，则左树没有)
- 右树元素是根在数组右边边部分构造。(如果数组左边部分没有元素，则右树没有)

```
/* 主函数 */
TreeNode constructMaximumBinaryTree(int[] nums) {
    return build(nums, 0, nums.length - 1);
}

/* 将 nums[lo..hi] 构造成符合条件的树，返回根节点 */
TreeNode build(int[] nums, int lo, int hi) {
    // base case
    if (lo > hi) {
        return null;
    }

    // 找到数组中的最大值和对应的索引
    int index = -1, maxVal = Integer.MIN_VALUE;
    for (int i = lo; i <= hi; i++) {
        if (maxVal < nums[i]) {
            index = i;
            maxVal = nums[i];
        }
    }

    TreeNode root = new TreeNode(maxVal);
    // 递归调用构造左右子树
    root.left = build(nums, lo, index - 1);
    root.right = build(nums, index + 1, hi);

    return root;
}
```
### 构造二叉树

知识点：`二叉树遍历后的输出特点`
- 前序遍历顺序`根，左，右`,其第一个元素一定是`根`，紧接的元素为`左树的根`
- 中序遍历顺序`左，根，右`，一定是以`根`为界限，左边为左树输出，右边为右树输出
- 后序遍历顺序`左，右，根`,最后一个元素一定是`根`
- 利用中序左边部分长度，算出让前/后序遍历数组左/右树的范围
- 前，中序构建顺序:
  - 先确定根，依次递归生成，左树，右树
- 后，中序构建顺序：
  - 先根，然后右树，左树

#### 通过前序和中序遍历结果构造二叉树
- 前序遍历 preorder = [3,9,20,15,7]
- 中序遍历 inorder  = [9,3,15,20,7]

返回二叉树：
```
     3
    / \
   9   20
      /  \
     15   7
```
```
/* 主函数 */
TreeNode buildTree(int[] preorder, int[] inorder) {
    return build(preorder, 0, preorder.length - 1,
                 inorder, 0, inorder.length - 1);
}
TreeNode build(int[] preorder, int preStart,int preEnd,int[] inorder ,int inStart, int inEnd){
    if (preStart>preEnd){
        return null;
    }
    // root 节点对应的值就是前序遍历数组的第一个元素
    int rootVal = preorder[preStart];
    // rootVal 在中序遍历数组中的索引
    int index = 0;
    for (int i = inStart; i <= inEnd; i++) {
        if (inorder[i] == rootVal) {
            index = i;
            break;
        }
    }
    int leftSize = index - inStart;

    TreeNode root = new TreeNode(nums[rootVal])

    // 递归构造左右子树
    root.left = build(preorder, preStart+1, preStart+leftSize,
                      inorder, inorder, index-1);

    root.right = build(preorder, preStart+leftSize+1, preEnd,
                       inorder, index+1, inEnd);
    return root;
}
```

#### 通过后序和中序遍历结果构造二叉树
- 中序遍历 inorder   = [9,3,15,20,7]
- 后序遍历 postorder = [9,15,7,20,3]

构建二叉树：
```
    3
   / \
  9   20
     /  \
    15   7
```
算法：
```
TreeNode buildTree(int[] inorder, int[] postorder){
    return build(inorder,0,inorderLength-1,0,postorderLength-1)
}

TreeNode build(int[] inorder,int inStart, int inEnd, int[] postorder, int pStart,int pEnd){

    if (pStart>pEnd){
        return null;
    }
    int rootVal = postorder[pEnd]
    int index = 0;
    for (var i=inStart;i<=inEnd;i++){
        if (rootVal==inorder[i]){
            index = i;
            break;
        }
    }
    // 左子树的节点个数
    int leftSize = index - inStart;
    TreeNode root = new TreeNode(rootVal);
    // 递归构造左右子树
    // inorder = [inStart,...,index]
    // postStart = [postStart,...,postStart + leftSize - 1]
    root.left = build(inorder, inStart, index - 1,
                        postorder, postStart, postStart + leftSize - 1);

    // inorder = [index+1,...,inEnd]
    // postStart = [postStart + leftSize,...,postEnd-1]
    root.right = build(inorder, index + 1, inEnd,
                        postorder, postStart + leftSize, postEnd - 1);
    return root;
}
```

### 二叉树序列化&反序列化
序列化：把二叉树前序|中序|后序|层级访问数据输出成字符串，指针没有指向则用`#`占用
反序列号：把序列化的字符串，还原成二叉树：
- 前序时：字符串最左元素就是树的根节点，#除外，递归处理左树，右树，每次缩小字符串去除构建好的根字符
- 后序时：字符串最后个元素就是树的根节点，递归处理右树，左树，每次缩小字符串去除构建好的根字符
- 中序时，无法构建
- 层级遍历时：每个非空节点都会对应两个左右节点，利用队列进行层级遍历，同时用索引`i`记录对应节点的位置

`与前后中序构建二叉树的区别：指针没有指向则用#代替，所以不需要其他序列辅助也能构成二叉树`
前|中|后序列访问算法参考[遍历算法](./binaryTree.md##遍历算法)

前序反序列化算法：
```
/* 主函数，将字符串反序列化为二叉树结构 */
TreeNode deserialize(String data) {
    LinkedList<String> nodes = new LinkedList<>();
    for (String s : data.split(SEP)) {
        nodes.addLast(s);
    }
    return deserialize(nodes);
}

/* 辅助函数，通过 nodes 列表构造二叉树 */
TreeNode deserialize(LinkedList<String> nodes) {
    if (nodes.isEmpty()) return null;
    // 从后往前取出元素
    String last = nodes.removeLast();
    if (last.equals(NULL)) return null;
    TreeNode root = new TreeNode(Integer.parseInt(last));
    // 限构造右子树，后构造左子树
    root.right = deserialize(nodes);
    root.left = deserialize(nodes);

    return root;
}

```

借用队列特性完成，层级访问算法：
```
String SEP = ",";
String NULL = "#";

/* 将二叉树序列化为字符串 */
String serialize(TreeNode root) {
    if (root == null) return "";
    StringBuilder sb = new StringBuilder();
    // 初始化队列，将 root 加入队列
    Queue<TreeNode> q = new LinkedList<>();
    q.offer(root);

    while (!q.isEmpty()) {
        TreeNode cur = q.poll();

        /* 层级遍历代码位置 */
        if (cur == null) {
            sb.append(NULL).append(SEP);
            continue;
        }
        sb.append(cur.val).append(SEP);
        /*****************/

        q.offer(cur.left);
        q.offer(cur.right);
    }

    return sb.toString();
}
```
借用队列特性完成，层级反序列化算法：
```
/* 将字符串反序列化为二叉树结构 */
TreeNode deserialize(String data) {
    if (data.isEmpty()) return null;
    String[] nodes = data.split(SEP);
    // 第一个元素就是 root 的值
    TreeNode root = new TreeNode(Integer.parseInt(nodes[0]));

    // 队列 q 记录父节点，将 root 加入队列
    Queue<TreeNode> q = new LinkedList<>();
    q.offer(root);

    for (int i = 1; i < nodes.length; ) {
        // 队列中存的都是父节点
        TreeNode parent = q.poll();
        // 父节点对应的左侧子节点的值
        String left = nodes[i++];
        if (!left.equals(NULL)) {
            parent.left = new TreeNode(Integer.parseInt(left));
            q.offer(parent.left);
        } else {
            parent.left = null;
        }
        // 父节点对应的右侧子节点的值
        String right = nodes[i++];
        if (!right.equals(NULL)) {
            parent.right = new TreeNode(Integer.parseInt(right));
            q.offer(parent.right);
        } else {
            parent.right = null;
        }
    }
    return root;
}
```

### 寻找二叉树中重复子树 - 后序+map
- 后序遍历，得出每个以当前节点的访问字符串，空指针用#代替
- 在map查找是否存在，存在加一，不存在则初始化

```
// 记录所有子树以及出现的次数
HashMap<String, Integer> memo = new HashMap<>();
// 记录重复的子树根节点
LinkedList<TreeNode> res = new LinkedList<>();

/* 主函数 */
List<TreeNode> findDuplicateSubtrees(TreeNode root) {
    traverse(root);
    return res;
}

/* 辅助函数 */
String traverse(TreeNode root) {
    if (root == null) {
        return "#";
    }

    String left = traverse(root.left);
    String right = traverse(root.right);

    String subTree = left + "," + right+ "," + root.val;

    int freq = memo.getOrDefault(subTree, 0);
    // 多次重复也只会被加入结果集一次
    if (freq == 1) {
        res.add(root);
    }
    // 给子树对应的出现次数加一
    memo.put(subTree, freq + 1);
    return subTree;
}
```

### 二叉树节点数
利用二叉树的特性：
- 普通的二叉树，只能向下遍历加一获取,时间复杂度为 $\large{O}(N)$
- 满二叉树，只需要算出高度，然后利用$2^h-1$ 可以得出节点数。时间复杂度为 $\large{O}(\normalsize{logN})$
- 完全二叉树：可以看成满二叉树+普通二叉树的结合。最坏时间复杂度为 $\large{O}(\normalsize{logN}*\normalsize{logN})$
  - 完全二叉树高度为 $\log_2{x}+1$, 所以递归深度等于树的高度 $\large{O}(logN)$
  - 每次递归主要花费在while循环，其时间复杂度为 $\large{O}(\normalsize{logN})$

```
// 普通的二叉树算法
public int countNodes(TreeNode root) {
    if (root == null) return 0;
    return 1 + countNodes(root.left) + countNodes(root.right);
}

// 满二叉树算法
public int countNodes(TreeNode root) {
    int h = 0;
    // 计算树的高度
    while (root != null) {
        root = root.left;
        h++;
    }
    // 节点总数就是 2^h - 1
    return (int)Math.pow(2, h) - 1;
}

// 完全二叉树 算法
public int countNodes(TreeNode root) {
    TreeNode l = root, r = root;
    // 记录左、右子树的高度
    int hl = 0, hr = 0;
    while (l != null) {
        l = l.left;
        hl++;
    }
    while (r != null) {
        r = r.right;
        hr++;
    }
    // 如果左右子树的高度相同，则是一棵满二叉树
    if (hl == hr) {
        return (int)Math.pow(2, hl) - 1;
    }
    // 如果左右高度不同，则按照普通二叉树的逻辑计算
    return 1 + countNodes(root.left) + countNodes(root.right);
}
```

### 寻找第K小的元素 - 二叉搜索树

### BST转化累加树



## 来源
- [百度百科二叉树](https://baike.baidu.com/item/%E4%BA%8C%E5%8F%89%E6%A0%91/1602879?fr=aladdin)
- [labuladong二叉树](https://mp.weixin.qq.com/s/AWsL7G89RtaHyHjRPNJENA)