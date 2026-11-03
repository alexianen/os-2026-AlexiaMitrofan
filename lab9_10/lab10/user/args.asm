
user/_args:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h" 
#include "user/user.h"
int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	89aa                	mv	s3,a0
  12:	892e                	mv	s2,a1
   printf("argc = %d\n", argc); 
  14:	85aa                	mv	a1,a0
  16:	00001517          	auipc	a0,0x1
  1a:	8ea50513          	addi	a0,a0,-1814 # 900 <malloc+0xf2>
  1e:	738000ef          	jal	756 <printf>
   for(int i = 0; i < argc; i++)
  22:	03305163          	blez	s3,44 <main+0x44>
  26:	4481                	li	s1,0
      printf("argv[%d] = [%s]\n", i, argv[i]); 
  28:	00001a17          	auipc	s4,0x1
  2c:	8e8a0a13          	addi	s4,s4,-1816 # 910 <malloc+0x102>
  30:	00093603          	ld	a2,0(s2)
  34:	85a6                	mv	a1,s1
  36:	8552                	mv	a0,s4
  38:	71e000ef          	jal	756 <printf>
   for(int i = 0; i < argc; i++)
  3c:	2485                	addiw	s1,s1,1
  3e:	0921                	addi	s2,s2,8
  40:	fe9998e3          	bne	s3,s1,30 <main+0x30>
   exit(0);
  44:	4501                	li	a0,0
  46:	2ba000ef          	jal	300 <exit>

000000000000004a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e406                	sd	ra,8(sp)
  4e:	e022                	sd	s0,0(sp)
  50:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  52:	fafff0ef          	jal	0 <main>
  exit(r);
  56:	2aa000ef          	jal	300 <exit>

000000000000005a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  62:	87aa                	mv	a5,a0
  64:	0585                	addi	a1,a1,1
  66:	0785                	addi	a5,a5,1
  68:	fff5c703          	lbu	a4,-1(a1)
  6c:	fee78fa3          	sb	a4,-1(a5)
  70:	fb75                	bnez	a4,64 <strcpy+0xa>
    ;
  return os;
}
  72:	60a2                	ld	ra,8(sp)
  74:	6402                	ld	s0,0(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x20>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x20>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x28>
  b8:	00150793          	addi	a5,a0,1
  bc:	86be                	mv	a3,a5
  be:	0785                	addi	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	ff65                	bnez	a4,bc <strlen+0x12>
  c6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for (n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfdd                	j	ca <strlen+0x20>

00000000000000d6 <memset>:

void *
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  de:	ca19                	beqz	a2,f4 <memset+0x1e>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x14>
  }
  return dst;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strchr>:

char *
strchr(const char *s, char c)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  for (; *s; s++)
 104:	00054783          	lbu	a5,0(a0)
 108:	cf81                	beqz	a5,120 <strchr+0x24>
    if (*s == c)
 10a:	00f58763          	beq	a1,a5,118 <strchr+0x1c>
  for (; *s; s++)
 10e:	0505                	addi	a0,a0,1
 110:	00054783          	lbu	a5,0(a0)
 114:	fbfd                	bnez	a5,10a <strchr+0xe>
      return (char *)s;
  return 0;
 116:	4501                	li	a0,0
}
 118:	60a2                	ld	ra,8(sp)
 11a:	6402                	ld	s0,0(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  return 0;
 120:	4501                	li	a0,0
 122:	bfdd                	j	118 <strchr+0x1c>

0000000000000124 <gets>:

char *
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	e862                	sd	s8,16(sp)
 13a:	1080                	addi	s0,sp,96
 13c:	8baa                	mv	s7,a0
 13e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 140:	892a                	mv	s2,a0
 142:	4481                	li	s1,0
    cc = read(0, &c, 1);
 144:	faf40b13          	addi	s6,s0,-81
 148:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 14a:	8c26                	mv	s8,s1
 14c:	0014899b          	addiw	s3,s1,1
 150:	84ce                	mv	s1,s3
 152:	0349d463          	bge	s3,s4,17a <gets+0x56>
    cc = read(0, &c, 1);
 156:	8656                	mv	a2,s5
 158:	85da                	mv	a1,s6
 15a:	4501                	li	a0,0
 15c:	1bc000ef          	jal	318 <read>
    if (cc < 1)
 160:	00a05d63          	blez	a0,17a <gets+0x56>
      break;
    buf[i++] = c;
 164:	faf44783          	lbu	a5,-81(s0)
 168:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 16c:	0905                	addi	s2,s2,1
 16e:	ff678713          	addi	a4,a5,-10
 172:	c319                	beqz	a4,178 <gets+0x54>
 174:	17cd                	addi	a5,a5,-13
 176:	fbf1                	bnez	a5,14a <gets+0x26>
    buf[i++] = c;
 178:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17a:	9c5e                	add	s8,s8,s7
 17c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 180:	855e                	mv	a0,s7
 182:	60e6                	ld	ra,88(sp)
 184:	6446                	ld	s0,80(sp)
 186:	64a6                	ld	s1,72(sp)
 188:	6906                	ld	s2,64(sp)
 18a:	79e2                	ld	s3,56(sp)
 18c:	7a42                	ld	s4,48(sp)
 18e:	7aa2                	ld	s5,40(sp)
 190:	7b02                	ld	s6,32(sp)
 192:	6be2                	ld	s7,24(sp)
 194:	6c42                	ld	s8,16(sp)
 196:	6125                	addi	sp,sp,96
 198:	8082                	ret

000000000000019a <stat>:

int
stat(const char *n, struct stat *st)
{
 19a:	1101                	addi	sp,sp,-32
 19c:	ec06                	sd	ra,24(sp)
 19e:	e822                	sd	s0,16(sp)
 1a0:	e04a                	sd	s2,0(sp)
 1a2:	1000                	addi	s0,sp,32
 1a4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	4581                	li	a1,0
 1a8:	198000ef          	jal	340 <open>
  if (fd < 0)
 1ac:	02054263          	bltz	a0,1d0 <stat+0x36>
 1b0:	e426                	sd	s1,8(sp)
 1b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b4:	85ca                	mv	a1,s2
 1b6:	1a2000ef          	jal	358 <fstat>
 1ba:	892a                	mv	s2,a0
  close(fd);
 1bc:	8526                	mv	a0,s1
 1be:	16a000ef          	jal	328 <close>
  return r;
 1c2:	64a2                	ld	s1,8(sp)
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	6902                	ld	s2,0(sp)
 1cc:	6105                	addi	sp,sp,32
 1ce:	8082                	ret
    return -1;
 1d0:	57fd                	li	a5,-1
 1d2:	893e                	mv	s2,a5
 1d4:	bfc5                	j	1c4 <stat+0x2a>

00000000000001d6 <atoi>:

int
atoi(const char *s)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e406                	sd	ra,8(sp)
 1da:	e022                	sd	s0,0(sp)
 1dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1de:	00054683          	lbu	a3,0(a0)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	4625                	li	a2,9
 1ec:	02f66963          	bltu	a2,a5,21e <atoi+0x48>
 1f0:	872a                	mv	a4,a0
  n = 0;
 1f2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1f4:	0705                	addi	a4,a4,1
 1f6:	0025179b          	slliw	a5,a0,0x2
 1fa:	9fa9                	addw	a5,a5,a0
 1fc:	0017979b          	slliw	a5,a5,0x1
 200:	9fb5                	addw	a5,a5,a3
 202:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 206:	00074683          	lbu	a3,0(a4)
 20a:	fd06879b          	addiw	a5,a3,-48
 20e:	0ff7f793          	zext.b	a5,a5
 212:	fef671e3          	bgeu	a2,a5,1f4 <atoi+0x1e>
  return n;
}
 216:	60a2                	ld	ra,8(sp)
 218:	6402                	ld	s0,0(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfdd                	j	216 <atoi+0x40>

0000000000000222 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e406                	sd	ra,8(sp)
 226:	e022                	sd	s0,0(sp)
 228:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22a:	02b57563          	bgeu	a0,a1,254 <memmove+0x32>
    while (n-- > 0)
 22e:	00c05f63          	blez	a2,24c <memmove+0x2a>
 232:	1602                	slli	a2,a2,0x20
 234:	9201                	srli	a2,a2,0x20
 236:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23a:	872a                	mv	a4,a0
      *dst++ = *src++;
 23c:	0585                	addi	a1,a1,1
 23e:	0705                	addi	a4,a4,1
 240:	fff5c683          	lbu	a3,-1(a1)
 244:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 248:	fee79ae3          	bne	a5,a4,23c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24c:	60a2                	ld	ra,8(sp)
 24e:	6402                	ld	s0,0(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
    while (n-- > 0)
 254:	fec05ce3          	blez	a2,24c <memmove+0x2a>
    dst += n;
 258:	00c50733          	add	a4,a0,a2
    src += n;
 25c:	95b2                	add	a1,a1,a2
 25e:	fff6079b          	addiw	a5,a2,-1
 262:	1782                	slli	a5,a5,0x20
 264:	9381                	srli	a5,a5,0x20
 266:	fff7c793          	not	a5,a5
 26a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 26c:	15fd                	addi	a1,a1,-1
 26e:	177d                	addi	a4,a4,-1
 270:	0005c683          	lbu	a3,0(a1)
 274:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 278:	fef71ae3          	bne	a4,a5,26c <memmove+0x4a>
 27c:	bfc1                	j	24c <memmove+0x2a>

000000000000027e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 286:	c61d                	beqz	a2,2b4 <memcmp+0x36>
 288:	1602                	slli	a2,a2,0x20
 28a:	9201                	srli	a2,a2,0x20
 28c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 290:	00054783          	lbu	a5,0(a0)
 294:	0005c703          	lbu	a4,0(a1)
 298:	00e79863          	bne	a5,a4,2a8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 29c:	0505                	addi	a0,a0,1
    p2++;
 29e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a0:	fed518e3          	bne	a0,a3,290 <memcmp+0x12>
  }
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	a019                	j	2ac <memcmp+0x2e>
      return *p1 - *p2;
 2a8:	40e7853b          	subw	a0,a5,a4
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	bfdd                	j	2ac <memcmp+0x2e>

00000000000002b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c0:	f63ff0ef          	jal	222 <memmove>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <sbrk>:

char *
sbrk(int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d4:	4585                	li	a1,1
 2d6:	0b2000ef          	jal	388 <sys_sbrk>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <sbrklazy>:

char *
sbrklazy(int n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ea:	4589                	li	a1,2
 2ec:	09c000ef          	jal	388 <sys_sbrk>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <pause>:
.global pause
pause:
 li a7, SYS_pause
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3a0:	48d9                	li	a7,22
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3a8:	48dd                	li	a7,23
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b0:	1101                	addi	sp,sp,-32
 3b2:	ec06                	sd	ra,24(sp)
 3b4:	e822                	sd	s0,16(sp)
 3b6:	1000                	addi	s0,sp,32
 3b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	fef40593          	addi	a1,s0,-17
 3c2:	f5fff0ef          	jal	320 <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ce:	715d                	addi	sp,sp,-80
 3d0:	e486                	sd	ra,72(sp)
 3d2:	e0a2                	sd	s0,64(sp)
 3d4:	f84a                	sd	s2,48(sp)
 3d6:	f44e                	sd	s3,40(sp)
 3d8:	0880                	addi	s0,sp,80
 3da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3dc:	c6d1                	beqz	a3,468 <printint+0x9a>
 3de:	0805d563          	bgez	a1,468 <printint+0x9a>
    neg = 1;
    x = -xx;
 3e2:	40b005b3          	neg	a1,a1
    neg = 1;
 3e6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3ec:	86ce                	mv	a3,s3
  i = 0;
 3ee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3f0:	00000817          	auipc	a6,0x0
 3f4:	54080813          	addi	a6,a6,1344 # 930 <digits>
 3f8:	88ba                	mv	a7,a4
 3fa:	0017051b          	addiw	a0,a4,1
 3fe:	872a                	mv	a4,a0
 400:	02c5f7b3          	remu	a5,a1,a2
 404:	97c2                	add	a5,a5,a6
 406:	0007c783          	lbu	a5,0(a5)
 40a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 40e:	87ae                	mv	a5,a1
 410:	02c5d5b3          	divu	a1,a1,a2
 414:	0685                	addi	a3,a3,1
 416:	fec7f1e3          	bgeu	a5,a2,3f8 <printint+0x2a>
  if (neg)
 41a:	00030c63          	beqz	t1,432 <printint+0x64>
    buf[i++] = '-';
 41e:	fd050793          	addi	a5,a0,-48
 422:	00878533          	add	a0,a5,s0
 426:	02d00793          	li	a5,45
 42a:	fef50423          	sb	a5,-24(a0)
 42e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 432:	02e05563          	blez	a4,45c <printint+0x8e>
 436:	fc26                	sd	s1,56(sp)
 438:	377d                	addiw	a4,a4,-1
 43a:	00e984b3          	add	s1,s3,a4
 43e:	19fd                	addi	s3,s3,-1
 440:	99ba                	add	s3,s3,a4
 442:	1702                	slli	a4,a4,0x20
 444:	9301                	srli	a4,a4,0x20
 446:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 44a:	0004c583          	lbu	a1,0(s1)
 44e:	854a                	mv	a0,s2
 450:	f61ff0ef          	jal	3b0 <putc>
  while (--i >= 0)
 454:	14fd                	addi	s1,s1,-1
 456:	ff349ae3          	bne	s1,s3,44a <printint+0x7c>
 45a:	74e2                	ld	s1,56(sp)
}
 45c:	60a6                	ld	ra,72(sp)
 45e:	6406                	ld	s0,64(sp)
 460:	7942                	ld	s2,48(sp)
 462:	79a2                	ld	s3,40(sp)
 464:	6161                	addi	sp,sp,80
 466:	8082                	ret
  neg = 0;
 468:	4301                	li	t1,0
 46a:	bfbd                	j	3e8 <printint+0x1a>

000000000000046c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46c:	711d                	addi	sp,sp,-96
 46e:	ec86                	sd	ra,88(sp)
 470:	e8a2                	sd	s0,80(sp)
 472:	e4a6                	sd	s1,72(sp)
 474:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 476:	0005c483          	lbu	s1,0(a1)
 47a:	22048363          	beqz	s1,6a0 <vprintf+0x234>
 47e:	e0ca                	sd	s2,64(sp)
 480:	fc4e                	sd	s3,56(sp)
 482:	f852                	sd	s4,48(sp)
 484:	f456                	sd	s5,40(sp)
 486:	f05a                	sd	s6,32(sp)
 488:	ec5e                	sd	s7,24(sp)
 48a:	e862                	sd	s8,16(sp)
 48c:	8b2a                	mv	s6,a0
 48e:	8a2e                	mv	s4,a1
 490:	8bb2                	mv	s7,a2
  state = 0;
 492:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 494:	4901                	li	s2,0
 496:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 498:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 49c:	06400c13          	li	s8,100
 4a0:	a00d                	j	4c2 <vprintf+0x56>
        putc(fd, c0);
 4a2:	85a6                	mv	a1,s1
 4a4:	855a                	mv	a0,s6
 4a6:	f0bff0ef          	jal	3b0 <putc>
 4aa:	a019                	j	4b0 <vprintf+0x44>
    } else if (state == '%') {
 4ac:	03598363          	beq	s3,s5,4d2 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4b0:	0019079b          	addiw	a5,s2,1
 4b4:	893e                	mv	s2,a5
 4b6:	873e                	mv	a4,a5
 4b8:	97d2                	add	a5,a5,s4
 4ba:	0007c483          	lbu	s1,0(a5)
 4be:	1c048a63          	beqz	s1,692 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4c2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4c6:	fe0993e3          	bnez	s3,4ac <vprintf+0x40>
      if (c0 == '%') {
 4ca:	fd579ce3          	bne	a5,s5,4a2 <vprintf+0x36>
        state = '%';
 4ce:	89be                	mv	s3,a5
 4d0:	b7c5                	j	4b0 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4d2:	00ea06b3          	add	a3,s4,a4
 4d6:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4da:	1c060863          	beqz	a2,6aa <vprintf+0x23e>
      if (c0 == 'd') {
 4de:	03878763          	beq	a5,s8,50c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4e2:	f9478693          	addi	a3,a5,-108
 4e6:	0016b693          	seqz	a3,a3
 4ea:	f9c60593          	addi	a1,a2,-100
 4ee:	e99d                	bnez	a1,524 <vprintf+0xb8>
 4f0:	ca95                	beqz	a3,524 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f2:	008b8493          	addi	s1,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000bb583          	ld	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	ecfff0ef          	jal	3ce <printint>
        i += 1;
 504:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 506:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 508:	4981                	li	s3,0
 50a:	b75d                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b8493          	addi	s1,s7,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000ba583          	lw	a1,0(s7)
 518:	855a                	mv	a0,s6
 51a:	eb5ff0ef          	jal	3ce <printint>
 51e:	8ba6                	mv	s7,s1
      state = 0;
 520:	4981                	li	s3,0
 522:	b779                	j	4b0 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 524:	9752                	add	a4,a4,s4
 526:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 52a:	f9460713          	addi	a4,a2,-108
 52e:	00173713          	seqz	a4,a4
 532:	8f75                	and	a4,a4,a3
 534:	f9c58513          	addi	a0,a1,-100
 538:	18051363          	bnez	a0,6be <vprintf+0x252>
 53c:	18070163          	beqz	a4,6be <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 540:	008b8493          	addi	s1,s7,8
 544:	4685                	li	a3,1
 546:	4629                	li	a2,10
 548:	000bb583          	ld	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e81ff0ef          	jal	3ce <printint>
        i += 2;
 552:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
        i += 2;
 558:	bfa1                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 55a:	008b8493          	addi	s1,s7,8
 55e:	4681                	li	a3,0
 560:	4629                	li	a2,10
 562:	000be583          	lwu	a1,0(s7)
 566:	855a                	mv	a0,s6
 568:	e67ff0ef          	jal	3ce <printint>
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	b781                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000bb583          	ld	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e4fff0ef          	jal	3ce <printint>
        i += 1;
 584:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
 58a:	b71d                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4629                	li	a2,10
 594:	000bb583          	ld	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e35ff0ef          	jal	3ce <printint>
        i += 2;
 59e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	8ba6                	mv	s7,s1
      state = 0;
 5a2:	4981                	li	s3,0
        i += 2;
 5a4:	b731                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5a6:	008b8493          	addi	s1,s7,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000be583          	lwu	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e1bff0ef          	jal	3ce <printint>
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bdd5                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e03ff0ef          	jal	3ce <printint>
        i += 1;
 5d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bde9                	j	4b0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	de9ff0ef          	jal	3ce <printint>
        i += 2;
 5ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8ba6                	mv	s7,s1
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	b5c1                	j	4b0 <vprintf+0x44>
 5f2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5f4:	008b8793          	addi	a5,s7,8
 5f8:	8cbe                	mv	s9,a5
 5fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fe:	03000593          	li	a1,48
 602:	855a                	mv	a0,s6
 604:	dadff0ef          	jal	3b0 <putc>
  putc(fd, 'x');
 608:	07800593          	li	a1,120
 60c:	855a                	mv	a0,s6
 60e:	da3ff0ef          	jal	3b0 <putc>
 612:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 614:	00000b97          	auipc	s7,0x0
 618:	31cb8b93          	addi	s7,s7,796 # 930 <digits>
 61c:	03c9d793          	srli	a5,s3,0x3c
 620:	97de                	add	a5,a5,s7
 622:	0007c583          	lbu	a1,0(a5)
 626:	855a                	mv	a0,s6
 628:	d89ff0ef          	jal	3b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 62c:	0992                	slli	s3,s3,0x4
 62e:	34fd                	addiw	s1,s1,-1
 630:	f4f5                	bnez	s1,61c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 632:	8be6                	mv	s7,s9
      state = 0;
 634:	4981                	li	s3,0
 636:	6ca2                	ld	s9,8(sp)
 638:	bda5                	j	4b0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 63a:	008b8493          	addi	s1,s7,8
 63e:	000bc583          	lbu	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	d6dff0ef          	jal	3b0 <putc>
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b595                	j	4b0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 64e:	008b8993          	addi	s3,s7,8
 652:	000bb483          	ld	s1,0(s7)
 656:	cc91                	beqz	s1,672 <vprintf+0x206>
        for (; *s; s++)
 658:	0004c583          	lbu	a1,0(s1)
 65c:	c985                	beqz	a1,68c <vprintf+0x220>
          putc(fd, *s);
 65e:	855a                	mv	a0,s6
 660:	d51ff0ef          	jal	3b0 <putc>
        for (; *s; s++)
 664:	0485                	addi	s1,s1,1
 666:	0004c583          	lbu	a1,0(s1)
 66a:	f9f5                	bnez	a1,65e <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 66c:	8bce                	mv	s7,s3
      state = 0;
 66e:	4981                	li	s3,0
 670:	b581                	j	4b0 <vprintf+0x44>
          s = "(null)";
 672:	00000497          	auipc	s1,0x0
 676:	2b648493          	addi	s1,s1,694 # 928 <malloc+0x11a>
        for (; *s; s++)
 67a:	02800593          	li	a1,40
 67e:	b7c5                	j	65e <vprintf+0x1f2>
        putc(fd, '%');
 680:	85be                	mv	a1,a5
 682:	855a                	mv	a0,s6
 684:	d2dff0ef          	jal	3b0 <putc>
      state = 0;
 688:	4981                	li	s3,0
 68a:	b51d                	j	4b0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b505                	j	4b0 <vprintf+0x44>
 692:	6906                	ld	s2,64(sp)
 694:	79e2                	ld	s3,56(sp)
 696:	7a42                	ld	s4,48(sp)
 698:	7aa2                	ld	s5,40(sp)
 69a:	7b02                	ld	s6,32(sp)
 69c:	6be2                	ld	s7,24(sp)
 69e:	6c42                	ld	s8,16(sp)
    }
  }
}
 6a0:	60e6                	ld	ra,88(sp)
 6a2:	6446                	ld	s0,80(sp)
 6a4:	64a6                	ld	s1,72(sp)
 6a6:	6125                	addi	sp,sp,96
 6a8:	8082                	ret
      if (c0 == 'd') {
 6aa:	06400713          	li	a4,100
 6ae:	e4e78fe3          	beq	a5,a4,50c <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 6b2:	f9478693          	addi	a3,a5,-108
 6b6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6ba:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6bc:	4701                	li	a4,0
      } else if (c0 == 'u') {
 6be:	07500513          	li	a0,117
 6c2:	e8a78ce3          	beq	a5,a0,55a <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6c6:	f8b60513          	addi	a0,a2,-117
 6ca:	e119                	bnez	a0,6d0 <vprintf+0x264>
 6cc:	ea0693e3          	bnez	a3,572 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6d0:	f8b58513          	addi	a0,a1,-117
 6d4:	e119                	bnez	a0,6da <vprintf+0x26e>
 6d6:	ea071be3          	bnez	a4,58c <vprintf+0x120>
      } else if (c0 == 'x') {
 6da:	07800513          	li	a0,120
 6de:	eca784e3          	beq	a5,a0,5a6 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 6e2:	f8860613          	addi	a2,a2,-120
 6e6:	e219                	bnez	a2,6ec <vprintf+0x280>
 6e8:	ec069be3          	bnez	a3,5be <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6ec:	f8858593          	addi	a1,a1,-120
 6f0:	e199                	bnez	a1,6f6 <vprintf+0x28a>
 6f2:	ee0713e3          	bnez	a4,5d8 <vprintf+0x16c>
      } else if (c0 == 'p') {
 6f6:	07000713          	li	a4,112
 6fa:	eee78ce3          	beq	a5,a4,5f2 <vprintf+0x186>
      } else if (c0 == 'c') {
 6fe:	06300713          	li	a4,99
 702:	f2e78ce3          	beq	a5,a4,63a <vprintf+0x1ce>
      } else if (c0 == 's') {
 706:	07300713          	li	a4,115
 70a:	f4e782e3          	beq	a5,a4,64e <vprintf+0x1e2>
      } else if (c0 == '%') {
 70e:	02500713          	li	a4,37
 712:	f6e787e3          	beq	a5,a4,680 <vprintf+0x214>
        putc(fd, '%');
 716:	02500593          	li	a1,37
 71a:	855a                	mv	a0,s6
 71c:	c95ff0ef          	jal	3b0 <putc>
        putc(fd, c0);
 720:	85a6                	mv	a1,s1
 722:	855a                	mv	a0,s6
 724:	c8dff0ef          	jal	3b0 <putc>
      state = 0;
 728:	4981                	li	s3,0
 72a:	b359                	j	4b0 <vprintf+0x44>

000000000000072c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72c:	715d                	addi	sp,sp,-80
 72e:	ec06                	sd	ra,24(sp)
 730:	e822                	sd	s0,16(sp)
 732:	1000                	addi	s0,sp,32
 734:	e010                	sd	a2,0(s0)
 736:	e414                	sd	a3,8(s0)
 738:	e818                	sd	a4,16(s0)
 73a:	ec1c                	sd	a5,24(s0)
 73c:	03043023          	sd	a6,32(s0)
 740:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	8622                	mv	a2,s0
 746:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74a:	d23ff0ef          	jal	46c <vprintf>
}
 74e:	60e2                	ld	ra,24(sp)
 750:	6442                	ld	s0,16(sp)
 752:	6161                	addi	sp,sp,80
 754:	8082                	ret

0000000000000756 <printf>:

void
printf(const char *fmt, ...)
{
 756:	711d                	addi	sp,sp,-96
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e40c                	sd	a1,8(s0)
 760:	e810                	sd	a2,16(s0)
 762:	ec14                	sd	a3,24(s0)
 764:	f018                	sd	a4,32(s0)
 766:	f41c                	sd	a5,40(s0)
 768:	03043823          	sd	a6,48(s0)
 76c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 770:	00840613          	addi	a2,s0,8
 774:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 778:	85aa                	mv	a1,a0
 77a:	4505                	li	a0,1
 77c:	cf1ff0ef          	jal	46c <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6125                	addi	sp,sp,96
 786:	8082                	ret

0000000000000788 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 788:	1141                	addi	sp,sp,-16
 78a:	e406                	sd	ra,8(sp)
 78c:	e022                	sd	s0,0(sp)
 78e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 790:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	00001797          	auipc	a5,0x1
 798:	86c7b783          	ld	a5,-1940(a5) # 1000 <freep>
 79c:	a039                	j	7aa <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x20>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x30>
{
 7a8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x16>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85713          	srli	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	02e60563          	beq	a2,a4,7f2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d713          	srli	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	02e68263          	beq	a3,a4,800 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	60a2                	ld	ra,8(sp)
 7ec:	6402                	ld	s0,0(sp)
 7ee:	0141                	addi	sp,sp,16
 7f0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7f2:	4618                	lw	a4,8(a2)
 7f4:	9f2d                	addw	a4,a4,a1
 7f6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	6398                	ld	a4,0(a5)
 7fc:	6310                	ld	a2,0(a4)
 7fe:	b7f9                	j	7cc <free+0x44>
    p->s.size += bp->s.size;
 800:	ff852703          	lw	a4,-8(a0)
 804:	9f31                	addw	a4,a4,a2
 806:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 808:	ff053683          	ld	a3,-16(a0)
 80c:	bfd1                	j	7e0 <free+0x58>

000000000000080e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 80e:	7139                	addi	sp,sp,-64
 810:	fc06                	sd	ra,56(sp)
 812:	f822                	sd	s0,48(sp)
 814:	f04a                	sd	s2,32(sp)
 816:	ec4e                	sd	s3,24(sp)
 818:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 81a:	02051993          	slli	s3,a0,0x20
 81e:	0209d993          	srli	s3,s3,0x20
 822:	09bd                	addi	s3,s3,15
 824:	0049d993          	srli	s3,s3,0x4
 828:	2985                	addiw	s3,s3,1
 82a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 82c:	00000517          	auipc	a0,0x0
 830:	7d453503          	ld	a0,2004(a0) # 1000 <freep>
 834:	c905                	beqz	a0,864 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 836:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 838:	4798                	lw	a4,8(a5)
 83a:	09377663          	bgeu	a4,s3,8c6 <malloc+0xb8>
 83e:	f426                	sd	s1,40(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 846:	8a4e                	mv	s4,s3
 848:	6705                	lui	a4,0x1
 84a:	00e9f363          	bgeu	s3,a4,850 <malloc+0x42>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 858:	00000497          	auipc	s1,0x0
 85c:	7a848493          	addi	s1,s1,1960 # 1000 <freep>
  if (p == SBRK_ERROR)
 860:	5afd                	li	s5,-1
 862:	a83d                	j	8a0 <malloc+0x92>
 864:	f426                	sd	s1,40(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86c:	00000797          	auipc	a5,0x0
 870:	7a478793          	addi	a5,a5,1956 # 1010 <base>
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
 87c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 882:	b7d1                	j	846 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	a899                	j	8de <malloc+0xd0>
  hp->s.size = nu;
 88a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	ef9ff0ef          	jal	788 <free>
  return freep;
 894:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 896:	c125                	beqz	a0,8f6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 898:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 89a:	4798                	lw	a4,8(a5)
 89c:	03277163          	bgeu	a4,s2,8be <malloc+0xb0>
    if (p == freep)
 8a0:	6098                	ld	a4,0(s1)
 8a2:	853e                	mv	a0,a5
 8a4:	fef71ae3          	bne	a4,a5,898 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	a23ff0ef          	jal	2cc <sbrk>
  if (p == SBRK_ERROR)
 8ae:	fd551ee3          	bne	a0,s5,88a <malloc+0x7c>
        return 0;
 8b2:	4501                	li	a0,0
 8b4:	74a2                	ld	s1,40(sp)
 8b6:	6a42                	ld	s4,16(sp)
 8b8:	6aa2                	ld	s5,8(sp)
 8ba:	6b02                	ld	s6,0(sp)
 8bc:	a03d                	j	8ea <malloc+0xdc>
 8be:	74a2                	ld	s1,40(sp)
 8c0:	6a42                	ld	s4,16(sp)
 8c2:	6aa2                	ld	s5,8(sp)
 8c4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8c6:	fae90fe3          	beq	s2,a4,884 <malloc+0x76>
        p->s.size -= nunits;
 8ca:	4137073b          	subw	a4,a4,s3
 8ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d0:	02071693          	slli	a3,a4,0x20
 8d4:	01c6d713          	srli	a4,a3,0x1c
 8d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8de:	00000717          	auipc	a4,0x0
 8e2:	72a73123          	sd	a0,1826(a4) # 1000 <freep>
      return (void *)(p + 1);
 8e6:	01078513          	addi	a0,a5,16
  }
}
 8ea:	70e2                	ld	ra,56(sp)
 8ec:	7442                	ld	s0,48(sp)
 8ee:	7902                	ld	s2,32(sp)
 8f0:	69e2                	ld	s3,24(sp)
 8f2:	6121                	addi	sp,sp,64
 8f4:	8082                	ret
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	6a42                	ld	s4,16(sp)
 8fa:	6aa2                	ld	s5,8(sp)
 8fc:	6b02                	ld	s6,0(sp)
 8fe:	b7f5                	j	8ea <malloc+0xdc>
