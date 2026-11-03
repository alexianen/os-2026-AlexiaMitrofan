
user/_mystat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <typename>:
#include "kernel/stat.h"
#include "user/user.h"

char *
typename(int t)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  switch(t){
   8:	4709                	li	a4,2
   a:	02e50663          	beq	a0,a4,36 <typename+0x36>
   e:	87aa                	mv	a5,a0
  10:	470d                	li	a4,3
  case T_DIR:
    return "directory";
  case T_FILE:
    return "file";
  case T_DEVICE:
    return "device";
  12:	00001517          	auipc	a0,0x1
  16:	99650513          	addi	a0,a0,-1642 # 9a8 <malloc+0x110>
  switch(t){
  1a:	02e78263          	beq	a5,a4,3e <typename+0x3e>
  1e:	4705                	li	a4,1
    return "directory";
  20:	00001517          	auipc	a0,0x1
  24:	97050513          	addi	a0,a0,-1680 # 990 <malloc+0xf8>
  switch(t){
  28:	00e78b63          	beq	a5,a4,3e <typename+0x3e>
  default:
    return "?";
  2c:	00001517          	auipc	a0,0x1
  30:	98450513          	addi	a0,a0,-1660 # 9b0 <malloc+0x118>
  34:	a029                	j	3e <typename+0x3e>
  switch(t){
  36:	00001517          	auipc	a0,0x1
  3a:	96a50513          	addi	a0,a0,-1686 # 9a0 <malloc+0x108>
  }
}
  3e:	60a2                	ld	ra,8(sp)
  40:	6402                	ld	s0,0(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <main>:

int
main(int argc, char *argv[])
{
  46:	7159                	addi	sp,sp,-112
  48:	f486                	sd	ra,104(sp)
  4a:	f0a2                	sd	s0,96(sp)
  4c:	eca6                	sd	s1,88(sp)
  4e:	e8ca                	sd	s2,80(sp)
  50:	e4ce                	sd	s3,72(sp)
  52:	e0d2                	sd	s4,64(sp)
  54:	fc56                	sd	s5,56(sp)
  56:	f85a                	sd	s6,48(sp)
  58:	f45e                	sd	s7,40(sp)
  5a:	1880                	addi	s0,sp,112
  struct stat st;
  for(int i = 1; i < argc; i++){
  5c:	4785                	li	a5,1
  5e:	06a7d863          	bge	a5,a0,ce <main+0x88>
  62:	00858493          	addi	s1,a1,8
  66:	ffe5091b          	addiw	s2,a0,-2
  6a:	02091793          	slli	a5,s2,0x20
  6e:	01d7d913          	srli	s2,a5,0x1d
  72:	05c1                	addi	a1,a1,16
  74:	992e                	add	s2,s2,a1
    if(stat(argv[i], &st) < 0){
  76:	f9840a13          	addi	s4,s0,-104
      fprintf(2, "stat: cannot stat %s\n", argv[i]);
      continue;
    }
    printf("%s: %s, inode %d, links %d, size %d bytes\n",
  7a:	00001a97          	auipc	s5,0x1
  7e:	956a8a93          	addi	s5,s5,-1706 # 9d0 <malloc+0x138>
      fprintf(2, "stat: cannot stat %s\n", argv[i]);
  82:	00001b97          	auipc	s7,0x1
  86:	936b8b93          	addi	s7,s7,-1738 # 9b8 <malloc+0x120>
  8a:	4b09                	li	s6,2
  8c:	a809                	j	9e <main+0x58>
  8e:	6090                	ld	a2,0(s1)
  90:	85de                	mv	a1,s7
  92:	855a                	mv	a0,s6
  94:	722000ef          	jal	7b6 <fprintf>
  for(int i = 1; i < argc; i++){
  98:	04a1                	addi	s1,s1,8
  9a:	03248a63          	beq	s1,s2,ce <main+0x88>
    if(stat(argv[i], &st) < 0){
  9e:	85d2                	mv	a1,s4
  a0:	6088                	ld	a0,0(s1)
  a2:	182000ef          	jal	224 <stat>
  a6:	fe0544e3          	bltz	a0,8e <main+0x48>
    printf("%s: %s, inode %d, links %d, size %d bytes\n",
  aa:	0004b983          	ld	s3,0(s1)
  ae:	fa041503          	lh	a0,-96(s0)
  b2:	f4fff0ef          	jal	0 <typename>
  b6:	862a                	mv	a2,a0
  b8:	fa842783          	lw	a5,-88(s0)
  bc:	fa241703          	lh	a4,-94(s0)
  c0:	f9c42683          	lw	a3,-100(s0)
  c4:	85ce                	mv	a1,s3
  c6:	8556                	mv	a0,s5
  c8:	718000ef          	jal	7e0 <printf>
  cc:	b7f1                	j	98 <main+0x52>
           argv[i], typename(st.type), st.ino, st.nlink, (int)st.size);
  }
  exit(0);
  ce:	4501                	li	a0,0
  d0:	2ba000ef          	jal	38a <exit>

00000000000000d4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  dc:	f6bff0ef          	jal	46 <main>
  exit(r);
  e0:	2aa000ef          	jal	38a <exit>

00000000000000e4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  ec:	87aa                	mv	a5,a0
  ee:	0585                	addi	a1,a1,1
  f0:	0785                	addi	a5,a5,1
  f2:	fff5c703          	lbu	a4,-1(a1)
  f6:	fee78fa3          	sb	a4,-1(a5)
  fa:	fb75                	bnez	a4,ee <strcpy+0xa>
    ;
  return os;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x20>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x20>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf91                	beqz	a5,15c <strlen+0x28>
 142:	00150793          	addi	a5,a0,1
 146:	86be                	mv	a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	ff65                	bnez	a4,146 <strlen+0x12>
 150:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  for (n = 0; s[n]; n++)
 15c:	4501                	li	a0,0
 15e:	bfdd                	j	154 <strlen+0x20>

0000000000000160 <memset>:

void *
memset(void *dst, int c, uint n)
{
 160:	1141                	addi	sp,sp,-16
 162:	e406                	sd	ra,8(sp)
 164:	e022                	sd	s0,0(sp)
 166:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 168:	ca19                	beqz	a2,17e <memset+0x1e>
 16a:	87aa                	mv	a5,a0
 16c:	1602                	slli	a2,a2,0x20
 16e:	9201                	srli	a2,a2,0x20
 170:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 174:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 178:	0785                	addi	a5,a5,1
 17a:	fee79de3          	bne	a5,a4,174 <memset+0x14>
  }
  return dst;
}
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strchr>:

char *
strchr(const char *s, char c)
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cf81                	beqz	a5,1aa <strchr+0x24>
    if (*s == c)
 194:	00f58763          	beq	a1,a5,1a2 <strchr+0x1c>
  for (; *s; s++)
 198:	0505                	addi	a0,a0,1
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbfd                	bnez	a5,194 <strchr+0xe>
      return (char *)s;
  return 0;
 1a0:	4501                	li	a0,0
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret
  return 0;
 1aa:	4501                	li	a0,0
 1ac:	bfdd                	j	1a2 <strchr+0x1c>

00000000000001ae <gets>:

char *
gets(char *buf, int max)
{
 1ae:	711d                	addi	sp,sp,-96
 1b0:	ec86                	sd	ra,88(sp)
 1b2:	e8a2                	sd	s0,80(sp)
 1b4:	e4a6                	sd	s1,72(sp)
 1b6:	e0ca                	sd	s2,64(sp)
 1b8:	fc4e                	sd	s3,56(sp)
 1ba:	f852                	sd	s4,48(sp)
 1bc:	f456                	sd	s5,40(sp)
 1be:	f05a                	sd	s6,32(sp)
 1c0:	ec5e                	sd	s7,24(sp)
 1c2:	e862                	sd	s8,16(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ce:	faf40b13          	addi	s6,s0,-81
 1d2:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1d4:	8c26                	mv	s8,s1
 1d6:	0014899b          	addiw	s3,s1,1
 1da:	84ce                	mv	s1,s3
 1dc:	0349d463          	bge	s3,s4,204 <gets+0x56>
    cc = read(0, &c, 1);
 1e0:	8656                	mv	a2,s5
 1e2:	85da                	mv	a1,s6
 1e4:	4501                	li	a0,0
 1e6:	1bc000ef          	jal	3a2 <read>
    if (cc < 1)
 1ea:	00a05d63          	blez	a0,204 <gets+0x56>
      break;
    buf[i++] = c;
 1ee:	faf44783          	lbu	a5,-81(s0)
 1f2:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f6:	0905                	addi	s2,s2,1
 1f8:	ff678713          	addi	a4,a5,-10
 1fc:	c319                	beqz	a4,202 <gets+0x54>
 1fe:	17cd                	addi	a5,a5,-13
 200:	fbf1                	bnez	a5,1d4 <gets+0x26>
    buf[i++] = c;
 202:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 204:	9c5e                	add	s8,s8,s7
 206:	000c0023          	sb	zero,0(s8)
  return buf;
}
 20a:	855e                	mv	a0,s7
 20c:	60e6                	ld	ra,88(sp)
 20e:	6446                	ld	s0,80(sp)
 210:	64a6                	ld	s1,72(sp)
 212:	6906                	ld	s2,64(sp)
 214:	79e2                	ld	s3,56(sp)
 216:	7a42                	ld	s4,48(sp)
 218:	7aa2                	ld	s5,40(sp)
 21a:	7b02                	ld	s6,32(sp)
 21c:	6be2                	ld	s7,24(sp)
 21e:	6c42                	ld	s8,16(sp)
 220:	6125                	addi	sp,sp,96
 222:	8082                	ret

0000000000000224 <stat>:

int
stat(const char *n, struct stat *st)
{
 224:	1101                	addi	sp,sp,-32
 226:	ec06                	sd	ra,24(sp)
 228:	e822                	sd	s0,16(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	1000                	addi	s0,sp,32
 22e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 230:	4581                	li	a1,0
 232:	198000ef          	jal	3ca <open>
  if (fd < 0)
 236:	02054263          	bltz	a0,25a <stat+0x36>
 23a:	e426                	sd	s1,8(sp)
 23c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23e:	85ca                	mv	a1,s2
 240:	1a2000ef          	jal	3e2 <fstat>
 244:	892a                	mv	s2,a0
  close(fd);
 246:	8526                	mv	a0,s1
 248:	16a000ef          	jal	3b2 <close>
  return r;
 24c:	64a2                	ld	s1,8(sp)
}
 24e:	854a                	mv	a0,s2
 250:	60e2                	ld	ra,24(sp)
 252:	6442                	ld	s0,16(sp)
 254:	6902                	ld	s2,0(sp)
 256:	6105                	addi	sp,sp,32
 258:	8082                	ret
    return -1;
 25a:	57fd                	li	a5,-1
 25c:	893e                	mv	s2,a5
 25e:	bfc5                	j	24e <stat+0x2a>

0000000000000260 <atoi>:

int
atoi(const char *s)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 268:	00054683          	lbu	a3,0(a0)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	4625                	li	a2,9
 276:	02f66963          	bltu	a2,a5,2a8 <atoi+0x48>
 27a:	872a                	mv	a4,a0
  n = 0;
 27c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 27e:	0705                	addi	a4,a4,1
 280:	0025179b          	slliw	a5,a0,0x2
 284:	9fa9                	addw	a5,a5,a0
 286:	0017979b          	slliw	a5,a5,0x1
 28a:	9fb5                	addw	a5,a5,a3
 28c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 290:	00074683          	lbu	a3,0(a4)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	fef671e3          	bgeu	a2,a5,27e <atoi+0x1e>
  return n;
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  n = 0;
 2a8:	4501                	li	a0,0
 2aa:	bfdd                	j	2a0 <atoi+0x40>

00000000000002ac <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b4:	02b57563          	bgeu	a0,a1,2de <memmove+0x32>
    while (n-- > 0)
 2b8:	00c05f63          	blez	a2,2d6 <memmove+0x2a>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c6:	0585                	addi	a1,a1,1
 2c8:	0705                	addi	a4,a4,1
 2ca:	fff5c683          	lbu	a3,-1(a1)
 2ce:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
    while (n-- > 0)
 2de:	fec05ce3          	blez	a2,2d6 <memmove+0x2a>
    dst += n;
 2e2:	00c50733          	add	a4,a0,a2
    src += n;
 2e6:	95b2                	add	a1,a1,a2
 2e8:	fff6079b          	addiw	a5,a2,-1
 2ec:	1782                	slli	a5,a5,0x20
 2ee:	9381                	srli	a5,a5,0x20
 2f0:	fff7c793          	not	a5,a5
 2f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f6:	15fd                	addi	a1,a1,-1
 2f8:	177d                	addi	a4,a4,-1
 2fa:	0005c683          	lbu	a3,0(a1)
 2fe:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 302:	fef71ae3          	bne	a4,a5,2f6 <memmove+0x4a>
 306:	bfc1                	j	2d6 <memmove+0x2a>

0000000000000308 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 310:	c61d                	beqz	a2,33e <memcmp+0x36>
 312:	1602                	slli	a2,a2,0x20
 314:	9201                	srli	a2,a2,0x20
 316:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00e79863          	bne	a5,a4,332 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 326:	0505                	addi	a0,a0,1
    p2++;
 328:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32a:	fed518e3          	bne	a0,a3,31a <memcmp+0x12>
  }
  return 0;
 32e:	4501                	li	a0,0
 330:	a019                	j	336 <memcmp+0x2e>
      return *p1 - *p2;
 332:	40e7853b          	subw	a0,a5,a4
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <memcmp+0x2e>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	f63ff0ef          	jal	2ac <memmove>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <sbrk>:

char *
sbrk(int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35e:	4585                	li	a1,1
 360:	0b2000ef          	jal	412 <sys_sbrk>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <sbrklazy>:

char *
sbrklazy(int n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 374:	4589                	li	a1,2
 376:	09c000ef          	jal	412 <sys_sbrk>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 382:	4885                	li	a7,1
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exit>:
.global exit
exit:
 li a7, SYS_exit
 38a:	4889                	li	a7,2
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <wait>:
.global wait
wait:
 li a7, SYS_wait
 392:	488d                	li	a7,3
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39a:	4891                	li	a7,4
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <read>:
.global read
read:
 li a7, SYS_read
 3a2:	4895                	li	a7,5
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <write>:
.global write
write:
 li a7, SYS_write
 3aa:	48c1                	li	a7,16
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <close>:
.global close
close:
 li a7, SYS_close
 3b2:	48d5                	li	a7,21
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <open>:
.global open
open:
 li a7, SYS_open
 3ca:	48bd                	li	a7,15
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d2:	48c5                	li	a7,17
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3da:	48c9                	li	a7,18
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e2:	48a1                	li	a7,8
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <link>:
.global link
link:
 li a7, SYS_link
 3ea:	48cd                	li	a7,19
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f2:	48d1                	li	a7,20
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fa:	48a5                	li	a7,9
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <dup>:
.global dup
dup:
 li a7, SYS_dup
 402:	48a9                	li	a7,10
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40a:	48ad                	li	a7,11
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 412:	48b1                	li	a7,12
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <pause>:
.global pause
pause:
 li a7, SYS_pause
 41a:	48b5                	li	a7,13
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 422:	48b9                	li	a7,14
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sync>:
.global sync
sync:
 li a7, SYS_sync
 42a:	48d9                	li	a7,22
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <trace>:
.global trace
trace:
 li a7, SYS_trace
 432:	48dd                	li	a7,23
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	f5fff0ef          	jal	3aa <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	addi	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 458:	715d                	addi	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	f84a                	sd	s2,48(sp)
 460:	f44e                	sd	s3,40(sp)
 462:	0880                	addi	s0,sp,80
 464:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 466:	c6d1                	beqz	a3,4f2 <printint+0x9a>
 468:	0805d563          	bgez	a1,4f2 <printint+0x9a>
    neg = 1;
    x = -xx;
 46c:	40b005b3          	neg	a1,a1
    neg = 1;
 470:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 472:	fb840993          	addi	s3,s0,-72
  neg = 0;
 476:	86ce                	mv	a3,s3
  i = 0;
 478:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 47a:	00000817          	auipc	a6,0x0
 47e:	58e80813          	addi	a6,a6,1422 # a08 <digits>
 482:	88ba                	mv	a7,a4
 484:	0017051b          	addiw	a0,a4,1
 488:	872a                	mv	a4,a0
 48a:	02c5f7b3          	remu	a5,a1,a2
 48e:	97c2                	add	a5,a5,a6
 490:	0007c783          	lbu	a5,0(a5)
 494:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 498:	87ae                	mv	a5,a1
 49a:	02c5d5b3          	divu	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fec7f1e3          	bgeu	a5,a2,482 <printint+0x2a>
  if (neg)
 4a4:	00030c63          	beqz	t1,4bc <printint+0x64>
    buf[i++] = '-';
 4a8:	fd050793          	addi	a5,a0,-48
 4ac:	00878533          	add	a0,a5,s0
 4b0:	02d00793          	li	a5,45
 4b4:	fef50423          	sb	a5,-24(a0)
 4b8:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4bc:	02e05563          	blez	a4,4e6 <printint+0x8e>
 4c0:	fc26                	sd	s1,56(sp)
 4c2:	377d                	addiw	a4,a4,-1
 4c4:	00e984b3          	add	s1,s3,a4
 4c8:	19fd                	addi	s3,s3,-1
 4ca:	99ba                	add	s3,s3,a4
 4cc:	1702                	slli	a4,a4,0x20
 4ce:	9301                	srli	a4,a4,0x20
 4d0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d4:	0004c583          	lbu	a1,0(s1)
 4d8:	854a                	mv	a0,s2
 4da:	f61ff0ef          	jal	43a <putc>
  while (--i >= 0)
 4de:	14fd                	addi	s1,s1,-1
 4e0:	ff349ae3          	bne	s1,s3,4d4 <printint+0x7c>
 4e4:	74e2                	ld	s1,56(sp)
}
 4e6:	60a6                	ld	ra,72(sp)
 4e8:	6406                	ld	s0,64(sp)
 4ea:	7942                	ld	s2,48(sp)
 4ec:	79a2                	ld	s3,40(sp)
 4ee:	6161                	addi	sp,sp,80
 4f0:	8082                	ret
  neg = 0;
 4f2:	4301                	li	t1,0
 4f4:	bfbd                	j	472 <printint+0x1a>

00000000000004f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f6:	711d                	addi	sp,sp,-96
 4f8:	ec86                	sd	ra,88(sp)
 4fa:	e8a2                	sd	s0,80(sp)
 4fc:	e4a6                	sd	s1,72(sp)
 4fe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 500:	0005c483          	lbu	s1,0(a1)
 504:	22048363          	beqz	s1,72a <vprintf+0x234>
 508:	e0ca                	sd	s2,64(sp)
 50a:	fc4e                	sd	s3,56(sp)
 50c:	f852                	sd	s4,48(sp)
 50e:	f456                	sd	s5,40(sp)
 510:	f05a                	sd	s6,32(sp)
 512:	ec5e                	sd	s7,24(sp)
 514:	e862                	sd	s8,16(sp)
 516:	8b2a                	mv	s6,a0
 518:	8a2e                	mv	s4,a1
 51a:	8bb2                	mv	s7,a2
  state = 0;
 51c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 51e:	4901                	li	s2,0
 520:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 522:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 526:	06400c13          	li	s8,100
 52a:	a00d                	j	54c <vprintf+0x56>
        putc(fd, c0);
 52c:	85a6                	mv	a1,s1
 52e:	855a                	mv	a0,s6
 530:	f0bff0ef          	jal	43a <putc>
 534:	a019                	j	53a <vprintf+0x44>
    } else if (state == '%') {
 536:	03598363          	beq	s3,s5,55c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 53a:	0019079b          	addiw	a5,s2,1
 53e:	893e                	mv	s2,a5
 540:	873e                	mv	a4,a5
 542:	97d2                	add	a5,a5,s4
 544:	0007c483          	lbu	s1,0(a5)
 548:	1c048a63          	beqz	s1,71c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 54c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 550:	fe0993e3          	bnez	s3,536 <vprintf+0x40>
      if (c0 == '%') {
 554:	fd579ce3          	bne	a5,s5,52c <vprintf+0x36>
        state = '%';
 558:	89be                	mv	s3,a5
 55a:	b7c5                	j	53a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 55c:	00ea06b3          	add	a3,s4,a4
 560:	0016c603          	lbu	a2,1(a3)
      if (c1)
 564:	1c060863          	beqz	a2,734 <vprintf+0x23e>
      if (c0 == 'd') {
 568:	03878763          	beq	a5,s8,596 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 56c:	f9478693          	addi	a3,a5,-108
 570:	0016b693          	seqz	a3,a3
 574:	f9c60593          	addi	a1,a2,-100
 578:	e99d                	bnez	a1,5ae <vprintf+0xb8>
 57a:	ca95                	beqz	a3,5ae <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	008b8493          	addi	s1,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	ecfff0ef          	jal	458 <printint>
        i += 1;
 58e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 590:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 592:	4981                	li	s3,0
 594:	b75d                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b8493          	addi	s1,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	eb5ff0ef          	jal	458 <printint>
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b779                	j	53a <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 5ae:	9752                	add	a4,a4,s4
 5b0:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5b4:	f9460713          	addi	a4,a2,-108
 5b8:	00173713          	seqz	a4,a4
 5bc:	8f75                	and	a4,a4,a3
 5be:	f9c58513          	addi	a0,a1,-100
 5c2:	18051363          	bnez	a0,748 <vprintf+0x252>
 5c6:	18070163          	beqz	a4,748 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	008b8493          	addi	s1,s7,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e81ff0ef          	jal	458 <printint>
        i += 2;
 5dc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	8ba6                	mv	s7,s1
      state = 0;
 5e0:	4981                	li	s3,0
        i += 2;
 5e2:	bfa1                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000be583          	lwu	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e67ff0ef          	jal	458 <printint>
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b781                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000bb583          	ld	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e4fff0ef          	jal	458 <printint>
        i += 1;
 60e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	b71d                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e35ff0ef          	jal	458 <printint>
        i += 2;
 628:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	b731                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000be583          	lwu	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e1bff0ef          	jal	458 <printint>
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	bdd5                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e03ff0ef          	jal	458 <printint>
        i += 1;
 65a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	bde9                	j	53a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	de9ff0ef          	jal	458 <printint>
        i += 2;
 674:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	b5c1                	j	53a <vprintf+0x44>
 67c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 67e:	008b8793          	addi	a5,s7,8
 682:	8cbe                	mv	s9,a5
 684:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 688:	03000593          	li	a1,48
 68c:	855a                	mv	a0,s6
 68e:	dadff0ef          	jal	43a <putc>
  putc(fd, 'x');
 692:	07800593          	li	a1,120
 696:	855a                	mv	a0,s6
 698:	da3ff0ef          	jal	43a <putc>
 69c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69e:	00000b97          	auipc	s7,0x0
 6a2:	36ab8b93          	addi	s7,s7,874 # a08 <digits>
 6a6:	03c9d793          	srli	a5,s3,0x3c
 6aa:	97de                	add	a5,a5,s7
 6ac:	0007c583          	lbu	a1,0(a5)
 6b0:	855a                	mv	a0,s6
 6b2:	d89ff0ef          	jal	43a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b6:	0992                	slli	s3,s3,0x4
 6b8:	34fd                	addiw	s1,s1,-1
 6ba:	f4f5                	bnez	s1,6a6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6bc:	8be6                	mv	s7,s9
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	6ca2                	ld	s9,8(sp)
 6c2:	bda5                	j	53a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	000bc583          	lbu	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d6dff0ef          	jal	43a <putc>
 6d2:	8ba6                	mv	s7,s1
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b595                	j	53a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d8:	008b8993          	addi	s3,s7,8
 6dc:	000bb483          	ld	s1,0(s7)
 6e0:	cc91                	beqz	s1,6fc <vprintf+0x206>
        for (; *s; s++)
 6e2:	0004c583          	lbu	a1,0(s1)
 6e6:	c985                	beqz	a1,716 <vprintf+0x220>
          putc(fd, *s);
 6e8:	855a                	mv	a0,s6
 6ea:	d51ff0ef          	jal	43a <putc>
        for (; *s; s++)
 6ee:	0485                	addi	s1,s1,1
 6f0:	0004c583          	lbu	a1,0(s1)
 6f4:	f9f5                	bnez	a1,6e8 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6f6:	8bce                	mv	s7,s3
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b581                	j	53a <vprintf+0x44>
          s = "(null)";
 6fc:	00000497          	auipc	s1,0x0
 700:	30448493          	addi	s1,s1,772 # a00 <malloc+0x168>
        for (; *s; s++)
 704:	02800593          	li	a1,40
 708:	b7c5                	j	6e8 <vprintf+0x1f2>
        putc(fd, '%');
 70a:	85be                	mv	a1,a5
 70c:	855a                	mv	a0,s6
 70e:	d2dff0ef          	jal	43a <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	b51d                	j	53a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	b505                	j	53a <vprintf+0x44>
 71c:	6906                	ld	s2,64(sp)
 71e:	79e2                	ld	s3,56(sp)
 720:	7a42                	ld	s4,48(sp)
 722:	7aa2                	ld	s5,40(sp)
 724:	7b02                	ld	s6,32(sp)
 726:	6be2                	ld	s7,24(sp)
 728:	6c42                	ld	s8,16(sp)
    }
  }
}
 72a:	60e6                	ld	ra,88(sp)
 72c:	6446                	ld	s0,80(sp)
 72e:	64a6                	ld	s1,72(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret
      if (c0 == 'd') {
 734:	06400713          	li	a4,100
 738:	e4e78fe3          	beq	a5,a4,596 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 73c:	f9478693          	addi	a3,a5,-108
 740:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 744:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 746:	4701                	li	a4,0
      } else if (c0 == 'u') {
 748:	07500513          	li	a0,117
 74c:	e8a78ce3          	beq	a5,a0,5e4 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 750:	f8b60513          	addi	a0,a2,-117
 754:	e119                	bnez	a0,75a <vprintf+0x264>
 756:	ea0693e3          	bnez	a3,5fc <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 75a:	f8b58513          	addi	a0,a1,-117
 75e:	e119                	bnez	a0,764 <vprintf+0x26e>
 760:	ea071be3          	bnez	a4,616 <vprintf+0x120>
      } else if (c0 == 'x') {
 764:	07800513          	li	a0,120
 768:	eca784e3          	beq	a5,a0,630 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 76c:	f8860613          	addi	a2,a2,-120
 770:	e219                	bnez	a2,776 <vprintf+0x280>
 772:	ec069be3          	bnez	a3,648 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 776:	f8858593          	addi	a1,a1,-120
 77a:	e199                	bnez	a1,780 <vprintf+0x28a>
 77c:	ee0713e3          	bnez	a4,662 <vprintf+0x16c>
      } else if (c0 == 'p') {
 780:	07000713          	li	a4,112
 784:	eee78ce3          	beq	a5,a4,67c <vprintf+0x186>
      } else if (c0 == 'c') {
 788:	06300713          	li	a4,99
 78c:	f2e78ce3          	beq	a5,a4,6c4 <vprintf+0x1ce>
      } else if (c0 == 's') {
 790:	07300713          	li	a4,115
 794:	f4e782e3          	beq	a5,a4,6d8 <vprintf+0x1e2>
      } else if (c0 == '%') {
 798:	02500713          	li	a4,37
 79c:	f6e787e3          	beq	a5,a4,70a <vprintf+0x214>
        putc(fd, '%');
 7a0:	02500593          	li	a1,37
 7a4:	855a                	mv	a0,s6
 7a6:	c95ff0ef          	jal	43a <putc>
        putc(fd, c0);
 7aa:	85a6                	mv	a1,s1
 7ac:	855a                	mv	a0,s6
 7ae:	c8dff0ef          	jal	43a <putc>
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b359                	j	53a <vprintf+0x44>

00000000000007b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b6:	715d                	addi	sp,sp,-80
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e010                	sd	a2,0(s0)
 7c0:	e414                	sd	a3,8(s0)
 7c2:	e818                	sd	a4,16(s0)
 7c4:	ec1c                	sd	a5,24(s0)
 7c6:	03043023          	sd	a6,32(s0)
 7ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	8622                	mv	a2,s0
 7d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d4:	d23ff0ef          	jal	4f6 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6161                	addi	sp,sp,80
 7de:	8082                	ret

00000000000007e0 <printf>:

void
printf(const char *fmt, ...)
{
 7e0:	711d                	addi	sp,sp,-96
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e40c                	sd	a1,8(s0)
 7ea:	e810                	sd	a2,16(s0)
 7ec:	ec14                	sd	a3,24(s0)
 7ee:	f018                	sd	a4,32(s0)
 7f0:	f41c                	sd	a5,40(s0)
 7f2:	03043823          	sd	a6,48(s0)
 7f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	00840613          	addi	a2,s0,8
 7fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 802:	85aa                	mv	a1,a0
 804:	4505                	li	a0,1
 806:	cf1ff0ef          	jal	4f6 <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6125                	addi	sp,sp,96
 810:	8082                	ret

0000000000000812 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 812:	1141                	addi	sp,sp,-16
 814:	e406                	sd	ra,8(sp)
 816:	e022                	sd	s0,0(sp)
 818:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 81a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	00000797          	auipc	a5,0x0
 822:	7e27b783          	ld	a5,2018(a5) # 1000 <freep>
 826:	a039                	j	834 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	6398                	ld	a4,0(a5)
 82a:	00e7e463          	bltu	a5,a4,832 <free+0x20>
 82e:	00e6ea63          	bltu	a3,a4,842 <free+0x30>
{
 832:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	fed7fae3          	bgeu	a5,a3,828 <free+0x16>
 838:	6398                	ld	a4,0(a5)
 83a:	00e6e463          	bltu	a3,a4,842 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	fee7eae3          	bltu	a5,a4,832 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85713          	srli	a4,a6,0x1c
 850:	9736                	add	a4,a4,a3
 852:	02e60563          	beq	a2,a4,87c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d713          	srli	a4,a1,0x1c
 864:	973e                	add	a4,a4,a5
 866:	02e68263          	beq	a3,a4,88a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 86a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
}
 874:	60a2                	ld	ra,8(sp)
 876:	6402                	ld	s0,0(sp)
 878:	0141                	addi	sp,sp,16
 87a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 87c:	4618                	lw	a4,8(a2)
 87e:	9f2d                	addw	a4,a4,a1
 880:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	6310                	ld	a2,0(a4)
 888:	b7f9                	j	856 <free+0x44>
    p->s.size += bp->s.size;
 88a:	ff852703          	lw	a4,-8(a0)
 88e:	9f31                	addw	a4,a4,a2
 890:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 892:	ff053683          	ld	a3,-16(a0)
 896:	bfd1                	j	86a <free+0x58>

0000000000000898 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 898:	7139                	addi	sp,sp,-64
 89a:	fc06                	sd	ra,56(sp)
 89c:	f822                	sd	s0,48(sp)
 89e:	f04a                	sd	s2,32(sp)
 8a0:	ec4e                	sd	s3,24(sp)
 8a2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8a4:	02051993          	slli	s3,a0,0x20
 8a8:	0209d993          	srli	s3,s3,0x20
 8ac:	09bd                	addi	s3,s3,15
 8ae:	0049d993          	srli	s3,s3,0x4
 8b2:	2985                	addiw	s3,s3,1
 8b4:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8b6:	00000517          	auipc	a0,0x0
 8ba:	74a53503          	ld	a0,1866(a0) # 1000 <freep>
 8be:	c905                	beqz	a0,8ee <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c2:	4798                	lw	a4,8(a5)
 8c4:	09377663          	bgeu	a4,s3,950 <malloc+0xb8>
 8c8:	f426                	sd	s1,40(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8d0:	8a4e                	mv	s4,s3
 8d2:	6705                	lui	a4,0x1
 8d4:	00e9f363          	bgeu	s3,a4,8da <malloc+0x42>
 8d8:	6a05                	lui	s4,0x1
 8da:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8de:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8e2:	00000497          	auipc	s1,0x0
 8e6:	71e48493          	addi	s1,s1,1822 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ea:	5afd                	li	s5,-1
 8ec:	a83d                	j	92a <malloc+0x92>
 8ee:	f426                	sd	s1,40(sp)
 8f0:	e852                	sd	s4,16(sp)
 8f2:	e456                	sd	s5,8(sp)
 8f4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f6:	00000797          	auipc	a5,0x0
 8fa:	71a78793          	addi	a5,a5,1818 # 1010 <base>
 8fe:	00000717          	auipc	a4,0x0
 902:	70f73123          	sd	a5,1794(a4) # 1000 <freep>
 906:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 908:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 90c:	b7d1                	j	8d0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 90e:	6398                	ld	a4,0(a5)
 910:	e118                	sd	a4,0(a0)
 912:	a899                	j	968 <malloc+0xd0>
  hp->s.size = nu;
 914:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 918:	0541                	addi	a0,a0,16
 91a:	ef9ff0ef          	jal	812 <free>
  return freep;
 91e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 920:	c125                	beqz	a0,980 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 922:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 924:	4798                	lw	a4,8(a5)
 926:	03277163          	bgeu	a4,s2,948 <malloc+0xb0>
    if (p == freep)
 92a:	6098                	ld	a4,0(s1)
 92c:	853e                	mv	a0,a5
 92e:	fef71ae3          	bne	a4,a5,922 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 932:	8552                	mv	a0,s4
 934:	a23ff0ef          	jal	356 <sbrk>
  if (p == SBRK_ERROR)
 938:	fd551ee3          	bne	a0,s5,914 <malloc+0x7c>
        return 0;
 93c:	4501                	li	a0,0
 93e:	74a2                	ld	s1,40(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	a03d                	j	974 <malloc+0xdc>
 948:	74a2                	ld	s1,40(sp)
 94a:	6a42                	ld	s4,16(sp)
 94c:	6aa2                	ld	s5,8(sp)
 94e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 950:	fae90fe3          	beq	s2,a4,90e <malloc+0x76>
        p->s.size -= nunits;
 954:	4137073b          	subw	a4,a4,s3
 958:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95a:	02071693          	slli	a3,a4,0x20
 95e:	01c6d713          	srli	a4,a3,0x1c
 962:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 964:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 968:	00000717          	auipc	a4,0x0
 96c:	68a73c23          	sd	a0,1688(a4) # 1000 <freep>
      return (void *)(p + 1);
 970:	01078513          	addi	a0,a5,16
  }
}
 974:	70e2                	ld	ra,56(sp)
 976:	7442                	ld	s0,48(sp)
 978:	7902                	ld	s2,32(sp)
 97a:	69e2                	ld	s3,24(sp)
 97c:	6121                	addi	sp,sp,64
 97e:	8082                	ret
 980:	74a2                	ld	s1,40(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
 988:	b7f5                	j	974 <malloc+0xdc>
