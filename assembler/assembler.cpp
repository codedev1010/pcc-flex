#include <bits/stdc++.h>
using namespace std;

/*
Assembly Program (program.asm):
START 100
MOVER AREG, NUM1     ; AREG = NUM1
ADD NUM2             ; AREG = AREG + NUM2
MOVEM AREG, RESULT   ; RESULT = AREG
END
*/

struct Symbol {
    string name;
    int address;
    int value;
};

struct Instruction {
    string opcode, operand1, operand2;
};

int main() {
    ifstream fin("program.asm");
    if (!fin) {
        cout << "Error: Cannot open input file.\n";
        return 0;
    }

    vector<string> program;
    string line;
    while (getline(fin, line)) {
        // Remove comments after ';' and extra spaces
        size_t comment = line.find(';');
        if (comment != string::npos) line = line.substr(0, comment);
        if (!line.empty()) {
            // Trim
            line.erase(remove(line.begin(), line.end(), '\r'), line.end());
            line.erase(remove(line.begin(), line.end(), '\t'), line.end());
            if (!line.empty())
                program.push_back(line);
        }
    }
    fin.close();

    cout << "Assembly program loaded successfully:\n";
    for (auto &x : program) cout << x << "\n";

    // ---------------- OPCODE TABLE ----------------
    map<string, string> opcodeTable = {
        {"MOVER", "01"}, {"MOVEM", "02"}, {"ADD", "03"}
    };

    vector<Instruction> code;
    vector<Symbol> symbolTable;

    // ---------------- PASS 1 ----------------
    cout << "\n=== PASS 1 ===\n";
    int locCounter = 0;

    for (auto &line : program) {
        stringstream ss(line);
        string word;
        ss >> word;

        if (word == "START") {
            ss >> locCounter;
            cout << "Program starts at address " << locCounter << "\n";
            continue;
        }
        if (word == "END") {
            cout << "End of program\n";
            break;
        }

        Instruction ins;
        ins.opcode = word;

        string rest;
        getline(ss, rest);
        rest.erase(remove(rest.begin(), rest.end(), ' '), rest.end());

        size_t comma = rest.find(',');
        if (comma != string::npos) {
            ins.operand1 = rest.substr(0, comma);
            ins.operand2 = rest.substr(comma + 1);
        } else {
            ins.operand1 = rest;
        }

        code.push_back(ins);

        // record symbols
        if (!ins.operand2.empty() && !isdigit(ins.operand2[0])) {
            bool exists = false;
            for (auto &s : symbolTable)
                if (s.name == ins.operand2)
                    exists = true;
            if (!exists) symbolTable.push_back({ins.operand2, -1, 0});
        }
        if (!ins.operand1.empty() && !isdigit(ins.operand1[0]) && ins.operand1 != "AREG") {
            bool exists = false;
            for (auto &s : symbolTable)
                if (s.name == ins.operand1)
                    exists = true;
            if (!exists) symbolTable.push_back({ins.operand1, -1, 0});
        }

        cout << locCounter << " : " << line << "\n";
        locCounter++;
    }

    // Assign addresses and values to symbols (sample data)
    int addr = 200;
    for (auto &s : symbolTable) {
        s.address = addr++;
        if (s.name == "NUM1") s.value = 5;
        if (s.name == "NUM2") s.value = 10;
        if (s.name == "RESULT") s.value = 0;
    }

    cout << "\nSymbol Table:\n";
    for (auto &s : symbolTable)
        cout << s.name << " -> Addr: " << s.address << " | Value: " << s.value << "\n";

    // ---------------- PASS 2 ----------------
    cout << "\n=== PASS 2 (Machine Code) ===\n";
    locCounter = 100;
    for (auto &ins : code) {
        cout << locCounter++ << " : ";

        if (opcodeTable.find(ins.opcode) != opcodeTable.end()) {
            cout << opcodeTable[ins.opcode] << " ";
        } else {
            cout << "?? ";
        }

        if (!ins.operand2.empty()) {
            for (auto &s : symbolTable)
                if (s.name == ins.operand2)
                    cout << s.address;
        } else if (!ins.operand1.empty()) {
            for (auto &s : symbolTable)
                if (s.name == ins.operand1)
                    cout << s.address;
        }

        cout << "\n";
    }

    // ---------------- EXECUTION SIMULATION ----------------
    cout << "\n=== EXECUTION ===\n";
    int AREG = 0;

    for (auto &ins : code) {
        if (ins.opcode == "MOVER") {
            for (auto &s : symbolTable)
                if (s.name == ins.operand2)
                    AREG = s.value; // AREG = NUM1
        }
        else if (ins.opcode == "ADD") {
            for (auto &s : symbolTable)
                if (s.name == ins.operand1)
                    AREG += s.value; // AREG = AREG + NUM2
        }
        else if (ins.opcode == "MOVEM") {
            for (auto &s : symbolTable)
                if (s.name == ins.operand2)
                    s.value = AREG; // RESULT = AREG
        }
    }

    cout << "AREG = " << AREG << "\n";
    for (auto &s : symbolTable)
        cout << s.name << " = " << s.value << "\n";

    return 0;
}
