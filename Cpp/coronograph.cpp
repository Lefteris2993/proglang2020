#include<iostream> 
#include <vector> 
#include <algorithm>

using namespace std;

//                                          must compile with: g++ -std=c++11 -Wall -Werror -O3 -o ex2 ex2.cpp 

void traversal (int prev_vertex, int cur_vertex, vector<int>* path, bool* visited, vector<int>** adj, int* back_edge_count)
{
    if (*back_edge_count == 0)
        (*path).push_back(cur_vertex);

    if (visited[cur_vertex] == true)
    {
        *back_edge_count += 1;
        return;
    }
    visited[cur_vertex] = true;
    for (int i = 0; i < (int) (*adj)[cur_vertex].size(); i++)
    {
        if (prev_vertex != -1)
            if ((*adj)[cur_vertex][i] == prev_vertex)
                continue;
        traversal(cur_vertex, (*adj)[cur_vertex][i], path, visited, adj, back_edge_count);
    }
    if (*back_edge_count == 0)
        (*path).pop_back();
}

//-------------------------------------------------------------------------------------------------------------------------

void simpleBFS (int prev_vertex, int cur_vertex, int* count, vector<int>** adj)
{
    (*count)++;
    for (int i = 0; i < (int) (*adj)[cur_vertex].size(); i++)
    {
        if (prev_vertex != -1)
            if ((*adj)[cur_vertex][i] == prev_vertex)
                continue;
        simpleBFS(cur_vertex, (*adj)[cur_vertex][i], count, adj);
    }
}

//-------------------------------------------------------------------------------------------------------------------------

int main(int argc, char** argv)
{
    int testcases, trap;
    FILE* inputfile;

    inputfile = fopen ((const char *) argv[1], "r");
    trap = fscanf (inputfile, "%d", &testcases);

    for (int i = 0; i < testcases; i++)
    {
        int V, E;
        trap = fscanf (inputfile, "%d", &V);
        trap = fscanf (inputfile, "%d", &E);

        vector<int>* adj = new vector<int>[V + 1];
        vector<int> path;
        bool* visited = new bool[V + 1];
        int back_edge_count = 0;
        for (int i = 0; i < V + 1; i++)
            visited[i] = false;

        for (int i = 0; i < E; i++)
        {
            int u, v;
            trap = fscanf (inputfile, "%d", &u);
            trap = fscanf (inputfile, "%d", &v);

            adj[v].push_back(u);
            adj[u].push_back(v);
        }

        if (V != E) // corona graph is a tree with an extra edge!
        {
            cout << "NO CORONA\n";
            continue;
        }

        if (trap) //useless thing. trap is only to remove warnings.
            trap++;
            
        traversal (-1, 1, &path, visited, &adj, &back_edge_count);

        if (back_edge_count != 2)
        {
            cout << "NO CORONA\n";
            continue;
        }

        bool flag = false;
        for (int i = 1; i < V + 1; i++)
        {
            if (visited[i] == false)
            {
                cout << "NO CORONA\n";
                flag = true;
                break;
            }
        }
        if (flag)
            continue;

        ///this code defines the cirlce from path
        int a = path[path.size() - 1];
        path.pop_back();
        for (int i = path.size() - 1; i > -1; i--)
        { 
            if (path[i] == a)
            {
                path.erase(path.begin(), path.begin() + i);
                break;
            }
        }

        cout << "CORONA " << path.size() << "\n";


        for (unsigned i = 0; i < path.size(); i++)//removing circle edges
        {
            vector<int> temp;
            int prev = i == 0 ? path[path.size() - 1] : path[i - 1];
            int next = i == path.size() - 1 ? path[0] : path[i + 1];
            for (unsigned j = 0; j < adj[path[i]].size(); j++)
            {
                int a = adj[path[i]][j];
                if (a != prev && a != next)
                    temp.push_back(a);
            }
            adj[path[i]] = temp;
        }

        vector<int> trees;
        int count;
        for (int i = 0; i < (int) path.size(); i++)// count trees in every edge of the circle
        {
            count = 0;
            simpleBFS(-1, path[i], &count, &adj);
            trees.push_back(count);
        }

        sort(trees.begin(), trees.end());

        for (int i = 0; i < (int) trees.size(); i++)
        {
            cout << trees[i] ;
            if (i < (int) trees.size() - 1)
                cout << " ";
        }
        cout << "\n";      
    }
} 
