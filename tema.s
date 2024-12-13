.data
v: .space 4096
i: .long 0
j: .long 0
formatRead: .asciz "%d"
formatWrite: .asciz "%d\n"
formatWriteArr: .asciz "%d "
newLine: .asciz "\n"
nrOperatii: .space 4
cod: .long 0
nrFisiere: .space 4
descriptor: .space 4
dimensiune: .space 4
nrBlocuri: .space 4
inputError: .asciz "Eroare citire \n "
chkWrite: .asciz "Aici a ajuns\n"
cat: .space 4
rest: .space 4
interval_i: .long 0
writeCanNotAdd: .asciz "%d: "
write1: .asciz "%d: ("
write2: .asciz "%d, "
write3: .asciz "%d)\n"
canAdd: .long 0
aux: .long 0
writeG: .asciz "(%d, "
get_i: .long 0
zerozero: .asciz "(0, 0)\n"
lastNonZero: .long 0
added: .long 0
.text

add:

pushl %ebp
mov %esp, %ebp

;#cin>>nrFisiere

pushl $nrFisiere
pushl $formatRead
call scanf
popl %ebx
popl %ebx

movl $0, i

whileNrFisiere:
;#while(nrFisiere)
movl nrFisiere, %ecx
cmp $0, %ecx
je closeAdd

;#cin>>descriptor

pushl $descriptor
pushl $formatRead
call scanf
popl %ebx
popl %ebx

;#cin>>dimensiune

pushl $dimensiune
pushl $formatRead
call scanf
popl %ebx
popl %ebx


;#nrFisiere--

subl $1, nrFisiere

;#nrBlocuri = dimensiune / 8

movl $0, %edx
movl $0, %eax
movl dimensiune, %eax
movl $8, %ecx

divl %ecx
movl %eax, nrBlocuri

movl $0, added

cmp $0, %edx
je for1
addl $1, nrBlocuri

movl $0, i

for1:

;#for(i=0; i<1024; i++)

movl i, %ecx
movl $1024, %edx
subl nrBlocuri, %edx
addl $1, %edx
;#bool canAdd = true

movl $1, canAdd
movl $0, aux
cmp %ecx, %edx
je canNotAdd

movl i, %ecx  ;#j=i
movl %ecx, j

movl (%edi, %ecx, 4), %eax
cmp $0, %eax
je forj
addl $1, i
jmp for1

forj:

;#for(j=i; j< i + nrBlocuri; j++)
movl j, %ecx
movl i, %edx
addl nrBlocuri, %edx

cmp %ecx, %edx
je verifCanAdd

addl $1, j

;#if(v[j]!=0)
movl (%edi, %ecx, 4), %eax
cmp $0, %eax
je forj

movl $0, canAdd  ;#canAdd = false
jmp verifCanAdd  ;#break


verifCanAdd:
movl canAdd, %ebx
cmp $0, %ebx  ;#if(canAdd)
je canAddFalse


movl i, %eax
movl %eax, j

movl descriptor, %eax
pushl %eax
pushl $write1
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

addDesc:

movl j, %ecx
movl i, %edx
addl nrBlocuri, %edx
cmp %ecx, %edx  ;# pana ecx = i + nrBlocuri 
je writeAdd

movl descriptor, %eax
movl %eax, (%edi, %ecx, 4)


addl $1, j
jmp addDesc

writeAdd:

movl j, %ecx
subl nrBlocuri, %ecx
pushl %ecx
pushl $write2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

movl j, %ecx
subl $1, %ecx
pushl %ecx
pushl $write3
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

movl $0, i

movl $1, added

jmp canNotAdd

canAddFalse:

addl $1, i
jmp canNotAdd

canNotAdd:
movl added, %eax
cmp $0, %eax
jne whileNrFisiere

pushl descriptor
pushl $writeCanNotAdd
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

pushl $zerozero
call printf
popl %ebx

pushl $0
call fflush
popl %ebx

jmp whileNrFisiere

closeAdd:

popl %ebp
ret

get:
pushl %ebp
mov %esp, %ebp


pushl $descriptor   ;#cin>>descriptor
pushl $formatRead
call scanf
popl %ebx
popl %ebx

movl $0, i    ;#int aux=0, get_i = 0
movl $0, aux
movl $0, get_i
forGet:

movl i, %ecx   ;#for(int i = 0; i<1000; i++)
movl $1024, %edx
cmp %ecx, %edx
je coutGet

movl descriptor, %eax

cmp %eax, (%edi, %ecx, 4)    ;# if( v[i] == descriptor)
je coutGet

addl $1, aux     ;# aux++
movl i, %ecx
movl %ecx, get_i    ;# get_i = i
addl $1, i          ;# i++
jmp forGet

coutGet:
movl get_i, %ecx

cmp $0, %ecx
je coutGetZeroCase
addl $1, get_i

movl get_i, %ecx

cmp $1024, %ecx
je descNotFound

movl get_i, %ecx  ;# cout<< (get_i ;
pushl %ecx
pushl $writeG
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

jmp verifGet

coutGetZeroCase:


movl get_i, %ecx  ;# cout<< (get_i ;
pushl %ecx
pushl $writeG
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

verifGet:
movl get_i, %ecx
movl (%edi, %ecx, 4), %eax
cmp %eax, 4(%edi, %ecx, 4)
jne coutGet2


addl $1, aux
addl $1, get_i
jmp verifGet

coutGet2:

movl get_i, %ecx

pushl %ecx
pushl $write3
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

jmp closeGet

descNotFound:

pushl $zerozero
call printf
popl %ebx

pushl $0
call fflush
popl %ebx

closeGet:
popl %ebp
ret

delete:
pushl %ebp
mov %esp, %ebp

pushl $descriptor
pushl $formatRead
call scanf
popl %ebx
popl %ebx


movl $0, i
movl $0, j

forDelete:
movl i, %ecx
movl $1024, %edx
cmp %ecx, %edx
je forDelete2

addl $1, i
movl descriptor, %eax

cmp %eax, (%edi, %ecx, 4)
jne forDelete

movl $0, (%edi, %ecx, 4)

jmp forDelete

coutArray:

movl j, %ecx
movl $1024, %edx
cmp %ecx, %edx
je closeDelete

movl (%edi, %ecx, 4), %eax
pushl %eax
pushl $formatWriteArr
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

addl $1, j
jmp coutArray

forDelete2:

movl j, %ecx     ;#for( int j=0; j<1024; j++)
movl $1024, %edx
cmp %ecx, %edx
je closeDelete

movl (%edi, %ecx, 4), %eax

cmp $0, %eax    ;#if(v[i]!=0)
je skipZeroDelete

pushl %eax
pushl $write1
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

pushl j
pushl $write2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

jmp verifDelete

skipZeroDelete:
addl $1, j
jmp forDelete2

verifDelete:
movl j, %ecx
movl (%edi, %ecx, 4), %eax
movl 4(%edi, %ecx, 4), %edx
cmp %eax, %edx    ;# iesire din while daca v[j]!=v[j+1]
jne coutDelete4

addl $1, j
cmp $1024, %ecx
je coutDelete4


jmp verifDelete

coutDelete4:

pushl %ecx    ;#cout<< j)
pushl $write3
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

addl $1, j
jmp forDelete2

closeDelete:
popl %ebp
ret


defrag:

pushl %ebp
mov %esp, %ebp

movl $0, i
movl $0, j
movl $0, lastNonZero

startDefrag:

movl i, %ecx         ;#for( int i =0; i<1024; i++)
movl $1024, %edx
cmp %ecx, %edx
je writeDefrag

addl $1, i

movl (%edi, %ecx, 4), %eax
cmp $0, %eax                   ;#if( v[i] != 0 )
je noSwap


movl lastNonZero, %ebx             ;#swap( v[lastNonzero], v[i])
movl (%edi, %ebx, 4), %edx
movl %edx, (%edi, %ecx, 4)
movl %eax, (%edi, %ebx, 4)
addl $1, lastNonZero               ;#swap( v[lastNonZero], v[i])


jmp startDefrag


noSwap:

jmp startDefrag


writeDefrag:

movl j, %ecx     ;#for( int j=0; j<1024; j++)
movl $1024, %edx
cmp %ecx, %edx
je closeDefrag

movl (%edi, %ecx, 4), %eax

cmp $0, %eax    ;#if(v[i]!=0)
je skipZeroDelete

pushl %eax
pushl $write1
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

pushl j
pushl $write2
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

jmp verifDefrag

skipZeroDefrag:
addl $1, j
jmp writeDefrag

verifDefrag:
movl j, %ecx
movl (%edi, %ecx, 4), %eax
movl 4(%edi, %ecx, 4), %edx
cmp %eax, %edx    ;# iesire din while daca v[j]!=v[j+1]
jne coutDefrag

addl $1, j
cmp $1024, %ecx
je coutDefrag


jmp verifDefrag

coutDefrag:

pushl %ecx    ;#cout<< j)
pushl $write3
call printf
popl %ebx
popl %ebx

pushl $0
call fflush
popl %ebx

addl $1, j
jmp writeDefrag


closeDefrag:

popl %ebp
ret

.global main

main:

lea v, %edi

pushl $nrOperatii
pushl $formatRead
call scanf
popl %ebx
popl %ebx

whileNrOp:

movl nrOperatii, %ecx
cmp $0, %ecx
je close

pushl $cod
pushl $formatRead
call scanf
popl %ebx
popl %ebx

movl cod, %eax

subl $1, nrOperatii
movl cod, %eax

cmp $1, %eax
je callAdd

cmp $2, %eax
je callGet

cmp $3, %eax
je callDelete

cmp $4, %eax
je callDefrag

jmp whileNrOp

callAdd:

call add
jmp whileNrOp

callGet:

call get
jmp whileNrOp

callDelete:

call delete
jmp whileNrOp

callDefrag:

call defrag
jmp whileNrOp

close:

mov $1, %eax
xor %ebx, %ebx
int $0x80