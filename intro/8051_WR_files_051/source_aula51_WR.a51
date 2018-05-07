; --- Mapeamento de Hardware (PARADOXUS 8051) ---
         rs      equ     P1.5    ;Reg Select ligado em P1.7
         rw      equ     P1.6    ;Read/Write ligado em P1.6
         en      equ     P1.7    ;Enable ligado em P1.5
         dat     equ     P2      ;Bits de dados em todo P2

        org     0000h           ;origem no endereço 00h de memória
        acall   delay500ms      ;aguarda 500ms para estabilizar

inicio:
        acall   lcd_init        ;Chama sub rotina de inicialização 
        mov     dptr,#LCD1      ;Move mensagem para DPTR
        acall   send_lcd        ;Chama sub rotina para enviar mensagem para LCD
        ajmp    $               ;Prende programa aqui

lcd_init:                       ;Sub Rotina para Inicialização do Display 
        mov      a,#60d         ;move literal 00111100b para acc
        acall    config         ;chama sub rotina config
        mov      a,#14d         ;move literal 00001110b para acc
        acall    config         ;chama sub rotina config
        mov      a,#1d          ;move literal 00000001b para acc
        acall    config         ;chama sub rotina config
        mov      a,#6d          ;move literal 00000110b para acc
        acall    config         ;chama sub rotina config
        ret                     ;retorna

config:                         ;Sub Rotina de Configuração
        clr      en             ;limpa pino en
        clr      rs             ;limpa pino rs
        clr      rw             ;limpa pino rw
        acall    wait           ;aguarda 55us
        setb     en             ;aciona enable
        acall    wait           ;aguarda 55us
        mov      dat,a          ;carrega dados em Port P2
        acall    wait           ;aguarda 55us com barramento igual ao valor de acc
        clr      en             ;limpa pino en
        acall    wait           ;aguarda 55us
        ret                     ;retorna

send_lcd:                       ;Sub Rotina para Enviar dados ao LCD
        mov      R0,#0d         ;Move valor 0d para R0

send:
        mov      a,R0           ;Move conteúdo de R0 para acc
        inc      R0             ;Incrementa acc
        movc     a,@a+dptr      ;Move o byte relativo de dptr somado
                                ;com o valor de acc para acc
        acall    w_dat          ;chama sub rotina para escrita de dados
        cjne     R0,#16d,send   ;compara R0 com valor de colunas e desvia se for diferente
        ret                     ;retorna

;================================================================================
w_dat:                          ;Sub Rotina para preparar para escrita de mensagem

        clr      en             ;limpa enable
        setb     rs             ;seta rs
        clr      rw             ;limpa rw (escrita)
        acall    wait           ;aguarda 55us
        setb     en             ;seta enable
        acall    wait           ;aguarda 55us
        mov      dat,a          ;carrega mensagem
        acall    wait           ;aguarda 55us
        clr      en             ;limpa enable
        acall    wait           ;aguarda 55us
        ret                     ;retorna
  
;================================================================================
;write_lcd:                      ;Sub Rotina para Escrita de mensagem
  
;        clr      en             ;limpa en
;        mov      rs,c           ; reg datos (1)  control (0)
;        clr      rw
;        setb     en
;        mov      dat,a
;        clr      en
;        acall    delay500ms
;        ret

;================================================================================
wait:                           ;Sub Rotina para atraso de 55us

        mov     R5,#055d        ;Carrega 55d em R5
aux0:           
        djnz    R5,aux0         ;Decrementa R5. R5 igual a zero? Não, desvia para aux
        ret                     ;Sim, retorna


delay500ms:                     ;Sub Rotina para atraso de 500ms
                                ; 2       | ciclos de máquina do mnemônico call
        mov     R1,#0fah        ; 1       | move o valor 250 decimal para o registrador R1
 
aux1:
        mov     R2,#0f9h        ; 1 x 250 | move o valor 249 decimal para o registrador R2
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250
        nop                     ; 1 x 250

aux2:
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250
        nop                     ; 1 x 250 x 249 = 62250

        djnz    R2,aux2         ; 2 x 250 x 249 = 124500     | decrementa o R2 até chegar a zero
        djnz    R1,aux1         ; 2 x 250                    | decrementa o R1 até chegar a zero

        ret                     ; 2                          | retorna para a função main
                                ;------------------------------------
                                ; Total = 500005 us ~~ 500 ms = 0,5 seg 


;================================================================================
; Definição de Mensagens para Enviar ao LCD
LCD1:
        db    '  PARADOXUS 8051'


        end                     ;Final do programa
  
  
  
  
  
  
  
  
  
  
  