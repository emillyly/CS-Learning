# Emilly Ly
# 111097939
# Homework 4

import ply
import sys
symbol_table = dict()

class Node:
    def __init__(self):
        print("init node")

    def evaluate(self):
        return 0

    def execute(self):
        return 0

class NumberNode(Node):
    def __init__(self, v):
        if('.' in v):
            self.value = float(v)
        else:
            self.value = int(v)

    def evaluate(self):
        return self.value

class NegativeNode(Node):
    def __init__(self, v):
        self.value = v.evaluate() * -1

    def evaluate(self):
        return self.value

class StringNode(Node):
    def __init__(self, v):
        self.value = v

    def evaluate(self):
        return self.value

class BooleanNode(Node):
    def __init__(self, v):
        if(v == "True"):
            self.value = True
        else:
            self.value = False

    def evaluate(self):
        return self.value

class NotNode(Node):
    def __init__(self,op, v):
        self.op = op
        self.v = v

    def evaluate(self):
        if (self.op == 'not'):
            return not self.v.evaluate()

class BooleanExpression(Node):
    def __init__(self, op, v1, v2):
        self.v1 = v1
        self.v2 = v2
        self.op = op

    def evaluate(self):
        if (self.op == 'andalso'):
            return (self.v1.evaluate() and self.v2.evaluate())
        elif (self.op == 'orelse'):
            return (self.v1.evaluate() or self.v2.evaluate())

class IndexNode(Node):
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2

    def evaluate(self):
        a = self.v1.evaluate()
        b = self.v2.evaluate()
        if(len(a) <= b):
            raise Exception
        elif(type(b) != int):
            raise Exception
        elif(isinstance(a,str) and (isinstance(a,list))):
            raise Exception
        else:
            return self.v1.evaluate()[self.v2.evaluate()]

class IndexTupleNode(Node):
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2

    def evaluate(self):
        a = self.v1.evaluate()
        b = self.v2.evaluate()
        if(type(b) != int):
            raise Exception
        elif(not isinstance(a,tuple)):
            raise Exception
        elif(len(a) == 1):
            raise Exception
        else:
            return a[b - 1]

class PrintNode(Node):
    def __init__(self, v):
        self.value = v

    def evaluate(self):
        self.value = self.value.evaluate()
        print(self.value)

class BopNode(Node):
    def __init__(self, op, v1, v2):
        self.v1 = v1
        self.v2 = v2
        self.op = op

    def evaluate(self):
        if (self.op == '+'):
            return self.v1.evaluate() + self.v2.evaluate()
        elif (self.op == '-'):
            return self.v1.evaluate() - self.v2.evaluate()
        elif (self.op == '*'):
            return self.v1.evaluate() * self.v2.evaluate()
        elif (self.op == '/'):
            return self.v1.evaluate() / self.v2.evaluate()
        elif (self.op == '**'):
            return self.v1.evaluate() ** self.v2.evaluate()
        elif (self.op == 'mod'):
            return self.v1.evaluate() % self.v2.evaluate()
        elif (self.op == 'div'):
            return self.v1.evaluate() // self.v2.evaluate()

class EQNode(Node):
    def __init__(self, op, v1, v2):
        self.v1 = v1
        self.v2 = v2
        self.op = op

    def evaluate(self):
        if(self.op == '=='):
            if (self.v1.evaluate() == self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == '<'):
            if (self.v1.evaluate() < self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == '<='):
            if (self.v1.evaluate() <= self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == '<>'):
            if (self.v1.evaluate() != self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == '>'):
            if (self.v1.evaluate() > self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == '>='):
            if (self.v1.evaluate() >= self.v2.evaluate()):
                return True
            else:
                return False
        elif(self.op == 'in'):
            if(self.v1.evaluate() in self.v2.evaluate()):
                return True
            else:
                return False

class ListNode(Node):
    def __init__(self, v):
        self.v = [v]

    def evaluate(self):
        l = []
        for v in self.v:
            l.append(v.evaluate())
        return l

class EmptyListNode(Node):
    def __init__(self, v):
        self.v = v

    def evaluate(self):
        return []

class TupleNode(Node):
    def __init__(self, v):
        self.v = [v]

    def evaluate(self):
        return tuple(self.v[0].evaluate())

class EmptyTupNode(Node):
    def __init__(self, v):
        self.v = v

    def evaluate(self):
        return ()

class BlockNode(Node):
    def __init__(self,sl):
        self.statementList = sl

    def evaluate(self):
         for statement in self.statementList:
            statement.evaluate()

class SymbolNode(Node):
    def __init__(self, v):
        self.value = v

    def evaluate(self):
        return symbol_table[self.value]

class AssignmentNode(Node):
    def __init__(self, symbol, value):
        self.symbol = symbol
        self.value = value

    def evaluate(self):
        symbol_table[self.symbol.value] = self.value.evaluate()

class AssignToListNode(Node):
    def __init__(self, symbol, index, value):
        self.symbol = symbol
        self.index = index
        self.value = value

    def evaluate(self):
        symbol_table[self.symbol.value][self.index.evaluate()] = self.value.evaluate()

class AssignToListSecondNode(Node):
    def __init__(self, symbol, indexOne, indexTwo, value):
        self.symbol = symbol
        self.indexOne = indexOne
        self.indexTwo = indexTwo
        self.value = value

    def evaluate(self):
        symbol_table[self.symbol.value][self.indexOne.evaluate()][self.indexOne.evaluate()] = self.value.evaluate()

class IfNode(Node):
    def __init__(self, condition, block):
        self.condition = condition
        self.block = block

    def evaluate(self):
        if (self.condition.evaluate()):
            self.block.evaluate()

class IfElseNode(Node):
    def __init__(self, condition, blockOne, blockTwo):
        self.condition = condition
        self.blockOne = blockOne
        self.blockTwo = blockTwo

    def evaluate(self):
        if (self.condition.evaluate()):
            self.blockOne.evaluate()
        else:
            self.blockTwo.evaluate()

class WhileNode(Node):
    def __init__(self, condition, block):
        self.condition = condition
        self.block = block

    def evaluate(self):
        while (self.condition.evaluate()):
            self.block.evaluate()


reserved = {
    'True': 'TRUE',
    'False': 'FALSE',
    'not' : 'NOT',
    'andalso' : 'ANDALSO',
    'orelse'  : 'ORELSE',
    'in'  : 'IN',
    'if'  : 'IF',
    'else': 'ELSE',
    'while': 'WHILE',
    'print': 'PRINT',
    'div' : 'DIV',
    'mod' : 'MOD',
}

tokens = [
    'LPAREN', 'RPAREN',
    'NUMBER',
    'PLUS','MINUS','TIMES','DIVIDE',
    'EXPONENT',
    'SEMICOLON',
    'STRING',
    'EQ', 'LT', 'LTE', 'NEQ', 'GT', 'GTE',
    'LBRACK', 'RBRACK', 'COMMA', 'CONCAT', 'HASHTAG',
    'LCURL', 'RCURL', 'ASSIGN', 'SYMBOL',
    ] + list(reserved.values())

# Tokens
t_STRING = r'("(\\"|[^"])*")|(\'(\\\'|[^\'])*\')'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_SEMICOLON = r';'
t_EXPONENT = r'\*\*'
t_EQ = r'=='
t_LT = r'<'
t_LTE = r'<='
t_NEQ = r'<>'
t_GT = r'>'
t_GTE = r'>='
t_LBRACK = r'\['
t_RBRACK = r'\]'
t_COMMA = r'\,'
t_CONCAT = r'::'
t_HASHTAG = r'\#'
t_LCURL  = r'\{'
t_RCURL  = r'\}'
t_ASSIGN = r'='

def t_NUMBER(t):
    r'\d*(\d\.|\.\d)\d* | \d+'
    try:
        t.value = NumberNode(t.value)
    except ValueError:
        print("Integer value too large %d", t.value)
        t.value = 0 
    return t

def t_TRUE(t):
    r'True'
    t.value = BooleanNode(t.value)
    return t

def t_FALSE(t):
    r'False'
    t.value = BooleanNode(t.value)
    return t

def t_SYMBOL(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value, 'SYMBOL')
    if t.type=='SYMBOL':
        t.value = SymbolNode(t.value)
    return t

# Ignored characters
t_ignore = " \t\n"

def t_error(t):
    raise SyntaxError
    
# Build the lexer
import ply.lex as lex
lex.lex(errorlog=lex.NullLogger())

# Parsing rules
precedence = (
    ('right', 'ASSIGN'),
    ('left', 'PRINT'),
    ('left', 'ORELSE', 'ANDALSO'),
    ('left', 'NOT'),
    ('left', 'LT', 'LTE', 'EQ', 'NEQ', 'GT', 'GTE'),
    ('right', 'CONCAT'),
    ('left', 'IN'),
    ('left', 'PLUS','MINUS'),
    ('left', 'TIMES','DIVIDE','DIV','MOD'),
    ('right', 'EXPONENT'),
    ('left', 'LBRACK'),
    ('left', 'LPAREN'),
    ('right','UMINUS'),
    )

def p_block(t):
    '''
     block : LCURL statement_list RCURL
           | LCURL RCURL
    '''
    if len(t) == 4:
        t[0] = BlockNode(t[2])
    else:
        t[0] = BlockNode([])

def p_statement_list(t):
    '''
     statement_list : statement_list statement 
    '''
    t[0] = t[1] + [t[2]]

def p_statement_list_val(t):
    '''
    statement_list : statement
    '''
    t[0] = [t[1]]

def p_statement_block(t):
    '''
    statement : block
    '''
    t[0] = t[1]

def p_symbol_expression(t):
    '''
    expression : SYMBOL
    '''
    t[0] = t[1]

def p_print_statement(t) :
    '''
    statement : PRINT LPAREN expression RPAREN SEMICOLON
    '''
    t[0] = PrintNode(t[3])

def p_print_symbol(t) :
    '''
    statement : PRINT LPAREN SYMBOL RPAREN SEMICOLON
    '''
    t[0] = PrintNode(t[3])

def p_assignment_statement(t):
    '''statement : SYMBOL ASSIGN expression SEMICOLON'''
    t[0] = AssignmentNode(t[1],t[3])

def p_list_assign_statment(t):
    '''statement : SYMBOL LBRACK expression RBRACK ASSIGN expression SEMICOLON'''
    t[0] = AssignToListNode(t[1], t[3], t[6])

def p_list_assign_statment_two(t):
    '''statement : SYMBOL LBRACK expression RBRACK LBRACK expression RBRACK ASSIGN expression SEMICOLON'''
    t[0] = AssignToListSecondNode(t[1], t[3], t[6], t[9])

def p_if_statment(t):
    '''statement : IF LPAREN expression RPAREN block'''
    t[0] = IfNode(t[3], t[5])

def p_if_else_statment(t):
    '''statement : IF LPAREN expression RPAREN block ELSE block'''
    t[0] = IfElseNode(t[3], t[5], t[7])

def p_while_statment(t):
    '''statement : WHILE LPAREN expression RPAREN block'''
    t[0] = WhileNode(t[3], t[5])

def p_expression_binop(t):
    '''expression : expression PLUS expression 
                  | expression MINUS expression 
                  | expression DIV expression 
                  | expression TIMES expression 
                  | expression DIVIDE expression
                  | expression MOD expression
                  | expression EXPONENT expression'''
    t[0] = BopNode(t[2], t[1], t[3])

def p_expression_factor(t):
    '''expression : factor '''
    t[0] = t[1]

def p_expression_uminus(t):
    '''expression : MINUS expression %prec UMINUS'''
    t[0] = NegativeNode(t[2])

def p_expression_semicolon(t):
    '''expression : expression SEMICOLON '''
    t[0] = t[1]

def p_notEval(t):
    '''expression : NOT expression'''
    t[0] = NotNode(t[1],t[2])

def p_expression_boolean(t):
    '''expression : expression ANDALSO expression 
                  | expression ORELSE expression'''
    t[0] = BooleanExpression(t[2], t[1], t[3])

def p_paranthesis(t):
    '''expression : LPAREN expression RPAREN'''
    t[0] = t[2]

def p_EQ(t):
    '''expression : expression EQ expression
                  | expression LT expression 
                  | expression LTE expression 
                  | expression NEQ expression
                  | expression GT expression
                  | expression GTE expression
                  | expression IN expression'''
    t[0] = EQNode(t[2], t[1], t[3])

def p_list_expression(t):
    '''expression : LIST
                  | TUPLE'''
    t[0] = t[1]

def p_list(t):
    '''LIST : LBRACK in_list RBRACK'''
    t[0] = t[2]

def p_empty(t):
    '''expression : LBRACK RBRACK'''
    t[0] = EmptyListNode(t[0])

def p_in_list(t):
    '''in_list : expression'''
    t[0] = ListNode(t[1])

def p_in_list2(t):
    '''in_list : in_list COMMA expression'''
    t[1].v.append(t[3])
    t[0] = t[1]

def p_concat(t):
    '''expression : expression CONCAT expression'''
    t[3].v.insert(0,t[1])
    t[0] = t[3]

def p_concat_empty(t):
    '''expression : expression CONCAT LBRACK RBRACK'''
    t[0] = ListNode(t[1])

def p_index(t):
    '''expression : expression LBRACK expression RBRACK'''
    t[0] = IndexNode(t[1], t[3])

def p_tuple(t):
    '''TUPLE : LPAREN in_list RPAREN'''
    t[0] = TupleNode(t[2])

def p_emptyTup(t):
    '''TUPLE : LPAREN RPAREN'''
    t[0] = EmptyTupNode(t[0])

def p_indexTup(t):
    '''expression : HASHTAG expression TUPLE'''
    t[0] = IndexTupleNode(t[3], t[2])

def p_string(t):
    '''expression : STRING'''
    t[0] = StringNode(t[1][1:-1])

def p_boolean(t):
    '''expression : TRUE 
                  | FALSE'''
    t[0] = t[1]

def p_factor_number(t):
    '''factor : NUMBER'''
    t[0] = t[1]

def p_error(t):
    raise SyntaxError

import ply.yacc as yacc
yacc.yacc(errorlog=yacc.NullLogger())
import sys

if (len(sys.argv) != 2):
    sys.exit("invalid arguments")

try:
    with open(sys.argv[1], 'r') as myfile:
        data = myfile.read().replace('\n', '')
    lex.input(data)
    while True:
       token = lex.token()
       if not token: break
    root = yacc.parse(data)
    root.evaluate()
except SyntaxError:
    print("SYNTAX ERROR")

except Exception:
    print("SEMANTIC ERROR")