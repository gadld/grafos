
#include "Graph.h"
#include <sstream>
#include <iostream>
#include <cstdlib>
#include <vector>
#include <climits>


int Graph::findNode(char c){
        unsigned int i;
        for (i=0; i < _v.size(); i++)
            if (_v[i]->value == c) return i;
        cout << "\nError: did not find Node with char "<<c<<"\n";
        return -1;
    }
    int Graph::findNode(Node * n){
        unsigned int i;
        for (i=0; i < _v.size(); i++)
            if (_v[i] == n) return i;
        cout << "\nError: did not find Node "<<n<<"\n";
        return -1;
    }
    

    

    
    Graph::Graph(){Graph(" Graph ");}
    Graph::Graph(string n){name = n;}//builder
    Graph::~Graph(){clearGraph();}
    void Graph::clearGraph(){
        unsigned int i;
        for(i=0; i<_v.size(); ++i)delete _v[i];
        _v.clear();
    }
    
    unsigned int Graph::n(){return _v.size();}
    
    Node * Graph::newNode(char c){
        Node * n = new Node(c);
        _v.push_back(n);
        return n;
    }
    
    void Graph::newArc(Node *orig, Node *des, int weight){
        arc a;
        a.w = weight;
        a.dest = des;
        a.label = 0;
        orig->to.push_back(a);
    }
    void Graph::newBArc(Node *n1, Node *n2, int weight){
        newArc(n1, n2, weight);
        newArc(n2, n1, weight);
    }
    void Graph::newArc(Node *orig, Node *des){newArc(orig, des, 1);}
    void Graph::newBArc(Node *n1, Node *n2){newBArc(n1, n2, 1);}
void Graph::newArc(int orig, int des, int weight){newArc(_v[orig], _v[des], weight);}
void Graph::newBArc(int n1, int n2, int weight){newArc(_v[n1], _v[n2], weight);}
void Graph::newArc(int orig, int des){newArc(_v[orig], _v[des]);}
void Graph::newBArc(int n1, int n2){newArc(_v[n1], _v[n2]);}

    void Graph::delNode(int i){
        delete _v[i];
        _v.erase(_v.begin() + i);
    }
    void Graph::delNode(Node * n){delNode(findNode(n));}
    void Graph::delNode(char c){delNode(findNode(c));}
    
    void Graph::delArc(Node * orig, Node * dest){_v[findNode(orig)]->delArc(dest);}
    void Graph::delBArc(Node * n1, Node * n2){
        _v[findNode(n1)]->delArc(n2);
        _v[findNode(n1)]->delArc(n2);
    }
    
    Node * Graph::getNode(int i){return _v[i];}
    Node * Graph::getNode(){return getNode(0);}
    Node * Graph::getNode(char c){return getNode(findNode(c));}
    
    void Graph::sortAllArcs(){
        for(unsigned int i=0; i<_v.size(); ++i)_v[i]->sortArcs();
    }
    
    void Graph::printg(){
        unsigned int i;
        string message;
        cout << "\n\n" << name << ":";
        for(i=0; i<_v.size(); ++i){
            _v[i]->printn();
        }
        cout << "\n\n";
    }// print graph
    
    bool Graph::connected(Node *start){
        unsigned int i;
        vector<Node *> q;
        Node * u;
        q.push_back(start);
        for(i=0; i<_v.size(); ++i){_v[i]->label = 1;}
        while(!q.empty()){
            u = q.back();
            q.pop_back();
            u->label = 0;
            for(i = 0; i < u->to.size(); ++i){
                if(u->to[i].dest->label){
                    q.push_back(u->to[i].dest);
                }}//if, for
        }//while
        for(i = 0; i < _v.size(); ++i){
            if(_v[i]->label){
                return false;
            }}//if, for
        return true;
    }//connected
    bool Graph::connected(){return connected(_v[0]);}
    
    bool Graph::directed(){
        bool dir = false;
        unsigned int i, j;
        for(i=0; i<n(); i++)
            for(j=0; j<_v[i]->to.size(); j++)
                if(_v[i]->to[j].dest->findArc(_v[i]) == -1) dir = true;
        return dir;
    }
    
    void Graph::undirect(){
        unsigned int i, j;
        for(i=0; i<n(); i++)
            for(j=0; j<_v[i]->to.size(); j++)
                if(_v[i]->to[j].dest->findArc(_v[i]) == -1)
                    newArc(_v[i]->to[j].dest, _v[i], _v[i]->to[j].w);
    }
    
    int ** Graph::dfs(int start){
        
        unsigned int i;
        for(i=0; i<_v.size(); ++i)_v[i]->label = 1;
        vector<int> cm = dfs(_v[start]);
        cm.push_back(-1);cm.push_back(-1);cm.push_back(-1);
        int ** table;
        table = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            table[i] = new int[3];
            table[i][0] = cm[3*i];
            table[i][1] = cm[3*i+1];
            table[i][2] = cm[3*i+2];
        }
        //
        //for(i=0; i<cm.size(); i++)cout<<"-"<<table[i/3][i%3];
        return table;
    }
    vector<int> Graph::dfs(Node * u){
        unsigned int i, j;
        vector<int> cm, temp;
        u->label = 0;
        cm.push_back(1);
        cm.push_back(findNode(u));
        cm.push_back(-1);
        for(i=0; i<u->to.size(); i++)
            if(u->to[i].dest->label){
                //cout<<"\n"<<u->value<<"->"<<u->to[i].dest->value;
                cm.push_back(2);
                cm.push_back(findNode(u));
                cm.push_back(i);
                temp = dfs(u->to[i].dest);
                for(j=0; j<temp.size(); j++)cm.push_back(temp[j]);
                cm.push_back(3);
                cm.push_back(findNode(u));
                cm.push_back(i);
            }
        return cm;
    }//depth first search
    
    int ** Graph::bfs(Node *start){
        unsigned int i;
        vector<int> cm;
        int ** table;
        
        vector<Node *> q;
        Node * u;
        
        q.push_back(start);
        for(i=0; i<_v.size(); ++i)_v[i]->label = 1;
        start->label = 0;
        while(!q.empty()){
            u = q.front();
            q.erase(q.begin());
            cm.push_back(1);
            cm.push_back(findNode(u));
            cm.push_back(-1);
            for(i = 0; i < u->to.size(); ++i){
                if(u->to[i].dest->label){
                    q.push_back(u->to[i].dest);
                    u->to[i].dest->label = 0;
                    cm.push_back(2);
                    cm.push_back(findNode(u));
                    cm.push_back(i);
                }}//if, for
        }//while
        
        cm.push_back(-1);cm.push_back(-1);cm.push_back(-1);
        table = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            table[i] = new int[3];
            table[i][0] = cm[3*i];
            table[i][1] = cm[3*i+1];
            table[i][2] = cm[3*i+2];
        }
        return table;
    }//bfs
    
    vector<intarc> Graph::mergeArcs(vector<intarc> a, unsigned int n){
        vector<intarc> res, b;
        intarc temp;
        unsigned int i=0, j=0, k;
        for(k=0; k<_v[n]->to.size(); k++){
            temp.orig=n; temp.dest=k;
            temp.w=_v[n]->to[k].w;
            b.push_back(temp);
        }
        if(n < _v.size()-1)//until last
            b = mergeArcs(b, n+1);
        
        while(i+j<a.size()+b.size()){
            if(i==a.size()){
                res.push_back(b[j]);
                j++;
            }else if(j==b.size()){
                res.push_back(a[i]);
                i++;
            }else if(a[i].w>b[j].w){
                res.push_back(b[j]);
                j++;
            }else{
                res.push_back(a[i]);
                i++;
            }
        }
        return res;
    }//merge sort for sorting kruskal arcs;
    int ** Graph::kruskal(){
        int ** table;
        unsigned int i;
        vector<int> cm;
        bool grouped = false;
        vector<intarc> arcs;
        int temp;
        Node * dest;
        
        arcs = mergeArcs(arcs, 0);
        /*
         cout<<"\nSorted arcs:";
         for(i=0; i<arcs.size(); i++)
         cout<<"\n"<<_v[arcs[i].orig]->value<<"->"
         <<_v[arcs[i].orig]->to[arcs[i].dest].dest->value
         <<"  "<<arcs[i].w;
         */
        for(i=0; i<_v.size(); i++)_v[i]->label = i;
        
        while(!grouped && !arcs.empty()){
            dest = _v[arcs[0].orig]->to[arcs[0].dest].dest;
            //cout<<"\n";for(i=0; i<_v.size(); i++)cout<<"["<<_v[i]->label<<"]";
            if(_v[arcs[0].orig]->label != dest->label){
                //cout<<"\nAdded: "<<_v[arcs[0].orig]->value<<"->"<<dest->value<<"  "<<arcs[0].w;
                temp = dest->label;
                for(i=0; i<_v.size(); ++i)if(_v[i]->label == temp)
                    _v[i]->label = _v[arcs[0].orig]->label;
                cm.push_back(2);
                cm.push_back(arcs[0].orig);
                cm.push_back(arcs[0].dest);
                grouped = true;
                for(i=0; i<_v.size(); ++i)
                    if(_v[i]->label != _v[0]->label)
                        grouped = false;
            }
            arcs.erase(arcs.begin());
        }
        
        cm.push_back(-1);cm.push_back(-1);cm.push_back(-1);
        table = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            table[i] = new int[3];
            table[i][0] = cm[3*i];
            table[i][1] = cm[3*i+1];
            table[i][2] = cm[3*i+2];
        }
        return table;
    }
    
    int ** Graph::getArcsTable(){
        vector<intarc> arcs;
        int ** list;
        intarc flag;
        flag.orig = -1;
        flag.dest = -1;
        flag.w = -1;
        unsigned int i;
        arcs = mergeArcs(arcs, 0);
        arcs.push_back(flag);
        list = new int*[arcs.size()];
        for(i=0; i<arcs.size(); i++){
            //cout<<"\n"<<arcs[i].orig<<", "<<arcs[i].dest<<", "<<arcs[i].w;
            list[i] = new int[3];
            list[i][0] = arcs[i].orig;
            if(arcs[i].orig != -1)list[i][1] = findNode(_v[arcs[i].orig]->to[arcs[i].dest].dest);
            else list[i][1]=-1;
            list[i][2] = arcs[i].w;
        }
        return list;
    }
    
    unsigned int Graph::depth(Node * start){
        unsigned int i, res=0, temp;
        for(i=0; i<_v.size(); ++i)_v[i]->label = 1;
        start->label=0;
        for(i=0; i<start->to.size(); ++i){
            if(start->to[i].dest->label){
                temp = depth(start->to[i].dest, 1);
                if(temp>res)res=temp;
            }
        }
        return res;
    }
    unsigned int Graph::depth(Node * start, int d){
        unsigned int i, res=0, temp;
        start->label=0;
        for(i=0; i<start->to.size(); ++i){
            if(start->to[i].dest->label){
                temp = depth(start->to[i].dest, 1);
                if(temp>res)res=temp;
            }
        }
        return res+d;
    }
    int ** Graph::bellmanFord(Node * end){
        unsigned int i, j, k, dep;
        int **table, dest;
        dep = depth(end);
        table = new int *[2];
        table[0] = new int[_v.size()];
        table[1] = new int[_v.size()];
        
        for(i=0; i<_v.size(); ++i){
            table[1][i] = -1;
            table[0][i] = 100000;//infinity
        }
        table[0][findNode(end)] = 0;
        table[1][findNode(end)] = findNode(end);
        for(i = 0; i < dep; ++i)
            for(j = 0; j<n(); ++j)
                for(k=0; k<_v[j]->to.size(); k++){
                    dest = findNode(_v[j]->to[k].dest);
                    if(table[0][j] > table[0][dest] + _v[j]->to[k].w){
                        table[0][j] = table[0][dest] + _v[j]->to[k].w;
                        table[1][j] = dest;
					}}//if, for
        return table;
    }//Bellman Ford
    
    int ** Graph::dijkstra(Node * start){
        unsigned int i, u;
        vector<Node *> q;
        int **table, mindist, newdist;
        
        table = new int *[2];
        table[0] = new int[_v.size()];
        table[1] = new int[_v.size()];
        
        for(i=0; i<_v.size(); ++i) _v[i]->label = 1;
        for(i=0; i<_v.size(); ++i){
            table[1][i] = -1;
            table[0][i] = INT_MAX;//infinity
        }
        q.push_back(start);
        start->label=0;
        
        table[0][findNode(start)] = 0;
        table[1][findNode(start)] = findNode(start);
        while(!q.empty()){
            u = 0;
            mindist = table[0][findNode(q[0])];
            for(i=0; i<q.size(); i++){
                if(mindist > table[0][findNode(q[i])]){
                    mindist = table[0][findNode(q[i])];
                    u = i;
                }}//if, for
            for(i = 0; i < q[u]->to.size(); ++i){
                newdist = table[0][findNode(q[u])]+q[u]->to[i].w;
                if(newdist < table[0][findNode(q[u]->to[i].dest)]){
                    table[0][findNode(q[u]->to[i].dest)] = newdist;
                    table[1][findNode(q[u]->to[i].dest)] = findNode(q[u]);
                }
                if(q[u]->to[i].dest->label){
                    q.push_back(q[u]->to[i].dest);
                    q[u]->to[i].dest->label=0;
                }
            }
            q.erase(q.begin() + u);
        }//while
        return table;
    }//dijkstra
    int ** Graph::prim(Node * start){
        unsigned int i, u;
        vector<Node *> q;
        int **table, mindist, newdist;
        
        table = new int *[2];
        table[0] = new int[_v.size()];
        table[1] = new int[_v.size()];
        
        for(i=0; i<_v.size(); ++i) _v[i]->label = 1;
        for(i=0; i<_v.size(); ++i){
            table[1][i] = -1;
            table[0][i] = INT_MAX;//infinity
        }
        
        q.push_back(start);
        start->label=0;
        
        table[0][findNode(start)] = 0;
        table[1][findNode(start)] = findNode(start);
        while(!q.empty()){
            u = 0;
            mindist = table[0][findNode(q[0])];
            for(i=0; i<q.size(); i++){
                if(mindist > table[0][findNode(q[i])]){
                    mindist = table[0][findNode(q[i])];
                    u = i;
                }}//if, for
            for(i = 0; i < q[u]->to.size(); ++i){
                newdist = q[u]->to[i].w;
                if(newdist < table[0][findNode(q[u]->to[i].dest)]){
                    table[0][findNode(q[u]->to[i].dest)] = newdist;
                    table[1][findNode(q[u]->to[i].dest)] = findNode(q[u]);
                }
                if(q[u]->to[i].dest->label){
                    q.push_back(q[u]->to[i].dest);
                    q[u]->to[i].dest->label=0;
                }
            }
            q.erase(q.begin() + u);
        }//while
        return table;
    }//prim
    int ** Graph::dijkstraAn(Node * start){
        unsigned int i, u;
        vector<Node *> q;
        vector<int> cm;
        int **table, ** atable, mindist, newdist;
        
        table = new int *[2];
        table[0] = new int[_v.size()];
        table[1] = new int[_v.size()];
        
        for(i=0; i<_v.size(); ++i) _v[i]->label = 1;
        for(i=0; i<_v.size(); ++i){
            table[1][i] = -1;
            table[0][i] = INT_MAX;//infinity
        }
        
        q.push_back(start);
        start->label=0;
        
        table[0][findNode(start)] = 0;
        table[1][findNode(start)] = findNode(start);
        while(!q.empty()){
            u = 0;
            mindist = table[0][findNode(q[0])];
            for(i=0; i<q.size(); i++){
                if(mindist > table[0][findNode(q[i])]){
                    mindist = table[0][findNode(q[i])];
                    u = i;
				}}//if, for
            cm.push_back(1);
            cm.push_back(findNode(q[u]));
            cm.push_back(-1);
            for(i = 0; i < q[u]->to.size(); ++i){
                newdist = table[0][findNode(q[u])]+q[u]->to[i].w;
                if(newdist < table[0][findNode(q[u]->to[i].dest)]){
                    if(table[0][findNode(q[u]->to[i].dest)] == INT_MAX)
                        cm.push_back(2);
                    else cm.push_back(3);
                    cm.push_back(findNode(q[u]));
                    cm.push_back(i);
                    table[0][findNode(q[u]->to[i].dest)] = newdist;
                    table[1][findNode(q[u]->to[i].dest)] = findNode(q[u]);
                }
                if(q[u]->to[i].dest->label){
                    q.push_back(q[u]->to[i].dest);
                    q[u]->to[i].dest->label=0;
                }
            }
            q.erase(q.begin() + u);
        }//while
        cm.push_back(-1);
        cm.push_back(-1);
        cm.push_back(-1);
        atable = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            atable[i] = new int[3];
            atable[i][0] = cm[3*i];
            atable[i][1] = cm[3*i+1];
            atable[i][2] = cm[3*i+2];
        }
        return atable;
    }//dijkstra an
    int ** Graph::primAn(Node * start){
        unsigned int i, u;
        vector<Node *> q;
        vector<int> cm;
        int **table, ** atable, mindist, newdist;
        
        table = new int *[2];
        table[0] = new int[_v.size()];
        table[1] = new int[_v.size()];
        
        for(i=0; i<_v.size(); ++i) _v[i]->label = 1;
        for(i=0; i<_v.size(); ++i){
            table[1][i] = -1;
            table[0][i] = INT_MAX;//infinity
        }
        
        q.push_back(start);
        start->label=0;
        
        table[0][findNode(start)] = 0;
        table[1][findNode(start)] = findNode(start);
        while(!q.empty()){
            u = 0;
            mindist = table[0][findNode(q[0])];
            for(i=0; i<q.size(); i++){
                if(mindist > table[0][findNode(q[i])]){
                    mindist = table[0][findNode(q[i])];
                    u = i;
                }}//if, for
            cm.push_back(1);
            cm.push_back(findNode(q[u]));
            cm.push_back(-1);
            //cout<<"\nu: "<<q[u]->value;
            for(i = 0; i < q[u]->to.size(); ++i){
                newdist = q[u]->to[i].w;
                if(newdist < table[0][findNode(q[u]->to[i].dest)]){
                    if(table[0][findNode(q[u]->to[i].dest)] == INT_MAX)
                        cm.push_back(2);
                    else cm.push_back(3);
                    cm.push_back(findNode(q[u]));
                    cm.push_back(i);
                    table[0][findNode(q[u]->to[i].dest)] = newdist;
                    table[1][findNode(q[u]->to[i].dest)] = findNode(q[u]);
                }
                if(q[u]->to[i].dest->label){
                    q.push_back(q[u]->to[i].dest);
                    q[u]->to[i].dest->label=0;
                }
            }
            q.erase(q.begin() + u);
        }//while
        cm.push_back(-1);
        cm.push_back(-1);
        cm.push_back(-1);
        atable = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            atable[i] = new int[3];
            atable[i][0] = cm[3*i];
            atable[i][1] = cm[3*i+1];
            atable[i][2] = cm[3*i+2];
        }
        return atable;
    }//prim an
    
    bool Graph::hamiltonianCy(){
        unsigned int i;
        vector<bool> marks;
        cout<<"\n\nhamiltonean cycles:\n";
        for(i=0; i<_v.size(); ++i){marks.push_back(false);}
        return hamiltonianCy(getNode(), marks);
    }
    bool Graph::hamiltonianCy(Node * current, vector<bool> marks){//must be private
        unsigned int i, j;
        bool allMarked, havePath = false;
        //cout<<"\ncurrent: "<<current->value<<"\nmarks:";
        //for(i=0; i<marks.size(); ++i)cout<<"("<<marks[i]<<")";
        allMarked = true;
        marks[findNode(current)] = 1;
        for(i=0; i<marks.size(); ++i){
            if (marks[i] == 0) allMarked = false;}
        if(allMarked && current == getNode()){cout<<"\n"; return true;}
        else{
            for(j=0; j<current->to.size(); ++j){
                if(marks[findNode(current->to[j].dest)] == 0 ||
                   (current->to[j].dest == getNode() && allMarked)){
                    //cout<<"\n"<<current->value<<"->"<<current->to[j].dest->value;
                    if (hamiltonianCy(current->to[j].dest, marks)){
                        cout << "<-" << current->value;
                        havePath = true;
                    }}}//if, if, for
            return havePath;
        }
    }
    
    bool Graph::eulerianCy(){
        unsigned int i, j, id = 0;
        //asign ids for arcs
        for(i=0; i<_v.size(); ++i){
            for(j=0; j<_v[i]->to.size(); ++j){
                _v[i]->to[j].label = id;
                id++;
			}}//for for
        cout<<"\n\nEulerean cycles:\n";
        cout<<"Arc ids:\t";
        for(i=0; i<_v.size(); ++i){
            for(j=0; j<_v[i]->to.size(); ++j){
                cout<<"("<<_v[i]->value<<"->"<<_v[i]->to[j].dest->value
                <<", "<<_v[i]->to[j].label<<") ";
			}}//for for
        vector<bool> marks;
        
        for(i=0; i<id; ++i){marks.push_back(false);}
        return eulerianCy(getNode()->to[0], marks);
        
    }//eulerianCy ()
    bool Graph::eulerianCy(arc current, vector<bool> marks){//must be private
        unsigned int i, j;
        bool allMarked, havePath = false;
        //cout<<"\ncurrent: "<<current.label<<"\nmarks:";
        //for(i=0; i<marks.size(); ++i)cout<<"("<<marks[i]<<")";
        allMarked = true;
        marks[current.label] = 1;
        for(i=0; i<marks.size(); ++i){
            if (marks[i] == 0) allMarked = false;}
        if(allMarked && current.label == 0){cout<<"\n"; return true;}
        else{
            for(j=0; j<current.dest->to.size(); ++j){
                if(marks[current.dest->to[j].label] == 0 ||
                   (current.dest->to[j].label == 0 && allMarked)){
                    //cout<<"\n"<<current.dest->value<<"->"<<current.dest->to[j].dest->value;
                    if (eulerianCy(current.dest->to[j], marks)){
                        cout<<" "<<current.dest->value<<" <-"
                        <<current.label<<"-";
                        havePath = true;
                    }}}//if, if, for
            return havePath;
        }
    }//eulerianCy
	
    int ** Graph::matrix(){
        unsigned int i, j;
        int ** mat;
        mat = new int*[n()];
        for(i=0; i<n(); i++){
            mat[i]= new int[n()];
            for(j=0; j<n(); j++)
                mat[i][j]=10000;
        }
        for(i=0; i<n(); i++)
            for(j=0; j<_v[i]->to.size(); j++)
                mat[i][findNode(_v[i]->to[j].dest)]= _v[i]->to[j].w;
        
        return mat;
    }
    int ** Graph::floydWarshall(){
        int ** mat;
        unsigned int i, j, k;
        int temp;
        mat = matrix();
        for(k=0; k<n(); ++k)
            for(i=0; i<n(); ++i)
                for(j=0; j<n(); ++j){
                    temp = mat[i][k] + mat[k][j];
                    if(temp<mat[i][j]) mat[i][j] = temp;
                }
        return mat;
    }		
    int ** Graph::floydWarshallAn(){
        int ** mat, ** table;
        vector<int> cm;
        unsigned int i, j, k;
        int temp;
        mat = matrix();
        for(k=0; k<n(); ++k)
            for(i=0; i<n(); ++i)
                for(j=0; j<n(); ++j){
                    temp = mat[i][k] + mat[k][j];
                    if(temp<mat[i][j]){
                        mat[i][j] = temp;
                        cm.push_back(i);
                        cm.push_back(j);
                        cm.push_back(temp);
                    }
                }
        cm.push_back(-1);
        cm.push_back(-1);
        cm.push_back(-1);
        table = new int*[cm.size()/3];
        for(i=0; i<cm.size()/3; i++){
            table[i] = new int[3];
            table[i][0] = cm[3*i];
            table[i][1] = cm[3*i+1];
            table[i][2] = cm[3*i+2];
        }
        return table;
    }


    int Graph::factorial(int n)
    {
        return (n == 1 || n == 0) ? 1 : factorial(n - 1) + n;
    }
    void Graph::buildGraph(int nodos,int arcos)
    {
        if(arcos>nodos*nodos -nodos) return;
        srand(time(NULL));
        clearGraph();
        
        char aa[]={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T'};
        for (int a=0; a<nodos; a++) {
            newNode(aa[a]);
        }
        
        int rand1;
        int rand2;
        int rand3;
        for (int i=0; i<arcos; i++) {
            
            
            do{
                rand1=rand()%nodos;
                rand2=rand()%nodos;
                
                
                while (rand1==rand2) {
                    rand2=rand()%nodos;
                }
                
               
                
                
            }while(_v[rand1]->findArc(_v[rand2])!=-1);
            rand3=rand()%100;
            
            newArc(rand1, rand2, rand3);
        }
        
    }
    void Graph::buildSample1(){
        clearGraph();
        newNode('A');
        newNode('B');
        newNode('C');
        newNode('D');
        newNode('E');
        newNode('F');
        newNode('G');
        newNode('H');
  
        newArc(_v[0], _v[1], 2);
        newArc(_v[0], _v[2], 7);
        newArc(_v[0], _v[4], 9);
        newArc(_v[1], _v[2], 2);
        newArc(_v[1], _v[3], 1);
        newArc(_v[3], _v[0], 4);
        newArc(_v[3], _v[2], 3);
        newArc(_v[2], _v[5], 1);
        newArc(_v[5], _v[1], 3);
        newArc(_v[5], _v[0], 6);
        newArc(_v[5], _v[3], 2);
        newArc(_v[4], _v[5], 9);
        newArc(_v[5], _v[4], 9);
        newArc(_v[0], _v[6], 9);
        newArc(_v[0], _v[7], 9);

    }
    void Graph::buildSample2(){
        clearGraph();
        
        newNode('X');
        newNode('Y');
        newNode('Z');
        //newNode('y');
        
        newBArc(_v[0], _v[1]);
        newBArc(_v[1], _v[2]);
        newBArc(_v[2], _v[0]);
        //newArc(_v[0], _v[3]);
        //newArc(_v[3], _v[2]);
        //newBArc(_v[1], _v[3]);
    }
