
#include <stdio.h>
int func(int a, int b, int c);
int main(void){
	int a,b,c;
	scanf("%d %d %d",&a,&b,&c);
	printf("%d",func(a,b,c));
	return(0);
}
