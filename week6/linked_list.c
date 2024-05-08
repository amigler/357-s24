#include <stdio.h>
#include <stdlib.h>

// structure for each node in a linked list
struct list_element {
    char *name;
    struct list_element *next;
};

// returns a pointer to the new list element
struct list_element *list_append(struct list_element *head, char *name);

int main()
{
    struct list_element head = { NULL, NULL }; // initialize empty list

    list_append(&head, "first name");
    
    char buf[32];
    
    while (fgets(buf, 32, stdin) > 0) {
        list_append(&head, buf);
    }

    printf("\nThe names:\n");
    
    struct list_element *n = head.next;
    while (n->next != NULL) {
        printf("%s (%p)\n", n->name, n->name);
        n = n->next;
    }

    printf("Last name:\n");
    
    printf("%s (%p)\n", n->name,  n->name);
    
    return EXIT_SUCCESS;
}

// insert name at the end of the list
struct list_element *list_append(struct list_element *head, char *name)
{
    // create a new list element
    struct list_element *new_el = malloc(sizeof(struct list_element));
    new_el->name = strdup(name);
    new_el->next = NULL;
    
    // add this new list element to the end
    struct list_element *end_of_list = head;
    while (end_of_list->next != NULL) {
        end_of_list = end_of_list->next;
    }
    end_of_list->next = new_el;
    
    // return pointer to new list element
    return new_el;
}
