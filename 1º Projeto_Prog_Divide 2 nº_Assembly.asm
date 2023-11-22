;
;  Aula de Assembly Para o PIC
;
; 
;  Sub-Rotina Para Divis�o 
;
;  Divide dois numeros (A0 e B0) e armazena o resultado em C0
;
;  Sistema Embarcado Sugerido: PARADOXUS PEPTO
; 
;  Disponivel em https//workits.com.br/catalog/show/141
;  
;  Clock 4MHz    ciclo de m�quina = 1
;    
;  Professora Elsa Salombue
;
;
 
; --- Listagem do Processador Utilizado ---     
     list p=16F628A                                ;Utilizado pic16F628A
;
;  
; --- Arquivos inclu�dos no projeto ---
     #include <p16F628a.inc>                        ; inclui o arquivo do PIC16F628A

 
; --- FUSE Bits ---
; - Cristal de 4MHz
; - Desabilitamos Watch Dog Timer
; - Habilitamos Power Up Timer
; - Brown out desabilitado
; - Sem programacao em baixa tens�o, sem prote��o de c�digo, sem prote��o de mem�ria
   __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
;
; 
; --- Pagina��o de Mem�ria ---
   #define		bank0		bcf	STATUS,RP0		;Cria um mnem�nico para o banco 0 de mem�ria
   #define		bank1		bsf STATUS,RP0		;Cria um mnem�nico para o banco 1 de mem�ria


; --- Registradores de Uso Geral ---
   cblock   H'20'			                    ;Inicio da mem�ria disponivel para usuario
   
   A0                                           ;armazena o conteudo de um dos numeros
   B0                                           ;armazena o conteudo de um dos numeros  
   C0                                           ;ayte menos significativo do resultado
   

  endc                                          ; final da mem�ria do usuario


; --- Vetor de RESET ---
  org			H'0000'				;Origem no endere�o 00h de mem�ria
  goto		    inicio				;Desvia do vetor de interrup��o 
  
  
; --- Vetor de Interrup��o ---
  org			H'0004'				;As interrup��es deste processador
  retfie							;Retorna de interrup��o


  inicio:
      bank0                         ;seleciona o banco 0 de mem�ria
      movlw    H'07'                ; w = 7h
      movwf    CMCON                ;CMCON =7h (apenas I/Os digitais)
      bank1                         ;seleciona o banco 1 de mem�ria
      movlw    H'00'                ;w = 00h
      movwf    OPTION_REG           ; habilita registradores de pull-up int
      bank0                         ;seleciona o banco 0 de mem�ria
			
	  movlw	  D'156'	            ;carrega o numero em w 
	  movwf   A0                    ;A0 = numero
	  movlw   D'13'                 ;carrega o numero em w
	  movwf   B0                    ;B0 = numero
	  call    div                   ;chama a sub-rotina de multiplica��o
	                                ;retornara  - <C1:C0> = A0 x B0 
	                                
	                                
	
     goto	  $                    ; prenda o programa nesta linha
     
     
 ; --- Desenvolvimento das Sub-Rotinas Auxiliares ---
    div:
    
    clrf      C0                   ; limpa registrador C0
    
    
    div_loop:
    
         movf    B0,W             ;copia divisor para w
         subwf   A0,F             ; subtrai divisor B0 do dividendo A0 
         btfss 	 STATUS,C		  ; testa para ver se hove carry
         goto    div_menor        ;dividendo menor que zero, desvia para
         incf    C0,F             ; se dividendo maior que zero incrementa	
         goto    div_loop         ;retorna para novo ciclo de subtra��o
         
 div_menor:  
     
  incf            C0,F             ; se dividendo menor que zero incrementa      
        return                    ;retorna
        
        
        
        end                       ; final do programa
        
        