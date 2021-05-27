#define COLOR_RED 0x0
#define COLOR_BLACK 0x1

#define NIL NULL

#define NIL_COLOR COLOR_BLACK

#define Nil_Num -1<<32

typedef int Index;

typedef struct rbtree_marray
{
    int Length;
    int T;
    
    int *Root;
    int *Left;
    int *Right;
    int *P;
    int *Key;

    unsigned char *color
} rbtree_marray_t;

typedef struct rbtree_node
{
    int Val;

    unsigned char Color;

    rbtree_node *Left;
    rbtree_node *Right;
    rbtree_node *P;

} rbtree_node_t,rbtree_head_t,rbtree_nil_t;
