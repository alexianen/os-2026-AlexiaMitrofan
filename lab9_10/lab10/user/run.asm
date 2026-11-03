
user/_run:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

// the three steps of the shell, inside xv6:  echo hello from the child
int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  printf("parent: my pid is %d\n", getpid());
   8:	3ce000ef          	jal	3d6 <getpid>
   c:	85aa                	mv	a1,a0
   e:	00001517          	auipc	a0,0x1
  12:	95250513          	addi	a0,a0,-1710 # 960 <malloc+0xfc>
  16:	796000ef          	jal	7ac <printf>

  int pid = fork();                     // step 1: copy myself
  1a:	334000ef          	jal	34e <fork>
  if(pid < 0){
  1e:	04054763          	bltz	a0,6c <main+0x6c>
  22:	f426                	sd	s1,40(sp)
  24:	84aa                	mv	s1,a0
    printf("fork failed\n");
    exit(1);
  }

  if(pid == 0){                         // only the child runs this
  26:	ed29                	bnez	a0,80 <main+0x80>
    printf("child: my pid is %d\n", getpid());
  28:	3ae000ef          	jal	3d6 <getpid>
  2c:	85aa                	mv	a1,a0
  2e:	00001517          	auipc	a0,0x1
  32:	95a50513          	addi	a0,a0,-1702 # 988 <malloc+0x124>
  36:	776000ef          	jal	7ac <printf>
    char *args[] = { "ls", 0 };
  3a:	00001797          	auipc	a5,0x1
  3e:	96678793          	addi	a5,a5,-1690 # 9a0 <malloc+0x13c>
  42:	fcf43423          	sd	a5,-56(s0)
  46:	fc043823          	sd	zero,-48(s0)
    exec("nosuchprog", args);           // step 2: program that doesn't exist
  4a:	fc840593          	addi	a1,s0,-56
  4e:	00001517          	auipc	a0,0x1
  52:	95a50513          	addi	a0,a0,-1702 # 9a8 <malloc+0x144>
  56:	338000ef          	jal	38e <exec>
    printf("exec failed\n");            // runs only if exec failed
  5a:	00001517          	auipc	a0,0x1
  5e:	95e50513          	addi	a0,a0,-1698 # 9b8 <malloc+0x154>
  62:	74a000ef          	jal	7ac <printf>
    exit(1);
  66:	4505                	li	a0,1
  68:	2ee000ef          	jal	356 <exit>
  6c:	f426                	sd	s1,40(sp)
    printf("fork failed\n");
  6e:	00001517          	auipc	a0,0x1
  72:	90a50513          	addi	a0,a0,-1782 # 978 <malloc+0x114>
  76:	736000ef          	jal	7ac <printf>
    exit(1);
  7a:	4505                	li	a0,1
  7c:	2da000ef          	jal	356 <exit>
  }

  int status;
  wait(&status);                        // step 3: wait for the child
  80:	fdc40513          	addi	a0,s0,-36
  84:	2da000ef          	jal	35e <wait>
  printf("parent: child %d ended with status %d\n", pid, status);
  88:	fdc42603          	lw	a2,-36(s0)
  8c:	85a6                	mv	a1,s1
  8e:	00001517          	auipc	a0,0x1
  92:	93a50513          	addi	a0,a0,-1734 # 9c8 <malloc+0x164>
  96:	716000ef          	jal	7ac <printf>
  exit(0);
  9a:	4501                	li	a0,0
  9c:	2ba000ef          	jal	356 <exit>

00000000000000a0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  a8:	f59ff0ef          	jal	0 <main>
  exit(r);
  ac:	2aa000ef          	jal	356 <exit>

00000000000000b0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e406                	sd	ra,8(sp)
  b4:	e022                	sd	s0,0(sp)
  b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  b8:	87aa                	mv	a5,a0
  ba:	0585                	addi	a1,a1,1
  bc:	0785                	addi	a5,a5,1
  be:	fff5c703          	lbu	a4,-1(a1)
  c2:	fee78fa3          	sb	a4,-1(a5)
  c6:	fb75                	bnez	a4,ba <strcpy+0xa>
    ;
  return os;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cb91                	beqz	a5,f0 <strcmp+0x20>
  de:	0005c703          	lbu	a4,0(a1)
  e2:	00f71763          	bne	a4,a5,f0 <strcmp+0x20>
    p++, q++;
  e6:	0505                	addi	a0,a0,1
  e8:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbe5                	bnez	a5,de <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  f0:	0005c503          	lbu	a0,0(a1)
}
  f4:	40a7853b          	subw	a0,a5,a0
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strlen>:

uint
strlen(const char *s)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf91                	beqz	a5,128 <strlen+0x28>
 10e:	00150793          	addi	a5,a0,1
 112:	86be                	mv	a3,a5
 114:	0785                	addi	a5,a5,1
 116:	fff7c703          	lbu	a4,-1(a5)
 11a:	ff65                	bnez	a4,112 <strlen+0x12>
 11c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 120:	60a2                	ld	ra,8(sp)
 122:	6402                	ld	s0,0(sp)
 124:	0141                	addi	sp,sp,16
 126:	8082                	ret
  for (n = 0; s[n]; n++)
 128:	4501                	li	a0,0
 12a:	bfdd                	j	120 <strlen+0x20>

000000000000012c <memset>:

void *
memset(void *dst, int c, uint n)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 134:	ca19                	beqz	a2,14a <memset+0x1e>
 136:	87aa                	mv	a5,a0
 138:	1602                	slli	a2,a2,0x20
 13a:	9201                	srli	a2,a2,0x20
 13c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 140:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 144:	0785                	addi	a5,a5,1
 146:	fee79de3          	bne	a5,a4,140 <memset+0x14>
  }
  return dst;
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <strchr>:

char *
strchr(const char *s, char c)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  for (; *s; s++)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cf81                	beqz	a5,176 <strchr+0x24>
    if (*s == c)
 160:	00f58763          	beq	a1,a5,16e <strchr+0x1c>
  for (; *s; s++)
 164:	0505                	addi	a0,a0,1
 166:	00054783          	lbu	a5,0(a0)
 16a:	fbfd                	bnez	a5,160 <strchr+0xe>
      return (char *)s;
  return 0;
 16c:	4501                	li	a0,0
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret
  return 0;
 176:	4501                	li	a0,0
 178:	bfdd                	j	16e <strchr+0x1c>

000000000000017a <gets>:

char *
gets(char *buf, int max)
{
 17a:	711d                	addi	sp,sp,-96
 17c:	ec86                	sd	ra,88(sp)
 17e:	e8a2                	sd	s0,80(sp)
 180:	e4a6                	sd	s1,72(sp)
 182:	e0ca                	sd	s2,64(sp)
 184:	fc4e                	sd	s3,56(sp)
 186:	f852                	sd	s4,48(sp)
 188:	f456                	sd	s5,40(sp)
 18a:	f05a                	sd	s6,32(sp)
 18c:	ec5e                	sd	s7,24(sp)
 18e:	e862                	sd	s8,16(sp)
 190:	1080                	addi	s0,sp,96
 192:	8baa                	mv	s7,a0
 194:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 196:	892a                	mv	s2,a0
 198:	4481                	li	s1,0
    cc = read(0, &c, 1);
 19a:	faf40b13          	addi	s6,s0,-81
 19e:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1a0:	8c26                	mv	s8,s1
 1a2:	0014899b          	addiw	s3,s1,1
 1a6:	84ce                	mv	s1,s3
 1a8:	0349d463          	bge	s3,s4,1d0 <gets+0x56>
    cc = read(0, &c, 1);
 1ac:	8656                	mv	a2,s5
 1ae:	85da                	mv	a1,s6
 1b0:	4501                	li	a0,0
 1b2:	1bc000ef          	jal	36e <read>
    if (cc < 1)
 1b6:	00a05d63          	blez	a0,1d0 <gets+0x56>
      break;
    buf[i++] = c;
 1ba:	faf44783          	lbu	a5,-81(s0)
 1be:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1c2:	0905                	addi	s2,s2,1
 1c4:	ff678713          	addi	a4,a5,-10
 1c8:	c319                	beqz	a4,1ce <gets+0x54>
 1ca:	17cd                	addi	a5,a5,-13
 1cc:	fbf1                	bnez	a5,1a0 <gets+0x26>
    buf[i++] = c;
 1ce:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1d0:	9c5e                	add	s8,s8,s7
 1d2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1d6:	855e                	mv	a0,s7
 1d8:	60e6                	ld	ra,88(sp)
 1da:	6446                	ld	s0,80(sp)
 1dc:	64a6                	ld	s1,72(sp)
 1de:	6906                	ld	s2,64(sp)
 1e0:	79e2                	ld	s3,56(sp)
 1e2:	7a42                	ld	s4,48(sp)
 1e4:	7aa2                	ld	s5,40(sp)
 1e6:	7b02                	ld	s6,32(sp)
 1e8:	6be2                	ld	s7,24(sp)
 1ea:	6c42                	ld	s8,16(sp)
 1ec:	6125                	addi	sp,sp,96
 1ee:	8082                	ret

00000000000001f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f0:	1101                	addi	sp,sp,-32
 1f2:	ec06                	sd	ra,24(sp)
 1f4:	e822                	sd	s0,16(sp)
 1f6:	e04a                	sd	s2,0(sp)
 1f8:	1000                	addi	s0,sp,32
 1fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fc:	4581                	li	a1,0
 1fe:	198000ef          	jal	396 <open>
  if (fd < 0)
 202:	02054263          	bltz	a0,226 <stat+0x36>
 206:	e426                	sd	s1,8(sp)
 208:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20a:	85ca                	mv	a1,s2
 20c:	1a2000ef          	jal	3ae <fstat>
 210:	892a                	mv	s2,a0
  close(fd);
 212:	8526                	mv	a0,s1
 214:	16a000ef          	jal	37e <close>
  return r;
 218:	64a2                	ld	s1,8(sp)
}
 21a:	854a                	mv	a0,s2
 21c:	60e2                	ld	ra,24(sp)
 21e:	6442                	ld	s0,16(sp)
 220:	6902                	ld	s2,0(sp)
 222:	6105                	addi	sp,sp,32
 224:	8082                	ret
    return -1;
 226:	57fd                	li	a5,-1
 228:	893e                	mv	s2,a5
 22a:	bfc5                	j	21a <stat+0x2a>

000000000000022c <atoi>:

int
atoi(const char *s)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e406                	sd	ra,8(sp)
 230:	e022                	sd	s0,0(sp)
 232:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 234:	00054683          	lbu	a3,0(a0)
 238:	fd06879b          	addiw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	4625                	li	a2,9
 242:	02f66963          	bltu	a2,a5,274 <atoi+0x48>
 246:	872a                	mv	a4,a0
  n = 0;
 248:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 24a:	0705                	addi	a4,a4,1
 24c:	0025179b          	slliw	a5,a0,0x2
 250:	9fa9                	addw	a5,a5,a0
 252:	0017979b          	slliw	a5,a5,0x1
 256:	9fb5                	addw	a5,a5,a3
 258:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 25c:	00074683          	lbu	a3,0(a4)
 260:	fd06879b          	addiw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	fef671e3          	bgeu	a2,a5,24a <atoi+0x1e>
  return n;
}
 26c:	60a2                	ld	ra,8(sp)
 26e:	6402                	ld	s0,0(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
  n = 0;
 274:	4501                	li	a0,0
 276:	bfdd                	j	26c <atoi+0x40>

0000000000000278 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 280:	02b57563          	bgeu	a0,a1,2aa <memmove+0x32>
    while (n-- > 0)
 284:	00c05f63          	blez	a2,2a2 <memmove+0x2a>
 288:	1602                	slli	a2,a2,0x20
 28a:	9201                	srli	a2,a2,0x20
 28c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 290:	872a                	mv	a4,a0
      *dst++ = *src++;
 292:	0585                	addi	a1,a1,1
 294:	0705                	addi	a4,a4,1
 296:	fff5c683          	lbu	a3,-1(a1)
 29a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
    while (n-- > 0)
 2aa:	fec05ce3          	blez	a2,2a2 <memmove+0x2a>
    dst += n;
 2ae:	00c50733          	add	a4,a0,a2
    src += n;
 2b2:	95b2                	add	a1,a1,a2
 2b4:	fff6079b          	addiw	a5,a2,-1
 2b8:	1782                	slli	a5,a5,0x20
 2ba:	9381                	srli	a5,a5,0x20
 2bc:	fff7c793          	not	a5,a5
 2c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c2:	15fd                	addi	a1,a1,-1
 2c4:	177d                	addi	a4,a4,-1
 2c6:	0005c683          	lbu	a3,0(a1)
 2ca:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2ce:	fef71ae3          	bne	a4,a5,2c2 <memmove+0x4a>
 2d2:	bfc1                	j	2a2 <memmove+0x2a>

00000000000002d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2dc:	c61d                	beqz	a2,30a <memcmp+0x36>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00e79863          	bne	a5,a4,2fe <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2f2:	0505                	addi	a0,a0,1
    p2++;
 2f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f6:	fed518e3          	bne	a0,a3,2e6 <memcmp+0x12>
  }
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	a019                	j	302 <memcmp+0x2e>
      return *p1 - *p2;
 2fe:	40e7853b          	subw	a0,a5,a4
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  return 0;
 30a:	4501                	li	a0,0
 30c:	bfdd                	j	302 <memcmp+0x2e>

000000000000030e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 316:	f63ff0ef          	jal	278 <memmove>
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <sbrk>:

char *
sbrk(int n)
{
 322:	1141                	addi	sp,sp,-16
 324:	e406                	sd	ra,8(sp)
 326:	e022                	sd	s0,0(sp)
 328:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 32a:	4585                	li	a1,1
 32c:	0b2000ef          	jal	3de <sys_sbrk>
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <sbrklazy>:

char *
sbrklazy(int n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 340:	4589                	li	a1,2
 342:	09c000ef          	jal	3de <sys_sbrk>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 34e:	4885                	li	a7,1
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <exit>:
.global exit
exit:
 li a7, SYS_exit
 356:	4889                	li	a7,2
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <wait>:
.global wait
wait:
 li a7, SYS_wait
 35e:	488d                	li	a7,3
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 366:	4891                	li	a7,4
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <read>:
.global read
read:
 li a7, SYS_read
 36e:	4895                	li	a7,5
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <write>:
.global write
write:
 li a7, SYS_write
 376:	48c1                	li	a7,16
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <close>:
.global close
close:
 li a7, SYS_close
 37e:	48d5                	li	a7,21
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <kill>:
.global kill
kill:
 li a7, SYS_kill
 386:	4899                	li	a7,6
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exec>:
.global exec
exec:
 li a7, SYS_exec
 38e:	489d                	li	a7,7
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <open>:
.global open
open:
 li a7, SYS_open
 396:	48bd                	li	a7,15
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 39e:	48c5                	li	a7,17
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a6:	48c9                	li	a7,18
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ae:	48a1                	li	a7,8
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <link>:
.global link
link:
 li a7, SYS_link
 3b6:	48cd                	li	a7,19
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3be:	48d1                	li	a7,20
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c6:	48a5                	li	a7,9
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ce:	48a9                	li	a7,10
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d6:	48ad                	li	a7,11
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3de:	48b1                	li	a7,12
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e6:	48b5                	li	a7,13
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ee:	48b9                	li	a7,14
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3f6:	48d9                	li	a7,22
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <trace>:
.global trace
trace:
 li a7, SYS_trace
 3fe:	48dd                	li	a7,23
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	f5fff0ef          	jal	376 <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 424:	715d                	addi	sp,sp,-80
 426:	e486                	sd	ra,72(sp)
 428:	e0a2                	sd	s0,64(sp)
 42a:	f84a                	sd	s2,48(sp)
 42c:	f44e                	sd	s3,40(sp)
 42e:	0880                	addi	s0,sp,80
 430:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 432:	c6d1                	beqz	a3,4be <printint+0x9a>
 434:	0805d563          	bgez	a1,4be <printint+0x9a>
    neg = 1;
    x = -xx;
 438:	40b005b3          	neg	a1,a1
    neg = 1;
 43c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 442:	86ce                	mv	a3,s3
  i = 0;
 444:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 446:	00000817          	auipc	a6,0x0
 44a:	5b280813          	addi	a6,a6,1458 # 9f8 <digits>
 44e:	88ba                	mv	a7,a4
 450:	0017051b          	addiw	a0,a4,1
 454:	872a                	mv	a4,a0
 456:	02c5f7b3          	remu	a5,a1,a2
 45a:	97c2                	add	a5,a5,a6
 45c:	0007c783          	lbu	a5,0(a5)
 460:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 464:	87ae                	mv	a5,a1
 466:	02c5d5b3          	divu	a1,a1,a2
 46a:	0685                	addi	a3,a3,1
 46c:	fec7f1e3          	bgeu	a5,a2,44e <printint+0x2a>
  if (neg)
 470:	00030c63          	beqz	t1,488 <printint+0x64>
    buf[i++] = '-';
 474:	fd050793          	addi	a5,a0,-48
 478:	00878533          	add	a0,a5,s0
 47c:	02d00793          	li	a5,45
 480:	fef50423          	sb	a5,-24(a0)
 484:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 488:	02e05563          	blez	a4,4b2 <printint+0x8e>
 48c:	fc26                	sd	s1,56(sp)
 48e:	377d                	addiw	a4,a4,-1
 490:	00e984b3          	add	s1,s3,a4
 494:	19fd                	addi	s3,s3,-1
 496:	99ba                	add	s3,s3,a4
 498:	1702                	slli	a4,a4,0x20
 49a:	9301                	srli	a4,a4,0x20
 49c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a0:	0004c583          	lbu	a1,0(s1)
 4a4:	854a                	mv	a0,s2
 4a6:	f61ff0ef          	jal	406 <putc>
  while (--i >= 0)
 4aa:	14fd                	addi	s1,s1,-1
 4ac:	ff349ae3          	bne	s1,s3,4a0 <printint+0x7c>
 4b0:	74e2                	ld	s1,56(sp)
}
 4b2:	60a6                	ld	ra,72(sp)
 4b4:	6406                	ld	s0,64(sp)
 4b6:	7942                	ld	s2,48(sp)
 4b8:	79a2                	ld	s3,40(sp)
 4ba:	6161                	addi	sp,sp,80
 4bc:	8082                	ret
  neg = 0;
 4be:	4301                	li	t1,0
 4c0:	bfbd                	j	43e <printint+0x1a>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	711d                	addi	sp,sp,-96
 4c4:	ec86                	sd	ra,88(sp)
 4c6:	e8a2                	sd	s0,80(sp)
 4c8:	e4a6                	sd	s1,72(sp)
 4ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4cc:	0005c483          	lbu	s1,0(a1)
 4d0:	22048363          	beqz	s1,6f6 <vprintf+0x234>
 4d4:	e0ca                	sd	s2,64(sp)
 4d6:	fc4e                	sd	s3,56(sp)
 4d8:	f852                	sd	s4,48(sp)
 4da:	f456                	sd	s5,40(sp)
 4dc:	f05a                	sd	s6,32(sp)
 4de:	ec5e                	sd	s7,24(sp)
 4e0:	e862                	sd	s8,16(sp)
 4e2:	8b2a                	mv	s6,a0
 4e4:	8a2e                	mv	s4,a1
 4e6:	8bb2                	mv	s7,a2
  state = 0;
 4e8:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4ea:	4901                	li	s2,0
 4ec:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4ee:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4f2:	06400c13          	li	s8,100
 4f6:	a00d                	j	518 <vprintf+0x56>
        putc(fd, c0);
 4f8:	85a6                	mv	a1,s1
 4fa:	855a                	mv	a0,s6
 4fc:	f0bff0ef          	jal	406 <putc>
 500:	a019                	j	506 <vprintf+0x44>
    } else if (state == '%') {
 502:	03598363          	beq	s3,s5,528 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 506:	0019079b          	addiw	a5,s2,1
 50a:	893e                	mv	s2,a5
 50c:	873e                	mv	a4,a5
 50e:	97d2                	add	a5,a5,s4
 510:	0007c483          	lbu	s1,0(a5)
 514:	1c048a63          	beqz	s1,6e8 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 518:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 51c:	fe0993e3          	bnez	s3,502 <vprintf+0x40>
      if (c0 == '%') {
 520:	fd579ce3          	bne	a5,s5,4f8 <vprintf+0x36>
        state = '%';
 524:	89be                	mv	s3,a5
 526:	b7c5                	j	506 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 528:	00ea06b3          	add	a3,s4,a4
 52c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 530:	1c060863          	beqz	a2,700 <vprintf+0x23e>
      if (c0 == 'd') {
 534:	03878763          	beq	a5,s8,562 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 538:	f9478693          	addi	a3,a5,-108
 53c:	0016b693          	seqz	a3,a3
 540:	f9c60593          	addi	a1,a2,-100
 544:	e99d                	bnez	a1,57a <vprintf+0xb8>
 546:	ca95                	beqz	a3,57a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	008b8493          	addi	s1,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000bb583          	ld	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	ecfff0ef          	jal	424 <printint>
        i += 1;
 55a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 55e:	4981                	li	s3,0
 560:	b75d                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 562:	008b8493          	addi	s1,s7,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000ba583          	lw	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	eb5ff0ef          	jal	424 <printint>
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b779                	j	506 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 57a:	9752                	add	a4,a4,s4
 57c:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 580:	f9460713          	addi	a4,a2,-108
 584:	00173713          	seqz	a4,a4
 588:	8f75                	and	a4,a4,a3
 58a:	f9c58513          	addi	a0,a1,-100
 58e:	18051363          	bnez	a0,714 <vprintf+0x252>
 592:	18070163          	beqz	a4,714 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8493          	addi	s1,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000bb583          	ld	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e81ff0ef          	jal	424 <printint>
        i += 2;
 5a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8ba6                	mv	s7,s1
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	bfa1                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000be583          	lwu	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e67ff0ef          	jal	424 <printint>
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b781                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e4fff0ef          	jal	424 <printint>
        i += 1;
 5da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b71d                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e35ff0ef          	jal	424 <printint>
        i += 2;
 5f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	b731                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000be583          	lwu	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e1bff0ef          	jal	424 <printint>
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	bdd5                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e03ff0ef          	jal	424 <printint>
        i += 1;
 626:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	bde9                	j	506 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000bb583          	ld	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	de9ff0ef          	jal	424 <printint>
        i += 2;
 640:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
        i += 2;
 646:	b5c1                	j	506 <vprintf+0x44>
 648:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64a:	008b8793          	addi	a5,s7,8
 64e:	8cbe                	mv	s9,a5
 650:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 654:	03000593          	li	a1,48
 658:	855a                	mv	a0,s6
 65a:	dadff0ef          	jal	406 <putc>
  putc(fd, 'x');
 65e:	07800593          	li	a1,120
 662:	855a                	mv	a0,s6
 664:	da3ff0ef          	jal	406 <putc>
 668:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66a:	00000b97          	auipc	s7,0x0
 66e:	38eb8b93          	addi	s7,s7,910 # 9f8 <digits>
 672:	03c9d793          	srli	a5,s3,0x3c
 676:	97de                	add	a5,a5,s7
 678:	0007c583          	lbu	a1,0(a5)
 67c:	855a                	mv	a0,s6
 67e:	d89ff0ef          	jal	406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 682:	0992                	slli	s3,s3,0x4
 684:	34fd                	addiw	s1,s1,-1
 686:	f4f5                	bnez	s1,672 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 688:	8be6                	mv	s7,s9
      state = 0;
 68a:	4981                	li	s3,0
 68c:	6ca2                	ld	s9,8(sp)
 68e:	bda5                	j	506 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 690:	008b8493          	addi	s1,s7,8
 694:	000bc583          	lbu	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	d6dff0ef          	jal	406 <putc>
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b595                	j	506 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6a4:	008b8993          	addi	s3,s7,8
 6a8:	000bb483          	ld	s1,0(s7)
 6ac:	cc91                	beqz	s1,6c8 <vprintf+0x206>
        for (; *s; s++)
 6ae:	0004c583          	lbu	a1,0(s1)
 6b2:	c985                	beqz	a1,6e2 <vprintf+0x220>
          putc(fd, *s);
 6b4:	855a                	mv	a0,s6
 6b6:	d51ff0ef          	jal	406 <putc>
        for (; *s; s++)
 6ba:	0485                	addi	s1,s1,1
 6bc:	0004c583          	lbu	a1,0(s1)
 6c0:	f9f5                	bnez	a1,6b4 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b581                	j	506 <vprintf+0x44>
          s = "(null)";
 6c8:	00000497          	auipc	s1,0x0
 6cc:	32848493          	addi	s1,s1,808 # 9f0 <malloc+0x18c>
        for (; *s; s++)
 6d0:	02800593          	li	a1,40
 6d4:	b7c5                	j	6b4 <vprintf+0x1f2>
        putc(fd, '%');
 6d6:	85be                	mv	a1,a5
 6d8:	855a                	mv	a0,s6
 6da:	d2dff0ef          	jal	406 <putc>
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b51d                	j	506 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6e2:	8bce                	mv	s7,s3
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b505                	j	506 <vprintf+0x44>
 6e8:	6906                	ld	s2,64(sp)
 6ea:	79e2                	ld	s3,56(sp)
 6ec:	7a42                	ld	s4,48(sp)
 6ee:	7aa2                	ld	s5,40(sp)
 6f0:	7b02                	ld	s6,32(sp)
 6f2:	6be2                	ld	s7,24(sp)
 6f4:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f6:	60e6                	ld	ra,88(sp)
 6f8:	6446                	ld	s0,80(sp)
 6fa:	64a6                	ld	s1,72(sp)
 6fc:	6125                	addi	sp,sp,96
 6fe:	8082                	ret
      if (c0 == 'd') {
 700:	06400713          	li	a4,100
 704:	e4e78fe3          	beq	a5,a4,562 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 708:	f9478693          	addi	a3,a5,-108
 70c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 710:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 712:	4701                	li	a4,0
      } else if (c0 == 'u') {
 714:	07500513          	li	a0,117
 718:	e8a78ce3          	beq	a5,a0,5b0 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 71c:	f8b60513          	addi	a0,a2,-117
 720:	e119                	bnez	a0,726 <vprintf+0x264>
 722:	ea0693e3          	bnez	a3,5c8 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 726:	f8b58513          	addi	a0,a1,-117
 72a:	e119                	bnez	a0,730 <vprintf+0x26e>
 72c:	ea071be3          	bnez	a4,5e2 <vprintf+0x120>
      } else if (c0 == 'x') {
 730:	07800513          	li	a0,120
 734:	eca784e3          	beq	a5,a0,5fc <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 738:	f8860613          	addi	a2,a2,-120
 73c:	e219                	bnez	a2,742 <vprintf+0x280>
 73e:	ec069be3          	bnez	a3,614 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 742:	f8858593          	addi	a1,a1,-120
 746:	e199                	bnez	a1,74c <vprintf+0x28a>
 748:	ee0713e3          	bnez	a4,62e <vprintf+0x16c>
      } else if (c0 == 'p') {
 74c:	07000713          	li	a4,112
 750:	eee78ce3          	beq	a5,a4,648 <vprintf+0x186>
      } else if (c0 == 'c') {
 754:	06300713          	li	a4,99
 758:	f2e78ce3          	beq	a5,a4,690 <vprintf+0x1ce>
      } else if (c0 == 's') {
 75c:	07300713          	li	a4,115
 760:	f4e782e3          	beq	a5,a4,6a4 <vprintf+0x1e2>
      } else if (c0 == '%') {
 764:	02500713          	li	a4,37
 768:	f6e787e3          	beq	a5,a4,6d6 <vprintf+0x214>
        putc(fd, '%');
 76c:	02500593          	li	a1,37
 770:	855a                	mv	a0,s6
 772:	c95ff0ef          	jal	406 <putc>
        putc(fd, c0);
 776:	85a6                	mv	a1,s1
 778:	855a                	mv	a0,s6
 77a:	c8dff0ef          	jal	406 <putc>
      state = 0;
 77e:	4981                	li	s3,0
 780:	b359                	j	506 <vprintf+0x44>

0000000000000782 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 782:	715d                	addi	sp,sp,-80
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e010                	sd	a2,0(s0)
 78c:	e414                	sd	a3,8(s0)
 78e:	e818                	sd	a4,16(s0)
 790:	ec1c                	sd	a5,24(s0)
 792:	03043023          	sd	a6,32(s0)
 796:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	8622                	mv	a2,s0
 79c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a0:	d23ff0ef          	jal	4c2 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	cf1ff0ef          	jal	4c2 <vprintf>
}
 7d6:	60e2                	ld	ra,24(sp)
 7d8:	6442                	ld	s0,16(sp)
 7da:	6125                	addi	sp,sp,96
 7dc:	8082                	ret

00000000000007de <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7de:	1141                	addi	sp,sp,-16
 7e0:	e406                	sd	ra,8(sp)
 7e2:	e022                	sd	s0,0(sp)
 7e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7e6:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	00001797          	auipc	a5,0x1
 7ee:	8167b783          	ld	a5,-2026(a5) # 1000 <freep>
 7f2:	a039                	j	800 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e7e463          	bltu	a5,a4,7fe <free+0x20>
 7fa:	00e6ea63          	bltu	a3,a4,80e <free+0x30>
{
 7fe:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 800:	fed7fae3          	bgeu	a5,a3,7f4 <free+0x16>
 804:	6398                	ld	a4,0(a5)
 806:	00e6e463          	bltu	a3,a4,80e <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80a:	fee7eae3          	bltu	a5,a4,7fe <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 80e:	ff852583          	lw	a1,-8(a0)
 812:	6390                	ld	a2,0(a5)
 814:	02059813          	slli	a6,a1,0x20
 818:	01c85713          	srli	a4,a6,0x1c
 81c:	9736                	add	a4,a4,a3
 81e:	02e60563          	beq	a2,a4,848 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 826:	4790                	lw	a2,8(a5)
 828:	02061593          	slli	a1,a2,0x20
 82c:	01c5d713          	srli	a4,a1,0x1c
 830:	973e                	add	a4,a4,a5
 832:	02e68263          	beq	a3,a4,856 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 836:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
}
 840:	60a2                	ld	ra,8(sp)
 842:	6402                	ld	s0,0(sp)
 844:	0141                	addi	sp,sp,16
 846:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 848:	4618                	lw	a4,8(a2)
 84a:	9f2d                	addw	a4,a4,a1
 84c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 850:	6398                	ld	a4,0(a5)
 852:	6310                	ld	a2,0(a4)
 854:	b7f9                	j	822 <free+0x44>
    p->s.size += bp->s.size;
 856:	ff852703          	lw	a4,-8(a0)
 85a:	9f31                	addw	a4,a4,a2
 85c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 85e:	ff053683          	ld	a3,-16(a0)
 862:	bfd1                	j	836 <free+0x58>

0000000000000864 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 864:	7139                	addi	sp,sp,-64
 866:	fc06                	sd	ra,56(sp)
 868:	f822                	sd	s0,48(sp)
 86a:	f04a                	sd	s2,32(sp)
 86c:	ec4e                	sd	s3,24(sp)
 86e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 870:	02051993          	slli	s3,a0,0x20
 874:	0209d993          	srli	s3,s3,0x20
 878:	09bd                	addi	s3,s3,15
 87a:	0049d993          	srli	s3,s3,0x4
 87e:	2985                	addiw	s3,s3,1
 880:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 882:	00000517          	auipc	a0,0x0
 886:	77e53503          	ld	a0,1918(a0) # 1000 <freep>
 88a:	c905                	beqz	a0,8ba <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 88c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 88e:	4798                	lw	a4,8(a5)
 890:	09377663          	bgeu	a4,s3,91c <malloc+0xb8>
 894:	f426                	sd	s1,40(sp)
 896:	e852                	sd	s4,16(sp)
 898:	e456                	sd	s5,8(sp)
 89a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 89c:	8a4e                	mv	s4,s3
 89e:	6705                	lui	a4,0x1
 8a0:	00e9f363          	bgeu	s3,a4,8a6 <malloc+0x42>
 8a4:	6a05                	lui	s4,0x1
 8a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8ae:	00000497          	auipc	s1,0x0
 8b2:	75248493          	addi	s1,s1,1874 # 1000 <freep>
  if (p == SBRK_ERROR)
 8b6:	5afd                	li	s5,-1
 8b8:	a83d                	j	8f6 <malloc+0x92>
 8ba:	f426                	sd	s1,40(sp)
 8bc:	e852                	sd	s4,16(sp)
 8be:	e456                	sd	s5,8(sp)
 8c0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c2:	00000797          	auipc	a5,0x0
 8c6:	74e78793          	addi	a5,a5,1870 # 1010 <base>
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
 8d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8d8:	b7d1                	j	89c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	a899                	j	934 <malloc+0xd0>
  hp->s.size = nu;
 8e0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8e4:	0541                	addi	a0,a0,16
 8e6:	ef9ff0ef          	jal	7de <free>
  return freep;
 8ea:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8ec:	c125                	beqz	a0,94c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ee:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f0:	4798                	lw	a4,8(a5)
 8f2:	03277163          	bgeu	a4,s2,914 <malloc+0xb0>
    if (p == freep)
 8f6:	6098                	ld	a4,0(s1)
 8f8:	853e                	mv	a0,a5
 8fa:	fef71ae3          	bne	a4,a5,8ee <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8fe:	8552                	mv	a0,s4
 900:	a23ff0ef          	jal	322 <sbrk>
  if (p == SBRK_ERROR)
 904:	fd551ee3          	bne	a0,s5,8e0 <malloc+0x7c>
        return 0;
 908:	4501                	li	a0,0
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	a03d                	j	940 <malloc+0xdc>
 914:	74a2                	ld	s1,40(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 91c:	fae90fe3          	beq	s2,a4,8da <malloc+0x76>
        p->s.size -= nunits;
 920:	4137073b          	subw	a4,a4,s3
 924:	c798                	sw	a4,8(a5)
        p += p->s.size;
 926:	02071693          	slli	a3,a4,0x20
 92a:	01c6d713          	srli	a4,a3,0x1c
 92e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 930:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 934:	00000717          	auipc	a4,0x0
 938:	6ca73623          	sd	a0,1740(a4) # 1000 <freep>
      return (void *)(p + 1);
 93c:	01078513          	addi	a0,a5,16
  }
}
 940:	70e2                	ld	ra,56(sp)
 942:	7442                	ld	s0,48(sp)
 944:	7902                	ld	s2,32(sp)
 946:	69e2                	ld	s3,24(sp)
 948:	6121                	addi	sp,sp,64
 94a:	8082                	ret
 94c:	74a2                	ld	s1,40(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
 954:	b7f5                	j	940 <malloc+0xdc>
