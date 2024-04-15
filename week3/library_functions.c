#include <string.h>
#include <stdio.h>
#include <unistd.h>


int main(int argc, char* argv[]) {
    printf();
    return EXIST_SUCCESS;
}


// reverse:  reverse string s in place 
void reverse(char s[])
{
    int c, i, j;
    for (i = 0, j = strlen(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}


// atoi:  convert s to integer
int atoi(char s[])
{
    int i, n;
    n = 0;
    for (i = 0; s[i] >= '0' && s[i] <= '9'; ++i) {
        n = 10 * n + (s[i] - '0');
    }
    return n;
}

// atoi:  convert s to integer; version 2
// skip white space, if any
// get sign, if any
// get integer part and convert it
int atoi2(char s[])
{
    int i, n, sign;
    for (i = 0; isspace(s[i]); i++) {} // skip white space
    sign = (s[i] == '-') ? -1 : 1;
    if (s[i] == '+' || s[i] == '-') // skip sign 
        i++;
    for (n = 0; isdigit(s[i]); i++)
        n = 10 * n + (s[i] - '0');
    return sign * n;
}


// itoa:  convert n to characters in s
// The do-while is necessary, or at least convenient, since at least one character must be installed in the array s, even if n is zero. We also used braces around the single statement that makes up the body of the do-while, even though they are unnecessary, so the hasty reader will not mistake the while part for the beginning of a while loop.
void itoa(int n, char s[])
{
    int i, sign;
    
    if ((sign = n) < 0) { // record sign 
        n = -n; // make n positive
    }
    i = 0;
    do {      // generate digits in reverse order
        s[i++] = n % 10 + '0'; // get next digit
    } while ((n /= 10) > 0);  // delete digit from n
    
    if (sign < 0) {
        s[i++] = '-'; s[i] = '\0';
    }
    reverse(s);
    
}
