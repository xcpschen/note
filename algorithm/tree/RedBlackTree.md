# Red Black Tree
1972年由Rudolf Bayer发明的,特殊化的AVL树。
## 特性
- 特殊化的AVL树，拥有自平衡特性，但是左右子树高差可能大于1
- 平衡性小于AVL,平均统计性强于AVL
- 查询，插入，删除时间只需$O(\log{N})$，树旋转不超过三次
- 任意子树都是红黑树
- 根必须是黑色，节点是红色/黑色，叶子是黑色
- 叶子到根所有路径上，不能连续有两个红色节点(垂直方向)，父子节点不能同色
- 从任一节节点其每个叶子的所有路径都包含相同的数目的黑色节点
- 树旋转，修改树中某些节点的颜色和指针结构
- n节点红黑树，高度最多为$2\log{n+1}$
- 黑高度即为根节点的黑高度

## 算法

## 场景使用场景