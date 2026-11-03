
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"      
#include "user/user.h"

void
find(char *path, char *name)
{
   0:	da010113          	addi	sp,sp,-608
   4:	24113c23          	sd	ra,600(sp)
   8:	24813823          	sd	s0,592(sp)
   c:	25213023          	sd	s2,576(sp)
  10:	23313c23          	sd	s3,568(sp)
  14:	1480                	addi	s0,sp,608
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  1a:	4581                	li	a1,0
  1c:	4a8000ef          	jal	4c4 <open>
  20:	04054063          	bltz	a0,60 <find+0x60>
  24:	24913423          	sd	s1,584(sp)
  28:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }
  if(fstat(fd, &st) < 0){
  2a:	da840593          	addi	a1,s0,-600
  2e:	4ae000ef          	jal	4dc <fstat>
  32:	04054063          	bltz	a0,72 <find+0x72>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }
  if(st.type != T_DIR){        // a plain file has nothing to search inside
  36:	db041703          	lh	a4,-592(s0)
  3a:	4785                	li	a5,1
  3c:	04f70963          	beq	a4,a5,8e <find+0x8e>
    close(fd);
  40:	8526                	mv	a0,s1
  42:	46a000ef          	jal	4ac <close>
    return;
  46:	24813483          	ld	s1,584(sp)
    }
    if(st.type == T_DIR)
      find(buf, name);         // recurse
  }
  close(fd);
}
  4a:	25813083          	ld	ra,600(sp)
  4e:	25013403          	ld	s0,592(sp)
  52:	24013903          	ld	s2,576(sp)
  56:	23813983          	ld	s3,568(sp)
  5a:	26010113          	addi	sp,sp,608
  5e:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  60:	864a                	mv	a2,s2
  62:	00001597          	auipc	a1,0x1
  66:	a2e58593          	addi	a1,a1,-1490 # a90 <malloc+0xfe>
  6a:	4509                	li	a0,2
  6c:	045000ef          	jal	8b0 <fprintf>
    return;
  70:	bfe9                	j	4a <find+0x4a>
    fprintf(2, "find: cannot stat %s\n", path);
  72:	864a                	mv	a2,s2
  74:	00001597          	auipc	a1,0x1
  78:	a3c58593          	addi	a1,a1,-1476 # ab0 <malloc+0x11e>
  7c:	4509                	li	a0,2
  7e:	033000ef          	jal	8b0 <fprintf>
    close(fd);
  82:	8526                	mv	a0,s1
  84:	428000ef          	jal	4ac <close>
    return;
  88:	24813483          	ld	s1,584(sp)
  8c:	bf7d                	j	4a <find+0x4a>
  if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
  8e:	854a                	mv	a0,s2
  90:	19e000ef          	jal	22e <strlen>
  94:	2541                	addiw	a0,a0,16
  96:	20000793          	li	a5,512
  9a:	0aa7e963          	bltu	a5,a0,14c <find+0x14c>
  9e:	23413823          	sd	s4,560(sp)
  strcpy(buf, path);
  a2:	85ca                	mv	a1,s2
  a4:	dd040513          	addi	a0,s0,-560
  a8:	136000ef          	jal	1de <strcpy>
  p = buf + strlen(buf);
  ac:	dd040513          	addi	a0,s0,-560
  b0:	17e000ef          	jal	22e <strlen>
  b4:	1502                	slli	a0,a0,0x20
  b6:	9101                	srli	a0,a0,0x20
  b8:	dd040793          	addi	a5,s0,-560
  bc:	00a78733          	add	a4,a5,a0
  c0:	8a3a                	mv	s4,a4
  *p++ = '/';                  // buf is now "path/", p points just after the slash
  c2:	00170793          	addi	a5,a4,1
  c6:	893e                	mv	s2,a5
  c8:	02f00793          	li	a5,47
  cc:	00f70023          	sb	a5,0(a4)
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
  d0:	4641                	li	a2,16
  d2:	dc040593          	addi	a1,s0,-576
  d6:	8526                	mv	a0,s1
  d8:	3c4000ef          	jal	49c <read>
  dc:	47c1                	li	a5,16
  de:	0af51763          	bne	a0,a5,18c <find+0x18c>
    if(de.inum == 0)
  e2:	dc045783          	lhu	a5,-576(s0)
  e6:	d7ed                	beqz	a5,d0 <find+0xd0>
    if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  e8:	00001597          	auipc	a1,0x1
  ec:	9f858593          	addi	a1,a1,-1544 # ae0 <malloc+0x14e>
  f0:	dc240513          	addi	a0,s0,-574
  f4:	10a000ef          	jal	1fe <strcmp>
  f8:	dd61                	beqz	a0,d0 <find+0xd0>
  fa:	00001597          	auipc	a1,0x1
  fe:	9ee58593          	addi	a1,a1,-1554 # ae8 <malloc+0x156>
 102:	dc240513          	addi	a0,s0,-574
 106:	0f8000ef          	jal	1fe <strcmp>
 10a:	d179                	beqz	a0,d0 <find+0xd0>
    memmove(p, de.name, DIRSIZ);
 10c:	4639                	li	a2,14
 10e:	dc240593          	addi	a1,s0,-574
 112:	854a                	mv	a0,s2
 114:	292000ef          	jal	3a6 <memmove>
    p[DIRSIZ] = 0;             // buf is now the full path, properly terminated
 118:	000a07a3          	sb	zero,15(s4)
    if(strcmp(p, name) == 0)   // last component matches
 11c:	85ce                	mv	a1,s3
 11e:	854a                	mv	a0,s2
 120:	0de000ef          	jal	1fe <strcmp>
 124:	c129                	beqz	a0,166 <find+0x166>
    if(stat(buf, &st) < 0){
 126:	da840593          	addi	a1,s0,-600
 12a:	dd040513          	addi	a0,s0,-560
 12e:	1f0000ef          	jal	31e <stat>
 132:	04054363          	bltz	a0,178 <find+0x178>
    if(st.type == T_DIR)
 136:	db041703          	lh	a4,-592(s0)
 13a:	4785                	li	a5,1
 13c:	f8f71ae3          	bne	a4,a5,d0 <find+0xd0>
      find(buf, name);         // recurse
 140:	85ce                	mv	a1,s3
 142:	dd040513          	addi	a0,s0,-560
 146:	ebbff0ef          	jal	0 <find>
 14a:	b759                	j	d0 <find+0xd0>
    fprintf(2, "find: path too long\n");
 14c:	00001597          	auipc	a1,0x1
 150:	97c58593          	addi	a1,a1,-1668 # ac8 <malloc+0x136>
 154:	4509                	li	a0,2
 156:	75a000ef          	jal	8b0 <fprintf>
    close(fd);
 15a:	8526                	mv	a0,s1
 15c:	350000ef          	jal	4ac <close>
    return;
 160:	24813483          	ld	s1,584(sp)
 164:	b5dd                	j	4a <find+0x4a>
      printf("%s\n", buf);
 166:	dd040593          	addi	a1,s0,-560
 16a:	00001517          	auipc	a0,0x1
 16e:	98650513          	addi	a0,a0,-1658 # af0 <malloc+0x15e>
 172:	768000ef          	jal	8da <printf>
 176:	bf45                	j	126 <find+0x126>
      fprintf(2, "find: cannot stat %s\n", buf);
 178:	dd040613          	addi	a2,s0,-560
 17c:	00001597          	auipc	a1,0x1
 180:	93458593          	addi	a1,a1,-1740 # ab0 <malloc+0x11e>
 184:	4509                	li	a0,2
 186:	72a000ef          	jal	8b0 <fprintf>
      continue;
 18a:	b799                	j	d0 <find+0xd0>
  close(fd);
 18c:	8526                	mv	a0,s1
 18e:	31e000ef          	jal	4ac <close>
 192:	24813483          	ld	s1,584(sp)
 196:	23013a03          	ld	s4,560(sp)
 19a:	bd45                	j	4a <find+0x4a>

000000000000019c <main>:

int
main(int argc, char *argv[])
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  if(argc != 3){
 1a4:	470d                	li	a4,3
 1a6:	00e50c63          	beq	a0,a4,1be <main+0x22>
    fprintf(2, "usage: find <dir> <name>\n");
 1aa:	00001597          	auipc	a1,0x1
 1ae:	94e58593          	addi	a1,a1,-1714 # af8 <malloc+0x166>
 1b2:	4509                	li	a0,2
 1b4:	6fc000ef          	jal	8b0 <fprintf>
    exit(1);
 1b8:	4505                	li	a0,1
 1ba:	2ca000ef          	jal	484 <exit>
 1be:	87ae                	mv	a5,a1
  }
  find(argv[1], argv[2]);
 1c0:	698c                	ld	a1,16(a1)
 1c2:	6788                	ld	a0,8(a5)
 1c4:	e3dff0ef          	jal	0 <find>
  exit(0);
 1c8:	4501                	li	a0,0
 1ca:	2ba000ef          	jal	484 <exit>

00000000000001ce <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1d6:	fc7ff0ef          	jal	19c <main>
  exit(r);
 1da:	2aa000ef          	jal	484 <exit>

00000000000001de <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 1e6:	87aa                	mv	a5,a0
 1e8:	0585                	addi	a1,a1,1
 1ea:	0785                	addi	a5,a5,1
 1ec:	fff5c703          	lbu	a4,-1(a1)
 1f0:	fee78fa3          	sb	a4,-1(a5)
 1f4:	fb75                	bnez	a4,1e8 <strcpy+0xa>
    ;
  return os;
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e406                	sd	ra,8(sp)
 202:	e022                	sd	s0,0(sp)
 204:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cb91                	beqz	a5,21e <strcmp+0x20>
 20c:	0005c703          	lbu	a4,0(a1)
 210:	00f71763          	bne	a4,a5,21e <strcmp+0x20>
    p++, q++;
 214:	0505                	addi	a0,a0,1
 216:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	fbe5                	bnez	a5,20c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 21e:	0005c503          	lbu	a0,0(a1)
}
 222:	40a7853b          	subw	a0,a5,a0
 226:	60a2                	ld	ra,8(sp)
 228:	6402                	ld	s0,0(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strlen>:

uint
strlen(const char *s)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 236:	00054783          	lbu	a5,0(a0)
 23a:	cf91                	beqz	a5,256 <strlen+0x28>
 23c:	00150793          	addi	a5,a0,1
 240:	86be                	mv	a3,a5
 242:	0785                	addi	a5,a5,1
 244:	fff7c703          	lbu	a4,-1(a5)
 248:	ff65                	bnez	a4,240 <strlen+0x12>
 24a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
  for (n = 0; s[n]; n++)
 256:	4501                	li	a0,0
 258:	bfdd                	j	24e <strlen+0x20>

000000000000025a <memset>:

void *
memset(void *dst, int c, uint n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 262:	ca19                	beqz	a2,278 <memset+0x1e>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x14>
  }
  return dst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <strchr>:

char *
strchr(const char *s, char c)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  for (; *s; s++)
 288:	00054783          	lbu	a5,0(a0)
 28c:	cf81                	beqz	a5,2a4 <strchr+0x24>
    if (*s == c)
 28e:	00f58763          	beq	a1,a5,29c <strchr+0x1c>
  for (; *s; s++)
 292:	0505                	addi	a0,a0,1
 294:	00054783          	lbu	a5,0(a0)
 298:	fbfd                	bnez	a5,28e <strchr+0xe>
      return (char *)s;
  return 0;
 29a:	4501                	li	a0,0
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <strchr+0x1c>

00000000000002a8 <gets>:

char *
gets(char *buf, int max)
{
 2a8:	711d                	addi	sp,sp,-96
 2aa:	ec86                	sd	ra,88(sp)
 2ac:	e8a2                	sd	s0,80(sp)
 2ae:	e4a6                	sd	s1,72(sp)
 2b0:	e0ca                	sd	s2,64(sp)
 2b2:	fc4e                	sd	s3,56(sp)
 2b4:	f852                	sd	s4,48(sp)
 2b6:	f456                	sd	s5,40(sp)
 2b8:	f05a                	sd	s6,32(sp)
 2ba:	ec5e                	sd	s7,24(sp)
 2bc:	e862                	sd	s8,16(sp)
 2be:	1080                	addi	s0,sp,96
 2c0:	8baa                	mv	s7,a0
 2c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 2c4:	892a                	mv	s2,a0
 2c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2c8:	faf40b13          	addi	s6,s0,-81
 2cc:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 2ce:	8c26                	mv	s8,s1
 2d0:	0014899b          	addiw	s3,s1,1
 2d4:	84ce                	mv	s1,s3
 2d6:	0349d463          	bge	s3,s4,2fe <gets+0x56>
    cc = read(0, &c, 1);
 2da:	8656                	mv	a2,s5
 2dc:	85da                	mv	a1,s6
 2de:	4501                	li	a0,0
 2e0:	1bc000ef          	jal	49c <read>
    if (cc < 1)
 2e4:	00a05d63          	blez	a0,2fe <gets+0x56>
      break;
    buf[i++] = c;
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 2f0:	0905                	addi	s2,s2,1
 2f2:	ff678713          	addi	a4,a5,-10
 2f6:	c319                	beqz	a4,2fc <gets+0x54>
 2f8:	17cd                	addi	a5,a5,-13
 2fa:	fbf1                	bnez	a5,2ce <gets+0x26>
    buf[i++] = c;
 2fc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2fe:	9c5e                	add	s8,s8,s7
 300:	000c0023          	sb	zero,0(s8)
  return buf;
}
 304:	855e                	mv	a0,s7
 306:	60e6                	ld	ra,88(sp)
 308:	6446                	ld	s0,80(sp)
 30a:	64a6                	ld	s1,72(sp)
 30c:	6906                	ld	s2,64(sp)
 30e:	79e2                	ld	s3,56(sp)
 310:	7a42                	ld	s4,48(sp)
 312:	7aa2                	ld	s5,40(sp)
 314:	7b02                	ld	s6,32(sp)
 316:	6be2                	ld	s7,24(sp)
 318:	6c42                	ld	s8,16(sp)
 31a:	6125                	addi	sp,sp,96
 31c:	8082                	ret

000000000000031e <stat>:

int
stat(const char *n, struct stat *st)
{
 31e:	1101                	addi	sp,sp,-32
 320:	ec06                	sd	ra,24(sp)
 322:	e822                	sd	s0,16(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32a:	4581                	li	a1,0
 32c:	198000ef          	jal	4c4 <open>
  if (fd < 0)
 330:	02054263          	bltz	a0,354 <stat+0x36>
 334:	e426                	sd	s1,8(sp)
 336:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 338:	85ca                	mv	a1,s2
 33a:	1a2000ef          	jal	4dc <fstat>
 33e:	892a                	mv	s2,a0
  close(fd);
 340:	8526                	mv	a0,s1
 342:	16a000ef          	jal	4ac <close>
  return r;
 346:	64a2                	ld	s1,8(sp)
}
 348:	854a                	mv	a0,s2
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	6902                	ld	s2,0(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
    return -1;
 354:	57fd                	li	a5,-1
 356:	893e                	mv	s2,a5
 358:	bfc5                	j	348 <stat+0x2a>

000000000000035a <atoi>:

int
atoi(const char *s)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 362:	00054683          	lbu	a3,0(a0)
 366:	fd06879b          	addiw	a5,a3,-48
 36a:	0ff7f793          	zext.b	a5,a5
 36e:	4625                	li	a2,9
 370:	02f66963          	bltu	a2,a5,3a2 <atoi+0x48>
 374:	872a                	mv	a4,a0
  n = 0;
 376:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 378:	0705                	addi	a4,a4,1
 37a:	0025179b          	slliw	a5,a0,0x2
 37e:	9fa9                	addw	a5,a5,a0
 380:	0017979b          	slliw	a5,a5,0x1
 384:	9fb5                	addw	a5,a5,a3
 386:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 38a:	00074683          	lbu	a3,0(a4)
 38e:	fd06879b          	addiw	a5,a3,-48
 392:	0ff7f793          	zext.b	a5,a5
 396:	fef671e3          	bgeu	a2,a5,378 <atoi+0x1e>
  return n;
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  n = 0;
 3a2:	4501                	li	a0,0
 3a4:	bfdd                	j	39a <atoi+0x40>

00000000000003a6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ae:	02b57563          	bgeu	a0,a1,3d8 <memmove+0x32>
    while (n-- > 0)
 3b2:	00c05f63          	blez	a2,3d0 <memmove+0x2a>
 3b6:	1602                	slli	a2,a2,0x20
 3b8:	9201                	srli	a2,a2,0x20
 3ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3be:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c0:	0585                	addi	a1,a1,1
 3c2:	0705                	addi	a4,a4,1
 3c4:	fff5c683          	lbu	a3,-1(a1)
 3c8:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 3cc:	fee79ae3          	bne	a5,a4,3c0 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d0:	60a2                	ld	ra,8(sp)
 3d2:	6402                	ld	s0,0(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
    while (n-- > 0)
 3d8:	fec05ce3          	blez	a2,3d0 <memmove+0x2a>
    dst += n;
 3dc:	00c50733          	add	a4,a0,a2
    src += n;
 3e0:	95b2                	add	a1,a1,a2
 3e2:	fff6079b          	addiw	a5,a2,-1
 3e6:	1782                	slli	a5,a5,0x20
 3e8:	9381                	srli	a5,a5,0x20
 3ea:	fff7c793          	not	a5,a5
 3ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f0:	15fd                	addi	a1,a1,-1
 3f2:	177d                	addi	a4,a4,-1
 3f4:	0005c683          	lbu	a3,0(a1)
 3f8:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 3fc:	fef71ae3          	bne	a4,a5,3f0 <memmove+0x4a>
 400:	bfc1                	j	3d0 <memmove+0x2a>

0000000000000402 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40a:	c61d                	beqz	a2,438 <memcmp+0x36>
 40c:	1602                	slli	a2,a2,0x20
 40e:	9201                	srli	a2,a2,0x20
 410:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 414:	00054783          	lbu	a5,0(a0)
 418:	0005c703          	lbu	a4,0(a1)
 41c:	00e79863          	bne	a5,a4,42c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 420:	0505                	addi	a0,a0,1
    p2++;
 422:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 424:	fed518e3          	bne	a0,a3,414 <memcmp+0x12>
  }
  return 0;
 428:	4501                	li	a0,0
 42a:	a019                	j	430 <memcmp+0x2e>
      return *p1 - *p2;
 42c:	40e7853b          	subw	a0,a5,a4
}
 430:	60a2                	ld	ra,8(sp)
 432:	6402                	ld	s0,0(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
  return 0;
 438:	4501                	li	a0,0
 43a:	bfdd                	j	430 <memcmp+0x2e>

000000000000043c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e406                	sd	ra,8(sp)
 440:	e022                	sd	s0,0(sp)
 442:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 444:	f63ff0ef          	jal	3a6 <memmove>
}
 448:	60a2                	ld	ra,8(sp)
 44a:	6402                	ld	s0,0(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret

0000000000000450 <sbrk>:

char *
sbrk(int n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 458:	4585                	li	a1,1
 45a:	0b2000ef          	jal	50c <sys_sbrk>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <sbrklazy>:

char *
sbrklazy(int n)
{
 466:	1141                	addi	sp,sp,-16
 468:	e406                	sd	ra,8(sp)
 46a:	e022                	sd	s0,0(sp)
 46c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 46e:	4589                	li	a1,2
 470:	09c000ef          	jal	50c <sys_sbrk>
}
 474:	60a2                	ld	ra,8(sp)
 476:	6402                	ld	s0,0(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	4885                	li	a7,1
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exit>:
.global exit
exit:
 li a7, SYS_exit
 484:	4889                	li	a7,2
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <wait>:
.global wait
wait:
 li a7, SYS_wait
 48c:	488d                	li	a7,3
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 494:	4891                	li	a7,4
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <read>:
.global read
read:
 li a7, SYS_read
 49c:	4895                	li	a7,5
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <write>:
.global write
write:
 li a7, SYS_write
 4a4:	48c1                	li	a7,16
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <close>:
.global close
close:
 li a7, SYS_close
 4ac:	48d5                	li	a7,21
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b4:	4899                	li	a7,6
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4bc:	489d                	li	a7,7
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <open>:
.global open
open:
 li a7, SYS_open
 4c4:	48bd                	li	a7,15
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4cc:	48c5                	li	a7,17
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d4:	48c9                	li	a7,18
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4dc:	48a1                	li	a7,8
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <link>:
.global link
link:
 li a7, SYS_link
 4e4:	48cd                	li	a7,19
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ec:	48d1                	li	a7,20
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f4:	48a5                	li	a7,9
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fc:	48a9                	li	a7,10
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 504:	48ad                	li	a7,11
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 50c:	48b1                	li	a7,12
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <pause>:
.global pause
pause:
 li a7, SYS_pause
 514:	48b5                	li	a7,13
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51c:	48b9                	li	a7,14
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <sync>:
.global sync
sync:
 li a7, SYS_sync
 524:	48d9                	li	a7,22
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <trace>:
.global trace
trace:
 li a7, SYS_trace
 52c:	48dd                	li	a7,23
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 534:	1101                	addi	sp,sp,-32
 536:	ec06                	sd	ra,24(sp)
 538:	e822                	sd	s0,16(sp)
 53a:	1000                	addi	s0,sp,32
 53c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 540:	4605                	li	a2,1
 542:	fef40593          	addi	a1,s0,-17
 546:	f5fff0ef          	jal	4a4 <write>
}
 54a:	60e2                	ld	ra,24(sp)
 54c:	6442                	ld	s0,16(sp)
 54e:	6105                	addi	sp,sp,32
 550:	8082                	ret

0000000000000552 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 552:	715d                	addi	sp,sp,-80
 554:	e486                	sd	ra,72(sp)
 556:	e0a2                	sd	s0,64(sp)
 558:	f84a                	sd	s2,48(sp)
 55a:	f44e                	sd	s3,40(sp)
 55c:	0880                	addi	s0,sp,80
 55e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 560:	c6d1                	beqz	a3,5ec <printint+0x9a>
 562:	0805d563          	bgez	a1,5ec <printint+0x9a>
    neg = 1;
    x = -xx;
 566:	40b005b3          	neg	a1,a1
    neg = 1;
 56a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 56c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 570:	86ce                	mv	a3,s3
  i = 0;
 572:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 574:	00000817          	auipc	a6,0x0
 578:	5ac80813          	addi	a6,a6,1452 # b20 <digits>
 57c:	88ba                	mv	a7,a4
 57e:	0017051b          	addiw	a0,a4,1
 582:	872a                	mv	a4,a0
 584:	02c5f7b3          	remu	a5,a1,a2
 588:	97c2                	add	a5,a5,a6
 58a:	0007c783          	lbu	a5,0(a5)
 58e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 592:	87ae                	mv	a5,a1
 594:	02c5d5b3          	divu	a1,a1,a2
 598:	0685                	addi	a3,a3,1
 59a:	fec7f1e3          	bgeu	a5,a2,57c <printint+0x2a>
  if (neg)
 59e:	00030c63          	beqz	t1,5b6 <printint+0x64>
    buf[i++] = '-';
 5a2:	fd050793          	addi	a5,a0,-48
 5a6:	00878533          	add	a0,a5,s0
 5aa:	02d00793          	li	a5,45
 5ae:	fef50423          	sb	a5,-24(a0)
 5b2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 5b6:	02e05563          	blez	a4,5e0 <printint+0x8e>
 5ba:	fc26                	sd	s1,56(sp)
 5bc:	377d                	addiw	a4,a4,-1
 5be:	00e984b3          	add	s1,s3,a4
 5c2:	19fd                	addi	s3,s3,-1
 5c4:	99ba                	add	s3,s3,a4
 5c6:	1702                	slli	a4,a4,0x20
 5c8:	9301                	srli	a4,a4,0x20
 5ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ce:	0004c583          	lbu	a1,0(s1)
 5d2:	854a                	mv	a0,s2
 5d4:	f61ff0ef          	jal	534 <putc>
  while (--i >= 0)
 5d8:	14fd                	addi	s1,s1,-1
 5da:	ff349ae3          	bne	s1,s3,5ce <printint+0x7c>
 5de:	74e2                	ld	s1,56(sp)
}
 5e0:	60a6                	ld	ra,72(sp)
 5e2:	6406                	ld	s0,64(sp)
 5e4:	7942                	ld	s2,48(sp)
 5e6:	79a2                	ld	s3,40(sp)
 5e8:	6161                	addi	sp,sp,80
 5ea:	8082                	ret
  neg = 0;
 5ec:	4301                	li	t1,0
 5ee:	bfbd                	j	56c <printint+0x1a>

00000000000005f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5f0:	711d                	addi	sp,sp,-96
 5f2:	ec86                	sd	ra,88(sp)
 5f4:	e8a2                	sd	s0,80(sp)
 5f6:	e4a6                	sd	s1,72(sp)
 5f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5fa:	0005c483          	lbu	s1,0(a1)
 5fe:	22048363          	beqz	s1,824 <vprintf+0x234>
 602:	e0ca                	sd	s2,64(sp)
 604:	fc4e                	sd	s3,56(sp)
 606:	f852                	sd	s4,48(sp)
 608:	f456                	sd	s5,40(sp)
 60a:	f05a                	sd	s6,32(sp)
 60c:	ec5e                	sd	s7,24(sp)
 60e:	e862                	sd	s8,16(sp)
 610:	8b2a                	mv	s6,a0
 612:	8a2e                	mv	s4,a1
 614:	8bb2                	mv	s7,a2
  state = 0;
 616:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 618:	4901                	li	s2,0
 61a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 61c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 620:	06400c13          	li	s8,100
 624:	a00d                	j	646 <vprintf+0x56>
        putc(fd, c0);
 626:	85a6                	mv	a1,s1
 628:	855a                	mv	a0,s6
 62a:	f0bff0ef          	jal	534 <putc>
 62e:	a019                	j	634 <vprintf+0x44>
    } else if (state == '%') {
 630:	03598363          	beq	s3,s5,656 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 634:	0019079b          	addiw	a5,s2,1
 638:	893e                	mv	s2,a5
 63a:	873e                	mv	a4,a5
 63c:	97d2                	add	a5,a5,s4
 63e:	0007c483          	lbu	s1,0(a5)
 642:	1c048a63          	beqz	s1,816 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 646:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 64a:	fe0993e3          	bnez	s3,630 <vprintf+0x40>
      if (c0 == '%') {
 64e:	fd579ce3          	bne	a5,s5,626 <vprintf+0x36>
        state = '%';
 652:	89be                	mv	s3,a5
 654:	b7c5                	j	634 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 656:	00ea06b3          	add	a3,s4,a4
 65a:	0016c603          	lbu	a2,1(a3)
      if (c1)
 65e:	1c060863          	beqz	a2,82e <vprintf+0x23e>
      if (c0 == 'd') {
 662:	03878763          	beq	a5,s8,690 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 666:	f9478693          	addi	a3,a5,-108
 66a:	0016b693          	seqz	a3,a3
 66e:	f9c60593          	addi	a1,a2,-100
 672:	e99d                	bnez	a1,6a8 <vprintf+0xb8>
 674:	ca95                	beqz	a3,6a8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8493          	addi	s1,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	ecfff0ef          	jal	552 <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 68c:	4981                	li	s3,0
 68e:	b75d                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 690:	008b8493          	addi	s1,s7,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	eb5ff0ef          	jal	552 <printint>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b779                	j	634 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 6a8:	9752                	add	a4,a4,s4
 6aa:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6ae:	f9460713          	addi	a4,a2,-108
 6b2:	00173713          	seqz	a4,a4
 6b6:	8f75                	and	a4,a4,a3
 6b8:	f9c58513          	addi	a0,a1,-100
 6bc:	18051363          	bnez	a0,842 <vprintf+0x252>
 6c0:	18070163          	beqz	a4,842 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4685                	li	a3,1
 6ca:	4629                	li	a2,10
 6cc:	000bb583          	ld	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	e81ff0ef          	jal	552 <printint>
        i += 2;
 6d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
        i += 2;
 6dc:	bfa1                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4629                	li	a2,10
 6e6:	000be583          	lwu	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e67ff0ef          	jal	552 <printint>
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b781                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4629                	li	a2,10
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	e4fff0ef          	jal	552 <printint>
        i += 1;
 708:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b71d                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 710:	008b8493          	addi	s1,s7,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	e35ff0ef          	jal	552 <printint>
        i += 2;
 722:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
        i += 2;
 728:	b731                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000be583          	lwu	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e1bff0ef          	jal	552 <printint>
 73c:	8ba6                	mv	s7,s1
      state = 0;
 73e:	4981                	li	s3,0
 740:	bdd5                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 742:	008b8493          	addi	s1,s7,8
 746:	4681                	li	a3,0
 748:	4641                	li	a2,16
 74a:	000bb583          	ld	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	e03ff0ef          	jal	552 <printint>
        i += 1;
 754:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 756:	8ba6                	mv	s7,s1
      state = 0;
 758:	4981                	li	s3,0
 75a:	bde9                	j	634 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75c:	008b8493          	addi	s1,s7,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000bb583          	ld	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	de9ff0ef          	jal	552 <printint>
        i += 2;
 76e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
        i += 2;
 774:	b5c1                	j	634 <vprintf+0x44>
 776:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 778:	008b8793          	addi	a5,s7,8
 77c:	8cbe                	mv	s9,a5
 77e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 782:	03000593          	li	a1,48
 786:	855a                	mv	a0,s6
 788:	dadff0ef          	jal	534 <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	855a                	mv	a0,s6
 792:	da3ff0ef          	jal	534 <putc>
 796:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 798:	00000b97          	auipc	s7,0x0
 79c:	388b8b93          	addi	s7,s7,904 # b20 <digits>
 7a0:	03c9d793          	srli	a5,s3,0x3c
 7a4:	97de                	add	a5,a5,s7
 7a6:	0007c583          	lbu	a1,0(a5)
 7aa:	855a                	mv	a0,s6
 7ac:	d89ff0ef          	jal	534 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	0992                	slli	s3,s3,0x4
 7b2:	34fd                	addiw	s1,s1,-1
 7b4:	f4f5                	bnez	s1,7a0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7b6:	8be6                	mv	s7,s9
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	6ca2                	ld	s9,8(sp)
 7bc:	bda5                	j	634 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7be:	008b8493          	addi	s1,s7,8
 7c2:	000bc583          	lbu	a1,0(s7)
 7c6:	855a                	mv	a0,s6
 7c8:	d6dff0ef          	jal	534 <putc>
 7cc:	8ba6                	mv	s7,s1
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b595                	j	634 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 7d2:	008b8993          	addi	s3,s7,8
 7d6:	000bb483          	ld	s1,0(s7)
 7da:	cc91                	beqz	s1,7f6 <vprintf+0x206>
        for (; *s; s++)
 7dc:	0004c583          	lbu	a1,0(s1)
 7e0:	c985                	beqz	a1,810 <vprintf+0x220>
          putc(fd, *s);
 7e2:	855a                	mv	a0,s6
 7e4:	d51ff0ef          	jal	534 <putc>
        for (; *s; s++)
 7e8:	0485                	addi	s1,s1,1
 7ea:	0004c583          	lbu	a1,0(s1)
 7ee:	f9f5                	bnez	a1,7e2 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 7f0:	8bce                	mv	s7,s3
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b581                	j	634 <vprintf+0x44>
          s = "(null)";
 7f6:	00000497          	auipc	s1,0x0
 7fa:	32248493          	addi	s1,s1,802 # b18 <malloc+0x186>
        for (; *s; s++)
 7fe:	02800593          	li	a1,40
 802:	b7c5                	j	7e2 <vprintf+0x1f2>
        putc(fd, '%');
 804:	85be                	mv	a1,a5
 806:	855a                	mv	a0,s6
 808:	d2dff0ef          	jal	534 <putc>
      state = 0;
 80c:	4981                	li	s3,0
 80e:	b51d                	j	634 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 810:	8bce                	mv	s7,s3
      state = 0;
 812:	4981                	li	s3,0
 814:	b505                	j	634 <vprintf+0x44>
 816:	6906                	ld	s2,64(sp)
 818:	79e2                	ld	s3,56(sp)
 81a:	7a42                	ld	s4,48(sp)
 81c:	7aa2                	ld	s5,40(sp)
 81e:	7b02                	ld	s6,32(sp)
 820:	6be2                	ld	s7,24(sp)
 822:	6c42                	ld	s8,16(sp)
    }
  }
}
 824:	60e6                	ld	ra,88(sp)
 826:	6446                	ld	s0,80(sp)
 828:	64a6                	ld	s1,72(sp)
 82a:	6125                	addi	sp,sp,96
 82c:	8082                	ret
      if (c0 == 'd') {
 82e:	06400713          	li	a4,100
 832:	e4e78fe3          	beq	a5,a4,690 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 836:	f9478693          	addi	a3,a5,-108
 83a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 83e:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 840:	4701                	li	a4,0
      } else if (c0 == 'u') {
 842:	07500513          	li	a0,117
 846:	e8a78ce3          	beq	a5,a0,6de <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 84a:	f8b60513          	addi	a0,a2,-117
 84e:	e119                	bnez	a0,854 <vprintf+0x264>
 850:	ea0693e3          	bnez	a3,6f6 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 854:	f8b58513          	addi	a0,a1,-117
 858:	e119                	bnez	a0,85e <vprintf+0x26e>
 85a:	ea071be3          	bnez	a4,710 <vprintf+0x120>
      } else if (c0 == 'x') {
 85e:	07800513          	li	a0,120
 862:	eca784e3          	beq	a5,a0,72a <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 866:	f8860613          	addi	a2,a2,-120
 86a:	e219                	bnez	a2,870 <vprintf+0x280>
 86c:	ec069be3          	bnez	a3,742 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 870:	f8858593          	addi	a1,a1,-120
 874:	e199                	bnez	a1,87a <vprintf+0x28a>
 876:	ee0713e3          	bnez	a4,75c <vprintf+0x16c>
      } else if (c0 == 'p') {
 87a:	07000713          	li	a4,112
 87e:	eee78ce3          	beq	a5,a4,776 <vprintf+0x186>
      } else if (c0 == 'c') {
 882:	06300713          	li	a4,99
 886:	f2e78ce3          	beq	a5,a4,7be <vprintf+0x1ce>
      } else if (c0 == 's') {
 88a:	07300713          	li	a4,115
 88e:	f4e782e3          	beq	a5,a4,7d2 <vprintf+0x1e2>
      } else if (c0 == '%') {
 892:	02500713          	li	a4,37
 896:	f6e787e3          	beq	a5,a4,804 <vprintf+0x214>
        putc(fd, '%');
 89a:	02500593          	li	a1,37
 89e:	855a                	mv	a0,s6
 8a0:	c95ff0ef          	jal	534 <putc>
        putc(fd, c0);
 8a4:	85a6                	mv	a1,s1
 8a6:	855a                	mv	a0,s6
 8a8:	c8dff0ef          	jal	534 <putc>
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	b359                	j	634 <vprintf+0x44>

00000000000008b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8b0:	715d                	addi	sp,sp,-80
 8b2:	ec06                	sd	ra,24(sp)
 8b4:	e822                	sd	s0,16(sp)
 8b6:	1000                	addi	s0,sp,32
 8b8:	e010                	sd	a2,0(s0)
 8ba:	e414                	sd	a3,8(s0)
 8bc:	e818                	sd	a4,16(s0)
 8be:	ec1c                	sd	a5,24(s0)
 8c0:	03043023          	sd	a6,32(s0)
 8c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c8:	8622                	mv	a2,s0
 8ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ce:	d23ff0ef          	jal	5f0 <vprintf>
}
 8d2:	60e2                	ld	ra,24(sp)
 8d4:	6442                	ld	s0,16(sp)
 8d6:	6161                	addi	sp,sp,80
 8d8:	8082                	ret

00000000000008da <printf>:

void
printf(const char *fmt, ...)
{
 8da:	711d                	addi	sp,sp,-96
 8dc:	ec06                	sd	ra,24(sp)
 8de:	e822                	sd	s0,16(sp)
 8e0:	1000                	addi	s0,sp,32
 8e2:	e40c                	sd	a1,8(s0)
 8e4:	e810                	sd	a2,16(s0)
 8e6:	ec14                	sd	a3,24(s0)
 8e8:	f018                	sd	a4,32(s0)
 8ea:	f41c                	sd	a5,40(s0)
 8ec:	03043823          	sd	a6,48(s0)
 8f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f4:	00840613          	addi	a2,s0,8
 8f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fc:	85aa                	mv	a1,a0
 8fe:	4505                	li	a0,1
 900:	cf1ff0ef          	jal	5f0 <vprintf>
}
 904:	60e2                	ld	ra,24(sp)
 906:	6442                	ld	s0,16(sp)
 908:	6125                	addi	sp,sp,96
 90a:	8082                	ret

000000000000090c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90c:	1141                	addi	sp,sp,-16
 90e:	e406                	sd	ra,8(sp)
 910:	e022                	sd	s0,0(sp)
 912:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 914:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 918:	00000797          	auipc	a5,0x0
 91c:	6e87b783          	ld	a5,1768(a5) # 1000 <freep>
 920:	a039                	j	92e <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 922:	6398                	ld	a4,0(a5)
 924:	00e7e463          	bltu	a5,a4,92c <free+0x20>
 928:	00e6ea63          	bltu	a3,a4,93c <free+0x30>
{
 92c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92e:	fed7fae3          	bgeu	a5,a3,922 <free+0x16>
 932:	6398                	ld	a4,0(a5)
 934:	00e6e463          	bltu	a3,a4,93c <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 938:	fee7eae3          	bltu	a5,a4,92c <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 93c:	ff852583          	lw	a1,-8(a0)
 940:	6390                	ld	a2,0(a5)
 942:	02059813          	slli	a6,a1,0x20
 946:	01c85713          	srli	a4,a6,0x1c
 94a:	9736                	add	a4,a4,a3
 94c:	02e60563          	beq	a2,a4,976 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 950:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 954:	4790                	lw	a2,8(a5)
 956:	02061593          	slli	a1,a2,0x20
 95a:	01c5d713          	srli	a4,a1,0x1c
 95e:	973e                	add	a4,a4,a5
 960:	02e68263          	beq	a3,a4,984 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 964:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 966:	00000717          	auipc	a4,0x0
 96a:	68f73d23          	sd	a5,1690(a4) # 1000 <freep>
}
 96e:	60a2                	ld	ra,8(sp)
 970:	6402                	ld	s0,0(sp)
 972:	0141                	addi	sp,sp,16
 974:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 976:	4618                	lw	a4,8(a2)
 978:	9f2d                	addw	a4,a4,a1
 97a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97e:	6398                	ld	a4,0(a5)
 980:	6310                	ld	a2,0(a4)
 982:	b7f9                	j	950 <free+0x44>
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9f31                	addw	a4,a4,a2
 98a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053683          	ld	a3,-16(a0)
 990:	bfd1                	j	964 <free+0x58>

0000000000000992 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 992:	7139                	addi	sp,sp,-64
 994:	fc06                	sd	ra,56(sp)
 996:	f822                	sd	s0,48(sp)
 998:	f04a                	sd	s2,32(sp)
 99a:	ec4e                	sd	s3,24(sp)
 99c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 99e:	02051993          	slli	s3,a0,0x20
 9a2:	0209d993          	srli	s3,s3,0x20
 9a6:	09bd                	addi	s3,s3,15
 9a8:	0049d993          	srli	s3,s3,0x4
 9ac:	2985                	addiw	s3,s3,1
 9ae:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 9b0:	00000517          	auipc	a0,0x0
 9b4:	65053503          	ld	a0,1616(a0) # 1000 <freep>
 9b8:	c905                	beqz	a0,9e8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9ba:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9bc:	4798                	lw	a4,8(a5)
 9be:	09377663          	bgeu	a4,s3,a4a <malloc+0xb8>
 9c2:	f426                	sd	s1,40(sp)
 9c4:	e852                	sd	s4,16(sp)
 9c6:	e456                	sd	s5,8(sp)
 9c8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 9ca:	8a4e                	mv	s4,s3
 9cc:	6705                	lui	a4,0x1
 9ce:	00e9f363          	bgeu	s3,a4,9d4 <malloc+0x42>
 9d2:	6a05                	lui	s4,0x1
 9d4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 9dc:	00000497          	auipc	s1,0x0
 9e0:	62448493          	addi	s1,s1,1572 # 1000 <freep>
  if (p == SBRK_ERROR)
 9e4:	5afd                	li	s5,-1
 9e6:	a83d                	j	a24 <malloc+0x92>
 9e8:	f426                	sd	s1,40(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f0:	00000797          	auipc	a5,0x0
 9f4:	62078793          	addi	a5,a5,1568 # 1010 <base>
 9f8:	00000717          	auipc	a4,0x0
 9fc:	60f73423          	sd	a5,1544(a4) # 1000 <freep>
 a00:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a02:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a06:	b7d1                	j	9ca <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a08:	6398                	ld	a4,0(a5)
 a0a:	e118                	sd	a4,0(a0)
 a0c:	a899                	j	a62 <malloc+0xd0>
  hp->s.size = nu;
 a0e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a12:	0541                	addi	a0,a0,16
 a14:	ef9ff0ef          	jal	90c <free>
  return freep;
 a18:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a1a:	c125                	beqz	a0,a7a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a1c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a1e:	4798                	lw	a4,8(a5)
 a20:	03277163          	bgeu	a4,s2,a42 <malloc+0xb0>
    if (p == freep)
 a24:	6098                	ld	a4,0(s1)
 a26:	853e                	mv	a0,a5
 a28:	fef71ae3          	bne	a4,a5,a1c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a2c:	8552                	mv	a0,s4
 a2e:	a23ff0ef          	jal	450 <sbrk>
  if (p == SBRK_ERROR)
 a32:	fd551ee3          	bne	a0,s5,a0e <malloc+0x7c>
        return 0;
 a36:	4501                	li	a0,0
 a38:	74a2                	ld	s1,40(sp)
 a3a:	6a42                	ld	s4,16(sp)
 a3c:	6aa2                	ld	s5,8(sp)
 a3e:	6b02                	ld	s6,0(sp)
 a40:	a03d                	j	a6e <malloc+0xdc>
 a42:	74a2                	ld	s1,40(sp)
 a44:	6a42                	ld	s4,16(sp)
 a46:	6aa2                	ld	s5,8(sp)
 a48:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a4a:	fae90fe3          	beq	s2,a4,a08 <malloc+0x76>
        p->s.size -= nunits;
 a4e:	4137073b          	subw	a4,a4,s3
 a52:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a54:	02071693          	slli	a3,a4,0x20
 a58:	01c6d713          	srli	a4,a3,0x1c
 a5c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a5e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a62:	00000717          	auipc	a4,0x0
 a66:	58a73f23          	sd	a0,1438(a4) # 1000 <freep>
      return (void *)(p + 1);
 a6a:	01078513          	addi	a0,a5,16
  }
}
 a6e:	70e2                	ld	ra,56(sp)
 a70:	7442                	ld	s0,48(sp)
 a72:	7902                	ld	s2,32(sp)
 a74:	69e2                	ld	s3,24(sp)
 a76:	6121                	addi	sp,sp,64
 a78:	8082                	ret
 a7a:	74a2                	ld	s1,40(sp)
 a7c:	6a42                	ld	s4,16(sp)
 a7e:	6aa2                	ld	s5,8(sp)
 a80:	6b02                	ld	s6,0(sp)
 a82:	b7f5                	j	a6e <malloc+0xdc>
