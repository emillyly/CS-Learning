# Emilly Ly
# 111097939
# Homework 3
import ply
import sys

error = False
reserved_table = dict()

class Node:
    def __init__(self):
        print('init node')

    def evaluate(self):
        return 0

    def execute(self):
        return 0

class ReservedNode(Node):
    def __init__(self, v):
        pass

    def evaluate(self):
        pass

class NumberNode(Node):
    def __init__(self, v):
        if('.' in v):
            self.value = float(v)
        else:
            self.value = int(v)

    def evaluate(self):
        return self.value

class StringNode(Node):
    def __init__(self, v):
        self.value = v[1:-1]

    def evaluate(self):
        return self.value

class BooleanNode(Node):
    def __init__ (self, v):
        self.v = v in ['True']

    def evaluate(self):
        return self.v

class ListNode(Node):
    def __init__(self, v):
        if not v:
            self.v = []
        else:
            self.v = [v]

    def evaluate(self):
        l = []
        if not self.v:
            return l
        for v in self.v:
            if(isinstance(v, list)):
                l.append([v[0].evaluate()])
            else:
                l.append(v.evaluate())
        return l

class TupleNode(Node):
    def __init__(self, v):
        if isinstance(v, tuple):
            self.v = ()
        else:
            self.v = [v]
    
    def evaluate(self):
        if not all(self.v):
            return self.v[0]
        l = []
        for v in self.v:
            l.append(v.evaluate())
        t = tuple(l)
        return t

class PrintNode(Node):
    def __init__(self, v):
        self.value = v

    def execute(self):
        self.value = self.value.evaluate()
        print(self.value)

class NotNode(Node):
    def __init__(self,op, v):
        self.op = op
        self.v = v

    def evaluate(self):
        if (self.op == 'not'):
            return not self.v.evaluate()

class UnaryOp(Node):
    def __init__(self, op, v1):
        self.op = op
        self.v1 = v1

    def evaluate(self):
        if(self.op == '-'):
            return -1 * self.v1

class BopNode(Node):
    def __init__(self, op, v1, v2):
        self.v1 = v1
        self.v2 = v2
        self.op = op

    def evaluate(self):
        value1 = self.v1.evaluate()
        value2 = self.v2.evaluate()

        if (self.op == '+'):
            if((isinstance(value1, (int, float)) and isinstance(value2, (int, float)))
                or (isinstance(value1, list) and isinstance(value2, list))
                or (isinstance(value1, str) and isinstance(value2, str))):    
                    return self.v1.evaluate() + self.v2.evaluate()
        
        if(isinstance(value1, (int, float)) and isinstance(value2, (int, float))):
            if (self.op == '-'):
                return self.v1.evaluate() - self.v2.evaluate()
            elif (self.op == '*'):
                return self.v1.evaluate() * self.v2.evaluate()
            elif (self.op == '/'):
                return self.v1.evaluate() / self.v2.evaluate()
            elif (self.op == 'div'):
                return self.v1.evaluate() // self.v2.evaluate()
            elif (self.op == 'mod'):
                return self.v1.evaluate() % self.v2.evaluate()
            elif (self.op == '**'):
                return self.v1.evaluate() ** self.v2.evaluate()
        
        if(isinstance(value1, bool) and isinstance(value2, bool)):
            if (self.op == 'andalso'):
                return value1 and value2 
            elif (self.op == 'orelse'):
                return value1 or value2 
        
        if((isinstance(value1, str) and isinstance(value2, str)) 
                or (isinstance(value1, (int, float)) and isinstance(value2, (int, float)))):
            if (self.op == '>'):
                return self.v1.evaluate() > self.v2.evaluate()
            elif (self.op == '>='):
                return self.v1.evaluate() >= self.v2.evaluate()
            elif (self.op == '<'):
                return self.v1.evaluate() < self.v2.evaluate()
            elif (self.op == '<='):
                return self.v1.evaluate() <= self.v2.evaluate()
            elif (self.op == '=='):
                return self.v1.evaluate() == self.v2.evaluate()
            elif (self.op == '<>'):
                return self.v1.evaluate() != self.v2.evaluate() 
        
        if(isinstance(value1, list) and isinstance(value2, int)
                or isinstance(value1, str) and isinstance(value2, int)):
            if (self.op == '['):
                if(isinstance(value1, str)):
                    return self.v1.evaluate()[self.v2.evaluate()]
                return self.v1.evaluate()[self.v2.evaluate()]
        
        if(isinstance(value2, (list, str)) and isinstance(value1, (int, float, str))):
            if(self.op == 'in'):
                return value1 in value2
        
        if(isinstance(value1, (str, int, float, bool, list)) and isinstance(value2, (list))):
            if(self.op == '::'):
                value2.insert(0, value1)
                return value2

        if(isinstance(value1, tuple) and isxinstance(value2, int)):
            if(self.op == '#'):
                return value1[value2-1] 

tokens = (
    'NUMBER',
    'EXPONENT', 'TIMES', 'DIVIDE', 'FLOORDIV',
    'STRING',
    'LPAREN', 'RPAREN','LBRACKET', 'RBRACKET',
    'TRUE', 'FALSE',
    'HASHTAG', 'EMPTYTUPLE',
    'MODULUS', 'PLUS', 'MINUS',
    'IN',
    'CONS',
    'GT', 'GTE',
    'LT', 'LTE',
    'NEQ', 'EQ',
    'NOT',
    'AND',
    'OR', 
    'SEMICOLON','COMMA',
    'RESERVED',
)

reserved  = {
    'True' : 'TRUE',
    'False' : 'FALSE', 
    'div' : 'FLOORDIV', 
    'mod' : 'MODULUS', 
    'in' : 'IN', 
    'not' : 'NOT', 
    'andalso' : 'AND', 
    'orelse' : 'OR'
}

t_STRING = r'("(\\"|[^"])*")|(\'(\\\'|[^\'])*\')'
t_LPAREN = r'\('
t_RPAREN = r'\)'
t_LBRACKET = r'\['
t_RBRACKET = r'\]'
t_HASHTAG = r'\#'
t_EXPONENT = r'\*\*'
t_TIMES = r'\*'
t_DIVIDE = r'/'
t_PLUS = r'\+'
t_MINUS = r'-'
t_CONS = r'::'
t_GT = r'>'
t_GTE = r'>='
t_LT = r'<'
t_LTE = r'<='
t_EQ = r'=='
t_NEQ = r'<>'
t_SEMICOLON = r';'
t_COMMA = r','

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

def t_EMPTYTUPLE(t):
    r'\(\)'
    mytup = ()
    t.value = TupleNode(mytup)
    return t

def t_RESERVED(t):
    r'[A-Za-z][A-Za-z0-9_]*'
    t.type = reserved.get(t.value, 'RESERVED')
    if t.type=='RESERVED':
        t.value = ReservedNode(t.value)
    return t

# Ignored characters
t_ignore = " \t\n"

def t_error(t):
    t.lexer.skip(1)
    if(error):
        raise SyntaxError
    
# Build the lexer
import ply.lex as lex
lex.lex(debug = 0)

precedence = (
    ('left', 'OR'),
    ('left', 'AND'),
    ('left', 'NOT'),
    ('left','LT','GT','LTE','GTE','EQ','NEQ'),
    ('right', 'CONS'),
    ('left', 'IN'),
    ('left', 'PLUS', 'MINUS'),
    ('left', 'TIMES', 'DIVIDE', 'FLOORDIV', 'MODULUS'),
    ('right', 'EXPONENT'),
    ('left', 'LBRACKET'),
    ('left', 'HASHTAG'),
    ('right', 'UMINUS')
)

def p_print_smt(t):
    """
    print_smt : expression SEMICOLON
    """
    t[0] = PrintNode(t[1])

def p_expression_factor(t):
    '''expression : boolean
                  | string
                  | list
                  | factor
                  | tuple
                  | RESERVED
    '''
    t[0] = t[1]

def p_expression_binop(t):
    '''expression : string PLUS string
                  | expression AND expression
                  | expression OR expression
                  | expression IN expression
                  | expression CONS expression
                  '''
    if(isinstance(t[3], list)):
        t[3] = ListNode(t[3][0])
    t[0] = BopNode(t[2], t[1], t[3])

def p_expression_compare(t):
    '''boolean : expression LT expression 
            | expression GT expression
            | expression LTE expression
            | expression GTE expression
            | expression EQ expression
            | expression NEQ expression
    '''
    t[0] = BopNode(t[2], t[1], t[3])

def p_expression_binop_num(t):
    '''expression : expression PLUS expression
                  | expression MINUS expression
                  | expression TIMES expression
                  | expression DIVIDE expression
                  | expression MODULUS expression
                  | expression FLOORDIV expression
                  | expression EXPONENT expression
    '''
    t[0] = BopNode(t[2], t[1], t[3])

def p_expression_group(t):
    '''expression : LPAREN expression RPAREN'''
    t[0] = t[2]

def p_not(t):
    '''boolean : NOT expression'''
    t[0] = NotNode(t[1],t[2])

def p_indexing(t):
    '''expression : expression LBRACKET expression RBRACKET '''
    t[0] = BopNode(t[2], t[1], t[3])

def p_tup_indexing(t):
    '''expression : HASHTAG expression expression'''
    t[0] = BopNode(t[1], t[3], t[2])

def p_empty_tuple(t):
    '''tuple : EMPTYTUPLE'''
    t[0] = t[1]

# Not Functional
# def p_tuple(t):
#     '''tuple : LPAREN in_tuple RPAREN'''
#     t[0] = t[2]

# def p_in_tuple2(t):
#     '''in_tuple : expression COMMA in_tuple'''
#     t[3].v.insert(0, t[1])
#     t[0] = t[3]

# def p_in_tuple(t):
#     '''in_tuple : expression'''
#     t[0] = TupNode(t[1]) 

def p_empty_list(t):
    '''list : LBRACKET RBRACKET'''
    t[0] = ListNode([])

def p_list_bracket(t):
    '''member : bracket'''
    t[0] = ListNode(t[1])

def p_list(t):
    '''list : LBRACKET member RBRACKET'''
    t[0] = t[2]

def p_bracket(t):
    '''bracket : LBRACKET expression RBRACKET'''
    t[0] = ListNode(t[2])

def p_member2(t):
    '''member : expression COMMA member'''
    t[3].v.insert(0, t[1])
    t[0] = t[3]

def p_member(t):
    '''member : expression'''
    t[0] = ListNode(t[1])

def p_unaryneg(t):
    '''factor : MINUS factor %prec UMINUS'''
    t[0] = NumberNode(str(-1 * t[2].evaluate()))

def p_bool(t):
    '''boolean : TRUE
            | FALSE
    '''
    t[0] = t[1]

def p_string(t):
    '''string : STRING'''
    t[0] = StringNode(t[1])

def p_factor_number(t):
    '''factor : NUMBER'''
    t[0] = t[1]

def p_error(t):
    if(error):
        raise SyntaxError()

import ply.yacc as yacc
import sys
yacc.yacc()

if (len(sys.argv) != 2):
    sys.exit("invalid arguments")
fd = open(sys.argv[1], 'r')
code = ""

try:
    for line in fd:
        lex.input(line)
        ast = yacc.parse(line)
        ast.execute()

except SyntaxError:
    print("SYNTAX ERROR")

except Exception:
    print("SEMANTIC ERROR")