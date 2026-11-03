
user/_sync:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sync();
   8:	360000ef          	jal	368 <sync>
  exit(0);
   c:	4501                	li	a0,0
   e:	2ba000ef          	jal	2c8 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2aa000ef          	jal	2c8 <exit>

0000000000000022 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x28>
  80:	00150793          	addi	a5,a0,1
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for (n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x20>

000000000000009e <memset>:

void *
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char *
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for (; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf81                	beqz	a5,e8 <strchr+0x24>
    if (*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for (; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char *)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfdd                	j	e0 <strchr+0x1c>

00000000000000ec <gets>:

char *
gets(char *buf, int max)
{
  ec:	711d                	addi	sp,sp,-96
  ee:	ec86                	sd	ra,88(sp)
  f0:	e8a2                	sd	s0,80(sp)
  f2:	e4a6                	sd	s1,72(sp)
  f4:	e0ca                	sd	s2,64(sp)
  f6:	fc4e                	sd	s3,56(sp)
  f8:	f852                	sd	s4,48(sp)
  fa:	f456                	sd	s5,40(sp)
  fc:	f05a                	sd	s6,32(sp)
  fe:	ec5e                	sd	s7,24(sp)
 100:	e862                	sd	s8,16(sp)
 102:	1080                	addi	s0,sp,96
 104:	8baa                	mv	s7,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10c:	faf40b13          	addi	s6,s0,-81
 110:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 112:	8c26                	mv	s8,s1
 114:	0014899b          	addiw	s3,s1,1
 118:	84ce                	mv	s1,s3
 11a:	0349d463          	bge	s3,s4,142 <gets+0x56>
    cc = read(0, &c, 1);
 11e:	8656                	mv	a2,s5
 120:	85da                	mv	a1,s6
 122:	4501                	li	a0,0
 124:	1bc000ef          	jal	2e0 <read>
    if (cc < 1)
 128:	00a05d63          	blez	a0,142 <gets+0x56>
      break;
    buf[i++] = c;
 12c:	faf44783          	lbu	a5,-81(s0)
 130:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 134:	0905                	addi	s2,s2,1
 136:	ff678713          	addi	a4,a5,-10
 13a:	c319                	beqz	a4,140 <gets+0x54>
 13c:	17cd                	addi	a5,a5,-13
 13e:	fbf1                	bnez	a5,112 <gets+0x26>
    buf[i++] = c;
 140:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 142:	9c5e                	add	s8,s8,s7
 144:	000c0023          	sb	zero,0(s8)
  return buf;
}
 148:	855e                	mv	a0,s7
 14a:	60e6                	ld	ra,88(sp)
 14c:	6446                	ld	s0,80(sp)
 14e:	64a6                	ld	s1,72(sp)
 150:	6906                	ld	s2,64(sp)
 152:	79e2                	ld	s3,56(sp)
 154:	7a42                	ld	s4,48(sp)
 156:	7aa2                	ld	s5,40(sp)
 158:	7b02                	ld	s6,32(sp)
 15a:	6be2                	ld	s7,24(sp)
 15c:	6c42                	ld	s8,16(sp)
 15e:	6125                	addi	sp,sp,96
 160:	8082                	ret

0000000000000162 <stat>:

int
stat(const char *n, struct stat *st)
{
 162:	1101                	addi	sp,sp,-32
 164:	ec06                	sd	ra,24(sp)
 166:	e822                	sd	s0,16(sp)
 168:	e04a                	sd	s2,0(sp)
 16a:	1000                	addi	s0,sp,32
 16c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16e:	4581                	li	a1,0
 170:	198000ef          	jal	308 <open>
  if (fd < 0)
 174:	02054263          	bltz	a0,198 <stat+0x36>
 178:	e426                	sd	s1,8(sp)
 17a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17c:	85ca                	mv	a1,s2
 17e:	1a2000ef          	jal	320 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	16a000ef          	jal	2f0 <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	57fd                	li	a5,-1
 19a:	893e                	mv	s2,a5
 19c:	bfc5                	j	18c <stat+0x2a>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1a6:	00054683          	lbu	a3,0(a0)
 1aa:	fd06879b          	addiw	a5,a3,-48
 1ae:	0ff7f793          	zext.b	a5,a5
 1b2:	4625                	li	a2,9
 1b4:	02f66963          	bltu	a2,a5,1e6 <atoi+0x48>
 1b8:	872a                	mv	a4,a0
  n = 0;
 1ba:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1bc:	0705                	addi	a4,a4,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb5                	addw	a5,a5,a3
 1ca:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1ce:	00074683          	lbu	a3,0(a4)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	fef671e3          	bgeu	a2,a5,1bc <atoi+0x1e>
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <atoi+0x40>

00000000000001ea <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57563          	bgeu	a0,a1,21c <memmove+0x32>
    while (n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x2a>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	60a2                	ld	ra,8(sp)
 216:	6402                	ld	s0,0(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    while (n-- > 0)
 21c:	fec05ce3          	blez	a2,214 <memmove+0x2a>
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 240:	fef71ae3          	bne	a4,a5,234 <memmove+0x4a>
 244:	bfc1                	j	214 <memmove+0x2a>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e406                	sd	ra,8(sp)
 24a:	e022                	sd	s0,0(sp)
 24c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24e:	c61d                	beqz	a2,27c <memcmp+0x36>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x12>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x2e>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <memcmp+0x2e>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f63ff0ef          	jal	1ea <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrk>:

char *
sbrk(int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29c:	4585                	li	a1,1
 29e:	0b2000ef          	jal	350 <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrklazy>:

char *
sbrklazy(int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b2:	4589                	li	a1,2
 2b4:	09c000ef          	jal	350 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d8:	4891                	li	a7,4
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <read>:
.global read
read:
 li a7, SYS_read
 2e0:	4895                	li	a7,5
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <write>:
.global write
write:
 li a7, SYS_write
 2e8:	48c1                	li	a7,16
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <close>:
.global close
close:
 li a7, SYS_close
 2f0:	48d5                	li	a7,21
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f8:	4899                	li	a7,6
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exec>:
.global exec
exec:
 li a7, SYS_exec
 300:	489d                	li	a7,7
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <open>:
.global open
open:
 li a7, SYS_open
 308:	48bd                	li	a7,15
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 310:	48c5                	li	a7,17
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 318:	48c9                	li	a7,18
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 320:	48a1                	li	a7,8
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <link>:
.global link
link:
 li a7, SYS_link
 328:	48cd                	li	a7,19
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 330:	48d1                	li	a7,20
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 338:	48a5                	li	a7,9
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <dup>:
.global dup
dup:
 li a7, SYS_dup
 340:	48a9                	li	a7,10
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 348:	48ad                	li	a7,11
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 350:	48b1                	li	a7,12
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pause>:
.global pause
pause:
 li a7, SYS_pause
 358:	48b5                	li	a7,13
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 360:	48b9                	li	a7,14
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sync>:
.global sync
sync:
 li a7, SYS_sync
 368:	48d9                	li	a7,22
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <trace>:
.global trace
trace:
 li a7, SYS_trace
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	f5fff0ef          	jal	2e8 <write>
}
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret

0000000000000396 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 396:	715d                	addi	sp,sp,-80
 398:	e486                	sd	ra,72(sp)
 39a:	e0a2                	sd	s0,64(sp)
 39c:	f84a                	sd	s2,48(sp)
 39e:	f44e                	sd	s3,40(sp)
 3a0:	0880                	addi	s0,sp,80
 3a2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3a4:	c6d1                	beqz	a3,430 <printint+0x9a>
 3a6:	0805d563          	bgez	a1,430 <printint+0x9a>
    neg = 1;
    x = -xx;
 3aa:	40b005b3          	neg	a1,a1
    neg = 1;
 3ae:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3b0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3b4:	86ce                	mv	a3,s3
  i = 0;
 3b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3b8:	00000817          	auipc	a6,0x0
 3bc:	52080813          	addi	a6,a6,1312 # 8d8 <digits>
 3c0:	88ba                	mv	a7,a4
 3c2:	0017051b          	addiw	a0,a4,1
 3c6:	872a                	mv	a4,a0
 3c8:	02c5f7b3          	remu	a5,a1,a2
 3cc:	97c2                	add	a5,a5,a6
 3ce:	0007c783          	lbu	a5,0(a5)
 3d2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3d6:	87ae                	mv	a5,a1
 3d8:	02c5d5b3          	divu	a1,a1,a2
 3dc:	0685                	addi	a3,a3,1
 3de:	fec7f1e3          	bgeu	a5,a2,3c0 <printint+0x2a>
  if (neg)
 3e2:	00030c63          	beqz	t1,3fa <printint+0x64>
    buf[i++] = '-';
 3e6:	fd050793          	addi	a5,a0,-48
 3ea:	00878533          	add	a0,a5,s0
 3ee:	02d00793          	li	a5,45
 3f2:	fef50423          	sb	a5,-24(a0)
 3f6:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 3fa:	02e05563          	blez	a4,424 <printint+0x8e>
 3fe:	fc26                	sd	s1,56(sp)
 400:	377d                	addiw	a4,a4,-1
 402:	00e984b3          	add	s1,s3,a4
 406:	19fd                	addi	s3,s3,-1
 408:	99ba                	add	s3,s3,a4
 40a:	1702                	slli	a4,a4,0x20
 40c:	9301                	srli	a4,a4,0x20
 40e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 412:	0004c583          	lbu	a1,0(s1)
 416:	854a                	mv	a0,s2
 418:	f61ff0ef          	jal	378 <putc>
  while (--i >= 0)
 41c:	14fd                	addi	s1,s1,-1
 41e:	ff349ae3          	bne	s1,s3,412 <printint+0x7c>
 422:	74e2                	ld	s1,56(sp)
}
 424:	60a6                	ld	ra,72(sp)
 426:	6406                	ld	s0,64(sp)
 428:	7942                	ld	s2,48(sp)
 42a:	79a2                	ld	s3,40(sp)
 42c:	6161                	addi	sp,sp,80
 42e:	8082                	ret
  neg = 0;
 430:	4301                	li	t1,0
 432:	bfbd                	j	3b0 <printint+0x1a>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	711d                	addi	sp,sp,-96
 436:	ec86                	sd	ra,88(sp)
 438:	e8a2                	sd	s0,80(sp)
 43a:	e4a6                	sd	s1,72(sp)
 43c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 43e:	0005c483          	lbu	s1,0(a1)
 442:	22048363          	beqz	s1,668 <vprintf+0x234>
 446:	e0ca                	sd	s2,64(sp)
 448:	fc4e                	sd	s3,56(sp)
 44a:	f852                	sd	s4,48(sp)
 44c:	f456                	sd	s5,40(sp)
 44e:	f05a                	sd	s6,32(sp)
 450:	ec5e                	sd	s7,24(sp)
 452:	e862                	sd	s8,16(sp)
 454:	8b2a                	mv	s6,a0
 456:	8a2e                	mv	s4,a1
 458:	8bb2                	mv	s7,a2
  state = 0;
 45a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 45c:	4901                	li	s2,0
 45e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 460:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 464:	06400c13          	li	s8,100
 468:	a00d                	j	48a <vprintf+0x56>
        putc(fd, c0);
 46a:	85a6                	mv	a1,s1
 46c:	855a                	mv	a0,s6
 46e:	f0bff0ef          	jal	378 <putc>
 472:	a019                	j	478 <vprintf+0x44>
    } else if (state == '%') {
 474:	03598363          	beq	s3,s5,49a <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 478:	0019079b          	addiw	a5,s2,1
 47c:	893e                	mv	s2,a5
 47e:	873e                	mv	a4,a5
 480:	97d2                	add	a5,a5,s4
 482:	0007c483          	lbu	s1,0(a5)
 486:	1c048a63          	beqz	s1,65a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 48a:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 48e:	fe0993e3          	bnez	s3,474 <vprintf+0x40>
      if (c0 == '%') {
 492:	fd579ce3          	bne	a5,s5,46a <vprintf+0x36>
        state = '%';
 496:	89be                	mv	s3,a5
 498:	b7c5                	j	478 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 49a:	00ea06b3          	add	a3,s4,a4
 49e:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4a2:	1c060863          	beqz	a2,672 <vprintf+0x23e>
      if (c0 == 'd') {
 4a6:	03878763          	beq	a5,s8,4d4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4aa:	f9478693          	addi	a3,a5,-108
 4ae:	0016b693          	seqz	a3,a3
 4b2:	f9c60593          	addi	a1,a2,-100
 4b6:	e99d                	bnez	a1,4ec <vprintf+0xb8>
 4b8:	ca95                	beqz	a3,4ec <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ba:	008b8493          	addi	s1,s7,8
 4be:	4685                	li	a3,1
 4c0:	4629                	li	a2,10
 4c2:	000bb583          	ld	a1,0(s7)
 4c6:	855a                	mv	a0,s6
 4c8:	ecfff0ef          	jal	396 <printint>
        i += 1;
 4cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ce:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4d0:	4981                	li	s3,0
 4d2:	b75d                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4d4:	008b8493          	addi	s1,s7,8
 4d8:	4685                	li	a3,1
 4da:	4629                	li	a2,10
 4dc:	000ba583          	lw	a1,0(s7)
 4e0:	855a                	mv	a0,s6
 4e2:	eb5ff0ef          	jal	396 <printint>
 4e6:	8ba6                	mv	s7,s1
      state = 0;
 4e8:	4981                	li	s3,0
 4ea:	b779                	j	478 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 4ec:	9752                	add	a4,a4,s4
 4ee:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4f2:	f9460713          	addi	a4,a2,-108
 4f6:	00173713          	seqz	a4,a4
 4fa:	8f75                	and	a4,a4,a3
 4fc:	f9c58513          	addi	a0,a1,-100
 500:	18051363          	bnez	a0,686 <vprintf+0x252>
 504:	18070163          	beqz	a4,686 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 508:	008b8493          	addi	s1,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000bb583          	ld	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	e81ff0ef          	jal	396 <printint>
        i += 2;
 51a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	8ba6                	mv	s7,s1
      state = 0;
 51e:	4981                	li	s3,0
        i += 2;
 520:	bfa1                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 522:	008b8493          	addi	s1,s7,8
 526:	4681                	li	a3,0
 528:	4629                	li	a2,10
 52a:	000be583          	lwu	a1,0(s7)
 52e:	855a                	mv	a0,s6
 530:	e67ff0ef          	jal	396 <printint>
 534:	8ba6                	mv	s7,s1
      state = 0;
 536:	4981                	li	s3,0
 538:	b781                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4681                	li	a3,0
 540:	4629                	li	a2,10
 542:	000bb583          	ld	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e4fff0ef          	jal	396 <printint>
        i += 1;
 54c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 54e:	8ba6                	mv	s7,s1
      state = 0;
 550:	4981                	li	s3,0
 552:	b71d                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 554:	008b8493          	addi	s1,s7,8
 558:	4681                	li	a3,0
 55a:	4629                	li	a2,10
 55c:	000bb583          	ld	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e35ff0ef          	jal	396 <printint>
        i += 2;
 566:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
        i += 2;
 56c:	b731                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 56e:	008b8493          	addi	s1,s7,8
 572:	4681                	li	a3,0
 574:	4641                	li	a2,16
 576:	000be583          	lwu	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e1bff0ef          	jal	396 <printint>
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	bdd5                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4641                	li	a2,16
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e03ff0ef          	jal	396 <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bde9                	j	478 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000bb583          	ld	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	de9ff0ef          	jal	396 <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	b5c1                	j	478 <vprintf+0x44>
 5ba:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5bc:	008b8793          	addi	a5,s7,8
 5c0:	8cbe                	mv	s9,a5
 5c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c6:	03000593          	li	a1,48
 5ca:	855a                	mv	a0,s6
 5cc:	dadff0ef          	jal	378 <putc>
  putc(fd, 'x');
 5d0:	07800593          	li	a1,120
 5d4:	855a                	mv	a0,s6
 5d6:	da3ff0ef          	jal	378 <putc>
 5da:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5dc:	00000b97          	auipc	s7,0x0
 5e0:	2fcb8b93          	addi	s7,s7,764 # 8d8 <digits>
 5e4:	03c9d793          	srli	a5,s3,0x3c
 5e8:	97de                	add	a5,a5,s7
 5ea:	0007c583          	lbu	a1,0(a5)
 5ee:	855a                	mv	a0,s6
 5f0:	d89ff0ef          	jal	378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f4:	0992                	slli	s3,s3,0x4
 5f6:	34fd                	addiw	s1,s1,-1
 5f8:	f4f5                	bnez	s1,5e4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5fa:	8be6                	mv	s7,s9
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	6ca2                	ld	s9,8(sp)
 600:	bda5                	j	478 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 602:	008b8493          	addi	s1,s7,8
 606:	000bc583          	lbu	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	d6dff0ef          	jal	378 <putc>
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	b595                	j	478 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 616:	008b8993          	addi	s3,s7,8
 61a:	000bb483          	ld	s1,0(s7)
 61e:	cc91                	beqz	s1,63a <vprintf+0x206>
        for (; *s; s++)
 620:	0004c583          	lbu	a1,0(s1)
 624:	c985                	beqz	a1,654 <vprintf+0x220>
          putc(fd, *s);
 626:	855a                	mv	a0,s6
 628:	d51ff0ef          	jal	378 <putc>
        for (; *s; s++)
 62c:	0485                	addi	s1,s1,1
 62e:	0004c583          	lbu	a1,0(s1)
 632:	f9f5                	bnez	a1,626 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 634:	8bce                	mv	s7,s3
      state = 0;
 636:	4981                	li	s3,0
 638:	b581                	j	478 <vprintf+0x44>
          s = "(null)";
 63a:	00000497          	auipc	s1,0x0
 63e:	29648493          	addi	s1,s1,662 # 8d0 <malloc+0xfa>
        for (; *s; s++)
 642:	02800593          	li	a1,40
 646:	b7c5                	j	626 <vprintf+0x1f2>
        putc(fd, '%');
 648:	85be                	mv	a1,a5
 64a:	855a                	mv	a0,s6
 64c:	d2dff0ef          	jal	378 <putc>
      state = 0;
 650:	4981                	li	s3,0
 652:	b51d                	j	478 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 654:	8bce                	mv	s7,s3
      state = 0;
 656:	4981                	li	s3,0
 658:	b505                	j	478 <vprintf+0x44>
 65a:	6906                	ld	s2,64(sp)
 65c:	79e2                	ld	s3,56(sp)
 65e:	7a42                	ld	s4,48(sp)
 660:	7aa2                	ld	s5,40(sp)
 662:	7b02                	ld	s6,32(sp)
 664:	6be2                	ld	s7,24(sp)
 666:	6c42                	ld	s8,16(sp)
    }
  }
}
 668:	60e6                	ld	ra,88(sp)
 66a:	6446                	ld	s0,80(sp)
 66c:	64a6                	ld	s1,72(sp)
 66e:	6125                	addi	sp,sp,96
 670:	8082                	ret
      if (c0 == 'd') {
 672:	06400713          	li	a4,100
 676:	e4e78fe3          	beq	a5,a4,4d4 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 67a:	f9478693          	addi	a3,a5,-108
 67e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 682:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 684:	4701                	li	a4,0
      } else if (c0 == 'u') {
 686:	07500513          	li	a0,117
 68a:	e8a78ce3          	beq	a5,a0,522 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 68e:	f8b60513          	addi	a0,a2,-117
 692:	e119                	bnez	a0,698 <vprintf+0x264>
 694:	ea0693e3          	bnez	a3,53a <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 698:	f8b58513          	addi	a0,a1,-117
 69c:	e119                	bnez	a0,6a2 <vprintf+0x26e>
 69e:	ea071be3          	bnez	a4,554 <vprintf+0x120>
      } else if (c0 == 'x') {
 6a2:	07800513          	li	a0,120
 6a6:	eca784e3          	beq	a5,a0,56e <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 6aa:	f8860613          	addi	a2,a2,-120
 6ae:	e219                	bnez	a2,6b4 <vprintf+0x280>
 6b0:	ec069be3          	bnez	a3,586 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6b4:	f8858593          	addi	a1,a1,-120
 6b8:	e199                	bnez	a1,6be <vprintf+0x28a>
 6ba:	ee0713e3          	bnez	a4,5a0 <vprintf+0x16c>
      } else if (c0 == 'p') {
 6be:	07000713          	li	a4,112
 6c2:	eee78ce3          	beq	a5,a4,5ba <vprintf+0x186>
      } else if (c0 == 'c') {
 6c6:	06300713          	li	a4,99
 6ca:	f2e78ce3          	beq	a5,a4,602 <vprintf+0x1ce>
      } else if (c0 == 's') {
 6ce:	07300713          	li	a4,115
 6d2:	f4e782e3          	beq	a5,a4,616 <vprintf+0x1e2>
      } else if (c0 == '%') {
 6d6:	02500713          	li	a4,37
 6da:	f6e787e3          	beq	a5,a4,648 <vprintf+0x214>
        putc(fd, '%');
 6de:	02500593          	li	a1,37
 6e2:	855a                	mv	a0,s6
 6e4:	c95ff0ef          	jal	378 <putc>
        putc(fd, c0);
 6e8:	85a6                	mv	a1,s1
 6ea:	855a                	mv	a0,s6
 6ec:	c8dff0ef          	jal	378 <putc>
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b359                	j	478 <vprintf+0x44>

00000000000006f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f4:	715d                	addi	sp,sp,-80
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e010                	sd	a2,0(s0)
 6fe:	e414                	sd	a3,8(s0)
 700:	e818                	sd	a4,16(s0)
 702:	ec1c                	sd	a5,24(s0)
 704:	03043023          	sd	a6,32(s0)
 708:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	8622                	mv	a2,s0
 70e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 712:	d23ff0ef          	jal	434 <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6161                	addi	sp,sp,80
 71c:	8082                	ret

000000000000071e <printf>:

void
printf(const char *fmt, ...)
{
 71e:	711d                	addi	sp,sp,-96
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	addi	s0,sp,32
 726:	e40c                	sd	a1,8(s0)
 728:	e810                	sd	a2,16(s0)
 72a:	ec14                	sd	a3,24(s0)
 72c:	f018                	sd	a4,32(s0)
 72e:	f41c                	sd	a5,40(s0)
 730:	03043823          	sd	a6,48(s0)
 734:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	00840613          	addi	a2,s0,8
 73c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 740:	85aa                	mv	a1,a0
 742:	4505                	li	a0,1
 744:	cf1ff0ef          	jal	434 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6125                	addi	sp,sp,96
 74e:	8082                	ret

0000000000000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	1141                	addi	sp,sp,-16
 752:	e406                	sd	ra,8(sp)
 754:	e022                	sd	s0,0(sp)
 756:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 758:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	00001797          	auipc	a5,0x1
 760:	8a47b783          	ld	a5,-1884(a5) # 1000 <freep>
 764:	a039                	j	772 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 766:	6398                	ld	a4,0(a5)
 768:	00e7e463          	bltu	a5,a4,770 <free+0x20>
 76c:	00e6ea63          	bltu	a3,a4,780 <free+0x30>
{
 770:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	fed7fae3          	bgeu	a5,a3,766 <free+0x16>
 776:	6398                	ld	a4,0(a5)
 778:	00e6e463          	bltu	a3,a4,780 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	fee7eae3          	bltu	a5,a4,770 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 780:	ff852583          	lw	a1,-8(a0)
 784:	6390                	ld	a2,0(a5)
 786:	02059813          	slli	a6,a1,0x20
 78a:	01c85713          	srli	a4,a6,0x1c
 78e:	9736                	add	a4,a4,a3
 790:	02e60563          	beq	a2,a4,7ba <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 798:	4790                	lw	a2,8(a5)
 79a:	02061593          	slli	a1,a2,0x20
 79e:	01c5d713          	srli	a4,a1,0x1c
 7a2:	973e                	add	a4,a4,a5
 7a4:	02e68263          	beq	a3,a4,7c8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7aa:	00001717          	auipc	a4,0x1
 7ae:	84f73b23          	sd	a5,-1962(a4) # 1000 <freep>
}
 7b2:	60a2                	ld	ra,8(sp)
 7b4:	6402                	ld	s0,0(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ba:	4618                	lw	a4,8(a2)
 7bc:	9f2d                	addw	a4,a4,a1
 7be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	6310                	ld	a2,0(a4)
 7c6:	b7f9                	j	794 <free+0x44>
    p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9f31                	addw	a4,a4,a2
 7ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d0:	ff053683          	ld	a3,-16(a0)
 7d4:	bfd1                	j	7a8 <free+0x58>

00000000000007d6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7d6:	7139                	addi	sp,sp,-64
 7d8:	fc06                	sd	ra,56(sp)
 7da:	f822                	sd	s0,48(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7e2:	02051993          	slli	s3,a0,0x20
 7e6:	0209d993          	srli	s3,s3,0x20
 7ea:	09bd                	addi	s3,s3,15
 7ec:	0049d993          	srli	s3,s3,0x4
 7f0:	2985                	addiw	s3,s3,1
 7f2:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 7f4:	00001517          	auipc	a0,0x1
 7f8:	80c53503          	ld	a0,-2036(a0) # 1000 <freep>
 7fc:	c905                	beqz	a0,82c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7fe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 800:	4798                	lw	a4,8(a5)
 802:	09377663          	bgeu	a4,s3,88e <malloc+0xb8>
 806:	f426                	sd	s1,40(sp)
 808:	e852                	sd	s4,16(sp)
 80a:	e456                	sd	s5,8(sp)
 80c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 80e:	8a4e                	mv	s4,s3
 810:	6705                	lui	a4,0x1
 812:	00e9f363          	bgeu	s3,a4,818 <malloc+0x42>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 820:	00000497          	auipc	s1,0x0
 824:	7e048493          	addi	s1,s1,2016 # 1000 <freep>
  if (p == SBRK_ERROR)
 828:	5afd                	li	s5,-1
 82a:	a83d                	j	868 <malloc+0x92>
 82c:	f426                	sd	s1,40(sp)
 82e:	e852                	sd	s4,16(sp)
 830:	e456                	sd	s5,8(sp)
 832:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 834:	00000797          	auipc	a5,0x0
 838:	7dc78793          	addi	a5,a5,2012 # 1010 <base>
 83c:	00000717          	auipc	a4,0x0
 840:	7cf73223          	sd	a5,1988(a4) # 1000 <freep>
 844:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 846:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 84a:	b7d1                	j	80e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 84c:	6398                	ld	a4,0(a5)
 84e:	e118                	sd	a4,0(a0)
 850:	a899                	j	8a6 <malloc+0xd0>
  hp->s.size = nu;
 852:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 856:	0541                	addi	a0,a0,16
 858:	ef9ff0ef          	jal	750 <free>
  return freep;
 85c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 85e:	c125                	beqz	a0,8be <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 860:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 862:	4798                	lw	a4,8(a5)
 864:	03277163          	bgeu	a4,s2,886 <malloc+0xb0>
    if (p == freep)
 868:	6098                	ld	a4,0(s1)
 86a:	853e                	mv	a0,a5
 86c:	fef71ae3          	bne	a4,a5,860 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 870:	8552                	mv	a0,s4
 872:	a23ff0ef          	jal	294 <sbrk>
  if (p == SBRK_ERROR)
 876:	fd551ee3          	bne	a0,s5,852 <malloc+0x7c>
        return 0;
 87a:	4501                	li	a0,0
 87c:	74a2                	ld	s1,40(sp)
 87e:	6a42                	ld	s4,16(sp)
 880:	6aa2                	ld	s5,8(sp)
 882:	6b02                	ld	s6,0(sp)
 884:	a03d                	j	8b2 <malloc+0xdc>
 886:	74a2                	ld	s1,40(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 88e:	fae90fe3          	beq	s2,a4,84c <malloc+0x76>
        p->s.size -= nunits;
 892:	4137073b          	subw	a4,a4,s3
 896:	c798                	sw	a4,8(a5)
        p += p->s.size;
 898:	02071693          	slli	a3,a4,0x20
 89c:	01c6d713          	srli	a4,a3,0x1c
 8a0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a6:	00000717          	auipc	a4,0x0
 8aa:	74a73d23          	sd	a0,1882(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ae:	01078513          	addi	a0,a5,16
  }
}
 8b2:	70e2                	ld	ra,56(sp)
 8b4:	7442                	ld	s0,48(sp)
 8b6:	7902                	ld	s2,32(sp)
 8b8:	69e2                	ld	s3,24(sp)
 8ba:	6121                	addi	sp,sp,64
 8bc:	8082                	ret
 8be:	74a2                	ld	s1,40(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
 8c6:	b7f5                	j	8b2 <malloc+0xdc>
