#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <unistd.h>
#include <pthread.h>
#include <stddef.h>

// A TCP service that efficiently handles all your case-changing needs
// Accepts the following requests:
// U string\r\n - returns the string in all upper case
// L string\r\n - returns the string in all lower case
// T string\r\n - returns the string, toggling the case of all letters

#define MAXLEN 1000
#define DEFAULT_BACKLOG 100
void *handle_client_request(void *param);

int main(int argc, char *argv[]) {

    if (argc < 2) {
        printf("Usage: ./case_server <port>\n");
        return EXIT_FAILURE;
    }
    
    int port = atoi(argv[1]);
    
    // create TCP socket for the server to listen
    int server_socket = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in server_sa;
    memset(&server_sa, 0, sizeof(server_sa));
    server_sa.sin_family = AF_INET;
    server_sa.sin_port = htons(port);
    server_sa.sin_addr.s_addr = htonl(INADDR_ANY);  // listen on any network device

    // bind server socket to server address/port
    if (bind(server_socket, (struct sockaddr *) &server_sa, sizeof(server_sa)) == -1) {
        printf("Error: bind()\n");
        return EXIT_FAILURE;
    }

    // configure socket's listen queue
    if (listen(server_socket, DEFAULT_BACKLOG) == -1) {
        printf("Error: listen()\n");
        return EXIT_FAILURE;
    }

    printf("listening on port: %d\n", port);
    
    // infinite loop to accept client requests
    for(;;) {
        struct sockaddr_in client_sa;
        socklen_t client_sa_len;
        char client_addr[INET_ADDRSTRLEN];
        
        int client_socket = accept(server_socket, (struct sockaddr *) &client_sa, &client_sa_len);
        inet_ntop(AF_INET, &(client_sa.sin_addr), client_addr, INET_ADDRSTRLEN);  // convert client IP address into printable string
        printf("client_socket: %d (%s:%d)\n", client_socket, client_addr, ntohs(client_sa.sin_port));

        // single-threaded, serial implementation
        handle_client_request(&client_socket);

        //pthread_t client_thread;
        //pthread_create(&client_thread, NULL, handle_client_request, &client_socket);
        //pthread_detach(client_thread); // when a detached thread terminates, its resources are automatically released without a join        
    }
    
    return EXIT_SUCCESS;
}

void upper(char *str) {
    while (*str) {
        *str &= 0x5f;  // convert char to upper case
        str++;
    }
}

void lower(char *str) {
    while (*str) {
        *str |= 0x20;  // lower case
        str++;
    }
}

void toggle(char *str) {
    while (*str) {
        *str ^= 0x20;  // toggle case
        str++;
    }
}

void *handle_client_request(void *param) {
    int client_socket = *((int *) param);
    char buf[MAXLEN+1];
    memset(buf, 0, MAXLEN+1);
    ssize_t bytes_read = recv(client_socket, buf, sizeof(buf), 0);
    if (bytes_read <= 0) {
        printf("Error reading client request\n");
        close(client_socket);
        return NULL;
    }
    buf[bytes_read-2] = '\0';  // remove CR/NL
    printf("received: %s (%lu)\n", buf, bytes_read);

    char *str = buf+1;
    if (buf[0] == 'U') {
        upper(str);
        sleep(5);
    } else if (buf[0] == 'L') {
        lower(str);
        sleep(5);
    } else if (buf[0] == 'T') {
        toggle(str);
        sleep(5);
    } else {
        char *error_response = "ERROR: unrecognized request\r\n";
        send(client_socket, error_response, strlen(error_response), 0);
        close(client_socket);
        return NULL;
    }
    
    printf("sending response: %s\n", buf+2);
    
    send(client_socket, buf+2, strlen(buf), 0);
    close(client_socket);
    
    return NULL;
}

