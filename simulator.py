# Re-initialize only the minimal necessary parts for a small demo program
# (to avoid redefining everything).

def mini_compile_and_run(src: str):
    # Minimal lexer, parser, and execution for the example
    import re

    # Tokenize numbers, identifiers, operators, and punctuation
    tokens = re.findall(r'\d+|[A-Za-z_][A-Za-z0-9_]*|[=;+*/()-]', src)

    memory = {}

    def eval_expr(expr_tokens):
        # Simple evaluation for "a + b" or constants
        if '+' in expr_tokens:
            idx = expr_tokens.index('+')
            left = eval_expr(expr_tokens[:idx])
            right = eval_expr(expr_tokens[idx+1:])
            return left + right
        elif expr_tokens[0].isdigit():
            return int(expr_tokens[0])
        else:
            return memory.get(expr_tokens[0], 0)

    i = 0
    while i < len(tokens):
        if tokens[i] == 'int':
            name = tokens[i+1]
            i += 3  # skip 'int', var, '='
            expr = []
            while tokens[i] != ';':
                expr.append(tokens[i])
                i += 1
            memory[name] = eval_expr(expr)
        elif tokens[i] == 'print':
            i += 2  # skip 'print', '('
            expr = []
            while tokens[i] != ')':
                expr.append(tokens[i])
                i += 1
            print(eval_expr(expr))
        i += 1

# Test the small example
mini_src = """
int a = 5;
int b = 10;
int c = a + b;
print(c);
"""

mini_compile_and_run(mini_src)
