.data
found: .long 0
l: .long 0
indexMatrice: .long 0
v: .space 4194304
nrMax: .long 1048576
i: .long 0
j: .long 0
k: .long 0
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
write1: .asciz "%d: (("
write2: .asciz "%d, "
write3: .asciz "%d), "
write4: .asciz "(%d, "
write5: .asciz "%d))\n"
coutZero: .asciz "%d: ((0, 0), (0, 0))\n"
coutZeroget: .asciz "((0, 0), (0, 0))\n"
canAdd: .long 0
aux: .long 0
writeG: .asciz "((%d, "
get_i: .long 0
zerozero: .asciz "(0, 0)\n"
lastNonZero: .long 0
added: .long 0
printEndl: .asciz "%d\n"

.text

printMemory:

pushl %ebp
mov %esp, %ebp

lea v, %edi

movl $0, i
movl $0, j

for1:

;# for( int i = 0; i< 1024; i++)

movl i, %ebx
movl nrMax, %edx
cmp %ebx, %edx
je closePrintMem


movl (%edi, %ebx, 4), %eax
cmp $0, %eax
je skipZero

pushl %eax
pushl $write1
call printf
popl %ebx
popl %ebx

movl $1024, %ecx
movl $0, %edx
movl i, %eax
divl %ecx

movl %eax, cat
movl %edx, rest

pushl cat
pushl $write2
call printf
popl %ebx
popl %ebx

pushl rest
pushl $write3
call printf
popl %ebx
popl %ebx

jmp verifPrint

verifPrint:

movl $0, %eax
movl $0, %ecx
movl $0, %edx
movl i, %ebx

movl (%edi, %ebx, 4), %eax
movl 4(%edi, %ebx, 4), %ecx

cmp %eax, %ecx
jne coutRest

addl $1, i

jmp verifPrint


coutRest:

movl $1024, %ecx
movl $0, %edx
movl i, %eax
divl %ecx

movl %eax, cat
movl %edx, rest

pushl cat
pushl $write4
call printf
popl %ebx
popl %ebx

pushl rest
pushl $write5
call printf
popl %ebx
popl %ebx


addl $1, i
jmp for1

skipZero:

addl $1, i
jmp for1

closePrintMem:

popl %ebp
ret

writeArray:
pushl %ebp
mov %esp, %ebp



movl $0, i
movl $0, j

writeArr:
movl i, %ecx
movl $1024, %edx
cmp %ecx, %edx
jle closeWriteArr
movl $0, %eax
movl (%edi, %ecx, 4), %eax

pushl %eax
pushl $formatWriteArr
call printf
popl %ebx
popl %ebx


addl $1, i
jmp writeArr

closeWriteArr:

popl %ebp
ret

add:

pushl %ebp
mov %esp, %ebp

lea v, %edi

;#cin>>nrFisiere

pushl $nrFisiere
pushl $formatRead
call scanf
popl %ebx
popl %ebx

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
movl $0, i
movl $0, j
movl $0, k
movl $0, l


cmp $0, %edx
je fori
addl $1, nrBlocuri

movl $0, i

fori:

movl i, %ebx    ;#for(int i = 0 ; i< 1024; i++)
movl $1024, %edx

cmp %ebx, %edx
je coutZeroZero


jmp forj

forj:
movl $0, k
movl j, %ecx          ;#for(j = 0; j<1024 -nrBlocuri +1; j++)
movl $1024, %edx
subl nrBlocuri, %edx
addl $1, %edx
cmp %ecx, %edx
jle inclI

movl $0, %eax
addl $1024, %eax
mull %ebx
addl %ecx, %eax


movl (%edi, %eax, 4), %eax

cmp $0, %eax                 ;#if (v[i][j] == 0)
je gasitZero1

addl $1, j                   ;#j++
movl i, %ebx
jmp forj

gasitZero1:

movl $1, canAdd         ;#canAdd = 1

gasitZero2:

movl k, %ecx 		;#for(k = 0; k< nrBlocuri; k++)
movl nrBlocuri, %edx
cmp %ecx, %edx
je verifCanAdd

movl $0, %eax
movl $1024, %eax
mull %ebx
addl k, %eax
addl j, %eax

addl $1, k

movl (%edi, %eax, 4), %eax

cmp $0, %eax              ;#if( v[i][j+k] != 0)
je gasitZero2

movl $0, canAdd           ;#canAdd = 0
jmp verifCanAdd 	  ;#break

verifCanAdd:
movl canAdd, %ecx
cmp $0, %ecx		;#if(canAdd)
je canAddFalse

movl l, %ecx		;#for( int l = 0; l< nrBlocuri; l++)
movl nrBlocuri, %edx
cmp %ecx, %edx
je added1

movl $0, %eax
movl $1024, %eax
mull %ebx
addl l, %eax
addl j, %eax

movl descriptor, %ecx

movl %ecx, (%edi, %eax, 4)	;#v[i][j+l] = descriptor

addl $1, l			;#l++
jmp verifCanAdd

added1:

movl $1, added
jmp verifAdded

verifAdded:
movl added, %eax
cmp $0, %eax
je inclI

jmp coutDescriptor

coutDescriptor:

pushl descriptor
pushl $write1
call printf
popl %ebx
popl %ebx

pushl i
pushl $write2
call printf
popl %ebx
popl %ebx

pushl j
pushl $write3
call printf
popl %ebx
popl %ebx

pushl i
pushl $write4
call printf
popl %ebx
popl %ebx

movl j, %ecx
addl nrBlocuri, %ecx
subl $1, %ecx
movl %ecx, j

pushl j
pushl $write5
call printf
popl %ebx
popl %ebx

jmp whileNrFisiere

coutZeroZero:

pushl descriptor
pushl $coutZero
call printf
popl %ebx
popl %ebx

jmp whileNrFisiere

inclI:

movl $0, j
movl $0, k
movl $0, l
addl $1, i

jmp fori

canAddFalse:

addl $1, j
jmp forj

closeAdd:

popl %ebp
ret

get:

pushl %ebp
mov %esp, %ebp

lea v, %edi

pushl $descriptor
pushl $formatRead
call scanf
popl %ebx
popl %ebx

movl $0, i
movl $0, j
movl $0, found
forGetI:

lea v, %edi

movl i, %ebx
movl $1024, %edx

cmp %ebx, %edx
jle coutZeroGet

forGetJ:

movl j, %ecx
movl $1024, %edx
cmp %ecx, %edx
jle inclGet

movl $0, %eax
movl $1024, %eax
mull %ebx
addl %ecx, %eax

movl descriptor, %ecx
cmp %ecx, (%edi, %eax, 4)
je coutGet

addl $1, j
jmp forGetJ

coutGet:

pushl i
pushl $writeG
call printf
popl %ebx
popl %ebx

pushl j
pushl $write3
call printf
popl %ebx
popl %ebx

addl $1, j

compDesc:
xorl %eax, %eax
movl i, %ebx
movl $0, %eax
movl $1024, %eax
mull %ebx
addl j, %eax

movl descriptor, %ecx
cmp %ecx, (%edi, %eax, 4)
jne coutGet2

addl $1, j

jmp compDesc

coutGet2:

pushl i
pushl $write4
call printf
popl %ebx
popl %ebx

subl $1, j

pushl j
pushl $write5
call printf
popl %ebx
popl %ebx

jmp closeGet

coutZeroGet:

pushl $coutZeroget
call printf
popl %ebx


jmp closeGet

inclGet:


addl $1, i
movl $0, j
movl $0, %eax
movl $0, %ebx
movl $0, %ecx
movl $0, %edx
jmp forGetI

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

forDeleteI:

lea v, %edi

movl i, %ebx
movl $1024, %edx

cmp %ebx, %edx
jle closeDelete

forDeleteJ:

movl j, %ecx
movl $1024, %edx
cmp %ecx, %edx
jle inclDelete

movl $0, %eax
movl $1024, %eax
mull %ebx
addl %ecx, %eax

movl descriptor, %ecx
cmp %ecx, (%edi, %eax, 4)
je addZero

addl $1, j

jmp forDeleteJ

addZero:

xorl %eax, %eax
movl i, %ebx
movl $0, %eax
movl $1024, %eax
mull %ebx
addl j, %eax

movl descriptor, %ecx

cmp %ecx, (%edi, %eax, 4)
jne closeDelete

movl $0, (%edi, %eax, 4)

addl $1, j

jmp addZero

inclDelete:

addl $1, i
movl $0, j

jmp forDeleteI

closeDelete:

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

jmp whileNrOp

callAdd:

call add

jmp whileNrOp

callGet:

call get

jmp whileNrOp

callDelete:

call delete
call printMemory
jmp whileNrOp

close:

pushl $0
call fflush
popl %eax

mov $1, %eax
xorl %ebx, %ebx
int $0x80