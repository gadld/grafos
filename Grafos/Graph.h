#include <sstream>
#include <iostream>
#include <cstdlib>
#include <vector>
#include <climits>
#include "Node.h"
using namespace std;

typedef struct{//intarc
    int orig, dest, w;//dest uses the to[] index
} intarc;

class Graph{

  public:  
    vector<Node *> _v;
    
    int findNode(char c);
    int findNode(Node * n);
    

    
    string name;
    
    Graph();
    Graph(string n);//builder
    ~Graph();
    void clearGraph();
    unsigned int n();
    Node * newNode(char c);
    void newArc(Node *orig, Node *des, int weight);
    void newBArc(Node *n1, Node *n2, int weight);
    void newArc(Node *orig, Node *des);
    void newBArc(Node *n1, Node *n2);
    void newArc(int orig, int des, int weight);
    void newBArc(int n1, int n2, int weight);
    void newArc(int orig, int des);
    void newBArc(int n1, int n2);
    
    void delNode(int i);
    void delNode(Node * n);
    void delNode(char c);
    void delArc(Node * orig, Node * dest);
    void delBArc(Node * n1, Node * n2);
    Node * getNode(int i);
    Node * getNode();
    Node * getNode(char c);
    
    void sortAllArcs();
    
    void printg();
    
    bool connected(Node *start);
    
    bool connected();
    
    bool directed();
    void undirect();
    int ** dfs(int start);
   
    vector<int> dfs(Node * u);
    
    int ** bfs(Node *start);
    
    vector<intarc> mergeArcs(vector<intarc> a, unsigned int n);
    int ** kruskal();
    
    int ** getArcsTable();
    unsigned int depth(Node * start);
    unsigned int depth(Node * start, int d);
    
    int ** bellmanFord(Node * end);
    int ** dijkstra(Node * start);
    
    int ** prim(Node * start);
    int ** dijkstraAn(Node * start);
    int ** primAn(Node * start);
    
    bool hamiltonianCy();
    bool hamiltonianCy(Node * current, vector<bool> marks);
    
    bool eulerianCy();
    
    bool eulerianCy(arc current, vector<bool> marks);
    
    int ** matrix();
    int ** floydWarshall();
    int ** floydWarshallAn();
    void buildSample1();
    void buildSample2();

    void buildGraph(int nodos,int arcos);
    int factorial(int n);
};
