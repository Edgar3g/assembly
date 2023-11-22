;
;  Aula de Assembly Para o PIC
;
; 
;  Sub-Rotina Para Divisão 
;
;  Divide dois numeros (A0 e B0) e armazena o resultado em C0
;
;  Sistema Embarcado Sugerido: PARADOXUS PEPTO
; 
;  Disponivel em https//workits.com.br/catalog/show/141
;  
;  Clock 4MHz    ciclo de máquina = 1
;    
;  Professora Elsa Salombue
;
;
 
; --- Listagem do Processador Utilizado ---     
     list p=16F628A                                ;Utilizado pic16F628A
;
;  
; --- Arquivos incluídos no projeto ---
     #include <p16F628a.inc>                        ; inclui o arquivo do PIC16F628A

 
; --- FUSE Bits ---
; - Cristal de 4MHz
; - Desabilitamos Watch Dog Timer
; - Habilitamos Power Up Timer
; - Brown out desabilitado
; - Sem programacao em baixa tensão, sem proteção de código, sem proteção de memória
   __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CP_OFF & _CPD_OFF & _MCLRE_OFF
;
; 
; --- Paginação de Memória ---
   #define		bank0		bcf	STATUS,RP0		;Cria um mnemônico para o banco 0 de memória
   #define		bank1		bsf STATUS,RP0		;Cria um mnemônico para o banco 1 de memória


; --- Registradores de Uso Geral ---
   cblock   H'20'			                    ;Inicio da memória disponivel para usuario
   
   A0                                           ;armazena o conteudo de um dos numeros
   B0                                           ;armazena o conteudo de um dos numeros  
   C0                                           ;ayte menos significativo do resultado
   

  endc                                          ; final da memória do usuario


; --- Vetor de RESET ---
  org			H'0000'				;Origem no endereço 00h de memória
  goto		    inicio				;Desvia do vetor de interrupção 
  
  
; --- Vetor de Interrupção ---
  org			H'0004'				;As interrupções deste processador
  retfie							;Retorna de interrupção


  inicio:
      bank0                         ;seleciona o banco 0 de memória
      movlw    H'07'                ; w = 7h
      movwf    CMCON                ;CMCON =7h (apenas I/Os digitais)
      bank1                         ;seleciona o banco 1 de memória
      movlw    H'00'                ;w = 00h
      movwf    OPTION_REG           ; habilita registradores de pull-up int
      bank0                         ;seleciona o banco 0 de memória
			
	  movlw	  D'156'	            ;carrega o numero em w 
	  movwf   A0                    ;A0 = numero
	  movlw   D'13'                 ;carrega o numero em w
	  movwf   B0                    ;B0 = numero
	  call    div                   ;chama a sub-rotina de multiplicação
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
         goto    div_loop         ;retorna para novo ciclo de subtração
         
 div_menor:  
     
  incf            C0,F             ; se dividendo menor que zero incrementa      
        return                    ;retorna
        
        
        
        end                       ; final do programa
        
        