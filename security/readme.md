### Linux syscall tables

HaoE says they are normally (used to be) in /usr/include/asm-i386/unistd.h

On Ubuntu 14.04 systems, they are in:

/usr/include/x86_64-linux-gnu/asm/unistd_32.h
/usr/include/x86_64-linux-gnu/asm/unistd_64.h

### To turn ASLR on and off

'''
/proc/sys/kernel/randomize_va_space
'''

0 = no randomization
1 = conservative randomization.  shared libraries, stack, mmap(), and heap are randomized
2 = full randomization

### How to control stack cookies

Compile with -fno-stack-protector

### How to control DEP (data execution prevention)

Compile with -z execstack

### Intel vs ATT syntax

For gdb, set syntax:
'''
set disassembly-flavor intel
'''

ATT:

mov %eax, %edx
instruction source, dest

Intel:

mov edx, eax
instruction dest, source

Compare (Intel) goes left to right

* BYTE = 8 bits = char
* WORD = 16 bits = short
* DWORD = 32-bits = int
* QWORD = 64-bit = long long

* .text = program instructions
* .data = initialized global variables
* .bss = uninitialized global variables

eax usually holds return value on x86

ebp (base pointer) - offset = local variables
ebp (base pointer) + offset = function arguement passed on stack

if conditions are actually the opposite for assembly.  if (x>y) becomes cmp x, y, followed by jle 
(less than or equal).  Basically, if the condition fails, we are going to jump over the code in the
if block.

## GDB Cheatsheet

set disassembly-flavor intel

### Examine command

* x/o = examine in octal
* x/x = examine in hexadecimal
* x/u = examine in unsigned base-10 decimal
* x/t = examine in binary
* x/s = examine as string
* x/i = examine instructions

* x with b = examine bytes
* x with h = half-words (16-bit)
* x with w = word (32-bit)
* x with g = giant (64-bit)

#### Examples

* x/8xb $eip = examine 8 bytes at EIP address (in hex)
* x/4xw addr = examine 4 32-bit words at address (in hex)

