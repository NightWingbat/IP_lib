
v
Command: %s
53*	vivadotcl2E
1synth_design -top sync_fifo -part xc7a35tcsg324-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7a35t2default:defaultZ17-349h px� 
�
%s*synth2�
rStarting Synthesize : Time (s): cpu = 00:00:00 ; elapsed = 00:00:01 . Memory (MB): peak = 431.461 ; gain = 97.500
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2
	sync_fifo2default:default2
 2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
502default:default8@Z8-6157h px� 
b
%s
*synth2J
6	Parameter INPUT_WIDTH bound to: 128 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter OUTPUT_WIDTH bound to: 16 - type: integer 
2default:defaulth p
x
� 
`
%s
*synth2H
4	Parameter WR_DEPTH bound to: 1024 - type: integer 
2default:defaulth p
x
� 
`
%s
*synth2H
4	Parameter RD_DEPTH bound to: 8192 - type: integer 
2default:defaulth p
x
� 
[
%s
*synth2C
/	Parameter MODE bound to: FWFT - type: string 
2default:defaulth p
x
� 
_
%s
*synth2G
3	Parameter DIRECTION bound to: MSB - type: string 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter ECC_MODE bound to: no_ecc - type: string 
2default:defaulth p
x
� 
g
%s
*synth2O
;	Parameter PROG_EMPTY_THRESH bound to: 10 - type: integer 
2default:defaulth p
x
� 
f
%s
*synth2N
:	Parameter PROG_FULL_THRESH bound to: 10 - type: integer 
2default:defaulth p
x
� 
h
%s
*synth2P
<	Parameter USE_ADV_FEATURES bound to: 16'b0001111100011111 
2default:defaulth p
x
� 
Y
%s
*synth2A
-	Parameter DW bound to: 128 - type: integer 
2default:defaulth p
x
� 
W
%s
*synth2?
+	Parameter PW bound to: 8 - type: integer 
2default:defaulth p
x
� 
\
%s
*synth2D
0	Parameter RAM_NUM bound to: 8 - type: integer 
2default:defaulth p
x
� 
_
%s
*synth2G
3	Parameter RAM_WIDTH bound to: 16 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter RAM_DEPTH bound to: 1024 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter RAM_WR_WIDTH bound to: 128 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter RAM_RD_WIDTH bound to: 128 - type: integer 
2default:defaulth p
x
� 
�
synthesizing module '%s'%s4497*oasys2
DPRAM2default:default2
 2default:default2I
3f:/FPGA_Project/IP_lib/user/src/memory/FIFO/DPRAM.v2default:default2
412default:default8@Z8-6157h px� 
[
%s
*synth2C
/	Parameter WIDTH bound to: 16 - type: integer 
2default:defaulth p
x
� 
]
%s
*synth2E
1	Parameter DEPTH bound to: 1024 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
DPRAM2default:default2
 2default:default2
12default:default2
12default:default2I
3f:/FPGA_Project/IP_lib/user/src/memory/FIFO/DPRAM.v2default:default2
412default:default8@Z8-6155h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[2].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[3].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[4].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[5].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[6].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[7].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[8].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys21
RD_GRAY_COUNTER[9].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys22
RD_GRAY_COUNTER[10].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys22
RD_GRAY_COUNTER[11].rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3252default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2!
rd_ptr_d1_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2682default:default8@Z8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2

rd_ptr_reg2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2802default:default8@Z8-6014h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
	sync_fifo2default:default2
 2default:default2
22default:default2
12default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
502default:default8@Z8-6155h px� 
�
+design %s has port %s driven by constant %s3447*oasys2
	sync_fifo2default:default2
sbiterr2default:default2
02default:defaultZ8-3917h px� 
�
+design %s has port %s driven by constant %s3447*oasys2
	sync_fifo2default:default2
dbiterr2default:default2
02default:defaultZ8-3917h px� 
�
%s*synth2�
sFinished Synthesize : Time (s): cpu = 00:00:00 ; elapsed = 00:00:02 . Memory (MB): peak = 487.223 ; gain = 153.262
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
~Finished Constraint Validation : Time (s): cpu = 00:00:00 ; elapsed = 00:00:02 . Memory (MB): peak = 487.223 ; gain = 153.262
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Loading part: xc7a35tcsg324-1
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
Loading part %s157*device2#
xc7a35tcsg324-12default:defaultZ21-403h px� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:00 ; elapsed = 00:00:02 . Memory (MB): peak = 487.223 ; gain = 153.262
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
}HDL ADVISOR - The operator resource <%s> is shared. To prevent sharing consider applying a KEEP on the output of the operator4233*oasys2
adder2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
6582default:default8@Z8-5818h px� 
�
}HDL ADVISOR - The operator resource <%s> is shared. To prevent sharing consider applying a KEEP on the output of the operator4233*oasys2
adder2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
6712default:default8@Z8-5818h px� 
�
}HDL ADVISOR - The operator resource <%s> is shared. To prevent sharing consider applying a KEEP on the output of the operator4233*oasys2

multiplier2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
6712default:default8@Z8-5818h px� 
|
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2 
almost_empty2default:defaultZ8-5546h px� 
�
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys25
!ALMOST_FULL_ENABLE.almost_full_d12default:defaultZ8-5546h px� 
~
?The signal %s was recognized as a true dual port RAM template.
3473*oasys2
ram_reg2default:defaultZ8-3971h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:01 ; elapsed = 00:00:02 . Memory (MB): peak = 487.223 ; gain = 153.262
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     14 Bit       Adders := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   3 Input     11 Bit       Adders := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     11 Bit       Adders := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit         XORs := 45    
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               16 Bit    Registers := 16    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               14 Bit    Registers := 2     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                9 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 7     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	              16K Bit         RAMs := 8     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     16 Bit        Muxes := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     14 Bit        Muxes := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     11 Bit        Muxes := 3     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 5     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Y
%s
*synth2A
-Start RTL Hierarchical Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Hierarchical RTL Component report 
2default:defaulth p
x
� 
>
%s
*synth2&
Module sync_fifo 
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     14 Bit       Adders := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   3 Input     11 Bit       Adders := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     11 Bit       Adders := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit         XORs := 45    
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               14 Bit    Registers := 2     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                9 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                8 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 7     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     16 Bit        Muxes := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     14 Bit        Muxes := 4     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     11 Bit        Muxes := 3     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input      1 Bit        Muxes := 5     
2default:defaulth p
x
� 
:
%s
*synth2"
Module DPRAM 
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               16 Bit    Registers := 2     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	              16K Bit         RAMs := 1     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
[
%s
*synth2C
/Finished RTL Hierarchical Component Statistics
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2j
VPart Resources:
DSPs: 90 (col length:60)
BRAMs: 100 (col length: RAMB18 60 RAMB36 30)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
]
%s
*synth2E
1Warning: Parallel synthesis criteria is not met 
2default:defaulth p
x
� 
�
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys25
!ALMOST_FULL_ENABLE.almost_full_d12default:defaultZ8-5546h px� 
|
8ROM "%s" won't be mapped to RAM because it is too sparse3998*oasys2 
almost_empty2default:defaultZ8-5546h px� 
�
+design %s has port %s driven by constant %s3447*oasys2
	sync_fifo2default:default2
sbiterr2default:default2
02default:defaultZ8-3917h px� 
�
+design %s has port %s driven by constant %s3447*oasys2
	sync_fifo2default:default2
dbiterr2default:default2
02default:defaultZ8-3917h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[0].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[1].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[2].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[3].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[4].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[5].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[6].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
+Unused sequential element %s was removed. 
4326*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[7].u_DPRAM/ram_reg2default:defaultZ8-6014h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[2]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[3]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[3]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[4]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[4]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[5]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[5]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[6]2default:defaultZ8-3886h px� 
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default2)
\rd_ptr_next_reg[13] 2default:defaultZ8-3333h px� 
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default2$
\wr_ptr_reg[10] 2default:defaultZ8-3333h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[6]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[7]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[7]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[8]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[8]2default:default2
FDCE2default:default2%
rd_ptr_pre_reg[9]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2%
rd_ptr_pre_reg[9]2default:default2
FDCE2default:default2&
rd_ptr_pre_reg[10]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2&
rd_ptr_pre_reg[10]2default:default2
FDCE2default:default2&
rd_ptr_pre_reg[11]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2&
rd_ptr_pre_reg[11]2default:default2
FDCE2default:default2&
rd_ptr_pre_reg[12]2default:defaultZ8-3886h px� 
�
"merging instance '%s' (%s) to '%s'3436*oasys2&
rd_ptr_pre_reg[12]2default:default2
FDCE2default:default2&
rd_ptr_pre_reg[13]2default:defaultZ8-3886h px� 
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default22
\OVERFLOW_ENABLE.overflow_reg 2default:defaultZ8-3333h px� 
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default2;
'\ALMOST_FULL_ENABLE.almost_full_d1_reg 2default:defaultZ8-3333h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[8]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[7]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[6]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[5]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[4]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[3]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2#
wr_ptr_reg[2]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
2262default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2)
rd_ptr_next_reg[11]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2)
rd_ptr_next_reg[10]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[9]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[8]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[7]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[6]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[5]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[4]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[3]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
1st2default:default2(
rd_ptr_next_reg[2]/Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
2multi-driven net on pin %s with %s driver pin '%s'4707*oasys2
Q2default:default2
2nd2default:default2
GND2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6859h px� 
�
rmulti-driven net %s is connected to at least one constant driver which has been preserved, other driver is ignored4706*oasys2
Q2default:default2M
7f:/FPGA_Project/IP_lib/user/src/memory/FIFO/sync_fifo.v2default:default2
3082default:default8@Z8-6858h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.285 ; gain = 299.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
e
%s*synth2M
9
Block RAM: Preliminary Mapping  Report (see note below)
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|Module Name | RTL Object | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth px� 
�
%s*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth px� 
�
%s*synth2�
�Note: The table above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
2default:defaulth px� 
�
%s*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP and Shift Register Reporting
2default:defaulth px� 
~
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[0].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_0/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[0].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[1].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_1/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[1].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[2].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_2/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[2].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[3].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_4/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[3].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[4].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_5/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[4].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[5].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2M
9i_8/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[5].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[6].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2N
:i_10/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[6].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
PSwapped enable and write-enable on %s RAM instances of RAM %s to conserve power
3784*oasys2
12default:default2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[7].u_DPRAM/ram_reg2default:defaultZ8-4652h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2N
:i_12/BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[7].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Timing Optimization : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.285 ; gain = 299.324
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Start ROM, RAM, DSP and Shift Register Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
N
%s
*synth26
"
Block RAM: Final Mapping  Report
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|Module Name | RTL Object | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�|DPRAM:      | ram_reg    | 1 K x 16(READ_FIRST)   | W | R | 1 K x 16(READ_FIRST)   | W | R | Port A and B     | 1      | 0      | 
2default:defaulth p
x
� 
�
%s
*synth2�
�+------------+------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

2default:defaulth p
x
� 
�
%s
*synth2�
�---------------------------------------------------------------------------------
Finished ROM, RAM, DSP and Shift Register Reporting
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[0].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[1].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[2].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[3].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[4].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[5].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[6].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
�
�The timing for the instance %s (implemented as a %s RAM) might be sub-optimal as no optional output register could be merged into the block ram. Providing additional output register may help in improving timing.
4693*oasys2I
5BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[7].u_DPRAM/ram_reg2default:default2
Block2default:defaultZ8-6837h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
{Finished Technology Mapping : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
uFinished IO Insertion : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
D
%s
*synth2,

Report Check Netlist: 
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
u
%s
*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth p
x
� 
u
%s
*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-

Report RTL Partitions: 
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
W
%s
*synth2?
++-+--------------+------------+----------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|      |Cell     |Count |
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
F
%s*synth2.
|1     |BUFG     |     1|
2default:defaulth px� 
F
%s*synth2.
|2     |CARRY4   |     5|
2default:defaulth px� 
F
%s*synth2.
|3     |LUT1     |     1|
2default:defaulth px� 
F
%s*synth2.
|4     |LUT2     |    20|
2default:defaulth px� 
F
%s*synth2.
|5     |LUT3     |    10|
2default:defaulth px� 
F
%s*synth2.
|6     |LUT4     |     9|
2default:defaulth px� 
F
%s*synth2.
|7     |LUT5     |     5|
2default:defaulth px� 
F
%s*synth2.
|8     |LUT6     |    68|
2default:defaulth px� 
F
%s*synth2.
|9     |RAMB18E1 |     8|
2default:defaulth px� 
F
%s*synth2.
|10    |FDCE     |    21|
2default:defaulth px� 
F
%s*synth2.
|11    |FDPE     |     2|
2default:defaulth px� 
F
%s*synth2.
|12    |IBUF     |   132|
2default:defaulth px� 
F
%s*synth2.
|13    |OBUF     |    79|
2default:defaulth px� 
F
%s*synth2.
+------+---------+------+
2default:defaulth px� 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
� 
x
%s
*synth2`
L+------+--------------------------------------------------+--------+------+
2default:defaulth p
x
� 
x
%s
*synth2`
L|      |Instance                                          |Module  |Cells |
2default:defaulth p
x
� 
x
%s
*synth2`
L+------+--------------------------------------------------+--------+------+
2default:defaulth p
x
� 
x
%s
*synth2`
L|1     |top                                               |        |   361|
2default:defaulth p
x
� 
x
%s
*synth2`
L|2     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[0].u_DPRAM  |DPRAM   |     2|
2default:defaulth p
x
� 
x
%s
*synth2`
L|3     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[1].u_DPRAM  |DPRAM_0 |     1|
2default:defaulth p
x
� 
x
%s
*synth2`
L|4     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[2].u_DPRAM  |DPRAM_1 |    17|
2default:defaulth p
x
� 
x
%s
*synth2`
L|5     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[3].u_DPRAM  |DPRAM_2 |     1|
2default:defaulth p
x
� 
x
%s
*synth2`
L|6     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[4].u_DPRAM  |DPRAM_3 |     1|
2default:defaulth p
x
� 
x
%s
*synth2`
L|7     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[5].u_DPRAM  |DPRAM_4 |    17|
2default:defaulth p
x
� 
x
%s
*synth2`
L|8     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[6].u_DPRAM  |DPRAM_5 |     1|
2default:defaulth p
x
� 
x
%s
*synth2`
L|9     |  \BIG_TO_SMALL_RAM.B2S_DUAL_PORT_RAM[7].u_DPRAM  |DPRAM_6 |    17|
2default:defaulth p
x
� 
x
%s
*synth2`
L+------+--------------------------------------------------+--------+------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
t
%s
*synth2\
HSynthesis finished with 0 errors, 51 critical warnings and 24 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
~Synthesis Optimization Runtime : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth p
x
� 
�
%s
*synth2�
Synthesis Optimization Complete : Time (s): cpu = 00:00:01 ; elapsed = 00:00:04 . Memory (MB): peak = 633.879 ; gain = 299.918
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
f
-Analyzing %s Unisim elements for replacement
17*netlist2
132default:defaultZ29-17h px� 
j
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
727.3322default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
602default:default2
242default:default2
512default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:00:022default:default2
00:00:082default:default2
727.3322default:default2
406.2702default:defaultZ17-268h px� 
~
4The following parameters have non-default value.
%s
395*common2&
general.maxThreads2default:defaultZ17-600h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
727.3322default:default2
0.0002default:defaultZ17-268h px� 
K
"No constraints selected for write.1103*constraintsZ18-5210h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2Y
Ef:/FPGA_Project/IP_lib/prj/xilinx/template.runs/synth_1/sync_fifo.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2|
hExecuting : report_utilization -file sync_fifo_utilization_synth.rpt -pb sync_fifo_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Thu Oct 10 21:13:25 20242default:defaultZ17-206h px� 


End Record