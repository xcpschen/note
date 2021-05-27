#include "rbtree.h"

// 存放头部位置
Index *Root;
// 存储x left元素下标
Index *Left;
// 存储x right元素下标
Index *Rigth;
// 存储x parent元素下标
Index *P;
Index *Nil;
// color
unsigned char *Color;
// 存储x 元素
int *Key;
// 头部下表
Index Head;

Index L;


static Index rbtree_marray_create(int length) {
    if (length<=0) {
        return -1;
    }
    int i=0;
    Index root,left,rigth,p,nil;
    unsigned char color;
    int k;
    Head = 0;
    L = length;
    Root = (Index*)calloc(L,sizeof(Index));
    Left = (Index*)calloc(L,sizeof(Index));
    Rigth = (Index*)calloc(L,sizeof(Index));
    P = (Index*)calloc(L,sizeof(Index));
    Nil = (Index*)calloc(L,sizeof(Index));
    Key = (int*)calloc(L,sizeof(int));
    Color = (unsigned char*)calloc(L,sizeof(unsigned char));

    Nil[0] = 0;
    return Head;
}

static int rbtree_marray_create(rbtree_marray_t *root){
    if (*root.Length<=0){
        return -1;
    }
    root.color = (unsigned char *)calloc(*root.Length,sizeof(unsigned char));

}

static int rbtree_left_rotate(Index Head, Index x){
    if (x>L||Head>L){
        return -1;
    }
    Index y = Rigth[x];
    // x的右子节点指向 y原来的左子节点
    Rigth[x] = Left[y];
    // y有左子节点
    if (Left[y]!=Nil[Head]){
        //y的左子节点，父节点变成为x
        P[Left[y]] = x;
    }
    // x的父节点成为y的父节点
    P[y] = P[x];
    // x为root
    if (P[x]==Nil[Head]){
        Root[Head] = y;
    }else if (x==Left[P[x]]){
        // x 在左边
        Left[P[x]] = y;
    }else{
        // x 在右边
        Rigth[P[x]] = y;
    }
    // y的左节点变成x
    Left[y] = x;
    // x的父节点成为y
    P[x] = y;
    return 1;
}

static int rbtree_right_rotate(Index Head, Index x){
    if (x>L||Head>L){
        return -1;
    }
    Index y = Left[x];
    Left[x] = Rigth[y];

    if (Rigth[y]!=Nil[Head]){
        P[Rigth[y]] = x;
    }
    P[y] = P[x];

    if (P[x]==Nil[Head]){
        Root[Head] = y;
    }else if (x==Left[P[x]]){
        Left[P[x]] = y;
    }else{
        Rigth[P[x]] = y;
    }
    Rigth[y] = x;
    P[x] =y; 
    return 1;
}

static int rbtree_insert(Index Head,Index z){
    Index y = Nil[Head];
    Index x = Root[Head];
    while (x!=Nil[Head])
    {
        y = x;
        if (Key[z]<Key[x]){
            x = Left[x];
        }else{
            x = Rigth[x];
        }
    }

    P[z] = y;
    if (y==Nil[Head]){
        Root[Head] = z;
    }else if (Key[z]<Key[y]){
        Left[y] = z;
    }else{
        Rigth[y] = z;
    }
    Left[z] =Nil[Head];
    Rigth[z] = Nil[Head];
    Color[z] = COLOR_RED;
    return 1;
}

static int rbtree_insert_fixup(Index T, Index z){

}