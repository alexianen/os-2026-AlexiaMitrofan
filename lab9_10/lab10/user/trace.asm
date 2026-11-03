
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h" 
#include "user/user.h"
int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if (argc < 3) {
   8:	4789                	li	a5,2
   a:	00a7cd63          	blt	a5,a0,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "usage: trace mask command [args...]\n"); 
  10:	00001597          	auipc	a1,0x1
  14:	91058593          	addi	a1,a1,-1776 # 920 <malloc+0xf2>
  18:	853e                	mv	a0,a5
  1a:	732000ef          	jal	74c <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	300000ef          	jal	320 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (trace(atoi(argv[1])) < 0) { 
  28:	6588                	ld	a0,8(a1)
  2a:	1cc000ef          	jal	1f6 <atoi>
  2e:	39a000ef          	jal	3c8 <trace>
  32:	02054263          	bltz	a0,56 <main+0x56>
    fprintf(2, "trace: failed\n"); 
    exit(1);
  }
  exec(argv[2], argv + 2);
  36:	01048593          	addi	a1,s1,16
  3a:	6888                	ld	a0,16(s1)
  3c:	31c000ef          	jal	358 <exec>
  fprintf(2, "trace: exec %s failed\n", argv[2]); 
  40:	6890                	ld	a2,16(s1)
  42:	00001597          	auipc	a1,0x1
  46:	91658593          	addi	a1,a1,-1770 # 958 <malloc+0x12a>
  4a:	4509                	li	a0,2
  4c:	700000ef          	jal	74c <fprintf>
  exit(1);
  50:	4505                	li	a0,1
  52:	2ce000ef          	jal	320 <exit>
    fprintf(2, "trace: failed\n"); 
  56:	00001597          	auipc	a1,0x1
  5a:	8f258593          	addi	a1,a1,-1806 # 948 <malloc+0x11a>
  5e:	4509                	li	a0,2
  60:	6ec000ef          	jal	74c <fprintf>
    exit(1);
  64:	4505                	li	a0,1
  66:	2ba000ef          	jal	320 <exit>

000000000000006a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  72:	f8fff0ef          	jal	0 <main>
  exit(r);
  76:	2aa000ef          	jal	320 <exit>

000000000000007a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0xa>
    ;
  return os;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cb91                	beqz	a5,ba <strcmp+0x20>
  a8:	0005c703          	lbu	a4,0(a1)
  ac:	00f71763          	bne	a4,a5,ba <strcmp+0x20>
    p++, q++;
  b0:	0505                	addi	a0,a0,1
  b2:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	fbe5                	bnez	a5,a8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x28>
  d8:	00150793          	addi	a5,a0,1
  dc:	86be                	mv	a3,a5
  de:	0785                	addi	a5,a5,1
  e0:	fff7c703          	lbu	a4,-1(a5)
  e4:	ff65                	bnez	a4,dc <strlen+0x12>
  e6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for (n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x20>

00000000000000f6 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char *
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for (; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf81                	beqz	a5,140 <strchr+0x24>
    if (*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for (; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char *)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfdd                	j	138 <strchr+0x1c>

0000000000000144 <gets>:

char *
gets(char *buf, int max)
{
 144:	711d                	addi	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	e862                	sd	s8,16(sp)
 15a:	1080                	addi	s0,sp,96
 15c:	8baa                	mv	s7,a0
 15e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 160:	892a                	mv	s2,a0
 162:	4481                	li	s1,0
    cc = read(0, &c, 1);
 164:	faf40b13          	addi	s6,s0,-81
 168:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 16a:	8c26                	mv	s8,s1
 16c:	0014899b          	addiw	s3,s1,1
 170:	84ce                	mv	s1,s3
 172:	0349d463          	bge	s3,s4,19a <gets+0x56>
    cc = read(0, &c, 1);
 176:	8656                	mv	a2,s5
 178:	85da                	mv	a1,s6
 17a:	4501                	li	a0,0
 17c:	1bc000ef          	jal	338 <read>
    if (cc < 1)
 180:	00a05d63          	blez	a0,19a <gets+0x56>
      break;
    buf[i++] = c;
 184:	faf44783          	lbu	a5,-81(s0)
 188:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 18c:	0905                	addi	s2,s2,1
 18e:	ff678713          	addi	a4,a5,-10
 192:	c319                	beqz	a4,198 <gets+0x54>
 194:	17cd                	addi	a5,a5,-13
 196:	fbf1                	bnez	a5,16a <gets+0x26>
    buf[i++] = c;
 198:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 19a:	9c5e                	add	s8,s8,s7
 19c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a0:	855e                	mv	a0,s7
 1a2:	60e6                	ld	ra,88(sp)
 1a4:	6446                	ld	s0,80(sp)
 1a6:	64a6                	ld	s1,72(sp)
 1a8:	6906                	ld	s2,64(sp)
 1aa:	79e2                	ld	s3,56(sp)
 1ac:	7a42                	ld	s4,48(sp)
 1ae:	7aa2                	ld	s5,40(sp)
 1b0:	7b02                	ld	s6,32(sp)
 1b2:	6be2                	ld	s7,24(sp)
 1b4:	6c42                	ld	s8,16(sp)
 1b6:	6125                	addi	sp,sp,96
 1b8:	8082                	ret

00000000000001ba <stat>:

int
stat(const char *n, struct stat *st)
{
 1ba:	1101                	addi	sp,sp,-32
 1bc:	ec06                	sd	ra,24(sp)
 1be:	e822                	sd	s0,16(sp)
 1c0:	e04a                	sd	s2,0(sp)
 1c2:	1000                	addi	s0,sp,32
 1c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c6:	4581                	li	a1,0
 1c8:	198000ef          	jal	360 <open>
  if (fd < 0)
 1cc:	02054263          	bltz	a0,1f0 <stat+0x36>
 1d0:	e426                	sd	s1,8(sp)
 1d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d4:	85ca                	mv	a1,s2
 1d6:	1a2000ef          	jal	378 <fstat>
 1da:	892a                	mv	s2,a0
  close(fd);
 1dc:	8526                	mv	a0,s1
 1de:	16a000ef          	jal	348 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	57fd                	li	a5,-1
 1f2:	893e                	mv	s2,a5
 1f4:	bfc5                	j	1e4 <stat+0x2a>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1fe:	00054683          	lbu	a3,0(a0)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	4625                	li	a2,9
 20c:	02f66963          	bltu	a2,a5,23e <atoi+0x48>
 210:	872a                	mv	a4,a0
  n = 0;
 212:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 214:	0705                	addi	a4,a4,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb5                	addw	a5,a5,a3
 222:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 226:	00074683          	lbu	a3,0(a4)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	fef671e3          	bgeu	a2,a5,214 <atoi+0x1e>
  return n;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  n = 0;
 23e:	4501                	li	a0,0
 240:	bfdd                	j	236 <atoi+0x40>

0000000000000242 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57563          	bgeu	a0,a1,274 <memmove+0x32>
    while (n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x2a>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	60a2                	ld	ra,8(sp)
 26e:	6402                	ld	s0,0(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    while (n-- > 0)
 274:	fec05ce3          	blez	a2,26c <memmove+0x2a>
    dst += n;
 278:	00c50733          	add	a4,a0,a2
    src += n;
 27c:	95b2                	add	a1,a1,a2
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 298:	fef71ae3          	bne	a4,a5,28c <memmove+0x4a>
 29c:	bfc1                	j	26c <memmove+0x2a>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a6:	c61d                	beqz	a2,2d4 <memcmp+0x36>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79863          	bne	a5,a4,2c8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x12>
  }
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	a019                	j	2cc <memcmp+0x2e>
      return *p1 - *p2;
 2c8:	40e7853b          	subw	a0,a5,a4
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfdd                	j	2cc <memcmp+0x2e>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f63ff0ef          	jal	242 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0b2000ef          	jal	3a8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	09c000ef          	jal	3a8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c8:	48dd                	li	a7,23
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	f5fff0ef          	jal	340 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ee:	715d                	addi	sp,sp,-80
 3f0:	e486                	sd	ra,72(sp)
 3f2:	e0a2                	sd	s0,64(sp)
 3f4:	f84a                	sd	s2,48(sp)
 3f6:	f44e                	sd	s3,40(sp)
 3f8:	0880                	addi	s0,sp,80
 3fa:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3fc:	c6d1                	beqz	a3,488 <printint+0x9a>
 3fe:	0805d563          	bgez	a1,488 <printint+0x9a>
    neg = 1;
    x = -xx;
 402:	40b005b3          	neg	a1,a1
    neg = 1;
 406:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 408:	fb840993          	addi	s3,s0,-72
  neg = 0;
 40c:	86ce                	mv	a3,s3
  i = 0;
 40e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 410:	00000817          	auipc	a6,0x0
 414:	56880813          	addi	a6,a6,1384 # 978 <digits>
 418:	88ba                	mv	a7,a4
 41a:	0017051b          	addiw	a0,a4,1
 41e:	872a                	mv	a4,a0
 420:	02c5f7b3          	remu	a5,a1,a2
 424:	97c2                	add	a5,a5,a6
 426:	0007c783          	lbu	a5,0(a5)
 42a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 42e:	87ae                	mv	a5,a1
 430:	02c5d5b3          	divu	a1,a1,a2
 434:	0685                	addi	a3,a3,1
 436:	fec7f1e3          	bgeu	a5,a2,418 <printint+0x2a>
  if (neg)
 43a:	00030c63          	beqz	t1,452 <printint+0x64>
    buf[i++] = '-';
 43e:	fd050793          	addi	a5,a0,-48
 442:	00878533          	add	a0,a5,s0
 446:	02d00793          	li	a5,45
 44a:	fef50423          	sb	a5,-24(a0)
 44e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 452:	02e05563          	blez	a4,47c <printint+0x8e>
 456:	fc26                	sd	s1,56(sp)
 458:	377d                	addiw	a4,a4,-1
 45a:	00e984b3          	add	s1,s3,a4
 45e:	19fd                	addi	s3,s3,-1
 460:	99ba                	add	s3,s3,a4
 462:	1702                	slli	a4,a4,0x20
 464:	9301                	srli	a4,a4,0x20
 466:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46a:	0004c583          	lbu	a1,0(s1)
 46e:	854a                	mv	a0,s2
 470:	f61ff0ef          	jal	3d0 <putc>
  while (--i >= 0)
 474:	14fd                	addi	s1,s1,-1
 476:	ff349ae3          	bne	s1,s3,46a <printint+0x7c>
 47a:	74e2                	ld	s1,56(sp)
}
 47c:	60a6                	ld	ra,72(sp)
 47e:	6406                	ld	s0,64(sp)
 480:	7942                	ld	s2,48(sp)
 482:	79a2                	ld	s3,40(sp)
 484:	6161                	addi	sp,sp,80
 486:	8082                	ret
  neg = 0;
 488:	4301                	li	t1,0
 48a:	bfbd                	j	408 <printint+0x1a>

000000000000048c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48c:	711d                	addi	sp,sp,-96
 48e:	ec86                	sd	ra,88(sp)
 490:	e8a2                	sd	s0,80(sp)
 492:	e4a6                	sd	s1,72(sp)
 494:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 496:	0005c483          	lbu	s1,0(a1)
 49a:	22048363          	beqz	s1,6c0 <vprintf+0x234>
 49e:	e0ca                	sd	s2,64(sp)
 4a0:	fc4e                	sd	s3,56(sp)
 4a2:	f852                	sd	s4,48(sp)
 4a4:	f456                	sd	s5,40(sp)
 4a6:	f05a                	sd	s6,32(sp)
 4a8:	ec5e                	sd	s7,24(sp)
 4aa:	e862                	sd	s8,16(sp)
 4ac:	8b2a                	mv	s6,a0
 4ae:	8a2e                	mv	s4,a1
 4b0:	8bb2                	mv	s7,a2
  state = 0;
 4b2:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4b4:	4901                	li	s2,0
 4b6:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4b8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4bc:	06400c13          	li	s8,100
 4c0:	a00d                	j	4e2 <vprintf+0x56>
        putc(fd, c0);
 4c2:	85a6                	mv	a1,s1
 4c4:	855a                	mv	a0,s6
 4c6:	f0bff0ef          	jal	3d0 <putc>
 4ca:	a019                	j	4d0 <vprintf+0x44>
    } else if (state == '%') {
 4cc:	03598363          	beq	s3,s5,4f2 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4d0:	0019079b          	addiw	a5,s2,1
 4d4:	893e                	mv	s2,a5
 4d6:	873e                	mv	a4,a5
 4d8:	97d2                	add	a5,a5,s4
 4da:	0007c483          	lbu	s1,0(a5)
 4de:	1c048a63          	beqz	s1,6b2 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4e2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4e6:	fe0993e3          	bnez	s3,4cc <vprintf+0x40>
      if (c0 == '%') {
 4ea:	fd579ce3          	bne	a5,s5,4c2 <vprintf+0x36>
        state = '%';
 4ee:	89be                	mv	s3,a5
 4f0:	b7c5                	j	4d0 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4f2:	00ea06b3          	add	a3,s4,a4
 4f6:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4fa:	1c060863          	beqz	a2,6ca <vprintf+0x23e>
      if (c0 == 'd') {
 4fe:	03878763          	beq	a5,s8,52c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 502:	f9478693          	addi	a3,a5,-108
 506:	0016b693          	seqz	a3,a3
 50a:	f9c60593          	addi	a1,a2,-100
 50e:	e99d                	bnez	a1,544 <vprintf+0xb8>
 510:	ca95                	beqz	a3,544 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 512:	008b8493          	addi	s1,s7,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000bb583          	ld	a1,0(s7)
 51e:	855a                	mv	a0,s6
 520:	ecfff0ef          	jal	3ee <printint>
        i += 1;
 524:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 528:	4981                	li	s3,0
 52a:	b75d                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 52c:	008b8493          	addi	s1,s7,8
 530:	4685                	li	a3,1
 532:	4629                	li	a2,10
 534:	000ba583          	lw	a1,0(s7)
 538:	855a                	mv	a0,s6
 53a:	eb5ff0ef          	jal	3ee <printint>
 53e:	8ba6                	mv	s7,s1
      state = 0;
 540:	4981                	li	s3,0
 542:	b779                	j	4d0 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 544:	9752                	add	a4,a4,s4
 546:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 54a:	f9460713          	addi	a4,a2,-108
 54e:	00173713          	seqz	a4,a4
 552:	8f75                	and	a4,a4,a3
 554:	f9c58513          	addi	a0,a1,-100
 558:	18051363          	bnez	a0,6de <vprintf+0x252>
 55c:	18070163          	beqz	a4,6de <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 560:	008b8493          	addi	s1,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000bb583          	ld	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	e81ff0ef          	jal	3ee <printint>
        i += 2;
 572:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
        i += 2;
 578:	bfa1                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000be583          	lwu	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e67ff0ef          	jal	3ee <printint>
 58c:	8ba6                	mv	s7,s1
      state = 0;
 58e:	4981                	li	s3,0
 590:	b781                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 592:	008b8493          	addi	s1,s7,8
 596:	4681                	li	a3,0
 598:	4629                	li	a2,10
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e4fff0ef          	jal	3ee <printint>
        i += 1;
 5a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a6:	8ba6                	mv	s7,s1
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b71d                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ac:	008b8493          	addi	s1,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000bb583          	ld	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e35ff0ef          	jal	3ee <printint>
        i += 2;
 5be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
        i += 2;
 5c4:	b731                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000be583          	lwu	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e1bff0ef          	jal	3ee <printint>
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	bdd5                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4641                	li	a2,16
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e03ff0ef          	jal	3ee <printint>
        i += 1;
 5f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bde9                	j	4d0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	de9ff0ef          	jal	3ee <printint>
        i += 2;
 60a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	b5c1                	j	4d0 <vprintf+0x44>
 612:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 614:	008b8793          	addi	a5,s7,8
 618:	8cbe                	mv	s9,a5
 61a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61e:	03000593          	li	a1,48
 622:	855a                	mv	a0,s6
 624:	dadff0ef          	jal	3d0 <putc>
  putc(fd, 'x');
 628:	07800593          	li	a1,120
 62c:	855a                	mv	a0,s6
 62e:	da3ff0ef          	jal	3d0 <putc>
 632:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 634:	00000b97          	auipc	s7,0x0
 638:	344b8b93          	addi	s7,s7,836 # 978 <digits>
 63c:	03c9d793          	srli	a5,s3,0x3c
 640:	97de                	add	a5,a5,s7
 642:	0007c583          	lbu	a1,0(a5)
 646:	855a                	mv	a0,s6
 648:	d89ff0ef          	jal	3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64c:	0992                	slli	s3,s3,0x4
 64e:	34fd                	addiw	s1,s1,-1
 650:	f4f5                	bnez	s1,63c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 652:	8be6                	mv	s7,s9
      state = 0;
 654:	4981                	li	s3,0
 656:	6ca2                	ld	s9,8(sp)
 658:	bda5                	j	4d0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 65a:	008b8493          	addi	s1,s7,8
 65e:	000bc583          	lbu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	d6dff0ef          	jal	3d0 <putc>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b595                	j	4d0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 66e:	008b8993          	addi	s3,s7,8
 672:	000bb483          	ld	s1,0(s7)
 676:	cc91                	beqz	s1,692 <vprintf+0x206>
        for (; *s; s++)
 678:	0004c583          	lbu	a1,0(s1)
 67c:	c985                	beqz	a1,6ac <vprintf+0x220>
          putc(fd, *s);
 67e:	855a                	mv	a0,s6
 680:	d51ff0ef          	jal	3d0 <putc>
        for (; *s; s++)
 684:	0485                	addi	s1,s1,1
 686:	0004c583          	lbu	a1,0(s1)
 68a:	f9f5                	bnez	a1,67e <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b581                	j	4d0 <vprintf+0x44>
          s = "(null)";
 692:	00000497          	auipc	s1,0x0
 696:	2de48493          	addi	s1,s1,734 # 970 <malloc+0x142>
        for (; *s; s++)
 69a:	02800593          	li	a1,40
 69e:	b7c5                	j	67e <vprintf+0x1f2>
        putc(fd, '%');
 6a0:	85be                	mv	a1,a5
 6a2:	855a                	mv	a0,s6
 6a4:	d2dff0ef          	jal	3d0 <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b51d                	j	4d0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b505                	j	4d0 <vprintf+0x44>
 6b2:	6906                	ld	s2,64(sp)
 6b4:	79e2                	ld	s3,56(sp)
 6b6:	7a42                	ld	s4,48(sp)
 6b8:	7aa2                	ld	s5,40(sp)
 6ba:	7b02                	ld	s6,32(sp)
 6bc:	6be2                	ld	s7,24(sp)
 6be:	6c42                	ld	s8,16(sp)
    }
  }
}
 6c0:	60e6                	ld	ra,88(sp)
 6c2:	6446                	ld	s0,80(sp)
 6c4:	64a6                	ld	s1,72(sp)
 6c6:	6125                	addi	sp,sp,96
 6c8:	8082                	ret
      if (c0 == 'd') {
 6ca:	06400713          	li	a4,100
 6ce:	e4e78fe3          	beq	a5,a4,52c <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 6d2:	f9478693          	addi	a3,a5,-108
 6d6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6da:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6dc:	4701                	li	a4,0
      } else if (c0 == 'u') {
 6de:	07500513          	li	a0,117
 6e2:	e8a78ce3          	beq	a5,a0,57a <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6e6:	f8b60513          	addi	a0,a2,-117
 6ea:	e119                	bnez	a0,6f0 <vprintf+0x264>
 6ec:	ea0693e3          	bnez	a3,592 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6f0:	f8b58513          	addi	a0,a1,-117
 6f4:	e119                	bnez	a0,6fa <vprintf+0x26e>
 6f6:	ea071be3          	bnez	a4,5ac <vprintf+0x120>
      } else if (c0 == 'x') {
 6fa:	07800513          	li	a0,120
 6fe:	eca784e3          	beq	a5,a0,5c6 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 702:	f8860613          	addi	a2,a2,-120
 706:	e219                	bnez	a2,70c <vprintf+0x280>
 708:	ec069be3          	bnez	a3,5de <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 70c:	f8858593          	addi	a1,a1,-120
 710:	e199                	bnez	a1,716 <vprintf+0x28a>
 712:	ee0713e3          	bnez	a4,5f8 <vprintf+0x16c>
      } else if (c0 == 'p') {
 716:	07000713          	li	a4,112
 71a:	eee78ce3          	beq	a5,a4,612 <vprintf+0x186>
      } else if (c0 == 'c') {
 71e:	06300713          	li	a4,99
 722:	f2e78ce3          	beq	a5,a4,65a <vprintf+0x1ce>
      } else if (c0 == 's') {
 726:	07300713          	li	a4,115
 72a:	f4e782e3          	beq	a5,a4,66e <vprintf+0x1e2>
      } else if (c0 == '%') {
 72e:	02500713          	li	a4,37
 732:	f6e787e3          	beq	a5,a4,6a0 <vprintf+0x214>
        putc(fd, '%');
 736:	02500593          	li	a1,37
 73a:	855a                	mv	a0,s6
 73c:	c95ff0ef          	jal	3d0 <putc>
        putc(fd, c0);
 740:	85a6                	mv	a1,s1
 742:	855a                	mv	a0,s6
 744:	c8dff0ef          	jal	3d0 <putc>
      state = 0;
 748:	4981                	li	s3,0
 74a:	b359                	j	4d0 <vprintf+0x44>

000000000000074c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74c:	715d                	addi	sp,sp,-80
 74e:	ec06                	sd	ra,24(sp)
 750:	e822                	sd	s0,16(sp)
 752:	1000                	addi	s0,sp,32
 754:	e010                	sd	a2,0(s0)
 756:	e414                	sd	a3,8(s0)
 758:	e818                	sd	a4,16(s0)
 75a:	ec1c                	sd	a5,24(s0)
 75c:	03043023          	sd	a6,32(s0)
 760:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	8622                	mv	a2,s0
 766:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76a:	d23ff0ef          	jal	48c <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	cf1ff0ef          	jal	48c <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e406                	sd	ra,8(sp)
 7ac:	e022                	sd	s0,0(sp)
 7ae:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7b0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	00001797          	auipc	a5,0x1
 7b8:	84c7b783          	ld	a5,-1972(a5) # 1000 <freep>
 7bc:	a039                	j	7ca <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	6398                	ld	a4,0(a5)
 7c0:	00e7e463          	bltu	a5,a4,7c8 <free+0x20>
 7c4:	00e6ea63          	bltu	a3,a4,7d8 <free+0x30>
{
 7c8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	fed7fae3          	bgeu	a5,a3,7be <free+0x16>
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e6e463          	bltu	a3,a4,7d8 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	fee7eae3          	bltu	a5,a4,7c8 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7d8:	ff852583          	lw	a1,-8(a0)
 7dc:	6390                	ld	a2,0(a5)
 7de:	02059813          	slli	a6,a1,0x20
 7e2:	01c85713          	srli	a4,a6,0x1c
 7e6:	9736                	add	a4,a4,a3
 7e8:	02e60563          	beq	a2,a4,812 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7f0:	4790                	lw	a2,8(a5)
 7f2:	02061593          	slli	a1,a2,0x20
 7f6:	01c5d713          	srli	a4,a1,0x1c
 7fa:	973e                	add	a4,a4,a5
 7fc:	02e68263          	beq	a3,a4,820 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 800:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 802:	00000717          	auipc	a4,0x0
 806:	7ef73f23          	sd	a5,2046(a4) # 1000 <freep>
}
 80a:	60a2                	ld	ra,8(sp)
 80c:	6402                	ld	s0,0(sp)
 80e:	0141                	addi	sp,sp,16
 810:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 812:	4618                	lw	a4,8(a2)
 814:	9f2d                	addw	a4,a4,a1
 816:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81a:	6398                	ld	a4,0(a5)
 81c:	6310                	ld	a2,0(a4)
 81e:	b7f9                	j	7ec <free+0x44>
    p->s.size += bp->s.size;
 820:	ff852703          	lw	a4,-8(a0)
 824:	9f31                	addw	a4,a4,a2
 826:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 828:	ff053683          	ld	a3,-16(a0)
 82c:	bfd1                	j	800 <free+0x58>

000000000000082e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 82e:	7139                	addi	sp,sp,-64
 830:	fc06                	sd	ra,56(sp)
 832:	f822                	sd	s0,48(sp)
 834:	f04a                	sd	s2,32(sp)
 836:	ec4e                	sd	s3,24(sp)
 838:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 83a:	02051993          	slli	s3,a0,0x20
 83e:	0209d993          	srli	s3,s3,0x20
 842:	09bd                	addi	s3,s3,15
 844:	0049d993          	srli	s3,s3,0x4
 848:	2985                	addiw	s3,s3,1
 84a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 84c:	00000517          	auipc	a0,0x0
 850:	7b453503          	ld	a0,1972(a0) # 1000 <freep>
 854:	c905                	beqz	a0,884 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 856:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 858:	4798                	lw	a4,8(a5)
 85a:	09377663          	bgeu	a4,s3,8e6 <malloc+0xb8>
 85e:	f426                	sd	s1,40(sp)
 860:	e852                	sd	s4,16(sp)
 862:	e456                	sd	s5,8(sp)
 864:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 866:	8a4e                	mv	s4,s3
 868:	6705                	lui	a4,0x1
 86a:	00e9f363          	bgeu	s3,a4,870 <malloc+0x42>
 86e:	6a05                	lui	s4,0x1
 870:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 874:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 878:	00000497          	auipc	s1,0x0
 87c:	78848493          	addi	s1,s1,1928 # 1000 <freep>
  if (p == SBRK_ERROR)
 880:	5afd                	li	s5,-1
 882:	a83d                	j	8c0 <malloc+0x92>
 884:	f426                	sd	s1,40(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88c:	00000797          	auipc	a5,0x0
 890:	78478793          	addi	a5,a5,1924 # 1010 <base>
 894:	00000717          	auipc	a4,0x0
 898:	76f73623          	sd	a5,1900(a4) # 1000 <freep>
 89c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8a2:	b7d1                	j	866 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a4:	6398                	ld	a4,0(a5)
 8a6:	e118                	sd	a4,0(a0)
 8a8:	a899                	j	8fe <malloc+0xd0>
  hp->s.size = nu;
 8aa:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8ae:	0541                	addi	a0,a0,16
 8b0:	ef9ff0ef          	jal	7a8 <free>
  return freep;
 8b4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8b6:	c125                	beqz	a0,916 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ba:	4798                	lw	a4,8(a5)
 8bc:	03277163          	bgeu	a4,s2,8de <malloc+0xb0>
    if (p == freep)
 8c0:	6098                	ld	a4,0(s1)
 8c2:	853e                	mv	a0,a5
 8c4:	fef71ae3          	bne	a4,a5,8b8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c8:	8552                	mv	a0,s4
 8ca:	a23ff0ef          	jal	2ec <sbrk>
  if (p == SBRK_ERROR)
 8ce:	fd551ee3          	bne	a0,s5,8aa <malloc+0x7c>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	74a2                	ld	s1,40(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	a03d                	j	90a <malloc+0xdc>
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e6:	fae90fe3          	beq	s2,a4,8a4 <malloc+0x76>
        p->s.size -= nunits;
 8ea:	4137073b          	subw	a4,a4,s3
 8ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f0:	02071693          	slli	a3,a4,0x20
 8f4:	01c6d713          	srli	a4,a3,0x1c
 8f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fe:	00000717          	auipc	a4,0x0
 902:	70a73123          	sd	a0,1794(a4) # 1000 <freep>
      return (void *)(p + 1);
 906:	01078513          	addi	a0,a5,16
  }
}
 90a:	70e2                	ld	ra,56(sp)
 90c:	7442                	ld	s0,48(sp)
 90e:	7902                	ld	s2,32(sp)
 910:	69e2                	ld	s3,24(sp)
 912:	6121                	addi	sp,sp,64
 914:	8082                	ret
 916:	74a2                	ld	s1,40(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	b7f5                	j	90a <malloc+0xdc>
