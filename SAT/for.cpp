#include <iostream>
using namespace std;

int main(){
start:    int i  = 0;
        for (int j=0; j <10; j++){
        i = i+j;
        if (i==1)
            goto start; 
        cout << i;
    }
     return 0;
}
