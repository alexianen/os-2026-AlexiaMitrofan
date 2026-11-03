
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	44813103          	ld	sp,1096(sp) # 8000a448 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae4f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de678793          	addi	a5,a5,-538 # 80000e5e <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	1dc020ef          	jal	800022f8 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7c2000ef          	jal	800008ea <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00012517          	auipc	a0,0x12
    80000198:	2fc50513          	addi	a0,a0,764 # 80012490 <cons>
    8000019c:	24d000ef          	jal	80000be8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00012497          	auipc	s1,0x12
    800001a4:	2f048493          	addi	s1,s1,752 # 80012490 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00012917          	auipc	s2,0x12
    800001ac:	38090913          	addi	s2,s2,896 # 80012528 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	748010ef          	jal	80001908 <myproc>
    800001c4:	7b5010ef          	jal	80002178 <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	54f010ef          	jal	80001f1a <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	29f000ef          	jal	80000c70 <release>
      sleep();
    800001d6:	581010ef          	jal	80001f56 <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	20d000ef          	jal	80000be8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00012717          	auipc	a4,0x12
    800001f2:	2a270713          	addi	a4,a4,674 # 80012490 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	08c020ef          	jal	800022ac <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	25850513          	addi	a0,a0,600 # 80012490 <cons>
    80000240:	231000ef          	jal	80000c70 <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	2cf72523          	sw	a5,714(a4) # 80012528 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00012517          	auipc	a0,0x12
    80000278:	21c50513          	addi	a0,a0,540 # 80012490 <cons>
    8000027c:	1f5000ef          	jal	80000c70 <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6d6000ef          	jal	80000970 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6c8000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6c0000ef          	jal	80000970 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ba000ef          	jal	80000970 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00012517          	auipc	a0,0x12
    800002cc:	1c850513          	addi	a0,a0,456 # 80012490 <cons>
    800002d0:	119000ef          	jal	80000be8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	08f48d63          	beq	s1,a5,80000370 <consoleintr+0xb4>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48263          	beq	s1,a5,800003c4 <consoleintr+0x108>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49363          	bne	s1,a5,800003ec <consoleintr+0x130>
  case C('P'): // Print process list.
    procdump();
    800002ea:	05a020ef          	jal	80002344 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00012517          	auipc	a0,0x12
    800002f2:	1a250513          	addi	a0,a0,418 # 80012490 <cons>
    800002f6:	17b000ef          	jal	80000c70 <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0af48e63          	beq	s1,a5,800003c4 <consoleintr+0x108>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00012717          	auipc	a4,0x12
    80000310:	18470713          	addi	a4,a4,388 # 80012490 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48563          	beq	s1,a5,800003f2 <consoleintr+0x136>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00012717          	auipc	a4,0x12
    80000336:	15e70713          	addi	a4,a4,350 # 80012490 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	c371                	beqz	a4,8000041a <consoleintr+0x15e>
    80000358:	14f1                	addi	s1,s1,-4
    8000035a:	c0e1                	beqz	s1,8000041a <consoleintr+0x15e>
    8000035c:	00012717          	auipc	a4,0x12
    80000360:	1cc72703          	lw	a4,460(a4) # 80012528 <cons+0x98>
    80000364:	9f99                	subw	a5,a5,a4
    80000366:	08000713          	li	a4,128
    8000036a:	f8e792e3          	bne	a5,a4,800002ee <consoleintr+0x32>
    8000036e:	a075                	j	8000041a <consoleintr+0x15e>
    80000370:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000372:	00012717          	auipc	a4,0x12
    80000376:	11e70713          	addi	a4,a4,286 # 80012490 <cons>
    8000037a:	0a072783          	lw	a5,160(a4)
    8000037e:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000382:	00012497          	auipc	s1,0x12
    80000386:	10e48493          	addi	s1,s1,270 # 80012490 <cons>
    while (cons.e != cons.w &&
    8000038a:	4929                	li	s2,10
    8000038c:	02f70863          	beq	a4,a5,800003bc <consoleintr+0x100>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000390:	37fd                	addiw	a5,a5,-1
    80000392:	07f7f713          	andi	a4,a5,127
    80000396:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    80000398:	01874703          	lbu	a4,24(a4)
    8000039c:	03270263          	beq	a4,s2,800003c0 <consoleintr+0x104>
      cons.e--;
    800003a0:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a4:	10000513          	li	a0,256
    800003a8:	ee3ff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003ac:	0a04a783          	lw	a5,160(s1)
    800003b0:	09c4a703          	lw	a4,156(s1)
    800003b4:	fcf71ee3          	bne	a4,a5,80000390 <consoleintr+0xd4>
    800003b8:	6902                	ld	s2,0(sp)
    800003ba:	bf15                	j	800002ee <consoleintr+0x32>
    800003bc:	6902                	ld	s2,0(sp)
    800003be:	bf05                	j	800002ee <consoleintr+0x32>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003c4:	00012717          	auipc	a4,0x12
    800003c8:	0cc70713          	addi	a4,a4,204 # 80012490 <cons>
    800003cc:	0a072783          	lw	a5,160(a4)
    800003d0:	09c72703          	lw	a4,156(a4)
    800003d4:	f0f70de3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003d8:	37fd                	addiw	a5,a5,-1
    800003da:	00012717          	auipc	a4,0x12
    800003de:	14f72b23          	sw	a5,342(a4) # 80012530 <cons+0xa0>
      consputc(BACKSPACE);
    800003e2:	10000513          	li	a0,256
    800003e6:	ea5ff0ef          	jal	8000028a <consputc>
    800003ea:	b711                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003ec:	f00481e3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f0:	bf31                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003f2:	4529                	li	a0,10
    800003f4:	e97ff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003f8:	00012797          	auipc	a5,0x12
    800003fc:	09878793          	addi	a5,a5,152 # 80012490 <cons>
    80000400:	0a07a703          	lw	a4,160(a5)
    80000404:	0017069b          	addiw	a3,a4,1
    80000408:	8636                	mv	a2,a3
    8000040a:	0ad7a023          	sw	a3,160(a5)
    8000040e:	07f77713          	andi	a4,a4,127
    80000412:	97ba                	add	a5,a5,a4
    80000414:	4729                	li	a4,10
    80000416:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000041a:	00012797          	auipc	a5,0x12
    8000041e:	10c7a923          	sw	a2,274(a5) # 8001252c <cons+0x9c>
        wakeup(&cons.r);
    80000422:	00012517          	auipc	a0,0x12
    80000426:	10650513          	addi	a0,a0,262 # 80012528 <cons+0x98>
    8000042a:	35d010ef          	jal	80001f86 <wakeup>
    8000042e:	b5c1                	j	800002ee <consoleintr+0x32>

0000000080000430 <consoleinit>:

void
consoleinit(void)
{
    80000430:	1141                	addi	sp,sp,-16
    80000432:	e406                	sd	ra,8(sp)
    80000434:	e022                	sd	s0,0(sp)
    80000436:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000438:	00007597          	auipc	a1,0x7
    8000043c:	bc858593          	addi	a1,a1,-1080 # 80007000 <etext>
    80000440:	00012517          	auipc	a0,0x12
    80000444:	05050513          	addi	a0,a0,80 # 80012490 <cons>
    80000448:	720000ef          	jal	80000b68 <initlock>

  uartinit();
    8000044c:	448000ef          	jal	80000894 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000450:	00022797          	auipc	a5,0x22
    80000454:	3c878793          	addi	a5,a5,968 # 80022818 <devsw>
    80000458:	00000717          	auipc	a4,0x0
    8000045c:	d2070713          	addi	a4,a4,-736 # 80000178 <consoleread>
    80000460:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000462:	00000717          	auipc	a4,0x0
    80000466:	c7470713          	addi	a4,a4,-908 # 800000d6 <consolewrite>
    8000046a:	ef98                	sd	a4,24(a5)
}
    8000046c:	60a2                	ld	ra,8(sp)
    8000046e:	6402                	ld	s0,0(sp)
    80000470:	0141                	addi	sp,sp,16
    80000472:	8082                	ret

0000000080000474 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000474:	7139                	addi	sp,sp,-64
    80000476:	fc06                	sd	ra,56(sp)
    80000478:	f822                	sd	s0,48(sp)
    8000047a:	f04a                	sd	s2,32(sp)
    8000047c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    8000047e:	c219                	beqz	a2,80000484 <printint+0x10>
    80000480:	08054163          	bltz	a0,80000502 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000484:	4301                	li	t1,0

  i = 0;
    80000486:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000048a:	86ca                	mv	a3,s2
  i = 0;
    8000048c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000048e:	00007817          	auipc	a6,0x7
    80000492:	35a80813          	addi	a6,a6,858 # 800077e8 <digits>
    80000496:	88ba                	mv	a7,a4
    80000498:	0017061b          	addiw	a2,a4,1
    8000049c:	8732                	mv	a4,a2
    8000049e:	02b577b3          	remu	a5,a0,a1
    800004a2:	97c2                	add	a5,a5,a6
    800004a4:	0007c783          	lbu	a5,0(a5)
    800004a8:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004ac:	87aa                	mv	a5,a0
    800004ae:	02b55533          	divu	a0,a0,a1
    800004b2:	0685                	addi	a3,a3,1
    800004b4:	feb7f1e3          	bgeu	a5,a1,80000496 <printint+0x22>

  if (sign)
    800004b8:	00030c63          	beqz	t1,800004d0 <printint+0x5c>
    buf[i++] = '-';
    800004bc:	fe060793          	addi	a5,a2,-32
    800004c0:	00878633          	add	a2,a5,s0
    800004c4:	02d00793          	li	a5,45
    800004c8:	fef60423          	sb	a5,-24(a2)
    800004cc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d0:	02e05463          	blez	a4,800004f8 <printint+0x84>
    800004d4:	f426                	sd	s1,40(sp)
    800004d6:	377d                	addiw	a4,a4,-1
    800004d8:	00e904b3          	add	s1,s2,a4
    800004dc:	197d                	addi	s2,s2,-1
    800004de:	993a                	add	s2,s2,a4
    800004e0:	1702                	slli	a4,a4,0x20
    800004e2:	9301                	srli	a4,a4,0x20
    800004e4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004e8:	0004c503          	lbu	a0,0(s1)
    800004ec:	d9fff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f0:	14fd                	addi	s1,s1,-1
    800004f2:	ff249be3          	bne	s1,s2,800004e8 <printint+0x74>
    800004f6:	74a2                	ld	s1,40(sp)
}
    800004f8:	70e2                	ld	ra,56(sp)
    800004fa:	7442                	ld	s0,48(sp)
    800004fc:	7902                	ld	s2,32(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
    x = -xx;
    80000502:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80000506:	4305                	li	t1,1
    x = -xx;
    80000508:	bfbd                	j	80000486 <printint+0x12>

000000008000050a <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    8000050a:	7131                	addi	sp,sp,-192
    8000050c:	fc86                	sd	ra,120(sp)
    8000050e:	f8a2                	sd	s0,112(sp)
    80000510:	f0ca                	sd	s2,96(sp)
    80000512:	0100                	addi	s0,sp,128
    80000514:	892a                	mv	s2,a0
    80000516:	e40c                	sd	a1,8(s0)
    80000518:	e810                	sd	a2,16(s0)
    8000051a:	ec14                	sd	a3,24(s0)
    8000051c:	f018                	sd	a4,32(s0)
    8000051e:	f41c                	sd	a5,40(s0)
    80000520:	03043823          	sd	a6,48(s0)
    80000524:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80000528:	0000a797          	auipc	a5,0xa
    8000052c:	f3c7a783          	lw	a5,-196(a5) # 8000a464 <panicking>
    80000530:	cf9d                	beqz	a5,8000056e <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000532:	00840793          	addi	a5,s0,8
    80000536:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000053a:	00094503          	lbu	a0,0(s2)
    8000053e:	22050663          	beqz	a0,8000076a <printk+0x260>
    80000542:	f4a6                	sd	s1,104(sp)
    80000544:	ecce                	sd	s3,88(sp)
    80000546:	e8d2                	sd	s4,80(sp)
    80000548:	e4d6                	sd	s5,72(sp)
    8000054a:	e0da                	sd	s6,64(sp)
    8000054c:	fc5e                	sd	s7,56(sp)
    8000054e:	f862                	sd	s8,48(sp)
    80000550:	f06a                	sd	s10,32(sp)
    80000552:	ec6e                	sd	s11,24(sp)
    80000554:	4a01                	li	s4,0
    if (cx != '%') {
    80000556:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    8000055a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    8000055e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000562:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000566:	4b29                	li	s6,10
    if (c0 == 'd') {
    80000568:	06400b93          	li	s7,100
    8000056c:	a015                	j	80000590 <printk+0x86>
    acquire(&pr.lock);
    8000056e:	00012517          	auipc	a0,0x12
    80000572:	fca50513          	addi	a0,a0,-54 # 80012538 <pr>
    80000576:	672000ef          	jal	80000be8 <acquire>
    8000057a:	bf65                	j	80000532 <printk+0x28>
      consputc(cx);
    8000057c:	d0fff0ef          	jal	8000028a <consputc>
      continue;
    80000580:	84d2                	mv	s1,s4
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000582:	2485                	addiw	s1,s1,1
    80000584:	8a26                	mv	s4,s1
    80000586:	94ca                	add	s1,s1,s2
    80000588:	0004c503          	lbu	a0,0(s1)
    8000058c:	1c050663          	beqz	a0,80000758 <printk+0x24e>
    if (cx != '%') {
    80000590:	ff3516e3          	bne	a0,s3,8000057c <printk+0x72>
    i++;
    80000594:	001a079b          	addiw	a5,s4,1
    80000598:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    8000059a:	00f90733          	add	a4,s2,a5
    8000059e:	00074a83          	lbu	s5,0(a4)
    if (c0)
    800005a2:	200a8963          	beqz	s5,800007b4 <printk+0x2aa>
      c1 = fmt[i + 1] & 0xff;
    800005a6:	00174683          	lbu	a3,1(a4)
    if (c1)
    800005aa:	1e068c63          	beqz	a3,800007a2 <printk+0x298>
    if (c0 == 'd') {
    800005ae:	037a8863          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b2:	f94a8713          	addi	a4,s5,-108
    800005b6:	00173713          	seqz	a4,a4
    800005ba:	f9c68613          	addi	a2,a3,-100
    800005be:	ee05                	bnez	a2,800005f6 <printk+0xec>
    800005c0:	cb1d                	beqz	a4,800005f6 <printk+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	addi	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4605                	li	a2,1
    800005d0:	85da                	mv	a1,s6
    800005d2:	6388                	ld	a0,0(a5)
    800005d4:	ea1ff0ef          	jal	80000474 <printint>
      i += 1;
    800005d8:	002a049b          	addiw	s1,s4,2
    800005dc:	b75d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005de:	f8843783          	ld	a5,-120(s0)
    800005e2:	00878713          	addi	a4,a5,8
    800005e6:	f8e43423          	sd	a4,-120(s0)
    800005ea:	4605                	li	a2,1
    800005ec:	85da                	mv	a1,s6
    800005ee:	4388                	lw	a0,0(a5)
    800005f0:	e85ff0ef          	jal	80000474 <printint>
    800005f4:	b779                	j	80000582 <printk+0x78>
      c2 = fmt[i + 2] & 0xff;
    800005f6:	97ca                	add	a5,a5,s2
    800005f8:	8636                	mv	a2,a3
    800005fa:	0027c683          	lbu	a3,2(a5)
    800005fe:	a2c9                	j	800007c0 <printk+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80000600:	f8843783          	ld	a5,-120(s0)
    80000604:	00878713          	addi	a4,a5,8
    80000608:	f8e43423          	sd	a4,-120(s0)
    8000060c:	4605                	li	a2,1
    8000060e:	45a9                	li	a1,10
    80000610:	6388                	ld	a0,0(a5)
    80000612:	e63ff0ef          	jal	80000474 <printint>
      i += 2;
    80000616:	003a049b          	addiw	s1,s4,3
    8000061a:	b7a5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000061c:	f8843783          	ld	a5,-120(s0)
    80000620:	00878713          	addi	a4,a5,8
    80000624:	f8e43423          	sd	a4,-120(s0)
    80000628:	4601                	li	a2,0
    8000062a:	85da                	mv	a1,s6
    8000062c:	0007e503          	lwu	a0,0(a5)
    80000630:	e45ff0ef          	jal	80000474 <printint>
    80000634:	b7b9                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	85da                	mv	a1,s6
    80000646:	6388                	ld	a0,0(a5)
    80000648:	e2dff0ef          	jal	80000474 <printint>
      i += 1;
    8000064c:	002a049b          	addiw	s1,s4,2
    80000650:	bf0d                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	e11ff0ef          	jal	80000474 <printint>
      i += 2;
    80000668:	003a049b          	addiw	s1,s4,3
    8000066c:	bf19                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45c1                	li	a1,16
    8000067e:	0007e503          	lwu	a0,0(a5)
    80000682:	df3ff0ef          	jal	80000474 <printint>
    80000686:	bdf5                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000688:	f8843783          	ld	a5,-120(s0)
    8000068c:	00878713          	addi	a4,a5,8
    80000690:	f8e43423          	sd	a4,-120(s0)
    80000694:	45c1                	li	a1,16
    80000696:	6388                	ld	a0,0(a5)
    80000698:	dddff0ef          	jal	80000474 <printint>
      i += 1;
    8000069c:	002a049b          	addiw	s1,s4,2
    800006a0:	b5cd                	j	80000582 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45c1                	li	a1,16
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	dc1ff0ef          	jal	80000474 <printint>
      i += 2;
    800006b8:	003a049b          	addiw	s1,s4,3
    800006bc:	b5d9                	j	80000582 <printk+0x78>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	106c8c93          	addi	s9,s9,262 # 800077e8 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1e0>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	b541                	j	80000582 <printk+0x78>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5b5                	j	80000582 <printk+0x78>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x238>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	e40509e3          	beqz	a0,80000582 <printk+0x78>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x22a>
    80000740:	b589                	j	80000582 <printk+0x78>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x22a>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b535                	j	80000582 <printk+0x78>
    80000758:	74a6                	ld	s1,104(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	0000a797          	auipc	a5,0xa
    8000076e:	cfa7a783          	lw	a5,-774(a5) # 8000a464 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x28a>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	7906                	ld	s2,96(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	74a6                	ld	s1,104(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x260>
    release(&pr.lock);
    80000794:	00012517          	auipc	a0,0x12
    80000798:	da450513          	addi	a0,a0,-604 # 80012538 <pr>
    8000079c:	4d4000ef          	jal	80000c70 <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x26a>
    if (c0 == 'd') {
    800007a2:	e37a8ee3          	beq	s5,s7,800005de <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8713          	addi	a4,s5,-108
    800007aa:	00173713          	seqz	a4,a4
    800007ae:	8636                	mv	a2,a3
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4781                	li	a5,0
    800007b2:	a00d                	j	800007d4 <printk+0x2ca>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8713          	addi	a4,s5,-108
    800007b8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	86d6                	mv	a3,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460793          	addi	a5,a2,-108
    800007c4:	0017b793          	seqz	a5,a5
    800007c8:	8ff9                	and	a5,a5,a4
    800007ca:	f9c68593          	addi	a1,a3,-100
    800007ce:	e199                	bnez	a1,800007d4 <printk+0x2ca>
    800007d0:	e20798e3          	bnez	a5,80000600 <printk+0xf6>
    } else if (c0 == 'u') {
    800007d4:	e58a84e3          	beq	s5,s8,8000061c <printk+0x112>
    } else if (c0 == 'l' && c1 == 'u') {
    800007d8:	f8b60593          	addi	a1,a2,-117
    800007dc:	e199                	bnez	a1,800007e2 <printk+0x2d8>
    800007de:	e4071ce3          	bnez	a4,80000636 <printk+0x12c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007e2:	f8b68593          	addi	a1,a3,-117
    800007e6:	e199                	bnez	a1,800007ec <printk+0x2e2>
    800007e8:	e60795e3          	bnez	a5,80000652 <printk+0x148>
    } else if (c0 == 'x') {
    800007ec:	e9aa81e3          	beq	s5,s10,8000066e <printk+0x164>
    } else if (c0 == 'l' && c1 == 'x') {
    800007f0:	f8860613          	addi	a2,a2,-120
    800007f4:	e219                	bnez	a2,800007fa <printk+0x2f0>
    800007f6:	e80719e3          	bnez	a4,80000688 <printk+0x17e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800007fa:	f8868693          	addi	a3,a3,-120
    800007fe:	e299                	bnez	a3,80000804 <printk+0x2fa>
    80000800:	ea0791e3          	bnez	a5,800006a2 <printk+0x198>
    } else if (c0 == 'p') {
    80000804:	ebba8de3          	beq	s5,s11,800006be <printk+0x1b4>
    } else if (c0 == 'c') {
    80000808:	06300793          	li	a5,99
    8000080c:	eefa8ce3          	beq	s5,a5,80000704 <printk+0x1fa>
    } else if (c0 == 's') {
    80000810:	07300793          	li	a5,115
    80000814:	f0fa82e3          	beq	s5,a5,80000718 <printk+0x20e>
    } else if (c0 == '%') {
    80000818:	02500793          	li	a5,37
    8000081c:	f2fa8ae3          	beq	s5,a5,80000750 <printk+0x246>
    } else if (c0 == 0) {
    80000820:	f60a80e3          	beqz	s5,80000780 <printk+0x276>
      consputc('%');
    80000824:	02500513          	li	a0,37
    80000828:	a63ff0ef          	jal	8000028a <consputc>
      consputc(c0);
    8000082c:	8556                	mv	a0,s5
    8000082e:	a5dff0ef          	jal	8000028a <consputc>
    80000832:	bb81                	j	80000582 <printk+0x78>

0000000080000834 <panic>:

void
panic(char *s)
{
    80000834:	1101                	addi	sp,sp,-32
    80000836:	ec06                	sd	ra,24(sp)
    80000838:	e822                	sd	s0,16(sp)
    8000083a:	e426                	sd	s1,8(sp)
    8000083c:	e04a                	sd	s2,0(sp)
    8000083e:	1000                	addi	s0,sp,32
    80000840:	892a                	mv	s2,a0
  panicking = 1;
    80000842:	4485                	li	s1,1
    80000844:	0000a797          	auipc	a5,0xa
    80000848:	c297a023          	sw	s1,-992(a5) # 8000a464 <panicking>
  printk("panic: ");
    8000084c:	00006517          	auipc	a0,0x6
    80000850:	7cc50513          	addi	a0,a0,1996 # 80007018 <etext+0x18>
    80000854:	cb7ff0ef          	jal	8000050a <printk>
  printk("%s\n", s);
    80000858:	85ca                	mv	a1,s2
    8000085a:	00006517          	auipc	a0,0x6
    8000085e:	7c650513          	addi	a0,a0,1990 # 80007020 <etext+0x20>
    80000862:	ca9ff0ef          	jal	8000050a <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000866:	0000a797          	auipc	a5,0xa
    8000086a:	be97ad23          	sw	s1,-1030(a5) # 8000a460 <panicked>
  for (;;)
    8000086e:	a001                	j	8000086e <panic+0x3a>

0000000080000870 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000870:	1141                	addi	sp,sp,-16
    80000872:	e406                	sd	ra,8(sp)
    80000874:	e022                	sd	s0,0(sp)
    80000876:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000878:	00006597          	auipc	a1,0x6
    8000087c:	7b058593          	addi	a1,a1,1968 # 80007028 <etext+0x28>
    80000880:	00012517          	auipc	a0,0x12
    80000884:	cb850513          	addi	a0,a0,-840 # 80012538 <pr>
    80000888:	2e0000ef          	jal	80000b68 <initlock>
}
    8000088c:	60a2                	ld	ra,8(sp)
    8000088e:	6402                	ld	s0,0(sp)
    80000890:	0141                	addi	sp,sp,16
    80000892:	8082                	ret

0000000080000894 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000894:	1141                	addi	sp,sp,-16
    80000896:	e406                	sd	ra,8(sp)
    80000898:	e022                	sd	s0,0(sp)
    8000089a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000089c:	100007b7          	lui	a5,0x10000
    800008a0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008a4:	10000737          	lui	a4,0x10000
    800008a8:	f8000693          	li	a3,-128
    800008ac:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008b0:	468d                	li	a3,3
    800008b2:	10000637          	lui	a2,0x10000
    800008b6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008be:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008c2:	8732                	mv	a4,a2
    800008c4:	461d                	li	a2,7
    800008c6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ca:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008ce:	00006597          	auipc	a1,0x6
    800008d2:	76258593          	addi	a1,a1,1890 # 80007030 <etext+0x30>
    800008d6:	00012517          	auipc	a0,0x12
    800008da:	c7a50513          	addi	a0,a0,-902 # 80012550 <tx_lock>
    800008de:	6fe030ef          	jal	80003fdc <initsleeplock>
}
    800008e2:	60a2                	ld	ra,8(sp)
    800008e4:	6402                	ld	s0,0(sp)
    800008e6:	0141                	addi	sp,sp,16
    800008e8:	8082                	ret

00000000800008ea <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008ea:	7139                	addi	sp,sp,-64
    800008ec:	fc06                	sd	ra,56(sp)
    800008ee:	f822                	sd	s0,48(sp)
    800008f0:	f04a                	sd	s2,32(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    800008fa:	00012517          	auipc	a0,0x12
    800008fe:	c5650513          	addi	a0,a0,-938 # 80012550 <tx_lock>
    80000902:	710030ef          	jal	80004012 <acquiresleep>

  int i = 0;
  while (i < n) {
    80000906:	05205963          	blez	s2,80000958 <uartwrite+0x6e>
    8000090a:	f426                	sd	s1,40(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000912:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000914:	0000aa17          	auipc	s4,0xa
    80000918:	b54a0a13          	addi	s4,s4,-1196 # 8000a468 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000091c:	100009b7          	lui	s3,0x10000
    80000920:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000922:	10000b37          	lui	s6,0x10000
    80000926:	a029                	j	80000930 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    80000928:	62e010ef          	jal	80001f56 <sleep>
  while (i < n) {
    8000092c:	0324d263          	bge	s1,s2,80000950 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000930:	8552                	mv	a0,s4
    80000932:	5e8010ef          	jal	80001f1a <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000936:	0009c783          	lbu	a5,0(s3)
    8000093a:	0207f793          	andi	a5,a5,32
    8000093e:	d7ed                	beqz	a5,80000928 <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000940:	009a87b3          	add	a5,s5,s1
    80000944:	0007c783          	lbu	a5,0(a5)
    80000948:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    8000094c:	2485                	addiw	s1,s1,1
    8000094e:	bff9                	j	8000092c <uartwrite+0x42>
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	69e2                	ld	s3,24(sp)
    80000954:	6a42                	ld	s4,16(sp)
    80000956:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80000958:	00012517          	auipc	a0,0x12
    8000095c:	bf850513          	addi	a0,a0,-1032 # 80012550 <tx_lock>
    80000960:	706030ef          	jal	80004066 <releasesleep>
}
    80000964:	70e2                	ld	ra,56(sp)
    80000966:	7442                	ld	s0,48(sp)
    80000968:	7902                	ld	s2,32(sp)
    8000096a:	6aa2                	ld	s5,8(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret

0000000080000970 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000970:	1101                	addi	sp,sp,-32
    80000972:	ec06                	sd	ra,24(sp)
    80000974:	e822                	sd	s0,16(sp)
    80000976:	e426                	sd	s1,8(sp)
    80000978:	1000                	addi	s0,sp,32
    8000097a:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000097c:	0000a797          	auipc	a5,0xa
    80000980:	ae87a783          	lw	a5,-1304(a5) # 8000a464 <panicking>
    80000984:	cf95                	beqz	a5,800009c0 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000986:	0000a797          	auipc	a5,0xa
    8000098a:	ada7a783          	lw	a5,-1318(a5) # 8000a460 <panicked>
    8000098e:	ef85                	bnez	a5,800009c6 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000990:	10000737          	lui	a4,0x10000
    80000994:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	00074783          	lbu	a5,0(a4)
    8000099a:	0207f793          	andi	a5,a5,32
    8000099e:	dfe5                	beqz	a5,80000996 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800009a0:	0ff4f513          	zext.b	a0,s1
    800009a4:	100007b7          	lui	a5,0x10000
    800009a8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009ac:	0000a797          	auipc	a5,0xa
    800009b0:	ab87a783          	lw	a5,-1352(a5) # 8000a464 <panicking>
    800009b4:	cb91                	beqz	a5,800009c8 <uartputc_sync+0x58>
    pop_off();
}
    800009b6:	60e2                	ld	ra,24(sp)
    800009b8:	6442                	ld	s0,16(sp)
    800009ba:	64a2                	ld	s1,8(sp)
    800009bc:	6105                	addi	sp,sp,32
    800009be:	8082                	ret
    push_off();
    800009c0:	1ee000ef          	jal	80000bae <push_off>
    800009c4:	b7c9                	j	80000986 <uartputc_sync+0x16>
    for (;;)
    800009c6:	a001                	j	800009c6 <uartputc_sync+0x56>
    pop_off();
    800009c8:	260000ef          	jal	80000c28 <pop_off>
}
    800009cc:	b7ed                	j	800009b6 <uartputc_sync+0x46>

00000000800009ce <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	e04a                	sd	s2,0(sp)
    800009d8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009e2:	100007b7          	lui	a5,0x10000
    800009e6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ea:	0207f793          	andi	a5,a5,32
    800009ee:	ef99                	bnez	a5,80000a0c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009f0:	100004b7          	lui	s1,0x10000
    800009f4:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009f6:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009fa:	0004c783          	lbu	a5,0(s1)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cf89                	beqz	a5,80000a1a <uartintr+0x4c>
    return ReadReg(RHR);
    80000a02:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a06:	8b7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a0a:	bfc5                	j	800009fa <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a0c:	0000a517          	auipc	a0,0xa
    80000a10:	a5c50513          	addi	a0,a0,-1444 # 8000a468 <tx_chan>
    80000a14:	572010ef          	jal	80001f86 <wakeup>
    80000a18:	bfe1                	j	800009f0 <uartintr+0x22>
  }
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6902                	ld	s2,0(sp)
    80000a22:	6105                	addi	sp,sp,32
    80000a24:	8082                	ret

0000000080000a26 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	e04a                	sd	s2,0(sp)
    80000a30:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a32:	00023797          	auipc	a5,0x23
    80000a36:	f7e78793          	addi	a5,a5,-130 # 800239b0 <end>
    80000a3a:	00f53733          	sltu	a4,a0,a5
    80000a3e:	47c5                	li	a5,17
    80000a40:	07ee                	slli	a5,a5,0x1b
    80000a42:	17fd                	addi	a5,a5,-1
    80000a44:	00a7b7b3          	sltu	a5,a5,a0
    80000a48:	8fd9                	or	a5,a5,a4
    80000a4a:	ef95                	bnez	a5,80000a86 <kfree+0x60>
    80000a4c:	84aa                	mv	s1,a0
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	eb95                	bnez	a5,80000a86 <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	4585                	li	a1,1
    80000a58:	250000ef          	jal	80000ca8 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a5c:	00012917          	auipc	s2,0x12
    80000a60:	b2490913          	addi	s2,s2,-1244 # 80012580 <kmem>
    80000a64:	854a                	mv	a0,s2
    80000a66:	182000ef          	jal	80000be8 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	1fa000ef          	jal	80000c70 <release>
}
    80000a7a:	60e2                	ld	ra,24(sp)
    80000a7c:	6442                	ld	s0,16(sp)
    80000a7e:	64a2                	ld	s1,8(sp)
    80000a80:	6902                	ld	s2,0(sp)
    80000a82:	6105                	addi	sp,sp,32
    80000a84:	8082                	ret
    panic("kfree");
    80000a86:	00006517          	auipc	a0,0x6
    80000a8a:	5b250513          	addi	a0,a0,1458 # 80007038 <etext+0x38>
    80000a8e:	da7ff0ef          	jal	80000834 <panic>

0000000080000a92 <freerange>:
{
    80000a92:	7179                	addi	sp,sp,-48
    80000a94:	f406                	sd	ra,40(sp)
    80000a96:	f022                	sd	s0,32(sp)
    80000a98:	ec26                	sd	s1,24(sp)
    80000a9a:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aa2:	00e504b3          	add	s1,a0,a4
    80000aa6:	777d                	lui	a4,0xfffff
    80000aa8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aaa:	94be                	add	s1,s1,a5
    80000aac:	0295e263          	bltu	a1,s1,80000ad0 <freerange+0x3e>
    80000ab0:	e84a                	sd	s2,16(sp)
    80000ab2:	e44e                	sd	s3,8(sp)
    80000ab4:	e052                	sd	s4,0(sp)
    80000ab6:	892e                	mv	s2,a1
    kfree(p);
    80000ab8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	89be                	mv	s3,a5
    kfree(p);
    80000abc:	01448533          	add	a0,s1,s4
    80000ac0:	f67ff0ef          	jal	80000a26 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ac4:	94ce                	add	s1,s1,s3
    80000ac6:	fe997be3          	bgeu	s2,s1,80000abc <freerange+0x2a>
    80000aca:	6942                	ld	s2,16(sp)
    80000acc:	69a2                	ld	s3,8(sp)
    80000ace:	6a02                	ld	s4,0(sp)
}
    80000ad0:	70a2                	ld	ra,40(sp)
    80000ad2:	7402                	ld	s0,32(sp)
    80000ad4:	64e2                	ld	s1,24(sp)
    80000ad6:	6145                	addi	sp,sp,48
    80000ad8:	8082                	ret

0000000080000ada <kinit>:
{
    80000ada:	1141                	addi	sp,sp,-16
    80000adc:	e406                	sd	ra,8(sp)
    80000ade:	e022                	sd	s0,0(sp)
    80000ae0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae2:	00006597          	auipc	a1,0x6
    80000ae6:	55e58593          	addi	a1,a1,1374 # 80007040 <etext+0x40>
    80000aea:	00012517          	auipc	a0,0x12
    80000aee:	a9650513          	addi	a0,a0,-1386 # 80012580 <kmem>
    80000af2:	076000ef          	jal	80000b68 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000af6:	45c5                	li	a1,17
    80000af8:	05ee                	slli	a1,a1,0x1b
    80000afa:	00023517          	auipc	a0,0x23
    80000afe:	eb650513          	addi	a0,a0,-330 # 800239b0 <end>
    80000b02:	f91ff0ef          	jal	80000a92 <freerange>
}
    80000b06:	60a2                	ld	ra,8(sp)
    80000b08:	6402                	ld	s0,0(sp)
    80000b0a:	0141                	addi	sp,sp,16
    80000b0c:	8082                	ret

0000000080000b0e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b0e:	1101                	addi	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b18:	00012517          	auipc	a0,0x12
    80000b1c:	a6850513          	addi	a0,a0,-1432 # 80012580 <kmem>
    80000b20:	0c8000ef          	jal	80000be8 <acquire>
  r = kmem.freelist;
    80000b24:	00012497          	auipc	s1,0x12
    80000b28:	a744b483          	ld	s1,-1420(s1) # 80012598 <kmem+0x18>
  if (r)
    80000b2c:	c49d                	beqz	s1,80000b5a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b2e:	609c                	ld	a5,0(s1)
    80000b30:	00012717          	auipc	a4,0x12
    80000b34:	a6f73423          	sd	a5,-1432(a4) # 80012598 <kmem+0x18>
  release(&kmem.lock);
    80000b38:	00012517          	auipc	a0,0x12
    80000b3c:	a4850513          	addi	a0,a0,-1464 # 80012580 <kmem>
    80000b40:	130000ef          	jal	80000c70 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b44:	6605                	lui	a2,0x1
    80000b46:	4595                	li	a1,5
    80000b48:	8526                	mv	a0,s1
    80000b4a:	15e000ef          	jal	80000ca8 <memset>
  return (void *)r;
}
    80000b4e:	8526                	mv	a0,s1
    80000b50:	60e2                	ld	ra,24(sp)
    80000b52:	6442                	ld	s0,16(sp)
    80000b54:	64a2                	ld	s1,8(sp)
    80000b56:	6105                	addi	sp,sp,32
    80000b58:	8082                	ret
  release(&kmem.lock);
    80000b5a:	00012517          	auipc	a0,0x12
    80000b5e:	a2650513          	addi	a0,a0,-1498 # 80012580 <kmem>
    80000b62:	10e000ef          	jal	80000c70 <release>
  if (r)
    80000b66:	b7e5                	j	80000b4e <kalloc+0x40>

0000000080000b68 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b68:	1141                	addi	sp,sp,-16
    80000b6a:	e406                	sd	ra,8(sp)
    80000b6c:	e022                	sd	s0,0(sp)
    80000b6e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b70:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b72:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b76:	00053823          	sd	zero,16(a0)
}
    80000b7a:	60a2                	ld	ra,8(sp)
    80000b7c:	6402                	ld	s0,0(sp)
    80000b7e:	0141                	addi	sp,sp,16
    80000b80:	8082                	ret

0000000080000b82 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	411c                	lw	a5,0(a0)
    80000b84:	e399                	bnez	a5,80000b8a <holding+0x8>
    80000b86:	4501                	li	a0,0
  return r;
}
    80000b88:	8082                	ret
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	691c                	ld	a5,16(a0)
    80000b96:	84be                	mv	s1,a5
    80000b98:	551000ef          	jal	800018e8 <mycpu>
    80000b9c:	40a48533          	sub	a0,s1,a0
    80000ba0:	00153513          	seqz	a0,a0
}
    80000ba4:	60e2                	ld	ra,24(sp)
    80000ba6:	6442                	ld	s0,16(sp)
    80000ba8:	64a2                	ld	s1,8(sp)
    80000baa:	6105                	addi	sp,sp,32
    80000bac:	8082                	ret

0000000080000bae <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bae:	1101                	addi	sp,sp,-32
    80000bb0:	ec06                	sd	ra,24(sp)
    80000bb2:	e822                	sd	s0,16(sp)
    80000bb4:	e426                	sd	s1,8(sp)
    80000bb6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bb8:	100177f3          	csrrci	a5,sstatus,2
    80000bbc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bbe:	52b000ef          	jal	800018e8 <mycpu>
    80000bc2:	5d3c                	lw	a5,120(a0)
    80000bc4:	cb99                	beqz	a5,80000bda <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bc6:	523000ef          	jal	800018e8 <mycpu>
    80000bca:	5d3c                	lw	a5,120(a0)
    80000bcc:	2785                	addiw	a5,a5,1
    80000bce:	dd3c                	sw	a5,120(a0)
}
    80000bd0:	60e2                	ld	ra,24(sp)
    80000bd2:	6442                	ld	s0,16(sp)
    80000bd4:	64a2                	ld	s1,8(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
    mycpu()->intena = old;
    80000bda:	50f000ef          	jal	800018e8 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bde:	0014d793          	srli	a5,s1,0x1
    80000be2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000be4:	dd7c                	sw	a5,124(a0)
    80000be6:	b7c5                	j	80000bc6 <push_off+0x18>

0000000080000be8 <acquire>:
{
    80000be8:	1101                	addi	sp,sp,-32
    80000bea:	ec06                	sd	ra,24(sp)
    80000bec:	e822                	sd	s0,16(sp)
    80000bee:	e426                	sd	s1,8(sp)
    80000bf0:	1000                	addi	s0,sp,32
    80000bf2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bf4:	fbbff0ef          	jal	80000bae <push_off>
  if (holding(lk))
    80000bf8:	8526                	mv	a0,s1
    80000bfa:	f89ff0ef          	jal	80000b82 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000bfe:	4705                	li	a4,1
  if (holding(lk))
    80000c00:	ed11                	bnez	a0,80000c1c <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c02:	87ba                	mv	a5,a4
    80000c04:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c08:	2781                	sext.w	a5,a5
    80000c0a:	ffe5                	bnez	a5,80000c02 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c0c:	4dd000ef          	jal	800018e8 <mycpu>
    80000c10:	e888                	sd	a0,16(s1)
}
    80000c12:	60e2                	ld	ra,24(sp)
    80000c14:	6442                	ld	s0,16(sp)
    80000c16:	64a2                	ld	s1,8(sp)
    80000c18:	6105                	addi	sp,sp,32
    80000c1a:	8082                	ret
    panic("acquire");
    80000c1c:	00006517          	auipc	a0,0x6
    80000c20:	42c50513          	addi	a0,a0,1068 # 80007048 <etext+0x48>
    80000c24:	c11ff0ef          	jal	80000834 <panic>

0000000080000c28 <pop_off>:

void
pop_off(void)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c30:	4b9000ef          	jal	800018e8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c34:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c38:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c3a:	ef99                	bnez	a5,80000c58 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	02f05363          	blez	a5,80000c64 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c42:	37fd                	addiw	a5,a5,-1
    80000c44:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c46:	e789                	bnez	a5,80000c50 <pop_off+0x28>
    80000c48:	5d7c                	lw	a5,124(a0)
    80000c4a:	c399                	beqz	a5,80000c50 <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c4c:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c50:	60a2                	ld	ra,8(sp)
    80000c52:	6402                	ld	s0,0(sp)
    80000c54:	0141                	addi	sp,sp,16
    80000c56:	8082                	ret
    panic("pop_off - interruptible");
    80000c58:	00006517          	auipc	a0,0x6
    80000c5c:	3f850513          	addi	a0,a0,1016 # 80007050 <etext+0x50>
    80000c60:	bd5ff0ef          	jal	80000834 <panic>
    panic("pop_off");
    80000c64:	00006517          	auipc	a0,0x6
    80000c68:	40450513          	addi	a0,a0,1028 # 80007068 <etext+0x68>
    80000c6c:	bc9ff0ef          	jal	80000834 <panic>

0000000080000c70 <release>:
{
    80000c70:	1101                	addi	sp,sp,-32
    80000c72:	ec06                	sd	ra,24(sp)
    80000c74:	e822                	sd	s0,16(sp)
    80000c76:	e426                	sd	s1,8(sp)
    80000c78:	1000                	addi	s0,sp,32
    80000c7a:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c7c:	f07ff0ef          	jal	80000b82 <holding>
    80000c80:	cd11                	beqz	a0,80000c9c <release+0x2c>
  lk->cpu = 0;
    80000c82:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c86:	0310000f          	fence	rw,w
    80000c8a:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c8e:	f9bff0ef          	jal	80000c28 <pop_off>
}
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	addi	sp,sp,32
    80000c9a:	8082                	ret
    panic("release");
    80000c9c:	00006517          	auipc	a0,0x6
    80000ca0:	3d450513          	addi	a0,a0,980 # 80007070 <etext+0x70>
    80000ca4:	b91ff0ef          	jal	80000834 <panic>

0000000080000ca8 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000ca8:	1141                	addi	sp,sp,-16
    80000caa:	e406                	sd	ra,8(sp)
    80000cac:	e022                	sd	s0,0(sp)
    80000cae:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cb0:	ca19                	beqz	a2,80000cc6 <memset+0x1e>
    80000cb2:	87aa                	mv	a5,a0
    80000cb4:	1602                	slli	a2,a2,0x20
    80000cb6:	9201                	srli	a2,a2,0x20
    80000cb8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cbc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000cc0:	0785                	addi	a5,a5,1
    80000cc2:	fee79de3          	bne	a5,a4,80000cbc <memset+0x14>
  }
  return dst;
}
    80000cc6:	60a2                	ld	ra,8(sp)
    80000cc8:	6402                	ld	s0,0(sp)
    80000cca:	0141                	addi	sp,sp,16
    80000ccc:	8082                	ret

0000000080000cce <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cce:	1141                	addi	sp,sp,-16
    80000cd0:	e406                	sd	ra,8(sp)
    80000cd2:	e022                	sd	s0,0(sp)
    80000cd4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000cd6:	c61d                	beqz	a2,80000d04 <memcmp+0x36>
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000ce0:	00054783          	lbu	a5,0(a0)
    80000ce4:	0005c703          	lbu	a4,0(a1)
    80000ce8:	00e79863          	bne	a5,a4,80000cf8 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000cec:	0505                	addi	a0,a0,1
    80000cee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cf0:	fed518e3          	bne	a0,a3,80000ce0 <memcmp+0x12>
  }

  return 0;
    80000cf4:	4501                	li	a0,0
    80000cf6:	a019                	j	80000cfc <memcmp+0x2e>
      return *s1 - *s2;
    80000cf8:	40e7853b          	subw	a0,a5,a4
}
    80000cfc:	60a2                	ld	ra,8(sp)
    80000cfe:	6402                	ld	s0,0(sp)
    80000d00:	0141                	addi	sp,sp,16
    80000d02:	8082                	ret
  return 0;
    80000d04:	4501                	li	a0,0
    80000d06:	bfdd                	j	80000cfc <memcmp+0x2e>

0000000080000d08 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d08:	1141                	addi	sp,sp,-16
    80000d0a:	e406                	sd	ra,8(sp)
    80000d0c:	e022                	sd	s0,0(sp)
    80000d0e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d10:	c205                	beqz	a2,80000d30 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d12:	02a5e363          	bltu	a1,a0,80000d38 <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d16:	1602                	slli	a2,a2,0x20
    80000d18:	9201                	srli	a2,a2,0x20
    80000d1a:	00c587b3          	add	a5,a1,a2
{
    80000d1e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d20:	0585                	addi	a1,a1,1
    80000d22:	0705                	addi	a4,a4,1
    80000d24:	fff5c683          	lbu	a3,-1(a1)
    80000d28:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d2c:	feb79ae3          	bne	a5,a1,80000d20 <memmove+0x18>

  return dst;
}
    80000d30:	60a2                	ld	ra,8(sp)
    80000d32:	6402                	ld	s0,0(sp)
    80000d34:	0141                	addi	sp,sp,16
    80000d36:	8082                	ret
  if (s < d && s + n > d) {
    80000d38:	02061693          	slli	a3,a2,0x20
    80000d3c:	9281                	srli	a3,a3,0x20
    80000d3e:	00d58733          	add	a4,a1,a3
    80000d42:	fce57ae3          	bgeu	a0,a4,80000d16 <memmove+0xe>
    d += n;
    80000d46:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d48:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d4c:	1782                	slli	a5,a5,0x20
    80000d4e:	9381                	srli	a5,a5,0x20
    80000d50:	fff7c793          	not	a5,a5
    80000d54:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d56:	177d                	addi	a4,a4,-1
    80000d58:	16fd                	addi	a3,a3,-1
    80000d5a:	00074603          	lbu	a2,0(a4)
    80000d5e:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d62:	fee79ae3          	bne	a5,a4,80000d56 <memmove+0x4e>
    80000d66:	b7e9                	j	80000d30 <memmove+0x28>

0000000080000d68 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e406                	sd	ra,8(sp)
    80000d6c:	e022                	sd	s0,0(sp)
    80000d6e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d70:	f99ff0ef          	jal	80000d08 <memmove>
}
    80000d74:	60a2                	ld	ra,8(sp)
    80000d76:	6402                	ld	s0,0(sp)
    80000d78:	0141                	addi	sp,sp,16
    80000d7a:	8082                	ret

0000000080000d7c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e406                	sd	ra,8(sp)
    80000d80:	e022                	sd	s0,0(sp)
    80000d82:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d84:	ce11                	beqz	a2,80000da0 <strncmp+0x24>
    80000d86:	00054783          	lbu	a5,0(a0)
    80000d8a:	cf89                	beqz	a5,80000da4 <strncmp+0x28>
    80000d8c:	0005c703          	lbu	a4,0(a1)
    80000d90:	00f71a63          	bne	a4,a5,80000da4 <strncmp+0x28>
    n--, p++, q++;
    80000d94:	367d                	addiw	a2,a2,-1
    80000d96:	0505                	addi	a0,a0,1
    80000d98:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000d9a:	f675                	bnez	a2,80000d86 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000d9c:	4501                	li	a0,0
    80000d9e:	a801                	j	80000dae <strncmp+0x32>
    80000da0:	4501                	li	a0,0
    80000da2:	a031                	j	80000dae <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000da4:	00054503          	lbu	a0,0(a0)
    80000da8:	0005c783          	lbu	a5,0(a1)
    80000dac:	9d1d                	subw	a0,a0,a5
}
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret

0000000080000db6 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e406                	sd	ra,8(sp)
    80000dba:	e022                	sd	s0,0(sp)
    80000dbc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dbe:	87aa                	mv	a5,a0
    80000dc0:	a011                	j	80000dc4 <strncpy+0xe>
    80000dc2:	8636                	mv	a2,a3
    80000dc4:	02c05863          	blez	a2,80000df4 <strncpy+0x3e>
    80000dc8:	fff6069b          	addiw	a3,a2,-1
    80000dcc:	8836                	mv	a6,a3
    80000dce:	0785                	addi	a5,a5,1
    80000dd0:	0005c703          	lbu	a4,0(a1)
    80000dd4:	fee78fa3          	sb	a4,-1(a5)
    80000dd8:	0585                	addi	a1,a1,1
    80000dda:	f765                	bnez	a4,80000dc2 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000ddc:	873e                	mv	a4,a5
    80000dde:	01005b63          	blez	a6,80000df4 <strncpy+0x3e>
    80000de2:	9fb1                	addw	a5,a5,a2
    80000de4:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de6:	0705                	addi	a4,a4,1
    80000de8:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dec:	40e786bb          	subw	a3,a5,a4
    80000df0:	fed04be3          	bgtz	a3,80000de6 <strncpy+0x30>
  return os;
}
    80000df4:	60a2                	ld	ra,8(sp)
    80000df6:	6402                	ld	s0,0(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret

0000000080000dfc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e406                	sd	ra,8(sp)
    80000e00:	e022                	sd	s0,0(sp)
    80000e02:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e04:	02c05363          	blez	a2,80000e2a <safestrcpy+0x2e>
    80000e08:	fff6069b          	addiw	a3,a2,-1
    80000e0c:	1682                	slli	a3,a3,0x20
    80000e0e:	9281                	srli	a3,a3,0x20
    80000e10:	96ae                	add	a3,a3,a1
    80000e12:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e14:	00d58963          	beq	a1,a3,80000e26 <safestrcpy+0x2a>
    80000e18:	0585                	addi	a1,a1,1
    80000e1a:	0785                	addi	a5,a5,1
    80000e1c:	fff5c703          	lbu	a4,-1(a1)
    80000e20:	fee78fa3          	sb	a4,-1(a5)
    80000e24:	fb65                	bnez	a4,80000e14 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e26:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2a:	60a2                	ld	ra,8(sp)
    80000e2c:	6402                	ld	s0,0(sp)
    80000e2e:	0141                	addi	sp,sp,16
    80000e30:	8082                	ret

0000000080000e32 <strlen>:

int
strlen(const char *s)
{
    80000e32:	1141                	addi	sp,sp,-16
    80000e34:	e406                	sd	ra,8(sp)
    80000e36:	e022                	sd	s0,0(sp)
    80000e38:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3a:	00054783          	lbu	a5,0(a0)
    80000e3e:	cf91                	beqz	a5,80000e5a <strlen+0x28>
    80000e40:	00150793          	addi	a5,a0,1
    80000e44:	86be                	mv	a3,a5
    80000e46:	0785                	addi	a5,a5,1
    80000e48:	fff7c703          	lbu	a4,-1(a5)
    80000e4c:	ff65                	bnez	a4,80000e44 <strlen+0x12>
    80000e4e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e52:	60a2                	ld	ra,8(sp)
    80000e54:	6402                	ld	s0,0(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5a:	4501                	li	a0,0
    80000e5c:	bfdd                	j	80000e52 <strlen+0x20>

0000000080000e5e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e406                	sd	ra,8(sp)
    80000e62:	e022                	sd	s0,0(sp)
    80000e64:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e66:	26f000ef          	jal	800018d4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6a:	00009717          	auipc	a4,0x9
    80000e6e:	60270713          	addi	a4,a4,1538 # 8000a46c <started>
  if (cpuid() == 0) {
    80000e72:	c51d                	beqz	a0,80000ea0 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e74:	431c                	lw	a5,0(a4)
    80000e76:	0230000f          	fence	r,rw
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dfe5                	beqz	a5,80000e74 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e7e:	257000ef          	jal	800018d4 <cpuid>
    80000e82:	85aa                	mv	a1,a0
    80000e84:	00006517          	auipc	a0,0x6
    80000e88:	21450513          	addi	a0,a0,532 # 80007098 <etext+0x98>
    80000e8c:	e7eff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80000e90:	082000ef          	jal	80000f12 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e94:	5e2010ef          	jal	80002476 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e98:	7f0040ef          	jal	80005688 <plicinithart>
  }

  scheduler();
    80000e9c:	6e3000ef          	jal	80001d7e <scheduler>
    consoleinit();
    80000ea0:	d90ff0ef          	jal	80000430 <consoleinit>
    printkinit();
    80000ea4:	9cdff0ef          	jal	80000870 <printkinit>
    printk("\n");
    80000ea8:	00006517          	auipc	a0,0x6
    80000eac:	1d050513          	addi	a0,a0,464 # 80007078 <etext+0x78>
    80000eb0:	e5aff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80000eb4:	00006517          	auipc	a0,0x6
    80000eb8:	1cc50513          	addi	a0,a0,460 # 80007080 <etext+0x80>
    80000ebc:	e4eff0ef          	jal	8000050a <printk>
    printk("\n");
    80000ec0:	00006517          	auipc	a0,0x6
    80000ec4:	1b850513          	addi	a0,a0,440 # 80007078 <etext+0x78>
    80000ec8:	e42ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    80000ecc:	c0fff0ef          	jal	80000ada <kinit>
    kvminit();          // create kernel page table
    80000ed0:	2ce000ef          	jal	8000119e <kvminit>
    kvminithart();      // turn on paging
    80000ed4:	03e000ef          	jal	80000f12 <kvminithart>
    procinit();         // process table
    80000ed8:	147000ef          	jal	8000181e <procinit>
    trapinit();         // trap vectors
    80000edc:	576010ef          	jal	80002452 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee0:	596010ef          	jal	80002476 <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee4:	78a040ef          	jal	8000566e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000ee8:	7a0040ef          	jal	80005688 <plicinithart>
    binit();            // buffer cache
    80000eec:	483010ef          	jal	80002b6e <binit>
    iinit();            // inode table
    80000ef0:	1d4020ef          	jal	800030c4 <iinit>
    fileinit();         // file table
    80000ef4:	1f4030ef          	jal	800040e8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ef8:	081040ef          	jal	80005778 <virtio_disk_init>
    userinit();         // first user process
    80000efc:	4cf000ef          	jal	80001bca <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f00:	00009797          	auipc	a5,0x9
    80000f04:	56c78793          	addi	a5,a5,1388 # 8000a46c <started>
    80000f08:	4705                	li	a4,1
    80000f0a:	0310000f          	fence	rw,w
    80000f0e:	c398                	sw	a4,0(a5)
    80000f10:	b771                	j	80000e9c <main+0x3e>

0000000080000f12 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e406                	sd	ra,8(sp)
    80000f16:	e022                	sd	s0,0(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	5527b783          	ld	a5,1362(a5) # 8000a470 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	60a2                	ld	ra,8(sp)
    80000f38:	6402                	ld	s0,0(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3e:	7139                	addi	sp,sp,-64
    80000f40:	fc06                	sd	ra,56(sp)
    80000f42:	f822                	sd	s0,48(sp)
    80000f44:	f426                	sd	s1,40(sp)
    80000f46:	f04a                	sd	s2,32(sp)
    80000f48:	ec4e                	sd	s3,24(sp)
    80000f4a:	e852                	sd	s4,16(sp)
    80000f4c:	e456                	sd	s5,8(sp)
    80000f4e:	e05a                	sd	s6,0(sp)
    80000f50:	0080                	addi	s0,sp,64
    80000f52:	84aa                	mv	s1,a0
    80000f54:	89ae                	mv	s3,a1
    80000f56:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f58:	57fd                	li	a5,-1
    80000f5a:	83e9                	srli	a5,a5,0x1a
    80000f5c:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f5e:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f60:	04b7e263          	bltu	a5,a1,80000fa4 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f64:	0149d933          	srl	s2,s3,s4
    80000f68:	1ff97913          	andi	s2,s2,511
    80000f6c:	090e                	slli	s2,s2,0x3
    80000f6e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f70:	00093483          	ld	s1,0(s2)
    80000f74:	0014f793          	andi	a5,s1,1
    80000f78:	cf85                	beqz	a5,80000fb0 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7a:	80a9                	srli	s1,s1,0xa
    80000f7c:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    80000f7e:	3a5d                	addiw	s4,s4,-9
    80000f80:	ff5a12e3          	bne	s4,s5,80000f64 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000f84:	00c9d513          	srli	a0,s3,0xc
    80000f88:	1ff57513          	andi	a0,a0,511
    80000f8c:	050e                	slli	a0,a0,0x3
    80000f8e:	9526                	add	a0,a0,s1
}
    80000f90:	70e2                	ld	ra,56(sp)
    80000f92:	7442                	ld	s0,48(sp)
    80000f94:	74a2                	ld	s1,40(sp)
    80000f96:	7902                	ld	s2,32(sp)
    80000f98:	69e2                	ld	s3,24(sp)
    80000f9a:	6a42                	ld	s4,16(sp)
    80000f9c:	6aa2                	ld	s5,8(sp)
    80000f9e:	6b02                	ld	s6,0(sp)
    80000fa0:	6121                	addi	sp,sp,64
    80000fa2:	8082                	ret
    panic("walk");
    80000fa4:	00006517          	auipc	a0,0x6
    80000fa8:	10c50513          	addi	a0,a0,268 # 800070b0 <etext+0xb0>
    80000fac:	889ff0ef          	jal	80000834 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fb0:	020b0263          	beqz	s6,80000fd4 <walk+0x96>
    80000fb4:	b5bff0ef          	jal	80000b0e <kalloc>
    80000fb8:	84aa                	mv	s1,a0
    80000fba:	d979                	beqz	a0,80000f90 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fbc:	6605                	lui	a2,0x1
    80000fbe:	4581                	li	a1,0
    80000fc0:	ce9ff0ef          	jal	80000ca8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fc4:	00c4d793          	srli	a5,s1,0xc
    80000fc8:	07aa                	slli	a5,a5,0xa
    80000fca:	0017e793          	ori	a5,a5,1
    80000fce:	00f93023          	sd	a5,0(s2)
    80000fd2:	b775                	j	80000f7e <walk+0x40>
        return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	bf6d                	j	80000f90 <walk+0x52>

0000000080000fd8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	00b7f463          	bgeu	a5,a1,80000fe4 <walkaddr+0xc>
    return 0;
    80000fe0:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe2:	8082                	ret
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	f51ff0ef          	jal	80000f3e <walk>
  if (pte == 0)
    80000ff2:	c901                	beqz	a0,80001002 <walkaddr+0x2a>
  if ((*pte & PTE_V) == 0)
    80000ff4:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ff6:	0117f693          	andi	a3,a5,17
    80000ffa:	4745                	li	a4,17
    return 0;
    80000ffc:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000ffe:	00e68663          	beq	a3,a4,8000100a <walkaddr+0x32>
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
  pa = PTE2PA(*pte);
    8000100a:	83a9                	srli	a5,a5,0xa
    8000100c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001010:	bfcd                	j	80001002 <walkaddr+0x2a>

0000000080001012 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001012:	715d                	addi	sp,sp,-80
    80001014:	e486                	sd	ra,72(sp)
    80001016:	e0a2                	sd	s0,64(sp)
    80001018:	fc26                	sd	s1,56(sp)
    8000101a:	f84a                	sd	s2,48(sp)
    8000101c:	f44e                	sd	s3,40(sp)
    8000101e:	f052                	sd	s4,32(sp)
    80001020:	ec56                	sd	s5,24(sp)
    80001022:	e85a                	sd	s6,16(sp)
    80001024:	e45e                	sd	s7,8(sp)
    80001026:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001028:	03459793          	slli	a5,a1,0x34
    8000102c:	eba1                	bnez	a5,8000107c <mappages+0x6a>
    8000102e:	8a2a                	mv	s4,a0
    80001030:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001032:	03461793          	slli	a5,a2,0x34
    80001036:	eba9                	bnez	a5,80001088 <mappages+0x76>
    panic("mappages: size not aligned");

  if (size == 0)
    80001038:	ce31                	beqz	a2,80001094 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000103a:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000103e:	80060613          	addi	a2,a2,-2048
    80001042:	00b60933          	add	s2,a2,a1
  a = va;
    80001046:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001048:	4b05                	li	s6,1
    8000104a:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000104e:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001050:	865a                	mv	a2,s6
    80001052:	85a6                	mv	a1,s1
    80001054:	8552                	mv	a0,s4
    80001056:	ee9ff0ef          	jal	80000f3e <walk>
    8000105a:	c929                	beqz	a0,800010ac <mappages+0x9a>
    if (*pte & PTE_V)
    8000105c:	611c                	ld	a5,0(a0)
    8000105e:	8b85                	andi	a5,a5,1
    80001060:	e3a1                	bnez	a5,800010a0 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001062:	013487b3          	add	a5,s1,s3
    80001066:	83b1                	srli	a5,a5,0xc
    80001068:	07aa                	slli	a5,a5,0xa
    8000106a:	0157e7b3          	or	a5,a5,s5
    8000106e:	0017e793          	ori	a5,a5,1
    80001072:	e11c                	sd	a5,0(a0)
    if (a == last)
    80001074:	05248863          	beq	s1,s2,800010c4 <mappages+0xb2>
    a += PGSIZE;
    80001078:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000107a:	bfd9                	j	80001050 <mappages+0x3e>
    panic("mappages: va not aligned");
    8000107c:	00006517          	auipc	a0,0x6
    80001080:	03c50513          	addi	a0,a0,60 # 800070b8 <etext+0xb8>
    80001084:	fb0ff0ef          	jal	80000834 <panic>
    panic("mappages: size not aligned");
    80001088:	00006517          	auipc	a0,0x6
    8000108c:	05050513          	addi	a0,a0,80 # 800070d8 <etext+0xd8>
    80001090:	fa4ff0ef          	jal	80000834 <panic>
    panic("mappages: size");
    80001094:	00006517          	auipc	a0,0x6
    80001098:	06450513          	addi	a0,a0,100 # 800070f8 <etext+0xf8>
    8000109c:	f98ff0ef          	jal	80000834 <panic>
      panic("mappages: remap");
    800010a0:	00006517          	auipc	a0,0x6
    800010a4:	06850513          	addi	a0,a0,104 # 80007108 <etext+0x108>
    800010a8:	f8cff0ef          	jal	80000834 <panic>
      return -1;
    800010ac:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010ae:	60a6                	ld	ra,72(sp)
    800010b0:	6406                	ld	s0,64(sp)
    800010b2:	74e2                	ld	s1,56(sp)
    800010b4:	7942                	ld	s2,48(sp)
    800010b6:	79a2                	ld	s3,40(sp)
    800010b8:	7a02                	ld	s4,32(sp)
    800010ba:	6ae2                	ld	s5,24(sp)
    800010bc:	6b42                	ld	s6,16(sp)
    800010be:	6ba2                	ld	s7,8(sp)
    800010c0:	6161                	addi	sp,sp,80
    800010c2:	8082                	ret
  return 0;
    800010c4:	4501                	li	a0,0
    800010c6:	b7e5                	j	800010ae <mappages+0x9c>

00000000800010c8 <kvmmap>:
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e406                	sd	ra,8(sp)
    800010cc:	e022                	sd	s0,0(sp)
    800010ce:	0800                	addi	s0,sp,16
    800010d0:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010d2:	86b2                	mv	a3,a2
    800010d4:	863e                	mv	a2,a5
    800010d6:	f3dff0ef          	jal	80001012 <mappages>
    800010da:	e509                	bnez	a0,800010e4 <kvmmap+0x1c>
}
    800010dc:	60a2                	ld	ra,8(sp)
    800010de:	6402                	ld	s0,0(sp)
    800010e0:	0141                	addi	sp,sp,16
    800010e2:	8082                	ret
    panic("kvmmap");
    800010e4:	00006517          	auipc	a0,0x6
    800010e8:	03450513          	addi	a0,a0,52 # 80007118 <etext+0x118>
    800010ec:	f48ff0ef          	jal	80000834 <panic>

00000000800010f0 <kvmmake>:
{
    800010f0:	1101                	addi	sp,sp,-32
    800010f2:	ec06                	sd	ra,24(sp)
    800010f4:	e822                	sd	s0,16(sp)
    800010f6:	e426                	sd	s1,8(sp)
    800010f8:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010fa:	a15ff0ef          	jal	80000b0e <kalloc>
    800010fe:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001100:	6605                	lui	a2,0x1
    80001102:	4581                	li	a1,0
    80001104:	ba5ff0ef          	jal	80000ca8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001108:	4719                	li	a4,6
    8000110a:	6685                	lui	a3,0x1
    8000110c:	10000637          	lui	a2,0x10000
    80001110:	85b2                	mv	a1,a2
    80001112:	8526                	mv	a0,s1
    80001114:	fb5ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001118:	4719                	li	a4,6
    8000111a:	6685                	lui	a3,0x1
    8000111c:	10001637          	lui	a2,0x10001
    80001120:	85b2                	mv	a1,a2
    80001122:	8526                	mv	a0,s1
    80001124:	fa5ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001128:	4719                	li	a4,6
    8000112a:	040006b7          	lui	a3,0x4000
    8000112e:	0c000637          	lui	a2,0xc000
    80001132:	85b2                	mv	a1,a2
    80001134:	8526                	mv	a0,s1
    80001136:	f93ff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000113a:	4729                	li	a4,10
    8000113c:	80006697          	auipc	a3,0x80006
    80001140:	ec468693          	addi	a3,a3,-316 # 7000 <_entry-0x7fff9000>
    80001144:	4605                	li	a2,1
    80001146:	067e                	slli	a2,a2,0x1f
    80001148:	85b2                	mv	a1,a2
    8000114a:	8526                	mv	a0,s1
    8000114c:	f7dff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001150:	4719                	li	a4,6
    80001152:	00006697          	auipc	a3,0x6
    80001156:	eae68693          	addi	a3,a3,-338 # 80007000 <etext>
    8000115a:	47c5                	li	a5,17
    8000115c:	07ee                	slli	a5,a5,0x1b
    8000115e:	40d786b3          	sub	a3,a5,a3
    80001162:	00006617          	auipc	a2,0x6
    80001166:	e9e60613          	addi	a2,a2,-354 # 80007000 <etext>
    8000116a:	85b2                	mv	a1,a2
    8000116c:	8526                	mv	a0,s1
    8000116e:	f5bff0ef          	jal	800010c8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001172:	4729                	li	a4,10
    80001174:	6685                	lui	a3,0x1
    80001176:	00005617          	auipc	a2,0x5
    8000117a:	e8a60613          	addi	a2,a2,-374 # 80006000 <_trampoline>
    8000117e:	040005b7          	lui	a1,0x4000
    80001182:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001184:	05b2                	slli	a1,a1,0xc
    80001186:	8526                	mv	a0,s1
    80001188:	f41ff0ef          	jal	800010c8 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000118c:	8526                	mv	a0,s1
    8000118e:	5ec000ef          	jal	8000177a <proc_mapstacks>
}
    80001192:	8526                	mv	a0,s1
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <kvminit>:
{
    8000119e:	1141                	addi	sp,sp,-16
    800011a0:	e406                	sd	ra,8(sp)
    800011a2:	e022                	sd	s0,0(sp)
    800011a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011a6:	f4bff0ef          	jal	800010f0 <kvmmake>
    800011aa:	00009797          	auipc	a5,0x9
    800011ae:	2ca7b323          	sd	a0,710(a5) # 8000a470 <kernel_pagetable>
}
    800011b2:	60a2                	ld	ra,8(sp)
    800011b4:	6402                	ld	s0,0(sp)
    800011b6:	0141                	addi	sp,sp,16
    800011b8:	8082                	ret

00000000800011ba <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011ba:	1101                	addi	sp,sp,-32
    800011bc:	ec06                	sd	ra,24(sp)
    800011be:	e822                	sd	s0,16(sp)
    800011c0:	e426                	sd	s1,8(sp)
    800011c2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011c4:	94bff0ef          	jal	80000b0e <kalloc>
    800011c8:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011ca:	c509                	beqz	a0,800011d4 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011cc:	6605                	lui	a2,0x1
    800011ce:	4581                	li	a1,0
    800011d0:	ad9ff0ef          	jal	80000ca8 <memset>
  return pagetable;
}
    800011d4:	8526                	mv	a0,s1
    800011d6:	60e2                	ld	ra,24(sp)
    800011d8:	6442                	ld	s0,16(sp)
    800011da:	64a2                	ld	s1,8(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret

00000000800011e0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011e0:	7139                	addi	sp,sp,-64
    800011e2:	fc06                	sd	ra,56(sp)
    800011e4:	f822                	sd	s0,48(sp)
    800011e6:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011e8:	03459793          	slli	a5,a1,0x34
    800011ec:	e38d                	bnez	a5,8000120e <uvmunmap+0x2e>
    800011ee:	f04a                	sd	s2,32(sp)
    800011f0:	ec4e                	sd	s3,24(sp)
    800011f2:	e852                	sd	s4,16(sp)
    800011f4:	e456                	sd	s5,8(sp)
    800011f6:	e05a                	sd	s6,0(sp)
    800011f8:	8a2a                	mv	s4,a0
    800011fa:	892e                	mv	s2,a1
    800011fc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011fe:	0632                	slli	a2,a2,0xc
    80001200:	00b609b3          	add	s3,a2,a1
    80001204:	6b05                	lui	s6,0x1
    80001206:	0535f963          	bgeu	a1,s3,80001258 <uvmunmap+0x78>
    8000120a:	f426                	sd	s1,40(sp)
    8000120c:	a015                	j	80001230 <uvmunmap+0x50>
    8000120e:	f426                	sd	s1,40(sp)
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000121a:	00006517          	auipc	a0,0x6
    8000121e:	f0650513          	addi	a0,a0,-250 # 80007120 <etext+0x120>
    80001222:	e12ff0ef          	jal	80000834 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001226:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000122a:	995a                	add	s2,s2,s6
    8000122c:	03397563          	bgeu	s2,s3,80001256 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001230:	4601                	li	a2,0
    80001232:	85ca                	mv	a1,s2
    80001234:	8552                	mv	a0,s4
    80001236:	d09ff0ef          	jal	80000f3e <walk>
    8000123a:	84aa                	mv	s1,a0
    8000123c:	d57d                	beqz	a0,8000122a <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    8000123e:	611c                	ld	a5,0(a0)
    80001240:	0017f713          	andi	a4,a5,1
    80001244:	d37d                	beqz	a4,8000122a <uvmunmap+0x4a>
    if (do_free) {
    80001246:	fe0a80e3          	beqz	s5,80001226 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000124a:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000124c:	00c79513          	slli	a0,a5,0xc
    80001250:	fd6ff0ef          	jal	80000a26 <kfree>
    80001254:	bfc9                	j	80001226 <uvmunmap+0x46>
    80001256:	74a2                	ld	s1,40(sp)
    80001258:	7902                	ld	s2,32(sp)
    8000125a:	69e2                	ld	s3,24(sp)
    8000125c:	6a42                	ld	s4,16(sp)
    8000125e:	6aa2                	ld	s5,8(sp)
    80001260:	6b02                	ld	s6,0(sp)
  }
}
    80001262:	70e2                	ld	ra,56(sp)
    80001264:	7442                	ld	s0,48(sp)
    80001266:	6121                	addi	sp,sp,64
    80001268:	8082                	ret

000000008000126a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000126a:	1101                	addi	sp,sp,-32
    8000126c:	ec06                	sd	ra,24(sp)
    8000126e:	e822                	sd	s0,16(sp)
    80001270:	e426                	sd	s1,8(sp)
    80001272:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001274:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001276:	00b67d63          	bgeu	a2,a1,80001290 <uvmdealloc+0x26>
    8000127a:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000127c:	6785                	lui	a5,0x1
    8000127e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001280:	00f60733          	add	a4,a2,a5
    80001284:	76fd                	lui	a3,0xfffff
    80001286:	8f75                	and	a4,a4,a3
    80001288:	97ae                	add	a5,a5,a1
    8000128a:	8ff5                	and	a5,a5,a3
    8000128c:	00f76863          	bltu	a4,a5,8000129c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6105                	addi	sp,sp,32
    8000129a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000129c:	8f99                	sub	a5,a5,a4
    8000129e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012a0:	4685                	li	a3,1
    800012a2:	0007861b          	sext.w	a2,a5
    800012a6:	85ba                	mv	a1,a4
    800012a8:	f39ff0ef          	jal	800011e0 <uvmunmap>
    800012ac:	b7d5                	j	80001290 <uvmdealloc+0x26>

00000000800012ae <uvmalloc>:
  if (newsz < oldsz)
    800012ae:	0ab66163          	bltu	a2,a1,80001350 <uvmalloc+0xa2>
{
    800012b2:	715d                	addi	sp,sp,-80
    800012b4:	e486                	sd	ra,72(sp)
    800012b6:	e0a2                	sd	s0,64(sp)
    800012b8:	f84a                	sd	s2,48(sp)
    800012ba:	f052                	sd	s4,32(sp)
    800012bc:	ec56                	sd	s5,24(sp)
    800012be:	e45e                	sd	s7,8(sp)
    800012c0:	0880                	addi	s0,sp,80
    800012c2:	8aaa                	mv	s5,a0
    800012c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012c6:	6785                	lui	a5,0x1
    800012c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ca:	95be                	add	a1,a1,a5
    800012cc:	77fd                	lui	a5,0xfffff
    800012ce:	00f5f933          	and	s2,a1,a5
    800012d2:	8bca                	mv	s7,s2
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012d4:	08c97063          	bgeu	s2,a2,80001354 <uvmalloc+0xa6>
    800012d8:	fc26                	sd	s1,56(sp)
    800012da:	f44e                	sd	s3,40(sp)
    800012dc:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800012de:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012e0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012e4:	82bff0ef          	jal	80000b0e <kalloc>
    800012e8:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012ea:	c50d                	beqz	a0,80001314 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800012ec:	864e                	mv	a2,s3
    800012ee:	4581                	li	a1,0
    800012f0:	9b9ff0ef          	jal	80000ca8 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012f4:	875a                	mv	a4,s6
    800012f6:	86a6                	mv	a3,s1
    800012f8:	864e                	mv	a2,s3
    800012fa:	85ca                	mv	a1,s2
    800012fc:	8556                	mv	a0,s5
    800012fe:	d15ff0ef          	jal	80001012 <mappages>
    80001302:	e915                	bnez	a0,80001336 <uvmalloc+0x88>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001304:	994e                	add	s2,s2,s3
    80001306:	fd496fe3          	bltu	s2,s4,800012e4 <uvmalloc+0x36>
  return newsz;
    8000130a:	8552                	mv	a0,s4
    8000130c:	74e2                	ld	s1,56(sp)
    8000130e:	79a2                	ld	s3,40(sp)
    80001310:	6b42                	ld	s6,16(sp)
    80001312:	a811                	j	80001326 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001314:	865e                	mv	a2,s7
    80001316:	85ca                	mv	a1,s2
    80001318:	8556                	mv	a0,s5
    8000131a:	f51ff0ef          	jal	8000126a <uvmdealloc>
      return 0;
    8000131e:	4501                	li	a0,0
    80001320:	74e2                	ld	s1,56(sp)
    80001322:	79a2                	ld	s3,40(sp)
    80001324:	6b42                	ld	s6,16(sp)
}
    80001326:	60a6                	ld	ra,72(sp)
    80001328:	6406                	ld	s0,64(sp)
    8000132a:	7942                	ld	s2,48(sp)
    8000132c:	7a02                	ld	s4,32(sp)
    8000132e:	6ae2                	ld	s5,24(sp)
    80001330:	6ba2                	ld	s7,8(sp)
    80001332:	6161                	addi	sp,sp,80
    80001334:	8082                	ret
      kfree(mem);
    80001336:	8526                	mv	a0,s1
    80001338:	eeeff0ef          	jal	80000a26 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000133c:	865e                	mv	a2,s7
    8000133e:	85ca                	mv	a1,s2
    80001340:	8556                	mv	a0,s5
    80001342:	f29ff0ef          	jal	8000126a <uvmdealloc>
      return 0;
    80001346:	4501                	li	a0,0
    80001348:	74e2                	ld	s1,56(sp)
    8000134a:	79a2                	ld	s3,40(sp)
    8000134c:	6b42                	ld	s6,16(sp)
    8000134e:	bfe1                	j	80001326 <uvmalloc+0x78>
    return oldsz;
    80001350:	852e                	mv	a0,a1
}
    80001352:	8082                	ret
  return newsz;
    80001354:	8532                	mv	a0,a2
    80001356:	bfc1                	j	80001326 <uvmalloc+0x78>

0000000080001358 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001358:	7179                	addi	sp,sp,-48
    8000135a:	f406                	sd	ra,40(sp)
    8000135c:	f022                	sd	s0,32(sp)
    8000135e:	ec26                	sd	s1,24(sp)
    80001360:	e84a                	sd	s2,16(sp)
    80001362:	e44e                	sd	s3,8(sp)
    80001364:	1800                	addi	s0,sp,48
    80001366:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001368:	84aa                	mv	s1,a0
    8000136a:	6905                	lui	s2,0x1
    8000136c:	992a                	add	s2,s2,a0
    8000136e:	a811                	j	80001382 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    80001370:	00006517          	auipc	a0,0x6
    80001374:	dc850513          	addi	a0,a0,-568 # 80007138 <etext+0x138>
    80001378:	cbcff0ef          	jal	80000834 <panic>
  for (int i = 0; i < 512; i++) {
    8000137c:	04a1                	addi	s1,s1,8
    8000137e:	03248163          	beq	s1,s2,800013a0 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001382:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001384:	0017f713          	andi	a4,a5,1
    80001388:	db75                	beqz	a4,8000137c <freewalk+0x24>
    8000138a:	00e7f713          	andi	a4,a5,14
    8000138e:	f36d                	bnez	a4,80001370 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80001390:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001392:	00c79513          	slli	a0,a5,0xc
    80001396:	fc3ff0ef          	jal	80001358 <freewalk>
      pagetable[i] = 0;
    8000139a:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000139e:	bff9                	j	8000137c <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013a0:	854e                	mv	a0,s3
    800013a2:	e84ff0ef          	jal	80000a26 <kfree>
}
    800013a6:	70a2                	ld	ra,40(sp)
    800013a8:	7402                	ld	s0,32(sp)
    800013aa:	64e2                	ld	s1,24(sp)
    800013ac:	6942                	ld	s2,16(sp)
    800013ae:	69a2                	ld	s3,8(sp)
    800013b0:	6145                	addi	sp,sp,48
    800013b2:	8082                	ret

00000000800013b4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
    800013be:	84aa                	mv	s1,a0
  if (sz > 0)
    800013c0:	e989                	bnez	a1,800013d2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013c2:	8526                	mv	a0,s1
    800013c4:	f95ff0ef          	jal	80001358 <freewalk>
}
    800013c8:	60e2                	ld	ra,24(sp)
    800013ca:	6442                	ld	s0,16(sp)
    800013cc:	64a2                	ld	s1,8(sp)
    800013ce:	6105                	addi	sp,sp,32
    800013d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013d2:	6785                	lui	a5,0x1
    800013d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013d6:	95be                	add	a1,a1,a5
    800013d8:	4685                	li	a3,1
    800013da:	00c5d613          	srli	a2,a1,0xc
    800013de:	4581                	li	a1,0
    800013e0:	e01ff0ef          	jal	800011e0 <uvmunmap>
    800013e4:	bff9                	j	800013c2 <uvmfree+0xe>

00000000800013e6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013e6:	ca59                	beqz	a2,8000147c <uvmcopy+0x96>
{
    800013e8:	715d                	addi	sp,sp,-80
    800013ea:	e486                	sd	ra,72(sp)
    800013ec:	e0a2                	sd	s0,64(sp)
    800013ee:	fc26                	sd	s1,56(sp)
    800013f0:	f84a                	sd	s2,48(sp)
    800013f2:	f44e                	sd	s3,40(sp)
    800013f4:	f052                	sd	s4,32(sp)
    800013f6:	ec56                	sd	s5,24(sp)
    800013f8:	e85a                	sd	s6,16(sp)
    800013fa:	e45e                	sd	s7,8(sp)
    800013fc:	0880                	addi	s0,sp,80
    800013fe:	8b2a                	mv	s6,a0
    80001400:	8bae                	mv	s7,a1
    80001402:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001404:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001406:	6a05                	lui	s4,0x1
    80001408:	a021                	j	80001410 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000140a:	94d2                	add	s1,s1,s4
    8000140c:	0554fc63          	bgeu	s1,s5,80001464 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80001410:	4601                	li	a2,0
    80001412:	85a6                	mv	a1,s1
    80001414:	855a                	mv	a0,s6
    80001416:	b29ff0ef          	jal	80000f3e <walk>
    8000141a:	d965                	beqz	a0,8000140a <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000141c:	00053983          	ld	s3,0(a0)
    80001420:	0019f793          	andi	a5,s3,1
    80001424:	d3fd                	beqz	a5,8000140a <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001426:	ee8ff0ef          	jal	80000b0e <kalloc>
    8000142a:	892a                	mv	s2,a0
    8000142c:	c11d                	beqz	a0,80001452 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000142e:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001432:	8652                	mv	a2,s4
    80001434:	05b2                	slli	a1,a1,0xc
    80001436:	8d3ff0ef          	jal	80000d08 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8000143a:	3ff9f713          	andi	a4,s3,1023
    8000143e:	86ca                	mv	a3,s2
    80001440:	8652                	mv	a2,s4
    80001442:	85a6                	mv	a1,s1
    80001444:	855e                	mv	a0,s7
    80001446:	bcdff0ef          	jal	80001012 <mappages>
    8000144a:	d161                	beqz	a0,8000140a <uvmcopy+0x24>
      kfree(mem);
    8000144c:	854a                	mv	a0,s2
    8000144e:	dd8ff0ef          	jal	80000a26 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001452:	4685                	li	a3,1
    80001454:	00c4d613          	srli	a2,s1,0xc
    80001458:	4581                	li	a1,0
    8000145a:	855e                	mv	a0,s7
    8000145c:	d85ff0ef          	jal	800011e0 <uvmunmap>
  return -1;
    80001460:	557d                	li	a0,-1
    80001462:	a011                	j	80001466 <uvmcopy+0x80>
  return 0;
    80001464:	4501                	li	a0,0
}
    80001466:	60a6                	ld	ra,72(sp)
    80001468:	6406                	ld	s0,64(sp)
    8000146a:	74e2                	ld	s1,56(sp)
    8000146c:	7942                	ld	s2,48(sp)
    8000146e:	79a2                	ld	s3,40(sp)
    80001470:	7a02                	ld	s4,32(sp)
    80001472:	6ae2                	ld	s5,24(sp)
    80001474:	6b42                	ld	s6,16(sp)
    80001476:	6ba2                	ld	s7,8(sp)
    80001478:	6161                	addi	sp,sp,80
    8000147a:	8082                	ret
  return 0;
    8000147c:	4501                	li	a0,0
}
    8000147e:	8082                	ret

0000000080001480 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001480:	1141                	addi	sp,sp,-16
    80001482:	e406                	sd	ra,8(sp)
    80001484:	e022                	sd	s0,0(sp)
    80001486:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001488:	4601                	li	a2,0
    8000148a:	ab5ff0ef          	jal	80000f3e <walk>
  if (pte == 0)
    8000148e:	c901                	beqz	a0,8000149e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001490:	611c                	ld	a5,0(a0)
    80001492:	9bbd                	andi	a5,a5,-17
    80001494:	e11c                	sd	a5,0(a0)
}
    80001496:	60a2                	ld	ra,8(sp)
    80001498:	6402                	ld	s0,0(sp)
    8000149a:	0141                	addi	sp,sp,16
    8000149c:	8082                	ret
    panic("uvmclear");
    8000149e:	00006517          	auipc	a0,0x6
    800014a2:	caa50513          	addi	a0,a0,-854 # 80007148 <etext+0x148>
    800014a6:	b8eff0ef          	jal	80000834 <panic>

00000000800014aa <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    800014aa:	1141                	addi	sp,sp,-16
    800014ac:	e406                	sd	ra,8(sp)
    800014ae:	e022                	sd	s0,0(sp)
    800014b0:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014b2:	4601                	li	a2,0
    800014b4:	a8bff0ef          	jal	80000f3e <walk>
  if (pte == 0) {
    800014b8:	c119                	beqz	a0,800014be <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014ba:	6108                	ld	a0,0(a0)
    800014bc:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014be:	60a2                	ld	ra,8(sp)
    800014c0:	6402                	ld	s0,0(sp)
    800014c2:	0141                	addi	sp,sp,16
    800014c4:	8082                	ret

00000000800014c6 <vmfault>:
{
    800014c6:	7179                	addi	sp,sp,-48
    800014c8:	f406                	sd	ra,40(sp)
    800014ca:	f022                	sd	s0,32(sp)
    800014cc:	e052                	sd	s4,0(sp)
    800014ce:	1800                	addi	s0,sp,48
    return 0;
    800014d0:	4a01                	li	s4,0
  if (va >= psz)
    800014d2:	00b66863          	bltu	a2,a1,800014e2 <vmfault+0x1c>
}
    800014d6:	8552                	mv	a0,s4
    800014d8:	70a2                	ld	ra,40(sp)
    800014da:	7402                	ld	s0,32(sp)
    800014dc:	6a02                	ld	s4,0(sp)
    800014de:	6145                	addi	sp,sp,48
    800014e0:	8082                	ret
    800014e2:	ec26                	sd	s1,24(sp)
    800014e4:	e44e                	sd	s3,8(sp)
    800014e6:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800014e8:	77fd                	lui	a5,0xfffff
    800014ea:	00f679b3          	and	s3,a2,a5
  if (ismapped(pagetable, va)) {
    800014ee:	85ce                	mv	a1,s3
    800014f0:	fbbff0ef          	jal	800014aa <ismapped>
    return 0;
    800014f4:	4a01                	li	s4,0
  if (ismapped(pagetable, va)) {
    800014f6:	c501                	beqz	a0,800014fe <vmfault+0x38>
    800014f8:	64e2                	ld	s1,24(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	bfe9                	j	800014d6 <vmfault+0x10>
    800014fe:	e84a                	sd	s2,16(sp)
  mem = (uint64)kalloc();
    80001500:	e0eff0ef          	jal	80000b0e <kalloc>
    80001504:	892a                	mv	s2,a0
  if (mem == 0)
    80001506:	c915                	beqz	a0,8000153a <vmfault+0x74>
  mem = (uint64)kalloc();
    80001508:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    8000150a:	6605                	lui	a2,0x1
    8000150c:	4581                	li	a1,0
    8000150e:	f9aff0ef          	jal	80000ca8 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001512:	4759                	li	a4,22
    80001514:	86ca                	mv	a3,s2
    80001516:	6605                	lui	a2,0x1
    80001518:	85ce                	mv	a1,s3
    8000151a:	8526                	mv	a0,s1
    8000151c:	af7ff0ef          	jal	80001012 <mappages>
    80001520:	e509                	bnez	a0,8000152a <vmfault+0x64>
    80001522:	64e2                	ld	s1,24(sp)
    80001524:	6942                	ld	s2,16(sp)
    80001526:	69a2                	ld	s3,8(sp)
    80001528:	b77d                	j	800014d6 <vmfault+0x10>
    kfree((void *)mem);
    8000152a:	854a                	mv	a0,s2
    8000152c:	cfaff0ef          	jal	80000a26 <kfree>
    return 0;
    80001530:	4a01                	li	s4,0
    80001532:	64e2                	ld	s1,24(sp)
    80001534:	6942                	ld	s2,16(sp)
    80001536:	69a2                	ld	s3,8(sp)
    80001538:	bf79                	j	800014d6 <vmfault+0x10>
    8000153a:	64e2                	ld	s1,24(sp)
    8000153c:	6942                	ld	s2,16(sp)
    8000153e:	69a2                	ld	s3,8(sp)
    80001540:	bf59                	j	800014d6 <vmfault+0x10>

0000000080001542 <copyout>:
  while (len > 0) {
    80001542:	cf49                	beqz	a4,800015dc <copyout+0x9a>
{
    80001544:	7159                	addi	sp,sp,-112
    80001546:	f486                	sd	ra,104(sp)
    80001548:	f0a2                	sd	s0,96(sp)
    8000154a:	eca6                	sd	s1,88(sp)
    8000154c:	e8ca                	sd	s2,80(sp)
    8000154e:	e4ce                	sd	s3,72(sp)
    80001550:	e0d2                	sd	s4,64(sp)
    80001552:	fc56                	sd	s5,56(sp)
    80001554:	f85a                	sd	s6,48(sp)
    80001556:	f45e                	sd	s7,40(sp)
    80001558:	f062                	sd	s8,32(sp)
    8000155a:	ec66                	sd	s9,24(sp)
    8000155c:	e86a                	sd	s10,16(sp)
    8000155e:	e46e                	sd	s11,8(sp)
    80001560:	1880                	addi	s0,sp,112
    80001562:	8baa                	mv	s7,a0
    80001564:	8dae                	mv	s11,a1
    80001566:	8a32                	mv	s4,a2
    80001568:	8b36                	mv	s6,a3
    8000156a:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    8000156c:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    8000156e:	5cfd                	li	s9,-1
    80001570:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001574:	6c05                	lui	s8,0x1
    80001576:	a005                	j	80001596 <copyout+0x54>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001578:	409a0533          	sub	a0,s4,s1
    8000157c:	0009061b          	sext.w	a2,s2
    80001580:	85da                	mv	a1,s6
    80001582:	954e                	add	a0,a0,s3
    80001584:	f84ff0ef          	jal	80000d08 <memmove>
    len -= n;
    80001588:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000158c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000158e:	01848a33          	add	s4,s1,s8
  while (len > 0) {
    80001592:	040a8363          	beqz	s5,800015d8 <copyout+0x96>
    va0 = PGROUNDDOWN(dstva);
    80001596:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    8000159a:	049ce363          	bltu	s9,s1,800015e0 <copyout+0x9e>
    pa0 = walkaddr(pagetable, va0);
    8000159e:	85a6                	mv	a1,s1
    800015a0:	855e                	mv	a0,s7
    800015a2:	a37ff0ef          	jal	80000fd8 <walkaddr>
    800015a6:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015a8:	e909                	bnez	a0,800015ba <copyout+0x78>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015aa:	4681                	li	a3,0
    800015ac:	8626                	mv	a2,s1
    800015ae:	85ee                	mv	a1,s11
    800015b0:	855e                	mv	a0,s7
    800015b2:	f15ff0ef          	jal	800014c6 <vmfault>
    800015b6:	89aa                	mv	s3,a0
    800015b8:	c521                	beqz	a0,80001600 <copyout+0xbe>
    pte = walk(pagetable, va0, 0);
    800015ba:	4601                	li	a2,0
    800015bc:	85a6                	mv	a1,s1
    800015be:	855e                	mv	a0,s7
    800015c0:	97fff0ef          	jal	80000f3e <walk>
    if ((*pte & PTE_W) == 0)
    800015c4:	611c                	ld	a5,0(a0)
    800015c6:	8b91                	andi	a5,a5,4
    800015c8:	cf95                	beqz	a5,80001604 <copyout+0xc2>
    n = PGSIZE - (dstva - va0);
    800015ca:	41448933          	sub	s2,s1,s4
    800015ce:	9962                	add	s2,s2,s8
    if (n > len)
    800015d0:	fb2af4e3          	bgeu	s5,s2,80001578 <copyout+0x36>
    800015d4:	8956                	mv	s2,s5
    800015d6:	b74d                	j	80001578 <copyout+0x36>
  return 0;
    800015d8:	4501                	li	a0,0
    800015da:	a021                	j	800015e2 <copyout+0xa0>
    800015dc:	4501                	li	a0,0
}
    800015de:	8082                	ret
      return -1;
    800015e0:	557d                	li	a0,-1
}
    800015e2:	70a6                	ld	ra,104(sp)
    800015e4:	7406                	ld	s0,96(sp)
    800015e6:	64e6                	ld	s1,88(sp)
    800015e8:	6946                	ld	s2,80(sp)
    800015ea:	69a6                	ld	s3,72(sp)
    800015ec:	6a06                	ld	s4,64(sp)
    800015ee:	7ae2                	ld	s5,56(sp)
    800015f0:	7b42                	ld	s6,48(sp)
    800015f2:	7ba2                	ld	s7,40(sp)
    800015f4:	7c02                	ld	s8,32(sp)
    800015f6:	6ce2                	ld	s9,24(sp)
    800015f8:	6d42                	ld	s10,16(sp)
    800015fa:	6da2                	ld	s11,8(sp)
    800015fc:	6165                	addi	sp,sp,112
    800015fe:	8082                	ret
        return -1;
    80001600:	557d                	li	a0,-1
    80001602:	b7c5                	j	800015e2 <copyout+0xa0>
      return -1;
    80001604:	557d                	li	a0,-1
    80001606:	bff1                	j	800015e2 <copyout+0xa0>

0000000080001608 <copyin>:
  while (len > 0) {
    80001608:	cf41                	beqz	a4,800016a0 <copyin+0x98>
{
    8000160a:	711d                	addi	sp,sp,-96
    8000160c:	ec86                	sd	ra,88(sp)
    8000160e:	e8a2                	sd	s0,80(sp)
    80001610:	e4a6                	sd	s1,72(sp)
    80001612:	e0ca                	sd	s2,64(sp)
    80001614:	fc4e                	sd	s3,56(sp)
    80001616:	f852                	sd	s4,48(sp)
    80001618:	f456                	sd	s5,40(sp)
    8000161a:	f05a                	sd	s6,32(sp)
    8000161c:	ec5e                	sd	s7,24(sp)
    8000161e:	e862                	sd	s8,16(sp)
    80001620:	e466                	sd	s9,8(sp)
    80001622:	e06a                	sd	s10,0(sp)
    80001624:	1080                	addi	s0,sp,96
    80001626:	8baa                	mv	s7,a0
    80001628:	8cae                	mv	s9,a1
    8000162a:	8ab2                	mv	s5,a2
    8000162c:	8936                	mv	s2,a3
    8000162e:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    80001630:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001632:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001634:	6b05                	lui	s6,0x1
    80001636:	a035                	j	80001662 <copyin+0x5a>
    80001638:	412984b3          	sub	s1,s3,s2
    8000163c:	94da                	add	s1,s1,s6
    if (n > len)
    8000163e:	009a7363          	bgeu	s4,s1,80001644 <copyin+0x3c>
    80001642:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001644:	413905b3          	sub	a1,s2,s3
    80001648:	0004861b          	sext.w	a2,s1
    8000164c:	95aa                	add	a1,a1,a0
    8000164e:	8556                	mv	a0,s5
    80001650:	eb8ff0ef          	jal	80000d08 <memmove>
    len -= n;
    80001654:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001658:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    8000165a:	01698933          	add	s2,s3,s6
  while (len > 0) {
    8000165e:	020a0263          	beqz	s4,80001682 <copyin+0x7a>
    va0 = PGROUNDDOWN(srcva);
    80001662:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001666:	85ce                	mv	a1,s3
    80001668:	855e                	mv	a0,s7
    8000166a:	96fff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    8000166e:	f569                	bnez	a0,80001638 <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001670:	86ea                	mv	a3,s10
    80001672:	864e                	mv	a2,s3
    80001674:	85e6                	mv	a1,s9
    80001676:	855e                	mv	a0,s7
    80001678:	e4fff0ef          	jal	800014c6 <vmfault>
    8000167c:	fd55                	bnez	a0,80001638 <copyin+0x30>
        return -1;
    8000167e:	557d                	li	a0,-1
    80001680:	a011                	j	80001684 <copyin+0x7c>
  return 0;
    80001682:	4501                	li	a0,0
}
    80001684:	60e6                	ld	ra,88(sp)
    80001686:	6446                	ld	s0,80(sp)
    80001688:	64a6                	ld	s1,72(sp)
    8000168a:	6906                	ld	s2,64(sp)
    8000168c:	79e2                	ld	s3,56(sp)
    8000168e:	7a42                	ld	s4,48(sp)
    80001690:	7aa2                	ld	s5,40(sp)
    80001692:	7b02                	ld	s6,32(sp)
    80001694:	6be2                	ld	s7,24(sp)
    80001696:	6c42                	ld	s8,16(sp)
    80001698:	6ca2                	ld	s9,8(sp)
    8000169a:	6d02                	ld	s10,0(sp)
    8000169c:	6125                	addi	sp,sp,96
    8000169e:	8082                	ret
  return 0;
    800016a0:	4501                	li	a0,0
}
    800016a2:	8082                	ret

00000000800016a4 <copyinstr>:
  while (got_null == 0 && max > 0) {
    800016a4:	c769                	beqz	a4,8000176e <copyinstr+0xca>
{
    800016a6:	711d                	addi	sp,sp,-96
    800016a8:	ec86                	sd	ra,88(sp)
    800016aa:	e8a2                	sd	s0,80(sp)
    800016ac:	e4a6                	sd	s1,72(sp)
    800016ae:	e0ca                	sd	s2,64(sp)
    800016b0:	fc4e                	sd	s3,56(sp)
    800016b2:	f852                	sd	s4,48(sp)
    800016b4:	f456                	sd	s5,40(sp)
    800016b6:	f05a                	sd	s6,32(sp)
    800016b8:	ec5e                	sd	s7,24(sp)
    800016ba:	e862                	sd	s8,16(sp)
    800016bc:	e466                	sd	s9,8(sp)
    800016be:	1080                	addi	s0,sp,96
    800016c0:	8b2a                	mv	s6,a0
    800016c2:	8c2e                	mv	s8,a1
    800016c4:	89b2                	mv	s3,a2
    800016c6:	84b6                	mv	s1,a3
    800016c8:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016ca:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016cc:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016ce:	6a85                	lui	s5,0x1
    800016d0:	a881                	j	80001720 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016d2:	86e6                	mv	a3,s9
    800016d4:	864a                	mv	a2,s2
    800016d6:	85e2                	mv	a1,s8
    800016d8:	855a                	mv	a0,s6
    800016da:	dedff0ef          	jal	800014c6 <vmfault>
    800016de:	e921                	bnez	a0,8000172e <copyinstr+0x8a>
        return -1;
    800016e0:	557d                	li	a0,-1
    800016e2:	a801                	j	800016f2 <copyinstr+0x4e>
        *dst = '\0';
    800016e4:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb650>
        got_null = 1;
    800016e8:	4785                	li	a5,1
  if (got_null) {
    800016ea:	0017c793          	xori	a5,a5,1
    800016ee:	40f0053b          	negw	a0,a5
}
    800016f2:	60e6                	ld	ra,88(sp)
    800016f4:	6446                	ld	s0,80(sp)
    800016f6:	64a6                	ld	s1,72(sp)
    800016f8:	6906                	ld	s2,64(sp)
    800016fa:	79e2                	ld	s3,56(sp)
    800016fc:	7a42                	ld	s4,48(sp)
    800016fe:	7aa2                	ld	s5,40(sp)
    80001700:	7b02                	ld	s6,32(sp)
    80001702:	6be2                	ld	s7,24(sp)
    80001704:	6c42                	ld	s8,16(sp)
    80001706:	6ca2                	ld	s9,8(sp)
    80001708:	6125                	addi	sp,sp,96
    8000170a:	8082                	ret
    8000170c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80001710:	974e                	add	a4,a4,s3
      --max;
    80001712:	40b70a33          	sub	s4,a4,a1
    srcva = va0 + PGSIZE;
    80001716:	015904b3          	add	s1,s2,s5
  while (got_null == 0 && max > 0) {
    8000171a:	04e58463          	beq	a1,a4,80001762 <copyinstr+0xbe>
{
    8000171e:	89be                	mv	s3,a5
    va0 = PGROUNDDOWN(srcva);
    80001720:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001724:	85ca                	mv	a1,s2
    80001726:	855a                	mv	a0,s6
    80001728:	8b1ff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    8000172c:	d15d                	beqz	a0,800016d2 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    8000172e:	40990633          	sub	a2,s2,s1
    80001732:	9656                	add	a2,a2,s5
    if (n > max)
    80001734:	00ca7363          	bgeu	s4,a2,8000173a <copyinstr+0x96>
    80001738:	8652                	mv	a2,s4
    while (n > 0) {
    8000173a:	c615                	beqz	a2,80001766 <copyinstr+0xc2>
    char *p = (char *)(pa0 + (srcva - va0));
    8000173c:	412484b3          	sub	s1,s1,s2
    80001740:	94aa                	add	s1,s1,a0
    80001742:	87ce                	mv	a5,s3
      if (*p == '\0') {
    80001744:	413484b3          	sub	s1,s1,s3
    while (n > 0) {
    80001748:	964e                	add	a2,a2,s3
    8000174a:	85be                	mv	a1,a5
      if (*p == '\0') {
    8000174c:	00f48733          	add	a4,s1,a5
    80001750:	00074683          	lbu	a3,0(a4)
    80001754:	dac1                	beqz	a3,800016e4 <copyinstr+0x40>
        *dst = *p;
    80001756:	00d78023          	sb	a3,0(a5)
      dst++;
    8000175a:	0785                	addi	a5,a5,1
    while (n > 0) {
    8000175c:	fec797e3          	bne	a5,a2,8000174a <copyinstr+0xa6>
    80001760:	b775                	j	8000170c <copyinstr+0x68>
    80001762:	4781                	li	a5,0
    80001764:	b759                	j	800016ea <copyinstr+0x46>
    srcva = va0 + PGSIZE;
    80001766:	6485                	lui	s1,0x1
    80001768:	94ca                	add	s1,s1,s2
    8000176a:	87ce                	mv	a5,s3
    8000176c:	bf4d                	j	8000171e <copyinstr+0x7a>
  int got_null = 0;
    8000176e:	4781                	li	a5,0
  if (got_null) {
    80001770:	0017c793          	xori	a5,a5,1
    80001774:	40f0053b          	negw	a0,a5
}
    80001778:	8082                	ret

000000008000177a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000177a:	715d                	addi	sp,sp,-80
    8000177c:	e486                	sd	ra,72(sp)
    8000177e:	e0a2                	sd	s0,64(sp)
    80001780:	fc26                	sd	s1,56(sp)
    80001782:	f84a                	sd	s2,48(sp)
    80001784:	f44e                	sd	s3,40(sp)
    80001786:	f052                	sd	s4,32(sp)
    80001788:	ec56                	sd	s5,24(sp)
    8000178a:	e85a                	sd	s6,16(sp)
    8000178c:	e45e                	sd	s7,8(sp)
    8000178e:	e062                	sd	s8,0(sp)
    80001790:	0880                	addi	s0,sp,80
    80001792:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001794:	00011497          	auipc	s1,0x11
    80001798:	23c48493          	addi	s1,s1,572 # 800129d0 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000179c:	8c26                	mv	s8,s1
    8000179e:	ff4df937          	lui	s2,0xff4df
    800017a2:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb00d>
    800017a6:	0936                	slli	s2,s2,0xd
    800017a8:	6f590913          	addi	s2,s2,1781
    800017ac:	0936                	slli	s2,s2,0xd
    800017ae:	bd390913          	addi	s2,s2,-1069
    800017b2:	0932                	slli	s2,s2,0xc
    800017b4:	7a790913          	addi	s2,s2,1959
    800017b8:	040009b7          	lui	s3,0x4000
    800017bc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017be:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017c0:	4b99                	li	s7,6
    800017c2:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017c4:	00017a97          	auipc	s5,0x17
    800017c8:	e0ca8a93          	addi	s5,s5,-500 # 800185d0 <tickslock>
    char *pa = kalloc();
    800017cc:	b42ff0ef          	jal	80000b0e <kalloc>
    800017d0:	862a                	mv	a2,a0
    if (pa == 0)
    800017d2:	c121                	beqz	a0,80001812 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int)(p - proc));
    800017d4:	418485b3          	sub	a1,s1,s8
    800017d8:	8591                	srai	a1,a1,0x4
    800017da:	032585b3          	mul	a1,a1,s2
    800017de:	05b6                	slli	a1,a1,0xd
    800017e0:	6789                	lui	a5,0x2
    800017e2:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e4:	875e                	mv	a4,s7
    800017e6:	86da                	mv	a3,s6
    800017e8:	40b985b3          	sub	a1,s3,a1
    800017ec:	8552                	mv	a0,s4
    800017ee:	8dbff0ef          	jal	800010c8 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017f2:	17048493          	addi	s1,s1,368
    800017f6:	fd549be3          	bne	s1,s5,800017cc <proc_mapstacks+0x52>
  }
}
    800017fa:	60a6                	ld	ra,72(sp)
    800017fc:	6406                	ld	s0,64(sp)
    800017fe:	74e2                	ld	s1,56(sp)
    80001800:	7942                	ld	s2,48(sp)
    80001802:	79a2                	ld	s3,40(sp)
    80001804:	7a02                	ld	s4,32(sp)
    80001806:	6ae2                	ld	s5,24(sp)
    80001808:	6b42                	ld	s6,16(sp)
    8000180a:	6ba2                	ld	s7,8(sp)
    8000180c:	6c02                	ld	s8,0(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret
      panic("kalloc");
    80001812:	00006517          	auipc	a0,0x6
    80001816:	94650513          	addi	a0,a0,-1722 # 80007158 <etext+0x158>
    8000181a:	81aff0ef          	jal	80000834 <panic>

000000008000181e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000181e:	7139                	addi	sp,sp,-64
    80001820:	fc06                	sd	ra,56(sp)
    80001822:	f822                	sd	s0,48(sp)
    80001824:	f426                	sd	s1,40(sp)
    80001826:	f04a                	sd	s2,32(sp)
    80001828:	ec4e                	sd	s3,24(sp)
    8000182a:	e852                	sd	s4,16(sp)
    8000182c:	e456                	sd	s5,8(sp)
    8000182e:	e05a                	sd	s6,0(sp)
    80001830:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001832:	00006597          	auipc	a1,0x6
    80001836:	92e58593          	addi	a1,a1,-1746 # 80007160 <etext+0x160>
    8000183a:	00011517          	auipc	a0,0x11
    8000183e:	d6650513          	addi	a0,a0,-666 # 800125a0 <pid_lock>
    80001842:	b26ff0ef          	jal	80000b68 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001846:	00006597          	auipc	a1,0x6
    8000184a:	92258593          	addi	a1,a1,-1758 # 80007168 <etext+0x168>
    8000184e:	00011517          	auipc	a0,0x11
    80001852:	d6a50513          	addi	a0,a0,-662 # 800125b8 <wait_lock>
    80001856:	b12ff0ef          	jal	80000b68 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000185a:	00011497          	auipc	s1,0x11
    8000185e:	17648493          	addi	s1,s1,374 # 800129d0 <proc>
    initlock(&p->lock, "proc");
    80001862:	00006b17          	auipc	s6,0x6
    80001866:	916b0b13          	addi	s6,s6,-1770 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    8000186a:	8aa6                	mv	s5,s1
    8000186c:	ff4df937          	lui	s2,0xff4df
    80001870:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bb00d>
    80001874:	0936                	slli	s2,s2,0xd
    80001876:	6f590913          	addi	s2,s2,1781
    8000187a:	0936                	slli	s2,s2,0xd
    8000187c:	bd390913          	addi	s2,s2,-1069
    80001880:	0932                	slli	s2,s2,0xc
    80001882:	7a790913          	addi	s2,s2,1959
    80001886:	040009b7          	lui	s3,0x4000
    8000188a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000188e:	00017a17          	auipc	s4,0x17
    80001892:	d42a0a13          	addi	s4,s4,-702 # 800185d0 <tickslock>
    initlock(&p->lock, "proc");
    80001896:	85da                	mv	a1,s6
    80001898:	8526                	mv	a0,s1
    8000189a:	aceff0ef          	jal	80000b68 <initlock>
    p->state = UNUSED;
    8000189e:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    800018a2:	415487b3          	sub	a5,s1,s5
    800018a6:	8791                	srai	a5,a5,0x4
    800018a8:	032787b3          	mul	a5,a5,s2
    800018ac:	07b6                	slli	a5,a5,0xd
    800018ae:	6709                	lui	a4,0x2
    800018b0:	9fb9                	addw	a5,a5,a4
    800018b2:	40f987b3          	sub	a5,s3,a5
    800018b6:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018b8:	17048493          	addi	s1,s1,368
    800018bc:	fd449de3          	bne	s1,s4,80001896 <procinit+0x78>
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6b02                	ld	s6,0(sp)
    800018d0:	6121                	addi	sp,sp,64
    800018d2:	8082                	ret

00000000800018d4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e406                	sd	ra,8(sp)
    800018d8:	e022                	sd	s0,0(sp)
    800018da:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018dc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018de:	2501                	sext.w	a0,a0
    800018e0:	60a2                	ld	ra,8(sp)
    800018e2:	6402                	ld	s0,0(sp)
    800018e4:	0141                	addi	sp,sp,16
    800018e6:	8082                	ret

00000000800018e8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018e8:	1141                	addi	sp,sp,-16
    800018ea:	e406                	sd	ra,8(sp)
    800018ec:	e022                	sd	s0,0(sp)
    800018ee:	0800                	addi	s0,sp,16
    800018f0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018f2:	2781                	sext.w	a5,a5
    800018f4:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f6:	00011517          	auipc	a0,0x11
    800018fa:	cda50513          	addi	a0,a0,-806 # 800125d0 <cpus>
    800018fe:	953e                	add	a0,a0,a5
    80001900:	60a2                	ld	ra,8(sp)
    80001902:	6402                	ld	s0,0(sp)
    80001904:	0141                	addi	sp,sp,16
    80001906:	8082                	ret

0000000080001908 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001908:	1101                	addi	sp,sp,-32
    8000190a:	ec06                	sd	ra,24(sp)
    8000190c:	e822                	sd	s0,16(sp)
    8000190e:	e426                	sd	s1,8(sp)
    80001910:	1000                	addi	s0,sp,32
  push_off();
    80001912:	a9cff0ef          	jal	80000bae <push_off>
    80001916:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001918:	2781                	sext.w	a5,a5
    8000191a:	079e                	slli	a5,a5,0x7
    8000191c:	00011717          	auipc	a4,0x11
    80001920:	c8470713          	addi	a4,a4,-892 # 800125a0 <pid_lock>
    80001924:	97ba                	add	a5,a5,a4
    80001926:	7b9c                	ld	a5,48(a5)
    80001928:	84be                	mv	s1,a5
  pop_off();
    8000192a:	afeff0ef          	jal	80000c28 <pop_off>
  return p;
}
    8000192e:	8526                	mv	a0,s1
    80001930:	60e2                	ld	ra,24(sp)
    80001932:	6442                	ld	s0,16(sp)
    80001934:	64a2                	ld	s1,8(sp)
    80001936:	6105                	addi	sp,sp,32
    80001938:	8082                	ret

000000008000193a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000193a:	7179                	addi	sp,sp,-48
    8000193c:	f406                	sd	ra,40(sp)
    8000193e:	f022                	sd	s0,32(sp)
    80001940:	ec26                	sd	s1,24(sp)
    80001942:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001944:	fc5ff0ef          	jal	80001908 <myproc>
    80001948:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000194a:	b26ff0ef          	jal	80000c70 <release>

  if (first) {
    8000194e:	00009797          	auipc	a5,0x9
    80001952:	ae27a783          	lw	a5,-1310(a5) # 8000a430 <first.1>
    80001956:	cf85                	beqz	a5,8000198e <forkret+0x54>
    first = 0;
    80001958:	00009797          	auipc	a5,0x9
    8000195c:	ac07ac23          	sw	zero,-1320(a5) # 8000a430 <first.1>

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001960:	4505                	li	a0,1
    80001962:	467010ef          	jal	800035c8 <fsinit>

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001966:	00006797          	auipc	a5,0x6
    8000196a:	81a78793          	addi	a5,a5,-2022 # 80007180 <etext+0x180>
    8000196e:	fcf43823          	sd	a5,-48(s0)
    80001972:	fc043c23          	sd	zero,-40(s0)
    80001976:	fd040593          	addi	a1,s0,-48
    8000197a:	853e                	mv	a0,a5
    8000197c:	6cf020ef          	jal	8000484a <kexec>
    80001980:	6cbc                	ld	a5,88(s1)
    80001982:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001984:	6cbc                	ld	a5,88(s1)
    80001986:	7bb8                	ld	a4,112(a5)
    80001988:	57fd                	li	a5,-1
    8000198a:	02f70d63          	beq	a4,a5,800019c4 <forkret+0x8a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    8000198e:	305000ef          	jal	80002492 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001992:	68a8                	ld	a0,80(s1)
    80001994:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001996:	04000737          	lui	a4,0x4000
    8000199a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000199c:	0732                	slli	a4,a4,0xc
    8000199e:	00004797          	auipc	a5,0x4
    800019a2:	6fe78793          	addi	a5,a5,1790 # 8000609c <userret>
    800019a6:	00004697          	auipc	a3,0x4
    800019aa:	65a68693          	addi	a3,a3,1626 # 80006000 <_trampoline>
    800019ae:	8f95                	sub	a5,a5,a3
    800019b0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019b2:	577d                	li	a4,-1
    800019b4:	177e                	slli	a4,a4,0x3f
    800019b6:	8d59                	or	a0,a0,a4
    800019b8:	9782                	jalr	a5
}
    800019ba:	70a2                	ld	ra,40(sp)
    800019bc:	7402                	ld	s0,32(sp)
    800019be:	64e2                	ld	s1,24(sp)
    800019c0:	6145                	addi	sp,sp,48
    800019c2:	8082                	ret
      panic("exec");
    800019c4:	00005517          	auipc	a0,0x5
    800019c8:	7c450513          	addi	a0,a0,1988 # 80007188 <etext+0x188>
    800019cc:	e69fe0ef          	jal	80000834 <panic>

00000000800019d0 <allocpid>:
{
    800019d0:	1101                	addi	sp,sp,-32
    800019d2:	ec06                	sd	ra,24(sp)
    800019d4:	e822                	sd	s0,16(sp)
    800019d6:	e426                	sd	s1,8(sp)
    800019d8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019da:	00011517          	auipc	a0,0x11
    800019de:	bc650513          	addi	a0,a0,-1082 # 800125a0 <pid_lock>
    800019e2:	a06ff0ef          	jal	80000be8 <acquire>
  pid = nextpid;
    800019e6:	00009797          	auipc	a5,0x9
    800019ea:	a4e78793          	addi	a5,a5,-1458 # 8000a434 <nextpid>
    800019ee:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019f0:	0014871b          	addiw	a4,s1,1
    800019f4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019f6:	00011517          	auipc	a0,0x11
    800019fa:	baa50513          	addi	a0,a0,-1110 # 800125a0 <pid_lock>
    800019fe:	a72ff0ef          	jal	80000c70 <release>
}
    80001a02:	8526                	mv	a0,s1
    80001a04:	60e2                	ld	ra,24(sp)
    80001a06:	6442                	ld	s0,16(sp)
    80001a08:	64a2                	ld	s1,8(sp)
    80001a0a:	6105                	addi	sp,sp,32
    80001a0c:	8082                	ret

0000000080001a0e <proc_pagetable>:
{
    80001a0e:	1101                	addi	sp,sp,-32
    80001a10:	ec06                	sd	ra,24(sp)
    80001a12:	e822                	sd	s0,16(sp)
    80001a14:	e426                	sd	s1,8(sp)
    80001a16:	e04a                	sd	s2,0(sp)
    80001a18:	1000                	addi	s0,sp,32
    80001a1a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a1c:	f9eff0ef          	jal	800011ba <uvmcreate>
    80001a20:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a22:	cd05                	beqz	a0,80001a5a <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a24:	4729                	li	a4,10
    80001a26:	00004697          	auipc	a3,0x4
    80001a2a:	5da68693          	addi	a3,a3,1498 # 80006000 <_trampoline>
    80001a2e:	6605                	lui	a2,0x1
    80001a30:	040005b7          	lui	a1,0x4000
    80001a34:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a36:	05b2                	slli	a1,a1,0xc
    80001a38:	ddaff0ef          	jal	80001012 <mappages>
    80001a3c:	02054663          	bltz	a0,80001a68 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a40:	4719                	li	a4,6
    80001a42:	05893683          	ld	a3,88(s2)
    80001a46:	6605                	lui	a2,0x1
    80001a48:	020005b7          	lui	a1,0x2000
    80001a4c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a4e:	05b6                	slli	a1,a1,0xd
    80001a50:	8526                	mv	a0,s1
    80001a52:	dc0ff0ef          	jal	80001012 <mappages>
    80001a56:	00054f63          	bltz	a0,80001a74 <proc_pagetable+0x66>
}
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	60e2                	ld	ra,24(sp)
    80001a5e:	6442                	ld	s0,16(sp)
    80001a60:	64a2                	ld	s1,8(sp)
    80001a62:	6902                	ld	s2,0(sp)
    80001a64:	6105                	addi	sp,sp,32
    80001a66:	8082                	ret
    uvmfree(pagetable, 0);
    80001a68:	4581                	li	a1,0
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	949ff0ef          	jal	800013b4 <uvmfree>
    return 0;
    80001a70:	4481                	li	s1,0
    80001a72:	b7e5                	j	80001a5a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a74:	4681                	li	a3,0
    80001a76:	4605                	li	a2,1
    80001a78:	040005b7          	lui	a1,0x4000
    80001a7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a7e:	05b2                	slli	a1,a1,0xc
    80001a80:	8526                	mv	a0,s1
    80001a82:	f5eff0ef          	jal	800011e0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a86:	4581                	li	a1,0
    80001a88:	8526                	mv	a0,s1
    80001a8a:	92bff0ef          	jal	800013b4 <uvmfree>
    return 0;
    80001a8e:	4481                	li	s1,0
    80001a90:	b7e9                	j	80001a5a <proc_pagetable+0x4c>

0000000080001a92 <proc_freepagetable>:
{
    80001a92:	1101                	addi	sp,sp,-32
    80001a94:	ec06                	sd	ra,24(sp)
    80001a96:	e822                	sd	s0,16(sp)
    80001a98:	e426                	sd	s1,8(sp)
    80001a9a:	e04a                	sd	s2,0(sp)
    80001a9c:	1000                	addi	s0,sp,32
    80001a9e:	84aa                	mv	s1,a0
    80001aa0:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aa2:	4681                	li	a3,0
    80001aa4:	4605                	li	a2,1
    80001aa6:	040005b7          	lui	a1,0x4000
    80001aaa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aac:	05b2                	slli	a1,a1,0xc
    80001aae:	f32ff0ef          	jal	800011e0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ab2:	4681                	li	a3,0
    80001ab4:	4605                	li	a2,1
    80001ab6:	020005b7          	lui	a1,0x2000
    80001aba:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001abc:	05b6                	slli	a1,a1,0xd
    80001abe:	8526                	mv	a0,s1
    80001ac0:	f20ff0ef          	jal	800011e0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001ac4:	85ca                	mv	a1,s2
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	8edff0ef          	jal	800013b4 <uvmfree>
}
    80001acc:	60e2                	ld	ra,24(sp)
    80001ace:	6442                	ld	s0,16(sp)
    80001ad0:	64a2                	ld	s1,8(sp)
    80001ad2:	6902                	ld	s2,0(sp)
    80001ad4:	6105                	addi	sp,sp,32
    80001ad6:	8082                	ret

0000000080001ad8 <freeproc>:
{
    80001ad8:	1101                	addi	sp,sp,-32
    80001ada:	ec06                	sd	ra,24(sp)
    80001adc:	e822                	sd	s0,16(sp)
    80001ade:	e426                	sd	s1,8(sp)
    80001ae0:	1000                	addi	s0,sp,32
    80001ae2:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001ae4:	6d28                	ld	a0,88(a0)
    80001ae6:	c119                	beqz	a0,80001aec <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001ae8:	f3ffe0ef          	jal	80000a26 <kfree>
  p->trapframe = 0;
    80001aec:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001af0:	68a8                	ld	a0,80(s1)
    80001af2:	c501                	beqz	a0,80001afa <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001af4:	64ac                	ld	a1,72(s1)
    80001af6:	f9dff0ef          	jal	80001a92 <proc_freepagetable>
  p->pagetable = 0;
    80001afa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001afe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b02:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001b06:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b0a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b0e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b12:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b16:	0004ac23          	sw	zero,24(s1)
}
    80001b1a:	60e2                	ld	ra,24(sp)
    80001b1c:	6442                	ld	s0,16(sp)
    80001b1e:	64a2                	ld	s1,8(sp)
    80001b20:	6105                	addi	sp,sp,32
    80001b22:	8082                	ret

0000000080001b24 <allocproc>:
{
    80001b24:	1101                	addi	sp,sp,-32
    80001b26:	ec06                	sd	ra,24(sp)
    80001b28:	e822                	sd	s0,16(sp)
    80001b2a:	e426                	sd	s1,8(sp)
    80001b2c:	e04a                	sd	s2,0(sp)
    80001b2e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b30:	00011497          	auipc	s1,0x11
    80001b34:	ea048493          	addi	s1,s1,-352 # 800129d0 <proc>
    80001b38:	00017917          	auipc	s2,0x17
    80001b3c:	a9890913          	addi	s2,s2,-1384 # 800185d0 <tickslock>
    acquire(&p->lock);
    80001b40:	8526                	mv	a0,s1
    80001b42:	8a6ff0ef          	jal	80000be8 <acquire>
    if (p->state == UNUSED) {
    80001b46:	4c9c                	lw	a5,24(s1)
    80001b48:	cb91                	beqz	a5,80001b5c <allocproc+0x38>
      release(&p->lock);
    80001b4a:	8526                	mv	a0,s1
    80001b4c:	924ff0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b50:	17048493          	addi	s1,s1,368
    80001b54:	ff2496e3          	bne	s1,s2,80001b40 <allocproc+0x1c>
  return 0;
    80001b58:	4481                	li	s1,0
    80001b5a:	a089                	j	80001b9c <allocproc+0x78>
  p->pid = allocpid();
    80001b5c:	e75ff0ef          	jal	800019d0 <allocpid>
    80001b60:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b62:	4785                	li	a5,1
    80001b64:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b66:	fa9fe0ef          	jal	80000b0e <kalloc>
    80001b6a:	892a                	mv	s2,a0
    80001b6c:	eca8                	sd	a0,88(s1)
    80001b6e:	cd15                	beqz	a0,80001baa <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b70:	8526                	mv	a0,s1
    80001b72:	e9dff0ef          	jal	80001a0e <proc_pagetable>
    80001b76:	892a                	mv	s2,a0
    80001b78:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b7a:	c121                	beqz	a0,80001bba <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b7c:	07000613          	li	a2,112
    80001b80:	4581                	li	a1,0
    80001b82:	06048513          	addi	a0,s1,96
    80001b86:	922ff0ef          	jal	80000ca8 <memset>
  p->context.ra = (uint64)forkret;
    80001b8a:	00000797          	auipc	a5,0x0
    80001b8e:	db078793          	addi	a5,a5,-592 # 8000193a <forkret>
    80001b92:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b94:	60bc                	ld	a5,64(s1)
    80001b96:	6705                	lui	a4,0x1
    80001b98:	97ba                	add	a5,a5,a4
    80001b9a:	f4bc                	sd	a5,104(s1)
}
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	60e2                	ld	ra,24(sp)
    80001ba0:	6442                	ld	s0,16(sp)
    80001ba2:	64a2                	ld	s1,8(sp)
    80001ba4:	6902                	ld	s2,0(sp)
    80001ba6:	6105                	addi	sp,sp,32
    80001ba8:	8082                	ret
    freeproc(p);
    80001baa:	8526                	mv	a0,s1
    80001bac:	f2dff0ef          	jal	80001ad8 <freeproc>
    release(&p->lock);
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	8beff0ef          	jal	80000c70 <release>
    return 0;
    80001bb6:	84ca                	mv	s1,s2
    80001bb8:	b7d5                	j	80001b9c <allocproc+0x78>
    freeproc(p);
    80001bba:	8526                	mv	a0,s1
    80001bbc:	f1dff0ef          	jal	80001ad8 <freeproc>
    release(&p->lock);
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	8aeff0ef          	jal	80000c70 <release>
    return 0;
    80001bc6:	84ca                	mv	s1,s2
    80001bc8:	bfd1                	j	80001b9c <allocproc+0x78>

0000000080001bca <userinit>:
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bd4:	f51ff0ef          	jal	80001b24 <allocproc>
    80001bd8:	84aa                	mv	s1,a0
  initproc = p;
    80001bda:	00009797          	auipc	a5,0x9
    80001bde:	88a7bf23          	sd	a0,-1890(a5) # 8000a478 <initproc>
  p->cwd = namei("/");
    80001be2:	00005517          	auipc	a0,0x5
    80001be6:	5ae50513          	addi	a0,a0,1454 # 80007190 <etext+0x190>
    80001bea:	72f010ef          	jal	80003b18 <namei>
    80001bee:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bf2:	478d                	li	a5,3
    80001bf4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	878ff0ef          	jal	80000c70 <release>
}
    80001bfc:	60e2                	ld	ra,24(sp)
    80001bfe:	6442                	ld	s0,16(sp)
    80001c00:	64a2                	ld	s1,8(sp)
    80001c02:	6105                	addi	sp,sp,32
    80001c04:	8082                	ret

0000000080001c06 <growproc>:
{
    80001c06:	1101                	addi	sp,sp,-32
    80001c08:	ec06                	sd	ra,24(sp)
    80001c0a:	e822                	sd	s0,16(sp)
    80001c0c:	e426                	sd	s1,8(sp)
    80001c0e:	e04a                	sd	s2,0(sp)
    80001c10:	1000                	addi	s0,sp,32
    80001c12:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c14:	cf5ff0ef          	jal	80001908 <myproc>
    80001c18:	892a                	mv	s2,a0
  sz = p->sz;
    80001c1a:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c1c:	02905963          	blez	s1,80001c4e <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80001c20:	00b48633          	add	a2,s1,a1
    80001c24:	020007b7          	lui	a5,0x2000
    80001c28:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c2a:	07b6                	slli	a5,a5,0xd
    80001c2c:	02c7ea63          	bltu	a5,a2,80001c60 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c30:	4691                	li	a3,4
    80001c32:	6928                	ld	a0,80(a0)
    80001c34:	e7aff0ef          	jal	800012ae <uvmalloc>
    80001c38:	85aa                	mv	a1,a0
    80001c3a:	c50d                	beqz	a0,80001c64 <growproc+0x5e>
  p->sz = sz;
    80001c3c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c40:	4501                	li	a0,0
}
    80001c42:	60e2                	ld	ra,24(sp)
    80001c44:	6442                	ld	s0,16(sp)
    80001c46:	64a2                	ld	s1,8(sp)
    80001c48:	6902                	ld	s2,0(sp)
    80001c4a:	6105                	addi	sp,sp,32
    80001c4c:	8082                	ret
  } else if (n < 0) {
    80001c4e:	fe04d7e3          	bgez	s1,80001c3c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c52:	00b48633          	add	a2,s1,a1
    80001c56:	6928                	ld	a0,80(a0)
    80001c58:	e12ff0ef          	jal	8000126a <uvmdealloc>
    80001c5c:	85aa                	mv	a1,a0
    80001c5e:	bff9                	j	80001c3c <growproc+0x36>
      return -1;
    80001c60:	557d                	li	a0,-1
    80001c62:	b7c5                	j	80001c42 <growproc+0x3c>
      return -1;
    80001c64:	557d                	li	a0,-1
    80001c66:	bff1                	j	80001c42 <growproc+0x3c>

0000000080001c68 <kfork>:
{
    80001c68:	7139                	addi	sp,sp,-64
    80001c6a:	fc06                	sd	ra,56(sp)
    80001c6c:	f822                	sd	s0,48(sp)
    80001c6e:	f426                	sd	s1,40(sp)
    80001c70:	e456                	sd	s5,8(sp)
    80001c72:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c74:	c95ff0ef          	jal	80001908 <myproc>
    80001c78:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c7a:	eabff0ef          	jal	80001b24 <allocproc>
    80001c7e:	0e050e63          	beqz	a0,80001d7a <kfork+0x112>
    80001c82:	ec4e                	sd	s3,24(sp)
    80001c84:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c86:	048ab603          	ld	a2,72(s5)
    80001c8a:	692c                	ld	a1,80(a0)
    80001c8c:	050ab503          	ld	a0,80(s5)
    80001c90:	f56ff0ef          	jal	800013e6 <uvmcopy>
    80001c94:	04054863          	bltz	a0,80001ce4 <kfork+0x7c>
    80001c98:	f04a                	sd	s2,32(sp)
    80001c9a:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c9c:	048ab783          	ld	a5,72(s5)
    80001ca0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001ca4:	058ab683          	ld	a3,88(s5)
    80001ca8:	87b6                	mv	a5,a3
    80001caa:	0589b703          	ld	a4,88(s3)
    80001cae:	12068693          	addi	a3,a3,288
    80001cb2:	6388                	ld	a0,0(a5)
    80001cb4:	678c                	ld	a1,8(a5)
    80001cb6:	6b90                	ld	a2,16(a5)
    80001cb8:	e308                	sd	a0,0(a4)
    80001cba:	e70c                	sd	a1,8(a4)
    80001cbc:	eb10                	sd	a2,16(a4)
    80001cbe:	6f90                	ld	a2,24(a5)
    80001cc0:	ef10                	sd	a2,24(a4)
    80001cc2:	02078793          	addi	a5,a5,32
    80001cc6:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cca:	fed794e3          	bne	a5,a3,80001cb2 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cce:	0589b783          	ld	a5,88(s3)
    80001cd2:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cd6:	0d0a8493          	addi	s1,s5,208
    80001cda:	0d098913          	addi	s2,s3,208
    80001cde:	150a8a13          	addi	s4,s5,336
    80001ce2:	a831                	j	80001cfe <kfork+0x96>
    freeproc(np);
    80001ce4:	854e                	mv	a0,s3
    80001ce6:	df3ff0ef          	jal	80001ad8 <freeproc>
    release(&np->lock);
    80001cea:	854e                	mv	a0,s3
    80001cec:	f85fe0ef          	jal	80000c70 <release>
    return -1;
    80001cf0:	54fd                	li	s1,-1
    80001cf2:	69e2                	ld	s3,24(sp)
    80001cf4:	a8a5                	j	80001d6c <kfork+0x104>
  for (i = 0; i < NOFILE; i++)
    80001cf6:	04a1                	addi	s1,s1,8
    80001cf8:	0921                	addi	s2,s2,8
    80001cfa:	01448963          	beq	s1,s4,80001d0c <kfork+0xa4>
    if (p->ofile[i])
    80001cfe:	6088                	ld	a0,0(s1)
    80001d00:	d97d                	beqz	a0,80001cf6 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d02:	468020ef          	jal	8000416a <filedup>
    80001d06:	00a93023          	sd	a0,0(s2)
    80001d0a:	b7f5                	j	80001cf6 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d0c:	150ab503          	ld	a0,336(s5)
    80001d10:	546010ef          	jal	80003256 <idup>
    80001d14:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d18:	4641                	li	a2,16
    80001d1a:	158a8593          	addi	a1,s5,344
    80001d1e:	15898513          	addi	a0,s3,344
    80001d22:	8daff0ef          	jal	80000dfc <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001d26:	168aa783          	lw	a5,360(s5)
    80001d2a:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001d2e:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001d32:	854e                	mv	a0,s3
    80001d34:	f3dfe0ef          	jal	80000c70 <release>
  acquire(&wait_lock);
    80001d38:	00011517          	auipc	a0,0x11
    80001d3c:	88050513          	addi	a0,a0,-1920 # 800125b8 <wait_lock>
    80001d40:	ea9fe0ef          	jal	80000be8 <acquire>
  np->parent = p;
    80001d44:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d48:	00011517          	auipc	a0,0x11
    80001d4c:	87050513          	addi	a0,a0,-1936 # 800125b8 <wait_lock>
    80001d50:	f21fe0ef          	jal	80000c70 <release>
  acquire(&np->lock);
    80001d54:	854e                	mv	a0,s3
    80001d56:	e93fe0ef          	jal	80000be8 <acquire>
  np->state = RUNNABLE;
    80001d5a:	478d                	li	a5,3
    80001d5c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001d60:	854e                	mv	a0,s3
    80001d62:	f0ffe0ef          	jal	80000c70 <release>
  return pid;
    80001d66:	7902                	ld	s2,32(sp)
    80001d68:	69e2                	ld	s3,24(sp)
    80001d6a:	6a42                	ld	s4,16(sp)
}
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	70e2                	ld	ra,56(sp)
    80001d70:	7442                	ld	s0,48(sp)
    80001d72:	74a2                	ld	s1,40(sp)
    80001d74:	6aa2                	ld	s5,8(sp)
    80001d76:	6121                	addi	sp,sp,64
    80001d78:	8082                	ret
    return -1;
    80001d7a:	54fd                	li	s1,-1
    80001d7c:	bfc5                	j	80001d6c <kfork+0x104>

0000000080001d7e <scheduler>:
{
    80001d7e:	711d                	addi	sp,sp,-96
    80001d80:	ec86                	sd	ra,88(sp)
    80001d82:	e8a2                	sd	s0,80(sp)
    80001d84:	e4a6                	sd	s1,72(sp)
    80001d86:	e0ca                	sd	s2,64(sp)
    80001d88:	fc4e                	sd	s3,56(sp)
    80001d8a:	f852                	sd	s4,48(sp)
    80001d8c:	f456                	sd	s5,40(sp)
    80001d8e:	f05a                	sd	s6,32(sp)
    80001d90:	ec5e                	sd	s7,24(sp)
    80001d92:	e862                	sd	s8,16(sp)
    80001d94:	e466                	sd	s9,8(sp)
    80001d96:	1080                	addi	s0,sp,96
    80001d98:	8792                	mv	a5,tp
  int id = r_tp();
    80001d9a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d9c:	00779a93          	slli	s5,a5,0x7
    80001da0:	00011717          	auipc	a4,0x11
    80001da4:	80070713          	addi	a4,a4,-2048 # 800125a0 <pid_lock>
    80001da8:	9756                	add	a4,a4,s5
    80001daa:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001dae:	00011717          	auipc	a4,0x11
    80001db2:	82a70713          	addi	a4,a4,-2006 # 800125d8 <cpus+0x8>
    80001db6:	9aba                	add	s5,s5,a4
        p->state = RUNNING;
    80001db8:	4c11                	li	s8,4
        c->proc = p;
    80001dba:	00010b17          	auipc	s6,0x10
    80001dbe:	7e6b0b13          	addi	s6,s6,2022 # 800125a0 <pid_lock>
    80001dc2:	079e                	slli	a5,a5,0x7
    80001dc4:	00fb0a33          	add	s4,s6,a5
        found = 1;
    80001dc8:	4b85                	li	s7,1
    80001dca:	a0a9                	j	80001e14 <scheduler+0x96>
      release(&p->lock);
    80001dcc:	8526                	mv	a0,s1
    80001dce:	ea3fe0ef          	jal	80000c70 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dd2:	17048493          	addi	s1,s1,368
    80001dd6:	03248b63          	beq	s1,s2,80001e0c <scheduler+0x8e>
      acquire(&p->lock);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	e0dfe0ef          	jal	80000be8 <acquire>
      if (p->state == RUNNABLE) {
    80001de0:	4c9c                	lw	a5,24(s1)
    80001de2:	ff3795e3          	bne	a5,s3,80001dcc <scheduler+0x4e>
        p->state = RUNNING;
    80001de6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001dea:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dee:	06048593          	addi	a1,s1,96
    80001df2:	8556                	mv	a0,s5
    80001df4:	5f4000ef          	jal	800023e8 <swtch>
    80001df8:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001dfa:	2781                	sext.w	a5,a5
    80001dfc:	079e                	slli	a5,a5,0x7
    80001dfe:	97da                	add	a5,a5,s6
    80001e00:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001e04:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e08:	8cde                	mv	s9,s7
    80001e0a:	b7c9                	j	80001dcc <scheduler+0x4e>
    if (found == 0) {
    80001e0c:	000c9463          	bnez	s9,80001e14 <scheduler+0x96>
      asm volatile("wfi");
    80001e10:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001e14:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001e18:	10017073          	csrci	sstatus,2
    int found = 0;
    80001e1c:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e1e:	00011497          	auipc	s1,0x11
    80001e22:	bb248493          	addi	s1,s1,-1102 # 800129d0 <proc>
      if (p->state == RUNNABLE) {
    80001e26:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e28:	00016917          	auipc	s2,0x16
    80001e2c:	7a890913          	addi	s2,s2,1960 # 800185d0 <tickslock>
    80001e30:	b76d                	j	80001dda <scheduler+0x5c>

0000000080001e32 <sched>:
{
    80001e32:	7179                	addi	sp,sp,-48
    80001e34:	f406                	sd	ra,40(sp)
    80001e36:	f022                	sd	s0,32(sp)
    80001e38:	ec26                	sd	s1,24(sp)
    80001e3a:	e84a                	sd	s2,16(sp)
    80001e3c:	e44e                	sd	s3,8(sp)
    80001e3e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e40:	ac9ff0ef          	jal	80001908 <myproc>
    80001e44:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e46:	d3dfe0ef          	jal	80000b82 <holding>
    80001e4a:	c935                	beqz	a0,80001ebe <sched+0x8c>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e4c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e4e:	2781                	sext.w	a5,a5
    80001e50:	079e                	slli	a5,a5,0x7
    80001e52:	00010717          	auipc	a4,0x10
    80001e56:	74e70713          	addi	a4,a4,1870 # 800125a0 <pid_lock>
    80001e5a:	97ba                	add	a5,a5,a4
    80001e5c:	0a87a703          	lw	a4,168(a5)
    80001e60:	4785                	li	a5,1
    80001e62:	06f71463          	bne	a4,a5,80001eca <sched+0x98>
  if (p->state == RUNNING)
    80001e66:	4c98                	lw	a4,24(s1)
    80001e68:	4791                	li	a5,4
    80001e6a:	06f70663          	beq	a4,a5,80001ed6 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e6e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e72:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e74:	e7bd                	bnez	a5,80001ee2 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e76:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e78:	00010917          	auipc	s2,0x10
    80001e7c:	72890913          	addi	s2,s2,1832 # 800125a0 <pid_lock>
    80001e80:	2781                	sext.w	a5,a5
    80001e82:	079e                	slli	a5,a5,0x7
    80001e84:	97ca                	add	a5,a5,s2
    80001e86:	0ac7a983          	lw	s3,172(a5)
    80001e8a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e8c:	2781                	sext.w	a5,a5
    80001e8e:	079e                	slli	a5,a5,0x7
    80001e90:	07a1                	addi	a5,a5,8
    80001e92:	00010597          	auipc	a1,0x10
    80001e96:	73e58593          	addi	a1,a1,1854 # 800125d0 <cpus>
    80001e9a:	95be                	add	a1,a1,a5
    80001e9c:	06048513          	addi	a0,s1,96
    80001ea0:	548000ef          	jal	800023e8 <swtch>
    80001ea4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ea6:	2781                	sext.w	a5,a5
    80001ea8:	079e                	slli	a5,a5,0x7
    80001eaa:	993e                	add	s2,s2,a5
    80001eac:	0b392623          	sw	s3,172(s2)
}
    80001eb0:	70a2                	ld	ra,40(sp)
    80001eb2:	7402                	ld	s0,32(sp)
    80001eb4:	64e2                	ld	s1,24(sp)
    80001eb6:	6942                	ld	s2,16(sp)
    80001eb8:	69a2                	ld	s3,8(sp)
    80001eba:	6145                	addi	sp,sp,48
    80001ebc:	8082                	ret
    panic("sched p->lock");
    80001ebe:	00005517          	auipc	a0,0x5
    80001ec2:	2da50513          	addi	a0,a0,730 # 80007198 <etext+0x198>
    80001ec6:	96ffe0ef          	jal	80000834 <panic>
    panic("sched locks");
    80001eca:	00005517          	auipc	a0,0x5
    80001ece:	2de50513          	addi	a0,a0,734 # 800071a8 <etext+0x1a8>
    80001ed2:	963fe0ef          	jal	80000834 <panic>
    panic("sched RUNNING");
    80001ed6:	00005517          	auipc	a0,0x5
    80001eda:	2e250513          	addi	a0,a0,738 # 800071b8 <etext+0x1b8>
    80001ede:	957fe0ef          	jal	80000834 <panic>
    panic("sched interruptible");
    80001ee2:	00005517          	auipc	a0,0x5
    80001ee6:	2e650513          	addi	a0,a0,742 # 800071c8 <etext+0x1c8>
    80001eea:	94bfe0ef          	jal	80000834 <panic>

0000000080001eee <yield>:
{
    80001eee:	1101                	addi	sp,sp,-32
    80001ef0:	ec06                	sd	ra,24(sp)
    80001ef2:	e822                	sd	s0,16(sp)
    80001ef4:	e426                	sd	s1,8(sp)
    80001ef6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ef8:	a11ff0ef          	jal	80001908 <myproc>
    80001efc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001efe:	cebfe0ef          	jal	80000be8 <acquire>
  p->state = RUNNABLE;
    80001f02:	478d                	li	a5,3
    80001f04:	cc9c                	sw	a5,24(s1)
  sched();
    80001f06:	f2dff0ef          	jal	80001e32 <sched>
  release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	d65fe0ef          	jal	80000c70 <release>
}
    80001f10:	60e2                	ld	ra,24(sp)
    80001f12:	6442                	ld	s0,16(sp)
    80001f14:	64a2                	ld	s1,8(sp)
    80001f16:	6105                	addi	sp,sp,32
    80001f18:	8082                	ret

0000000080001f1a <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	e426                	sd	s1,8(sp)
    80001f22:	e04a                	sd	s2,0(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f28:	9e1ff0ef          	jal	80001908 <myproc>
    80001f2c:	892a                	mv	s2,a0

  acquire(&p->lock);
    80001f2e:	cbbfe0ef          	jal	80000be8 <acquire>
  if (chan == 0)
    80001f32:	cc81                	beqz	s1,80001f4a <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001f34:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001f38:	854a                	mv	a0,s2
    80001f3a:	d37fe0ef          	jal	80000c70 <release>
}
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001f4a:	00005517          	auipc	a0,0x5
    80001f4e:	29650513          	addi	a0,a0,662 # 800071e0 <etext+0x1e0>
    80001f52:	8e3fe0ef          	jal	80000834 <panic>

0000000080001f56 <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80001f56:	1101                	addi	sp,sp,-32
    80001f58:	ec06                	sd	ra,24(sp)
    80001f5a:	e822                	sd	s0,16(sp)
    80001f5c:	e426                	sd	s1,8(sp)
    80001f5e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f60:	9a9ff0ef          	jal	80001908 <myproc>
    80001f64:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80001f66:	c83fe0ef          	jal	80000be8 <acquire>
  if (p->chan != 0) {
    80001f6a:	709c                	ld	a5,32(s1)
    80001f6c:	c789                	beqz	a5,80001f76 <sleep+0x20>
    p->state = SLEEPING;
    80001f6e:	4789                	li	a5,2
    80001f70:	cc9c                	sw	a5,24(s1)
    sched();
    80001f72:	ec1ff0ef          	jal	80001e32 <sched>
  }
  release(&p->lock);
    80001f76:	8526                	mv	a0,s1
    80001f78:	cf9fe0ef          	jal	80000c70 <release>
}
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    80001f86:	7139                	addi	sp,sp,-64
    80001f88:	fc06                	sd	ra,56(sp)
    80001f8a:	f822                	sd	s0,48(sp)
    80001f8c:	f426                	sd	s1,40(sp)
    80001f8e:	f04a                	sd	s2,32(sp)
    80001f90:	ec4e                	sd	s3,24(sp)
    80001f92:	e852                	sd	s4,16(sp)
    80001f94:	e456                	sd	s5,8(sp)
    80001f96:	0080                	addi	s0,sp,64
    80001f98:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f9a:	00011497          	auipc	s1,0x11
    80001f9e:	a3648493          	addi	s1,s1,-1482 # 800129d0 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    80001fa2:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001fa4:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fa6:	00016997          	auipc	s3,0x16
    80001faa:	62a98993          	addi	s3,s3,1578 # 800185d0 <tickslock>
    80001fae:	a801                	j	80001fbe <wakeup+0x38>
      }
    }
    release(&p->lock);
    80001fb0:	8526                	mv	a0,s1
    80001fb2:	cbffe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fb6:	17048493          	addi	s1,s1,368
    80001fba:	03348063          	beq	s1,s3,80001fda <wakeup+0x54>
    acquire(&p->lock);
    80001fbe:	8526                	mv	a0,s1
    80001fc0:	c29fe0ef          	jal	80000be8 <acquire>
    if (p->chan == chan) {
    80001fc4:	709c                	ld	a5,32(s1)
    80001fc6:	ff2795e3          	bne	a5,s2,80001fb0 <wakeup+0x2a>
      p->chan = 0;
    80001fca:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80001fce:	4c9c                	lw	a5,24(s1)
    80001fd0:	ff4790e3          	bne	a5,s4,80001fb0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fd4:	0154ac23          	sw	s5,24(s1)
    80001fd8:	bfe1                	j	80001fb0 <wakeup+0x2a>
  }
}
    80001fda:	70e2                	ld	ra,56(sp)
    80001fdc:	7442                	ld	s0,48(sp)
    80001fde:	74a2                	ld	s1,40(sp)
    80001fe0:	7902                	ld	s2,32(sp)
    80001fe2:	69e2                	ld	s3,24(sp)
    80001fe4:	6a42                	ld	s4,16(sp)
    80001fe6:	6aa2                	ld	s5,8(sp)
    80001fe8:	6121                	addi	sp,sp,64
    80001fea:	8082                	ret

0000000080001fec <reparent>:
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	e052                	sd	s4,0(sp)
    80001ffa:	1800                	addi	s0,sp,48
    80001ffc:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ffe:	00011497          	auipc	s1,0x11
    80002002:	9d248493          	addi	s1,s1,-1582 # 800129d0 <proc>
      pp->parent = initproc;
    80002006:	00008a17          	auipc	s4,0x8
    8000200a:	472a0a13          	addi	s4,s4,1138 # 8000a478 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000200e:	00016997          	auipc	s3,0x16
    80002012:	5c298993          	addi	s3,s3,1474 # 800185d0 <tickslock>
    80002016:	a029                	j	80002020 <reparent+0x34>
    80002018:	17048493          	addi	s1,s1,368
    8000201c:	01348b63          	beq	s1,s3,80002032 <reparent+0x46>
    if (pp->parent == p) {
    80002020:	7c9c                	ld	a5,56(s1)
    80002022:	ff279be3          	bne	a5,s2,80002018 <reparent+0x2c>
      pp->parent = initproc;
    80002026:	000a3503          	ld	a0,0(s4)
    8000202a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000202c:	f5bff0ef          	jal	80001f86 <wakeup>
    80002030:	b7e5                	j	80002018 <reparent+0x2c>
}
    80002032:	70a2                	ld	ra,40(sp)
    80002034:	7402                	ld	s0,32(sp)
    80002036:	64e2                	ld	s1,24(sp)
    80002038:	6942                	ld	s2,16(sp)
    8000203a:	69a2                	ld	s3,8(sp)
    8000203c:	6a02                	ld	s4,0(sp)
    8000203e:	6145                	addi	sp,sp,48
    80002040:	8082                	ret

0000000080002042 <kexit>:
{
    80002042:	7179                	addi	sp,sp,-48
    80002044:	f406                	sd	ra,40(sp)
    80002046:	f022                	sd	s0,32(sp)
    80002048:	ec26                	sd	s1,24(sp)
    8000204a:	e84a                	sd	s2,16(sp)
    8000204c:	e44e                	sd	s3,8(sp)
    8000204e:	e052                	sd	s4,0(sp)
    80002050:	1800                	addi	s0,sp,48
    80002052:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002054:	8b5ff0ef          	jal	80001908 <myproc>
    80002058:	89aa                	mv	s3,a0
  if (p == initproc)
    8000205a:	00008797          	auipc	a5,0x8
    8000205e:	41e7b783          	ld	a5,1054(a5) # 8000a478 <initproc>
    80002062:	0d050493          	addi	s1,a0,208
    80002066:	15050913          	addi	s2,a0,336
    8000206a:	00a79b63          	bne	a5,a0,80002080 <kexit+0x3e>
    panic("init exiting");
    8000206e:	00005517          	auipc	a0,0x5
    80002072:	19250513          	addi	a0,a0,402 # 80007200 <etext+0x200>
    80002076:	fbefe0ef          	jal	80000834 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    8000207a:	04a1                	addi	s1,s1,8
    8000207c:	01248963          	beq	s1,s2,8000208e <kexit+0x4c>
    if (p->ofile[fd]) {
    80002080:	6088                	ld	a0,0(s1)
    80002082:	dd65                	beqz	a0,8000207a <kexit+0x38>
      fileclose(f);
    80002084:	12c020ef          	jal	800041b0 <fileclose>
      p->ofile[fd] = 0;
    80002088:	0004b023          	sd	zero,0(s1)
    8000208c:	b7fd                	j	8000207a <kexit+0x38>
  begin_op();
    8000208e:	469010ef          	jal	80003cf6 <begin_op>
  iput(p->cwd);
    80002092:	1509b503          	ld	a0,336(s3)
    80002096:	378010ef          	jal	8000340e <iput>
  end_op();
    8000209a:	4e9010ef          	jal	80003d82 <end_op>
  p->cwd = 0;
    8000209e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800020a2:	00010517          	auipc	a0,0x10
    800020a6:	51650513          	addi	a0,a0,1302 # 800125b8 <wait_lock>
    800020aa:	b3ffe0ef          	jal	80000be8 <acquire>
  reparent(p);
    800020ae:	854e                	mv	a0,s3
    800020b0:	f3dff0ef          	jal	80001fec <reparent>
  wakeup(p->parent);
    800020b4:	0389b503          	ld	a0,56(s3)
    800020b8:	ecfff0ef          	jal	80001f86 <wakeup>
  acquire(&p->lock);
    800020bc:	854e                	mv	a0,s3
    800020be:	b2bfe0ef          	jal	80000be8 <acquire>
  p->xstate = status;
    800020c2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020c6:	4795                	li	a5,5
    800020c8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020cc:	00010517          	auipc	a0,0x10
    800020d0:	4ec50513          	addi	a0,a0,1260 # 800125b8 <wait_lock>
    800020d4:	b9dfe0ef          	jal	80000c70 <release>
  sched();
    800020d8:	d5bff0ef          	jal	80001e32 <sched>
  panic("zombie exit");
    800020dc:	00005517          	auipc	a0,0x5
    800020e0:	13450513          	addi	a0,a0,308 # 80007210 <etext+0x210>
    800020e4:	f50fe0ef          	jal	80000834 <panic>

00000000800020e8 <kkill>:
int
kkill(int pid)
{
  struct proc *p;

  if (pid == 0)
    800020e8:	c525                	beqz	a0,80002150 <kkill+0x68>
{
    800020ea:	7179                	addi	sp,sp,-48
    800020ec:	f406                	sd	ra,40(sp)
    800020ee:	f022                	sd	s0,32(sp)
    800020f0:	ec26                	sd	s1,24(sp)
    800020f2:	e84a                	sd	s2,16(sp)
    800020f4:	e44e                	sd	s3,8(sp)
    800020f6:	1800                	addi	s0,sp,48
    800020f8:	892a                	mv	s2,a0
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    800020fa:	00011497          	auipc	s1,0x11
    800020fe:	8d648493          	addi	s1,s1,-1834 # 800129d0 <proc>
    80002102:	00016997          	auipc	s3,0x16
    80002106:	4ce98993          	addi	s3,s3,1230 # 800185d0 <tickslock>
    acquire(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	addfe0ef          	jal	80000be8 <acquire>
    if (p->pid == pid) {
    80002110:	589c                	lw	a5,48(s1)
    80002112:	01278b63          	beq	a5,s2,80002128 <kkill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002116:	8526                	mv	a0,s1
    80002118:	b59fe0ef          	jal	80000c70 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000211c:	17048493          	addi	s1,s1,368
    80002120:	ff3495e3          	bne	s1,s3,8000210a <kkill+0x22>
  }
  return -1;
    80002124:	557d                	li	a0,-1
    80002126:	a819                	j	8000213c <kkill+0x54>
      p->killed = 1;
    80002128:	4785                	li	a5,1
    8000212a:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    8000212c:	4c98                	lw	a4,24(s1)
    8000212e:	4789                	li	a5,2
    80002130:	00f70d63          	beq	a4,a5,8000214a <kkill+0x62>
      release(&p->lock);
    80002134:	8526                	mv	a0,s1
    80002136:	b3bfe0ef          	jal	80000c70 <release>
      return 0;
    8000213a:	4501                	li	a0,0
}
    8000213c:	70a2                	ld	ra,40(sp)
    8000213e:	7402                	ld	s0,32(sp)
    80002140:	64e2                	ld	s1,24(sp)
    80002142:	6942                	ld	s2,16(sp)
    80002144:	69a2                	ld	s3,8(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret
        p->state = RUNNABLE;
    8000214a:	478d                	li	a5,3
    8000214c:	cc9c                	sw	a5,24(s1)
    8000214e:	b7dd                	j	80002134 <kkill+0x4c>
    return -1;
    80002150:	557d                	li	a0,-1
}
    80002152:	8082                	ret

0000000080002154 <setkilled>:

void
setkilled(struct proc *p)
{
    80002154:	1101                	addi	sp,sp,-32
    80002156:	ec06                	sd	ra,24(sp)
    80002158:	e822                	sd	s0,16(sp)
    8000215a:	e426                	sd	s1,8(sp)
    8000215c:	1000                	addi	s0,sp,32
    8000215e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002160:	a89fe0ef          	jal	80000be8 <acquire>
  p->killed = 1;
    80002164:	4785                	li	a5,1
    80002166:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002168:	8526                	mv	a0,s1
    8000216a:	b07fe0ef          	jal	80000c70 <release>
}
    8000216e:	60e2                	ld	ra,24(sp)
    80002170:	6442                	ld	s0,16(sp)
    80002172:	64a2                	ld	s1,8(sp)
    80002174:	6105                	addi	sp,sp,32
    80002176:	8082                	ret

0000000080002178 <killed>:

int
killed(struct proc *p)
{
    80002178:	1101                	addi	sp,sp,-32
    8000217a:	ec06                	sd	ra,24(sp)
    8000217c:	e822                	sd	s0,16(sp)
    8000217e:	e426                	sd	s1,8(sp)
    80002180:	e04a                	sd	s2,0(sp)
    80002182:	1000                	addi	s0,sp,32
    80002184:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002186:	a63fe0ef          	jal	80000be8 <acquire>
  k = p->killed;
    8000218a:	549c                	lw	a5,40(s1)
    8000218c:	893e                	mv	s2,a5
  release(&p->lock);
    8000218e:	8526                	mv	a0,s1
    80002190:	ae1fe0ef          	jal	80000c70 <release>
  return k;
}
    80002194:	854a                	mv	a0,s2
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	64a2                	ld	s1,8(sp)
    8000219c:	6902                	ld	s2,0(sp)
    8000219e:	6105                	addi	sp,sp,32
    800021a0:	8082                	ret

00000000800021a2 <kwait>:
{
    800021a2:	715d                	addi	sp,sp,-80
    800021a4:	e486                	sd	ra,72(sp)
    800021a6:	e0a2                	sd	s0,64(sp)
    800021a8:	fc26                	sd	s1,56(sp)
    800021aa:	f84a                	sd	s2,48(sp)
    800021ac:	f44e                	sd	s3,40(sp)
    800021ae:	f052                	sd	s4,32(sp)
    800021b0:	ec56                	sd	s5,24(sp)
    800021b2:	e85a                	sd	s6,16(sp)
    800021b4:	e45e                	sd	s7,8(sp)
    800021b6:	0880                	addi	s0,sp,80
    800021b8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021ba:	f4eff0ef          	jal	80001908 <myproc>
    800021be:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021c0:	00010517          	auipc	a0,0x10
    800021c4:	3f850513          	addi	a0,a0,1016 # 800125b8 <wait_lock>
    800021c8:	a21fe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    800021cc:	4a15                	li	s4,5
        havekids = 1;
    800021ce:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021d0:	00016997          	auipc	s3,0x16
    800021d4:	40098993          	addi	s3,s3,1024 # 800185d0 <tickslock>
    release(&wait_lock);
    800021d8:	00010b17          	auipc	s6,0x10
    800021dc:	3e0b0b13          	addi	s6,s6,992 # 800125b8 <wait_lock>
    800021e0:	a845                	j	80002290 <kwait+0xee>
          pid = pp->pid;
    800021e2:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800021e6:	000b8e63          	beqz	s7,80002202 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800021ea:	4711                	li	a4,4
    800021ec:	02c48693          	addi	a3,s1,44
    800021f0:	865e                	mv	a2,s7
    800021f2:	04893583          	ld	a1,72(s2)
    800021f6:	05093503          	ld	a0,80(s2)
    800021fa:	b48ff0ef          	jal	80001542 <copyout>
          if (addr != 0 &&
    800021fe:	02054c63          	bltz	a0,80002236 <kwait+0x94>
          pp->parent = 0;
    80002202:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    80002206:	8526                	mv	a0,s1
    80002208:	8d1ff0ef          	jal	80001ad8 <freeproc>
          release(&pp->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	a63fe0ef          	jal	80000c70 <release>
          release(&wait_lock);
    80002212:	00010517          	auipc	a0,0x10
    80002216:	3a650513          	addi	a0,a0,934 # 800125b8 <wait_lock>
    8000221a:	a57fe0ef          	jal	80000c70 <release>
}
    8000221e:	854e                	mv	a0,s3
    80002220:	60a6                	ld	ra,72(sp)
    80002222:	6406                	ld	s0,64(sp)
    80002224:	74e2                	ld	s1,56(sp)
    80002226:	7942                	ld	s2,48(sp)
    80002228:	79a2                	ld	s3,40(sp)
    8000222a:	7a02                	ld	s4,32(sp)
    8000222c:	6ae2                	ld	s5,24(sp)
    8000222e:	6b42                	ld	s6,16(sp)
    80002230:	6ba2                	ld	s7,8(sp)
    80002232:	6161                	addi	sp,sp,80
    80002234:	8082                	ret
            release(&pp->lock);
    80002236:	8526                	mv	a0,s1
    80002238:	a39fe0ef          	jal	80000c70 <release>
            release(&wait_lock);
    8000223c:	00010517          	auipc	a0,0x10
    80002240:	37c50513          	addi	a0,a0,892 # 800125b8 <wait_lock>
    80002244:	a2dfe0ef          	jal	80000c70 <release>
            return -1;
    80002248:	59fd                	li	s3,-1
    8000224a:	bfd1                	j	8000221e <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000224c:	17048493          	addi	s1,s1,368
    80002250:	03348063          	beq	s1,s3,80002270 <kwait+0xce>
      if (pp->parent == p) {
    80002254:	7c9c                	ld	a5,56(s1)
    80002256:	ff279be3          	bne	a5,s2,8000224c <kwait+0xaa>
        acquire(&pp->lock);
    8000225a:	8526                	mv	a0,s1
    8000225c:	98dfe0ef          	jal	80000be8 <acquire>
        if (pp->state == ZOMBIE) {
    80002260:	4c9c                	lw	a5,24(s1)
    80002262:	f94780e3          	beq	a5,s4,800021e2 <kwait+0x40>
        release(&pp->lock);
    80002266:	8526                	mv	a0,s1
    80002268:	a09fe0ef          	jal	80000c70 <release>
        havekids = 1;
    8000226c:	8756                	mv	a4,s5
    8000226e:	bff9                	j	8000224c <kwait+0xaa>
    if (!havekids || killed(p)) {
    80002270:	c715                	beqz	a4,8000229c <kwait+0xfa>
    80002272:	854a                	mv	a0,s2
    80002274:	f05ff0ef          	jal	80002178 <killed>
    80002278:	e115                	bnez	a0,8000229c <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    8000227a:	854a                	mv	a0,s2
    8000227c:	c9fff0ef          	jal	80001f1a <sleep_prepare>
    release(&wait_lock);
    80002280:	855a                	mv	a0,s6
    80002282:	9effe0ef          	jal	80000c70 <release>
    sleep();
    80002286:	cd1ff0ef          	jal	80001f56 <sleep>
    acquire(&wait_lock);
    8000228a:	855a                	mv	a0,s6
    8000228c:	95dfe0ef          	jal	80000be8 <acquire>
    havekids = 0;
    80002290:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002292:	00010497          	auipc	s1,0x10
    80002296:	73e48493          	addi	s1,s1,1854 # 800129d0 <proc>
    8000229a:	bf6d                	j	80002254 <kwait+0xb2>
      release(&wait_lock);
    8000229c:	00010517          	auipc	a0,0x10
    800022a0:	31c50513          	addi	a0,a0,796 # 800125b8 <wait_lock>
    800022a4:	9cdfe0ef          	jal	80000c70 <release>
      return -1;
    800022a8:	59fd                	li	s3,-1
    800022aa:	bf95                	j	8000221e <kwait+0x7c>

00000000800022ac <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800022ac:	7179                	addi	sp,sp,-48
    800022ae:	f406                	sd	ra,40(sp)
    800022b0:	f022                	sd	s0,32(sp)
    800022b2:	ec26                	sd	s1,24(sp)
    800022b4:	e84a                	sd	s2,16(sp)
    800022b6:	e44e                	sd	s3,8(sp)
    800022b8:	e052                	sd	s4,0(sp)
    800022ba:	1800                	addi	s0,sp,48
    800022bc:	84aa                	mv	s1,a0
    800022be:	8a2e                	mv	s4,a1
    800022c0:	89b2                	mv	s3,a2
    800022c2:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022c4:	e44ff0ef          	jal	80001908 <myproc>
  if (user_dst) {
    800022c8:	c085                	beqz	s1,800022e8 <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    800022ca:	874a                	mv	a4,s2
    800022cc:	86ce                	mv	a3,s3
    800022ce:	8652                	mv	a2,s4
    800022d0:	652c                	ld	a1,72(a0)
    800022d2:	6928                	ld	a0,80(a0)
    800022d4:	a6eff0ef          	jal	80001542 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6942                	ld	s2,16(sp)
    800022e0:	69a2                	ld	s3,8(sp)
    800022e2:	6a02                	ld	s4,0(sp)
    800022e4:	6145                	addi	sp,sp,48
    800022e6:	8082                	ret
    memmove((char *)dst, src, len);
    800022e8:	0009061b          	sext.w	a2,s2
    800022ec:	85ce                	mv	a1,s3
    800022ee:	8552                	mv	a0,s4
    800022f0:	a19fe0ef          	jal	80000d08 <memmove>
    return 0;
    800022f4:	8526                	mv	a0,s1
    800022f6:	b7cd                	j	800022d8 <either_copyout+0x2c>

00000000800022f8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022f8:	7179                	addi	sp,sp,-48
    800022fa:	f406                	sd	ra,40(sp)
    800022fc:	f022                	sd	s0,32(sp)
    800022fe:	ec26                	sd	s1,24(sp)
    80002300:	e84a                	sd	s2,16(sp)
    80002302:	e44e                	sd	s3,8(sp)
    80002304:	e052                	sd	s4,0(sp)
    80002306:	1800                	addi	s0,sp,48
    80002308:	8a2a                	mv	s4,a0
    8000230a:	84ae                	mv	s1,a1
    8000230c:	89b2                	mv	s3,a2
    8000230e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002310:	df8ff0ef          	jal	80001908 <myproc>
  if (user_src) {
    80002314:	c085                	beqz	s1,80002334 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80002316:	874a                	mv	a4,s2
    80002318:	86ce                	mv	a3,s3
    8000231a:	8652                	mv	a2,s4
    8000231c:	652c                	ld	a1,72(a0)
    8000231e:	6928                	ld	a0,80(a0)
    80002320:	ae8ff0ef          	jal	80001608 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002324:	70a2                	ld	ra,40(sp)
    80002326:	7402                	ld	s0,32(sp)
    80002328:	64e2                	ld	s1,24(sp)
    8000232a:	6942                	ld	s2,16(sp)
    8000232c:	69a2                	ld	s3,8(sp)
    8000232e:	6a02                	ld	s4,0(sp)
    80002330:	6145                	addi	sp,sp,48
    80002332:	8082                	ret
    memmove(dst, (char *)src, len);
    80002334:	0009061b          	sext.w	a2,s2
    80002338:	85ce                	mv	a1,s3
    8000233a:	8552                	mv	a0,s4
    8000233c:	9cdfe0ef          	jal	80000d08 <memmove>
    return 0;
    80002340:	8526                	mv	a0,s1
    80002342:	b7cd                	j	80002324 <either_copyin+0x2c>

0000000080002344 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002344:	715d                	addi	sp,sp,-80
    80002346:	e486                	sd	ra,72(sp)
    80002348:	e0a2                	sd	s0,64(sp)
    8000234a:	fc26                	sd	s1,56(sp)
    8000234c:	f84a                	sd	s2,48(sp)
    8000234e:	f44e                	sd	s3,40(sp)
    80002350:	f052                	sd	s4,32(sp)
    80002352:	ec56                	sd	s5,24(sp)
    80002354:	e85a                	sd	s6,16(sp)
    80002356:	e45e                	sd	s7,8(sp)
    80002358:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000235a:	00005517          	auipc	a0,0x5
    8000235e:	d1e50513          	addi	a0,a0,-738 # 80007078 <etext+0x78>
    80002362:	9a8fe0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002366:	00010497          	auipc	s1,0x10
    8000236a:	7c248493          	addi	s1,s1,1986 # 80012b28 <proc+0x158>
    8000236e:	00016917          	auipc	s2,0x16
    80002372:	3ba90913          	addi	s2,s2,954 # 80018728 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002376:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002378:	00005997          	auipc	s3,0x5
    8000237c:	ea898993          	addi	s3,s3,-344 # 80007220 <etext+0x220>
    printk("%d %s %s", p->pid, state, p->name);
    80002380:	00005a97          	auipc	s5,0x5
    80002384:	ea8a8a93          	addi	s5,s5,-344 # 80007228 <etext+0x228>
    printk("\n");
    80002388:	00005a17          	auipc	s4,0x5
    8000238c:	cf0a0a13          	addi	s4,s4,-784 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002390:	00005b97          	auipc	s7,0x5
    80002394:	470b8b93          	addi	s7,s7,1136 # 80007800 <states.0>
    80002398:	a829                	j	800023b2 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    8000239a:	ed86a583          	lw	a1,-296(a3)
    8000239e:	8556                	mv	a0,s5
    800023a0:	96afe0ef          	jal	8000050a <printk>
    printk("\n");
    800023a4:	8552                	mv	a0,s4
    800023a6:	964fe0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023aa:	17048493          	addi	s1,s1,368
    800023ae:	03248263          	beq	s1,s2,800023d2 <procdump+0x8e>
    if (p->state == UNUSED)
    800023b2:	86a6                	mv	a3,s1
    800023b4:	ec04a783          	lw	a5,-320(s1)
    800023b8:	dbed                	beqz	a5,800023aa <procdump+0x66>
      state = "???";
    800023ba:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023bc:	fcfb6fe3          	bltu	s6,a5,8000239a <procdump+0x56>
    800023c0:	02079713          	slli	a4,a5,0x20
    800023c4:	01d75793          	srli	a5,a4,0x1d
    800023c8:	97de                	add	a5,a5,s7
    800023ca:	6390                	ld	a2,0(a5)
    800023cc:	f679                	bnez	a2,8000239a <procdump+0x56>
      state = "???";
    800023ce:	864e                	mv	a2,s3
    800023d0:	b7e9                	j	8000239a <procdump+0x56>
  }
}
    800023d2:	60a6                	ld	ra,72(sp)
    800023d4:	6406                	ld	s0,64(sp)
    800023d6:	74e2                	ld	s1,56(sp)
    800023d8:	7942                	ld	s2,48(sp)
    800023da:	79a2                	ld	s3,40(sp)
    800023dc:	7a02                	ld	s4,32(sp)
    800023de:	6ae2                	ld	s5,24(sp)
    800023e0:	6b42                	ld	s6,16(sp)
    800023e2:	6ba2                	ld	s7,8(sp)
    800023e4:	6161                	addi	sp,sp,80
    800023e6:	8082                	ret

00000000800023e8 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023e8:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023ec:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023f0:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023f2:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023f4:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023f8:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023fc:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002400:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002404:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002408:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000240c:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002410:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002414:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002418:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000241c:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002420:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002424:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002426:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002428:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000242c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002430:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002434:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002438:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000243c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002440:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002444:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002448:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000244c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002450:	8082                	ret

0000000080002452 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002452:	1141                	addi	sp,sp,-16
    80002454:	e406                	sd	ra,8(sp)
    80002456:	e022                	sd	s0,0(sp)
    80002458:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000245a:	00005597          	auipc	a1,0x5
    8000245e:	e0e58593          	addi	a1,a1,-498 # 80007268 <etext+0x268>
    80002462:	00016517          	auipc	a0,0x16
    80002466:	16e50513          	addi	a0,a0,366 # 800185d0 <tickslock>
    8000246a:	efefe0ef          	jal	80000b68 <initlock>
}
    8000246e:	60a2                	ld	ra,8(sp)
    80002470:	6402                	ld	s0,0(sp)
    80002472:	0141                	addi	sp,sp,16
    80002474:	8082                	ret

0000000080002476 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002476:	1141                	addi	sp,sp,-16
    80002478:	e406                	sd	ra,8(sp)
    8000247a:	e022                	sd	s0,0(sp)
    8000247c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000247e:	00003797          	auipc	a5,0x3
    80002482:	19278793          	addi	a5,a5,402 # 80005610 <kernelvec>
    80002486:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000248a:	60a2                	ld	ra,8(sp)
    8000248c:	6402                	ld	s0,0(sp)
    8000248e:	0141                	addi	sp,sp,16
    80002490:	8082                	ret

0000000080002492 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002492:	1141                	addi	sp,sp,-16
    80002494:	e406                	sd	ra,8(sp)
    80002496:	e022                	sd	s0,0(sp)
    80002498:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000249a:	c6eff0ef          	jal	80001908 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    8000249e:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800024a2:	04000737          	lui	a4,0x4000
    800024a6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800024a8:	0732                	slli	a4,a4,0xc
    800024aa:	00004797          	auipc	a5,0x4
    800024ae:	b5678793          	addi	a5,a5,-1194 # 80006000 <_trampoline>
    800024b2:	00004697          	auipc	a3,0x4
    800024b6:	b4e68693          	addi	a3,a3,-1202 # 80006000 <_trampoline>
    800024ba:	8f95                	sub	a5,a5,a3
    800024bc:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    800024be:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800024c2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800024c4:	18002773          	csrr	a4,satp
    800024c8:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024ca:	6d38                	ld	a4,88(a0)
    800024cc:	613c                	ld	a5,64(a0)
    800024ce:	6685                	lui	a3,0x1
    800024d0:	97b6                	add	a5,a5,a3
    800024d2:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024d4:	6d3c                	ld	a5,88(a0)
    800024d6:	00000717          	auipc	a4,0x0
    800024da:	0fc70713          	addi	a4,a4,252 # 800025d2 <usertrap>
    800024de:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800024e0:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024e2:	8712                	mv	a4,tp
    800024e4:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024e6:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024ea:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ee:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024f2:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024f6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024f8:	6f9c                	ld	a5,24(a5)
    800024fa:	14179073          	csrw	sepc,a5
}
    800024fe:	60a2                	ld	ra,8(sp)
    80002500:	6402                	ld	s0,0(sp)
    80002502:	0141                	addi	sp,sp,16
    80002504:	8082                	ret

0000000080002506 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002506:	1141                	addi	sp,sp,-16
    80002508:	e406                	sd	ra,8(sp)
    8000250a:	e022                	sd	s0,0(sp)
    8000250c:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    8000250e:	bc6ff0ef          	jal	800018d4 <cpuid>
    80002512:	cd11                	beqz	a0,8000252e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80002514:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002518:	000f4737          	lui	a4,0xf4
    8000251c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002520:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80002522:	14d79073          	csrw	stimecmp,a5
}
    80002526:	60a2                	ld	ra,8(sp)
    80002528:	6402                	ld	s0,0(sp)
    8000252a:	0141                	addi	sp,sp,16
    8000252c:	8082                	ret
    acquire(&tickslock);
    8000252e:	00016517          	auipc	a0,0x16
    80002532:	0a250513          	addi	a0,a0,162 # 800185d0 <tickslock>
    80002536:	eb2fe0ef          	jal	80000be8 <acquire>
    ticks++;
    8000253a:	00008717          	auipc	a4,0x8
    8000253e:	f4670713          	addi	a4,a4,-186 # 8000a480 <ticks>
    80002542:	431c                	lw	a5,0(a4)
    80002544:	2785                	addiw	a5,a5,1
    80002546:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002548:	853a                	mv	a0,a4
    8000254a:	a3dff0ef          	jal	80001f86 <wakeup>
    release(&tickslock);
    8000254e:	00016517          	auipc	a0,0x16
    80002552:	08250513          	addi	a0,a0,130 # 800185d0 <tickslock>
    80002556:	f1afe0ef          	jal	80000c70 <release>
    8000255a:	bf6d                	j	80002514 <clockintr+0xe>

000000008000255c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002564:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002568:	57fd                	li	a5,-1
    8000256a:	17fe                	slli	a5,a5,0x3f
    8000256c:	07a5                	addi	a5,a5,9
    8000256e:	00f70c63          	beq	a4,a5,80002586 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002572:	57fd                	li	a5,-1
    80002574:	17fe                	slli	a5,a5,0x3f
    80002576:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002578:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    8000257a:	04f70863          	beq	a4,a5,800025ca <devintr+0x6e>
  }
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    80002586:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002588:	134030ef          	jal	800056bc <plic_claim>
    8000258c:	872a                	mv	a4,a0
    8000258e:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002590:	47a9                	li	a5,10
    80002592:	00f50963          	beq	a0,a5,800025a4 <devintr+0x48>
    } else if (irq == VIRTIO0_IRQ) {
    80002596:	4785                	li	a5,1
    80002598:	00f50963          	beq	a0,a5,800025aa <devintr+0x4e>
    return 1;
    8000259c:	4505                	li	a0,1
    } else if (irq) {
    8000259e:	eb09                	bnez	a4,800025b0 <devintr+0x54>
    800025a0:	64a2                	ld	s1,8(sp)
    800025a2:	bff1                	j	8000257e <devintr+0x22>
      uartintr();
    800025a4:	c2afe0ef          	jal	800009ce <uartintr>
    if (irq)
    800025a8:	a819                	j	800025be <devintr+0x62>
      virtio_disk_intr();
    800025aa:	5ca030ef          	jal	80005b74 <virtio_disk_intr>
    if (irq)
    800025ae:	a801                	j	800025be <devintr+0x62>
      printk("unexpected interrupt irq=%d\n", irq);
    800025b0:	85ba                	mv	a1,a4
    800025b2:	00005517          	auipc	a0,0x5
    800025b6:	cbe50513          	addi	a0,a0,-834 # 80007270 <etext+0x270>
    800025ba:	f51fd0ef          	jal	8000050a <printk>
      plic_complete(irq);
    800025be:	8526                	mv	a0,s1
    800025c0:	11c030ef          	jal	800056dc <plic_complete>
    return 1;
    800025c4:	4505                	li	a0,1
    800025c6:	64a2                	ld	s1,8(sp)
    800025c8:	bf5d                	j	8000257e <devintr+0x22>
    clockintr();
    800025ca:	f3dff0ef          	jal	80002506 <clockintr>
    return 2;
    800025ce:	4509                	li	a0,2
    800025d0:	b77d                	j	8000257e <devintr+0x22>

00000000800025d2 <usertrap>:
{
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	e04a                	sd	s2,0(sp)
    800025dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800025de:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800025e2:	1007f793          	andi	a5,a5,256
    800025e6:	eba5                	bnez	a5,80002656 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025e8:	00003797          	auipc	a5,0x3
    800025ec:	02878793          	addi	a5,a5,40 # 80005610 <kernelvec>
    800025f0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025f4:	b14ff0ef          	jal	80001908 <myproc>
    800025f8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025fa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025fc:	14102773          	csrr	a4,sepc
    80002600:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002602:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002606:	47a1                	li	a5,8
    80002608:	04f70d63          	beq	a4,a5,80002662 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    8000260c:	f51ff0ef          	jal	8000255c <devintr>
    80002610:	892a                	mv	s2,a0
    80002612:	e54d                	bnez	a0,800026bc <usertrap+0xea>
    80002614:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002618:	47bd                	li	a5,15
    8000261a:	08f70463          	beq	a4,a5,800026a2 <usertrap+0xd0>
    8000261e:	14202773          	csrr	a4,scause
    80002622:	47b5                	li	a5,13
    80002624:	06f70f63          	beq	a4,a5,800026a2 <usertrap+0xd0>
    80002628:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000262c:	5890                	lw	a2,48(s1)
    8000262e:	00005517          	auipc	a0,0x5
    80002632:	c8250513          	addi	a0,a0,-894 # 800072b0 <etext+0x2b0>
    80002636:	ed5fd0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000263a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000263e:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002642:	00005517          	auipc	a0,0x5
    80002646:	c9e50513          	addi	a0,a0,-866 # 800072e0 <etext+0x2e0>
    8000264a:	ec1fd0ef          	jal	8000050a <printk>
    setkilled(p);
    8000264e:	8526                	mv	a0,s1
    80002650:	b05ff0ef          	jal	80002154 <setkilled>
    80002654:	a015                	j	80002678 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    80002656:	00005517          	auipc	a0,0x5
    8000265a:	c3a50513          	addi	a0,a0,-966 # 80007290 <etext+0x290>
    8000265e:	9d6fe0ef          	jal	80000834 <panic>
    if (killed(p))
    80002662:	b17ff0ef          	jal	80002178 <killed>
    80002666:	e915                	bnez	a0,8000269a <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002668:	6cb8                	ld	a4,88(s1)
    8000266a:	6f1c                	ld	a5,24(a4)
    8000266c:	0791                	addi	a5,a5,4
    8000266e:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80002670:	10016073          	csrsi	sstatus,2
    syscall();
    80002674:	244000ef          	jal	800028b8 <syscall>
  if (killed(p))
    80002678:	8526                	mv	a0,s1
    8000267a:	affff0ef          	jal	80002178 <killed>
    8000267e:	e521                	bnez	a0,800026c6 <usertrap+0xf4>
  prepare_return();
    80002680:	e13ff0ef          	jal	80002492 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002684:	68a8                	ld	a0,80(s1)
    80002686:	8131                	srli	a0,a0,0xc
    80002688:	57fd                	li	a5,-1
    8000268a:	17fe                	slli	a5,a5,0x3f
    8000268c:	8d5d                	or	a0,a0,a5
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6902                	ld	s2,0(sp)
    80002696:	6105                	addi	sp,sp,32
    80002698:	8082                	ret
      kexit(-1);
    8000269a:	557d                	li	a0,-1
    8000269c:	9a7ff0ef          	jal	80002042 <kexit>
    800026a0:	b7e1                	j	80002668 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    800026a2:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    800026a6:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    800026aa:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    800026ac:	0016b693          	seqz	a3,a3
    800026b0:	64ac                	ld	a1,72(s1)
    800026b2:	68a8                	ld	a0,80(s1)
    800026b4:	e13fe0ef          	jal	800014c6 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800026b8:	f161                	bnez	a0,80002678 <usertrap+0xa6>
    800026ba:	b7bd                	j	80002628 <usertrap+0x56>
  if (killed(p))
    800026bc:	8526                	mv	a0,s1
    800026be:	abbff0ef          	jal	80002178 <killed>
    800026c2:	c511                	beqz	a0,800026ce <usertrap+0xfc>
    800026c4:	a011                	j	800026c8 <usertrap+0xf6>
    800026c6:	4901                	li	s2,0
    kexit(-1);
    800026c8:	557d                	li	a0,-1
    800026ca:	979ff0ef          	jal	80002042 <kexit>
  if (which_dev == 2)
    800026ce:	4789                	li	a5,2
    800026d0:	faf918e3          	bne	s2,a5,80002680 <usertrap+0xae>
    yield();
    800026d4:	81bff0ef          	jal	80001eee <yield>
    800026d8:	b765                	j	80002680 <usertrap+0xae>

00000000800026da <kerneltrap>:
{
    800026da:	7179                	addi	sp,sp,-48
    800026dc:	f406                	sd	ra,40(sp)
    800026de:	f022                	sd	s0,32(sp)
    800026e0:	ec26                	sd	s1,24(sp)
    800026e2:	e84a                	sd	s2,16(sp)
    800026e4:	e44e                	sd	s3,8(sp)
    800026e6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026e8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026ec:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800026f0:	142027f3          	csrr	a5,scause
    800026f4:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800026f6:	1004f793          	andi	a5,s1,256
    800026fa:	c795                	beqz	a5,80002726 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002700:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002702:	eb85                	bnez	a5,80002732 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80002704:	e59ff0ef          	jal	8000255c <devintr>
    80002708:	c91d                	beqz	a0,8000273e <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    8000270a:	4789                	li	a5,2
    8000270c:	04f50a63          	beq	a0,a5,80002760 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002710:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002714:	10049073          	csrw	sstatus,s1
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002726:	00005517          	auipc	a0,0x5
    8000272a:	be250513          	addi	a0,a0,-1054 # 80007308 <etext+0x308>
    8000272e:	906fe0ef          	jal	80000834 <panic>
    panic("kerneltrap: interrupts enabled");
    80002732:	00005517          	auipc	a0,0x5
    80002736:	bfe50513          	addi	a0,a0,-1026 # 80007330 <etext+0x330>
    8000273a:	8fafe0ef          	jal	80000834 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000273e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002742:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002746:	85ce                	mv	a1,s3
    80002748:	00005517          	auipc	a0,0x5
    8000274c:	c0850513          	addi	a0,a0,-1016 # 80007350 <etext+0x350>
    80002750:	dbbfd0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    80002754:	00005517          	auipc	a0,0x5
    80002758:	c2450513          	addi	a0,a0,-988 # 80007378 <etext+0x378>
    8000275c:	8d8fe0ef          	jal	80000834 <panic>
  if (which_dev == 2 && myproc() != 0)
    80002760:	9a8ff0ef          	jal	80001908 <myproc>
    80002764:	d555                	beqz	a0,80002710 <kerneltrap+0x36>
    yield();
    80002766:	f88ff0ef          	jal	80001eee <yield>
    8000276a:	b75d                	j	80002710 <kerneltrap+0x36>

000000008000276c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	1000                	addi	s0,sp,32
    80002776:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002778:	990ff0ef          	jal	80001908 <myproc>
  switch (n) {
    8000277c:	4795                	li	a5,5
    8000277e:	0497e163          	bltu	a5,s1,800027c0 <argraw+0x54>
    80002782:	048a                	slli	s1,s1,0x2
    80002784:	00005717          	auipc	a4,0x5
    80002788:	0ac70713          	addi	a4,a4,172 # 80007830 <states.0+0x30>
    8000278c:	94ba                	add	s1,s1,a4
    8000278e:	409c                	lw	a5,0(s1)
    80002790:	97ba                	add	a5,a5,a4
    80002792:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002794:	6d3c                	ld	a5,88(a0)
    80002796:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002798:	60e2                	ld	ra,24(sp)
    8000279a:	6442                	ld	s0,16(sp)
    8000279c:	64a2                	ld	s1,8(sp)
    8000279e:	6105                	addi	sp,sp,32
    800027a0:	8082                	ret
    return p->trapframe->a1;
    800027a2:	6d3c                	ld	a5,88(a0)
    800027a4:	7fa8                	ld	a0,120(a5)
    800027a6:	bfcd                	j	80002798 <argraw+0x2c>
    return p->trapframe->a2;
    800027a8:	6d3c                	ld	a5,88(a0)
    800027aa:	63c8                	ld	a0,128(a5)
    800027ac:	b7f5                	j	80002798 <argraw+0x2c>
    return p->trapframe->a3;
    800027ae:	6d3c                	ld	a5,88(a0)
    800027b0:	67c8                	ld	a0,136(a5)
    800027b2:	b7dd                	j	80002798 <argraw+0x2c>
    return p->trapframe->a4;
    800027b4:	6d3c                	ld	a5,88(a0)
    800027b6:	6bc8                	ld	a0,144(a5)
    800027b8:	b7c5                	j	80002798 <argraw+0x2c>
    return p->trapframe->a5;
    800027ba:	6d3c                	ld	a5,88(a0)
    800027bc:	6fc8                	ld	a0,152(a5)
    800027be:	bfe9                	j	80002798 <argraw+0x2c>
  panic("argraw");
    800027c0:	00005517          	auipc	a0,0x5
    800027c4:	bc850513          	addi	a0,a0,-1080 # 80007388 <etext+0x388>
    800027c8:	86cfe0ef          	jal	80000834 <panic>

00000000800027cc <fetchaddr>:
{
    800027cc:	1101                	addi	sp,sp,-32
    800027ce:	ec06                	sd	ra,24(sp)
    800027d0:	e822                	sd	s0,16(sp)
    800027d2:	e426                	sd	s1,8(sp)
    800027d4:	e04a                	sd	s2,0(sp)
    800027d6:	1000                	addi	s0,sp,32
    800027d8:	84aa                	mv	s1,a0
    800027da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027dc:	92cff0ef          	jal	80001908 <myproc>
  if (addr >= p->sz ||
    800027e0:	652c                	ld	a1,72(a0)
    800027e2:	02b4f663          	bgeu	s1,a1,8000280e <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800027e6:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    800027ea:	02f5e463          	bltu	a1,a5,80002812 <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    800027ee:	4721                	li	a4,8
    800027f0:	86a6                	mv	a3,s1
    800027f2:	864a                	mv	a2,s2
    800027f4:	6928                	ld	a0,80(a0)
    800027f6:	e13fe0ef          	jal	80001608 <copyin>
    800027fa:	00a03533          	snez	a0,a0
    800027fe:	40a0053b          	negw	a0,a0
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	6105                	addi	sp,sp,32
    8000280c:	8082                	ret
    return -1;
    8000280e:	557d                	li	a0,-1
    80002810:	bfcd                	j	80002802 <fetchaddr+0x36>
    80002812:	557d                	li	a0,-1
    80002814:	b7fd                	j	80002802 <fetchaddr+0x36>

0000000080002816 <fetchstr>:
{
    80002816:	7179                	addi	sp,sp,-48
    80002818:	f406                	sd	ra,40(sp)
    8000281a:	f022                	sd	s0,32(sp)
    8000281c:	ec26                	sd	s1,24(sp)
    8000281e:	e84a                	sd	s2,16(sp)
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	1800                	addi	s0,sp,48
    80002824:	89aa                	mv	s3,a0
    80002826:	84ae                	mv	s1,a1
    80002828:	8932                	mv	s2,a2
  struct proc *p = myproc();
    8000282a:	8deff0ef          	jal	80001908 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    8000282e:	874a                	mv	a4,s2
    80002830:	86ce                	mv	a3,s3
    80002832:	8626                	mv	a2,s1
    80002834:	652c                	ld	a1,72(a0)
    80002836:	6928                	ld	a0,80(a0)
    80002838:	e6dfe0ef          	jal	800016a4 <copyinstr>
    8000283c:	00054c63          	bltz	a0,80002854 <fetchstr+0x3e>
  return strlen(buf);
    80002840:	8526                	mv	a0,s1
    80002842:	df0fe0ef          	jal	80000e32 <strlen>
}
    80002846:	70a2                	ld	ra,40(sp)
    80002848:	7402                	ld	s0,32(sp)
    8000284a:	64e2                	ld	s1,24(sp)
    8000284c:	6942                	ld	s2,16(sp)
    8000284e:	69a2                	ld	s3,8(sp)
    80002850:	6145                	addi	sp,sp,48
    80002852:	8082                	ret
    return -1;
    80002854:	557d                	li	a0,-1
    80002856:	bfc5                	j	80002846 <fetchstr+0x30>

0000000080002858 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002858:	1101                	addi	sp,sp,-32
    8000285a:	ec06                	sd	ra,24(sp)
    8000285c:	e822                	sd	s0,16(sp)
    8000285e:	e426                	sd	s1,8(sp)
    80002860:	1000                	addi	s0,sp,32
    80002862:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002864:	f09ff0ef          	jal	8000276c <argraw>
    80002868:	c088                	sw	a0,0(s1)
}
    8000286a:	60e2                	ld	ra,24(sp)
    8000286c:	6442                	ld	s0,16(sp)
    8000286e:	64a2                	ld	s1,8(sp)
    80002870:	6105                	addi	sp,sp,32
    80002872:	8082                	ret

0000000080002874 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002874:	1101                	addi	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	1000                	addi	s0,sp,32
    8000287e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002880:	eedff0ef          	jal	8000276c <argraw>
    80002884:	e088                	sd	a0,0(s1)
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6105                	addi	sp,sp,32
    8000288e:	8082                	ret

0000000080002890 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002890:	1101                	addi	sp,sp,-32
    80002892:	ec06                	sd	ra,24(sp)
    80002894:	e822                	sd	s0,16(sp)
    80002896:	e426                	sd	s1,8(sp)
    80002898:	e04a                	sd	s2,0(sp)
    8000289a:	1000                	addi	s0,sp,32
    8000289c:	892e                	mv	s2,a1
    8000289e:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800028a0:	ecdff0ef          	jal	8000276c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800028a4:	8626                	mv	a2,s1
    800028a6:	85ca                	mv	a1,s2
    800028a8:	f6fff0ef          	jal	80002816 <fetchstr>
}
    800028ac:	60e2                	ld	ra,24(sp)
    800028ae:	6442                	ld	s0,16(sp)
    800028b0:	64a2                	ld	s1,8(sp)
    800028b2:	6902                	ld	s2,0(sp)
    800028b4:	6105                	addi	sp,sp,32
    800028b6:	8082                	ret

00000000800028b8 <syscall>:
};


void
syscall(void)
{
    800028b8:	7179                	addi	sp,sp,-48
    800028ba:	f406                	sd	ra,40(sp)
    800028bc:	f022                	sd	s0,32(sp)
    800028be:	ec26                	sd	s1,24(sp)
    800028c0:	e84a                	sd	s2,16(sp)
    800028c2:	e44e                	sd	s3,8(sp)
    800028c4:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800028c6:	842ff0ef          	jal	80001908 <myproc>
    800028ca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028cc:	05853903          	ld	s2,88(a0)
    800028d0:	0a893783          	ld	a5,168(s2)
    800028d4:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028d8:	37fd                	addiw	a5,a5,-1
    800028da:	4759                	li	a4,22
    800028dc:	04f76563          	bltu	a4,a5,80002926 <syscall+0x6e>
    800028e0:	00399713          	slli	a4,s3,0x3
    800028e4:	00005797          	auipc	a5,0x5
    800028e8:	f6478793          	addi	a5,a5,-156 # 80007848 <syscalls>
    800028ec:	97ba                	add	a5,a5,a4
    800028ee:	639c                	ld	a5,0(a5)
    800028f0:	cb9d                	beqz	a5,80002926 <syscall+0x6e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028f2:	9782                	jalr	a5
    800028f4:	06a93823          	sd	a0,112(s2)
    if ((p->trace_mask >> num) & 1)
    800028f8:	1684a783          	lw	a5,360(s1)
    800028fc:	4137d7bb          	sraw	a5,a5,s3
    80002900:	8b85                	andi	a5,a5,1
    80002902:	cf9d                	beqz	a5,80002940 <syscall+0x88>
      printk("%d: syscall %s -> %ld\n",
    80002904:	6cb8                	ld	a4,88(s1)
    80002906:	098e                	slli	s3,s3,0x3
    80002908:	00005797          	auipc	a5,0x5
    8000290c:	f4078793          	addi	a5,a5,-192 # 80007848 <syscalls>
    80002910:	97ce                	add	a5,a5,s3
    80002912:	7b34                	ld	a3,112(a4)
    80002914:	63f0                	ld	a2,192(a5)
    80002916:	588c                	lw	a1,48(s1)
    80002918:	00005517          	auipc	a0,0x5
    8000291c:	a7850513          	addi	a0,a0,-1416 # 80007390 <etext+0x390>
    80002920:	bebfd0ef          	jal	8000050a <printk>
    80002924:	a831                	j	80002940 <syscall+0x88>
        p->pid, syscallnames[num], p->trapframe->a0);
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002926:	86ce                	mv	a3,s3
    80002928:	15848613          	addi	a2,s1,344
    8000292c:	588c                	lw	a1,48(s1)
    8000292e:	00005517          	auipc	a0,0x5
    80002932:	a7a50513          	addi	a0,a0,-1414 # 800073a8 <etext+0x3a8>
    80002936:	bd5fd0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    8000293a:	6cbc                	ld	a5,88(s1)
    8000293c:	577d                	li	a4,-1
    8000293e:	fbb8                	sd	a4,112(a5)
  }
}
    80002940:	70a2                	ld	ra,40(sp)
    80002942:	7402                	ld	s0,32(sp)
    80002944:	64e2                	ld	s1,24(sp)
    80002946:	6942                	ld	s2,16(sp)
    80002948:	69a2                	ld	s3,8(sp)
    8000294a:	6145                	addi	sp,sp,48
    8000294c:	8082                	ret

000000008000294e <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002956:	fec40593          	addi	a1,s0,-20
    8000295a:	4501                	li	a0,0
    8000295c:	efdff0ef          	jal	80002858 <argint>
  kexit(n);
    80002960:	fec42503          	lw	a0,-20(s0)
    80002964:	edeff0ef          	jal	80002042 <kexit>
  return 0; // not reached
}
    80002968:	4501                	li	a0,0
    8000296a:	60e2                	ld	ra,24(sp)
    8000296c:	6442                	ld	s0,16(sp)
    8000296e:	6105                	addi	sp,sp,32
    80002970:	8082                	ret

0000000080002972 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002972:	1141                	addi	sp,sp,-16
    80002974:	e406                	sd	ra,8(sp)
    80002976:	e022                	sd	s0,0(sp)
    80002978:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000297a:	f8ffe0ef          	jal	80001908 <myproc>
}
    8000297e:	5908                	lw	a0,48(a0)
    80002980:	60a2                	ld	ra,8(sp)
    80002982:	6402                	ld	s0,0(sp)
    80002984:	0141                	addi	sp,sp,16
    80002986:	8082                	ret

0000000080002988 <sys_fork>:

uint64
sys_fork(void)
{
    80002988:	1141                	addi	sp,sp,-16
    8000298a:	e406                	sd	ra,8(sp)
    8000298c:	e022                	sd	s0,0(sp)
    8000298e:	0800                	addi	s0,sp,16
  return kfork();
    80002990:	ad8ff0ef          	jal	80001c68 <kfork>
}
    80002994:	60a2                	ld	ra,8(sp)
    80002996:	6402                	ld	s0,0(sp)
    80002998:	0141                	addi	sp,sp,16
    8000299a:	8082                	ret

000000008000299c <sys_wait>:

uint64
sys_wait(void)
{
    8000299c:	1101                	addi	sp,sp,-32
    8000299e:	ec06                	sd	ra,24(sp)
    800029a0:	e822                	sd	s0,16(sp)
    800029a2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800029a4:	fe840593          	addi	a1,s0,-24
    800029a8:	4501                	li	a0,0
    800029aa:	ecbff0ef          	jal	80002874 <argaddr>
  return kwait(p);
    800029ae:	fe843503          	ld	a0,-24(s0)
    800029b2:	ff0ff0ef          	jal	800021a2 <kwait>
}
    800029b6:	60e2                	ld	ra,24(sp)
    800029b8:	6442                	ld	s0,16(sp)
    800029ba:	6105                	addi	sp,sp,32
    800029bc:	8082                	ret

00000000800029be <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800029c8:	fd840593          	addi	a1,s0,-40
    800029cc:	4501                	li	a0,0
    800029ce:	e8bff0ef          	jal	80002858 <argint>
  argint(1, &t);
    800029d2:	fdc40593          	addi	a1,s0,-36
    800029d6:	4505                	li	a0,1
    800029d8:	e81ff0ef          	jal	80002858 <argint>
  addr = myproc()->sz;
    800029dc:	f2dfe0ef          	jal	80001908 <myproc>
    800029e0:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    800029e2:	fdc42703          	lw	a4,-36(s0)
    800029e6:	4785                	li	a5,1
    800029e8:	02f70763          	beq	a4,a5,80002a16 <sys_sbrk+0x58>
    800029ec:	fd842783          	lw	a5,-40(s0)
    800029f0:	0207c363          	bltz	a5,80002a16 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    800029f4:	97a6                	add	a5,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    800029f6:	02000737          	lui	a4,0x2000
    800029fa:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800029fc:	0736                	slli	a4,a4,0xd
    800029fe:	02f76a63          	bltu	a4,a5,80002a32 <sys_sbrk+0x74>
    80002a02:	0297e863          	bltu	a5,s1,80002a32 <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80002a06:	f03fe0ef          	jal	80001908 <myproc>
    80002a0a:	fd842703          	lw	a4,-40(s0)
    80002a0e:	653c                	ld	a5,72(a0)
    80002a10:	97ba                	add	a5,a5,a4
    80002a12:	e53c                	sd	a5,72(a0)
    80002a14:	a039                	j	80002a22 <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80002a16:	fd842503          	lw	a0,-40(s0)
    80002a1a:	9ecff0ef          	jal	80001c06 <growproc>
    80002a1e:	00054863          	bltz	a0,80002a2e <sys_sbrk+0x70>
  }
  return addr;
}
    80002a22:	8526                	mv	a0,s1
    80002a24:	70a2                	ld	ra,40(sp)
    80002a26:	7402                	ld	s0,32(sp)
    80002a28:	64e2                	ld	s1,24(sp)
    80002a2a:	6145                	addi	sp,sp,48
    80002a2c:	8082                	ret
      return -1;
    80002a2e:	54fd                	li	s1,-1
    80002a30:	bfcd                	j	80002a22 <sys_sbrk+0x64>
      return -1;
    80002a32:	54fd                	li	s1,-1
    80002a34:	b7fd                	j	80002a22 <sys_sbrk+0x64>

0000000080002a36 <sys_pause>:

uint64
sys_pause(void)
{
    80002a36:	7139                	addi	sp,sp,-64
    80002a38:	fc06                	sd	ra,56(sp)
    80002a3a:	f822                	sd	s0,48(sp)
    80002a3c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a3e:	fcc40593          	addi	a1,s0,-52
    80002a42:	4501                	li	a0,0
    80002a44:	e15ff0ef          	jal	80002858 <argint>
  if (n < 0)
    80002a48:	fcc42783          	lw	a5,-52(s0)
    80002a4c:	0807c063          	bltz	a5,80002acc <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002a50:	00016517          	auipc	a0,0x16
    80002a54:	b8050513          	addi	a0,a0,-1152 # 800185d0 <tickslock>
    80002a58:	990fe0ef          	jal	80000be8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a5c:	fcc42783          	lw	a5,-52(s0)
    80002a60:	cbb9                	beqz	a5,80002ab6 <sys_pause+0x80>
    80002a62:	f426                	sd	s1,40(sp)
    80002a64:	f04a                	sd	s2,32(sp)
    80002a66:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a68:	00008997          	auipc	s3,0x8
    80002a6c:	a189a983          	lw	s3,-1512(s3) # 8000a480 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002a70:	00008917          	auipc	s2,0x8
    80002a74:	a1090913          	addi	s2,s2,-1520 # 8000a480 <ticks>
    release(&tickslock);
    80002a78:	00016497          	auipc	s1,0x16
    80002a7c:	b5848493          	addi	s1,s1,-1192 # 800185d0 <tickslock>
    if (killed(myproc())) {
    80002a80:	e89fe0ef          	jal	80001908 <myproc>
    80002a84:	ef4ff0ef          	jal	80002178 <killed>
    80002a88:	e529                	bnez	a0,80002ad2 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002a8a:	854a                	mv	a0,s2
    80002a8c:	c8eff0ef          	jal	80001f1a <sleep_prepare>
    release(&tickslock);
    80002a90:	8526                	mv	a0,s1
    80002a92:	9defe0ef          	jal	80000c70 <release>
    sleep();
    80002a96:	cc0ff0ef          	jal	80001f56 <sleep>
    acquire(&tickslock);
    80002a9a:	8526                	mv	a0,s1
    80002a9c:	94cfe0ef          	jal	80000be8 <acquire>
  while (ticks - ticks0 < n) {
    80002aa0:	00092783          	lw	a5,0(s2)
    80002aa4:	413787bb          	subw	a5,a5,s3
    80002aa8:	fcc42703          	lw	a4,-52(s0)
    80002aac:	fce7eae3          	bltu	a5,a4,80002a80 <sys_pause+0x4a>
    80002ab0:	74a2                	ld	s1,40(sp)
    80002ab2:	7902                	ld	s2,32(sp)
    80002ab4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002ab6:	00016517          	auipc	a0,0x16
    80002aba:	b1a50513          	addi	a0,a0,-1254 # 800185d0 <tickslock>
    80002abe:	9b2fe0ef          	jal	80000c70 <release>
  return 0;
    80002ac2:	4501                	li	a0,0
}
    80002ac4:	70e2                	ld	ra,56(sp)
    80002ac6:	7442                	ld	s0,48(sp)
    80002ac8:	6121                	addi	sp,sp,64
    80002aca:	8082                	ret
    n = 0;
    80002acc:	fc042623          	sw	zero,-52(s0)
    80002ad0:	b741                	j	80002a50 <sys_pause+0x1a>
      release(&tickslock);
    80002ad2:	00016517          	auipc	a0,0x16
    80002ad6:	afe50513          	addi	a0,a0,-1282 # 800185d0 <tickslock>
    80002ada:	996fe0ef          	jal	80000c70 <release>
      return -1;
    80002ade:	557d                	li	a0,-1
    80002ae0:	74a2                	ld	s1,40(sp)
    80002ae2:	7902                	ld	s2,32(sp)
    80002ae4:	69e2                	ld	s3,24(sp)
    80002ae6:	bff9                	j	80002ac4 <sys_pause+0x8e>

0000000080002ae8 <sys_kill>:

uint64
sys_kill(void)
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002af0:	fec40593          	addi	a1,s0,-20
    80002af4:	4501                	li	a0,0
    80002af6:	d63ff0ef          	jal	80002858 <argint>
  return kkill(pid);
    80002afa:	fec42503          	lw	a0,-20(s0)
    80002afe:	deaff0ef          	jal	800020e8 <kkill>
}
    80002b02:	60e2                	ld	ra,24(sp)
    80002b04:	6442                	ld	s0,16(sp)
    80002b06:	6105                	addi	sp,sp,32
    80002b08:	8082                	ret

0000000080002b0a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002b0a:	1101                	addi	sp,sp,-32
    80002b0c:	ec06                	sd	ra,24(sp)
    80002b0e:	e822                	sd	s0,16(sp)
    80002b10:	e426                	sd	s1,8(sp)
    80002b12:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002b14:	00016517          	auipc	a0,0x16
    80002b18:	abc50513          	addi	a0,a0,-1348 # 800185d0 <tickslock>
    80002b1c:	8ccfe0ef          	jal	80000be8 <acquire>
  xticks = ticks;
    80002b20:	00008797          	auipc	a5,0x8
    80002b24:	9607a783          	lw	a5,-1696(a5) # 8000a480 <ticks>
    80002b28:	84be                	mv	s1,a5
  release(&tickslock);
    80002b2a:	00016517          	auipc	a0,0x16
    80002b2e:	aa650513          	addi	a0,a0,-1370 # 800185d0 <tickslock>
    80002b32:	93efe0ef          	jal	80000c70 <release>
  return xticks;
}
    80002b36:	02049513          	slli	a0,s1,0x20
    80002b3a:	9101                	srli	a0,a0,0x20
    80002b3c:	60e2                	ld	ra,24(sp)
    80002b3e:	6442                	ld	s0,16(sp)
    80002b40:	64a2                	ld	s1,8(sp)
    80002b42:	6105                	addi	sp,sp,32
    80002b44:	8082                	ret

0000000080002b46 <sys_trace>:

uint64
sys_trace(void)
{
    80002b46:	1101                	addi	sp,sp,-32
    80002b48:	ec06                	sd	ra,24(sp)
    80002b4a:	e822                	sd	s0,16(sp)
    80002b4c:	1000                	addi	s0,sp,32
  int mask; 
  argint(0, &mask);
    80002b4e:	fec40593          	addi	a1,s0,-20
    80002b52:	4501                	li	a0,0
    80002b54:	d05ff0ef          	jal	80002858 <argint>
  myproc()->trace_mask = mask; 
    80002b58:	db1fe0ef          	jal	80001908 <myproc>
    80002b5c:	fec42783          	lw	a5,-20(s0)
    80002b60:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002b64:	4501                	li	a0,0
    80002b66:	60e2                	ld	ra,24(sp)
    80002b68:	6442                	ld	s0,16(sp)
    80002b6a:	6105                	addi	sp,sp,32
    80002b6c:	8082                	ret

0000000080002b6e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b6e:	7179                	addi	sp,sp,-48
    80002b70:	f406                	sd	ra,40(sp)
    80002b72:	f022                	sd	s0,32(sp)
    80002b74:	ec26                	sd	s1,24(sp)
    80002b76:	e84a                	sd	s2,16(sp)
    80002b78:	e44e                	sd	s3,8(sp)
    80002b7a:	e052                	sd	s4,0(sp)
    80002b7c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b7e:	00005597          	auipc	a1,0x5
    80002b82:	8f258593          	addi	a1,a1,-1806 # 80007470 <etext+0x470>
    80002b86:	00016517          	auipc	a0,0x16
    80002b8a:	a6250513          	addi	a0,a0,-1438 # 800185e8 <bcache>
    80002b8e:	fdbfd0ef          	jal	80000b68 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b92:	0001e797          	auipc	a5,0x1e
    80002b96:	a5678793          	addi	a5,a5,-1450 # 800205e8 <bcache+0x8000>
    80002b9a:	0001e717          	auipc	a4,0x1e
    80002b9e:	cb670713          	addi	a4,a4,-842 # 80020850 <bcache+0x8268>
    80002ba2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ba6:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002baa:	00016497          	auipc	s1,0x16
    80002bae:	a5648493          	addi	s1,s1,-1450 # 80018600 <bcache+0x18>
    b->next = bcache.head.next;
    80002bb2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002bb4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bb6:	00005a17          	auipc	s4,0x5
    80002bba:	8c2a0a13          	addi	s4,s4,-1854 # 80007478 <etext+0x478>
    b->next = bcache.head.next;
    80002bbe:	2b893783          	ld	a5,696(s2)
    80002bc2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bc4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bc8:	85d2                	mv	a1,s4
    80002bca:	01048513          	addi	a0,s1,16
    80002bce:	40e010ef          	jal	80003fdc <initsleeplock>
    bcache.head.next->prev = b;
    80002bd2:	2b893783          	ld	a5,696(s2)
    80002bd6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bd8:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002bdc:	45848493          	addi	s1,s1,1112
    80002be0:	fd349fe3          	bne	s1,s3,80002bbe <binit+0x50>
  }
}
    80002be4:	70a2                	ld	ra,40(sp)
    80002be6:	7402                	ld	s0,32(sp)
    80002be8:	64e2                	ld	s1,24(sp)
    80002bea:	6942                	ld	s2,16(sp)
    80002bec:	69a2                	ld	s3,8(sp)
    80002bee:	6a02                	ld	s4,0(sp)
    80002bf0:	6145                	addi	sp,sp,48
    80002bf2:	8082                	ret

0000000080002bf4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002bf4:	7179                	addi	sp,sp,-48
    80002bf6:	f406                	sd	ra,40(sp)
    80002bf8:	f022                	sd	s0,32(sp)
    80002bfa:	ec26                	sd	s1,24(sp)
    80002bfc:	e84a                	sd	s2,16(sp)
    80002bfe:	e44e                	sd	s3,8(sp)
    80002c00:	1800                	addi	s0,sp,48
    80002c02:	892a                	mv	s2,a0
    80002c04:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002c06:	00016517          	auipc	a0,0x16
    80002c0a:	9e250513          	addi	a0,a0,-1566 # 800185e8 <bcache>
    80002c0e:	fdbfd0ef          	jal	80000be8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002c12:	0001e497          	auipc	s1,0x1e
    80002c16:	c8e4b483          	ld	s1,-882(s1) # 800208a0 <bcache+0x82b8>
    80002c1a:	0001e797          	auipc	a5,0x1e
    80002c1e:	c3678793          	addi	a5,a5,-970 # 80020850 <bcache+0x8268>
    80002c22:	02f48b63          	beq	s1,a5,80002c58 <bread+0x64>
    80002c26:	873e                	mv	a4,a5
    80002c28:	a021                	j	80002c30 <bread+0x3c>
    80002c2a:	68a4                	ld	s1,80(s1)
    80002c2c:	02e48663          	beq	s1,a4,80002c58 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002c30:	449c                	lw	a5,8(s1)
    80002c32:	ff279ce3          	bne	a5,s2,80002c2a <bread+0x36>
    80002c36:	44dc                	lw	a5,12(s1)
    80002c38:	ff3799e3          	bne	a5,s3,80002c2a <bread+0x36>
      b->refcnt++;
    80002c3c:	40bc                	lw	a5,64(s1)
    80002c3e:	2785                	addiw	a5,a5,1
    80002c40:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c42:	00016517          	auipc	a0,0x16
    80002c46:	9a650513          	addi	a0,a0,-1626 # 800185e8 <bcache>
    80002c4a:	826fe0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002c4e:	01048513          	addi	a0,s1,16
    80002c52:	3c0010ef          	jal	80004012 <acquiresleep>
      return b;
    80002c56:	a889                	j	80002ca8 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c58:	0001e497          	auipc	s1,0x1e
    80002c5c:	c404b483          	ld	s1,-960(s1) # 80020898 <bcache+0x82b0>
    80002c60:	0001e797          	auipc	a5,0x1e
    80002c64:	bf078793          	addi	a5,a5,-1040 # 80020850 <bcache+0x8268>
    80002c68:	00f48863          	beq	s1,a5,80002c78 <bread+0x84>
    80002c6c:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002c6e:	40bc                	lw	a5,64(s1)
    80002c70:	cb91                	beqz	a5,80002c84 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c72:	64a4                	ld	s1,72(s1)
    80002c74:	fee49de3          	bne	s1,a4,80002c6e <bread+0x7a>
  panic("bget: no buffers");
    80002c78:	00005517          	auipc	a0,0x5
    80002c7c:	80850513          	addi	a0,a0,-2040 # 80007480 <etext+0x480>
    80002c80:	bb5fd0ef          	jal	80000834 <panic>
      b->dev = dev;
    80002c84:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c88:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c8c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c90:	4785                	li	a5,1
    80002c92:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c94:	00016517          	auipc	a0,0x16
    80002c98:	95450513          	addi	a0,a0,-1708 # 800185e8 <bcache>
    80002c9c:	fd5fd0ef          	jal	80000c70 <release>
      acquiresleep(&b->lock);
    80002ca0:	01048513          	addi	a0,s1,16
    80002ca4:	36e010ef          	jal	80004012 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002ca8:	409c                	lw	a5,0(s1)
    80002caa:	cb89                	beqz	a5,80002cbc <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002cac:	8526                	mv	a0,s1
    80002cae:	70a2                	ld	ra,40(sp)
    80002cb0:	7402                	ld	s0,32(sp)
    80002cb2:	64e2                	ld	s1,24(sp)
    80002cb4:	6942                	ld	s2,16(sp)
    80002cb6:	69a2                	ld	s3,8(sp)
    80002cb8:	6145                	addi	sp,sp,48
    80002cba:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cbc:	4581                	li	a1,0
    80002cbe:	8526                	mv	a0,s1
    80002cc0:	481020ef          	jal	80005940 <virtio_disk_rw>
    b->valid = 1;
    80002cc4:	4785                	li	a5,1
    80002cc6:	c09c                	sw	a5,0(s1)
  return b;
    80002cc8:	b7d5                	j	80002cac <bread+0xb8>

0000000080002cca <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002cca:	1101                	addi	sp,sp,-32
    80002ccc:	ec06                	sd	ra,24(sp)
    80002cce:	e822                	sd	s0,16(sp)
    80002cd0:	e426                	sd	s1,8(sp)
    80002cd2:	1000                	addi	s0,sp,32
    80002cd4:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002cd6:	0541                	addi	a0,a0,16
    80002cd8:	3c6010ef          	jal	8000409e <holdingsleep>
    80002cdc:	c911                	beqz	a0,80002cf0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002cde:	4585                	li	a1,1
    80002ce0:	8526                	mv	a0,s1
    80002ce2:	45f020ef          	jal	80005940 <virtio_disk_rw>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
    panic("bwrite");
    80002cf0:	00004517          	auipc	a0,0x4
    80002cf4:	7a850513          	addi	a0,a0,1960 # 80007498 <etext+0x498>
    80002cf8:	b3dfd0ef          	jal	80000834 <panic>

0000000080002cfc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002cfc:	1101                	addi	sp,sp,-32
    80002cfe:	ec06                	sd	ra,24(sp)
    80002d00:	e822                	sd	s0,16(sp)
    80002d02:	e426                	sd	s1,8(sp)
    80002d04:	e04a                	sd	s2,0(sp)
    80002d06:	1000                	addi	s0,sp,32
    80002d08:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002d0a:	01050913          	addi	s2,a0,16
    80002d0e:	854a                	mv	a0,s2
    80002d10:	38e010ef          	jal	8000409e <holdingsleep>
    80002d14:	c125                	beqz	a0,80002d74 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002d16:	854a                	mv	a0,s2
    80002d18:	34e010ef          	jal	80004066 <releasesleep>

  acquire(&bcache.lock);
    80002d1c:	00016517          	auipc	a0,0x16
    80002d20:	8cc50513          	addi	a0,a0,-1844 # 800185e8 <bcache>
    80002d24:	ec5fd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    80002d28:	40bc                	lw	a5,64(s1)
    80002d2a:	37fd                	addiw	a5,a5,-1
    80002d2c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d2e:	e79d                	bnez	a5,80002d5c <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d30:	68b8                	ld	a4,80(s1)
    80002d32:	64bc                	ld	a5,72(s1)
    80002d34:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d36:	68b8                	ld	a4,80(s1)
    80002d38:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d3a:	0001e797          	auipc	a5,0x1e
    80002d3e:	8ae78793          	addi	a5,a5,-1874 # 800205e8 <bcache+0x8000>
    80002d42:	2b87b703          	ld	a4,696(a5)
    80002d46:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d48:	0001e717          	auipc	a4,0x1e
    80002d4c:	b0870713          	addi	a4,a4,-1272 # 80020850 <bcache+0x8268>
    80002d50:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d52:	2b87b703          	ld	a4,696(a5)
    80002d56:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d58:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002d5c:	00016517          	auipc	a0,0x16
    80002d60:	88c50513          	addi	a0,a0,-1908 # 800185e8 <bcache>
    80002d64:	f0dfd0ef          	jal	80000c70 <release>
}
    80002d68:	60e2                	ld	ra,24(sp)
    80002d6a:	6442                	ld	s0,16(sp)
    80002d6c:	64a2                	ld	s1,8(sp)
    80002d6e:	6902                	ld	s2,0(sp)
    80002d70:	6105                	addi	sp,sp,32
    80002d72:	8082                	ret
    panic("brelse");
    80002d74:	00004517          	auipc	a0,0x4
    80002d78:	72c50513          	addi	a0,a0,1836 # 800074a0 <etext+0x4a0>
    80002d7c:	ab9fd0ef          	jal	80000834 <panic>

0000000080002d80 <bpin>:

void
bpin(struct buf *b)
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	1000                	addi	s0,sp,32
    80002d8a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d8c:	00016517          	auipc	a0,0x16
    80002d90:	85c50513          	addi	a0,a0,-1956 # 800185e8 <bcache>
    80002d94:	e55fd0ef          	jal	80000be8 <acquire>
  b->refcnt++;
    80002d98:	40bc                	lw	a5,64(s1)
    80002d9a:	2785                	addiw	a5,a5,1
    80002d9c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d9e:	00016517          	auipc	a0,0x16
    80002da2:	84a50513          	addi	a0,a0,-1974 # 800185e8 <bcache>
    80002da6:	ecbfd0ef          	jal	80000c70 <release>
}
    80002daa:	60e2                	ld	ra,24(sp)
    80002dac:	6442                	ld	s0,16(sp)
    80002dae:	64a2                	ld	s1,8(sp)
    80002db0:	6105                	addi	sp,sp,32
    80002db2:	8082                	ret

0000000080002db4 <bunpin>:

void
bunpin(struct buf *b)
{
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	e426                	sd	s1,8(sp)
    80002dbc:	1000                	addi	s0,sp,32
    80002dbe:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002dc0:	00016517          	auipc	a0,0x16
    80002dc4:	82850513          	addi	a0,a0,-2008 # 800185e8 <bcache>
    80002dc8:	e21fd0ef          	jal	80000be8 <acquire>
  b->refcnt--;
    80002dcc:	40bc                	lw	a5,64(s1)
    80002dce:	37fd                	addiw	a5,a5,-1
    80002dd0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002dd2:	00016517          	auipc	a0,0x16
    80002dd6:	81650513          	addi	a0,a0,-2026 # 800185e8 <bcache>
    80002dda:	e97fd0ef          	jal	80000c70 <release>
}
    80002dde:	60e2                	ld	ra,24(sp)
    80002de0:	6442                	ld	s0,16(sp)
    80002de2:	64a2                	ld	s1,8(sp)
    80002de4:	6105                	addi	sp,sp,32
    80002de6:	8082                	ret

0000000080002de8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002de8:	1101                	addi	sp,sp,-32
    80002dea:	ec06                	sd	ra,24(sp)
    80002dec:	e822                	sd	s0,16(sp)
    80002dee:	e426                	sd	s1,8(sp)
    80002df0:	e04a                	sd	s2,0(sp)
    80002df2:	1000                	addi	s0,sp,32
    80002df4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002df6:	00d5d79b          	srliw	a5,a1,0xd
    80002dfa:	0001e597          	auipc	a1,0x1e
    80002dfe:	eca5a583          	lw	a1,-310(a1) # 80020cc4 <sb+0x1c>
    80002e02:	9dbd                	addw	a1,a1,a5
    80002e04:	df1ff0ef          	jal	80002bf4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002e08:	0074f713          	andi	a4,s1,7
    80002e0c:	4785                	li	a5,1
    80002e0e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002e12:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002e14:	90d9                	srli	s1,s1,0x36
    80002e16:	00950733          	add	a4,a0,s1
    80002e1a:	05874703          	lbu	a4,88(a4)
    80002e1e:	00e7f6b3          	and	a3,a5,a4
    80002e22:	c29d                	beqz	a3,80002e48 <bfree+0x60>
    80002e24:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002e26:	94aa                	add	s1,s1,a0
    80002e28:	fff7c793          	not	a5,a5
    80002e2c:	8f7d                	and	a4,a4,a5
    80002e2e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e32:	072010ef          	jal	80003ea4 <log_write>
  brelse(bp);
    80002e36:	854a                	mv	a0,s2
    80002e38:	ec5ff0ef          	jal	80002cfc <brelse>
}
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6902                	ld	s2,0(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret
    panic("freeing free block");
    80002e48:	00004517          	auipc	a0,0x4
    80002e4c:	66050513          	addi	a0,a0,1632 # 800074a8 <etext+0x4a8>
    80002e50:	9e5fd0ef          	jal	80000834 <panic>

0000000080002e54 <balloc>:
{
    80002e54:	715d                	addi	sp,sp,-80
    80002e56:	e486                	sd	ra,72(sp)
    80002e58:	e0a2                	sd	s0,64(sp)
    80002e5a:	fc26                	sd	s1,56(sp)
    80002e5c:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002e5e:	0001e797          	auipc	a5,0x1e
    80002e62:	e4e7a783          	lw	a5,-434(a5) # 80020cac <sb+0x4>
    80002e66:	0e078263          	beqz	a5,80002f4a <balloc+0xf6>
    80002e6a:	f84a                	sd	s2,48(sp)
    80002e6c:	f44e                	sd	s3,40(sp)
    80002e6e:	f052                	sd	s4,32(sp)
    80002e70:	ec56                	sd	s5,24(sp)
    80002e72:	e85a                	sd	s6,16(sp)
    80002e74:	e45e                	sd	s7,8(sp)
    80002e76:	e062                	sd	s8,0(sp)
    80002e78:	8baa                	mv	s7,a0
    80002e7a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e7c:	0001eb17          	auipc	s6,0x1e
    80002e80:	e2cb0b13          	addi	s6,s6,-468 # 80020ca8 <sb>
      m = 1 << (bi % 8);
    80002e84:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e86:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002e88:	6c09                	lui	s8,0x2
    80002e8a:	a09d                	j	80002ef0 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002e8c:	97ca                	add	a5,a5,s2
    80002e8e:	8e55                	or	a2,a2,a3
    80002e90:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e94:	854a                	mv	a0,s2
    80002e96:	00e010ef          	jal	80003ea4 <log_write>
        brelse(bp);
    80002e9a:	854a                	mv	a0,s2
    80002e9c:	e61ff0ef          	jal	80002cfc <brelse>
  bp = bread(dev, bno);
    80002ea0:	85a6                	mv	a1,s1
    80002ea2:	855e                	mv	a0,s7
    80002ea4:	d51ff0ef          	jal	80002bf4 <bread>
    80002ea8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002eaa:	40000613          	li	a2,1024
    80002eae:	4581                	li	a1,0
    80002eb0:	05850513          	addi	a0,a0,88
    80002eb4:	df5fd0ef          	jal	80000ca8 <memset>
  log_write(bp);
    80002eb8:	854a                	mv	a0,s2
    80002eba:	7eb000ef          	jal	80003ea4 <log_write>
  brelse(bp);
    80002ebe:	854a                	mv	a0,s2
    80002ec0:	e3dff0ef          	jal	80002cfc <brelse>
}
    80002ec4:	7942                	ld	s2,48(sp)
    80002ec6:	79a2                	ld	s3,40(sp)
    80002ec8:	7a02                	ld	s4,32(sp)
    80002eca:	6ae2                	ld	s5,24(sp)
    80002ecc:	6b42                	ld	s6,16(sp)
    80002ece:	6ba2                	ld	s7,8(sp)
    80002ed0:	6c02                	ld	s8,0(sp)
}
    80002ed2:	8526                	mv	a0,s1
    80002ed4:	60a6                	ld	ra,72(sp)
    80002ed6:	6406                	ld	s0,64(sp)
    80002ed8:	74e2                	ld	s1,56(sp)
    80002eda:	6161                	addi	sp,sp,80
    80002edc:	8082                	ret
    brelse(bp);
    80002ede:	854a                	mv	a0,s2
    80002ee0:	e1dff0ef          	jal	80002cfc <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002ee4:	015c0abb          	addw	s5,s8,s5
    80002ee8:	004b2783          	lw	a5,4(s6)
    80002eec:	04faf863          	bgeu	s5,a5,80002f3c <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002ef0:	40dad59b          	sraiw	a1,s5,0xd
    80002ef4:	01cb2783          	lw	a5,28(s6)
    80002ef8:	9dbd                	addw	a1,a1,a5
    80002efa:	855e                	mv	a0,s7
    80002efc:	cf9ff0ef          	jal	80002bf4 <bread>
    80002f00:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f02:	004b2503          	lw	a0,4(s6)
    80002f06:	84d6                	mv	s1,s5
    80002f08:	4701                	li	a4,0
    80002f0a:	fca4fae3          	bgeu	s1,a0,80002ede <balloc+0x8a>
      m = 1 << (bi % 8);
    80002f0e:	00777693          	andi	a3,a4,7
    80002f12:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002f16:	41f7579b          	sraiw	a5,a4,0x1f
    80002f1a:	01d7d79b          	srliw	a5,a5,0x1d
    80002f1e:	9fb9                	addw	a5,a5,a4
    80002f20:	4037d79b          	sraiw	a5,a5,0x3
    80002f24:	00f90633          	add	a2,s2,a5
    80002f28:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80002f2c:	00c6f5b3          	and	a1,a3,a2
    80002f30:	ddb1                	beqz	a1,80002e8c <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f32:	2705                	addiw	a4,a4,1
    80002f34:	2485                	addiw	s1,s1,1
    80002f36:	fd471ae3          	bne	a4,s4,80002f0a <balloc+0xb6>
    80002f3a:	b755                	j	80002ede <balloc+0x8a>
    80002f3c:	7942                	ld	s2,48(sp)
    80002f3e:	79a2                	ld	s3,40(sp)
    80002f40:	7a02                	ld	s4,32(sp)
    80002f42:	6ae2                	ld	s5,24(sp)
    80002f44:	6b42                	ld	s6,16(sp)
    80002f46:	6ba2                	ld	s7,8(sp)
    80002f48:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80002f4a:	00004517          	auipc	a0,0x4
    80002f4e:	57650513          	addi	a0,a0,1398 # 800074c0 <etext+0x4c0>
    80002f52:	db8fd0ef          	jal	8000050a <printk>
  return 0;
    80002f56:	4481                	li	s1,0
    80002f58:	bfad                	j	80002ed2 <balloc+0x7e>

0000000080002f5a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f5a:	7179                	addi	sp,sp,-48
    80002f5c:	f406                	sd	ra,40(sp)
    80002f5e:	f022                	sd	s0,32(sp)
    80002f60:	ec26                	sd	s1,24(sp)
    80002f62:	e84a                	sd	s2,16(sp)
    80002f64:	e44e                	sd	s3,8(sp)
    80002f66:	1800                	addi	s0,sp,48
    80002f68:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002f6a:	47ad                	li	a5,11
    80002f6c:	02b7e363          	bltu	a5,a1,80002f92 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80002f70:	02059793          	slli	a5,a1,0x20
    80002f74:	01e7d593          	srli	a1,a5,0x1e
    80002f78:	00b509b3          	add	s3,a0,a1
    80002f7c:	0509a483          	lw	s1,80(s3)
    80002f80:	e0b5                	bnez	s1,80002fe4 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002f82:	4108                	lw	a0,0(a0)
    80002f84:	ed1ff0ef          	jal	80002e54 <balloc>
    80002f88:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f8a:	cd29                	beqz	a0,80002fe4 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002f8c:	04a9a823          	sw	a0,80(s3)
    80002f90:	a891                	j	80002fe4 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f92:	ff45879b          	addiw	a5,a1,-12
    80002f96:	873e                	mv	a4,a5
    80002f98:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80002f9a:	0ff00793          	li	a5,255
    80002f9e:	06e7e763          	bltu	a5,a4,8000300c <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002fa2:	08052483          	lw	s1,128(a0)
    80002fa6:	e891                	bnez	s1,80002fba <bmap+0x60>
      addr = balloc(ip->dev);
    80002fa8:	4108                	lw	a0,0(a0)
    80002faa:	eabff0ef          	jal	80002e54 <balloc>
    80002fae:	84aa                	mv	s1,a0
      if (addr == 0)
    80002fb0:	c915                	beqz	a0,80002fe4 <bmap+0x8a>
    80002fb2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002fb4:	08a92023          	sw	a0,128(s2)
    80002fb8:	a011                	j	80002fbc <bmap+0x62>
    80002fba:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002fbc:	85a6                	mv	a1,s1
    80002fbe:	00092503          	lw	a0,0(s2)
    80002fc2:	c33ff0ef          	jal	80002bf4 <bread>
    80002fc6:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002fc8:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002fcc:	02099713          	slli	a4,s3,0x20
    80002fd0:	01e75593          	srli	a1,a4,0x1e
    80002fd4:	97ae                	add	a5,a5,a1
    80002fd6:	89be                	mv	s3,a5
    80002fd8:	4384                	lw	s1,0(a5)
    80002fda:	cc89                	beqz	s1,80002ff4 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002fdc:	8552                	mv	a0,s4
    80002fde:	d1fff0ef          	jal	80002cfc <brelse>
    return addr;
    80002fe2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	70a2                	ld	ra,40(sp)
    80002fe8:	7402                	ld	s0,32(sp)
    80002fea:	64e2                	ld	s1,24(sp)
    80002fec:	6942                	ld	s2,16(sp)
    80002fee:	69a2                	ld	s3,8(sp)
    80002ff0:	6145                	addi	sp,sp,48
    80002ff2:	8082                	ret
      addr = balloc(ip->dev);
    80002ff4:	00092503          	lw	a0,0(s2)
    80002ff8:	e5dff0ef          	jal	80002e54 <balloc>
    80002ffc:	84aa                	mv	s1,a0
      if (addr) {
    80002ffe:	dd79                	beqz	a0,80002fdc <bmap+0x82>
        a[bn] = addr;
    80003000:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003004:	8552                	mv	a0,s4
    80003006:	69f000ef          	jal	80003ea4 <log_write>
    8000300a:	bfc9                	j	80002fdc <bmap+0x82>
    8000300c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000300e:	00004517          	auipc	a0,0x4
    80003012:	4ca50513          	addi	a0,a0,1226 # 800074d8 <etext+0x4d8>
    80003016:	81ffd0ef          	jal	80000834 <panic>

000000008000301a <iget>:
{
    8000301a:	7179                	addi	sp,sp,-48
    8000301c:	f406                	sd	ra,40(sp)
    8000301e:	f022                	sd	s0,32(sp)
    80003020:	ec26                	sd	s1,24(sp)
    80003022:	e84a                	sd	s2,16(sp)
    80003024:	e44e                	sd	s3,8(sp)
    80003026:	e052                	sd	s4,0(sp)
    80003028:	1800                	addi	s0,sp,48
    8000302a:	892a                	mv	s2,a0
    8000302c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000302e:	0001e517          	auipc	a0,0x1e
    80003032:	c9a50513          	addi	a0,a0,-870 # 80020cc8 <itable>
    80003036:	bb3fd0ef          	jal	80000be8 <acquire>
  empty = 0;
    8000303a:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000303c:	0001e497          	auipc	s1,0x1e
    80003040:	ca448493          	addi	s1,s1,-860 # 80020ce0 <itable+0x18>
    80003044:	0001f697          	auipc	a3,0x1f
    80003048:	72c68693          	addi	a3,a3,1836 # 80022770 <log>
    8000304c:	a809                	j	8000305e <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000304e:	e781                	bnez	a5,80003056 <iget+0x3c>
    80003050:	00099363          	bnez	s3,80003056 <iget+0x3c>
      empty = ip;
    80003054:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003056:	08848493          	addi	s1,s1,136
    8000305a:	02d48563          	beq	s1,a3,80003084 <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000305e:	449c                	lw	a5,8(s1)
    80003060:	fef057e3          	blez	a5,8000304e <iget+0x34>
    80003064:	4098                	lw	a4,0(s1)
    80003066:	ff2718e3          	bne	a4,s2,80003056 <iget+0x3c>
    8000306a:	40d8                	lw	a4,4(s1)
    8000306c:	ff4715e3          	bne	a4,s4,80003056 <iget+0x3c>
      ip->ref++;
    80003070:	2785                	addiw	a5,a5,1
    80003072:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003074:	0001e517          	auipc	a0,0x1e
    80003078:	c5450513          	addi	a0,a0,-940 # 80020cc8 <itable>
    8000307c:	bf5fd0ef          	jal	80000c70 <release>
      return ip;
    80003080:	89a6                	mv	s3,s1
    80003082:	a015                	j	800030a6 <iget+0x8c>
  if (empty == 0)
    80003084:	02098a63          	beqz	s3,800030b8 <iget+0x9e>
  ip->dev = dev;
    80003088:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000308c:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003090:	4785                	li	a5,1
    80003092:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003096:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000309a:	0001e517          	auipc	a0,0x1e
    8000309e:	c2e50513          	addi	a0,a0,-978 # 80020cc8 <itable>
    800030a2:	bcffd0ef          	jal	80000c70 <release>
}
    800030a6:	854e                	mv	a0,s3
    800030a8:	70a2                	ld	ra,40(sp)
    800030aa:	7402                	ld	s0,32(sp)
    800030ac:	64e2                	ld	s1,24(sp)
    800030ae:	6942                	ld	s2,16(sp)
    800030b0:	69a2                	ld	s3,8(sp)
    800030b2:	6a02                	ld	s4,0(sp)
    800030b4:	6145                	addi	sp,sp,48
    800030b6:	8082                	ret
    panic("iget: no inodes");
    800030b8:	00004517          	auipc	a0,0x4
    800030bc:	43850513          	addi	a0,a0,1080 # 800074f0 <etext+0x4f0>
    800030c0:	f74fd0ef          	jal	80000834 <panic>

00000000800030c4 <iinit>:
{
    800030c4:	7179                	addi	sp,sp,-48
    800030c6:	f406                	sd	ra,40(sp)
    800030c8:	f022                	sd	s0,32(sp)
    800030ca:	ec26                	sd	s1,24(sp)
    800030cc:	e84a                	sd	s2,16(sp)
    800030ce:	e44e                	sd	s3,8(sp)
    800030d0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800030d2:	00004597          	auipc	a1,0x4
    800030d6:	42e58593          	addi	a1,a1,1070 # 80007500 <etext+0x500>
    800030da:	0001e517          	auipc	a0,0x1e
    800030de:	bee50513          	addi	a0,a0,-1042 # 80020cc8 <itable>
    800030e2:	a87fd0ef          	jal	80000b68 <initlock>
  for (i = 0; i < NINODE; i++) {
    800030e6:	0001e497          	auipc	s1,0x1e
    800030ea:	c0a48493          	addi	s1,s1,-1014 # 80020cf0 <itable+0x28>
    800030ee:	0001f997          	auipc	s3,0x1f
    800030f2:	69298993          	addi	s3,s3,1682 # 80022780 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030f6:	00004917          	auipc	s2,0x4
    800030fa:	41290913          	addi	s2,s2,1042 # 80007508 <etext+0x508>
    800030fe:	85ca                	mv	a1,s2
    80003100:	8526                	mv	a0,s1
    80003102:	6db000ef          	jal	80003fdc <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003106:	08848493          	addi	s1,s1,136
    8000310a:	ff349ae3          	bne	s1,s3,800030fe <iinit+0x3a>
}
    8000310e:	70a2                	ld	ra,40(sp)
    80003110:	7402                	ld	s0,32(sp)
    80003112:	64e2                	ld	s1,24(sp)
    80003114:	6942                	ld	s2,16(sp)
    80003116:	69a2                	ld	s3,8(sp)
    80003118:	6145                	addi	sp,sp,48
    8000311a:	8082                	ret

000000008000311c <ialloc>:
{
    8000311c:	7139                	addi	sp,sp,-64
    8000311e:	fc06                	sd	ra,56(sp)
    80003120:	f822                	sd	s0,48(sp)
    80003122:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003124:	0001e717          	auipc	a4,0x1e
    80003128:	b9072703          	lw	a4,-1136(a4) # 80020cb4 <sb+0xc>
    8000312c:	4785                	li	a5,1
    8000312e:	06e7f063          	bgeu	a5,a4,8000318e <ialloc+0x72>
    80003132:	f426                	sd	s1,40(sp)
    80003134:	f04a                	sd	s2,32(sp)
    80003136:	ec4e                	sd	s3,24(sp)
    80003138:	e852                	sd	s4,16(sp)
    8000313a:	e456                	sd	s5,8(sp)
    8000313c:	e05a                	sd	s6,0(sp)
    8000313e:	8aaa                	mv	s5,a0
    80003140:	8b2e                	mv	s6,a1
    80003142:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003144:	0001ea17          	auipc	s4,0x1e
    80003148:	b64a0a13          	addi	s4,s4,-1180 # 80020ca8 <sb>
    8000314c:	00495593          	srli	a1,s2,0x4
    80003150:	018a2783          	lw	a5,24(s4)
    80003154:	9dbd                	addw	a1,a1,a5
    80003156:	8556                	mv	a0,s5
    80003158:	a9dff0ef          	jal	80002bf4 <bread>
    8000315c:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000315e:	05850993          	addi	s3,a0,88
    80003162:	00f97793          	andi	a5,s2,15
    80003166:	079a                	slli	a5,a5,0x6
    80003168:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000316a:	00099783          	lh	a5,0(s3)
    8000316e:	cb9d                	beqz	a5,800031a4 <ialloc+0x88>
    brelse(bp);
    80003170:	b8dff0ef          	jal	80002cfc <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003174:	0905                	addi	s2,s2,1
    80003176:	00ca2703          	lw	a4,12(s4)
    8000317a:	0009079b          	sext.w	a5,s2
    8000317e:	fce7e7e3          	bltu	a5,a4,8000314c <ialloc+0x30>
    80003182:	74a2                	ld	s1,40(sp)
    80003184:	7902                	ld	s2,32(sp)
    80003186:	69e2                	ld	s3,24(sp)
    80003188:	6a42                	ld	s4,16(sp)
    8000318a:	6aa2                	ld	s5,8(sp)
    8000318c:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    8000318e:	00004517          	auipc	a0,0x4
    80003192:	38250513          	addi	a0,a0,898 # 80007510 <etext+0x510>
    80003196:	b74fd0ef          	jal	8000050a <printk>
  return 0;
    8000319a:	4501                	li	a0,0
}
    8000319c:	70e2                	ld	ra,56(sp)
    8000319e:	7442                	ld	s0,48(sp)
    800031a0:	6121                	addi	sp,sp,64
    800031a2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800031a4:	04000613          	li	a2,64
    800031a8:	4581                	li	a1,0
    800031aa:	854e                	mv	a0,s3
    800031ac:	afdfd0ef          	jal	80000ca8 <memset>
      dip->type = type;
    800031b0:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800031b4:	8526                	mv	a0,s1
    800031b6:	4ef000ef          	jal	80003ea4 <log_write>
      brelse(bp);
    800031ba:	8526                	mv	a0,s1
    800031bc:	b41ff0ef          	jal	80002cfc <brelse>
      return iget(dev, inum);
    800031c0:	0009059b          	sext.w	a1,s2
    800031c4:	8556                	mv	a0,s5
    800031c6:	e55ff0ef          	jal	8000301a <iget>
    800031ca:	74a2                	ld	s1,40(sp)
    800031cc:	7902                	ld	s2,32(sp)
    800031ce:	69e2                	ld	s3,24(sp)
    800031d0:	6a42                	ld	s4,16(sp)
    800031d2:	6aa2                	ld	s5,8(sp)
    800031d4:	6b02                	ld	s6,0(sp)
    800031d6:	b7d9                	j	8000319c <ialloc+0x80>

00000000800031d8 <iupdate>:
{
    800031d8:	1101                	addi	sp,sp,-32
    800031da:	ec06                	sd	ra,24(sp)
    800031dc:	e822                	sd	s0,16(sp)
    800031de:	e426                	sd	s1,8(sp)
    800031e0:	e04a                	sd	s2,0(sp)
    800031e2:	1000                	addi	s0,sp,32
    800031e4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031e6:	415c                	lw	a5,4(a0)
    800031e8:	0047d79b          	srliw	a5,a5,0x4
    800031ec:	0001e597          	auipc	a1,0x1e
    800031f0:	ad45a583          	lw	a1,-1324(a1) # 80020cc0 <sb+0x18>
    800031f4:	9dbd                	addw	a1,a1,a5
    800031f6:	4108                	lw	a0,0(a0)
    800031f8:	9fdff0ef          	jal	80002bf4 <bread>
    800031fc:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800031fe:	05850793          	addi	a5,a0,88
    80003202:	40d8                	lw	a4,4(s1)
    80003204:	8b3d                	andi	a4,a4,15
    80003206:	071a                	slli	a4,a4,0x6
    80003208:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000320a:	04449703          	lh	a4,68(s1)
    8000320e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003212:	04649703          	lh	a4,70(s1)
    80003216:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000321a:	04849703          	lh	a4,72(s1)
    8000321e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003222:	04a49703          	lh	a4,74(s1)
    80003226:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000322a:	44f8                	lw	a4,76(s1)
    8000322c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000322e:	03400613          	li	a2,52
    80003232:	05048593          	addi	a1,s1,80
    80003236:	00c78513          	addi	a0,a5,12
    8000323a:	acffd0ef          	jal	80000d08 <memmove>
  log_write(bp);
    8000323e:	854a                	mv	a0,s2
    80003240:	465000ef          	jal	80003ea4 <log_write>
  brelse(bp);
    80003244:	854a                	mv	a0,s2
    80003246:	ab7ff0ef          	jal	80002cfc <brelse>
}
    8000324a:	60e2                	ld	ra,24(sp)
    8000324c:	6442                	ld	s0,16(sp)
    8000324e:	64a2                	ld	s1,8(sp)
    80003250:	6902                	ld	s2,0(sp)
    80003252:	6105                	addi	sp,sp,32
    80003254:	8082                	ret

0000000080003256 <idup>:
{
    80003256:	1101                	addi	sp,sp,-32
    80003258:	ec06                	sd	ra,24(sp)
    8000325a:	e822                	sd	s0,16(sp)
    8000325c:	e426                	sd	s1,8(sp)
    8000325e:	1000                	addi	s0,sp,32
    80003260:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003262:	0001e517          	auipc	a0,0x1e
    80003266:	a6650513          	addi	a0,a0,-1434 # 80020cc8 <itable>
    8000326a:	97ffd0ef          	jal	80000be8 <acquire>
  ip->ref++;
    8000326e:	449c                	lw	a5,8(s1)
    80003270:	2785                	addiw	a5,a5,1
    80003272:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003274:	0001e517          	auipc	a0,0x1e
    80003278:	a5450513          	addi	a0,a0,-1452 # 80020cc8 <itable>
    8000327c:	9f5fd0ef          	jal	80000c70 <release>
}
    80003280:	8526                	mv	a0,s1
    80003282:	60e2                	ld	ra,24(sp)
    80003284:	6442                	ld	s0,16(sp)
    80003286:	64a2                	ld	s1,8(sp)
    80003288:	6105                	addi	sp,sp,32
    8000328a:	8082                	ret

000000008000328c <ilock>:
{
    8000328c:	1101                	addi	sp,sp,-32
    8000328e:	ec06                	sd	ra,24(sp)
    80003290:	e822                	sd	s0,16(sp)
    80003292:	e426                	sd	s1,8(sp)
    80003294:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003296:	cd19                	beqz	a0,800032b4 <ilock+0x28>
    80003298:	84aa                	mv	s1,a0
    8000329a:	451c                	lw	a5,8(a0)
    8000329c:	00f05c63          	blez	a5,800032b4 <ilock+0x28>
  acquiresleep(&ip->lock);
    800032a0:	0541                	addi	a0,a0,16
    800032a2:	571000ef          	jal	80004012 <acquiresleep>
  if (ip->valid == 0) {
    800032a6:	40bc                	lw	a5,64(s1)
    800032a8:	cf89                	beqz	a5,800032c2 <ilock+0x36>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	64a2                	ld	s1,8(sp)
    800032b0:	6105                	addi	sp,sp,32
    800032b2:	8082                	ret
    800032b4:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800032b6:	00004517          	auipc	a0,0x4
    800032ba:	27250513          	addi	a0,a0,626 # 80007528 <etext+0x528>
    800032be:	d76fd0ef          	jal	80000834 <panic>
    800032c2:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032c4:	40dc                	lw	a5,4(s1)
    800032c6:	0047d79b          	srliw	a5,a5,0x4
    800032ca:	0001e597          	auipc	a1,0x1e
    800032ce:	9f65a583          	lw	a1,-1546(a1) # 80020cc0 <sb+0x18>
    800032d2:	9dbd                	addw	a1,a1,a5
    800032d4:	4088                	lw	a0,0(s1)
    800032d6:	91fff0ef          	jal	80002bf4 <bread>
    800032da:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800032dc:	05850593          	addi	a1,a0,88
    800032e0:	40dc                	lw	a5,4(s1)
    800032e2:	8bbd                	andi	a5,a5,15
    800032e4:	079a                	slli	a5,a5,0x6
    800032e6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032e8:	00059783          	lh	a5,0(a1)
    800032ec:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032f0:	00259783          	lh	a5,2(a1)
    800032f4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032f8:	00459783          	lh	a5,4(a1)
    800032fc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003300:	00659783          	lh	a5,6(a1)
    80003304:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003308:	459c                	lw	a5,8(a1)
    8000330a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000330c:	03400613          	li	a2,52
    80003310:	05b1                	addi	a1,a1,12
    80003312:	05048513          	addi	a0,s1,80
    80003316:	9f3fd0ef          	jal	80000d08 <memmove>
    brelse(bp);
    8000331a:	854a                	mv	a0,s2
    8000331c:	9e1ff0ef          	jal	80002cfc <brelse>
    ip->valid = 1;
    80003320:	4785                	li	a5,1
    80003322:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003324:	04449783          	lh	a5,68(s1)
    80003328:	c399                	beqz	a5,8000332e <ilock+0xa2>
    8000332a:	6902                	ld	s2,0(sp)
    8000332c:	bfbd                	j	800032aa <ilock+0x1e>
      panic("ilock: no type");
    8000332e:	00004517          	auipc	a0,0x4
    80003332:	20250513          	addi	a0,a0,514 # 80007530 <etext+0x530>
    80003336:	cfefd0ef          	jal	80000834 <panic>

000000008000333a <iunlock>:
{
    8000333a:	1101                	addi	sp,sp,-32
    8000333c:	ec06                	sd	ra,24(sp)
    8000333e:	e822                	sd	s0,16(sp)
    80003340:	e426                	sd	s1,8(sp)
    80003342:	e04a                	sd	s2,0(sp)
    80003344:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003346:	c505                	beqz	a0,8000336e <iunlock+0x34>
    80003348:	84aa                	mv	s1,a0
    8000334a:	01050913          	addi	s2,a0,16
    8000334e:	854a                	mv	a0,s2
    80003350:	54f000ef          	jal	8000409e <holdingsleep>
    80003354:	cd09                	beqz	a0,8000336e <iunlock+0x34>
    80003356:	449c                	lw	a5,8(s1)
    80003358:	00f05b63          	blez	a5,8000336e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000335c:	854a                	mv	a0,s2
    8000335e:	509000ef          	jal	80004066 <releasesleep>
}
    80003362:	60e2                	ld	ra,24(sp)
    80003364:	6442                	ld	s0,16(sp)
    80003366:	64a2                	ld	s1,8(sp)
    80003368:	6902                	ld	s2,0(sp)
    8000336a:	6105                	addi	sp,sp,32
    8000336c:	8082                	ret
    panic("iunlock");
    8000336e:	00004517          	auipc	a0,0x4
    80003372:	1d250513          	addi	a0,a0,466 # 80007540 <etext+0x540>
    80003376:	cbefd0ef          	jal	80000834 <panic>

000000008000337a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000337a:	7179                	addi	sp,sp,-48
    8000337c:	f406                	sd	ra,40(sp)
    8000337e:	f022                	sd	s0,32(sp)
    80003380:	ec26                	sd	s1,24(sp)
    80003382:	e84a                	sd	s2,16(sp)
    80003384:	e44e                	sd	s3,8(sp)
    80003386:	1800                	addi	s0,sp,48
    80003388:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000338a:	05050493          	addi	s1,a0,80
    8000338e:	08050913          	addi	s2,a0,128
    80003392:	a021                	j	8000339a <itrunc+0x20>
    80003394:	0491                	addi	s1,s1,4
    80003396:	01248b63          	beq	s1,s2,800033ac <itrunc+0x32>
    if (ip->addrs[i]) {
    8000339a:	408c                	lw	a1,0(s1)
    8000339c:	dde5                	beqz	a1,80003394 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000339e:	0009a503          	lw	a0,0(s3)
    800033a2:	a47ff0ef          	jal	80002de8 <bfree>
      ip->addrs[i] = 0;
    800033a6:	0004a023          	sw	zero,0(s1)
    800033aa:	b7ed                	j	80003394 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800033ac:	0809a583          	lw	a1,128(s3)
    800033b0:	ed89                	bnez	a1,800033ca <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800033b2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800033b6:	854e                	mv	a0,s3
    800033b8:	e21ff0ef          	jal	800031d8 <iupdate>
}
    800033bc:	70a2                	ld	ra,40(sp)
    800033be:	7402                	ld	s0,32(sp)
    800033c0:	64e2                	ld	s1,24(sp)
    800033c2:	6942                	ld	s2,16(sp)
    800033c4:	69a2                	ld	s3,8(sp)
    800033c6:	6145                	addi	sp,sp,48
    800033c8:	8082                	ret
    800033ca:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800033cc:	0009a503          	lw	a0,0(s3)
    800033d0:	825ff0ef          	jal	80002bf4 <bread>
    800033d4:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800033d6:	05850493          	addi	s1,a0,88
    800033da:	45850913          	addi	s2,a0,1112
    800033de:	a021                	j	800033e6 <itrunc+0x6c>
    800033e0:	0491                	addi	s1,s1,4
    800033e2:	01248963          	beq	s1,s2,800033f4 <itrunc+0x7a>
      if (a[j])
    800033e6:	408c                	lw	a1,0(s1)
    800033e8:	dde5                	beqz	a1,800033e0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800033ea:	0009a503          	lw	a0,0(s3)
    800033ee:	9fbff0ef          	jal	80002de8 <bfree>
    800033f2:	b7fd                	j	800033e0 <itrunc+0x66>
    brelse(bp);
    800033f4:	8552                	mv	a0,s4
    800033f6:	907ff0ef          	jal	80002cfc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033fa:	0809a583          	lw	a1,128(s3)
    800033fe:	0009a503          	lw	a0,0(s3)
    80003402:	9e7ff0ef          	jal	80002de8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003406:	0809a023          	sw	zero,128(s3)
    8000340a:	6a02                	ld	s4,0(sp)
    8000340c:	b75d                	j	800033b2 <itrunc+0x38>

000000008000340e <iput>:
{
    8000340e:	7179                	addi	sp,sp,-48
    80003410:	f406                	sd	ra,40(sp)
    80003412:	f022                	sd	s0,32(sp)
    80003414:	ec26                	sd	s1,24(sp)
    80003416:	1800                	addi	s0,sp,48
    80003418:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000341a:	0001e517          	auipc	a0,0x1e
    8000341e:	8ae50513          	addi	a0,a0,-1874 # 80020cc8 <itable>
    80003422:	fc6fd0ef          	jal	80000be8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003426:	449c                	lw	a5,8(s1)
    80003428:	4705                	li	a4,1
    8000342a:	00e78f63          	beq	a5,a4,80003448 <iput+0x3a>
  ip->ref--;
    8000342e:	37fd                	addiw	a5,a5,-1
    80003430:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003432:	0001e517          	auipc	a0,0x1e
    80003436:	89650513          	addi	a0,a0,-1898 # 80020cc8 <itable>
    8000343a:	837fd0ef          	jal	80000c70 <release>
}
    8000343e:	70a2                	ld	ra,40(sp)
    80003440:	7402                	ld	s0,32(sp)
    80003442:	64e2                	ld	s1,24(sp)
    80003444:	6145                	addi	sp,sp,48
    80003446:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003448:	40b8                	lw	a4,64(s1)
    8000344a:	d375                	beqz	a4,8000342e <iput+0x20>
    8000344c:	e84a                	sd	s2,16(sp)
    8000344e:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003450:	0004aa03          	lw	s4,0(s1)
    80003454:	0044a903          	lw	s2,4(s1)
  if (last) {
    80003458:	04a49703          	lh	a4,74(s1)
    8000345c:	ef3d                	bnez	a4,800034da <iput+0xcc>
    8000345e:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003460:	01048793          	addi	a5,s1,16
    80003464:	89be                	mv	s3,a5
    80003466:	853e                	mv	a0,a5
    80003468:	3ab000ef          	jal	80004012 <acquiresleep>
    release(&itable.lock);
    8000346c:	0001e517          	auipc	a0,0x1e
    80003470:	85c50513          	addi	a0,a0,-1956 # 80020cc8 <itable>
    80003474:	ffcfd0ef          	jal	80000c70 <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    80003478:	8526                	mv	a0,s1
    8000347a:	f01ff0ef          	jal	8000337a <itrunc>
    ip->valid = 0;
    8000347e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003482:	854e                	mv	a0,s3
    80003484:	3e3000ef          	jal	80004066 <releasesleep>
    acquire(&itable.lock);
    80003488:	0001e517          	auipc	a0,0x1e
    8000348c:	84050513          	addi	a0,a0,-1984 # 80020cc8 <itable>
    80003490:	f58fd0ef          	jal	80000be8 <acquire>
  ip->ref--;
    80003494:	449c                	lw	a5,8(s1)
    80003496:	37fd                	addiw	a5,a5,-1
    80003498:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000349a:	0001e517          	auipc	a0,0x1e
    8000349e:	82e50513          	addi	a0,a0,-2002 # 80020cc8 <itable>
    800034a2:	fcefd0ef          	jal	80000c70 <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034a6:	0049579b          	srliw	a5,s2,0x4
    800034aa:	0001e597          	auipc	a1,0x1e
    800034ae:	8165a583          	lw	a1,-2026(a1) # 80020cc0 <sb+0x18>
    800034b2:	9dbd                	addw	a1,a1,a5
    800034b4:	8552                	mv	a0,s4
    800034b6:	f3eff0ef          	jal	80002bf4 <bread>
    800034ba:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034bc:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    800034c0:	079a                	slli	a5,a5,0x6
    800034c2:	97aa                	add	a5,a5,a0
    800034c4:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    800034c8:	1dd000ef          	jal	80003ea4 <log_write>
  brelse(bp);
    800034cc:	8526                	mv	a0,s1
    800034ce:	82fff0ef          	jal	80002cfc <brelse>
}
    800034d2:	6942                	ld	s2,16(sp)
    800034d4:	69a2                	ld	s3,8(sp)
    800034d6:	6a02                	ld	s4,0(sp)
    800034d8:	b79d                	j	8000343e <iput+0x30>
    800034da:	6942                	ld	s2,16(sp)
    800034dc:	6a02                	ld	s4,0(sp)
    800034de:	bf81                	j	8000342e <iput+0x20>

00000000800034e0 <iunlockput>:
{
    800034e0:	1101                	addi	sp,sp,-32
    800034e2:	ec06                	sd	ra,24(sp)
    800034e4:	e822                	sd	s0,16(sp)
    800034e6:	e426                	sd	s1,8(sp)
    800034e8:	1000                	addi	s0,sp,32
    800034ea:	84aa                	mv	s1,a0
  iunlock(ip);
    800034ec:	e4fff0ef          	jal	8000333a <iunlock>
  iput(ip);
    800034f0:	8526                	mv	a0,s1
    800034f2:	f1dff0ef          	jal	8000340e <iput>
}
    800034f6:	60e2                	ld	ra,24(sp)
    800034f8:	6442                	ld	s0,16(sp)
    800034fa:	64a2                	ld	s1,8(sp)
    800034fc:	6105                	addi	sp,sp,32
    800034fe:	8082                	ret

0000000080003500 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003500:	0001d717          	auipc	a4,0x1d
    80003504:	7b472703          	lw	a4,1972(a4) # 80020cb4 <sb+0xc>
    80003508:	4785                	li	a5,1
    8000350a:	0ae7fe63          	bgeu	a5,a4,800035c6 <ireclaim+0xc6>
{
    8000350e:	7139                	addi	sp,sp,-64
    80003510:	fc06                	sd	ra,56(sp)
    80003512:	f822                	sd	s0,48(sp)
    80003514:	f426                	sd	s1,40(sp)
    80003516:	f04a                	sd	s2,32(sp)
    80003518:	ec4e                	sd	s3,24(sp)
    8000351a:	e852                	sd	s4,16(sp)
    8000351c:	e456                	sd	s5,8(sp)
    8000351e:	e05a                	sd	s6,0(sp)
    80003520:	0080                	addi	s0,sp,64
    80003522:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003524:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003526:	0001da17          	auipc	s4,0x1d
    8000352a:	782a0a13          	addi	s4,s4,1922 # 80020ca8 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    8000352e:	00004b17          	auipc	s6,0x4
    80003532:	01ab0b13          	addi	s6,s6,26 # 80007548 <etext+0x548>
    80003536:	a099                	j	8000357c <ireclaim+0x7c>
    80003538:	85ce                	mv	a1,s3
    8000353a:	855a                	mv	a0,s6
    8000353c:	fcffc0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    80003540:	85ce                	mv	a1,s3
    80003542:	8556                	mv	a0,s5
    80003544:	ad7ff0ef          	jal	8000301a <iget>
    80003548:	89aa                	mv	s3,a0
    brelse(bp);
    8000354a:	854a                	mv	a0,s2
    8000354c:	fb0ff0ef          	jal	80002cfc <brelse>
    if (ip) {
    80003550:	00098f63          	beqz	s3,8000356e <ireclaim+0x6e>
      begin_op();
    80003554:	7a2000ef          	jal	80003cf6 <begin_op>
      ilock(ip);
    80003558:	854e                	mv	a0,s3
    8000355a:	d33ff0ef          	jal	8000328c <ilock>
      iunlock(ip);
    8000355e:	854e                	mv	a0,s3
    80003560:	ddbff0ef          	jal	8000333a <iunlock>
      iput(ip);
    80003564:	854e                	mv	a0,s3
    80003566:	ea9ff0ef          	jal	8000340e <iput>
      end_op();
    8000356a:	019000ef          	jal	80003d82 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000356e:	0485                	addi	s1,s1,1
    80003570:	00ca2703          	lw	a4,12(s4)
    80003574:	0004879b          	sext.w	a5,s1
    80003578:	02e7fd63          	bgeu	a5,a4,800035b2 <ireclaim+0xb2>
    8000357c:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003580:	0044d593          	srli	a1,s1,0x4
    80003584:	018a2783          	lw	a5,24(s4)
    80003588:	9dbd                	addw	a1,a1,a5
    8000358a:	8556                	mv	a0,s5
    8000358c:	e68ff0ef          	jal	80002bf4 <bread>
    80003590:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003592:	05850793          	addi	a5,a0,88
    80003596:	00f9f713          	andi	a4,s3,15
    8000359a:	071a                	slli	a4,a4,0x6
    8000359c:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    8000359e:	00079703          	lh	a4,0(a5)
    800035a2:	c701                	beqz	a4,800035aa <ireclaim+0xaa>
    800035a4:	00679783          	lh	a5,6(a5)
    800035a8:	dbc1                	beqz	a5,80003538 <ireclaim+0x38>
    brelse(bp);
    800035aa:	854a                	mv	a0,s2
    800035ac:	f50ff0ef          	jal	80002cfc <brelse>
    if (ip) {
    800035b0:	bf7d                	j	8000356e <ireclaim+0x6e>
}
    800035b2:	70e2                	ld	ra,56(sp)
    800035b4:	7442                	ld	s0,48(sp)
    800035b6:	74a2                	ld	s1,40(sp)
    800035b8:	7902                	ld	s2,32(sp)
    800035ba:	69e2                	ld	s3,24(sp)
    800035bc:	6a42                	ld	s4,16(sp)
    800035be:	6aa2                	ld	s5,8(sp)
    800035c0:	6b02                	ld	s6,0(sp)
    800035c2:	6121                	addi	sp,sp,64
    800035c4:	8082                	ret
    800035c6:	8082                	ret

00000000800035c8 <fsinit>:
{
    800035c8:	1101                	addi	sp,sp,-32
    800035ca:	ec06                	sd	ra,24(sp)
    800035cc:	e822                	sd	s0,16(sp)
    800035ce:	e426                	sd	s1,8(sp)
    800035d0:	e04a                	sd	s2,0(sp)
    800035d2:	1000                	addi	s0,sp,32
    800035d4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035d6:	4585                	li	a1,1
    800035d8:	e1cff0ef          	jal	80002bf4 <bread>
    800035dc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035de:	02000613          	li	a2,32
    800035e2:	05850593          	addi	a1,a0,88
    800035e6:	0001d517          	auipc	a0,0x1d
    800035ea:	6c250513          	addi	a0,a0,1730 # 80020ca8 <sb>
    800035ee:	f1afd0ef          	jal	80000d08 <memmove>
  brelse(bp);
    800035f2:	8526                	mv	a0,s1
    800035f4:	f08ff0ef          	jal	80002cfc <brelse>
  if (sb.magic != FSMAGIC)
    800035f8:	0001d717          	auipc	a4,0x1d
    800035fc:	6b072703          	lw	a4,1712(a4) # 80020ca8 <sb>
    80003600:	102037b7          	lui	a5,0x10203
    80003604:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003608:	02f71263          	bne	a4,a5,8000362c <fsinit+0x64>
  initlog(dev, &sb);
    8000360c:	0001d597          	auipc	a1,0x1d
    80003610:	69c58593          	addi	a1,a1,1692 # 80020ca8 <sb>
    80003614:	854a                	mv	a0,s2
    80003616:	65e000ef          	jal	80003c74 <initlog>
  ireclaim(dev);
    8000361a:	854a                	mv	a0,s2
    8000361c:	ee5ff0ef          	jal	80003500 <ireclaim>
}
    80003620:	60e2                	ld	ra,24(sp)
    80003622:	6442                	ld	s0,16(sp)
    80003624:	64a2                	ld	s1,8(sp)
    80003626:	6902                	ld	s2,0(sp)
    80003628:	6105                	addi	sp,sp,32
    8000362a:	8082                	ret
    panic("invalid file system");
    8000362c:	00004517          	auipc	a0,0x4
    80003630:	f3c50513          	addi	a0,a0,-196 # 80007568 <etext+0x568>
    80003634:	a00fd0ef          	jal	80000834 <panic>

0000000080003638 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003638:	1141                	addi	sp,sp,-16
    8000363a:	e406                	sd	ra,8(sp)
    8000363c:	e022                	sd	s0,0(sp)
    8000363e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003640:	411c                	lw	a5,0(a0)
    80003642:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003644:	415c                	lw	a5,4(a0)
    80003646:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003648:	04451783          	lh	a5,68(a0)
    8000364c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003650:	04a51783          	lh	a5,74(a0)
    80003654:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003658:	04c56783          	lwu	a5,76(a0)
    8000365c:	e99c                	sd	a5,16(a1)
}
    8000365e:	60a2                	ld	ra,8(sp)
    80003660:	6402                	ld	s0,0(sp)
    80003662:	0141                	addi	sp,sp,16
    80003664:	8082                	ret

0000000080003666 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003666:	457c                	lw	a5,76(a0)
    80003668:	0ed7e663          	bltu	a5,a3,80003754 <readi+0xee>
{
    8000366c:	7159                	addi	sp,sp,-112
    8000366e:	f486                	sd	ra,104(sp)
    80003670:	f0a2                	sd	s0,96(sp)
    80003672:	eca6                	sd	s1,88(sp)
    80003674:	e0d2                	sd	s4,64(sp)
    80003676:	fc56                	sd	s5,56(sp)
    80003678:	f85a                	sd	s6,48(sp)
    8000367a:	f45e                	sd	s7,40(sp)
    8000367c:	1880                	addi	s0,sp,112
    8000367e:	8b2a                	mv	s6,a0
    80003680:	8bae                	mv	s7,a1
    80003682:	8a32                	mv	s4,a2
    80003684:	84b6                	mv	s1,a3
    80003686:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003688:	9f35                	addw	a4,a4,a3
    return 0;
    8000368a:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    8000368c:	0ad76b63          	bltu	a4,a3,80003742 <readi+0xdc>
    80003690:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003692:	00e7f463          	bgeu	a5,a4,8000369a <readi+0x34>
    n = ip->size - off;
    80003696:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000369a:	080a8b63          	beqz	s5,80003730 <readi+0xca>
    8000369e:	e8ca                	sd	s2,80(sp)
    800036a0:	f062                	sd	s8,32(sp)
    800036a2:	ec66                	sd	s9,24(sp)
    800036a4:	e86a                	sd	s10,16(sp)
    800036a6:	e46e                	sd	s11,8(sp)
    800036a8:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800036aa:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800036ae:	5c7d                	li	s8,-1
    800036b0:	a80d                	j	800036e2 <readi+0x7c>
    800036b2:	020d1d93          	slli	s11,s10,0x20
    800036b6:	020ddd93          	srli	s11,s11,0x20
    800036ba:	05890613          	addi	a2,s2,88
    800036be:	86ee                	mv	a3,s11
    800036c0:	963e                	add	a2,a2,a5
    800036c2:	85d2                	mv	a1,s4
    800036c4:	855e                	mv	a0,s7
    800036c6:	be7fe0ef          	jal	800022ac <either_copyout>
    800036ca:	05850363          	beq	a0,s8,80003710 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800036ce:	854a                	mv	a0,s2
    800036d0:	e2cff0ef          	jal	80002cfc <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800036d4:	013d09bb          	addw	s3,s10,s3
    800036d8:	009d04bb          	addw	s1,s10,s1
    800036dc:	9a6e                	add	s4,s4,s11
    800036de:	0559f363          	bgeu	s3,s5,80003724 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    800036e2:	00a4d59b          	srliw	a1,s1,0xa
    800036e6:	855a                	mv	a0,s6
    800036e8:	873ff0ef          	jal	80002f5a <bmap>
    800036ec:	85aa                	mv	a1,a0
    if (addr == 0)
    800036ee:	c139                	beqz	a0,80003734 <readi+0xce>
    bp = bread(ip->dev, addr);
    800036f0:	000b2503          	lw	a0,0(s6)
    800036f4:	d00ff0ef          	jal	80002bf4 <bread>
    800036f8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800036fa:	3ff4f793          	andi	a5,s1,1023
    800036fe:	40fc873b          	subw	a4,s9,a5
    80003702:	413a86bb          	subw	a3,s5,s3
    80003706:	8d3a                	mv	s10,a4
    80003708:	fae6f5e3          	bgeu	a3,a4,800036b2 <readi+0x4c>
    8000370c:	8d36                	mv	s10,a3
    8000370e:	b755                	j	800036b2 <readi+0x4c>
      brelse(bp);
    80003710:	854a                	mv	a0,s2
    80003712:	deaff0ef          	jal	80002cfc <brelse>
      tot = -1;
    80003716:	59fd                	li	s3,-1
      break;
    80003718:	6946                	ld	s2,80(sp)
    8000371a:	7c02                	ld	s8,32(sp)
    8000371c:	6ce2                	ld	s9,24(sp)
    8000371e:	6d42                	ld	s10,16(sp)
    80003720:	6da2                	ld	s11,8(sp)
    80003722:	a831                	j	8000373e <readi+0xd8>
    80003724:	6946                	ld	s2,80(sp)
    80003726:	7c02                	ld	s8,32(sp)
    80003728:	6ce2                	ld	s9,24(sp)
    8000372a:	6d42                	ld	s10,16(sp)
    8000372c:	6da2                	ld	s11,8(sp)
    8000372e:	a801                	j	8000373e <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003730:	89d6                	mv	s3,s5
    80003732:	a031                	j	8000373e <readi+0xd8>
    80003734:	6946                	ld	s2,80(sp)
    80003736:	7c02                	ld	s8,32(sp)
    80003738:	6ce2                	ld	s9,24(sp)
    8000373a:	6d42                	ld	s10,16(sp)
    8000373c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000373e:	854e                	mv	a0,s3
    80003740:	69a6                	ld	s3,72(sp)
}
    80003742:	70a6                	ld	ra,104(sp)
    80003744:	7406                	ld	s0,96(sp)
    80003746:	64e6                	ld	s1,88(sp)
    80003748:	6a06                	ld	s4,64(sp)
    8000374a:	7ae2                	ld	s5,56(sp)
    8000374c:	7b42                	ld	s6,48(sp)
    8000374e:	7ba2                	ld	s7,40(sp)
    80003750:	6165                	addi	sp,sp,112
    80003752:	8082                	ret
    return 0;
    80003754:	4501                	li	a0,0
}
    80003756:	8082                	ret

0000000080003758 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003758:	457c                	lw	a5,76(a0)
    8000375a:	0ed7ee63          	bltu	a5,a3,80003856 <writei+0xfe>
{
    8000375e:	7159                	addi	sp,sp,-112
    80003760:	f486                	sd	ra,104(sp)
    80003762:	f0a2                	sd	s0,96(sp)
    80003764:	e8ca                	sd	s2,80(sp)
    80003766:	e0d2                	sd	s4,64(sp)
    80003768:	fc56                	sd	s5,56(sp)
    8000376a:	f85a                	sd	s6,48(sp)
    8000376c:	f45e                	sd	s7,40(sp)
    8000376e:	1880                	addi	s0,sp,112
    80003770:	8aaa                	mv	s5,a0
    80003772:	8bae                	mv	s7,a1
    80003774:	8a32                	mv	s4,a2
    80003776:	8936                	mv	s2,a3
    80003778:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000377a:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000377e:	00043737          	lui	a4,0x43
    80003782:	0cf76c63          	bltu	a4,a5,8000385a <writei+0x102>
    80003786:	0cd7ea63          	bltu	a5,a3,8000385a <writei+0x102>
    8000378a:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000378c:	0a0b0d63          	beqz	s6,80003846 <writei+0xee>
    80003790:	eca6                	sd	s1,88(sp)
    80003792:	f062                	sd	s8,32(sp)
    80003794:	ec66                	sd	s9,24(sp)
    80003796:	e86a                	sd	s10,16(sp)
    80003798:	e46e                	sd	s11,8(sp)
    8000379a:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000379c:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800037a0:	5c7d                	li	s8,-1
    800037a2:	a825                	j	800037da <writei+0x82>
    800037a4:	020d1d93          	slli	s11,s10,0x20
    800037a8:	020ddd93          	srli	s11,s11,0x20
    800037ac:	05848513          	addi	a0,s1,88
    800037b0:	86ee                	mv	a3,s11
    800037b2:	8652                	mv	a2,s4
    800037b4:	85de                	mv	a1,s7
    800037b6:	953e                	add	a0,a0,a5
    800037b8:	b41fe0ef          	jal	800022f8 <either_copyin>
    800037bc:	05850663          	beq	a0,s8,80003808 <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    800037c0:	8526                	mv	a0,s1
    800037c2:	6e2000ef          	jal	80003ea4 <log_write>
    brelse(bp);
    800037c6:	8526                	mv	a0,s1
    800037c8:	d34ff0ef          	jal	80002cfc <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037cc:	013d09bb          	addw	s3,s10,s3
    800037d0:	012d093b          	addw	s2,s10,s2
    800037d4:	9a6e                	add	s4,s4,s11
    800037d6:	0369ff63          	bgeu	s3,s6,80003814 <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    800037da:	00a9559b          	srliw	a1,s2,0xa
    800037de:	8556                	mv	a0,s5
    800037e0:	f7aff0ef          	jal	80002f5a <bmap>
    800037e4:	85aa                	mv	a1,a0
    if (addr == 0)
    800037e6:	c51d                	beqz	a0,80003814 <writei+0xbc>
    bp = bread(ip->dev, addr);
    800037e8:	000aa503          	lw	a0,0(s5)
    800037ec:	c08ff0ef          	jal	80002bf4 <bread>
    800037f0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800037f2:	3ff97793          	andi	a5,s2,1023
    800037f6:	40fc873b          	subw	a4,s9,a5
    800037fa:	413b06bb          	subw	a3,s6,s3
    800037fe:	8d3a                	mv	s10,a4
    80003800:	fae6f2e3          	bgeu	a3,a4,800037a4 <writei+0x4c>
    80003804:	8d36                	mv	s10,a3
    80003806:	bf79                	j	800037a4 <writei+0x4c>
      log_write(bp);
    80003808:	8526                	mv	a0,s1
    8000380a:	69a000ef          	jal	80003ea4 <log_write>
      brelse(bp);
    8000380e:	8526                	mv	a0,s1
    80003810:	cecff0ef          	jal	80002cfc <brelse>
  }

  if (off > ip->size)
    80003814:	04caa783          	lw	a5,76(s5)
    80003818:	0327f963          	bgeu	a5,s2,8000384a <writei+0xf2>
    ip->size = off;
    8000381c:	052aa623          	sw	s2,76(s5)
    80003820:	64e6                	ld	s1,88(sp)
    80003822:	7c02                	ld	s8,32(sp)
    80003824:	6ce2                	ld	s9,24(sp)
    80003826:	6d42                	ld	s10,16(sp)
    80003828:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000382a:	8556                	mv	a0,s5
    8000382c:	9adff0ef          	jal	800031d8 <iupdate>

  return tot;
    80003830:	854e                	mv	a0,s3
    80003832:	69a6                	ld	s3,72(sp)
}
    80003834:	70a6                	ld	ra,104(sp)
    80003836:	7406                	ld	s0,96(sp)
    80003838:	6946                	ld	s2,80(sp)
    8000383a:	6a06                	ld	s4,64(sp)
    8000383c:	7ae2                	ld	s5,56(sp)
    8000383e:	7b42                	ld	s6,48(sp)
    80003840:	7ba2                	ld	s7,40(sp)
    80003842:	6165                	addi	sp,sp,112
    80003844:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003846:	89da                	mv	s3,s6
    80003848:	b7cd                	j	8000382a <writei+0xd2>
    8000384a:	64e6                	ld	s1,88(sp)
    8000384c:	7c02                	ld	s8,32(sp)
    8000384e:	6ce2                	ld	s9,24(sp)
    80003850:	6d42                	ld	s10,16(sp)
    80003852:	6da2                	ld	s11,8(sp)
    80003854:	bfd9                	j	8000382a <writei+0xd2>
    return -1;
    80003856:	557d                	li	a0,-1
}
    80003858:	8082                	ret
    return -1;
    8000385a:	557d                	li	a0,-1
    8000385c:	bfe1                	j	80003834 <writei+0xdc>

000000008000385e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000385e:	1141                	addi	sp,sp,-16
    80003860:	e406                	sd	ra,8(sp)
    80003862:	e022                	sd	s0,0(sp)
    80003864:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003866:	4639                	li	a2,14
    80003868:	d14fd0ef          	jal	80000d7c <strncmp>
}
    8000386c:	60a2                	ld	ra,8(sp)
    8000386e:	6402                	ld	s0,0(sp)
    80003870:	0141                	addi	sp,sp,16
    80003872:	8082                	ret

0000000080003874 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003874:	711d                	addi	sp,sp,-96
    80003876:	ec86                	sd	ra,88(sp)
    80003878:	e8a2                	sd	s0,80(sp)
    8000387a:	e4a6                	sd	s1,72(sp)
    8000387c:	e0ca                	sd	s2,64(sp)
    8000387e:	fc4e                	sd	s3,56(sp)
    80003880:	f852                	sd	s4,48(sp)
    80003882:	f456                	sd	s5,40(sp)
    80003884:	f05a                	sd	s6,32(sp)
    80003886:	ec5e                	sd	s7,24(sp)
    80003888:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    8000388a:	04451703          	lh	a4,68(a0)
    8000388e:	4785                	li	a5,1
    80003890:	00f71f63          	bne	a4,a5,800038ae <dirlookup+0x3a>
    80003894:	892a                	mv	s2,a0
    80003896:	8aae                	mv	s5,a1
    80003898:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000389a:	457c                	lw	a5,76(a0)
    8000389c:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000389e:	fa040a13          	addi	s4,s0,-96
    800038a2:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    800038a4:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800038a8:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800038aa:	e39d                	bnez	a5,800038d0 <dirlookup+0x5c>
    800038ac:	a8b9                	j	8000390a <dirlookup+0x96>
    panic("dirlookup not DIR");
    800038ae:	00004517          	auipc	a0,0x4
    800038b2:	cd250513          	addi	a0,a0,-814 # 80007580 <etext+0x580>
    800038b6:	f7ffc0ef          	jal	80000834 <panic>
      panic("dirlookup read");
    800038ba:	00004517          	auipc	a0,0x4
    800038be:	cde50513          	addi	a0,a0,-802 # 80007598 <etext+0x598>
    800038c2:	f73fc0ef          	jal	80000834 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800038c6:	24c1                	addiw	s1,s1,16
    800038c8:	04c92783          	lw	a5,76(s2)
    800038cc:	02f4fe63          	bgeu	s1,a5,80003908 <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800038d0:	874e                	mv	a4,s3
    800038d2:	86a6                	mv	a3,s1
    800038d4:	8652                	mv	a2,s4
    800038d6:	4581                	li	a1,0
    800038d8:	854a                	mv	a0,s2
    800038da:	d8dff0ef          	jal	80003666 <readi>
    800038de:	fd351ee3          	bne	a0,s3,800038ba <dirlookup+0x46>
    if (de.inum == 0)
    800038e2:	fa045783          	lhu	a5,-96(s0)
    800038e6:	d3e5                	beqz	a5,800038c6 <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    800038e8:	85da                	mv	a1,s6
    800038ea:	8556                	mv	a0,s5
    800038ec:	f73ff0ef          	jal	8000385e <namecmp>
    800038f0:	f979                	bnez	a0,800038c6 <dirlookup+0x52>
      if (poff)
    800038f2:	000b8463          	beqz	s7,800038fa <dirlookup+0x86>
        *poff = off;
    800038f6:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800038fa:	fa045583          	lhu	a1,-96(s0)
    800038fe:	00092503          	lw	a0,0(s2)
    80003902:	f18ff0ef          	jal	8000301a <iget>
    80003906:	a011                	j	8000390a <dirlookup+0x96>
  return 0;
    80003908:	4501                	li	a0,0
}
    8000390a:	60e6                	ld	ra,88(sp)
    8000390c:	6446                	ld	s0,80(sp)
    8000390e:	64a6                	ld	s1,72(sp)
    80003910:	6906                	ld	s2,64(sp)
    80003912:	79e2                	ld	s3,56(sp)
    80003914:	7a42                	ld	s4,48(sp)
    80003916:	7aa2                	ld	s5,40(sp)
    80003918:	7b02                	ld	s6,32(sp)
    8000391a:	6be2                	ld	s7,24(sp)
    8000391c:	6125                	addi	sp,sp,96
    8000391e:	8082                	ret

0000000080003920 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003920:	711d                	addi	sp,sp,-96
    80003922:	ec86                	sd	ra,88(sp)
    80003924:	e8a2                	sd	s0,80(sp)
    80003926:	e4a6                	sd	s1,72(sp)
    80003928:	e0ca                	sd	s2,64(sp)
    8000392a:	fc4e                	sd	s3,56(sp)
    8000392c:	f852                	sd	s4,48(sp)
    8000392e:	f456                	sd	s5,40(sp)
    80003930:	f05a                	sd	s6,32(sp)
    80003932:	ec5e                	sd	s7,24(sp)
    80003934:	e862                	sd	s8,16(sp)
    80003936:	e466                	sd	s9,8(sp)
    80003938:	e06a                	sd	s10,0(sp)
    8000393a:	1080                	addi	s0,sp,96
    8000393c:	84aa                	mv	s1,a0
    8000393e:	8b2e                	mv	s6,a1
    80003940:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003942:	00054703          	lbu	a4,0(a0)
    80003946:	02f00793          	li	a5,47
    8000394a:	00f70f63          	beq	a4,a5,80003968 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000394e:	fbbfd0ef          	jal	80001908 <myproc>
    80003952:	15053503          	ld	a0,336(a0)
    80003956:	901ff0ef          	jal	80003256 <idup>
    8000395a:	8a2a                	mv	s4,a0
  while (*path == '/')
    8000395c:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003960:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003962:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003964:	4b85                	li	s7,1
    80003966:	a07d                	j	80003a14 <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    80003968:	4585                	li	a1,1
    8000396a:	852e                	mv	a0,a1
    8000396c:	eaeff0ef          	jal	8000301a <iget>
    80003970:	8a2a                	mv	s4,a0
    80003972:	b7ed                	j	8000395c <namex+0x3c>
      iunlockput(ip);
    80003974:	8552                	mv	a0,s4
    80003976:	b6bff0ef          	jal	800034e0 <iunlockput>
      return 0;
    8000397a:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000397c:	8552                	mv	a0,s4
    8000397e:	60e6                	ld	ra,88(sp)
    80003980:	6446                	ld	s0,80(sp)
    80003982:	64a6                	ld	s1,72(sp)
    80003984:	6906                	ld	s2,64(sp)
    80003986:	79e2                	ld	s3,56(sp)
    80003988:	7a42                	ld	s4,48(sp)
    8000398a:	7aa2                	ld	s5,40(sp)
    8000398c:	7b02                	ld	s6,32(sp)
    8000398e:	6be2                	ld	s7,24(sp)
    80003990:	6c42                	ld	s8,16(sp)
    80003992:	6ca2                	ld	s9,8(sp)
    80003994:	6d02                	ld	s10,0(sp)
    80003996:	6125                	addi	sp,sp,96
    80003998:	8082                	ret
      iunlockput(ip);
    8000399a:	8552                	mv	a0,s4
    8000399c:	b45ff0ef          	jal	800034e0 <iunlockput>
      return 0;
    800039a0:	4a01                	li	s4,0
    800039a2:	bfe9                	j	8000397c <namex+0x5c>
      iunlock(ip);
    800039a4:	8552                	mv	a0,s4
    800039a6:	995ff0ef          	jal	8000333a <iunlock>
      return ip;
    800039aa:	bfc9                	j	8000397c <namex+0x5c>
      iunlockput(ip);
    800039ac:	8552                	mv	a0,s4
    800039ae:	b33ff0ef          	jal	800034e0 <iunlockput>
      return 0;
    800039b2:	8a4a                	mv	s4,s2
    800039b4:	b7e1                	j	8000397c <namex+0x5c>
  len = path - s;
    800039b6:	40990633          	sub	a2,s2,s1
    800039ba:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    800039be:	09ac5763          	bge	s8,s10,80003a4c <namex+0x12c>
    memmove(name, s, DIRSIZ);
    800039c2:	8666                	mv	a2,s9
    800039c4:	85a6                	mv	a1,s1
    800039c6:	8556                	mv	a0,s5
    800039c8:	b40fd0ef          	jal	80000d08 <memmove>
    800039cc:	84ca                	mv	s1,s2
  while (*path == '/')
    800039ce:	0004c783          	lbu	a5,0(s1)
    800039d2:	01379763          	bne	a5,s3,800039e0 <namex+0xc0>
    path++;
    800039d6:	0485                	addi	s1,s1,1
  while (*path == '/')
    800039d8:	0004c783          	lbu	a5,0(s1)
    800039dc:	ff378de3          	beq	a5,s3,800039d6 <namex+0xb6>
    ilock(ip);
    800039e0:	8552                	mv	a0,s4
    800039e2:	8abff0ef          	jal	8000328c <ilock>
    if (ip->type != T_DIR) {
    800039e6:	044a1783          	lh	a5,68(s4)
    800039ea:	f97795e3          	bne	a5,s7,80003974 <namex+0x54>
    if (ip->nlink == 0) {
    800039ee:	04aa1783          	lh	a5,74(s4)
    800039f2:	d7c5                	beqz	a5,8000399a <namex+0x7a>
    if (nameiparent && *path == '\0') {
    800039f4:	000b0563          	beqz	s6,800039fe <namex+0xde>
    800039f8:	0004c783          	lbu	a5,0(s1)
    800039fc:	d7c5                	beqz	a5,800039a4 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800039fe:	4601                	li	a2,0
    80003a00:	85d6                	mv	a1,s5
    80003a02:	8552                	mv	a0,s4
    80003a04:	e71ff0ef          	jal	80003874 <dirlookup>
    80003a08:	892a                	mv	s2,a0
    80003a0a:	d14d                	beqz	a0,800039ac <namex+0x8c>
    iunlockput(ip);
    80003a0c:	8552                	mv	a0,s4
    80003a0e:	ad3ff0ef          	jal	800034e0 <iunlockput>
    ip = next;
    80003a12:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003a14:	0004c783          	lbu	a5,0(s1)
    80003a18:	01379763          	bne	a5,s3,80003a26 <namex+0x106>
    path++;
    80003a1c:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003a1e:	0004c783          	lbu	a5,0(s1)
    80003a22:	ff378de3          	beq	a5,s3,80003a1c <namex+0xfc>
  if (*path == 0)
    80003a26:	cf8d                	beqz	a5,80003a60 <namex+0x140>
  while (*path != '/' && *path != 0)
    80003a28:	0004c783          	lbu	a5,0(s1)
    80003a2c:	fd178713          	addi	a4,a5,-47
    80003a30:	cb19                	beqz	a4,80003a46 <namex+0x126>
    80003a32:	cb91                	beqz	a5,80003a46 <namex+0x126>
    80003a34:	8926                	mv	s2,s1
    path++;
    80003a36:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003a38:	00094783          	lbu	a5,0(s2)
    80003a3c:	fd178713          	addi	a4,a5,-47
    80003a40:	db3d                	beqz	a4,800039b6 <namex+0x96>
    80003a42:	fbf5                	bnez	a5,80003a36 <namex+0x116>
    80003a44:	bf8d                	j	800039b6 <namex+0x96>
    80003a46:	8926                	mv	s2,s1
  len = path - s;
    80003a48:	4d01                	li	s10,0
    80003a4a:	4601                	li	a2,0
    memmove(name, s, len);
    80003a4c:	2601                	sext.w	a2,a2
    80003a4e:	85a6                	mv	a1,s1
    80003a50:	8556                	mv	a0,s5
    80003a52:	ab6fd0ef          	jal	80000d08 <memmove>
    name[len] = 0;
    80003a56:	9d56                	add	s10,s10,s5
    80003a58:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdb650>
    80003a5c:	84ca                	mv	s1,s2
    80003a5e:	bf85                	j	800039ce <namex+0xae>
  if (nameiparent) {
    80003a60:	f00b0ee3          	beqz	s6,8000397c <namex+0x5c>
    iput(ip);
    80003a64:	8552                	mv	a0,s4
    80003a66:	9a9ff0ef          	jal	8000340e <iput>
    return 0;
    80003a6a:	4a01                	li	s4,0
    80003a6c:	bf01                	j	8000397c <namex+0x5c>

0000000080003a6e <dirlink>:
{
    80003a6e:	715d                	addi	sp,sp,-80
    80003a70:	e486                	sd	ra,72(sp)
    80003a72:	e0a2                	sd	s0,64(sp)
    80003a74:	f84a                	sd	s2,48(sp)
    80003a76:	ec56                	sd	s5,24(sp)
    80003a78:	e85a                	sd	s6,16(sp)
    80003a7a:	0880                	addi	s0,sp,80
    80003a7c:	892a                	mv	s2,a0
    80003a7e:	8aae                	mv	s5,a1
    80003a80:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003a82:	4601                	li	a2,0
    80003a84:	df1ff0ef          	jal	80003874 <dirlookup>
    80003a88:	ed1d                	bnez	a0,80003ac6 <dirlink+0x58>
    80003a8a:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a8c:	04c92483          	lw	s1,76(s2)
    80003a90:	c4b9                	beqz	s1,80003ade <dirlink+0x70>
    80003a92:	f44e                	sd	s3,40(sp)
    80003a94:	f052                	sd	s4,32(sp)
    80003a96:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a98:	fb040a13          	addi	s4,s0,-80
    80003a9c:	49c1                	li	s3,16
    80003a9e:	874e                	mv	a4,s3
    80003aa0:	86a6                	mv	a3,s1
    80003aa2:	8652                	mv	a2,s4
    80003aa4:	4581                	li	a1,0
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	bbfff0ef          	jal	80003666 <readi>
    80003aac:	03351163          	bne	a0,s3,80003ace <dirlink+0x60>
    if (de.inum == 0)
    80003ab0:	fb045783          	lhu	a5,-80(s0)
    80003ab4:	c39d                	beqz	a5,80003ada <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003ab6:	24c1                	addiw	s1,s1,16
    80003ab8:	04c92783          	lw	a5,76(s2)
    80003abc:	fef4e1e3          	bltu	s1,a5,80003a9e <dirlink+0x30>
    80003ac0:	79a2                	ld	s3,40(sp)
    80003ac2:	7a02                	ld	s4,32(sp)
    80003ac4:	a829                	j	80003ade <dirlink+0x70>
    iput(ip);
    80003ac6:	949ff0ef          	jal	8000340e <iput>
    return -1;
    80003aca:	557d                	li	a0,-1
    80003acc:	a83d                	j	80003b0a <dirlink+0x9c>
      panic("dirlink read");
    80003ace:	00004517          	auipc	a0,0x4
    80003ad2:	ada50513          	addi	a0,a0,-1318 # 800075a8 <etext+0x5a8>
    80003ad6:	d5ffc0ef          	jal	80000834 <panic>
    80003ada:	79a2                	ld	s3,40(sp)
    80003adc:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003ade:	4639                	li	a2,14
    80003ae0:	85d6                	mv	a1,s5
    80003ae2:	fb240513          	addi	a0,s0,-78
    80003ae6:	ad0fd0ef          	jal	80000db6 <strncpy>
  de.inum = inum;
    80003aea:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003aee:	4741                	li	a4,16
    80003af0:	86a6                	mv	a3,s1
    80003af2:	fb040613          	addi	a2,s0,-80
    80003af6:	4581                	li	a1,0
    80003af8:	854a                	mv	a0,s2
    80003afa:	c5fff0ef          	jal	80003758 <writei>
    80003afe:	1541                	addi	a0,a0,-16
    80003b00:	00a03533          	snez	a0,a0
    80003b04:	40a0053b          	negw	a0,a0
    80003b08:	74e2                	ld	s1,56(sp)
}
    80003b0a:	60a6                	ld	ra,72(sp)
    80003b0c:	6406                	ld	s0,64(sp)
    80003b0e:	7942                	ld	s2,48(sp)
    80003b10:	6ae2                	ld	s5,24(sp)
    80003b12:	6b42                	ld	s6,16(sp)
    80003b14:	6161                	addi	sp,sp,80
    80003b16:	8082                	ret

0000000080003b18 <namei>:

struct inode *
namei(char *path)
{
    80003b18:	1101                	addi	sp,sp,-32
    80003b1a:	ec06                	sd	ra,24(sp)
    80003b1c:	e822                	sd	s0,16(sp)
    80003b1e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003b20:	fe040613          	addi	a2,s0,-32
    80003b24:	4581                	li	a1,0
    80003b26:	dfbff0ef          	jal	80003920 <namex>
}
    80003b2a:	60e2                	ld	ra,24(sp)
    80003b2c:	6442                	ld	s0,16(sp)
    80003b2e:	6105                	addi	sp,sp,32
    80003b30:	8082                	ret

0000000080003b32 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003b32:	1141                	addi	sp,sp,-16
    80003b34:	e406                	sd	ra,8(sp)
    80003b36:	e022                	sd	s0,0(sp)
    80003b38:	0800                	addi	s0,sp,16
    80003b3a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003b3c:	4585                	li	a1,1
    80003b3e:	de3ff0ef          	jal	80003920 <namex>
}
    80003b42:	60a2                	ld	ra,8(sp)
    80003b44:	6402                	ld	s0,0(sp)
    80003b46:	0141                	addi	sp,sp,16
    80003b48:	8082                	ret

0000000080003b4a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003b4a:	1101                	addi	sp,sp,-32
    80003b4c:	ec06                	sd	ra,24(sp)
    80003b4e:	e822                	sd	s0,16(sp)
    80003b50:	e426                	sd	s1,8(sp)
    80003b52:	e04a                	sd	s2,0(sp)
    80003b54:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b56:	0001f917          	auipc	s2,0x1f
    80003b5a:	c1a90913          	addi	s2,s2,-998 # 80022770 <log>
    80003b5e:	01892583          	lw	a1,24(s2)
    80003b62:	02492503          	lw	a0,36(s2)
    80003b66:	88eff0ef          	jal	80002bf4 <bread>
    80003b6a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003b6c:	02c92603          	lw	a2,44(s2)
    80003b70:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b72:	00c05f63          	blez	a2,80003b90 <write_head+0x46>
    80003b76:	0001f717          	auipc	a4,0x1f
    80003b7a:	c2a70713          	addi	a4,a4,-982 # 800227a0 <log+0x30>
    80003b7e:	87aa                	mv	a5,a0
    80003b80:	060a                	slli	a2,a2,0x2
    80003b82:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b84:	4314                	lw	a3,0(a4)
    80003b86:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b88:	0711                	addi	a4,a4,4
    80003b8a:	0791                	addi	a5,a5,4
    80003b8c:	fec79ce3          	bne	a5,a2,80003b84 <write_head+0x3a>
  }
  bwrite(buf);
    80003b90:	8526                	mv	a0,s1
    80003b92:	938ff0ef          	jal	80002cca <bwrite>
  brelse(buf);
    80003b96:	8526                	mv	a0,s1
    80003b98:	964ff0ef          	jal	80002cfc <brelse>
}
    80003b9c:	60e2                	ld	ra,24(sp)
    80003b9e:	6442                	ld	s0,16(sp)
    80003ba0:	64a2                	ld	s1,8(sp)
    80003ba2:	6902                	ld	s2,0(sp)
    80003ba4:	6105                	addi	sp,sp,32
    80003ba6:	8082                	ret

0000000080003ba8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ba8:	0001f797          	auipc	a5,0x1f
    80003bac:	bf47a783          	lw	a5,-1036(a5) # 8002279c <log+0x2c>
    80003bb0:	0cf05163          	blez	a5,80003c72 <install_trans+0xca>
{
    80003bb4:	715d                	addi	sp,sp,-80
    80003bb6:	e486                	sd	ra,72(sp)
    80003bb8:	e0a2                	sd	s0,64(sp)
    80003bba:	fc26                	sd	s1,56(sp)
    80003bbc:	f84a                	sd	s2,48(sp)
    80003bbe:	f44e                	sd	s3,40(sp)
    80003bc0:	f052                	sd	s4,32(sp)
    80003bc2:	ec56                	sd	s5,24(sp)
    80003bc4:	e85a                	sd	s6,16(sp)
    80003bc6:	e45e                	sd	s7,8(sp)
    80003bc8:	e062                	sd	s8,0(sp)
    80003bca:	0880                	addi	s0,sp,80
    80003bcc:	8b2a                	mv	s6,a0
    80003bce:	0001fa97          	auipc	s5,0x1f
    80003bd2:	bd2a8a93          	addi	s5,s5,-1070 # 800227a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bd6:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003bd8:	00004c17          	auipc	s8,0x4
    80003bdc:	9e0c0c13          	addi	s8,s8,-1568 # 800075b8 <etext+0x5b8>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003be0:	0001fa17          	auipc	s4,0x1f
    80003be4:	b90a0a13          	addi	s4,s4,-1136 # 80022770 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003be8:	40000b93          	li	s7,1024
    80003bec:	a025                	j	80003c14 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003bee:	000aa603          	lw	a2,0(s5)
    80003bf2:	85ce                	mv	a1,s3
    80003bf4:	8562                	mv	a0,s8
    80003bf6:	915fc0ef          	jal	8000050a <printk>
    80003bfa:	a839                	j	80003c18 <install_trans+0x70>
    brelse(lbuf);
    80003bfc:	854a                	mv	a0,s2
    80003bfe:	8feff0ef          	jal	80002cfc <brelse>
    brelse(dbuf);
    80003c02:	8526                	mv	a0,s1
    80003c04:	8f8ff0ef          	jal	80002cfc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c08:	2985                	addiw	s3,s3,1
    80003c0a:	0a91                	addi	s5,s5,4
    80003c0c:	02ca2783          	lw	a5,44(s4)
    80003c10:	04f9d563          	bge	s3,a5,80003c5a <install_trans+0xb2>
    if (recovering) {
    80003c14:	fc0b1de3          	bnez	s6,80003bee <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003c18:	018a2583          	lw	a1,24(s4)
    80003c1c:	013585bb          	addw	a1,a1,s3
    80003c20:	2585                	addiw	a1,a1,1
    80003c22:	024a2503          	lw	a0,36(s4)
    80003c26:	fcffe0ef          	jal	80002bf4 <bread>
    80003c2a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003c2c:	000aa583          	lw	a1,0(s5)
    80003c30:	024a2503          	lw	a0,36(s4)
    80003c34:	fc1fe0ef          	jal	80002bf4 <bread>
    80003c38:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003c3a:	865e                	mv	a2,s7
    80003c3c:	05890593          	addi	a1,s2,88
    80003c40:	05850513          	addi	a0,a0,88
    80003c44:	8c4fd0ef          	jal	80000d08 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003c48:	8526                	mv	a0,s1
    80003c4a:	880ff0ef          	jal	80002cca <bwrite>
    if (recovering == 0)
    80003c4e:	fa0b17e3          	bnez	s6,80003bfc <install_trans+0x54>
      bunpin(dbuf);
    80003c52:	8526                	mv	a0,s1
    80003c54:	960ff0ef          	jal	80002db4 <bunpin>
    80003c58:	b755                	j	80003bfc <install_trans+0x54>
}
    80003c5a:	60a6                	ld	ra,72(sp)
    80003c5c:	6406                	ld	s0,64(sp)
    80003c5e:	74e2                	ld	s1,56(sp)
    80003c60:	7942                	ld	s2,48(sp)
    80003c62:	79a2                	ld	s3,40(sp)
    80003c64:	7a02                	ld	s4,32(sp)
    80003c66:	6ae2                	ld	s5,24(sp)
    80003c68:	6b42                	ld	s6,16(sp)
    80003c6a:	6ba2                	ld	s7,8(sp)
    80003c6c:	6c02                	ld	s8,0(sp)
    80003c6e:	6161                	addi	sp,sp,80
    80003c70:	8082                	ret
    80003c72:	8082                	ret

0000000080003c74 <initlog>:
{
    80003c74:	7179                	addi	sp,sp,-48
    80003c76:	f406                	sd	ra,40(sp)
    80003c78:	f022                	sd	s0,32(sp)
    80003c7a:	ec26                	sd	s1,24(sp)
    80003c7c:	e84a                	sd	s2,16(sp)
    80003c7e:	e44e                	sd	s3,8(sp)
    80003c80:	1800                	addi	s0,sp,48
    80003c82:	84aa                	mv	s1,a0
    80003c84:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c86:	0001f917          	auipc	s2,0x1f
    80003c8a:	aea90913          	addi	s2,s2,-1302 # 80022770 <log>
    80003c8e:	00004597          	auipc	a1,0x4
    80003c92:	94a58593          	addi	a1,a1,-1718 # 800075d8 <etext+0x5d8>
    80003c96:	854a                	mv	a0,s2
    80003c98:	ed1fc0ef          	jal	80000b68 <initlock>
  log.start = sb->logstart;
    80003c9c:	0149a583          	lw	a1,20(s3)
    80003ca0:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003ca4:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	f4bfe0ef          	jal	80002bf4 <bread>
  log.lh.n = lh->n;
    80003cae:	4d30                	lw	a2,88(a0)
    80003cb0:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003cb4:	00c05f63          	blez	a2,80003cd2 <initlog+0x5e>
    80003cb8:	87aa                	mv	a5,a0
    80003cba:	0001f717          	auipc	a4,0x1f
    80003cbe:	ae670713          	addi	a4,a4,-1306 # 800227a0 <log+0x30>
    80003cc2:	060a                	slli	a2,a2,0x2
    80003cc4:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003cc6:	4ff4                	lw	a3,92(a5)
    80003cc8:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003cca:	0791                	addi	a5,a5,4
    80003ccc:	0711                	addi	a4,a4,4
    80003cce:	fec79ce3          	bne	a5,a2,80003cc6 <initlog+0x52>
  brelse(buf);
    80003cd2:	82aff0ef          	jal	80002cfc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003cd6:	4505                	li	a0,1
    80003cd8:	ed1ff0ef          	jal	80003ba8 <install_trans>
  log.lh.n = 0;
    80003cdc:	0001f797          	auipc	a5,0x1f
    80003ce0:	ac07a023          	sw	zero,-1344(a5) # 8002279c <log+0x2c>
  write_head(); // clear the log
    80003ce4:	e67ff0ef          	jal	80003b4a <write_head>
}
    80003ce8:	70a2                	ld	ra,40(sp)
    80003cea:	7402                	ld	s0,32(sp)
    80003cec:	64e2                	ld	s1,24(sp)
    80003cee:	6942                	ld	s2,16(sp)
    80003cf0:	69a2                	ld	s3,8(sp)
    80003cf2:	6145                	addi	sp,sp,48
    80003cf4:	8082                	ret

0000000080003cf6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003cf6:	1101                	addi	sp,sp,-32
    80003cf8:	ec06                	sd	ra,24(sp)
    80003cfa:	e822                	sd	s0,16(sp)
    80003cfc:	e426                	sd	s1,8(sp)
    80003cfe:	e04a                	sd	s2,0(sp)
    80003d00:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d02:	0001f517          	auipc	a0,0x1f
    80003d06:	a6e50513          	addi	a0,a0,-1426 # 80022770 <log>
    80003d0a:	edffc0ef          	jal	80000be8 <acquire>
  while (1) {
    if (log.committing) {
    80003d0e:	0001f497          	auipc	s1,0x1f
    80003d12:	a6248493          	addi	s1,s1,-1438 # 80022770 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003d16:	4979                	li	s2,30
    80003d18:	a821                	j	80003d30 <begin_op+0x3a>
      sleep_prepare(&log);
    80003d1a:	8526                	mv	a0,s1
    80003d1c:	9fefe0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003d20:	8526                	mv	a0,s1
    80003d22:	f4ffc0ef          	jal	80000c70 <release>
      sleep();
    80003d26:	a30fe0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003d2a:	8526                	mv	a0,s1
    80003d2c:	ebdfc0ef          	jal	80000be8 <acquire>
    if (log.committing) {
    80003d30:	509c                	lw	a5,32(s1)
    80003d32:	f7e5                	bnez	a5,80003d1a <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003d34:	4cd8                	lw	a4,28(s1)
    80003d36:	2705                	addiw	a4,a4,1
    80003d38:	0027179b          	slliw	a5,a4,0x2
    80003d3c:	9fb9                	addw	a5,a5,a4
    80003d3e:	0017979b          	slliw	a5,a5,0x1
    80003d42:	54d4                	lw	a3,44(s1)
    80003d44:	9fb5                	addw	a5,a5,a3
    80003d46:	00f95e63          	bge	s2,a5,80003d62 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	9cefe0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003d50:	8526                	mv	a0,s1
    80003d52:	f1ffc0ef          	jal	80000c70 <release>
      sleep();
    80003d56:	a00fe0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003d5a:	8526                	mv	a0,s1
    80003d5c:	e8dfc0ef          	jal	80000be8 <acquire>
    80003d60:	bfc1                	j	80003d30 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003d62:	0001f797          	auipc	a5,0x1f
    80003d66:	a2e7a523          	sw	a4,-1494(a5) # 8002278c <log+0x1c>
      release(&log.lock);
    80003d6a:	0001f517          	auipc	a0,0x1f
    80003d6e:	a0650513          	addi	a0,a0,-1530 # 80022770 <log>
    80003d72:	efffc0ef          	jal	80000c70 <release>
      break;
    }
  }
}
    80003d76:	60e2                	ld	ra,24(sp)
    80003d78:	6442                	ld	s0,16(sp)
    80003d7a:	64a2                	ld	s1,8(sp)
    80003d7c:	6902                	ld	s2,0(sp)
    80003d7e:	6105                	addi	sp,sp,32
    80003d80:	8082                	ret

0000000080003d82 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d82:	7139                	addi	sp,sp,-64
    80003d84:	fc06                	sd	ra,56(sp)
    80003d86:	f822                	sd	s0,48(sp)
    80003d88:	f426                	sd	s1,40(sp)
    80003d8a:	f04a                	sd	s2,32(sp)
    80003d8c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d8e:	0001f497          	auipc	s1,0x1f
    80003d92:	9e248493          	addi	s1,s1,-1566 # 80022770 <log>
    80003d96:	8526                	mv	a0,s1
    80003d98:	e51fc0ef          	jal	80000be8 <acquire>
  log.outstanding -= 1;
    80003d9c:	4cdc                	lw	a5,28(s1)
    80003d9e:	37fd                	addiw	a5,a5,-1
    80003da0:	893e                	mv	s2,a5
    80003da2:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003da4:	509c                	lw	a5,32(s1)
    80003da6:	e3b1                	bnez	a5,80003dea <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003da8:	04091a63          	bnez	s2,80003dfc <end_op+0x7a>
    do_commit = 1;
    log.committing = 1;
    80003dac:	0001f497          	auipc	s1,0x1f
    80003db0:	9c448493          	addi	s1,s1,-1596 # 80022770 <log>
    80003db4:	4785                	li	a5,1
    80003db6:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003db8:	8526                	mv	a0,s1
    80003dba:	eb7fc0ef          	jal	80000c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003dbe:	54dc                	lw	a5,44(s1)
    80003dc0:	06f04063          	bgtz	a5,80003e20 <end_op+0x9e>
    acquire(&log.lock);
    80003dc4:	0001f497          	auipc	s1,0x1f
    80003dc8:	9ac48493          	addi	s1,s1,-1620 # 80022770 <log>
    80003dcc:	8526                	mv	a0,s1
    80003dce:	e1bfc0ef          	jal	80000be8 <acquire>
    log.committing = 0;
    80003dd2:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003dd6:	549c                	lw	a5,40(s1)
    80003dd8:	2785                	addiw	a5,a5,1
    80003dda:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003ddc:	8526                	mv	a0,s1
    80003dde:	9a8fe0ef          	jal	80001f86 <wakeup>
    release(&log.lock);
    80003de2:	8526                	mv	a0,s1
    80003de4:	e8dfc0ef          	jal	80000c70 <release>
}
    80003de8:	a035                	j	80003e14 <end_op+0x92>
    80003dea:	ec4e                	sd	s3,24(sp)
    80003dec:	e852                	sd	s4,16(sp)
    80003dee:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003df0:	00003517          	auipc	a0,0x3
    80003df4:	7f050513          	addi	a0,a0,2032 # 800075e0 <etext+0x5e0>
    80003df8:	a3dfc0ef          	jal	80000834 <panic>
    wakeup(&log);
    80003dfc:	0001f517          	auipc	a0,0x1f
    80003e00:	97450513          	addi	a0,a0,-1676 # 80022770 <log>
    80003e04:	982fe0ef          	jal	80001f86 <wakeup>
  release(&log.lock);
    80003e08:	0001f517          	auipc	a0,0x1f
    80003e0c:	96850513          	addi	a0,a0,-1688 # 80022770 <log>
    80003e10:	e61fc0ef          	jal	80000c70 <release>
}
    80003e14:	70e2                	ld	ra,56(sp)
    80003e16:	7442                	ld	s0,48(sp)
    80003e18:	74a2                	ld	s1,40(sp)
    80003e1a:	7902                	ld	s2,32(sp)
    80003e1c:	6121                	addi	sp,sp,64
    80003e1e:	8082                	ret
    80003e20:	ec4e                	sd	s3,24(sp)
    80003e22:	e852                	sd	s4,16(sp)
    80003e24:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e26:	0001fa97          	auipc	s5,0x1f
    80003e2a:	97aa8a93          	addi	s5,s5,-1670 # 800227a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003e2e:	0001fa17          	auipc	s4,0x1f
    80003e32:	942a0a13          	addi	s4,s4,-1726 # 80022770 <log>
    80003e36:	018a2583          	lw	a1,24(s4)
    80003e3a:	012585bb          	addw	a1,a1,s2
    80003e3e:	2585                	addiw	a1,a1,1
    80003e40:	024a2503          	lw	a0,36(s4)
    80003e44:	db1fe0ef          	jal	80002bf4 <bread>
    80003e48:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003e4a:	000aa583          	lw	a1,0(s5)
    80003e4e:	024a2503          	lw	a0,36(s4)
    80003e52:	da3fe0ef          	jal	80002bf4 <bread>
    80003e56:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003e58:	40000613          	li	a2,1024
    80003e5c:	05850593          	addi	a1,a0,88
    80003e60:	05848513          	addi	a0,s1,88
    80003e64:	ea5fc0ef          	jal	80000d08 <memmove>
    bwrite(to); // write the log
    80003e68:	8526                	mv	a0,s1
    80003e6a:	e61fe0ef          	jal	80002cca <bwrite>
    brelse(from);
    80003e6e:	854e                	mv	a0,s3
    80003e70:	e8dfe0ef          	jal	80002cfc <brelse>
    brelse(to);
    80003e74:	8526                	mv	a0,s1
    80003e76:	e87fe0ef          	jal	80002cfc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e7a:	2905                	addiw	s2,s2,1
    80003e7c:	0a91                	addi	s5,s5,4
    80003e7e:	02ca2783          	lw	a5,44(s4)
    80003e82:	faf94ae3          	blt	s2,a5,80003e36 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003e86:	cc5ff0ef          	jal	80003b4a <write_head>
    install_trans(0); // Now install writes to home locations
    80003e8a:	4501                	li	a0,0
    80003e8c:	d1dff0ef          	jal	80003ba8 <install_trans>
    log.lh.n = 0;
    80003e90:	0001f797          	auipc	a5,0x1f
    80003e94:	9007a623          	sw	zero,-1780(a5) # 8002279c <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003e98:	cb3ff0ef          	jal	80003b4a <write_head>
    80003e9c:	69e2                	ld	s3,24(sp)
    80003e9e:	6a42                	ld	s4,16(sp)
    80003ea0:	6aa2                	ld	s5,8(sp)
    80003ea2:	b70d                	j	80003dc4 <end_op+0x42>

0000000080003ea4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003ea4:	1101                	addi	sp,sp,-32
    80003ea6:	ec06                	sd	ra,24(sp)
    80003ea8:	e822                	sd	s0,16(sp)
    80003eaa:	e426                	sd	s1,8(sp)
    80003eac:	1000                	addi	s0,sp,32
    80003eae:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003eb0:	0001f517          	auipc	a0,0x1f
    80003eb4:	8c050513          	addi	a0,a0,-1856 # 80022770 <log>
    80003eb8:	d31fc0ef          	jal	80000be8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003ebc:	0001f617          	auipc	a2,0x1f
    80003ec0:	8e062603          	lw	a2,-1824(a2) # 8002279c <log+0x2c>
    80003ec4:	47f5                	li	a5,29
    80003ec6:	04c7cd63          	blt	a5,a2,80003f20 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003eca:	0001f797          	auipc	a5,0x1f
    80003ece:	8c27a783          	lw	a5,-1854(a5) # 8002278c <log+0x1c>
    80003ed2:	04f05d63          	blez	a5,80003f2c <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003ed6:	4781                	li	a5,0
    80003ed8:	06c05063          	blez	a2,80003f38 <log_write+0x94>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003edc:	44cc                	lw	a1,12(s1)
    80003ede:	0001f717          	auipc	a4,0x1f
    80003ee2:	8c270713          	addi	a4,a4,-1854 # 800227a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ee6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003ee8:	4314                	lw	a3,0(a4)
    80003eea:	04b68763          	beq	a3,a1,80003f38 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003eee:	2785                	addiw	a5,a5,1
    80003ef0:	0711                	addi	a4,a4,4
    80003ef2:	fef61be3          	bne	a2,a5,80003ee8 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ef6:	060a                	slli	a2,a2,0x2
    80003ef8:	02060613          	addi	a2,a2,32
    80003efc:	0001f797          	auipc	a5,0x1f
    80003f00:	87478793          	addi	a5,a5,-1932 # 80022770 <log>
    80003f04:	97b2                	add	a5,a5,a2
    80003f06:	44d8                	lw	a4,12(s1)
    80003f08:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	e75fe0ef          	jal	80002d80 <bpin>
    log.lh.n++;
    80003f10:	0001f717          	auipc	a4,0x1f
    80003f14:	86070713          	addi	a4,a4,-1952 # 80022770 <log>
    80003f18:	575c                	lw	a5,44(a4)
    80003f1a:	2785                	addiw	a5,a5,1
    80003f1c:	d75c                	sw	a5,44(a4)
    80003f1e:	a815                	j	80003f52 <log_write+0xae>
    panic("too big a transaction");
    80003f20:	00003517          	auipc	a0,0x3
    80003f24:	6d050513          	addi	a0,a0,1744 # 800075f0 <etext+0x5f0>
    80003f28:	90dfc0ef          	jal	80000834 <panic>
    panic("log_write outside of trans");
    80003f2c:	00003517          	auipc	a0,0x3
    80003f30:	6dc50513          	addi	a0,a0,1756 # 80007608 <etext+0x608>
    80003f34:	901fc0ef          	jal	80000834 <panic>
  log.lh.block[i] = b->blockno;
    80003f38:	00279693          	slli	a3,a5,0x2
    80003f3c:	02068693          	addi	a3,a3,32
    80003f40:	0001f717          	auipc	a4,0x1f
    80003f44:	83070713          	addi	a4,a4,-2000 # 80022770 <log>
    80003f48:	9736                	add	a4,a4,a3
    80003f4a:	44d4                	lw	a3,12(s1)
    80003f4c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003f4e:	faf60ee3          	beq	a2,a5,80003f0a <log_write+0x66>
  }
  release(&log.lock);
    80003f52:	0001f517          	auipc	a0,0x1f
    80003f56:	81e50513          	addi	a0,a0,-2018 # 80022770 <log>
    80003f5a:	d17fc0ef          	jal	80000c70 <release>
}
    80003f5e:	60e2                	ld	ra,24(sp)
    80003f60:	6442                	ld	s0,16(sp)
    80003f62:	64a2                	ld	s1,8(sp)
    80003f64:	6105                	addi	sp,sp,32
    80003f66:	8082                	ret

0000000080003f68 <sys_sync>:

uint64
sys_sync(void)
{
    80003f68:	1101                	addi	sp,sp,-32
    80003f6a:	ec06                	sd	ra,24(sp)
    80003f6c:	e822                	sd	s0,16(sp)
    80003f6e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003f70:	0001f517          	auipc	a0,0x1f
    80003f74:	80050513          	addi	a0,a0,-2048 # 80022770 <log>
    80003f78:	c71fc0ef          	jal	80000be8 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003f7c:	0001f797          	auipc	a5,0x1f
    80003f80:	8147a783          	lw	a5,-2028(a5) # 80022790 <log+0x20>
    80003f84:	e799                	bnez	a5,80003f92 <sys_sync+0x2a>
    80003f86:	0001f797          	auipc	a5,0x1f
    80003f8a:	8067a783          	lw	a5,-2042(a5) # 8002278c <log+0x1c>
    80003f8e:	02f05c63          	blez	a5,80003fc6 <sys_sync+0x5e>
    80003f92:	e426                	sd	s1,8(sp)
    80003f94:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003f96:	0001f917          	auipc	s2,0x1f
    80003f9a:	80292903          	lw	s2,-2046(s2) # 80022798 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80003f9e:	0001e497          	auipc	s1,0x1e
    80003fa2:	7d248493          	addi	s1,s1,2002 # 80022770 <log>
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	f73fd0ef          	jal	80001f1a <sleep_prepare>
      release(&log.lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	cc3fc0ef          	jal	80000c70 <release>
      sleep();
    80003fb2:	fa5fd0ef          	jal	80001f56 <sleep>
      acquire(&log.lock);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	c31fc0ef          	jal	80000be8 <acquire>
    while (log.ncommit < n) {
    80003fbc:	549c                	lw	a5,40(s1)
    80003fbe:	fef954e3          	bge	s2,a5,80003fa6 <sys_sync+0x3e>
    80003fc2:	64a2                	ld	s1,8(sp)
    80003fc4:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003fc6:	0001e517          	auipc	a0,0x1e
    80003fca:	7aa50513          	addi	a0,a0,1962 # 80022770 <log>
    80003fce:	ca3fc0ef          	jal	80000c70 <release>
  return 0;
}
    80003fd2:	4501                	li	a0,0
    80003fd4:	60e2                	ld	ra,24(sp)
    80003fd6:	6442                	ld	s0,16(sp)
    80003fd8:	6105                	addi	sp,sp,32
    80003fda:	8082                	ret

0000000080003fdc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fdc:	1101                	addi	sp,sp,-32
    80003fde:	ec06                	sd	ra,24(sp)
    80003fe0:	e822                	sd	s0,16(sp)
    80003fe2:	e426                	sd	s1,8(sp)
    80003fe4:	e04a                	sd	s2,0(sp)
    80003fe6:	1000                	addi	s0,sp,32
    80003fe8:	84aa                	mv	s1,a0
    80003fea:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003fec:	00003597          	auipc	a1,0x3
    80003ff0:	63c58593          	addi	a1,a1,1596 # 80007628 <etext+0x628>
    80003ff4:	0521                	addi	a0,a0,8
    80003ff6:	b73fc0ef          	jal	80000b68 <initlock>
  lk->name = name;
    80003ffa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ffe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004002:	0204a423          	sw	zero,40(s1)
}
    80004006:	60e2                	ld	ra,24(sp)
    80004008:	6442                	ld	s0,16(sp)
    8000400a:	64a2                	ld	s1,8(sp)
    8000400c:	6902                	ld	s2,0(sp)
    8000400e:	6105                	addi	sp,sp,32
    80004010:	8082                	ret

0000000080004012 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004012:	1101                	addi	sp,sp,-32
    80004014:	ec06                	sd	ra,24(sp)
    80004016:	e822                	sd	s0,16(sp)
    80004018:	e426                	sd	s1,8(sp)
    8000401a:	e04a                	sd	s2,0(sp)
    8000401c:	1000                	addi	s0,sp,32
    8000401e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004020:	00850913          	addi	s2,a0,8
    80004024:	854a                	mv	a0,s2
    80004026:	bc3fc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    8000402a:	409c                	lw	a5,0(s1)
    8000402c:	cf91                	beqz	a5,80004048 <acquiresleep+0x36>
    sleep_prepare(lk);
    8000402e:	8526                	mv	a0,s1
    80004030:	eebfd0ef          	jal	80001f1a <sleep_prepare>
    release(&lk->lk);
    80004034:	854a                	mv	a0,s2
    80004036:	c3bfc0ef          	jal	80000c70 <release>
    sleep();
    8000403a:	f1dfd0ef          	jal	80001f56 <sleep>
    acquire(&lk->lk);
    8000403e:	854a                	mv	a0,s2
    80004040:	ba9fc0ef          	jal	80000be8 <acquire>
  while (lk->locked) {
    80004044:	409c                	lw	a5,0(s1)
    80004046:	f7e5                	bnez	a5,8000402e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004048:	4785                	li	a5,1
    8000404a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000404c:	8bdfd0ef          	jal	80001908 <myproc>
    80004050:	591c                	lw	a5,48(a0)
    80004052:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004054:	854a                	mv	a0,s2
    80004056:	c1bfc0ef          	jal	80000c70 <release>
}
    8000405a:	60e2                	ld	ra,24(sp)
    8000405c:	6442                	ld	s0,16(sp)
    8000405e:	64a2                	ld	s1,8(sp)
    80004060:	6902                	ld	s2,0(sp)
    80004062:	6105                	addi	sp,sp,32
    80004064:	8082                	ret

0000000080004066 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004066:	1101                	addi	sp,sp,-32
    80004068:	ec06                	sd	ra,24(sp)
    8000406a:	e822                	sd	s0,16(sp)
    8000406c:	e426                	sd	s1,8(sp)
    8000406e:	e04a                	sd	s2,0(sp)
    80004070:	1000                	addi	s0,sp,32
    80004072:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004074:	00850913          	addi	s2,a0,8
    80004078:	854a                	mv	a0,s2
    8000407a:	b6ffc0ef          	jal	80000be8 <acquire>
  lk->locked = 0;
    8000407e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004082:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004086:	8526                	mv	a0,s1
    80004088:	efffd0ef          	jal	80001f86 <wakeup>
  release(&lk->lk);
    8000408c:	854a                	mv	a0,s2
    8000408e:	be3fc0ef          	jal	80000c70 <release>
}
    80004092:	60e2                	ld	ra,24(sp)
    80004094:	6442                	ld	s0,16(sp)
    80004096:	64a2                	ld	s1,8(sp)
    80004098:	6902                	ld	s2,0(sp)
    8000409a:	6105                	addi	sp,sp,32
    8000409c:	8082                	ret

000000008000409e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000409e:	7179                	addi	sp,sp,-48
    800040a0:	f406                	sd	ra,40(sp)
    800040a2:	f022                	sd	s0,32(sp)
    800040a4:	ec26                	sd	s1,24(sp)
    800040a6:	e84a                	sd	s2,16(sp)
    800040a8:	1800                	addi	s0,sp,48
    800040aa:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800040ac:	00850913          	addi	s2,a0,8
    800040b0:	854a                	mv	a0,s2
    800040b2:	b37fc0ef          	jal	80000be8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800040b6:	409c                	lw	a5,0(s1)
    800040b8:	ef81                	bnez	a5,800040d0 <holdingsleep+0x32>
    800040ba:	4481                	li	s1,0
  release(&lk->lk);
    800040bc:	854a                	mv	a0,s2
    800040be:	bb3fc0ef          	jal	80000c70 <release>
  return r;
}
    800040c2:	8526                	mv	a0,s1
    800040c4:	70a2                	ld	ra,40(sp)
    800040c6:	7402                	ld	s0,32(sp)
    800040c8:	64e2                	ld	s1,24(sp)
    800040ca:	6942                	ld	s2,16(sp)
    800040cc:	6145                	addi	sp,sp,48
    800040ce:	8082                	ret
    800040d0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040d2:	0284a983          	lw	s3,40(s1)
    800040d6:	833fd0ef          	jal	80001908 <myproc>
    800040da:	5904                	lw	s1,48(a0)
    800040dc:	413484b3          	sub	s1,s1,s3
    800040e0:	0014b493          	seqz	s1,s1
    800040e4:	69a2                	ld	s3,8(sp)
    800040e6:	bfd9                	j	800040bc <holdingsleep+0x1e>

00000000800040e8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040e8:	1141                	addi	sp,sp,-16
    800040ea:	e406                	sd	ra,8(sp)
    800040ec:	e022                	sd	s0,0(sp)
    800040ee:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040f0:	00003597          	auipc	a1,0x3
    800040f4:	54858593          	addi	a1,a1,1352 # 80007638 <etext+0x638>
    800040f8:	0001e517          	auipc	a0,0x1e
    800040fc:	7c050513          	addi	a0,a0,1984 # 800228b8 <ftable>
    80004100:	a69fc0ef          	jal	80000b68 <initlock>
}
    80004104:	60a2                	ld	ra,8(sp)
    80004106:	6402                	ld	s0,0(sp)
    80004108:	0141                	addi	sp,sp,16
    8000410a:	8082                	ret

000000008000410c <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000410c:	1101                	addi	sp,sp,-32
    8000410e:	ec06                	sd	ra,24(sp)
    80004110:	e822                	sd	s0,16(sp)
    80004112:	e426                	sd	s1,8(sp)
    80004114:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004116:	0001e517          	auipc	a0,0x1e
    8000411a:	7a250513          	addi	a0,a0,1954 # 800228b8 <ftable>
    8000411e:	acbfc0ef          	jal	80000be8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004122:	0001e497          	auipc	s1,0x1e
    80004126:	7ae48493          	addi	s1,s1,1966 # 800228d0 <ftable+0x18>
    8000412a:	0001f717          	auipc	a4,0x1f
    8000412e:	74670713          	addi	a4,a4,1862 # 80023870 <disk>
    if (f->ref == 0) {
    80004132:	40dc                	lw	a5,4(s1)
    80004134:	cf89                	beqz	a5,8000414e <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004136:	02848493          	addi	s1,s1,40
    8000413a:	fee49ce3          	bne	s1,a4,80004132 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000413e:	0001e517          	auipc	a0,0x1e
    80004142:	77a50513          	addi	a0,a0,1914 # 800228b8 <ftable>
    80004146:	b2bfc0ef          	jal	80000c70 <release>
  return 0;
    8000414a:	4481                	li	s1,0
    8000414c:	a809                	j	8000415e <filealloc+0x52>
      f->ref = 1;
    8000414e:	4785                	li	a5,1
    80004150:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004152:	0001e517          	auipc	a0,0x1e
    80004156:	76650513          	addi	a0,a0,1894 # 800228b8 <ftable>
    8000415a:	b17fc0ef          	jal	80000c70 <release>
}
    8000415e:	8526                	mv	a0,s1
    80004160:	60e2                	ld	ra,24(sp)
    80004162:	6442                	ld	s0,16(sp)
    80004164:	64a2                	ld	s1,8(sp)
    80004166:	6105                	addi	sp,sp,32
    80004168:	8082                	ret

000000008000416a <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000416a:	1101                	addi	sp,sp,-32
    8000416c:	ec06                	sd	ra,24(sp)
    8000416e:	e822                	sd	s0,16(sp)
    80004170:	e426                	sd	s1,8(sp)
    80004172:	1000                	addi	s0,sp,32
    80004174:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004176:	0001e517          	auipc	a0,0x1e
    8000417a:	74250513          	addi	a0,a0,1858 # 800228b8 <ftable>
    8000417e:	a6bfc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    80004182:	40dc                	lw	a5,4(s1)
    80004184:	02f05063          	blez	a5,800041a4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004188:	2785                	addiw	a5,a5,1
    8000418a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000418c:	0001e517          	auipc	a0,0x1e
    80004190:	72c50513          	addi	a0,a0,1836 # 800228b8 <ftable>
    80004194:	addfc0ef          	jal	80000c70 <release>
  return f;
}
    80004198:	8526                	mv	a0,s1
    8000419a:	60e2                	ld	ra,24(sp)
    8000419c:	6442                	ld	s0,16(sp)
    8000419e:	64a2                	ld	s1,8(sp)
    800041a0:	6105                	addi	sp,sp,32
    800041a2:	8082                	ret
    panic("filedup");
    800041a4:	00003517          	auipc	a0,0x3
    800041a8:	49c50513          	addi	a0,a0,1180 # 80007640 <etext+0x640>
    800041ac:	e88fc0ef          	jal	80000834 <panic>

00000000800041b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800041b0:	7139                	addi	sp,sp,-64
    800041b2:	fc06                	sd	ra,56(sp)
    800041b4:	f822                	sd	s0,48(sp)
    800041b6:	f426                	sd	s1,40(sp)
    800041b8:	0080                	addi	s0,sp,64
    800041ba:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800041bc:	0001e517          	auipc	a0,0x1e
    800041c0:	6fc50513          	addi	a0,a0,1788 # 800228b8 <ftable>
    800041c4:	a25fc0ef          	jal	80000be8 <acquire>
  if (f->ref < 1)
    800041c8:	40dc                	lw	a5,4(s1)
    800041ca:	04f05a63          	blez	a5,8000421e <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800041ce:	37fd                	addiw	a5,a5,-1
    800041d0:	c0dc                	sw	a5,4(s1)
    800041d2:	06f04063          	bgtz	a5,80004232 <fileclose+0x82>
    800041d6:	f04a                	sd	s2,32(sp)
    800041d8:	ec4e                	sd	s3,24(sp)
    800041da:	e852                	sd	s4,16(sp)
    800041dc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041de:	0004a903          	lw	s2,0(s1)
    800041e2:	0094c783          	lbu	a5,9(s1)
    800041e6:	89be                	mv	s3,a5
    800041e8:	689c                	ld	a5,16(s1)
    800041ea:	8a3e                	mv	s4,a5
    800041ec:	6c9c                	ld	a5,24(s1)
    800041ee:	8abe                	mv	s5,a5
  f->ref = 0;
    800041f0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041f4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041f8:	0001e517          	auipc	a0,0x1e
    800041fc:	6c050513          	addi	a0,a0,1728 # 800228b8 <ftable>
    80004200:	a71fc0ef          	jal	80000c70 <release>

  if (ff.type == FD_PIPE) {
    80004204:	4785                	li	a5,1
    80004206:	04f90163          	beq	s2,a5,80004248 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000420a:	ffe9079b          	addiw	a5,s2,-2
    8000420e:	4705                	li	a4,1
    80004210:	04f77563          	bgeu	a4,a5,8000425a <fileclose+0xaa>
    80004214:	7902                	ld	s2,32(sp)
    80004216:	69e2                	ld	s3,24(sp)
    80004218:	6a42                	ld	s4,16(sp)
    8000421a:	6aa2                	ld	s5,8(sp)
    8000421c:	a00d                	j	8000423e <fileclose+0x8e>
    8000421e:	f04a                	sd	s2,32(sp)
    80004220:	ec4e                	sd	s3,24(sp)
    80004222:	e852                	sd	s4,16(sp)
    80004224:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004226:	00003517          	auipc	a0,0x3
    8000422a:	42250513          	addi	a0,a0,1058 # 80007648 <etext+0x648>
    8000422e:	e06fc0ef          	jal	80000834 <panic>
    release(&ftable.lock);
    80004232:	0001e517          	auipc	a0,0x1e
    80004236:	68650513          	addi	a0,a0,1670 # 800228b8 <ftable>
    8000423a:	a37fc0ef          	jal	80000c70 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000423e:	70e2                	ld	ra,56(sp)
    80004240:	7442                	ld	s0,48(sp)
    80004242:	74a2                	ld	s1,40(sp)
    80004244:	6121                	addi	sp,sp,64
    80004246:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004248:	85ce                	mv	a1,s3
    8000424a:	8552                	mv	a0,s4
    8000424c:	360000ef          	jal	800045ac <pipeclose>
    80004250:	7902                	ld	s2,32(sp)
    80004252:	69e2                	ld	s3,24(sp)
    80004254:	6a42                	ld	s4,16(sp)
    80004256:	6aa2                	ld	s5,8(sp)
    80004258:	b7dd                	j	8000423e <fileclose+0x8e>
    begin_op();
    8000425a:	a9dff0ef          	jal	80003cf6 <begin_op>
    iput(ff.ip);
    8000425e:	8556                	mv	a0,s5
    80004260:	9aeff0ef          	jal	8000340e <iput>
    end_op();
    80004264:	b1fff0ef          	jal	80003d82 <end_op>
    80004268:	7902                	ld	s2,32(sp)
    8000426a:	69e2                	ld	s3,24(sp)
    8000426c:	6a42                	ld	s4,16(sp)
    8000426e:	6aa2                	ld	s5,8(sp)
    80004270:	b7f9                	j	8000423e <fileclose+0x8e>

0000000080004272 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004272:	715d                	addi	sp,sp,-80
    80004274:	e486                	sd	ra,72(sp)
    80004276:	e0a2                	sd	s0,64(sp)
    80004278:	fc26                	sd	s1,56(sp)
    8000427a:	f052                	sd	s4,32(sp)
    8000427c:	0880                	addi	s0,sp,80
    8000427e:	84aa                	mv	s1,a0
    80004280:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004282:	e86fd0ef          	jal	80001908 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004286:	409c                	lw	a5,0(s1)
    80004288:	37f9                	addiw	a5,a5,-2
    8000428a:	4705                	li	a4,1
    8000428c:	04f76463          	bltu	a4,a5,800042d4 <filestat+0x62>
    80004290:	f84a                	sd	s2,48(sp)
    80004292:	f44e                	sd	s3,40(sp)
    80004294:	892a                	mv	s2,a0
    ilock(f->ip);
    80004296:	6c88                	ld	a0,24(s1)
    80004298:	ff5fe0ef          	jal	8000328c <ilock>
    stati(f->ip, &st);
    8000429c:	fb840993          	addi	s3,s0,-72
    800042a0:	85ce                	mv	a1,s3
    800042a2:	6c88                	ld	a0,24(s1)
    800042a4:	b94ff0ef          	jal	80003638 <stati>
    iunlock(f->ip);
    800042a8:	6c88                	ld	a0,24(s1)
    800042aa:	890ff0ef          	jal	8000333a <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    800042ae:	4761                	li	a4,24
    800042b0:	86ce                	mv	a3,s3
    800042b2:	8652                	mv	a2,s4
    800042b4:	04893583          	ld	a1,72(s2)
    800042b8:	05093503          	ld	a0,80(s2)
    800042bc:	a86fd0ef          	jal	80001542 <copyout>
    800042c0:	41f5551b          	sraiw	a0,a0,0x1f
    800042c4:	7942                	ld	s2,48(sp)
    800042c6:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042c8:	60a6                	ld	ra,72(sp)
    800042ca:	6406                	ld	s0,64(sp)
    800042cc:	74e2                	ld	s1,56(sp)
    800042ce:	7a02                	ld	s4,32(sp)
    800042d0:	6161                	addi	sp,sp,80
    800042d2:	8082                	ret
  return -1;
    800042d4:	557d                	li	a0,-1
    800042d6:	bfcd                	j	800042c8 <filestat+0x56>

00000000800042d8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042d8:	7179                	addi	sp,sp,-48
    800042da:	f406                	sd	ra,40(sp)
    800042dc:	f022                	sd	s0,32(sp)
    800042de:	e84a                	sd	s2,16(sp)
    800042e0:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    800042e2:	00854783          	lbu	a5,8(a0)
    800042e6:	c3dd                	beqz	a5,8000438c <fileread+0xb4>
    800042e8:	ec26                	sd	s1,24(sp)
    800042ea:	e44e                	sd	s3,8(sp)
    800042ec:	84aa                	mv	s1,a0
    800042ee:	892e                	mv	s2,a1
    800042f0:	89b2                	mv	s3,a2
    800042f2:	01f6579b          	srliw	a5,a2,0x1f
    800042f6:	ebc9                	bnez	a5,80004388 <fileread+0xb0>
    return -1;

  if (f->type == FD_PIPE) {
    800042f8:	411c                	lw	a5,0(a0)
    800042fa:	4705                	li	a4,1
    800042fc:	04e78363          	beq	a5,a4,80004342 <fileread+0x6a>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004300:	470d                	li	a4,3
    80004302:	04e78763          	beq	a5,a4,80004350 <fileread+0x78>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004306:	4709                	li	a4,2
    80004308:	06e79a63          	bne	a5,a4,8000437c <fileread+0xa4>
    ilock(f->ip);
    8000430c:	6d08                	ld	a0,24(a0)
    8000430e:	f7ffe0ef          	jal	8000328c <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004312:	874e                	mv	a4,s3
    80004314:	5094                	lw	a3,32(s1)
    80004316:	864a                	mv	a2,s2
    80004318:	4585                	li	a1,1
    8000431a:	6c88                	ld	a0,24(s1)
    8000431c:	b4aff0ef          	jal	80003666 <readi>
    80004320:	892a                	mv	s2,a0
    80004322:	00a05563          	blez	a0,8000432c <fileread+0x54>
      f->off += r;
    80004326:	509c                	lw	a5,32(s1)
    80004328:	9fa9                	addw	a5,a5,a0
    8000432a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000432c:	6c88                	ld	a0,24(s1)
    8000432e:	80cff0ef          	jal	8000333a <iunlock>
    80004332:	64e2                	ld	s1,24(sp)
    80004334:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004336:	854a                	mv	a0,s2
    80004338:	70a2                	ld	ra,40(sp)
    8000433a:	7402                	ld	s0,32(sp)
    8000433c:	6942                	ld	s2,16(sp)
    8000433e:	6145                	addi	sp,sp,48
    80004340:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004342:	6908                	ld	a0,16(a0)
    80004344:	3e2000ef          	jal	80004726 <piperead>
    80004348:	892a                	mv	s2,a0
    8000434a:	64e2                	ld	s1,24(sp)
    8000434c:	69a2                	ld	s3,8(sp)
    8000434e:	b7e5                	j	80004336 <fileread+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004350:	02451783          	lh	a5,36(a0)
    80004354:	03079693          	slli	a3,a5,0x30
    80004358:	92c1                	srli	a3,a3,0x30
    8000435a:	4725                	li	a4,9
    8000435c:	02d76b63          	bltu	a4,a3,80004392 <fileread+0xba>
    80004360:	0792                	slli	a5,a5,0x4
    80004362:	0001e717          	auipc	a4,0x1e
    80004366:	4b670713          	addi	a4,a4,1206 # 80022818 <devsw>
    8000436a:	97ba                	add	a5,a5,a4
    8000436c:	639c                	ld	a5,0(a5)
    8000436e:	c79d                	beqz	a5,8000439c <fileread+0xc4>
    r = devsw[f->major].read(1, addr, n);
    80004370:	4505                	li	a0,1
    80004372:	9782                	jalr	a5
    80004374:	892a                	mv	s2,a0
    80004376:	64e2                	ld	s1,24(sp)
    80004378:	69a2                	ld	s3,8(sp)
    8000437a:	bf75                	j	80004336 <fileread+0x5e>
    panic("fileread");
    8000437c:	00003517          	auipc	a0,0x3
    80004380:	2dc50513          	addi	a0,a0,732 # 80007658 <etext+0x658>
    80004384:	cb0fc0ef          	jal	80000834 <panic>
    80004388:	64e2                	ld	s1,24(sp)
    8000438a:	69a2                	ld	s3,8(sp)
    return -1;
    8000438c:	57fd                	li	a5,-1
    8000438e:	893e                	mv	s2,a5
    80004390:	b75d                	j	80004336 <fileread+0x5e>
      return -1;
    80004392:	57fd                	li	a5,-1
    80004394:	893e                	mv	s2,a5
    80004396:	64e2                	ld	s1,24(sp)
    80004398:	69a2                	ld	s3,8(sp)
    8000439a:	bf71                	j	80004336 <fileread+0x5e>
    8000439c:	57fd                	li	a5,-1
    8000439e:	893e                	mv	s2,a5
    800043a0:	64e2                	ld	s1,24(sp)
    800043a2:	69a2                	ld	s3,8(sp)
    800043a4:	bf49                	j	80004336 <fileread+0x5e>

00000000800043a6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    800043a6:	00954783          	lbu	a5,9(a0)
    800043aa:	12078b63          	beqz	a5,800044e0 <filewrite+0x13a>
{
    800043ae:	711d                	addi	sp,sp,-96
    800043b0:	ec86                	sd	ra,88(sp)
    800043b2:	e8a2                	sd	s0,80(sp)
    800043b4:	e0ca                	sd	s2,64(sp)
    800043b6:	f456                	sd	s5,40(sp)
    800043b8:	f05a                	sd	s6,32(sp)
    800043ba:	1080                	addi	s0,sp,96
    800043bc:	892a                	mv	s2,a0
    800043be:	8b2e                	mv	s6,a1
    800043c0:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    800043c2:	01f6579b          	srliw	a5,a2,0x1f
    800043c6:	0e079d63          	bnez	a5,800044c0 <filewrite+0x11a>
    return -1;

  if (f->type == FD_PIPE) {
    800043ca:	411c                	lw	a5,0(a0)
    800043cc:	4705                	li	a4,1
    800043ce:	02e78a63          	beq	a5,a4,80004402 <filewrite+0x5c>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800043d2:	470d                	li	a4,3
    800043d4:	02e78b63          	beq	a5,a4,8000440a <filewrite+0x64>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800043d8:	4709                	li	a4,2
    800043da:	0ce79763          	bne	a5,a4,800044a8 <filewrite+0x102>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800043de:	0ec05763          	blez	a2,800044cc <filewrite+0x126>
    800043e2:	e4a6                	sd	s1,72(sp)
    800043e4:	fc4e                	sd	s3,56(sp)
    800043e6:	f852                	sd	s4,48(sp)
    800043e8:	ec5e                	sd	s7,24(sp)
    800043ea:	e862                	sd	s8,16(sp)
    800043ec:	e466                	sd	s9,8(sp)
    int i = 0;
    800043ee:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800043f0:	6b85                	lui	s7,0x1
    800043f2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043f6:	6785                	lui	a5,0x1
    800043f8:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800043fc:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043fe:	4c05                	li	s8,1
    80004400:	a8ad                	j	8000447a <filewrite+0xd4>
    ret = pipewrite(f->pipe, addr, n);
    80004402:	6908                	ld	a0,16(a0)
    80004404:	206000ef          	jal	8000460a <pipewrite>
    80004408:	a849                	j	8000449a <filewrite+0xf4>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000440a:	02451783          	lh	a5,36(a0)
    8000440e:	03079693          	slli	a3,a5,0x30
    80004412:	92c1                	srli	a3,a3,0x30
    80004414:	4725                	li	a4,9
    80004416:	0ad76763          	bltu	a4,a3,800044c4 <filewrite+0x11e>
    8000441a:	0792                	slli	a5,a5,0x4
    8000441c:	0001e717          	auipc	a4,0x1e
    80004420:	3fc70713          	addi	a4,a4,1020 # 80022818 <devsw>
    80004424:	97ba                	add	a5,a5,a4
    80004426:	679c                	ld	a5,8(a5)
    80004428:	c3c5                	beqz	a5,800044c8 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000442a:	4505                	li	a0,1
    8000442c:	9782                	jalr	a5
    8000442e:	a0b5                	j	8000449a <filewrite+0xf4>
      if (n1 > max)
    80004430:	2981                	sext.w	s3,s3
      begin_op();
    80004432:	8c5ff0ef          	jal	80003cf6 <begin_op>
      ilock(f->ip);
    80004436:	01893503          	ld	a0,24(s2)
    8000443a:	e53fe0ef          	jal	8000328c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000443e:	874e                	mv	a4,s3
    80004440:	02092683          	lw	a3,32(s2)
    80004444:	016a0633          	add	a2,s4,s6
    80004448:	85e2                	mv	a1,s8
    8000444a:	01893503          	ld	a0,24(s2)
    8000444e:	b0aff0ef          	jal	80003758 <writei>
    80004452:	84aa                	mv	s1,a0
    80004454:	00a05763          	blez	a0,80004462 <filewrite+0xbc>
        f->off += r;
    80004458:	02092783          	lw	a5,32(s2)
    8000445c:	9fa9                	addw	a5,a5,a0
    8000445e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004462:	01893503          	ld	a0,24(s2)
    80004466:	ed5fe0ef          	jal	8000333a <iunlock>
      end_op();
    8000446a:	919ff0ef          	jal	80003d82 <end_op>

      if (r != n1) {
    8000446e:	00999d63          	bne	s3,s1,80004488 <filewrite+0xe2>
        // error from writei
        break;
      }
      i += r;
    80004472:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004476:	015a5963          	bge	s4,s5,80004488 <filewrite+0xe2>
      int n1 = n - i;
    8000447a:	414a87bb          	subw	a5,s5,s4
    8000447e:	89be                	mv	s3,a5
      if (n1 > max)
    80004480:	fafbd8e3          	bge	s7,a5,80004430 <filewrite+0x8a>
    80004484:	89e6                	mv	s3,s9
    80004486:	b76d                	j	80004430 <filewrite+0x8a>
    }
    ret = (i == n ? n : -1);
    80004488:	054a9463          	bne	s5,s4,800044d0 <filewrite+0x12a>
    8000448c:	8556                	mv	a0,s5
    8000448e:	64a6                	ld	s1,72(sp)
    80004490:	79e2                	ld	s3,56(sp)
    80004492:	7a42                	ld	s4,48(sp)
    80004494:	6be2                	ld	s7,24(sp)
    80004496:	6c42                	ld	s8,16(sp)
    80004498:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000449a:	60e6                	ld	ra,88(sp)
    8000449c:	6446                	ld	s0,80(sp)
    8000449e:	6906                	ld	s2,64(sp)
    800044a0:	7aa2                	ld	s5,40(sp)
    800044a2:	7b02                	ld	s6,32(sp)
    800044a4:	6125                	addi	sp,sp,96
    800044a6:	8082                	ret
    800044a8:	e4a6                	sd	s1,72(sp)
    800044aa:	fc4e                	sd	s3,56(sp)
    800044ac:	f852                	sd	s4,48(sp)
    800044ae:	ec5e                	sd	s7,24(sp)
    800044b0:	e862                	sd	s8,16(sp)
    800044b2:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800044b4:	00003517          	auipc	a0,0x3
    800044b8:	1b450513          	addi	a0,a0,436 # 80007668 <etext+0x668>
    800044bc:	b78fc0ef          	jal	80000834 <panic>
    return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	bfe1                	j	8000449a <filewrite+0xf4>
      return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	bfd1                	j	8000449a <filewrite+0xf4>
    800044c8:	557d                	li	a0,-1
    800044ca:	bfc1                	j	8000449a <filewrite+0xf4>
    ret = (i == n ? n : -1);
    800044cc:	8532                	mv	a0,a2
    800044ce:	b7f1                	j	8000449a <filewrite+0xf4>
    800044d0:	557d                	li	a0,-1
    800044d2:	64a6                	ld	s1,72(sp)
    800044d4:	79e2                	ld	s3,56(sp)
    800044d6:	7a42                	ld	s4,48(sp)
    800044d8:	6be2                	ld	s7,24(sp)
    800044da:	6c42                	ld	s8,16(sp)
    800044dc:	6ca2                	ld	s9,8(sp)
    800044de:	bf75                	j	8000449a <filewrite+0xf4>
    return -1;
    800044e0:	557d                	li	a0,-1
}
    800044e2:	8082                	ret

00000000800044e4 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044e4:	7179                	addi	sp,sp,-48
    800044e6:	f406                	sd	ra,40(sp)
    800044e8:	f022                	sd	s0,32(sp)
    800044ea:	ec26                	sd	s1,24(sp)
    800044ec:	e052                	sd	s4,0(sp)
    800044ee:	1800                	addi	s0,sp,48
    800044f0:	84aa                	mv	s1,a0
    800044f2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044f4:	0005b023          	sd	zero,0(a1)
    800044f8:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044fc:	c11ff0ef          	jal	8000410c <filealloc>
    80004500:	e088                	sd	a0,0(s1)
    80004502:	c549                	beqz	a0,8000458c <pipealloc+0xa8>
    80004504:	c09ff0ef          	jal	8000410c <filealloc>
    80004508:	00aa3023          	sd	a0,0(s4)
    8000450c:	cd25                	beqz	a0,80004584 <pipealloc+0xa0>
    8000450e:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004510:	dfefc0ef          	jal	80000b0e <kalloc>
    80004514:	892a                	mv	s2,a0
    80004516:	c12d                	beqz	a0,80004578 <pipealloc+0x94>
    80004518:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000451a:	4985                	li	s3,1
    8000451c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004520:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004524:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004528:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000452c:	00003597          	auipc	a1,0x3
    80004530:	eb458593          	addi	a1,a1,-332 # 800073e0 <etext+0x3e0>
    80004534:	e34fc0ef          	jal	80000b68 <initlock>
  (*f0)->type = FD_PIPE;
    80004538:	609c                	ld	a5,0(s1)
    8000453a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000453e:	609c                	ld	a5,0(s1)
    80004540:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004544:	609c                	ld	a5,0(s1)
    80004546:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000454a:	609c                	ld	a5,0(s1)
    8000454c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004550:	000a3783          	ld	a5,0(s4)
    80004554:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004558:	000a3783          	ld	a5,0(s4)
    8000455c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004560:	000a3783          	ld	a5,0(s4)
    80004564:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004568:	000a3783          	ld	a5,0(s4)
    8000456c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004570:	4501                	li	a0,0
    80004572:	6942                	ld	s2,16(sp)
    80004574:	69a2                	ld	s3,8(sp)
    80004576:	a01d                	j	8000459c <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004578:	6088                	ld	a0,0(s1)
    8000457a:	c119                	beqz	a0,80004580 <pipealloc+0x9c>
    8000457c:	6942                	ld	s2,16(sp)
    8000457e:	a029                	j	80004588 <pipealloc+0xa4>
    80004580:	6942                	ld	s2,16(sp)
    80004582:	a029                	j	8000458c <pipealloc+0xa8>
    80004584:	6088                	ld	a0,0(s1)
    80004586:	c10d                	beqz	a0,800045a8 <pipealloc+0xc4>
    fileclose(*f0);
    80004588:	c29ff0ef          	jal	800041b0 <fileclose>
  if (*f1)
    8000458c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004590:	557d                	li	a0,-1
  if (*f1)
    80004592:	c789                	beqz	a5,8000459c <pipealloc+0xb8>
    fileclose(*f1);
    80004594:	853e                	mv	a0,a5
    80004596:	c1bff0ef          	jal	800041b0 <fileclose>
  return -1;
    8000459a:	557d                	li	a0,-1
}
    8000459c:	70a2                	ld	ra,40(sp)
    8000459e:	7402                	ld	s0,32(sp)
    800045a0:	64e2                	ld	s1,24(sp)
    800045a2:	6a02                	ld	s4,0(sp)
    800045a4:	6145                	addi	sp,sp,48
    800045a6:	8082                	ret
  return -1;
    800045a8:	557d                	li	a0,-1
    800045aa:	bfcd                	j	8000459c <pipealloc+0xb8>

00000000800045ac <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800045ac:	1101                	addi	sp,sp,-32
    800045ae:	ec06                	sd	ra,24(sp)
    800045b0:	e822                	sd	s0,16(sp)
    800045b2:	e426                	sd	s1,8(sp)
    800045b4:	e04a                	sd	s2,0(sp)
    800045b6:	1000                	addi	s0,sp,32
    800045b8:	84aa                	mv	s1,a0
    800045ba:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800045bc:	e2cfc0ef          	jal	80000be8 <acquire>
  if (writable) {
    800045c0:	02090763          	beqz	s2,800045ee <pipeclose+0x42>
    pi->writeopen = 0;
    800045c4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800045c8:	21848513          	addi	a0,s1,536
    800045cc:	9bbfd0ef          	jal	80001f86 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800045d0:	2204a783          	lw	a5,544(s1)
    800045d4:	e781                	bnez	a5,800045dc <pipeclose+0x30>
    800045d6:	2244a783          	lw	a5,548(s1)
    800045da:	c38d                	beqz	a5,800045fc <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    800045dc:	8526                	mv	a0,s1
    800045de:	e92fc0ef          	jal	80000c70 <release>
}
    800045e2:	60e2                	ld	ra,24(sp)
    800045e4:	6442                	ld	s0,16(sp)
    800045e6:	64a2                	ld	s1,8(sp)
    800045e8:	6902                	ld	s2,0(sp)
    800045ea:	6105                	addi	sp,sp,32
    800045ec:	8082                	ret
    pi->readopen = 0;
    800045ee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045f2:	21c48513          	addi	a0,s1,540
    800045f6:	991fd0ef          	jal	80001f86 <wakeup>
    800045fa:	bfd9                	j	800045d0 <pipeclose+0x24>
    release(&pi->lock);
    800045fc:	8526                	mv	a0,s1
    800045fe:	e72fc0ef          	jal	80000c70 <release>
    kfree((char *)pi);
    80004602:	8526                	mv	a0,s1
    80004604:	c22fc0ef          	jal	80000a26 <kfree>
    80004608:	bfe9                	j	800045e2 <pipeclose+0x36>

000000008000460a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000460a:	7159                	addi	sp,sp,-112
    8000460c:	f486                	sd	ra,104(sp)
    8000460e:	f0a2                	sd	s0,96(sp)
    80004610:	eca6                	sd	s1,88(sp)
    80004612:	e8ca                	sd	s2,80(sp)
    80004614:	e4ce                	sd	s3,72(sp)
    80004616:	e0d2                	sd	s4,64(sp)
    80004618:	fc56                	sd	s5,56(sp)
    8000461a:	1880                	addi	s0,sp,112
    8000461c:	84aa                	mv	s1,a0
    8000461e:	8aae                	mv	s5,a1
    80004620:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004622:	ae6fd0ef          	jal	80001908 <myproc>
    80004626:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004628:	8526                	mv	a0,s1
    8000462a:	dbefc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    8000462e:	0f405a63          	blez	s4,80004722 <pipewrite+0x118>
    80004632:	f85a                	sd	s6,48(sp)
    80004634:	f45e                	sd	s7,40(sp)
    80004636:	f062                	sd	s8,32(sp)
    80004638:	ec66                	sd	s9,24(sp)
    8000463a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000463c:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    8000463e:	f9f40c13          	addi	s8,s0,-97
    80004642:	4b85                	li	s7,1
    80004644:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004646:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    8000464a:	21c48c93          	addi	s9,s1,540
    8000464e:	a0a1                	j	80004696 <pipewrite+0x8c>
      release(&pi->lock);
    80004650:	8526                	mv	a0,s1
    80004652:	e1efc0ef          	jal	80000c70 <release>
      return -1;
    80004656:	597d                	li	s2,-1
    80004658:	7b42                	ld	s6,48(sp)
    8000465a:	7ba2                	ld	s7,40(sp)
    8000465c:	7c02                	ld	s8,32(sp)
    8000465e:	6ce2                	ld	s9,24(sp)
    80004660:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004662:	854a                	mv	a0,s2
    80004664:	70a6                	ld	ra,104(sp)
    80004666:	7406                	ld	s0,96(sp)
    80004668:	64e6                	ld	s1,88(sp)
    8000466a:	6946                	ld	s2,80(sp)
    8000466c:	69a6                	ld	s3,72(sp)
    8000466e:	6a06                	ld	s4,64(sp)
    80004670:	7ae2                	ld	s5,56(sp)
    80004672:	6165                	addi	sp,sp,112
    80004674:	8082                	ret
      wakeup(&pi->nread);
    80004676:	856a                	mv	a0,s10
    80004678:	90ffd0ef          	jal	80001f86 <wakeup>
      sleep_prepare(&pi->nwrite);
    8000467c:	8566                	mv	a0,s9
    8000467e:	89dfd0ef          	jal	80001f1a <sleep_prepare>
      release(&pi->lock);
    80004682:	8526                	mv	a0,s1
    80004684:	decfc0ef          	jal	80000c70 <release>
      sleep();
    80004688:	8cffd0ef          	jal	80001f56 <sleep>
      acquire(&pi->lock);
    8000468c:	8526                	mv	a0,s1
    8000468e:	d5afc0ef          	jal	80000be8 <acquire>
  while (i < n) {
    80004692:	07495b63          	bge	s2,s4,80004708 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004696:	2204a783          	lw	a5,544(s1)
    8000469a:	dbdd                	beqz	a5,80004650 <pipewrite+0x46>
    8000469c:	854e                	mv	a0,s3
    8000469e:	adbfd0ef          	jal	80002178 <killed>
    800046a2:	f55d                	bnez	a0,80004650 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    800046a4:	2184a783          	lw	a5,536(s1)
    800046a8:	21c4a703          	lw	a4,540(s1)
    800046ac:	2007879b          	addiw	a5,a5,512
    800046b0:	fcf703e3          	beq	a4,a5,80004676 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800046b4:	875e                	mv	a4,s7
    800046b6:	015906b3          	add	a3,s2,s5
    800046ba:	8662                	mv	a2,s8
    800046bc:	0489b583          	ld	a1,72(s3)
    800046c0:	0509b503          	ld	a0,80(s3)
    800046c4:	f45fc0ef          	jal	80001608 <copyin>
    800046c8:	03650163          	beq	a0,s6,800046ea <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800046cc:	21c4a783          	lw	a5,540(s1)
    800046d0:	0017871b          	addiw	a4,a5,1
    800046d4:	20e4ae23          	sw	a4,540(s1)
    800046d8:	1ff7f793          	andi	a5,a5,511
    800046dc:	97a6                	add	a5,a5,s1
    800046de:	f9f44703          	lbu	a4,-97(s0)
    800046e2:	00e78c23          	sb	a4,24(a5)
      i++;
    800046e6:	2905                	addiw	s2,s2,1
    800046e8:	b76d                	j	80004692 <pipewrite+0x88>
        if (i == 0)
    800046ea:	00090863          	beqz	s2,800046fa <pipewrite+0xf0>
    800046ee:	7b42                	ld	s6,48(sp)
    800046f0:	7ba2                	ld	s7,40(sp)
    800046f2:	7c02                	ld	s8,32(sp)
    800046f4:	6ce2                	ld	s9,24(sp)
    800046f6:	6d42                	ld	s10,16(sp)
    800046f8:	a829                	j	80004712 <pipewrite+0x108>
          i = -1;
    800046fa:	892a                	mv	s2,a0
        break;
    800046fc:	7b42                	ld	s6,48(sp)
    800046fe:	7ba2                	ld	s7,40(sp)
    80004700:	7c02                	ld	s8,32(sp)
    80004702:	6ce2                	ld	s9,24(sp)
    80004704:	6d42                	ld	s10,16(sp)
    80004706:	a031                	j	80004712 <pipewrite+0x108>
    80004708:	7b42                	ld	s6,48(sp)
    8000470a:	7ba2                	ld	s7,40(sp)
    8000470c:	7c02                	ld	s8,32(sp)
    8000470e:	6ce2                	ld	s9,24(sp)
    80004710:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004712:	21848513          	addi	a0,s1,536
    80004716:	871fd0ef          	jal	80001f86 <wakeup>
  release(&pi->lock);
    8000471a:	8526                	mv	a0,s1
    8000471c:	d54fc0ef          	jal	80000c70 <release>
  return i;
    80004720:	b789                	j	80004662 <pipewrite+0x58>
  int i = 0;
    80004722:	4901                	li	s2,0
    80004724:	b7fd                	j	80004712 <pipewrite+0x108>

0000000080004726 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004726:	711d                	addi	sp,sp,-96
    80004728:	ec86                	sd	ra,88(sp)
    8000472a:	e8a2                	sd	s0,80(sp)
    8000472c:	e4a6                	sd	s1,72(sp)
    8000472e:	e0ca                	sd	s2,64(sp)
    80004730:	fc4e                	sd	s3,56(sp)
    80004732:	f852                	sd	s4,48(sp)
    80004734:	f456                	sd	s5,40(sp)
    80004736:	1080                	addi	s0,sp,96
    80004738:	84aa                	mv	s1,a0
    8000473a:	89ae                	mv	s3,a1
    8000473c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000473e:	9cafd0ef          	jal	80001908 <myproc>
    80004742:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004744:	8526                	mv	a0,s1
    80004746:	ca2fc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000474a:	2184a703          	lw	a4,536(s1)
    8000474e:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004752:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004756:	02f71e63          	bne	a4,a5,80004792 <piperead+0x6c>
    8000475a:	2244a783          	lw	a5,548(s1)
    8000475e:	c3b9                	beqz	a5,800047a4 <piperead+0x7e>
    if (killed(pr)) {
    80004760:	854a                	mv	a0,s2
    80004762:	a17fd0ef          	jal	80002178 <killed>
    80004766:	e915                	bnez	a0,8000479a <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004768:	8552                	mv	a0,s4
    8000476a:	fb0fd0ef          	jal	80001f1a <sleep_prepare>
    release(&pi->lock);
    8000476e:	8526                	mv	a0,s1
    80004770:	d00fc0ef          	jal	80000c70 <release>
    sleep();
    80004774:	fe2fd0ef          	jal	80001f56 <sleep>
    acquire(&pi->lock);
    80004778:	8526                	mv	a0,s1
    8000477a:	c6efc0ef          	jal	80000be8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000477e:	2184a703          	lw	a4,536(s1)
    80004782:	21c4a783          	lw	a5,540(s1)
    80004786:	fcf70ae3          	beq	a4,a5,8000475a <piperead+0x34>
    8000478a:	f05a                	sd	s6,32(sp)
    8000478c:	ec5e                	sd	s7,24(sp)
    8000478e:	e862                	sd	s8,16(sp)
    80004790:	a829                	j	800047aa <piperead+0x84>
    80004792:	f05a                	sd	s6,32(sp)
    80004794:	ec5e                	sd	s7,24(sp)
    80004796:	e862                	sd	s8,16(sp)
    80004798:	a809                	j	800047aa <piperead+0x84>
      release(&pi->lock);
    8000479a:	8526                	mv	a0,s1
    8000479c:	cd4fc0ef          	jal	80000c70 <release>
      return -1;
    800047a0:	5a7d                	li	s4,-1
    800047a2:	a0b5                	j	8000480e <piperead+0xe8>
    800047a4:	f05a                	sd	s6,32(sp)
    800047a6:	ec5e                	sd	s7,24(sp)
    800047a8:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800047aa:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    800047ac:	faf40c13          	addi	s8,s0,-81
    800047b0:	4b85                	li	s7,1
    800047b2:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800047b4:	05505363          	blez	s5,800047fa <piperead+0xd4>
    if (pi->nread == pi->nwrite)
    800047b8:	2184a783          	lw	a5,536(s1)
    800047bc:	21c4a703          	lw	a4,540(s1)
    800047c0:	02f70d63          	beq	a4,a5,800047fa <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    800047c4:	1ff7f793          	andi	a5,a5,511
    800047c8:	97a6                	add	a5,a5,s1
    800047ca:	0187c783          	lbu	a5,24(a5)
    800047ce:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    800047d2:	875e                	mv	a4,s7
    800047d4:	86e2                	mv	a3,s8
    800047d6:	864e                	mv	a2,s3
    800047d8:	04893583          	ld	a1,72(s2)
    800047dc:	05093503          	ld	a0,80(s2)
    800047e0:	d63fc0ef          	jal	80001542 <copyout>
    800047e4:	03650f63          	beq	a0,s6,80004822 <piperead+0xfc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800047e8:	2184a783          	lw	a5,536(s1)
    800047ec:	2785                	addiw	a5,a5,1
    800047ee:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800047f2:	2a05                	addiw	s4,s4,1
    800047f4:	0985                	addi	s3,s3,1
    800047f6:	fd4a91e3          	bne	s5,s4,800047b8 <piperead+0x92>
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800047fa:	21c48513          	addi	a0,s1,540
    800047fe:	f88fd0ef          	jal	80001f86 <wakeup>
  release(&pi->lock);
    80004802:	8526                	mv	a0,s1
    80004804:	c6cfc0ef          	jal	80000c70 <release>
    80004808:	7b02                	ld	s6,32(sp)
    8000480a:	6be2                	ld	s7,24(sp)
    8000480c:	6c42                	ld	s8,16(sp)
  return i;
}
    8000480e:	8552                	mv	a0,s4
    80004810:	60e6                	ld	ra,88(sp)
    80004812:	6446                	ld	s0,80(sp)
    80004814:	64a6                	ld	s1,72(sp)
    80004816:	6906                	ld	s2,64(sp)
    80004818:	79e2                	ld	s3,56(sp)
    8000481a:	7a42                	ld	s4,48(sp)
    8000481c:	7aa2                	ld	s5,40(sp)
    8000481e:	6125                	addi	sp,sp,96
    80004820:	8082                	ret
      if (i == 0)
    80004822:	fc0a1ce3          	bnez	s4,800047fa <piperead+0xd4>
        i = -1;
    80004826:	8a2a                	mv	s4,a0
    80004828:	bfc9                	j	800047fa <piperead+0xd4>

000000008000482a <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    8000482a:	1141                	addi	sp,sp,-16
    8000482c:	e406                	sd	ra,8(sp)
    8000482e:	e022                	sd	s0,0(sp)
    80004830:	0800                	addi	s0,sp,16
    80004832:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004834:	0035151b          	slliw	a0,a0,0x3
    80004838:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    8000483a:	8b89                	andi	a5,a5,2
    8000483c:	c399                	beqz	a5,80004842 <flags2perm+0x18>
    perm |= PTE_W;
    8000483e:	00456513          	ori	a0,a0,4
  return perm;
}
    80004842:	60a2                	ld	ra,8(sp)
    80004844:	6402                	ld	s0,0(sp)
    80004846:	0141                	addi	sp,sp,16
    80004848:	8082                	ret

000000008000484a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000484a:	de010113          	addi	sp,sp,-544
    8000484e:	20113c23          	sd	ra,536(sp)
    80004852:	20813823          	sd	s0,528(sp)
    80004856:	20913423          	sd	s1,520(sp)
    8000485a:	21213023          	sd	s2,512(sp)
    8000485e:	1400                	addi	s0,sp,544
    80004860:	892a                	mv	s2,a0
    80004862:	dea43823          	sd	a0,-528(s0)
    80004866:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000486a:	89efd0ef          	jal	80001908 <myproc>
    8000486e:	84aa                	mv	s1,a0

  begin_op();
    80004870:	c86ff0ef          	jal	80003cf6 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004874:	854a                	mv	a0,s2
    80004876:	aa2ff0ef          	jal	80003b18 <namei>
    8000487a:	cd21                	beqz	a0,800048d2 <kexec+0x88>
    8000487c:	fbd2                	sd	s4,496(sp)
    8000487e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004880:	a0dfe0ef          	jal	8000328c <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004884:	04000713          	li	a4,64
    80004888:	4681                	li	a3,0
    8000488a:	e5040613          	addi	a2,s0,-432
    8000488e:	4581                	li	a1,0
    80004890:	8552                	mv	a0,s4
    80004892:	dd5fe0ef          	jal	80003666 <readi>
    80004896:	04000793          	li	a5,64
    8000489a:	00f51a63          	bne	a0,a5,800048ae <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    8000489e:	e5042703          	lw	a4,-432(s0)
    800048a2:	464c47b7          	lui	a5,0x464c4
    800048a6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800048aa:	02f70863          	beq	a4,a5,800048da <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800048ae:	8552                	mv	a0,s4
    800048b0:	c31fe0ef          	jal	800034e0 <iunlockput>
    end_op();
    800048b4:	cceff0ef          	jal	80003d82 <end_op>
  }
  return -1;
    800048b8:	557d                	li	a0,-1
    800048ba:	7a5e                	ld	s4,496(sp)
}
    800048bc:	21813083          	ld	ra,536(sp)
    800048c0:	21013403          	ld	s0,528(sp)
    800048c4:	20813483          	ld	s1,520(sp)
    800048c8:	20013903          	ld	s2,512(sp)
    800048cc:	22010113          	addi	sp,sp,544
    800048d0:	8082                	ret
    end_op();
    800048d2:	cb0ff0ef          	jal	80003d82 <end_op>
    return -1;
    800048d6:	557d                	li	a0,-1
    800048d8:	b7d5                	j	800048bc <kexec+0x72>
    800048da:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    800048dc:	8526                	mv	a0,s1
    800048de:	930fd0ef          	jal	80001a0e <proc_pagetable>
    800048e2:	8b2a                	mv	s6,a0
    800048e4:	26050e63          	beqz	a0,80004b60 <kexec+0x316>
    800048e8:	ffce                	sd	s3,504(sp)
    800048ea:	f7d6                	sd	s5,488(sp)
    800048ec:	efde                	sd	s7,472(sp)
    800048ee:	ebe2                	sd	s8,464(sp)
    800048f0:	e7e6                	sd	s9,456(sp)
    800048f2:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048f4:	e8845783          	lhu	a5,-376(s0)
    800048f8:	14078263          	beqz	a5,80004a3c <kexec+0x1f2>
    800048fc:	ff6e                	sd	s11,440(sp)
    800048fe:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004902:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004904:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004906:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    8000490a:	6c85                	lui	s9,0x1
    8000490c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004910:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004914:	6a85                	lui	s5,0x1
    80004916:	a085                	j	80004976 <kexec+0x12c>
      panic("loadseg: address should exist");
    80004918:	00003517          	auipc	a0,0x3
    8000491c:	d6050513          	addi	a0,a0,-672 # 80007678 <etext+0x678>
    80004920:	f15fb0ef          	jal	80000834 <panic>
    if (sz - i < PGSIZE)
    80004924:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004926:	874a                	mv	a4,s2
    80004928:	009b86bb          	addw	a3,s7,s1
    8000492c:	4581                	li	a1,0
    8000492e:	8552                	mv	a0,s4
    80004930:	d37fe0ef          	jal	80003666 <readi>
    80004934:	22a91a63          	bne	s2,a0,80004b68 <kexec+0x31e>
  for (i = 0; i < sz; i += PGSIZE) {
    80004938:	009a84bb          	addw	s1,s5,s1
    8000493c:	0334f263          	bgeu	s1,s3,80004960 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004940:	02049593          	slli	a1,s1,0x20
    80004944:	9181                	srli	a1,a1,0x20
    80004946:	95e2                	add	a1,a1,s8
    80004948:	855a                	mv	a0,s6
    8000494a:	e8efc0ef          	jal	80000fd8 <walkaddr>
    8000494e:	862a                	mv	a2,a0
    if (pa == 0)
    80004950:	d561                	beqz	a0,80004918 <kexec+0xce>
    if (sz - i < PGSIZE)
    80004952:	409987bb          	subw	a5,s3,s1
    80004956:	893e                	mv	s2,a5
    80004958:	fcfcf6e3          	bgeu	s9,a5,80004924 <kexec+0xda>
    8000495c:	8956                	mv	s2,s5
    8000495e:	b7d9                	j	80004924 <kexec+0xda>
    sz = sz1;
    80004960:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004964:	2d05                	addiw	s10,s10,1
    80004966:	e0843783          	ld	a5,-504(s0)
    8000496a:	0387869b          	addiw	a3,a5,56
    8000496e:	e8845783          	lhu	a5,-376(s0)
    80004972:	06fd5d63          	bge	s10,a5,800049ec <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004976:	e0d43423          	sd	a3,-504(s0)
    8000497a:	876e                	mv	a4,s11
    8000497c:	e1840613          	addi	a2,s0,-488
    80004980:	4581                	li	a1,0
    80004982:	8552                	mv	a0,s4
    80004984:	ce3fe0ef          	jal	80003666 <readi>
    80004988:	1db51e63          	bne	a0,s11,80004b64 <kexec+0x31a>
    if (ph.type != ELF_PROG_LOAD)
    8000498c:	e1842783          	lw	a5,-488(s0)
    80004990:	4705                	li	a4,1
    80004992:	fce799e3          	bne	a5,a4,80004964 <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    80004996:	e4043483          	ld	s1,-448(s0)
    8000499a:	e3843783          	ld	a5,-456(s0)
    8000499e:	1ef4e363          	bltu	s1,a5,80004b84 <kexec+0x33a>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800049a2:	e2843783          	ld	a5,-472(s0)
    800049a6:	94be                	add	s1,s1,a5
    800049a8:	1ef4e163          	bltu	s1,a5,80004b8a <kexec+0x340>
    if (ph.vaddr % PGSIZE != 0)
    800049ac:	de843703          	ld	a4,-536(s0)
    800049b0:	8ff9                	and	a5,a5,a4
    800049b2:	1c079f63          	bnez	a5,80004b90 <kexec+0x346>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800049b6:	e1c42503          	lw	a0,-484(s0)
    800049ba:	e71ff0ef          	jal	8000482a <flags2perm>
    800049be:	86aa                	mv	a3,a0
    800049c0:	8626                	mv	a2,s1
    800049c2:	85ca                	mv	a1,s2
    800049c4:	855a                	mv	a0,s6
    800049c6:	8e9fc0ef          	jal	800012ae <uvmalloc>
    800049ca:	dea43c23          	sd	a0,-520(s0)
    800049ce:	1c050463          	beqz	a0,80004b96 <kexec+0x34c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800049d2:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800049d6:	00098863          	beqz	s3,800049e6 <kexec+0x19c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800049da:	e2843c03          	ld	s8,-472(s0)
    800049de:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800049e2:	4481                	li	s1,0
    800049e4:	bfb1                	j	80004940 <kexec+0xf6>
    sz = sz1;
    800049e6:	df843903          	ld	s2,-520(s0)
    800049ea:	bfad                	j	80004964 <kexec+0x11a>
    800049ec:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    800049ee:	8552                	mv	a0,s4
    800049f0:	af1fe0ef          	jal	800034e0 <iunlockput>
  end_op();
    800049f4:	b8eff0ef          	jal	80003d82 <end_op>
  p = myproc();
    800049f8:	f11fc0ef          	jal	80001908 <myproc>
    800049fc:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    800049fe:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    80004a02:	6c05                	lui	s8,0x1
    80004a04:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    80004a06:	9c4a                	add	s8,s8,s2
    80004a08:	77fd                	lui	a5,0xfffff
    80004a0a:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004a0e:	4691                	li	a3,4
    80004a10:	6609                	lui	a2,0x2
    80004a12:	9662                	add	a2,a2,s8
    80004a14:	85e2                	mv	a1,s8
    80004a16:	855a                	mv	a0,s6
    80004a18:	897fc0ef          	jal	800012ae <uvmalloc>
    80004a1c:	892a                	mv	s2,a0
    80004a1e:	e10d                	bnez	a0,80004a40 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    80004a20:	85e2                	mv	a1,s8
    80004a22:	855a                	mv	a0,s6
    80004a24:	86efd0ef          	jal	80001a92 <proc_freepagetable>
  return -1;
    80004a28:	557d                	li	a0,-1
    80004a2a:	79fe                	ld	s3,504(sp)
    80004a2c:	7a5e                	ld	s4,496(sp)
    80004a2e:	7abe                	ld	s5,488(sp)
    80004a30:	7b1e                	ld	s6,480(sp)
    80004a32:	6bfe                	ld	s7,472(sp)
    80004a34:	6c5e                	ld	s8,464(sp)
    80004a36:	6cbe                	ld	s9,456(sp)
    80004a38:	6d1e                	ld	s10,448(sp)
    80004a3a:	b549                	j	800048bc <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a3c:	4901                	li	s2,0
    80004a3e:	bf45                	j	800049ee <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004a40:	75f9                	lui	a1,0xffffe
    80004a42:	95aa                	add	a1,a1,a0
    80004a44:	855a                	mv	a0,s6
    80004a46:	a3bfc0ef          	jal	80001480 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004a4a:	80090a13          	addi	s4,s2,-2048
    80004a4e:	800a0a13          	addi	s4,s4,-2048
  for (argc = 0; argv[argc]; argc++) {
    80004a52:	e0043783          	ld	a5,-512(s0)
    80004a56:	6388                	ld	a0,0(a5)
    80004a58:	c545                	beqz	a0,80004b00 <kexec+0x2b6>
  sp = sz;
    80004a5a:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004a5c:	4481                	li	s1,0
    ustack[argc] = sp;
    80004a5e:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004a62:	bd0fc0ef          	jal	80000e32 <strlen>
    80004a66:	0015079b          	addiw	a5,a0,1
    80004a6a:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a6e:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004a72:	134c6563          	bltu	s8,s4,80004b9c <kexec+0x352>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a76:	e0043d03          	ld	s10,-512(s0)
    80004a7a:	000d3c83          	ld	s9,0(s10)
    80004a7e:	8566                	mv	a0,s9
    80004a80:	bb2fc0ef          	jal	80000e32 <strlen>
    80004a84:	0015071b          	addiw	a4,a0,1
    80004a88:	86e6                	mv	a3,s9
    80004a8a:	8662                	mv	a2,s8
    80004a8c:	85ca                	mv	a1,s2
    80004a8e:	855a                	mv	a0,s6
    80004a90:	ab3fc0ef          	jal	80001542 <copyout>
    80004a94:	10054663          	bltz	a0,80004ba0 <kexec+0x356>
    ustack[argc] = sp;
    80004a98:	00349793          	slli	a5,s1,0x3
    80004a9c:	97de                	add	a5,a5,s7
    80004a9e:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb650>
  for (argc = 0; argv[argc]; argc++) {
    80004aa2:	0485                	addi	s1,s1,1
    80004aa4:	008d0793          	addi	a5,s10,8
    80004aa8:	e0f43023          	sd	a5,-512(s0)
    80004aac:	008d3503          	ld	a0,8(s10)
    80004ab0:	f94d                	bnez	a0,80004a62 <kexec+0x218>
  ustack[argc] = 0;
    80004ab2:	00349793          	slli	a5,s1,0x3
    80004ab6:	f9078793          	addi	a5,a5,-112
    80004aba:	97a2                	add	a5,a5,s0
    80004abc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004ac0:	00349713          	slli	a4,s1,0x3
    80004ac4:	0721                	addi	a4,a4,8
    80004ac6:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    80004aca:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80004ace:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80004ad0:	f54be8e3          	bltu	s7,s4,80004a20 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004ad4:	e9040693          	addi	a3,s0,-368
    80004ad8:	865e                	mv	a2,s7
    80004ada:	85ca                	mv	a1,s2
    80004adc:	855a                	mv	a0,s6
    80004ade:	a65fc0ef          	jal	80001542 <copyout>
    80004ae2:	f2054fe3          	bltz	a0,80004a20 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004ae6:	0589b783          	ld	a5,88(s3)
    80004aea:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    80004aee:	df043783          	ld	a5,-528(s0)
    80004af2:	0007c703          	lbu	a4,0(a5)
    80004af6:	c30d                	beqz	a4,80004b18 <kexec+0x2ce>
    80004af8:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004afa:	02f00693          	li	a3,47
    80004afe:	a801                	j	80004b0e <kexec+0x2c4>
  sp = sz;
    80004b00:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80004b02:	4481                	li	s1,0
    80004b04:	b77d                	j	80004ab2 <kexec+0x268>
  for (last = s = path; *s; s++)
    80004b06:	0785                	addi	a5,a5,1
    80004b08:	fff7c703          	lbu	a4,-1(a5)
    80004b0c:	c711                	beqz	a4,80004b18 <kexec+0x2ce>
    if (*s == '/')
    80004b0e:	fed71ce3          	bne	a4,a3,80004b06 <kexec+0x2bc>
      last = s + 1;
    80004b12:	def43823          	sd	a5,-528(s0)
    80004b16:	bfc5                	j	80004b06 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b18:	4641                	li	a2,16
    80004b1a:	df043583          	ld	a1,-528(s0)
    80004b1e:	15898513          	addi	a0,s3,344
    80004b22:	adafc0ef          	jal	80000dfc <safestrcpy>
  oldpagetable = p->pagetable;
    80004b26:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004b2a:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004b2e:	0529b423          	sd	s2,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004b32:	0589b783          	ld	a5,88(s3)
    80004b36:	e6843703          	ld	a4,-408(s0)
    80004b3a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004b3c:	0589b783          	ld	a5,88(s3)
    80004b40:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b44:	85d6                	mv	a1,s5
    80004b46:	f4dfc0ef          	jal	80001a92 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b4a:	0004851b          	sext.w	a0,s1
    80004b4e:	79fe                	ld	s3,504(sp)
    80004b50:	7a5e                	ld	s4,496(sp)
    80004b52:	7abe                	ld	s5,488(sp)
    80004b54:	7b1e                	ld	s6,480(sp)
    80004b56:	6bfe                	ld	s7,472(sp)
    80004b58:	6c5e                	ld	s8,464(sp)
    80004b5a:	6cbe                	ld	s9,456(sp)
    80004b5c:	6d1e                	ld	s10,448(sp)
    80004b5e:	bbb9                	j	800048bc <kexec+0x72>
    80004b60:	7b1e                	ld	s6,480(sp)
    80004b62:	b3b1                	j	800048ae <kexec+0x64>
    80004b64:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004b68:	df843583          	ld	a1,-520(s0)
    80004b6c:	855a                	mv	a0,s6
    80004b6e:	f25fc0ef          	jal	80001a92 <proc_freepagetable>
  if (ip) {
    80004b72:	79fe                	ld	s3,504(sp)
    80004b74:	7abe                	ld	s5,488(sp)
    80004b76:	7b1e                	ld	s6,480(sp)
    80004b78:	6bfe                	ld	s7,472(sp)
    80004b7a:	6c5e                	ld	s8,464(sp)
    80004b7c:	6cbe                	ld	s9,456(sp)
    80004b7e:	6d1e                	ld	s10,448(sp)
    80004b80:	7dfa                	ld	s11,440(sp)
    80004b82:	b335                	j	800048ae <kexec+0x64>
    80004b84:	df243c23          	sd	s2,-520(s0)
    80004b88:	b7c5                	j	80004b68 <kexec+0x31e>
    80004b8a:	df243c23          	sd	s2,-520(s0)
    80004b8e:	bfe9                	j	80004b68 <kexec+0x31e>
    80004b90:	df243c23          	sd	s2,-520(s0)
    80004b94:	bfd1                	j	80004b68 <kexec+0x31e>
    80004b96:	df243c23          	sd	s2,-520(s0)
    80004b9a:	b7f9                	j	80004b68 <kexec+0x31e>
  sz = sz1;
    80004b9c:	8c4a                	mv	s8,s2
    80004b9e:	b549                	j	80004a20 <kexec+0x1d6>
    80004ba0:	8c4a                	mv	s8,s2
    80004ba2:	bdbd                	j	80004a20 <kexec+0x1d6>

0000000080004ba4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ba4:	7179                	addi	sp,sp,-48
    80004ba6:	f406                	sd	ra,40(sp)
    80004ba8:	f022                	sd	s0,32(sp)
    80004baa:	ec26                	sd	s1,24(sp)
    80004bac:	e84a                	sd	s2,16(sp)
    80004bae:	1800                	addi	s0,sp,48
    80004bb0:	892e                	mv	s2,a1
    80004bb2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004bb4:	fdc40593          	addi	a1,s0,-36
    80004bb8:	ca1fd0ef          	jal	80002858 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004bbc:	fdc42703          	lw	a4,-36(s0)
    80004bc0:	47bd                	li	a5,15
    80004bc2:	02e7ea63          	bltu	a5,a4,80004bf6 <argfd+0x52>
    80004bc6:	d43fc0ef          	jal	80001908 <myproc>
    80004bca:	fdc42703          	lw	a4,-36(s0)
    80004bce:	00371793          	slli	a5,a4,0x3
    80004bd2:	0d078793          	addi	a5,a5,208
    80004bd6:	953e                	add	a0,a0,a5
    80004bd8:	611c                	ld	a5,0(a0)
    80004bda:	c385                	beqz	a5,80004bfa <argfd+0x56>
    return -1;
  if (pfd)
    80004bdc:	00090463          	beqz	s2,80004be4 <argfd+0x40>
    *pfd = fd;
    80004be0:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004be4:	4501                	li	a0,0
  if (pf)
    80004be6:	c091                	beqz	s1,80004bea <argfd+0x46>
    *pf = f;
    80004be8:	e09c                	sd	a5,0(s1)
}
    80004bea:	70a2                	ld	ra,40(sp)
    80004bec:	7402                	ld	s0,32(sp)
    80004bee:	64e2                	ld	s1,24(sp)
    80004bf0:	6942                	ld	s2,16(sp)
    80004bf2:	6145                	addi	sp,sp,48
    80004bf4:	8082                	ret
    return -1;
    80004bf6:	557d                	li	a0,-1
    80004bf8:	bfcd                	j	80004bea <argfd+0x46>
    80004bfa:	557d                	li	a0,-1
    80004bfc:	b7fd                	j	80004bea <argfd+0x46>

0000000080004bfe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004bfe:	1101                	addi	sp,sp,-32
    80004c00:	ec06                	sd	ra,24(sp)
    80004c02:	e822                	sd	s0,16(sp)
    80004c04:	e426                	sd	s1,8(sp)
    80004c06:	1000                	addi	s0,sp,32
    80004c08:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c0a:	cfffc0ef          	jal	80001908 <myproc>
    80004c0e:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004c10:	0d050793          	addi	a5,a0,208
    80004c14:	4501                	li	a0,0
    80004c16:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004c18:	6398                	ld	a4,0(a5)
    80004c1a:	cb19                	beqz	a4,80004c30 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004c1c:	2505                	addiw	a0,a0,1
    80004c1e:	07a1                	addi	a5,a5,8
    80004c20:	fed51ce3          	bne	a0,a3,80004c18 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c24:	557d                	li	a0,-1
}
    80004c26:	60e2                	ld	ra,24(sp)
    80004c28:	6442                	ld	s0,16(sp)
    80004c2a:	64a2                	ld	s1,8(sp)
    80004c2c:	6105                	addi	sp,sp,32
    80004c2e:	8082                	ret
      p->ofile[fd] = f;
    80004c30:	00351793          	slli	a5,a0,0x3
    80004c34:	0d078793          	addi	a5,a5,208
    80004c38:	963e                	add	a2,a2,a5
    80004c3a:	e204                	sd	s1,0(a2)
      return fd;
    80004c3c:	b7ed                	j	80004c26 <fdalloc+0x28>

0000000080004c3e <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004c3e:	715d                	addi	sp,sp,-80
    80004c40:	e486                	sd	ra,72(sp)
    80004c42:	e0a2                	sd	s0,64(sp)
    80004c44:	fc26                	sd	s1,56(sp)
    80004c46:	f84a                	sd	s2,48(sp)
    80004c48:	f052                	sd	s4,32(sp)
    80004c4a:	ec56                	sd	s5,24(sp)
    80004c4c:	e85a                	sd	s6,16(sp)
    80004c4e:	0880                	addi	s0,sp,80
    80004c50:	8a2e                	mv	s4,a1
    80004c52:	8ab2                	mv	s5,a2
    80004c54:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004c56:	fb040593          	addi	a1,s0,-80
    80004c5a:	ed9fe0ef          	jal	80003b32 <nameiparent>
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	12050f63          	beqz	a0,80004d9e <create+0x160>
    return 0;

  ilock(dp);
    80004c64:	e28fe0ef          	jal	8000328c <ilock>

  if (dp->nlink == 0) {
    80004c68:	04a49783          	lh	a5,74(s1)
    80004c6c:	cbb9                	beqz	a5,80004cc2 <create+0x84>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004c6e:	7761                	lui	a4,0xffff8
    80004c70:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd4651>
    80004c72:	97ba                	add	a5,a5,a4
    80004c74:	e781                	bnez	a5,80004c7c <create+0x3e>
    80004c76:	fffa0793          	addi	a5,s4,-1
    80004c7a:	cba9                	beqz	a5,80004ccc <create+0x8e>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004c7c:	4601                	li	a2,0
    80004c7e:	fb040593          	addi	a1,s0,-80
    80004c82:	8526                	mv	a0,s1
    80004c84:	bf1fe0ef          	jal	80003874 <dirlookup>
    80004c88:	892a                	mv	s2,a0
    80004c8a:	c939                	beqz	a0,80004ce0 <create+0xa2>
    iunlockput(dp);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	853fe0ef          	jal	800034e0 <iunlockput>
    ilock(ip);
    80004c92:	854a                	mv	a0,s2
    80004c94:	df8fe0ef          	jal	8000328c <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c98:	4789                	li	a5,2
    80004c9a:	02fa1e63          	bne	s4,a5,80004cd6 <create+0x98>
    80004c9e:	04495783          	lhu	a5,68(s2)
    80004ca2:	37f9                	addiw	a5,a5,-2
    80004ca4:	17c2                	slli	a5,a5,0x30
    80004ca6:	93c1                	srli	a5,a5,0x30
    80004ca8:	4705                	li	a4,1
    80004caa:	02f76663          	bltu	a4,a5,80004cd6 <create+0x98>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004cae:	854a                	mv	a0,s2
    80004cb0:	60a6                	ld	ra,72(sp)
    80004cb2:	6406                	ld	s0,64(sp)
    80004cb4:	74e2                	ld	s1,56(sp)
    80004cb6:	7942                	ld	s2,48(sp)
    80004cb8:	7a02                	ld	s4,32(sp)
    80004cba:	6ae2                	ld	s5,24(sp)
    80004cbc:	6b42                	ld	s6,16(sp)
    80004cbe:	6161                	addi	sp,sp,80
    80004cc0:	8082                	ret
    iunlockput(dp);
    80004cc2:	8526                	mv	a0,s1
    80004cc4:	81dfe0ef          	jal	800034e0 <iunlockput>
    return 0;
    80004cc8:	4901                	li	s2,0
    80004cca:	b7d5                	j	80004cae <create+0x70>
    iunlockput(dp);
    80004ccc:	8526                	mv	a0,s1
    80004cce:	813fe0ef          	jal	800034e0 <iunlockput>
    return 0;
    80004cd2:	4901                	li	s2,0
    80004cd4:	bfe9                	j	80004cae <create+0x70>
    iunlockput(ip);
    80004cd6:	854a                	mv	a0,s2
    80004cd8:	809fe0ef          	jal	800034e0 <iunlockput>
    return 0;
    80004cdc:	4901                	li	s2,0
    80004cde:	bfc1                	j	80004cae <create+0x70>
    80004ce0:	f44e                	sd	s3,40(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004ce2:	85d2                	mv	a1,s4
    80004ce4:	4088                	lw	a0,0(s1)
    80004ce6:	c36fe0ef          	jal	8000311c <ialloc>
    80004cea:	89aa                	mv	s3,a0
    80004cec:	cd1d                	beqz	a0,80004d2a <create+0xec>
  ilock(ip);
    80004cee:	d9efe0ef          	jal	8000328c <ilock>
  ip->major = major;
    80004cf2:	05599323          	sh	s5,70(s3)
  ip->minor = minor;
    80004cf6:	05699423          	sh	s6,72(s3)
  ip->nlink = 1;
    80004cfa:	4705                	li	a4,1
    80004cfc:	04e99523          	sh	a4,74(s3)
  iupdate(ip);
    80004d00:	854e                	mv	a0,s3
    80004d02:	cd6fe0ef          	jal	800031d8 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004d06:	4705                	li	a4,1
    80004d08:	02ea0763          	beq	s4,a4,80004d36 <create+0xf8>
  if (dirlink(dp, name, ip->inum) < 0)
    80004d0c:	0049a603          	lw	a2,4(s3)
    80004d10:	fb040593          	addi	a1,s0,-80
    80004d14:	8526                	mv	a0,s1
    80004d16:	d59fe0ef          	jal	80003a6e <dirlink>
    80004d1a:	06054563          	bltz	a0,80004d84 <create+0x146>
  iunlockput(dp);
    80004d1e:	8526                	mv	a0,s1
    80004d20:	fc0fe0ef          	jal	800034e0 <iunlockput>
  return ip;
    80004d24:	894e                	mv	s2,s3
    80004d26:	79a2                	ld	s3,40(sp)
    80004d28:	b759                	j	80004cae <create+0x70>
    iunlockput(dp);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	fb4fe0ef          	jal	800034e0 <iunlockput>
    return 0;
    80004d30:	894e                	mv	s2,s3
    80004d32:	79a2                	ld	s3,40(sp)
    80004d34:	bfad                	j	80004cae <create+0x70>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d36:	0049a603          	lw	a2,4(s3)
    80004d3a:	00003597          	auipc	a1,0x3
    80004d3e:	95e58593          	addi	a1,a1,-1698 # 80007698 <etext+0x698>
    80004d42:	854e                	mv	a0,s3
    80004d44:	d2bfe0ef          	jal	80003a6e <dirlink>
    80004d48:	02054e63          	bltz	a0,80004d84 <create+0x146>
    80004d4c:	40d0                	lw	a2,4(s1)
    80004d4e:	00003597          	auipc	a1,0x3
    80004d52:	95258593          	addi	a1,a1,-1710 # 800076a0 <etext+0x6a0>
    80004d56:	854e                	mv	a0,s3
    80004d58:	d17fe0ef          	jal	80003a6e <dirlink>
    80004d5c:	02054463          	bltz	a0,80004d84 <create+0x146>
  if (dirlink(dp, name, ip->inum) < 0)
    80004d60:	0049a603          	lw	a2,4(s3)
    80004d64:	fb040593          	addi	a1,s0,-80
    80004d68:	8526                	mv	a0,s1
    80004d6a:	d05fe0ef          	jal	80003a6e <dirlink>
    80004d6e:	00054b63          	bltz	a0,80004d84 <create+0x146>
    dp->nlink++; // for ".."
    80004d72:	04a4d783          	lhu	a5,74(s1)
    80004d76:	2785                	addiw	a5,a5,1
    80004d78:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	c5afe0ef          	jal	800031d8 <iupdate>
    80004d82:	bf71                	j	80004d1e <create+0xe0>
  ip->nlink = 0;
    80004d84:	04099523          	sh	zero,74(s3)
  iupdate(ip);
    80004d88:	854e                	mv	a0,s3
    80004d8a:	c4efe0ef          	jal	800031d8 <iupdate>
  iunlockput(ip);
    80004d8e:	854e                	mv	a0,s3
    80004d90:	f50fe0ef          	jal	800034e0 <iunlockput>
  iunlockput(dp);
    80004d94:	8526                	mv	a0,s1
    80004d96:	f4afe0ef          	jal	800034e0 <iunlockput>
  return 0;
    80004d9a:	79a2                	ld	s3,40(sp)
    80004d9c:	bf09                	j	80004cae <create+0x70>
    return 0;
    80004d9e:	892a                	mv	s2,a0
    80004da0:	b739                	j	80004cae <create+0x70>

0000000080004da2 <sys_dup>:
{
    80004da2:	7179                	addi	sp,sp,-48
    80004da4:	f406                	sd	ra,40(sp)
    80004da6:	f022                	sd	s0,32(sp)
    80004da8:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004daa:	fd840613          	addi	a2,s0,-40
    80004dae:	4581                	li	a1,0
    80004db0:	4501                	li	a0,0
    80004db2:	df3ff0ef          	jal	80004ba4 <argfd>
    return -1;
    80004db6:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004db8:	02054363          	bltz	a0,80004dde <sys_dup+0x3c>
    80004dbc:	ec26                	sd	s1,24(sp)
    80004dbe:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004dc0:	fd843483          	ld	s1,-40(s0)
    80004dc4:	8526                	mv	a0,s1
    80004dc6:	e39ff0ef          	jal	80004bfe <fdalloc>
    80004dca:	892a                	mv	s2,a0
    return -1;
    80004dcc:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004dce:	00054d63          	bltz	a0,80004de8 <sys_dup+0x46>
  filedup(f);
    80004dd2:	8526                	mv	a0,s1
    80004dd4:	b96ff0ef          	jal	8000416a <filedup>
  return fd;
    80004dd8:	87ca                	mv	a5,s2
    80004dda:	64e2                	ld	s1,24(sp)
    80004ddc:	6942                	ld	s2,16(sp)
}
    80004dde:	853e                	mv	a0,a5
    80004de0:	70a2                	ld	ra,40(sp)
    80004de2:	7402                	ld	s0,32(sp)
    80004de4:	6145                	addi	sp,sp,48
    80004de6:	8082                	ret
    80004de8:	64e2                	ld	s1,24(sp)
    80004dea:	6942                	ld	s2,16(sp)
    80004dec:	bfcd                	j	80004dde <sys_dup+0x3c>

0000000080004dee <sys_read>:
{
    80004dee:	7179                	addi	sp,sp,-48
    80004df0:	f406                	sd	ra,40(sp)
    80004df2:	f022                	sd	s0,32(sp)
    80004df4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004df6:	fd840593          	addi	a1,s0,-40
    80004dfa:	4505                	li	a0,1
    80004dfc:	a79fd0ef          	jal	80002874 <argaddr>
  argint(2, &n);
    80004e00:	fe440593          	addi	a1,s0,-28
    80004e04:	4509                	li	a0,2
    80004e06:	a53fd0ef          	jal	80002858 <argint>
  if (argfd(0, 0, &f) < 0)
    80004e0a:	fe840613          	addi	a2,s0,-24
    80004e0e:	4581                	li	a1,0
    80004e10:	4501                	li	a0,0
    80004e12:	d93ff0ef          	jal	80004ba4 <argfd>
    80004e16:	87aa                	mv	a5,a0
    return -1;
    80004e18:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004e1a:	0007ca63          	bltz	a5,80004e2e <sys_read+0x40>
  return fileread(f, p, n);
    80004e1e:	fe442603          	lw	a2,-28(s0)
    80004e22:	fd843583          	ld	a1,-40(s0)
    80004e26:	fe843503          	ld	a0,-24(s0)
    80004e2a:	caeff0ef          	jal	800042d8 <fileread>
}
    80004e2e:	70a2                	ld	ra,40(sp)
    80004e30:	7402                	ld	s0,32(sp)
    80004e32:	6145                	addi	sp,sp,48
    80004e34:	8082                	ret

0000000080004e36 <sys_write>:
{
    80004e36:	7179                	addi	sp,sp,-48
    80004e38:	f406                	sd	ra,40(sp)
    80004e3a:	f022                	sd	s0,32(sp)
    80004e3c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e3e:	fd840593          	addi	a1,s0,-40
    80004e42:	4505                	li	a0,1
    80004e44:	a31fd0ef          	jal	80002874 <argaddr>
  argint(2, &n);
    80004e48:	fe440593          	addi	a1,s0,-28
    80004e4c:	4509                	li	a0,2
    80004e4e:	a0bfd0ef          	jal	80002858 <argint>
  if (argfd(0, 0, &f) < 0)
    80004e52:	fe840613          	addi	a2,s0,-24
    80004e56:	4581                	li	a1,0
    80004e58:	4501                	li	a0,0
    80004e5a:	d4bff0ef          	jal	80004ba4 <argfd>
    80004e5e:	87aa                	mv	a5,a0
    return -1;
    80004e60:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004e62:	0007ca63          	bltz	a5,80004e76 <sys_write+0x40>
  return filewrite(f, p, n);
    80004e66:	fe442603          	lw	a2,-28(s0)
    80004e6a:	fd843583          	ld	a1,-40(s0)
    80004e6e:	fe843503          	ld	a0,-24(s0)
    80004e72:	d34ff0ef          	jal	800043a6 <filewrite>
}
    80004e76:	70a2                	ld	ra,40(sp)
    80004e78:	7402                	ld	s0,32(sp)
    80004e7a:	6145                	addi	sp,sp,48
    80004e7c:	8082                	ret

0000000080004e7e <sys_close>:
{
    80004e7e:	1101                	addi	sp,sp,-32
    80004e80:	ec06                	sd	ra,24(sp)
    80004e82:	e822                	sd	s0,16(sp)
    80004e84:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004e86:	fe040613          	addi	a2,s0,-32
    80004e8a:	fec40593          	addi	a1,s0,-20
    80004e8e:	4501                	li	a0,0
    80004e90:	d15ff0ef          	jal	80004ba4 <argfd>
    return -1;
    80004e94:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004e96:	02054163          	bltz	a0,80004eb8 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004e9a:	a6ffc0ef          	jal	80001908 <myproc>
    80004e9e:	fec42783          	lw	a5,-20(s0)
    80004ea2:	078e                	slli	a5,a5,0x3
    80004ea4:	0d078793          	addi	a5,a5,208
    80004ea8:	953e                	add	a0,a0,a5
    80004eaa:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004eae:	fe043503          	ld	a0,-32(s0)
    80004eb2:	afeff0ef          	jal	800041b0 <fileclose>
  return 0;
    80004eb6:	4781                	li	a5,0
}
    80004eb8:	853e                	mv	a0,a5
    80004eba:	60e2                	ld	ra,24(sp)
    80004ebc:	6442                	ld	s0,16(sp)
    80004ebe:	6105                	addi	sp,sp,32
    80004ec0:	8082                	ret

0000000080004ec2 <sys_fstat>:
{
    80004ec2:	1101                	addi	sp,sp,-32
    80004ec4:	ec06                	sd	ra,24(sp)
    80004ec6:	e822                	sd	s0,16(sp)
    80004ec8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004eca:	fe040593          	addi	a1,s0,-32
    80004ece:	4505                	li	a0,1
    80004ed0:	9a5fd0ef          	jal	80002874 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004ed4:	fe840613          	addi	a2,s0,-24
    80004ed8:	4581                	li	a1,0
    80004eda:	4501                	li	a0,0
    80004edc:	cc9ff0ef          	jal	80004ba4 <argfd>
    80004ee0:	87aa                	mv	a5,a0
    return -1;
    80004ee2:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004ee4:	0007c863          	bltz	a5,80004ef4 <sys_fstat+0x32>
  return filestat(f, st);
    80004ee8:	fe043583          	ld	a1,-32(s0)
    80004eec:	fe843503          	ld	a0,-24(s0)
    80004ef0:	b82ff0ef          	jal	80004272 <filestat>
}
    80004ef4:	60e2                	ld	ra,24(sp)
    80004ef6:	6442                	ld	s0,16(sp)
    80004ef8:	6105                	addi	sp,sp,32
    80004efa:	8082                	ret

0000000080004efc <sys_link>:
{
    80004efc:	7169                	addi	sp,sp,-304
    80004efe:	f606                	sd	ra,296(sp)
    80004f00:	f222                	sd	s0,288(sp)
    80004f02:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f04:	08000613          	li	a2,128
    80004f08:	ed040593          	addi	a1,s0,-304
    80004f0c:	4501                	li	a0,0
    80004f0e:	983fd0ef          	jal	80002890 <argstr>
    return -1;
    80004f12:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f14:	10054163          	bltz	a0,80005016 <sys_link+0x11a>
    80004f18:	08000613          	li	a2,128
    80004f1c:	f5040593          	addi	a1,s0,-176
    80004f20:	4505                	li	a0,1
    80004f22:	96ffd0ef          	jal	80002890 <argstr>
    return -1;
    80004f26:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f28:	0e054763          	bltz	a0,80005016 <sys_link+0x11a>
    80004f2c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f2e:	dc9fe0ef          	jal	80003cf6 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004f32:	ed040513          	addi	a0,s0,-304
    80004f36:	be3fe0ef          	jal	80003b18 <namei>
    80004f3a:	84aa                	mv	s1,a0
    80004f3c:	cd35                	beqz	a0,80004fb8 <sys_link+0xbc>
  ilock(ip);
    80004f3e:	b4efe0ef          	jal	8000328c <ilock>
  if (ip->type == T_DIR) {
    80004f42:	04449703          	lh	a4,68(s1)
    80004f46:	4785                	li	a5,1
    80004f48:	06f70d63          	beq	a4,a5,80004fc2 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    80004f4c:	04a49783          	lh	a5,74(s1)
    80004f50:	6721                	lui	a4,0x8
    80004f52:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80004f54:	06e78f63          	beq	a5,a4,80004fd2 <sys_link+0xd6>
    80004f58:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f5a:	2785                	addiw	a5,a5,1
    80004f5c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f60:	8526                	mv	a0,s1
    80004f62:	a76fe0ef          	jal	800031d8 <iupdate>
  iunlock(ip);
    80004f66:	8526                	mv	a0,s1
    80004f68:	bd2fe0ef          	jal	8000333a <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004f6c:	fd040593          	addi	a1,s0,-48
    80004f70:	f5040513          	addi	a0,s0,-176
    80004f74:	bbffe0ef          	jal	80003b32 <nameiparent>
    80004f78:	892a                	mv	s2,a0
    80004f7a:	c93d                	beqz	a0,80004ff0 <sys_link+0xf4>
  ilock(dp);
    80004f7c:	b10fe0ef          	jal	8000328c <ilock>
  if (dp->nlink == 0) {
    80004f80:	04a91783          	lh	a5,74(s2)
    80004f84:	cfb9                	beqz	a5,80004fe2 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004f86:	854a                	mv	a0,s2
    80004f88:	00092703          	lw	a4,0(s2)
    80004f8c:	409c                	lw	a5,0(s1)
    80004f8e:	04f71e63          	bne	a4,a5,80004fea <sys_link+0xee>
    80004f92:	40d0                	lw	a2,4(s1)
    80004f94:	fd040593          	addi	a1,s0,-48
    80004f98:	ad7fe0ef          	jal	80003a6e <dirlink>
    80004f9c:	04054763          	bltz	a0,80004fea <sys_link+0xee>
  iunlockput(dp);
    80004fa0:	854a                	mv	a0,s2
    80004fa2:	d3efe0ef          	jal	800034e0 <iunlockput>
  iput(ip);
    80004fa6:	8526                	mv	a0,s1
    80004fa8:	c66fe0ef          	jal	8000340e <iput>
  end_op();
    80004fac:	dd7fe0ef          	jal	80003d82 <end_op>
  return 0;
    80004fb0:	4781                	li	a5,0
    80004fb2:	64f2                	ld	s1,280(sp)
    80004fb4:	6952                	ld	s2,272(sp)
    80004fb6:	a085                	j	80005016 <sys_link+0x11a>
    end_op();
    80004fb8:	dcbfe0ef          	jal	80003d82 <end_op>
    return -1;
    80004fbc:	57fd                	li	a5,-1
    80004fbe:	64f2                	ld	s1,280(sp)
    80004fc0:	a899                	j	80005016 <sys_link+0x11a>
    iunlockput(ip);
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	d1cfe0ef          	jal	800034e0 <iunlockput>
    end_op();
    80004fc8:	dbbfe0ef          	jal	80003d82 <end_op>
    return -1;
    80004fcc:	57fd                	li	a5,-1
    80004fce:	64f2                	ld	s1,280(sp)
    80004fd0:	a099                	j	80005016 <sys_link+0x11a>
    iunlockput(ip);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	d0cfe0ef          	jal	800034e0 <iunlockput>
    end_op();
    80004fd8:	dabfe0ef          	jal	80003d82 <end_op>
    return -1;
    80004fdc:	57fd                	li	a5,-1
    80004fde:	64f2                	ld	s1,280(sp)
    80004fe0:	a81d                	j	80005016 <sys_link+0x11a>
    iunlockput(dp);
    80004fe2:	854a                	mv	a0,s2
    80004fe4:	cfcfe0ef          	jal	800034e0 <iunlockput>
    goto bad;
    80004fe8:	a021                	j	80004ff0 <sys_link+0xf4>
    iunlockput(dp);
    80004fea:	854a                	mv	a0,s2
    80004fec:	cf4fe0ef          	jal	800034e0 <iunlockput>
  ilock(ip);
    80004ff0:	8526                	mv	a0,s1
    80004ff2:	a9afe0ef          	jal	8000328c <ilock>
  ip->nlink--;
    80004ff6:	04a4d783          	lhu	a5,74(s1)
    80004ffa:	37fd                	addiw	a5,a5,-1
    80004ffc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005000:	8526                	mv	a0,s1
    80005002:	9d6fe0ef          	jal	800031d8 <iupdate>
  iunlockput(ip);
    80005006:	8526                	mv	a0,s1
    80005008:	cd8fe0ef          	jal	800034e0 <iunlockput>
  end_op();
    8000500c:	d77fe0ef          	jal	80003d82 <end_op>
  return -1;
    80005010:	57fd                	li	a5,-1
    80005012:	64f2                	ld	s1,280(sp)
    80005014:	6952                	ld	s2,272(sp)
}
    80005016:	853e                	mv	a0,a5
    80005018:	70b2                	ld	ra,296(sp)
    8000501a:	7412                	ld	s0,288(sp)
    8000501c:	6155                	addi	sp,sp,304
    8000501e:	8082                	ret

0000000080005020 <sys_unlink>:
{
    80005020:	7151                	addi	sp,sp,-240
    80005022:	f586                	sd	ra,232(sp)
    80005024:	f1a2                	sd	s0,224(sp)
    80005026:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80005028:	08000613          	li	a2,128
    8000502c:	f3040593          	addi	a1,s0,-208
    80005030:	4501                	li	a0,0
    80005032:	85ffd0ef          	jal	80002890 <argstr>
    80005036:	14054d63          	bltz	a0,80005190 <sys_unlink+0x170>
    8000503a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000503c:	cbbfe0ef          	jal	80003cf6 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80005040:	fb040593          	addi	a1,s0,-80
    80005044:	f3040513          	addi	a0,s0,-208
    80005048:	aebfe0ef          	jal	80003b32 <nameiparent>
    8000504c:	84aa                	mv	s1,a0
    8000504e:	c955                	beqz	a0,80005102 <sys_unlink+0xe2>
  ilock(dp);
    80005050:	a3cfe0ef          	jal	8000328c <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005054:	00002597          	auipc	a1,0x2
    80005058:	64458593          	addi	a1,a1,1604 # 80007698 <etext+0x698>
    8000505c:	fb040513          	addi	a0,s0,-80
    80005060:	ffefe0ef          	jal	8000385e <namecmp>
    80005064:	10050b63          	beqz	a0,8000517a <sys_unlink+0x15a>
    80005068:	00002597          	auipc	a1,0x2
    8000506c:	63858593          	addi	a1,a1,1592 # 800076a0 <etext+0x6a0>
    80005070:	fb040513          	addi	a0,s0,-80
    80005074:	feafe0ef          	jal	8000385e <namecmp>
    80005078:	10050163          	beqz	a0,8000517a <sys_unlink+0x15a>
    8000507c:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    8000507e:	f2c40613          	addi	a2,s0,-212
    80005082:	fb040593          	addi	a1,s0,-80
    80005086:	8526                	mv	a0,s1
    80005088:	fecfe0ef          	jal	80003874 <dirlookup>
    8000508c:	892a                	mv	s2,a0
    8000508e:	0e050563          	beqz	a0,80005178 <sys_unlink+0x158>
    80005092:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005094:	9f8fe0ef          	jal	8000328c <ilock>
  if (ip->nlink < 1)
    80005098:	04a91783          	lh	a5,74(s2)
    8000509c:	06f05863          	blez	a5,8000510c <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    800050a0:	04491703          	lh	a4,68(s2)
    800050a4:	4785                	li	a5,1
    800050a6:	06f70963          	beq	a4,a5,80005118 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800050aa:	fc040993          	addi	s3,s0,-64
    800050ae:	4641                	li	a2,16
    800050b0:	4581                	li	a1,0
    800050b2:	854e                	mv	a0,s3
    800050b4:	bf5fb0ef          	jal	80000ca8 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050b8:	4741                	li	a4,16
    800050ba:	f2c42683          	lw	a3,-212(s0)
    800050be:	864e                	mv	a2,s3
    800050c0:	4581                	li	a1,0
    800050c2:	8526                	mv	a0,s1
    800050c4:	e94fe0ef          	jal	80003758 <writei>
    800050c8:	47c1                	li	a5,16
    800050ca:	08f51863          	bne	a0,a5,8000515a <sys_unlink+0x13a>
  if (ip->type == T_DIR) {
    800050ce:	04491703          	lh	a4,68(s2)
    800050d2:	4785                	li	a5,1
    800050d4:	08f70963          	beq	a4,a5,80005166 <sys_unlink+0x146>
  iunlockput(dp);
    800050d8:	8526                	mv	a0,s1
    800050da:	c06fe0ef          	jal	800034e0 <iunlockput>
  ip->nlink--;
    800050de:	04a95783          	lhu	a5,74(s2)
    800050e2:	37fd                	addiw	a5,a5,-1
    800050e4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050e8:	854a                	mv	a0,s2
    800050ea:	8eefe0ef          	jal	800031d8 <iupdate>
  iunlockput(ip);
    800050ee:	854a                	mv	a0,s2
    800050f0:	bf0fe0ef          	jal	800034e0 <iunlockput>
  end_op();
    800050f4:	c8ffe0ef          	jal	80003d82 <end_op>
  return 0;
    800050f8:	4501                	li	a0,0
    800050fa:	64ee                	ld	s1,216(sp)
    800050fc:	694e                	ld	s2,208(sp)
    800050fe:	69ae                	ld	s3,200(sp)
    80005100:	a061                	j	80005188 <sys_unlink+0x168>
    end_op();
    80005102:	c81fe0ef          	jal	80003d82 <end_op>
    return -1;
    80005106:	557d                	li	a0,-1
    80005108:	64ee                	ld	s1,216(sp)
    8000510a:	a8bd                	j	80005188 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000510c:	00002517          	auipc	a0,0x2
    80005110:	59c50513          	addi	a0,a0,1436 # 800076a8 <etext+0x6a8>
    80005114:	f20fb0ef          	jal	80000834 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005118:	04c92703          	lw	a4,76(s2)
    8000511c:	02000793          	li	a5,32
    80005120:	f8e7f5e3          	bgeu	a5,a4,800050aa <sys_unlink+0x8a>
    80005124:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005126:	4741                	li	a4,16
    80005128:	86ce                	mv	a3,s3
    8000512a:	f1840613          	addi	a2,s0,-232
    8000512e:	4581                	li	a1,0
    80005130:	854a                	mv	a0,s2
    80005132:	d34fe0ef          	jal	80003666 <readi>
    80005136:	47c1                	li	a5,16
    80005138:	00f51b63          	bne	a0,a5,8000514e <sys_unlink+0x12e>
    if (de.inum != 0)
    8000513c:	f1845783          	lhu	a5,-232(s0)
    80005140:	ebb1                	bnez	a5,80005194 <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005142:	29c1                	addiw	s3,s3,16
    80005144:	04c92783          	lw	a5,76(s2)
    80005148:	fcf9efe3          	bltu	s3,a5,80005126 <sys_unlink+0x106>
    8000514c:	bfb9                	j	800050aa <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000514e:	00002517          	auipc	a0,0x2
    80005152:	57250513          	addi	a0,a0,1394 # 800076c0 <etext+0x6c0>
    80005156:	edefb0ef          	jal	80000834 <panic>
    panic("unlink: writei");
    8000515a:	00002517          	auipc	a0,0x2
    8000515e:	57e50513          	addi	a0,a0,1406 # 800076d8 <etext+0x6d8>
    80005162:	ed2fb0ef          	jal	80000834 <panic>
    dp->nlink--;
    80005166:	04a4d783          	lhu	a5,74(s1)
    8000516a:	37fd                	addiw	a5,a5,-1
    8000516c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005170:	8526                	mv	a0,s1
    80005172:	866fe0ef          	jal	800031d8 <iupdate>
    80005176:	b78d                	j	800050d8 <sys_unlink+0xb8>
    80005178:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000517a:	8526                	mv	a0,s1
    8000517c:	b64fe0ef          	jal	800034e0 <iunlockput>
  end_op();
    80005180:	c03fe0ef          	jal	80003d82 <end_op>
  return -1;
    80005184:	557d                	li	a0,-1
    80005186:	64ee                	ld	s1,216(sp)
}
    80005188:	70ae                	ld	ra,232(sp)
    8000518a:	740e                	ld	s0,224(sp)
    8000518c:	616d                	addi	sp,sp,240
    8000518e:	8082                	ret
    return -1;
    80005190:	557d                	li	a0,-1
    80005192:	bfdd                	j	80005188 <sys_unlink+0x168>
    iunlockput(ip);
    80005194:	854a                	mv	a0,s2
    80005196:	b4afe0ef          	jal	800034e0 <iunlockput>
    goto bad;
    8000519a:	694e                	ld	s2,208(sp)
    8000519c:	69ae                	ld	s3,200(sp)
    8000519e:	bff1                	j	8000517a <sys_unlink+0x15a>

00000000800051a0 <sys_open>:

uint64
sys_open(void)
{
    800051a0:	7131                	addi	sp,sp,-192
    800051a2:	fd06                	sd	ra,184(sp)
    800051a4:	f922                	sd	s0,176(sp)
    800051a6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800051a8:	f4c40593          	addi	a1,s0,-180
    800051ac:	4505                	li	a0,1
    800051ae:	eaafd0ef          	jal	80002858 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800051b2:	08000613          	li	a2,128
    800051b6:	f5040593          	addi	a1,s0,-176
    800051ba:	4501                	li	a0,0
    800051bc:	ed4fd0ef          	jal	80002890 <argstr>
    800051c0:	87aa                	mv	a5,a0
    return -1;
    800051c2:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    800051c4:	0a07c363          	bltz	a5,8000526a <sys_open+0xca>
    800051c8:	f526                	sd	s1,168(sp)

  begin_op();
    800051ca:	b2dfe0ef          	jal	80003cf6 <begin_op>

  if (omode & O_CREATE) {
    800051ce:	f4c42783          	lw	a5,-180(s0)
    800051d2:	2007f793          	andi	a5,a5,512
    800051d6:	c3dd                	beqz	a5,8000527c <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800051d8:	4681                	li	a3,0
    800051da:	4601                	li	a2,0
    800051dc:	4589                	li	a1,2
    800051de:	f5040513          	addi	a0,s0,-176
    800051e2:	a5dff0ef          	jal	80004c3e <create>
    800051e6:	84aa                	mv	s1,a0
    if (ip == 0) {
    800051e8:	c549                	beqz	a0,80005272 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800051ea:	04449703          	lh	a4,68(s1)
    800051ee:	478d                	li	a5,3
    800051f0:	00f71763          	bne	a4,a5,800051fe <sys_open+0x5e>
    800051f4:	0464d703          	lhu	a4,70(s1)
    800051f8:	47a5                	li	a5,9
    800051fa:	0ae7ee63          	bltu	a5,a4,800052b6 <sys_open+0x116>
    800051fe:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005200:	f0dfe0ef          	jal	8000410c <filealloc>
    80005204:	892a                	mv	s2,a0
    80005206:	c561                	beqz	a0,800052ce <sys_open+0x12e>
    80005208:	ed4e                	sd	s3,152(sp)
    8000520a:	9f5ff0ef          	jal	80004bfe <fdalloc>
    8000520e:	89aa                	mv	s3,a0
    80005210:	0a054b63          	bltz	a0,800052c6 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005214:	04449703          	lh	a4,68(s1)
    80005218:	478d                	li	a5,3
    8000521a:	0cf70363          	beq	a4,a5,800052e0 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000521e:	4789                	li	a5,2
    80005220:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005224:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005228:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000522c:	f4c42783          	lw	a5,-180(s0)
    80005230:	0017f713          	andi	a4,a5,1
    80005234:	00174713          	xori	a4,a4,1
    80005238:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000523c:	0037f713          	andi	a4,a5,3
    80005240:	00e03733          	snez	a4,a4
    80005244:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005248:	4007f793          	andi	a5,a5,1024
    8000524c:	c791                	beqz	a5,80005258 <sys_open+0xb8>
    8000524e:	04449703          	lh	a4,68(s1)
    80005252:	4789                	li	a5,2
    80005254:	08f70d63          	beq	a4,a5,800052ee <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005258:	8526                	mv	a0,s1
    8000525a:	8e0fe0ef          	jal	8000333a <iunlock>
  end_op();
    8000525e:	b25fe0ef          	jal	80003d82 <end_op>

  return fd;
    80005262:	854e                	mv	a0,s3
    80005264:	74aa                	ld	s1,168(sp)
    80005266:	790a                	ld	s2,160(sp)
    80005268:	69ea                	ld	s3,152(sp)
}
    8000526a:	70ea                	ld	ra,184(sp)
    8000526c:	744a                	ld	s0,176(sp)
    8000526e:	6129                	addi	sp,sp,192
    80005270:	8082                	ret
      end_op();
    80005272:	b11fe0ef          	jal	80003d82 <end_op>
      return -1;
    80005276:	557d                	li	a0,-1
    80005278:	74aa                	ld	s1,168(sp)
    8000527a:	bfc5                	j	8000526a <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    8000527c:	f5040513          	addi	a0,s0,-176
    80005280:	899fe0ef          	jal	80003b18 <namei>
    80005284:	84aa                	mv	s1,a0
    80005286:	c11d                	beqz	a0,800052ac <sys_open+0x10c>
    ilock(ip);
    80005288:	804fe0ef          	jal	8000328c <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000528c:	04449703          	lh	a4,68(s1)
    80005290:	4785                	li	a5,1
    80005292:	f4f71ce3          	bne	a4,a5,800051ea <sys_open+0x4a>
    80005296:	f4c42783          	lw	a5,-180(s0)
    8000529a:	d3b5                	beqz	a5,800051fe <sys_open+0x5e>
      iunlockput(ip);
    8000529c:	8526                	mv	a0,s1
    8000529e:	a42fe0ef          	jal	800034e0 <iunlockput>
      end_op();
    800052a2:	ae1fe0ef          	jal	80003d82 <end_op>
      return -1;
    800052a6:	557d                	li	a0,-1
    800052a8:	74aa                	ld	s1,168(sp)
    800052aa:	b7c1                	j	8000526a <sys_open+0xca>
      end_op();
    800052ac:	ad7fe0ef          	jal	80003d82 <end_op>
      return -1;
    800052b0:	557d                	li	a0,-1
    800052b2:	74aa                	ld	s1,168(sp)
    800052b4:	bf5d                	j	8000526a <sys_open+0xca>
    iunlockput(ip);
    800052b6:	8526                	mv	a0,s1
    800052b8:	a28fe0ef          	jal	800034e0 <iunlockput>
    end_op();
    800052bc:	ac7fe0ef          	jal	80003d82 <end_op>
    return -1;
    800052c0:	557d                	li	a0,-1
    800052c2:	74aa                	ld	s1,168(sp)
    800052c4:	b75d                	j	8000526a <sys_open+0xca>
      fileclose(f);
    800052c6:	854a                	mv	a0,s2
    800052c8:	ee9fe0ef          	jal	800041b0 <fileclose>
    800052cc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800052ce:	8526                	mv	a0,s1
    800052d0:	a10fe0ef          	jal	800034e0 <iunlockput>
    end_op();
    800052d4:	aaffe0ef          	jal	80003d82 <end_op>
    return -1;
    800052d8:	557d                	li	a0,-1
    800052da:	74aa                	ld	s1,168(sp)
    800052dc:	790a                	ld	s2,160(sp)
    800052de:	b771                	j	8000526a <sys_open+0xca>
    f->type = FD_DEVICE;
    800052e0:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800052e4:	04649783          	lh	a5,70(s1)
    800052e8:	02f91223          	sh	a5,36(s2)
    800052ec:	bf35                	j	80005228 <sys_open+0x88>
    itrunc(ip);
    800052ee:	8526                	mv	a0,s1
    800052f0:	88afe0ef          	jal	8000337a <itrunc>
    800052f4:	b795                	j	80005258 <sys_open+0xb8>

00000000800052f6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800052f6:	7175                	addi	sp,sp,-144
    800052f8:	e506                	sd	ra,136(sp)
    800052fa:	e122                	sd	s0,128(sp)
    800052fc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800052fe:	9f9fe0ef          	jal	80003cf6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005302:	08000613          	li	a2,128
    80005306:	f7040593          	addi	a1,s0,-144
    8000530a:	4501                	li	a0,0
    8000530c:	d84fd0ef          	jal	80002890 <argstr>
    80005310:	02054363          	bltz	a0,80005336 <sys_mkdir+0x40>
    80005314:	4681                	li	a3,0
    80005316:	4601                	li	a2,0
    80005318:	4585                	li	a1,1
    8000531a:	f7040513          	addi	a0,s0,-144
    8000531e:	921ff0ef          	jal	80004c3e <create>
    80005322:	c911                	beqz	a0,80005336 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005324:	9bcfe0ef          	jal	800034e0 <iunlockput>
  end_op();
    80005328:	a5bfe0ef          	jal	80003d82 <end_op>
  return 0;
    8000532c:	4501                	li	a0,0
}
    8000532e:	60aa                	ld	ra,136(sp)
    80005330:	640a                	ld	s0,128(sp)
    80005332:	6149                	addi	sp,sp,144
    80005334:	8082                	ret
    end_op();
    80005336:	a4dfe0ef          	jal	80003d82 <end_op>
    return -1;
    8000533a:	557d                	li	a0,-1
    8000533c:	bfcd                	j	8000532e <sys_mkdir+0x38>

000000008000533e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000533e:	7135                	addi	sp,sp,-160
    80005340:	ed06                	sd	ra,152(sp)
    80005342:	e922                	sd	s0,144(sp)
    80005344:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005346:	9b1fe0ef          	jal	80003cf6 <begin_op>
  argint(1, &major);
    8000534a:	f6c40593          	addi	a1,s0,-148
    8000534e:	4505                	li	a0,1
    80005350:	d08fd0ef          	jal	80002858 <argint>
  argint(2, &minor);
    80005354:	f6840593          	addi	a1,s0,-152
    80005358:	4509                	li	a0,2
    8000535a:	cfefd0ef          	jal	80002858 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000535e:	08000613          	li	a2,128
    80005362:	f7040593          	addi	a1,s0,-144
    80005366:	4501                	li	a0,0
    80005368:	d28fd0ef          	jal	80002890 <argstr>
    8000536c:	02054563          	bltz	a0,80005396 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005370:	f6841683          	lh	a3,-152(s0)
    80005374:	f6c41603          	lh	a2,-148(s0)
    80005378:	458d                	li	a1,3
    8000537a:	f7040513          	addi	a0,s0,-144
    8000537e:	8c1ff0ef          	jal	80004c3e <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005382:	c911                	beqz	a0,80005396 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005384:	95cfe0ef          	jal	800034e0 <iunlockput>
  end_op();
    80005388:	9fbfe0ef          	jal	80003d82 <end_op>
  return 0;
    8000538c:	4501                	li	a0,0
}
    8000538e:	60ea                	ld	ra,152(sp)
    80005390:	644a                	ld	s0,144(sp)
    80005392:	610d                	addi	sp,sp,160
    80005394:	8082                	ret
    end_op();
    80005396:	9edfe0ef          	jal	80003d82 <end_op>
    return -1;
    8000539a:	557d                	li	a0,-1
    8000539c:	bfcd                	j	8000538e <sys_mknod+0x50>

000000008000539e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000539e:	7135                	addi	sp,sp,-160
    800053a0:	ed06                	sd	ra,152(sp)
    800053a2:	e922                	sd	s0,144(sp)
    800053a4:	e14a                	sd	s2,128(sp)
    800053a6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800053a8:	d60fc0ef          	jal	80001908 <myproc>
    800053ac:	892a                	mv	s2,a0

  begin_op();
    800053ae:	949fe0ef          	jal	80003cf6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800053b2:	08000613          	li	a2,128
    800053b6:	f6040593          	addi	a1,s0,-160
    800053ba:	4501                	li	a0,0
    800053bc:	cd4fd0ef          	jal	80002890 <argstr>
    800053c0:	04054363          	bltz	a0,80005406 <sys_chdir+0x68>
    800053c4:	e526                	sd	s1,136(sp)
    800053c6:	f6040513          	addi	a0,s0,-160
    800053ca:	f4efe0ef          	jal	80003b18 <namei>
    800053ce:	84aa                	mv	s1,a0
    800053d0:	c915                	beqz	a0,80005404 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800053d2:	ebbfd0ef          	jal	8000328c <ilock>
  if (ip->type != T_DIR) {
    800053d6:	04449703          	lh	a4,68(s1)
    800053da:	4785                	li	a5,1
    800053dc:	02f71963          	bne	a4,a5,8000540e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800053e0:	8526                	mv	a0,s1
    800053e2:	f59fd0ef          	jal	8000333a <iunlock>
  iput(p->cwd);
    800053e6:	15093503          	ld	a0,336(s2)
    800053ea:	824fe0ef          	jal	8000340e <iput>
  end_op();
    800053ee:	995fe0ef          	jal	80003d82 <end_op>
  p->cwd = ip;
    800053f2:	14993823          	sd	s1,336(s2)
  return 0;
    800053f6:	4501                	li	a0,0
    800053f8:	64aa                	ld	s1,136(sp)
}
    800053fa:	60ea                	ld	ra,152(sp)
    800053fc:	644a                	ld	s0,144(sp)
    800053fe:	690a                	ld	s2,128(sp)
    80005400:	610d                	addi	sp,sp,160
    80005402:	8082                	ret
    80005404:	64aa                	ld	s1,136(sp)
    end_op();
    80005406:	97dfe0ef          	jal	80003d82 <end_op>
    return -1;
    8000540a:	557d                	li	a0,-1
    8000540c:	b7fd                	j	800053fa <sys_chdir+0x5c>
    iunlockput(ip);
    8000540e:	8526                	mv	a0,s1
    80005410:	8d0fe0ef          	jal	800034e0 <iunlockput>
    end_op();
    80005414:	96ffe0ef          	jal	80003d82 <end_op>
    return -1;
    80005418:	557d                	li	a0,-1
    8000541a:	64aa                	ld	s1,136(sp)
    8000541c:	bff9                	j	800053fa <sys_chdir+0x5c>

000000008000541e <sys_exec>:

uint64
sys_exec(void)
{
    8000541e:	7105                	addi	sp,sp,-480
    80005420:	ef86                	sd	ra,472(sp)
    80005422:	eba2                	sd	s0,464(sp)
    80005424:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005426:	e2840593          	addi	a1,s0,-472
    8000542a:	4505                	li	a0,1
    8000542c:	c48fd0ef          	jal	80002874 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005430:	08000613          	li	a2,128
    80005434:	f3040593          	addi	a1,s0,-208
    80005438:	4501                	li	a0,0
    8000543a:	c56fd0ef          	jal	80002890 <argstr>
    8000543e:	87aa                	mv	a5,a0
    return -1;
    80005440:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005442:	0e07c063          	bltz	a5,80005522 <sys_exec+0x104>
    80005446:	e7a6                	sd	s1,456(sp)
    80005448:	e3ca                	sd	s2,448(sp)
    8000544a:	ff4e                	sd	s3,440(sp)
    8000544c:	fb52                	sd	s4,432(sp)
    8000544e:	f756                	sd	s5,424(sp)
    80005450:	f35a                	sd	s6,416(sp)
    80005452:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005454:	e3040a13          	addi	s4,s0,-464
    80005458:	10000613          	li	a2,256
    8000545c:	4581                	li	a1,0
    8000545e:	8552                	mv	a0,s4
    80005460:	849fb0ef          	jal	80000ca8 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005464:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005466:	89d2                	mv	s3,s4
    80005468:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000546a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000546e:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80005470:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005474:	00391513          	slli	a0,s2,0x3
    80005478:	85d6                	mv	a1,s5
    8000547a:	e2843783          	ld	a5,-472(s0)
    8000547e:	953e                	add	a0,a0,a5
    80005480:	b4cfd0ef          	jal	800027cc <fetchaddr>
    80005484:	02054663          	bltz	a0,800054b0 <sys_exec+0x92>
    if (uarg == 0) {
    80005488:	e2043783          	ld	a5,-480(s0)
    8000548c:	c7a1                	beqz	a5,800054d4 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000548e:	e80fb0ef          	jal	80000b0e <kalloc>
    80005492:	85aa                	mv	a1,a0
    80005494:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005498:	cd01                	beqz	a0,800054b0 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000549a:	865a                	mv	a2,s6
    8000549c:	e2043503          	ld	a0,-480(s0)
    800054a0:	b76fd0ef          	jal	80002816 <fetchstr>
    800054a4:	00054663          	bltz	a0,800054b0 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    800054a8:	0905                	addi	s2,s2,1
    800054aa:	09a1                	addi	s3,s3,8
    800054ac:	fd7914e3          	bne	s2,s7,80005474 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054b0:	100a0a13          	addi	s4,s4,256
    800054b4:	6088                	ld	a0,0(s1)
    800054b6:	cd31                	beqz	a0,80005512 <sys_exec+0xf4>
    kfree(argv[i]);
    800054b8:	d6efb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054bc:	04a1                	addi	s1,s1,8
    800054be:	ff449be3          	bne	s1,s4,800054b4 <sys_exec+0x96>
  return -1;
    800054c2:	557d                	li	a0,-1
    800054c4:	64be                	ld	s1,456(sp)
    800054c6:	691e                	ld	s2,448(sp)
    800054c8:	79fa                	ld	s3,440(sp)
    800054ca:	7a5a                	ld	s4,432(sp)
    800054cc:	7aba                	ld	s5,424(sp)
    800054ce:	7b1a                	ld	s6,416(sp)
    800054d0:	6bfa                	ld	s7,408(sp)
    800054d2:	a881                	j	80005522 <sys_exec+0x104>
      argv[i] = 0;
    800054d4:	0009079b          	sext.w	a5,s2
    800054d8:	e3040593          	addi	a1,s0,-464
    800054dc:	078e                	slli	a5,a5,0x3
    800054de:	97ae                	add	a5,a5,a1
    800054e0:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800054e4:	f3040513          	addi	a0,s0,-208
    800054e8:	b62ff0ef          	jal	8000484a <kexec>
    800054ec:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054ee:	100a0a13          	addi	s4,s4,256
    800054f2:	6088                	ld	a0,0(s1)
    800054f4:	c511                	beqz	a0,80005500 <sys_exec+0xe2>
    kfree(argv[i]);
    800054f6:	d30fb0ef          	jal	80000a26 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800054fa:	04a1                	addi	s1,s1,8
    800054fc:	ff449be3          	bne	s1,s4,800054f2 <sys_exec+0xd4>
  return ret;
    80005500:	854a                	mv	a0,s2
    80005502:	64be                	ld	s1,456(sp)
    80005504:	691e                	ld	s2,448(sp)
    80005506:	79fa                	ld	s3,440(sp)
    80005508:	7a5a                	ld	s4,432(sp)
    8000550a:	7aba                	ld	s5,424(sp)
    8000550c:	7b1a                	ld	s6,416(sp)
    8000550e:	6bfa                	ld	s7,408(sp)
    80005510:	a809                	j	80005522 <sys_exec+0x104>
  return -1;
    80005512:	557d                	li	a0,-1
    80005514:	64be                	ld	s1,456(sp)
    80005516:	691e                	ld	s2,448(sp)
    80005518:	79fa                	ld	s3,440(sp)
    8000551a:	7a5a                	ld	s4,432(sp)
    8000551c:	7aba                	ld	s5,424(sp)
    8000551e:	7b1a                	ld	s6,416(sp)
    80005520:	6bfa                	ld	s7,408(sp)
}
    80005522:	60fe                	ld	ra,472(sp)
    80005524:	645e                	ld	s0,464(sp)
    80005526:	613d                	addi	sp,sp,480
    80005528:	8082                	ret

000000008000552a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000552a:	7139                	addi	sp,sp,-64
    8000552c:	fc06                	sd	ra,56(sp)
    8000552e:	f822                	sd	s0,48(sp)
    80005530:	f426                	sd	s1,40(sp)
    80005532:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005534:	bd4fc0ef          	jal	80001908 <myproc>
    80005538:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000553a:	fd840593          	addi	a1,s0,-40
    8000553e:	4501                	li	a0,0
    80005540:	b34fd0ef          	jal	80002874 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80005544:	fc840593          	addi	a1,s0,-56
    80005548:	fd040513          	addi	a0,s0,-48
    8000554c:	f99fe0ef          	jal	800044e4 <pipealloc>
    return -1;
    80005550:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80005552:	0a054963          	bltz	a0,80005604 <sys_pipe+0xda>
  fd0 = -1;
    80005556:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000555a:	fd043503          	ld	a0,-48(s0)
    8000555e:	ea0ff0ef          	jal	80004bfe <fdalloc>
    80005562:	fca42223          	sw	a0,-60(s0)
    80005566:	08054663          	bltz	a0,800055f2 <sys_pipe+0xc8>
    8000556a:	fc843503          	ld	a0,-56(s0)
    8000556e:	e90ff0ef          	jal	80004bfe <fdalloc>
    80005572:	fca42023          	sw	a0,-64(s0)
    80005576:	06054463          	bltz	a0,800055de <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000557a:	4711                	li	a4,4
    8000557c:	fc440693          	addi	a3,s0,-60
    80005580:	fd843603          	ld	a2,-40(s0)
    80005584:	64ac                	ld	a1,72(s1)
    80005586:	68a8                	ld	a0,80(s1)
    80005588:	fbbfb0ef          	jal	80001542 <copyout>
    8000558c:	00054f63          	bltz	a0,800055aa <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005590:	4711                	li	a4,4
    80005592:	fc040693          	addi	a3,s0,-64
    80005596:	fd843603          	ld	a2,-40(s0)
    8000559a:	963a                	add	a2,a2,a4
    8000559c:	64ac                	ld	a1,72(s1)
    8000559e:	68a8                	ld	a0,80(s1)
    800055a0:	fa3fb0ef          	jal	80001542 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800055a4:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800055a6:	04055f63          	bgez	a0,80005604 <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    800055aa:	fc442783          	lw	a5,-60(s0)
    800055ae:	078e                	slli	a5,a5,0x3
    800055b0:	0d078793          	addi	a5,a5,208
    800055b4:	97a6                	add	a5,a5,s1
    800055b6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800055ba:	fc042783          	lw	a5,-64(s0)
    800055be:	078e                	slli	a5,a5,0x3
    800055c0:	0d078793          	addi	a5,a5,208
    800055c4:	94be                	add	s1,s1,a5
    800055c6:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800055ca:	fd043503          	ld	a0,-48(s0)
    800055ce:	be3fe0ef          	jal	800041b0 <fileclose>
    fileclose(wf);
    800055d2:	fc843503          	ld	a0,-56(s0)
    800055d6:	bdbfe0ef          	jal	800041b0 <fileclose>
    return -1;
    800055da:	57fd                	li	a5,-1
    800055dc:	a025                	j	80005604 <sys_pipe+0xda>
    if (fd0 >= 0)
    800055de:	fc442783          	lw	a5,-60(s0)
    800055e2:	0007c863          	bltz	a5,800055f2 <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    800055e6:	078e                	slli	a5,a5,0x3
    800055e8:	0d078793          	addi	a5,a5,208
    800055ec:	97a6                	add	a5,a5,s1
    800055ee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800055f2:	fd043503          	ld	a0,-48(s0)
    800055f6:	bbbfe0ef          	jal	800041b0 <fileclose>
    fileclose(wf);
    800055fa:	fc843503          	ld	a0,-56(s0)
    800055fe:	bb3fe0ef          	jal	800041b0 <fileclose>
    return -1;
    80005602:	57fd                	li	a5,-1
}
    80005604:	853e                	mv	a0,a5
    80005606:	70e2                	ld	ra,56(sp)
    80005608:	7442                	ld	s0,48(sp)
    8000560a:	74a2                	ld	s1,40(sp)
    8000560c:	6121                	addi	sp,sp,64
    8000560e:	8082                	ret

0000000080005610 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005610:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005612:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005614:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005616:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005618:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000561a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000561c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000561e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005620:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005622:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005624:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005626:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005628:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000562a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000562c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000562e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005630:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005632:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005634:	8a6fd0ef          	jal	800026da <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005638:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000563a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000563c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000563e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005640:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005642:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005644:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005646:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005648:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000564a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000564c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000564e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005650:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005652:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005654:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005656:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005658:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000565a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000565c:	10200073          	sret
    80005660:	0001                	nop
    80005662:	00000013          	nop
    80005666:	00000013          	nop
    8000566a:	00000013          	nop

000000008000566e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000566e:	1141                	addi	sp,sp,-16
    80005670:	e406                	sd	ra,8(sp)
    80005672:	e022                	sd	s0,0(sp)
    80005674:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005676:	0c000737          	lui	a4,0xc000
    8000567a:	4785                	li	a5,1
    8000567c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000567e:	c35c                	sw	a5,4(a4)
}
    80005680:	60a2                	ld	ra,8(sp)
    80005682:	6402                	ld	s0,0(sp)
    80005684:	0141                	addi	sp,sp,16
    80005686:	8082                	ret

0000000080005688 <plicinithart>:

void
plicinithart(void)
{
    80005688:	1141                	addi	sp,sp,-16
    8000568a:	e406                	sd	ra,8(sp)
    8000568c:	e022                	sd	s0,0(sp)
    8000568e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005690:	a44fc0ef          	jal	800018d4 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005694:	0085171b          	slliw	a4,a0,0x8
    80005698:	0c0027b7          	lui	a5,0xc002
    8000569c:	97ba                	add	a5,a5,a4
    8000569e:	40200713          	li	a4,1026
    800056a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    800056a6:	00d5151b          	slliw	a0,a0,0xd
    800056aa:	0c2017b7          	lui	a5,0xc201
    800056ae:	97aa                	add	a5,a5,a0
    800056b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800056b4:	60a2                	ld	ra,8(sp)
    800056b6:	6402                	ld	s0,0(sp)
    800056b8:	0141                	addi	sp,sp,16
    800056ba:	8082                	ret

00000000800056bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800056bc:	1141                	addi	sp,sp,-16
    800056be:	e406                	sd	ra,8(sp)
    800056c0:	e022                	sd	s0,0(sp)
    800056c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800056c4:	a10fc0ef          	jal	800018d4 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    800056c8:	00d5151b          	slliw	a0,a0,0xd
    800056cc:	0c2017b7          	lui	a5,0xc201
    800056d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800056d2:	43c8                	lw	a0,4(a5)
    800056d4:	60a2                	ld	ra,8(sp)
    800056d6:	6402                	ld	s0,0(sp)
    800056d8:	0141                	addi	sp,sp,16
    800056da:	8082                	ret

00000000800056dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800056dc:	1101                	addi	sp,sp,-32
    800056de:	ec06                	sd	ra,24(sp)
    800056e0:	e822                	sd	s0,16(sp)
    800056e2:	e426                	sd	s1,8(sp)
    800056e4:	1000                	addi	s0,sp,32
    800056e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800056e8:	9ecfc0ef          	jal	800018d4 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800056ec:	00d5179b          	slliw	a5,a0,0xd
    800056f0:	0c201737          	lui	a4,0xc201
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	c3c4                	sw	s1,4(a5)
}
    800056f8:	60e2                	ld	ra,24(sp)
    800056fa:	6442                	ld	s0,16(sp)
    800056fc:	64a2                	ld	s1,8(sp)
    800056fe:	6105                	addi	sp,sp,32
    80005700:	8082                	ret

0000000080005702 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005702:	1141                	addi	sp,sp,-16
    80005704:	e406                	sd	ra,8(sp)
    80005706:	e022                	sd	s0,0(sp)
    80005708:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000570a:	479d                	li	a5,7
    8000570c:	04a7ca63          	blt	a5,a0,80005760 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005710:	0001e797          	auipc	a5,0x1e
    80005714:	16078793          	addi	a5,a5,352 # 80023870 <disk>
    80005718:	97aa                	add	a5,a5,a0
    8000571a:	0187c783          	lbu	a5,24(a5)
    8000571e:	e7b9                	bnez	a5,8000576c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005720:	00451693          	slli	a3,a0,0x4
    80005724:	0001e797          	auipc	a5,0x1e
    80005728:	14c78793          	addi	a5,a5,332 # 80023870 <disk>
    8000572c:	6398                	ld	a4,0(a5)
    8000572e:	9736                	add	a4,a4,a3
    80005730:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005734:	6398                	ld	a4,0(a5)
    80005736:	9736                	add	a4,a4,a3
    80005738:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000573c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005740:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005744:	97aa                	add	a5,a5,a0
    80005746:	4705                	li	a4,1
    80005748:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000574c:	0001e517          	auipc	a0,0x1e
    80005750:	13c50513          	addi	a0,a0,316 # 80023888 <disk+0x18>
    80005754:	833fc0ef          	jal	80001f86 <wakeup>
}
    80005758:	60a2                	ld	ra,8(sp)
    8000575a:	6402                	ld	s0,0(sp)
    8000575c:	0141                	addi	sp,sp,16
    8000575e:	8082                	ret
    panic("free_desc 1");
    80005760:	00002517          	auipc	a0,0x2
    80005764:	f8850513          	addi	a0,a0,-120 # 800076e8 <etext+0x6e8>
    80005768:	8ccfb0ef          	jal	80000834 <panic>
    panic("free_desc 2");
    8000576c:	00002517          	auipc	a0,0x2
    80005770:	f8c50513          	addi	a0,a0,-116 # 800076f8 <etext+0x6f8>
    80005774:	8c0fb0ef          	jal	80000834 <panic>

0000000080005778 <virtio_disk_init>:
{
    80005778:	1101                	addi	sp,sp,-32
    8000577a:	ec06                	sd	ra,24(sp)
    8000577c:	e822                	sd	s0,16(sp)
    8000577e:	e426                	sd	s1,8(sp)
    80005780:	e04a                	sd	s2,0(sp)
    80005782:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005784:	00002597          	auipc	a1,0x2
    80005788:	f8458593          	addi	a1,a1,-124 # 80007708 <etext+0x708>
    8000578c:	0001e517          	auipc	a0,0x1e
    80005790:	20c50513          	addi	a0,a0,524 # 80023998 <disk+0x128>
    80005794:	bd4fb0ef          	jal	80000b68 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005798:	100017b7          	lui	a5,0x10001
    8000579c:	4398                	lw	a4,0(a5)
    8000579e:	2701                	sext.w	a4,a4
    800057a0:	747277b7          	lui	a5,0x74727
    800057a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800057a8:	14f71863          	bne	a4,a5,800058f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ac:	100017b7          	lui	a5,0x10001
    800057b0:	43dc                	lw	a5,4(a5)
    800057b2:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800057b4:	4709                	li	a4,2
    800057b6:	14e79163          	bne	a5,a4,800058f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ba:	100017b7          	lui	a5,0x10001
    800057be:	479c                	lw	a5,8(a5)
    800057c0:	2781                	sext.w	a5,a5
    800057c2:	12e79b63          	bne	a5,a4,800058f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800057c6:	100017b7          	lui	a5,0x10001
    800057ca:	47d8                	lw	a4,12(a5)
    800057cc:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800057ce:	554d47b7          	lui	a5,0x554d4
    800057d2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800057d6:	12f71163          	bne	a4,a5,800058f8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057da:	100017b7          	lui	a5,0x10001
    800057de:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e2:	4705                	li	a4,1
    800057e4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800057e6:	470d                	li	a4,3
    800057e8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800057ea:	10001737          	lui	a4,0x10001
    800057ee:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800057f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800057f4:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fdabaf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800057f8:	8f75                	and	a4,a4,a3
    800057fa:	100016b7          	lui	a3,0x10001
    800057fe:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005800:	472d                	li	a4,11
    80005802:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005804:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005808:	439c                	lw	a5,0(a5)
    8000580a:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000580e:	8ba1                	andi	a5,a5,8
    80005810:	0e078a63          	beqz	a5,80005904 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005814:	100017b7          	lui	a5,0x10001
    80005818:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000581c:	43fc                	lw	a5,68(a5)
    8000581e:	2781                	sext.w	a5,a5
    80005820:	0e079863          	bnez	a5,80005910 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005824:	100017b7          	lui	a5,0x10001
    80005828:	5bdc                	lw	a5,52(a5)
    8000582a:	2781                	sext.w	a5,a5
  if (max == 0)
    8000582c:	0e078863          	beqz	a5,8000591c <virtio_disk_init+0x1a4>
  if (max < NUM)
    80005830:	471d                	li	a4,7
    80005832:	0ef77b63          	bgeu	a4,a5,80005928 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005836:	ad8fb0ef          	jal	80000b0e <kalloc>
    8000583a:	0001e497          	auipc	s1,0x1e
    8000583e:	03648493          	addi	s1,s1,54 # 80023870 <disk>
    80005842:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005844:	acafb0ef          	jal	80000b0e <kalloc>
    80005848:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000584a:	ac4fb0ef          	jal	80000b0e <kalloc>
    8000584e:	87aa                	mv	a5,a0
    80005850:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005852:	6088                	ld	a0,0(s1)
    80005854:	0e050063          	beqz	a0,80005934 <virtio_disk_init+0x1bc>
    80005858:	0001e717          	auipc	a4,0x1e
    8000585c:	02073703          	ld	a4,32(a4) # 80023878 <disk+0x8>
    80005860:	cb71                	beqz	a4,80005934 <virtio_disk_init+0x1bc>
    80005862:	cbe9                	beqz	a5,80005934 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005864:	6605                	lui	a2,0x1
    80005866:	4581                	li	a1,0
    80005868:	c40fb0ef          	jal	80000ca8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000586c:	0001e497          	auipc	s1,0x1e
    80005870:	00448493          	addi	s1,s1,4 # 80023870 <disk>
    80005874:	6605                	lui	a2,0x1
    80005876:	4581                	li	a1,0
    80005878:	6488                	ld	a0,8(s1)
    8000587a:	c2efb0ef          	jal	80000ca8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000587e:	6605                	lui	a2,0x1
    80005880:	4581                	li	a1,0
    80005882:	6888                	ld	a0,16(s1)
    80005884:	c24fb0ef          	jal	80000ca8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005888:	100017b7          	lui	a5,0x10001
    8000588c:	4721                	li	a4,8
    8000588e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005890:	4098                	lw	a4,0(s1)
    80005892:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005896:	40d8                	lw	a4,4(s1)
    80005898:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000589c:	649c                	ld	a5,8(s1)
    8000589e:	0007869b          	sext.w	a3,a5
    800058a2:	10001737          	lui	a4,0x10001
    800058a6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800058aa:	9781                	srai	a5,a5,0x20
    800058ac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800058b0:	689c                	ld	a5,16(s1)
    800058b2:	0007869b          	sext.w	a3,a5
    800058b6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800058ba:	9781                	srai	a5,a5,0x20
    800058bc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800058c0:	4785                	li	a5,1
    800058c2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800058c4:	00f48c23          	sb	a5,24(s1)
    800058c8:	00f48ca3          	sb	a5,25(s1)
    800058cc:	00f48d23          	sb	a5,26(s1)
    800058d0:	00f48da3          	sb	a5,27(s1)
    800058d4:	00f48e23          	sb	a5,28(s1)
    800058d8:	00f48ea3          	sb	a5,29(s1)
    800058dc:	00f48f23          	sb	a5,30(s1)
    800058e0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800058e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800058e8:	07272823          	sw	s2,112(a4)
}
    800058ec:	60e2                	ld	ra,24(sp)
    800058ee:	6442                	ld	s0,16(sp)
    800058f0:	64a2                	ld	s1,8(sp)
    800058f2:	6902                	ld	s2,0(sp)
    800058f4:	6105                	addi	sp,sp,32
    800058f6:	8082                	ret
    panic("could not find virtio disk");
    800058f8:	00002517          	auipc	a0,0x2
    800058fc:	e2050513          	addi	a0,a0,-480 # 80007718 <etext+0x718>
    80005900:	f35fa0ef          	jal	80000834 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005904:	00002517          	auipc	a0,0x2
    80005908:	e3450513          	addi	a0,a0,-460 # 80007738 <etext+0x738>
    8000590c:	f29fa0ef          	jal	80000834 <panic>
    panic("virtio disk should not be ready");
    80005910:	00002517          	auipc	a0,0x2
    80005914:	e4850513          	addi	a0,a0,-440 # 80007758 <etext+0x758>
    80005918:	f1dfa0ef          	jal	80000834 <panic>
    panic("virtio disk has no queue 0");
    8000591c:	00002517          	auipc	a0,0x2
    80005920:	e5c50513          	addi	a0,a0,-420 # 80007778 <etext+0x778>
    80005924:	f11fa0ef          	jal	80000834 <panic>
    panic("virtio disk max queue too short");
    80005928:	00002517          	auipc	a0,0x2
    8000592c:	e7050513          	addi	a0,a0,-400 # 80007798 <etext+0x798>
    80005930:	f05fa0ef          	jal	80000834 <panic>
    panic("virtio disk kalloc");
    80005934:	00002517          	auipc	a0,0x2
    80005938:	e8450513          	addi	a0,a0,-380 # 800077b8 <etext+0x7b8>
    8000593c:	ef9fa0ef          	jal	80000834 <panic>

0000000080005940 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005940:	711d                	addi	sp,sp,-96
    80005942:	ec86                	sd	ra,88(sp)
    80005944:	e8a2                	sd	s0,80(sp)
    80005946:	e4a6                	sd	s1,72(sp)
    80005948:	e0ca                	sd	s2,64(sp)
    8000594a:	fc4e                	sd	s3,56(sp)
    8000594c:	f852                	sd	s4,48(sp)
    8000594e:	f456                	sd	s5,40(sp)
    80005950:	f05a                	sd	s6,32(sp)
    80005952:	ec5e                	sd	s7,24(sp)
    80005954:	e862                	sd	s8,16(sp)
    80005956:	1080                	addi	s0,sp,96
    80005958:	89aa                	mv	s3,a0
    8000595a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000595c:	00c52b83          	lw	s7,12(a0)
    80005960:	001b9b9b          	slliw	s7,s7,0x1
    80005964:	1b82                	slli	s7,s7,0x20
    80005966:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000596a:	0001e517          	auipc	a0,0x1e
    8000596e:	02e50513          	addi	a0,a0,46 # 80023998 <disk+0x128>
    80005972:	a76fb0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005976:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005978:	0001ea97          	auipc	s5,0x1e
    8000597c:	ef8a8a93          	addi	s5,s5,-264 # 80023870 <disk>
  for (int i = 0; i < 3; i++) {
    80005980:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005982:	5c7d                	li	s8,-1
    80005984:	a8a5                	j	800059fc <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80005986:	00fa8733          	add	a4,s5,a5
    8000598a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000598e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005990:	0207c563          	bltz	a5,800059ba <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005994:	2905                	addiw	s2,s2,1
    80005996:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005998:	07490663          	beq	s2,s4,80005a04 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    8000599c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    8000599e:	0001e717          	auipc	a4,0x1e
    800059a2:	ed270713          	addi	a4,a4,-302 # 80023870 <disk>
    800059a6:	4781                	li	a5,0
    if (disk.free[i]) {
    800059a8:	01874683          	lbu	a3,24(a4)
    800059ac:	fee9                	bnez	a3,80005986 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    800059ae:	2785                	addiw	a5,a5,1
    800059b0:	0705                	addi	a4,a4,1
    800059b2:	fe979be3          	bne	a5,s1,800059a8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800059b6:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    800059ba:	01205d63          	blez	s2,800059d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059be:	fa042503          	lw	a0,-96(s0)
    800059c2:	d41ff0ef          	jal	80005702 <free_desc>
      for (int j = 0; j < i; j++)
    800059c6:	4785                	li	a5,1
    800059c8:	0127d663          	bge	a5,s2,800059d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800059cc:	fa442503          	lw	a0,-92(s0)
    800059d0:	d33ff0ef          	jal	80005702 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    800059d4:	0001e517          	auipc	a0,0x1e
    800059d8:	eb450513          	addi	a0,a0,-332 # 80023888 <disk+0x18>
    800059dc:	d3efc0ef          	jal	80001f1a <sleep_prepare>
    release(&disk.vdisk_lock);
    800059e0:	0001e517          	auipc	a0,0x1e
    800059e4:	fb850513          	addi	a0,a0,-72 # 80023998 <disk+0x128>
    800059e8:	a88fb0ef          	jal	80000c70 <release>
    sleep();
    800059ec:	d6afc0ef          	jal	80001f56 <sleep>
    acquire(&disk.vdisk_lock);
    800059f0:	0001e517          	auipc	a0,0x1e
    800059f4:	fa850513          	addi	a0,a0,-88 # 80023998 <disk+0x128>
    800059f8:	9f0fb0ef          	jal	80000be8 <acquire>
  for (int i = 0; i < 3; i++) {
    800059fc:	fa040613          	addi	a2,s0,-96
    80005a00:	4901                	li	s2,0
    80005a02:	bf69                	j	8000599c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a04:	fa042503          	lw	a0,-96(s0)
    80005a08:	00451693          	slli	a3,a0,0x4

  if (write)
    80005a0c:	0001e797          	auipc	a5,0x1e
    80005a10:	e6478793          	addi	a5,a5,-412 # 80023870 <disk>
    80005a14:	00451713          	slli	a4,a0,0x4
    80005a18:	0a070713          	addi	a4,a4,160
    80005a1c:	973e                	add	a4,a4,a5
    80005a1e:	01603633          	snez	a2,s6
    80005a22:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a24:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a28:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005a2c:	6398                	ld	a4,0(a5)
    80005a2e:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a30:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005a34:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005a36:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005a38:	6390                	ld	a2,0(a5)
    80005a3a:	00d60833          	add	a6,a2,a3
    80005a3e:	4741                	li	a4,16
    80005a40:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005a44:	4585                	li	a1,1
    80005a46:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005a4a:	fa442703          	lw	a4,-92(s0)
    80005a4e:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005a52:	0712                	slli	a4,a4,0x4
    80005a54:	963a                	add	a2,a2,a4
    80005a56:	05898813          	addi	a6,s3,88
    80005a5a:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a5e:	0007b883          	ld	a7,0(a5)
    80005a62:	9746                	add	a4,a4,a7
    80005a64:	40000613          	li	a2,1024
    80005a68:	c710                	sw	a2,8(a4)
  if (write)
    80005a6a:	001b3613          	seqz	a2,s6
    80005a6e:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005a72:	8e4d                	or	a2,a2,a1
    80005a74:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005a78:	fa842603          	lw	a2,-88(s0)
    80005a7c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005a80:	00451813          	slli	a6,a0,0x4
    80005a84:	02080813          	addi	a6,a6,32
    80005a88:	983e                	add	a6,a6,a5
    80005a8a:	577d                	li	a4,-1
    80005a8c:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005a90:	0612                	slli	a2,a2,0x4
    80005a92:	98b2                	add	a7,a7,a2
    80005a94:	03068713          	addi	a4,a3,48
    80005a98:	973e                	add	a4,a4,a5
    80005a9a:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005a9e:	6398                	ld	a4,0(a5)
    80005aa0:	9732                	add	a4,a4,a2
    80005aa2:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005aa4:	4689                	li	a3,2
    80005aa6:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005aaa:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005aae:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005ab2:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005ab6:	6794                	ld	a3,8(a5)
    80005ab8:	0026d703          	lhu	a4,2(a3)
    80005abc:	8b1d                	andi	a4,a4,7
    80005abe:	0706                	slli	a4,a4,0x1
    80005ac0:	96ba                	add	a3,a3,a4
    80005ac2:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005ac6:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005aca:	6798                	ld	a4,8(a5)
    80005acc:	00275783          	lhu	a5,2(a4)
    80005ad0:	2785                	addiw	a5,a5,1
    80005ad2:	00f71123          	sh	a5,2(a4)
    80005ad6:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005ada:	100017b7          	lui	a5,0x10001
    80005ade:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005ae2:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005ae6:	0001e497          	auipc	s1,0x1e
    80005aea:	eb248493          	addi	s1,s1,-334 # 80023998 <disk+0x128>
  while (b->disk == 1) {
    80005aee:	892e                	mv	s2,a1
    80005af0:	02b79163          	bne	a5,a1,80005b12 <virtio_disk_rw+0x1d2>
    sleep_prepare(b);
    80005af4:	854e                	mv	a0,s3
    80005af6:	c24fc0ef          	jal	80001f1a <sleep_prepare>
    release(&disk.vdisk_lock);
    80005afa:	8526                	mv	a0,s1
    80005afc:	974fb0ef          	jal	80000c70 <release>
    sleep();
    80005b00:	c56fc0ef          	jal	80001f56 <sleep>
    acquire(&disk.vdisk_lock);
    80005b04:	8526                	mv	a0,s1
    80005b06:	8e2fb0ef          	jal	80000be8 <acquire>
  while (b->disk == 1) {
    80005b0a:	0049a783          	lw	a5,4(s3)
    80005b0e:	ff2783e3          	beq	a5,s2,80005af4 <virtio_disk_rw+0x1b4>
  }

  disk.info[idx[0]].b = 0;
    80005b12:	fa042903          	lw	s2,-96(s0)
    80005b16:	00491713          	slli	a4,s2,0x4
    80005b1a:	02070713          	addi	a4,a4,32
    80005b1e:	0001e797          	auipc	a5,0x1e
    80005b22:	d5278793          	addi	a5,a5,-686 # 80023870 <disk>
    80005b26:	97ba                	add	a5,a5,a4
    80005b28:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b2c:	0001e997          	auipc	s3,0x1e
    80005b30:	d4498993          	addi	s3,s3,-700 # 80023870 <disk>
    80005b34:	00491713          	slli	a4,s2,0x4
    80005b38:	0009b783          	ld	a5,0(s3)
    80005b3c:	97ba                	add	a5,a5,a4
    80005b3e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005b42:	854a                	mv	a0,s2
    80005b44:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005b48:	bbbff0ef          	jal	80005702 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005b4c:	8885                	andi	s1,s1,1
    80005b4e:	f0fd                	bnez	s1,80005b34 <virtio_disk_rw+0x1f4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005b50:	0001e517          	auipc	a0,0x1e
    80005b54:	e4850513          	addi	a0,a0,-440 # 80023998 <disk+0x128>
    80005b58:	918fb0ef          	jal	80000c70 <release>
}
    80005b5c:	60e6                	ld	ra,88(sp)
    80005b5e:	6446                	ld	s0,80(sp)
    80005b60:	64a6                	ld	s1,72(sp)
    80005b62:	6906                	ld	s2,64(sp)
    80005b64:	79e2                	ld	s3,56(sp)
    80005b66:	7a42                	ld	s4,48(sp)
    80005b68:	7aa2                	ld	s5,40(sp)
    80005b6a:	7b02                	ld	s6,32(sp)
    80005b6c:	6be2                	ld	s7,24(sp)
    80005b6e:	6c42                	ld	s8,16(sp)
    80005b70:	6125                	addi	sp,sp,96
    80005b72:	8082                	ret

0000000080005b74 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005b74:	1101                	addi	sp,sp,-32
    80005b76:	ec06                	sd	ra,24(sp)
    80005b78:	e822                	sd	s0,16(sp)
    80005b7a:	e426                	sd	s1,8(sp)
    80005b7c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b7e:	0001e497          	auipc	s1,0x1e
    80005b82:	cf248493          	addi	s1,s1,-782 # 80023870 <disk>
    80005b86:	0001e517          	auipc	a0,0x1e
    80005b8a:	e1250513          	addi	a0,a0,-494 # 80023998 <disk+0x128>
    80005b8e:	85afb0ef          	jal	80000be8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b92:	100017b7          	lui	a5,0x10001
    80005b96:	53bc                	lw	a5,96(a5)
    80005b98:	8b8d                	andi	a5,a5,3
    80005b9a:	10001737          	lui	a4,0x10001
    80005b9e:	d37c                	sw	a5,100(a4)
    80005ba0:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005ba4:	689c                	ld	a5,16(s1)
    80005ba6:	0204d703          	lhu	a4,32(s1)
    80005baa:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005bae:	04f70863          	beq	a4,a5,80005bfe <virtio_disk_intr+0x8a>
    80005bb2:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005bb6:	6898                	ld	a4,16(s1)
    80005bb8:	0204d783          	lhu	a5,32(s1)
    80005bbc:	8b9d                	andi	a5,a5,7
    80005bbe:	078e                	slli	a5,a5,0x3
    80005bc0:	97ba                	add	a5,a5,a4
    80005bc2:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005bc4:	00479713          	slli	a4,a5,0x4
    80005bc8:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005bcc:	9726                	add	a4,a4,s1
    80005bce:	01074703          	lbu	a4,16(a4)
    80005bd2:	e329                	bnez	a4,80005c14 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005bd4:	0792                	slli	a5,a5,0x4
    80005bd6:	02078793          	addi	a5,a5,32
    80005bda:	97a6                	add	a5,a5,s1
    80005bdc:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005bde:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005be2:	ba4fc0ef          	jal	80001f86 <wakeup>

    disk.used_idx += 1;
    80005be6:	0204d783          	lhu	a5,32(s1)
    80005bea:	2785                	addiw	a5,a5,1
    80005bec:	17c2                	slli	a5,a5,0x30
    80005bee:	93c1                	srli	a5,a5,0x30
    80005bf0:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005bf4:	6898                	ld	a4,16(s1)
    80005bf6:	00275703          	lhu	a4,2(a4)
    80005bfa:	faf71ce3          	bne	a4,a5,80005bb2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005bfe:	0001e517          	auipc	a0,0x1e
    80005c02:	d9a50513          	addi	a0,a0,-614 # 80023998 <disk+0x128>
    80005c06:	86afb0ef          	jal	80000c70 <release>
}
    80005c0a:	60e2                	ld	ra,24(sp)
    80005c0c:	6442                	ld	s0,16(sp)
    80005c0e:	64a2                	ld	s1,8(sp)
    80005c10:	6105                	addi	sp,sp,32
    80005c12:	8082                	ret
      panic("virtio_disk_intr status");
    80005c14:	00002517          	auipc	a0,0x2
    80005c18:	bbc50513          	addi	a0,a0,-1092 # 800077d0 <etext+0x7d0>
    80005c1c:	c19fa0ef          	jal	80000834 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
