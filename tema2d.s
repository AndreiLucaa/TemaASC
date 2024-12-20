.data
l: .long 0
indexMatrice: .long 0
v: .space 16777216
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

pushl nrBlocuri
pushl $formatWrite
call printf
popl %ebx
popl %ebx

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
je gasitZero

addl $1, j
movl i, %ebx
jmp forj

gasitZero:

movl $1, canAdd          ;#canAdd = 1
movl k, %ecx 		;#for(k = 0; k< nrBlocuri; k++)
movl nrBlocuri, %edx
cmp %ecx, %edx
jle verifCanAdd

movl $0, %eax
movl $1024, %eax
mull %ebx
addl %ecx, %eax
addl j, %eax

addl $1, k

movl (%edi, %eax, 4), %eax

cmp $0, %eax
je gasitZero

movl $0, canAdd
jmp verifCanAdd

verifCanAdd:
movl canAdd, %ecx
cmp $0, %ecx
je forj

movl l, %ecx
movl nrBlocuri, %edx
cmp %ecx, %edx
jle added1

movl $0, %eax
movl $1024, %eax
mull %ebx
addl l, %eax
addl j, %eax

movl descriptor, %ecx

movl %ecx, (%edi, %eax, 4)

addl $1, l
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

closeAdd:

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

jmp whileNrOp

callAdd:

call add

jmp whileNrOp

close:

pushl $0
call fflush
popl %eax

mov $1, %eax
xorl %ebx, %ebx
int $0x80