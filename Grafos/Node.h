#include <sstream>
#include <iostream>
#include <cstdlib>
#include <vector>

using namespace std;


class Node;

class arc{
public:
    Node * dest;
    short int w, label;
};//arc

class Node{
public:
    Node(char c);
    vector<arc> to;
    short int label;
    int findArc(Node *d);
    void sortArcs();
    void sortArcs(int left, int right);
    void delArc(int i);
    void delArc(Node *d);
    
    void printn();

    char value;
};//Node

