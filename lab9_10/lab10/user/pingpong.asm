
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  int p2c[2], c2p[2];     // parent-to-child, child-to-parent
  char b;

  pipe(p2c);
   8:	fd840513          	addi	a0,s0,-40
   c:	392000ef          	jal	39e <pipe>
  pipe(c2p);
  10:	fd040513          	addi	a0,s0,-48
  14:	38a000ef          	jal	39e <pipe>
  if(fork() == 0){
  18:	36e000ef          	jal	386 <fork>
  1c:	ed21                	bnez	a0,74 <main+0x74>
  1e:	f426                	sd	s1,40(sp)
    close(p2c[1]); close(c2p[0]);       // the ends the child does not use
  20:	fdc42503          	lw	a0,-36(s0)
  24:	392000ef          	jal	3b6 <close>
  28:	fd042503          	lw	a0,-48(s0)
  2c:	38a000ef          	jal	3b6 <close>
    read(p2c[0], &b, 1);                // block until the parent's byte arrives
  30:	fcf40493          	addi	s1,s0,-49
  34:	4605                	li	a2,1
  36:	85a6                	mv	a1,s1
  38:	fd842503          	lw	a0,-40(s0)
  3c:	36a000ef          	jal	3a6 <read>
    printf("%d: received ping\n", getpid());
  40:	3ce000ef          	jal	40e <getpid>
  44:	85aa                	mv	a1,a0
  46:	00001517          	auipc	a0,0x1
  4a:	94a50513          	addi	a0,a0,-1718 # 990 <malloc+0xf4>
  4e:	796000ef          	jal	7e4 <printf>
    write(c2p[1], &b, 1);               // send the same byte back
  52:	4605                	li	a2,1
  54:	85a6                	mv	a1,s1
  56:	fd442503          	lw	a0,-44(s0)
  5a:	354000ef          	jal	3ae <write>
    close(p2c[0]); close(c2p[1]);
  5e:	fd842503          	lw	a0,-40(s0)
  62:	354000ef          	jal	3b6 <close>
  66:	fd442503          	lw	a0,-44(s0)
  6a:	34c000ef          	jal	3b6 <close>
    exit(0);
  6e:	4501                	li	a0,0
  70:	31e000ef          	jal	38e <exit>
  74:	f426                	sd	s1,40(sp)
  }
  close(p2c[0]); close(c2p[1]);         // the ends the parent does not use
  76:	fd842503          	lw	a0,-40(s0)
  7a:	33c000ef          	jal	3b6 <close>
  7e:	fd442503          	lw	a0,-44(s0)
  82:	334000ef          	jal	3b6 <close>
  b = 'x';
  86:	07800793          	li	a5,120
  8a:	fcf407a3          	sb	a5,-49(s0)
  write(p2c[1], &b, 1);                 // send one byte to the child
  8e:	fcf40493          	addi	s1,s0,-49
  92:	4605                	li	a2,1
  94:	85a6                	mv	a1,s1
  96:	fdc42503          	lw	a0,-36(s0)
  9a:	314000ef          	jal	3ae <write>
  read(c2p[0], &b, 1);                  // block until the child replies
  9e:	4605                	li	a2,1
  a0:	85a6                	mv	a1,s1
  a2:	fd042503          	lw	a0,-48(s0)
  a6:	300000ef          	jal	3a6 <read>
  printf("%d: received pong\n", getpid());
  aa:	364000ef          	jal	40e <getpid>
  ae:	85aa                	mv	a1,a0
  b0:	00001517          	auipc	a0,0x1
  b4:	8f850513          	addi	a0,a0,-1800 # 9a8 <malloc+0x10c>
  b8:	72c000ef          	jal	7e4 <printf>
  close(p2c[1]); close(c2p[0]);
  bc:	fdc42503          	lw	a0,-36(s0)
  c0:	2f6000ef          	jal	3b6 <close>
  c4:	fd042503          	lw	a0,-48(s0)
  c8:	2ee000ef          	jal	3b6 <close>
  wait(0);
  cc:	4501                	li	a0,0
  ce:	2c8000ef          	jal	396 <wait>
  exit(0);
  d2:	4501                	li	a0,0
  d4:	2ba000ef          	jal	38e <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  e0:	f21ff0ef          	jal	0 <main>
  exit(r);
  e4:	2aa000ef          	jal	38e <exit>

00000000000000e8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0xa>
    ;
  return os;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	cb91                	beqz	a5,128 <strcmp+0x20>
 116:	0005c703          	lbu	a4,0(a1)
 11a:	00f71763          	bne	a4,a5,128 <strcmp+0x20>
    p++, q++;
 11e:	0505                	addi	a0,a0,1
 120:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 122:	00054783          	lbu	a5,0(a0)
 126:	fbe5                	bnez	a5,116 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 128:	0005c503          	lbu	a0,0(a1)
}
 12c:	40a7853b          	subw	a0,a5,a0
 130:	60a2                	ld	ra,8(sp)
 132:	6402                	ld	s0,0(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strlen>:

uint
strlen(const char *s)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 140:	00054783          	lbu	a5,0(a0)
 144:	cf91                	beqz	a5,160 <strlen+0x28>
 146:	00150793          	addi	a5,a0,1
 14a:	86be                	mv	a3,a5
 14c:	0785                	addi	a5,a5,1
 14e:	fff7c703          	lbu	a4,-1(a5)
 152:	ff65                	bnez	a4,14a <strlen+0x12>
 154:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 158:	60a2                	ld	ra,8(sp)
 15a:	6402                	ld	s0,0(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret
  for (n = 0; s[n]; n++)
 160:	4501                	li	a0,0
 162:	bfdd                	j	158 <strlen+0x20>

0000000000000164 <memset>:

void *
memset(void *dst, int c, uint n)
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 16c:	ca19                	beqz	a2,182 <memset+0x1e>
 16e:	87aa                	mv	a5,a0
 170:	1602                	slli	a2,a2,0x20
 172:	9201                	srli	a2,a2,0x20
 174:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 178:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 17c:	0785                	addi	a5,a5,1
 17e:	fee79de3          	bne	a5,a4,178 <memset+0x14>
  }
  return dst;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strchr>:

char *
strchr(const char *s, char c)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e406                	sd	ra,8(sp)
 18e:	e022                	sd	s0,0(sp)
 190:	0800                	addi	s0,sp,16
  for (; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cf81                	beqz	a5,1ae <strchr+0x24>
    if (*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1c>
  for (; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xe>
      return (char *)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	60a2                	ld	ra,8(sp)
 1a8:	6402                	ld	s0,0(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret
  return 0;
 1ae:	4501                	li	a0,0
 1b0:	bfdd                	j	1a6 <strchr+0x1c>

00000000000001b2 <gets>:

char *
gets(char *buf, int max)
{
 1b2:	711d                	addi	sp,sp,-96
 1b4:	ec86                	sd	ra,88(sp)
 1b6:	e8a2                	sd	s0,80(sp)
 1b8:	e4a6                	sd	s1,72(sp)
 1ba:	e0ca                	sd	s2,64(sp)
 1bc:	fc4e                	sd	s3,56(sp)
 1be:	f852                	sd	s4,48(sp)
 1c0:	f456                	sd	s5,40(sp)
 1c2:	f05a                	sd	s6,32(sp)
 1c4:	ec5e                	sd	s7,24(sp)
 1c6:	e862                	sd	s8,16(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1d2:	faf40b13          	addi	s6,s0,-81
 1d6:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1d8:	8c26                	mv	s8,s1
 1da:	0014899b          	addiw	s3,s1,1
 1de:	84ce                	mv	s1,s3
 1e0:	0349d463          	bge	s3,s4,208 <gets+0x56>
    cc = read(0, &c, 1);
 1e4:	8656                	mv	a2,s5
 1e6:	85da                	mv	a1,s6
 1e8:	4501                	li	a0,0
 1ea:	1bc000ef          	jal	3a6 <read>
    if (cc < 1)
 1ee:	00a05d63          	blez	a0,208 <gets+0x56>
      break;
    buf[i++] = c;
 1f2:	faf44783          	lbu	a5,-81(s0)
 1f6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1fa:	0905                	addi	s2,s2,1
 1fc:	ff678713          	addi	a4,a5,-10
 200:	c319                	beqz	a4,206 <gets+0x54>
 202:	17cd                	addi	a5,a5,-13
 204:	fbf1                	bnez	a5,1d8 <gets+0x26>
    buf[i++] = c;
 206:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 208:	9c5e                	add	s8,s8,s7
 20a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 20e:	855e                	mv	a0,s7
 210:	60e6                	ld	ra,88(sp)
 212:	6446                	ld	s0,80(sp)
 214:	64a6                	ld	s1,72(sp)
 216:	6906                	ld	s2,64(sp)
 218:	79e2                	ld	s3,56(sp)
 21a:	7a42                	ld	s4,48(sp)
 21c:	7aa2                	ld	s5,40(sp)
 21e:	7b02                	ld	s6,32(sp)
 220:	6be2                	ld	s7,24(sp)
 222:	6c42                	ld	s8,16(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	1000                	addi	s0,sp,32
 232:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	4581                	li	a1,0
 236:	198000ef          	jal	3ce <open>
  if (fd < 0)
 23a:	02054263          	bltz	a0,25e <stat+0x36>
 23e:	e426                	sd	s1,8(sp)
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	1a2000ef          	jal	3e6 <fstat>
 248:	892a                	mv	s2,a0
  close(fd);
 24a:	8526                	mv	a0,s1
 24c:	16a000ef          	jal	3b6 <close>
  return r;
 250:	64a2                	ld	s1,8(sp)
}
 252:	854a                	mv	a0,s2
 254:	60e2                	ld	ra,24(sp)
 256:	6442                	ld	s0,16(sp)
 258:	6902                	ld	s2,0(sp)
 25a:	6105                	addi	sp,sp,32
 25c:	8082                	ret
    return -1;
 25e:	57fd                	li	a5,-1
 260:	893e                	mv	s2,a5
 262:	bfc5                	j	252 <stat+0x2a>

0000000000000264 <atoi>:

int
atoi(const char *s)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 26c:	00054683          	lbu	a3,0(a0)
 270:	fd06879b          	addiw	a5,a3,-48
 274:	0ff7f793          	zext.b	a5,a5
 278:	4625                	li	a2,9
 27a:	02f66963          	bltu	a2,a5,2ac <atoi+0x48>
 27e:	872a                	mv	a4,a0
  n = 0;
 280:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 282:	0705                	addi	a4,a4,1
 284:	0025179b          	slliw	a5,a0,0x2
 288:	9fa9                	addw	a5,a5,a0
 28a:	0017979b          	slliw	a5,a5,0x1
 28e:	9fb5                	addw	a5,a5,a3
 290:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 294:	00074683          	lbu	a3,0(a4)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	fef671e3          	bgeu	a2,a5,282 <atoi+0x1e>
  return n;
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  n = 0;
 2ac:	4501                	li	a0,0
 2ae:	bfdd                	j	2a4 <atoi+0x40>

00000000000002b0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57563          	bgeu	a0,a1,2e2 <memmove+0x32>
    while (n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x2a>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2d6:	fee79ae3          	bne	a5,a4,2ca <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    while (n-- > 0)
 2e2:	fec05ce3          	blez	a2,2da <memmove+0x2a>
    dst += n;
 2e6:	00c50733          	add	a4,a0,a2
    src += n;
 2ea:	95b2                	add	a1,a1,a2
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 306:	fef71ae3          	bne	a4,a5,2fa <memmove+0x4a>
 30a:	bfc1                	j	2da <memmove+0x2a>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 314:	c61d                	beqz	a2,342 <memcmp+0x36>
 316:	1602                	slli	a2,a2,0x20
 318:	9201                	srli	a2,a2,0x20
 31a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79863          	bne	a5,a4,336 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x12>
  }
  return 0;
 332:	4501                	li	a0,0
 334:	a019                	j	33a <memcmp+0x2e>
      return *p1 - *p2;
 336:	40e7853b          	subw	a0,a5,a4
}
 33a:	60a2                	ld	ra,8(sp)
 33c:	6402                	ld	s0,0(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret
  return 0;
 342:	4501                	li	a0,0
 344:	bfdd                	j	33a <memcmp+0x2e>

0000000000000346 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34e:	f63ff0ef          	jal	2b0 <memmove>
}
 352:	60a2                	ld	ra,8(sp)
 354:	6402                	ld	s0,0(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret

000000000000035a <sbrk>:

char *
sbrk(int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 362:	4585                	li	a1,1
 364:	0b2000ef          	jal	416 <sys_sbrk>
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret

0000000000000370 <sbrklazy>:

char *
sbrklazy(int n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 378:	4589                	li	a1,2
 37a:	09c000ef          	jal	416 <sys_sbrk>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <pause>:
.global pause
pause:
 li a7, SYS_pause
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <sync>:
.global sync
sync:
 li a7, SYS_sync
 42e:	48d9                	li	a7,22
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <trace>:
.global trace
trace:
 li a7, SYS_trace
 436:	48dd                	li	a7,23
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	1000                	addi	s0,sp,32
 446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44a:	4605                	li	a2,1
 44c:	fef40593          	addi	a1,s0,-17
 450:	f5fff0ef          	jal	3ae <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 45c:	715d                	addi	sp,sp,-80
 45e:	e486                	sd	ra,72(sp)
 460:	e0a2                	sd	s0,64(sp)
 462:	f84a                	sd	s2,48(sp)
 464:	f44e                	sd	s3,40(sp)
 466:	0880                	addi	s0,sp,80
 468:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 46a:	c6d1                	beqz	a3,4f6 <printint+0x9a>
 46c:	0805d563          	bgez	a1,4f6 <printint+0x9a>
    neg = 1;
    x = -xx;
 470:	40b005b3          	neg	a1,a1
    neg = 1;
 474:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 476:	fb840993          	addi	s3,s0,-72
  neg = 0;
 47a:	86ce                	mv	a3,s3
  i = 0;
 47c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 47e:	00000817          	auipc	a6,0x0
 482:	54a80813          	addi	a6,a6,1354 # 9c8 <digits>
 486:	88ba                	mv	a7,a4
 488:	0017051b          	addiw	a0,a4,1
 48c:	872a                	mv	a4,a0
 48e:	02c5f7b3          	remu	a5,a1,a2
 492:	97c2                	add	a5,a5,a6
 494:	0007c783          	lbu	a5,0(a5)
 498:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 49c:	87ae                	mv	a5,a1
 49e:	02c5d5b3          	divu	a1,a1,a2
 4a2:	0685                	addi	a3,a3,1
 4a4:	fec7f1e3          	bgeu	a5,a2,486 <printint+0x2a>
  if (neg)
 4a8:	00030c63          	beqz	t1,4c0 <printint+0x64>
    buf[i++] = '-';
 4ac:	fd050793          	addi	a5,a0,-48
 4b0:	00878533          	add	a0,a5,s0
 4b4:	02d00793          	li	a5,45
 4b8:	fef50423          	sb	a5,-24(a0)
 4bc:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4c0:	02e05563          	blez	a4,4ea <printint+0x8e>
 4c4:	fc26                	sd	s1,56(sp)
 4c6:	377d                	addiw	a4,a4,-1
 4c8:	00e984b3          	add	s1,s3,a4
 4cc:	19fd                	addi	s3,s3,-1
 4ce:	99ba                	add	s3,s3,a4
 4d0:	1702                	slli	a4,a4,0x20
 4d2:	9301                	srli	a4,a4,0x20
 4d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d8:	0004c583          	lbu	a1,0(s1)
 4dc:	854a                	mv	a0,s2
 4de:	f61ff0ef          	jal	43e <putc>
  while (--i >= 0)
 4e2:	14fd                	addi	s1,s1,-1
 4e4:	ff349ae3          	bne	s1,s3,4d8 <printint+0x7c>
 4e8:	74e2                	ld	s1,56(sp)
}
 4ea:	60a6                	ld	ra,72(sp)
 4ec:	6406                	ld	s0,64(sp)
 4ee:	7942                	ld	s2,48(sp)
 4f0:	79a2                	ld	s3,40(sp)
 4f2:	6161                	addi	sp,sp,80
 4f4:	8082                	ret
  neg = 0;
 4f6:	4301                	li	t1,0
 4f8:	bfbd                	j	476 <printint+0x1a>

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	711d                	addi	sp,sp,-96
 4fc:	ec86                	sd	ra,88(sp)
 4fe:	e8a2                	sd	s0,80(sp)
 500:	e4a6                	sd	s1,72(sp)
 502:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 504:	0005c483          	lbu	s1,0(a1)
 508:	22048363          	beqz	s1,72e <vprintf+0x234>
 50c:	e0ca                	sd	s2,64(sp)
 50e:	fc4e                	sd	s3,56(sp)
 510:	f852                	sd	s4,48(sp)
 512:	f456                	sd	s5,40(sp)
 514:	f05a                	sd	s6,32(sp)
 516:	ec5e                	sd	s7,24(sp)
 518:	e862                	sd	s8,16(sp)
 51a:	8b2a                	mv	s6,a0
 51c:	8a2e                	mv	s4,a1
 51e:	8bb2                	mv	s7,a2
  state = 0;
 520:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 522:	4901                	li	s2,0
 524:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 526:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 52a:	06400c13          	li	s8,100
 52e:	a00d                	j	550 <vprintf+0x56>
        putc(fd, c0);
 530:	85a6                	mv	a1,s1
 532:	855a                	mv	a0,s6
 534:	f0bff0ef          	jal	43e <putc>
 538:	a019                	j	53e <vprintf+0x44>
    } else if (state == '%') {
 53a:	03598363          	beq	s3,s5,560 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 53e:	0019079b          	addiw	a5,s2,1
 542:	893e                	mv	s2,a5
 544:	873e                	mv	a4,a5
 546:	97d2                	add	a5,a5,s4
 548:	0007c483          	lbu	s1,0(a5)
 54c:	1c048a63          	beqz	s1,720 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 550:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 554:	fe0993e3          	bnez	s3,53a <vprintf+0x40>
      if (c0 == '%') {
 558:	fd579ce3          	bne	a5,s5,530 <vprintf+0x36>
        state = '%';
 55c:	89be                	mv	s3,a5
 55e:	b7c5                	j	53e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 560:	00ea06b3          	add	a3,s4,a4
 564:	0016c603          	lbu	a2,1(a3)
      if (c1)
 568:	1c060863          	beqz	a2,738 <vprintf+0x23e>
      if (c0 == 'd') {
 56c:	03878763          	beq	a5,s8,59a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 570:	f9478693          	addi	a3,a5,-108
 574:	0016b693          	seqz	a3,a3
 578:	f9c60593          	addi	a1,a2,-100
 57c:	e99d                	bnez	a1,5b2 <vprintf+0xb8>
 57e:	ca95                	beqz	a3,5b2 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	008b8493          	addi	s1,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000bb583          	ld	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	ecfff0ef          	jal	45c <printint>
        i += 1;
 592:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 596:	4981                	li	s3,0
 598:	b75d                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4685                	li	a3,1
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	eb5ff0ef          	jal	45c <printint>
 5ac:	8ba6                	mv	s7,s1
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b779                	j	53e <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 5b2:	9752                	add	a4,a4,s4
 5b4:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5b8:	f9460713          	addi	a4,a2,-108
 5bc:	00173713          	seqz	a4,a4
 5c0:	8f75                	and	a4,a4,a3
 5c2:	f9c58513          	addi	a0,a1,-100
 5c6:	18051363          	bnez	a0,74c <vprintf+0x252>
 5ca:	18070163          	beqz	a4,74c <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4685                	li	a3,1
 5d4:	4629                	li	a2,10
 5d6:	000bb583          	ld	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e81ff0ef          	jal	45c <printint>
        i += 2;
 5e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
        i += 2;
 5e6:	bfa1                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000be583          	lwu	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e67ff0ef          	jal	45c <printint>
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b781                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e4fff0ef          	jal	45c <printint>
        i += 1;
 612:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	b71d                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000bb583          	ld	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e35ff0ef          	jal	45c <printint>
        i += 2;
 62c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
        i += 2;
 632:	b731                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000be583          	lwu	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	e1bff0ef          	jal	45c <printint>
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bdd5                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8493          	addi	s1,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e03ff0ef          	jal	45c <printint>
        i += 1;
 65e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8ba6                	mv	s7,s1
      state = 0;
 662:	4981                	li	s3,0
 664:	bde9                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	008b8493          	addi	s1,s7,8
 66a:	4681                	li	a3,0
 66c:	4641                	li	a2,16
 66e:	000bb583          	ld	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	de9ff0ef          	jal	45c <printint>
        i += 2;
 678:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
        i += 2;
 67e:	b5c1                	j	53e <vprintf+0x44>
 680:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 682:	008b8793          	addi	a5,s7,8
 686:	8cbe                	mv	s9,a5
 688:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68c:	03000593          	li	a1,48
 690:	855a                	mv	a0,s6
 692:	dadff0ef          	jal	43e <putc>
  putc(fd, 'x');
 696:	07800593          	li	a1,120
 69a:	855a                	mv	a0,s6
 69c:	da3ff0ef          	jal	43e <putc>
 6a0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a2:	00000b97          	auipc	s7,0x0
 6a6:	326b8b93          	addi	s7,s7,806 # 9c8 <digits>
 6aa:	03c9d793          	srli	a5,s3,0x3c
 6ae:	97de                	add	a5,a5,s7
 6b0:	0007c583          	lbu	a1,0(a5)
 6b4:	855a                	mv	a0,s6
 6b6:	d89ff0ef          	jal	43e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ba:	0992                	slli	s3,s3,0x4
 6bc:	34fd                	addiw	s1,s1,-1
 6be:	f4f5                	bnez	s1,6aa <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6c0:	8be6                	mv	s7,s9
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	6ca2                	ld	s9,8(sp)
 6c6:	bda5                	j	53e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	000bc583          	lbu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	d6dff0ef          	jal	43e <putc>
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b595                	j	53e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6dc:	008b8993          	addi	s3,s7,8
 6e0:	000bb483          	ld	s1,0(s7)
 6e4:	cc91                	beqz	s1,700 <vprintf+0x206>
        for (; *s; s++)
 6e6:	0004c583          	lbu	a1,0(s1)
 6ea:	c985                	beqz	a1,71a <vprintf+0x220>
          putc(fd, *s);
 6ec:	855a                	mv	a0,s6
 6ee:	d51ff0ef          	jal	43e <putc>
        for (; *s; s++)
 6f2:	0485                	addi	s1,s1,1
 6f4:	0004c583          	lbu	a1,0(s1)
 6f8:	f9f5                	bnez	a1,6ec <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b581                	j	53e <vprintf+0x44>
          s = "(null)";
 700:	00000497          	auipc	s1,0x0
 704:	2c048493          	addi	s1,s1,704 # 9c0 <malloc+0x124>
        for (; *s; s++)
 708:	02800593          	li	a1,40
 70c:	b7c5                	j	6ec <vprintf+0x1f2>
        putc(fd, '%');
 70e:	85be                	mv	a1,a5
 710:	855a                	mv	a0,s6
 712:	d2dff0ef          	jal	43e <putc>
      state = 0;
 716:	4981                	li	s3,0
 718:	b51d                	j	53e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b505                	j	53e <vprintf+0x44>
 720:	6906                	ld	s2,64(sp)
 722:	79e2                	ld	s3,56(sp)
 724:	7a42                	ld	s4,48(sp)
 726:	7aa2                	ld	s5,40(sp)
 728:	7b02                	ld	s6,32(sp)
 72a:	6be2                	ld	s7,24(sp)
 72c:	6c42                	ld	s8,16(sp)
    }
  }
}
 72e:	60e6                	ld	ra,88(sp)
 730:	6446                	ld	s0,80(sp)
 732:	64a6                	ld	s1,72(sp)
 734:	6125                	addi	sp,sp,96
 736:	8082                	ret
      if (c0 == 'd') {
 738:	06400713          	li	a4,100
 73c:	e4e78fe3          	beq	a5,a4,59a <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 740:	f9478693          	addi	a3,a5,-108
 744:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 748:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 74a:	4701                	li	a4,0
      } else if (c0 == 'u') {
 74c:	07500513          	li	a0,117
 750:	e8a78ce3          	beq	a5,a0,5e8 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 754:	f8b60513          	addi	a0,a2,-117
 758:	e119                	bnez	a0,75e <vprintf+0x264>
 75a:	ea0693e3          	bnez	a3,600 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 75e:	f8b58513          	addi	a0,a1,-117
 762:	e119                	bnez	a0,768 <vprintf+0x26e>
 764:	ea071be3          	bnez	a4,61a <vprintf+0x120>
      } else if (c0 == 'x') {
 768:	07800513          	li	a0,120
 76c:	eca784e3          	beq	a5,a0,634 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 770:	f8860613          	addi	a2,a2,-120
 774:	e219                	bnez	a2,77a <vprintf+0x280>
 776:	ec069be3          	bnez	a3,64c <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 77a:	f8858593          	addi	a1,a1,-120
 77e:	e199                	bnez	a1,784 <vprintf+0x28a>
 780:	ee0713e3          	bnez	a4,666 <vprintf+0x16c>
      } else if (c0 == 'p') {
 784:	07000713          	li	a4,112
 788:	eee78ce3          	beq	a5,a4,680 <vprintf+0x186>
      } else if (c0 == 'c') {
 78c:	06300713          	li	a4,99
 790:	f2e78ce3          	beq	a5,a4,6c8 <vprintf+0x1ce>
      } else if (c0 == 's') {
 794:	07300713          	li	a4,115
 798:	f4e782e3          	beq	a5,a4,6dc <vprintf+0x1e2>
      } else if (c0 == '%') {
 79c:	02500713          	li	a4,37
 7a0:	f6e787e3          	beq	a5,a4,70e <vprintf+0x214>
        putc(fd, '%');
 7a4:	02500593          	li	a1,37
 7a8:	855a                	mv	a0,s6
 7aa:	c95ff0ef          	jal	43e <putc>
        putc(fd, c0);
 7ae:	85a6                	mv	a1,s1
 7b0:	855a                	mv	a0,s6
 7b2:	c8dff0ef          	jal	43e <putc>
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b359                	j	53e <vprintf+0x44>

00000000000007ba <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ba:	715d                	addi	sp,sp,-80
 7bc:	ec06                	sd	ra,24(sp)
 7be:	e822                	sd	s0,16(sp)
 7c0:	1000                	addi	s0,sp,32
 7c2:	e010                	sd	a2,0(s0)
 7c4:	e414                	sd	a3,8(s0)
 7c6:	e818                	sd	a4,16(s0)
 7c8:	ec1c                	sd	a5,24(s0)
 7ca:	03043023          	sd	a6,32(s0)
 7ce:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	8622                	mv	a2,s0
 7d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d8:	d23ff0ef          	jal	4fa <vprintf>
}
 7dc:	60e2                	ld	ra,24(sp)
 7de:	6442                	ld	s0,16(sp)
 7e0:	6161                	addi	sp,sp,80
 7e2:	8082                	ret

00000000000007e4 <printf>:

void
printf(const char *fmt, ...)
{
 7e4:	711d                	addi	sp,sp,-96
 7e6:	ec06                	sd	ra,24(sp)
 7e8:	e822                	sd	s0,16(sp)
 7ea:	1000                	addi	s0,sp,32
 7ec:	e40c                	sd	a1,8(s0)
 7ee:	e810                	sd	a2,16(s0)
 7f0:	ec14                	sd	a3,24(s0)
 7f2:	f018                	sd	a4,32(s0)
 7f4:	f41c                	sd	a5,40(s0)
 7f6:	03043823          	sd	a6,48(s0)
 7fa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fe:	00840613          	addi	a2,s0,8
 802:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 806:	85aa                	mv	a1,a0
 808:	4505                	li	a0,1
 80a:	cf1ff0ef          	jal	4fa <vprintf>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 816:	1141                	addi	sp,sp,-16
 818:	e406                	sd	ra,8(sp)
 81a:	e022                	sd	s0,0(sp)
 81c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 81e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	7de7b783          	ld	a5,2014(a5) # 1000 <freep>
 82a:	a039                	j	838 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82c:	6398                	ld	a4,0(a5)
 82e:	00e7e463          	bltu	a5,a4,836 <free+0x20>
 832:	00e6ea63          	bltu	a3,a4,846 <free+0x30>
{
 836:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	fed7fae3          	bgeu	a5,a3,82c <free+0x16>
 83c:	6398                	ld	a4,0(a5)
 83e:	00e6e463          	bltu	a3,a4,846 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	fee7eae3          	bltu	a5,a4,836 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 846:	ff852583          	lw	a1,-8(a0)
 84a:	6390                	ld	a2,0(a5)
 84c:	02059813          	slli	a6,a1,0x20
 850:	01c85713          	srli	a4,a6,0x1c
 854:	9736                	add	a4,a4,a3
 856:	02e60563          	beq	a2,a4,880 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 85a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 85e:	4790                	lw	a2,8(a5)
 860:	02061593          	slli	a1,a2,0x20
 864:	01c5d713          	srli	a4,a1,0x1c
 868:	973e                	add	a4,a4,a5
 86a:	02e68263          	beq	a3,a4,88e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 86e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 870:	00000717          	auipc	a4,0x0
 874:	78f73823          	sd	a5,1936(a4) # 1000 <freep>
}
 878:	60a2                	ld	ra,8(sp)
 87a:	6402                	ld	s0,0(sp)
 87c:	0141                	addi	sp,sp,16
 87e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 880:	4618                	lw	a4,8(a2)
 882:	9f2d                	addw	a4,a4,a1
 884:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	6310                	ld	a2,0(a4)
 88c:	b7f9                	j	85a <free+0x44>
    p->s.size += bp->s.size;
 88e:	ff852703          	lw	a4,-8(a0)
 892:	9f31                	addw	a4,a4,a2
 894:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 896:	ff053683          	ld	a3,-16(a0)
 89a:	bfd1                	j	86e <free+0x58>

000000000000089c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 89c:	7139                	addi	sp,sp,-64
 89e:	fc06                	sd	ra,56(sp)
 8a0:	f822                	sd	s0,48(sp)
 8a2:	f04a                	sd	s2,32(sp)
 8a4:	ec4e                	sd	s3,24(sp)
 8a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8a8:	02051993          	slli	s3,a0,0x20
 8ac:	0209d993          	srli	s3,s3,0x20
 8b0:	09bd                	addi	s3,s3,15
 8b2:	0049d993          	srli	s3,s3,0x4
 8b6:	2985                	addiw	s3,s3,1
 8b8:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8ba:	00000517          	auipc	a0,0x0
 8be:	74653503          	ld	a0,1862(a0) # 1000 <freep>
 8c2:	c905                	beqz	a0,8f2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c6:	4798                	lw	a4,8(a5)
 8c8:	09377663          	bgeu	a4,s3,954 <malloc+0xb8>
 8cc:	f426                	sd	s1,40(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8d4:	8a4e                	mv	s4,s3
 8d6:	6705                	lui	a4,0x1
 8d8:	00e9f363          	bgeu	s3,a4,8de <malloc+0x42>
 8dc:	6a05                	lui	s4,0x1
 8de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8e6:	00000497          	auipc	s1,0x0
 8ea:	71a48493          	addi	s1,s1,1818 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ee:	5afd                	li	s5,-1
 8f0:	a83d                	j	92e <malloc+0x92>
 8f2:	f426                	sd	s1,40(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fa:	00000797          	auipc	a5,0x0
 8fe:	71678793          	addi	a5,a5,1814 # 1010 <base>
 902:	00000717          	auipc	a4,0x0
 906:	6ef73f23          	sd	a5,1790(a4) # 1000 <freep>
 90a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 910:	b7d1                	j	8d4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	a899                	j	96c <malloc+0xd0>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 91c:	0541                	addi	a0,a0,16
 91e:	ef9ff0ef          	jal	816 <free>
  return freep;
 922:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 924:	c125                	beqz	a0,984 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 926:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 928:	4798                	lw	a4,8(a5)
 92a:	03277163          	bgeu	a4,s2,94c <malloc+0xb0>
    if (p == freep)
 92e:	6098                	ld	a4,0(s1)
 930:	853e                	mv	a0,a5
 932:	fef71ae3          	bne	a4,a5,926 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 936:	8552                	mv	a0,s4
 938:	a23ff0ef          	jal	35a <sbrk>
  if (p == SBRK_ERROR)
 93c:	fd551ee3          	bne	a0,s5,918 <malloc+0x7c>
        return 0;
 940:	4501                	li	a0,0
 942:	74a2                	ld	s1,40(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	a03d                	j	978 <malloc+0xdc>
 94c:	74a2                	ld	s1,40(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 954:	fae90fe3          	beq	s2,a4,912 <malloc+0x76>
        p->s.size -= nunits;
 958:	4137073b          	subw	a4,a4,s3
 95c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95e:	02071693          	slli	a3,a4,0x20
 962:	01c6d713          	srli	a4,a3,0x1c
 966:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 968:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96c:	00000717          	auipc	a4,0x0
 970:	68a73a23          	sd	a0,1684(a4) # 1000 <freep>
      return (void *)(p + 1);
 974:	01078513          	addi	a0,a5,16
  }
}
 978:	70e2                	ld	ra,56(sp)
 97a:	7442                	ld	s0,48(sp)
 97c:	7902                	ld	s2,32(sp)
 97e:	69e2                	ld	s3,24(sp)
 980:	6121                	addi	sp,sp,64
 982:	8082                	ret
 984:	74a2                	ld	s1,40(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	b7f5                	j	978 <malloc+0xdc>
