#include <cstdio>
#include <iostream>
#include <fstream>
#include <iostream>
#include <bitset>

//                                          must compile with: g++ -std=c++11 -Wall -Werror -O3 -o ex1 ex1.cpp 

using namespace std;

int main(int argc, char** argv)
{
    FILE* inputfile;
    int cases;
    int arr[32];
    int trap; // totaly useless just to get rid fo Werrors

    inputfile = fopen ((const char *) argv[1], "r");

    trap = fscanf (inputfile, "%d", &cases);

    for (int i = 0; i < cases; i++)
    {
        int n, k;
        trap = fscanf (inputfile, "%d", &n);
        trap = fscanf (inputfile, "%d", &k);

        if (trap)
            trap--;

        string binary_str = bitset<32>(n).to_string();

        for (int i = 0; i < 16; i++)
        {
            int temp = binary_str[i];
            binary_str[i] = binary_str[31 - i];
            binary_str[31 - i] = temp;
        }

        int one_counter = 0;
        for (int i = 0; i < 32; i++)
        {
            arr[i] = (int) binary_str[i] - 48;
            if (arr[i] == 1)
                one_counter++;
        } 
        if (k < one_counter)
        {
            cout << "[]\n";
            continue;
        }    
        int iterations = k - one_counter;
        for (int i = 0; i < iterations; i++)
        {
            int j = 0;
            while (++j)
            {
                if (arr[j] != 0)
                {
                    arr[j]--;
                    arr[j-1] += 2;
                    break;
                }
            }
        }
        int j = 0, l = 0;
        cout << "[";
        while (true)
        {
            cout << arr[l];
            j += arr[l++];
            if (j < k)
            {
                cout << ",";
                continue;
            }
            else
                break;
            
        }
        cout << "]\n";
    }
}   
