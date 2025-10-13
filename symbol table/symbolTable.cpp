#include <bits/stdc++.h>
using namespace std;

struct SymbolInfo {
    string name;
    string type;
    string scope;
    SymbolInfo* next;

    SymbolInfo(string n, string t, string s) {
        name = n;
        type = t;
        scope = s;
        next = nullptr;
    }
};

class SymbolTable {
private:
    static const int TABLE_SIZE = 10;
    SymbolInfo* table[TABLE_SIZE];

    // Simple hash function
    int hashFunction(string name) {
        int hash = 0;
        for (char c : name)
            hash += c;
        return hash % TABLE_SIZE;
    }

public:
    SymbolTable() {
        for (int i = 0; i < TABLE_SIZE; i++)
            table[i] = nullptr;
    }

    // Insert a new symbol
    void insertSymbol(string name, string type, string scope) {
        int index = hashFunction(name);
        SymbolInfo* newSymbol = new SymbolInfo(name, type, scope);

        // Check for duplicates
        SymbolInfo* temp = table[index];
        while (temp != nullptr) {
            if (temp->name == name) {
                cout << "Symbol '" << name << "' already exists!\n";
                delete newSymbol;
                return;
            }
            temp = temp->next;
        }

        // Insert at beginning of chain
        newSymbol->next = table[index];
        table[index] = newSymbol;
        cout << "Symbol '" << name << "' inserted successfully.\n";
    }

    // Search for a symbol
    SymbolInfo* searchSymbol(string name) {
        int index = hashFunction(name);
        SymbolInfo* temp = table[index];

        while (temp != nullptr) {
            if (temp->name == name)
                return temp;
            temp = temp->next;
        }
        return nullptr;
    }

    // Delete a symbol
    void deleteSymbol(string name) {
        int index = hashFunction(name);
        SymbolInfo* temp = table[index];
        SymbolInfo* prev = nullptr;

        while (temp != nullptr && temp->name != name) {
            prev = temp;
            temp = temp->next;
        }

        if (temp == nullptr) {
            cout << "Symbol '" << name << "' not found!\n";
            return;
        }

        if (prev == nullptr)
            table[index] = temp->next;
        else
            prev->next = temp->next;

        delete temp;
        cout << "Symbol '" << name << "' deleted successfully.\n";
    }

    // Display all symbols
    void displayTable() {
        cout << "\n------ SYMBOL TABLE ------\n";
        for (int i = 0; i < TABLE_SIZE; i++) {
            cout << "Bucket " << i << ": ";
            SymbolInfo* temp = table[i];
            if (!temp) {
                cout << "Empty\n";
                continue;
            }
            while (temp != nullptr) {
                cout << "[Name: " << temp->name << ", Type: " << temp->type
                     << ", Scope: " << temp->scope << "] -> ";
                temp = temp->next;
            }
            cout << "NULL\n";
        }
        cout << "--------------------------\n";
    }
};

// Main function
int main() {
    SymbolTable symTable;
    int choice;
    string name, type, scope;

    do {
        cout << "\n===== SYMBOL TABLE MENU =====";
        cout << "\n1. Insert Symbol";
        cout << "\n2. Search Symbol";
        cout << "\n3. Delete Symbol";
        cout << "\n4. Display Table";
        cout << "\n5. Exit";
        cout << "\nEnter your choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            cout << "Enter Symbol Name: ";
            cin >> name;
            cout << "Enter Symbol Type: ";
            cin >> type;
            cout << "Enter Symbol Scope: ";
            cin >> scope;
            symTable.insertSymbol(name, type, scope);
            break;

        case 2:
            cout << "Enter Symbol Name to Search: ";
            cin >> name;
            {
                SymbolInfo* s = symTable.searchSymbol(name);
                if (s)
                    cout << "Found -> [Name: " << s->name << ", Type: " << s->type
                         << ", Scope: " << s->scope << "]\n";
                else
                    cout << "Symbol not found!\n";
            }
            break;

        case 3:
            cout << "Enter Symbol Name to Delete: ";
            cin >> name;
            symTable.deleteSymbol(name);
            break;

        case 4:
            symTable.displayTable();
            break;

        case 5:
            cout << "Exiting...\n";
            break;

        default:
            cout << "Invalid choice! Try again.\n";
        }
    } while (choice != 5);

    return 0;
}
