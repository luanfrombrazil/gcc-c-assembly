.text
.globl func
func:
	pushl %ebp
	movl %esp, %ebp
	subl $0, %esp

	movl 8(%ebp), %eax
	addl 12(%ebp), %eax
	addl 16(%ebp), %eax

	movl %ebp, %esp
	popl %ebp
ret
