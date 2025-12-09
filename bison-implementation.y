%{
    #include <stdio.h>
    void yyerror(const char *s){}
    int yylex(void);
%}
%token tPLUS tMINUS	tMUL tEXP tLPR tRPR tASSIGN tCOMMA	tSEMICOLON tDERIVATION tINTEGRATION	tCALCULATE tIDENTIFIER tINTEGER

%%
input: definition_block calculation_block;

definition_block: tIDENTIFIER tLPR variables tRPR tASSIGN ordinary_expression tSEMICOLON definition_block
                |
;

variables: 
        |tIDENTIFIER more_variables
;

more_variables:
            | tCOMMA tIDENTIFIER more_variables
;

ordinary_expression: ordinary_expression tPLUS term
                |   ordinary_expression tMINUS term
                |   term
;

term:  term expo
    | term tMUL expo
    | expo
;

expo: tIDENTIFIER tEXP tINTEGER
    | tINTEGER tEXP tINTEGER
    | tINTEGER
    | tIDENTIFIER
    | tLPR ordinary_expression tRPR
;

calculation_block: tCALCULATE extended_expression tSEMICOLON calculation_block
                 |
;

extended_expression: extended_expression tPLUS multi
                | extended_expression tMINUS multi
                | multi
;

multi: multi factor
    | multi tMUL factor
    | factor
;

factor: tINTEGER
       | tINTEGER tEXP tINTEGER
       | tLPR comma_extended tRPR
       | tINTEGRATION tLPR tIDENTIFIER tCOMMA tIDENTIFIER tCOMMA tINTEGER tRPR
       | tDERIVATION tLPR tIDENTIFIER tCOMMA tIDENTIFIER tCOMMA tINTEGER tRPR 
       | tIDENTIFIER tEXP tINTEGER
       | tIDENTIFIER 
;

comma_extended: 
            | extended_expression more_comma
;

more_comma: 
        | tCOMMA extended_expression more_comma
;

%%
int main ()
{
    if (yyparse()){
    // parse error
    printf("ERROR\n");
    return 1;
    }
    else{
    // successful parsing
    printf("OK\n");
    return 0;
    }
}
