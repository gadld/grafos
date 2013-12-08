#include "Node.h"

class Node;



Node::Node(char c){
        value = c;
        label = 0;
        to.clear();
    }

    int Node::findArc(Node *d){
        unsigned int i;
        for (i=0; i < to.size(); i++)
            if (to[i].dest == d) return i;
        cout << "\nDid not find Arc\nFrom "
        <<value<<" to "<<d->value;
        return -1;
    }
    void Node::sortArcs(){sortArcs(0, to.size()-1);}
    void Node::sortArcs(int left, int right){
        int i = left, j = right, pivot;
        arc temp;
        if (right < 0) return;
        pivot = to[(left + right) / 2].w;
        while (i <= j){
            while (to[i].w < pivot)i++;
            while (to[j].w > pivot)j--;
            if (i <= j) {
                temp = to[i];
                to[i] = to[j];
                to[j] = temp;
                i++;
                j--;
            }
        }
        if (left < j)sortArcs(left, j);
        if (i < right)sortArcs(i, right);
    }//quick sort
    void Node::delArc(int i){to.erase(to.begin() + i);}
    void Node::delArc(Node *d){delArc(findArc(d));}
    
    void Node::printn(){
        unsigned int j;
        cout << "\n" << value << "-> ";
        for(j=0; j<to.size(); ++j){
            cout<<"("<< to[j].w<<" "
            << to[j].dest->value<< "), ";
            //cout<<to[j].label<<", ";
        }
    }
	//private:
    char value;


