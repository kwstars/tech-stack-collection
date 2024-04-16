# 定义一个目标（target）叫做 cli
# 使用 gcc 编译器，优化级别为 O2，启用调试信息（-g），输出文件名为目标名（$@），输入文件为依赖文件列表的第一个文件（$<）
cli: cli.c
	gcc -O2 -g -o $@ $<

NAME := cli
SRCS := cli.c
export ARCH := x86_64-qemu

-include $(AM_HOME)/Makefile

debug:
	qemu-system-x86_64 -s -S -machine accel=tcg -smp "1,sockets=1" \
		-drive format=raw,file=build/cli-x86_64-qemu &
	gdb -x debug.py
