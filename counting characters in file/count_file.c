#include <stdio.h>
#include <ctype.h>

int main() {
    FILE *file;
    char filename[100], ch;
    int characters = 0, words = 0, lines = 0;
    int inWord = 0;

    // Input file name
    printf("Enter the filename: ");
    scanf("%s", filename);

    file = fopen(filename, "r");
    if (file == NULL) {
        printf("Could not open file %s\n", filename);
        return 1;
    }

    while ((ch = fgetc(file)) != EOF) {
        characters++;  // Count every character

        if (ch == '\n')
            lines++;    // Count lines

        if (isspace(ch)) {
            inWord = 0; // Space means end of a word
        } else if (!inWord) {
            inWord = 1;
            words++;     // Start of a new word
        }
    }

    fclose(file);

    printf("\nFile: %s\n", filename);
    printf("Characters: %d\n", characters);
    printf("Words: %d\n", words);
    printf("Lines: %d\n", lines);

    return 0;
}
