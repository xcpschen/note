#define COLOR_RED 0x0
#define COLOR_BLACK 0x1

typedef struct RBNode
{
    int key;
    unsigned char color;
    struct RBNode *left;
    struct RBNode *right;
    struct RBNode *parent;
}rb_node_t,*rb_tree_t;

// *rb_rotate_right 右旋转
static rb_node_t *rb_rotate_right(rb_tree_t *root, rb_node_t *node){
    rb_node_t *left = node->left;
    if (node->left==left->right){
        left->right->parent = node;
    }
    left->right = node;
    if (left->parent==node->parent){
        if (node->parent->left==node){
            node->parent->left = left;
        }else{
            node->parent->right = left;
        }
    }else{
        *root = left;
    }
    node->parent = left;
    return left;
}

static rb_node_t *rb_rotate_left(rb_tree_t *root, rb_node_t *node){
    rb_node_t *right = node->right;
    if(node->right = right->left)
    {
       right->left->parent = node;
    }
    
    right->left = node;
    
    if(right->parent = node->parent)
    {
        if(node->parent->left == node)
        {
             node->parent->left = right;
        }
        else{
             node->parent->right = right;
        }
    }
    else{
       *root = right;
    }

    node->parent = right;
    return right;
}

static int rbtree_delete_fixup(rb_tree_t *root, rb_node_t *node, rb_node_t *parent){
    rb_node_t *brother;
    while ((!node||node->color==COLOR_BLACK)&& node !=*parent)
    {
        /* code */
    }
    if (node){
        node->color = COLOR_BLACK;
    }
    return 0x0
}
// rb_insert_fixup 插入调整算法
// case 1 插入z的叔节点y是红色的
// case 2 插入z的叔节点y是黑色，且z是一个右孩子
// case 2 插入z的叔y节点是黑色，且z是一个左孩子

int rb_insert_fixup(rb_tree_t *root, rb_node_t *node){
    rb_node_t *parent;
    rb_node_t *grand_parant;
    
    while ((parent=node->parent)&&parent->color==COLOR_RED)
    {
       grand_parant = parent->parent;
       if (grand_parant->left==parent){
           rb_node_t *uncle = grand_parant->right;
           // case 1
           if (uncle&&uncle->color==COLOR_RED){
               parent->color = COLOR_BLACK;
               uncle->color = COLOR_BLACK;
               grand_parant->color = COLOR_RED;
               node = grand_parant;
               continue;
           }

           // case 2
           if (parent->right==node){
               rb_rotate_left(root,parent);

               rb_node_t *tmp;
               tmp = parent;
               parent = node;
               node = tmp;
           }

           // case 3
           parent->color = COLOR_BLACK;
           grand_parant->color = COLOR_RED;
           rb_rotate_right(root,grand_parant);
       }else{
           rb_node_t *uncle = grand_parant->left;
           // case 1
           if (uncle&&uncle->color==COLOR_RED){
               parent->color = COLOR_BLACK;
               uncle->color = COLOR_BLACK;
               grand_parant->color = COLOR_RED;

               node = grand_parant;
               continue;
           }

           // case 2
           if (parent->right==node){
               rb_rotate_right(root,parent);

               rb_node_t *tmp;
               tmp = parent;
               parent = node;
               node = tmp;
           }

           // case 3
           parent->color = COLOR_BLACK;
           grand_parant->color = COLOR_RED;
           rb_rotate_left(root,grand_parant);
       }
    }
    (*root)->color = COLOR_BLACK;
    return 0x0;
}
// insert_rbtree 插入节点
int insert_rbtree(rb_tree_t *root, rb_node_t *node){
    rb_node_t *p = *root;
    rb_node_t *q;
    
    while (p)
    {
       q = p;
       if (p->key==node->key) return 1;
       else if (p->key>node->key) p = p->left;
       else p = p->right;
    }
    node->parent = q;
    if (!q){
        if(node->key < q->key) q->left = node;
		else q->right = node;
    }else{
        *root = node;
    }
    node->color = COLOR_RED;
    return rb_insert_fixup(root,node);
}

int delete_rebtree(rb_tree_t *root, int key){
    rb_node_t *p = *root;

    while (p)
    {
       if (p->key==key) break;
       else if (p->key>key) p = p->left;
       else p= p->right;
    }
    if (!p) return -1;

    if (p->left&&p->right){
        rb_node_t *successor = p->right;
        while (successor->left)
        {
           successor = successor->left;
        }
        if (p->parent){
            if (p->parent->left==p){
                // p 是左节点
                p->parent->left = successor;
            }else{
                p->parent->right = successor;
            }
        }else{
            *root =successor;
        }

        rb_node_t *successor_child = successor->right;
		rb_node_t *successor_parent = successor->parent;
		int color = successor->color;      //save the color

        if(successor_parent == p)
		{
			successor_parent = successor;
		}
		else{
			if(successor_child)
				successor_child->parent = successor_parent;
		
			successor_parent->left = successor_child;
		
			successor->right = p->right;
			p->right->parent = successor;
		}

		successor->parent = p->parent;
		successor->color = p->color;
		successor->left = p->left;
		p->left->parent = successor;
	
		if(color == COLOR_BLACK)
			rbtree_delete_fixup(root, successor_child, successor_parent);
	
		free(p);
		return 0x0;

    }

    rb_node_t *child;
	rb_node_t *parent;
	int color;
	
	if(p->left)
		child = p->left;
	else
		child = p->right;
	
	
	parent = p->parent;
	color = p->color;   //save the color
	
	if(child)
		child->parent = parent;
	
	if(parent)
	{
		if(parent->left == p)
			parent->left = child;
		else
			parent->right = child;
	}
	else{
		*root = child;
	}
	
	
	if(color == COLOR_BLACK)
		rbtree_delete_fixup(root, child, parent);
	
	free(p);
	
	return 0x0;
}
