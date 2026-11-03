
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	68078793          	addi	a5,a5,1664 # 8690 <malloc+0x2a2e>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	74a050ef          	jal	5794 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	cf450513          	addi	a0,a0,-780 # 5d60 <malloc+0xfe>
      74:	337050ef          	jal	5baa <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	6da050ef          	jal	5754 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000b797          	auipc	a5,0xb
      82:	56a78793          	addi	a5,a5,1386 # b5e8 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c7268693          	addi	a3,a3,-910 # dcf8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	cda50513          	addi	a0,a0,-806 # 5d80 <malloc+0x11e>
      ae:	2fd050ef          	jal	5baa <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	6a0050ef          	jal	5754 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	cd250513          	addi	a0,a0,-814 # 5d98 <malloc+0x136>
      ce:	6c6050ef          	jal	5794 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	6a6050ef          	jal	577c <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	cdc50513          	addi	a0,a0,-804 # 5db8 <malloc+0x156>
      e4:	6b0050ef          	jal	5794 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	ca850513          	addi	a0,a0,-856 # 5da0 <malloc+0x13e>
     100:	2ab050ef          	jal	5baa <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	64e050ef          	jal	5754 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	cbc50513          	addi	a0,a0,-836 # 5dc8 <malloc+0x166>
     114:	297050ef          	jal	5baa <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	63a050ef          	jal	5754 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	cc250513          	addi	a0,a0,-830 # 5df0 <malloc+0x18e>
     136:	66e050ef          	jal	57a4 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	cb250513          	addi	a0,a0,-846 # 5df0 <malloc+0x18e>
     146:	64e050ef          	jal	5794 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	cb258593          	addi	a1,a1,-846 # 5e00 <malloc+0x19e>
     156:	61e050ef          	jal	5774 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	c9250513          	addi	a0,a0,-878 # 5df0 <malloc+0x18e>
     166:	62e050ef          	jal	5794 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	c9a58593          	addi	a1,a1,-870 # 5e08 <malloc+0x1a6>
     176:	8526                	mv	a0,s1
     178:	5fc050ef          	jal	5774 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	c6e50513          	addi	a0,a0,-914 # 5df0 <malloc+0x18e>
     18a:	61a050ef          	jal	57a4 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	5ec050ef          	jal	577c <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	5e6050ef          	jal	577c <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	c6450513          	addi	a0,a0,-924 # 5e10 <malloc+0x1ae>
     1b4:	1f7050ef          	jal	5baa <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	59a050ef          	jal	5754 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	5a2050ef          	jal	5794 <open>
    close(fd);
     1f6:	586050ef          	jal	577c <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	582050ef          	jal	57a4 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00006517          	auipc	a0,0x6
     260:	bdc50513          	addi	a0,a0,-1060 # 5e38 <malloc+0x1d6>
     264:	540050ef          	jal	57a4 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00006a17          	auipc	s4,0x6
     274:	bc8a0a13          	addi	s4,s4,-1080 # 5e38 <malloc+0x1d6>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a7e98993          	addi	s3,s3,-1410 # dcf8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x51>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	508050ef          	jal	5794 <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	4d6050ef          	jal	5774 <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	4ce050ef          	jal	577c <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	4f0050ef          	jal	57a4 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00006517          	auipc	a0,0x6
     2e0:	b6c50513          	addi	a0,a0,-1172 # 5e48 <malloc+0x1e6>
     2e4:	0c7050ef          	jal	5baa <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	46a050ef          	jal	5754 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00006517          	auipc	a0,0x6
     2f8:	b7450513          	addi	a0,a0,-1164 # 5e68 <malloc+0x206>
     2fc:	0af050ef          	jal	5baa <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	452050ef          	jal	5754 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00006517          	auipc	a0,0x6
     31e:	b6650513          	addi	a0,a0,-1178 # 5e80 <malloc+0x21e>
     322:	482050ef          	jal	57a4 <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00006997          	auipc	s3,0x6
     332:	b5298993          	addi	s3,s3,-1198 # 5e80 <malloc+0x21e>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	452050ef          	jal	5794 <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	424050ef          	jal	5774 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	426050ef          	jal	577c <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	448050ef          	jal	57a4 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00006517          	auipc	a0,0x6
     36e:	b1650513          	addi	a0,a0,-1258 # 5e80 <malloc+0x21e>
     372:	422050ef          	jal	5794 <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00006597          	auipc	a1,0x6
     382:	a8a58593          	addi	a1,a1,-1398 # 5e08 <malloc+0x1a6>
     386:	3ee050ef          	jal	5774 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00006517          	auipc	a0,0x6
     394:	b1050513          	addi	a0,a0,-1264 # 5ea0 <malloc+0x23e>
     398:	013050ef          	jal	5baa <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	3b6050ef          	jal	5754 <exit>
      printf("open junk failed\n");
     3a2:	00006517          	auipc	a0,0x6
     3a6:	ae650513          	addi	a0,a0,-1306 # 5e88 <malloc+0x226>
     3aa:	001050ef          	jal	5baa <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	3a4050ef          	jal	5754 <exit>
    printf("open junk failed\n");
     3b4:	00006517          	auipc	a0,0x6
     3b8:	ad450513          	addi	a0,a0,-1324 # 5e88 <malloc+0x226>
     3bc:	7ee050ef          	jal	5baa <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	392050ef          	jal	5754 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	3b4050ef          	jal	577c <close>
  unlink("junk");
     3cc:	00006517          	auipc	a0,0x6
     3d0:	ab450513          	addi	a0,a0,-1356 # 5e80 <malloc+0x21e>
     3d4:	3d0050ef          	jal	57a4 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	37a050ef          	jal	5754 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	370050ef          	jal	57a4 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	358050ef          	jal	5794 <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	338050ef          	jal	577c <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	316050ef          	jal	57a4 <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00008797          	auipc	a5,0x8
     4c8:	1cc78793          	addi	a5,a5,460 # 8690 <malloc+0x2a2e>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00006a97          	auipc	s5,0x6
     4fa:	9baa8a93          	addi	s5,s5,-1606 # 5eb0 <malloc+0x24e>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	286050ef          	jal	5794 <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	258050ef          	jal	5774 <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	256050ef          	jal	577c <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	278050ef          	jal	57a4 <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	23e050ef          	jal	5774 <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	224050ef          	jal	5764 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	224050ef          	jal	5774 <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	220050ef          	jal	577c <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	218050ef          	jal	577c <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00006517          	auipc	a0,0x6
     58c:	93050513          	addi	a0,a0,-1744 # 5eb8 <malloc+0x256>
     590:	61a050ef          	jal	5baa <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	1be050ef          	jal	5754 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00006517          	auipc	a0,0x6
     5a2:	93250513          	addi	a0,a0,-1742 # 5ed0 <malloc+0x26e>
     5a6:	604050ef          	jal	5baa <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	1a8050ef          	jal	5754 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	94c50513          	addi	a0,a0,-1716 # 5f00 <malloc+0x29e>
     5bc:	5ee050ef          	jal	5baa <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	192050ef          	jal	5754 <exit>
      printf("pipe() failed\n");
     5c6:	00006517          	auipc	a0,0x6
     5ca:	96a50513          	addi	a0,a0,-1686 # 5f30 <malloc+0x2ce>
     5ce:	5dc050ef          	jal	5baa <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	180050ef          	jal	5754 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00006517          	auipc	a0,0x6
     5e0:	96450513          	addi	a0,a0,-1692 # 5f40 <malloc+0x2de>
     5e4:	5c6050ef          	jal	5baa <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	16a050ef          	jal	5754 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00008797          	auipc	a5,0x8
     60c:	08878793          	addi	a5,a5,136 # 8690 <malloc+0x2a2e>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00006b17          	auipc	s6,0x6
     640:	934b0b13          	addi	s6,s6,-1740 # 5f70 <malloc+0x30e>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	7bcb8b93          	addi	s7,s7,1980 # 5e08 <malloc+0x1a6>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	138050ef          	jal	5794 <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	102050ef          	jal	576c <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	108050ef          	jal	577c <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	0ea050ef          	jal	5764 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	0ea050ef          	jal	5774 <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	0d2050ef          	jal	576c <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	0d6050ef          	jal	577c <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	0ce050ef          	jal	577c <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00006517          	auipc	a0,0x6
     6d6:	8a650513          	addi	a0,a0,-1882 # 5f78 <malloc+0x316>
     6da:	4d0050ef          	jal	5baa <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	074050ef          	jal	5754 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00006517          	auipc	a0,0x6
     6ec:	8a850513          	addi	a0,a0,-1880 # 5f90 <malloc+0x32e>
     6f0:	4ba050ef          	jal	5baa <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	05e050ef          	jal	5754 <exit>
      printf("pipe() failed\n");
     6fa:	00006517          	auipc	a0,0x6
     6fe:	83650513          	addi	a0,a0,-1994 # 5f30 <malloc+0x2ce>
     702:	4a8050ef          	jal	5baa <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	04c050ef          	jal	5754 <exit>
      printf("pipe write failed\n");
     70c:	00006517          	auipc	a0,0x6
     710:	8b450513          	addi	a0,a0,-1868 # 5fc0 <malloc+0x35e>
     714:	496050ef          	jal	5baa <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	03a050ef          	jal	5754 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00006517          	auipc	a0,0x6
     726:	8b650513          	addi	a0,a0,-1866 # 5fd8 <malloc+0x376>
     72a:	480050ef          	jal	5baa <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	024050ef          	jal	5754 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	6a850513          	addi	a0,a0,1704 # 5df0 <malloc+0x18e>
     750:	054050ef          	jal	57a4 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	69850513          	addi	a0,a0,1688 # 5df0 <malloc+0x18e>
     760:	034050ef          	jal	5794 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	69858593          	addi	a1,a1,1688 # 5e00 <malloc+0x19e>
     770:	004050ef          	jal	5774 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	006050ef          	jal	577c <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	67450513          	addi	a0,a0,1652 # 5df0 <malloc+0x18e>
     784:	010050ef          	jal	5794 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	7db040ef          	jal	576c <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	65050513          	addi	a0,a0,1616 # 5df0 <malloc+0x18e>
     7a8:	7ed040ef          	jal	5794 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	64050513          	addi	a0,a0,1600 # 5df0 <malloc+0x18e>
     7b8:	7dd040ef          	jal	5794 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	7a7040ef          	jal	576c <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	795040ef          	jal	576c <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00006597          	auipc	a1,0x6
     7e6:	88658593          	addi	a1,a1,-1914 # 6068 <malloc+0x406>
     7ea:	854e                	mv	a0,s3
     7ec:	789040ef          	jal	5774 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	773040ef          	jal	576c <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	75f040ef          	jal	576c <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	5d850513          	addi	a0,a0,1496 # 5df0 <malloc+0x18e>
     820:	785040ef          	jal	57a4 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	757040ef          	jal	577c <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	751040ef          	jal	577c <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	74b040ef          	jal	577c <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	7bc50513          	addi	a0,a0,1980 # 6008 <malloc+0x3a6>
     854:	356050ef          	jal	5baa <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	6fb040ef          	jal	5754 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	7c850513          	addi	a0,a0,1992 # 6028 <malloc+0x3c6>
     868:	342050ef          	jal	5baa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	7c850513          	addi	a0,a0,1992 # 6038 <malloc+0x3d6>
     878:	332050ef          	jal	5baa <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	6d7040ef          	jal	5754 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	7d450513          	addi	a0,a0,2004 # 6058 <malloc+0x3f6>
     88c:	31e050ef          	jal	5baa <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	7a450513          	addi	a0,a0,1956 # 6038 <malloc+0x3d6>
     89c:	30e050ef          	jal	5baa <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	6b3040ef          	jal	5754 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	7c650513          	addi	a0,a0,1990 # 6070 <malloc+0x40e>
     8b2:	2f8050ef          	jal	5baa <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	69d040ef          	jal	5754 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	7d050513          	addi	a0,a0,2000 # 6090 <malloc+0x42e>
     8c8:	2e2050ef          	jal	5baa <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	687040ef          	jal	5754 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	7c250513          	addi	a0,a0,1986 # 60b0 <malloc+0x44e>
     8f6:	69f040ef          	jal	5794 <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	7d4a0a13          	addi	s4,s4,2004 # 60d8 <malloc+0x476>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00006b17          	auipc	s6,0x6
     910:	804b0b13          	addi	s6,s6,-2044 # 6110 <malloc+0x4ae>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	657040ef          	jal	5774 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	649040ef          	jal	5774 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	641040ef          	jal	577c <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	76e50513          	addi	a0,a0,1902 # 60b0 <malloc+0x44e>
     94a:	64b040ef          	jal	5794 <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	3a058593          	addi	a1,a1,928 # dcf8 <buf>
     960:	60d040ef          	jal	576c <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	60f040ef          	jal	577c <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	73e50513          	addi	a0,a0,1854 # 60b0 <malloc+0x44e>
     97a:	62b040ef          	jal	57a4 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	71e50513          	addi	a0,a0,1822 # 60b8 <malloc+0x456>
     9a2:	208050ef          	jal	5baa <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	5ad040ef          	jal	5754 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	73850513          	addi	a0,a0,1848 # 60e8 <malloc+0x486>
     9b8:	1f2050ef          	jal	5baa <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	597040ef          	jal	5754 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	75a50513          	addi	a0,a0,1882 # 6120 <malloc+0x4be>
     9ce:	1dc050ef          	jal	5baa <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	581040ef          	jal	5754 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	76e50513          	addi	a0,a0,1902 # 6148 <malloc+0x4e6>
     9e2:	1c8050ef          	jal	5baa <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	56d040ef          	jal	5754 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	77a50513          	addi	a0,a0,1914 # 6168 <malloc+0x506>
     9f6:	1b4050ef          	jal	5baa <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	559040ef          	jal	5754 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	77e50513          	addi	a0,a0,1918 # 6180 <malloc+0x51e>
     a0a:	1a0050ef          	jal	5baa <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	545040ef          	jal	5754 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	77250513          	addi	a0,a0,1906 # 61a0 <malloc+0x53e>
     a36:	55f040ef          	jal	5794 <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000d997          	auipc	s3,0xd
     a46:	2b698993          	addi	s3,s3,694 # dcf8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	519040ef          	jal	5774 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	511040ef          	jal	577c <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	72e50513          	addi	a0,a0,1838 # 61a0 <malloc+0x53e>
     a7a:	51b040ef          	jal	5794 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000d917          	auipc	s2,0xd
     a8a:	27290913          	addi	s2,s2,626 # dcf8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	4d5040ef          	jal	576c <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	6f850513          	addi	a0,a0,1784 # 61a8 <malloc+0x546>
     ab8:	0f2050ef          	jal	5baa <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	497040ef          	jal	5754 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	70250513          	addi	a0,a0,1794 # 61c8 <malloc+0x566>
     ace:	0dc050ef          	jal	5baa <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	481040ef          	jal	5754 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	71650513          	addi	a0,a0,1814 # 61f0 <malloc+0x58e>
     ae2:	0c8050ef          	jal	5baa <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	46d040ef          	jal	5754 <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	487040ef          	jal	577c <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	6a650513          	addi	a0,a0,1702 # 61a0 <malloc+0x53e>
     b02:	4a3040ef          	jal	57a4 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	6ee50513          	addi	a0,a0,1774 # 6210 <malloc+0x5ae>
     b2a:	080050ef          	jal	5baa <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	425040ef          	jal	5754 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	70050513          	addi	a0,a0,1792 # 6238 <malloc+0x5d6>
     b40:	06a050ef          	jal	5baa <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	40f040ef          	jal	5754 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	70250513          	addi	a0,a0,1794 # 6250 <malloc+0x5ee>
     b56:	054050ef          	jal	5baa <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	3f9040ef          	jal	5754 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	71650513          	addi	a0,a0,1814 # 6278 <malloc+0x616>
     b6a:	040050ef          	jal	5baa <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	3e5040ef          	jal	5754 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	70850513          	addi	a0,a0,1800 # 6290 <malloc+0x62e>
     b90:	405040ef          	jal	5794 <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	72458593          	addi	a1,a1,1828 # 62c0 <malloc+0x65e>
     ba4:	3d1040ef          	jal	5774 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	3d3040ef          	jal	577c <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	6e050513          	addi	a0,a0,1760 # 6290 <malloc+0x62e>
     bb8:	3dd040ef          	jal	5794 <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	6ce50513          	addi	a0,a0,1742 # 6290 <malloc+0x62e>
     bca:	3db040ef          	jal	57a4 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	6bc50513          	addi	a0,a0,1724 # 6290 <malloc+0x62e>
     bdc:	3b9040ef          	jal	5794 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	72458593          	addi	a1,a1,1828 # 6308 <malloc+0x6a6>
     bec:	389040ef          	jal	5774 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	38b040ef          	jal	577c <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	10058593          	addi	a1,a1,256 # dcf8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	36b040ef          	jal	576c <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000d717          	auipc	a4,0xd
     c10:	0ec74703          	lbu	a4,236(a4) # dcf8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000d597          	auipc	a1,0xd
     c22:	0da58593          	addi	a1,a1,218 # dcf8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	34d040ef          	jal	5774 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	349040ef          	jal	577c <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	65850513          	addi	a0,a0,1624 # 6290 <malloc+0x62e>
     c40:	365040ef          	jal	57a4 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	64c50513          	addi	a0,a0,1612 # 62a0 <malloc+0x63e>
     c5c:	74f040ef          	jal	5baa <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	2f3040ef          	jal	5754 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	66050513          	addi	a0,a0,1632 # 62c8 <malloc+0x666>
     c70:	73b040ef          	jal	5baa <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	2df040ef          	jal	5754 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	66c50513          	addi	a0,a0,1644 # 62e8 <malloc+0x686>
     c84:	727040ef          	jal	5baa <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	2cb040ef          	jal	5754 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	68050513          	addi	a0,a0,1664 # 6310 <malloc+0x6ae>
     c98:	713040ef          	jal	5baa <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	2b7040ef          	jal	5754 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	68c50513          	addi	a0,a0,1676 # 6330 <malloc+0x6ce>
     cac:	6ff040ef          	jal	5baa <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	2a3040ef          	jal	5754 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	69850513          	addi	a0,a0,1688 # 6350 <malloc+0x6ee>
     cc0:	6eb040ef          	jal	5baa <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	28f040ef          	jal	5754 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	69850513          	addi	a0,a0,1688 # 6370 <malloc+0x70e>
     ce0:	2c5040ef          	jal	57a4 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	69450513          	addi	a0,a0,1684 # 6378 <malloc+0x716>
     cec:	2b9040ef          	jal	57a4 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	67c50513          	addi	a0,a0,1660 # 6370 <malloc+0x70e>
     cfc:	299040ef          	jal	5794 <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	5b858593          	addi	a1,a1,1464 # 62c0 <malloc+0x65e>
     d10:	265040ef          	jal	5774 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	261040ef          	jal	577c <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	65858593          	addi	a1,a1,1624 # 6378 <malloc+0x716>
     d28:	00005517          	auipc	a0,0x5
     d2c:	64850513          	addi	a0,a0,1608 # 6370 <malloc+0x70e>
     d30:	285040ef          	jal	57b4 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	63850513          	addi	a0,a0,1592 # 6370 <malloc+0x70e>
     d40:	265040ef          	jal	57a4 <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	62a50513          	addi	a0,a0,1578 # 6370 <malloc+0x70e>
     d4e:	247040ef          	jal	5794 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	62050513          	addi	a0,a0,1568 # 6378 <malloc+0x716>
     d60:	235040ef          	jal	5794 <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f8c58593          	addi	a1,a1,-116 # dcf8 <buf>
     d74:	1f9040ef          	jal	576c <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	1fd040ef          	jal	577c <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	5f458593          	addi	a1,a1,1524 # 6378 <malloc+0x716>
     d8c:	852e                	mv	a0,a1
     d8e:	227040ef          	jal	57b4 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	5e250513          	addi	a0,a0,1506 # 6378 <malloc+0x716>
     d9e:	207040ef          	jal	57a4 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	5ce58593          	addi	a1,a1,1486 # 6370 <malloc+0x70e>
     daa:	00005517          	auipc	a0,0x5
     dae:	5ce50513          	addi	a0,a0,1486 # 6378 <malloc+0x716>
     db2:	203040ef          	jal	57b4 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	5b658593          	addi	a1,a1,1462 # 6370 <malloc+0x70e>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	6be50513          	addi	a0,a0,1726 # 6480 <malloc+0x81e>
     dca:	1eb040ef          	jal	57b4 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	5a050513          	addi	a0,a0,1440 # 6380 <malloc+0x71e>
     de8:	5c3040ef          	jal	5baa <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	167040ef          	jal	5754 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	5a450513          	addi	a0,a0,1444 # 6398 <malloc+0x736>
     dfc:	5af040ef          	jal	5baa <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	153040ef          	jal	5754 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	5a850513          	addi	a0,a0,1448 # 63b0 <malloc+0x74e>
     e10:	59b040ef          	jal	5baa <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	13f040ef          	jal	5754 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	5b450513          	addi	a0,a0,1460 # 63d0 <malloc+0x76e>
     e24:	587040ef          	jal	5baa <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	12b040ef          	jal	5754 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	5d050513          	addi	a0,a0,1488 # 6400 <malloc+0x79e>
     e38:	573040ef          	jal	5baa <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	117040ef          	jal	5754 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	5d450513          	addi	a0,a0,1492 # 6418 <malloc+0x7b6>
     e4c:	55f040ef          	jal	5baa <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	103040ef          	jal	5754 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	5d850513          	addi	a0,a0,1496 # 6430 <malloc+0x7ce>
     e60:	54b040ef          	jal	5baa <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	0ef040ef          	jal	5754 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	5ec50513          	addi	a0,a0,1516 # 6458 <malloc+0x7f6>
     e74:	537040ef          	jal	5baa <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	0db040ef          	jal	5754 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	60850513          	addi	a0,a0,1544 # 6488 <malloc+0x826>
     e88:	523040ef          	jal	5baa <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	0c7040ef          	jal	5754 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	5fe98993          	addi	s3,s3,1534 # 64a8 <malloc+0x846>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	0f7040ef          	jal	57b4 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	5d650513          	addi	a0,a0,1494 # 64b8 <malloc+0x856>
     eea:	4c1040ef          	jal	5baa <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	065040ef          	jal	5754 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	5cc50513          	addi	a0,a0,1484 # 64d8 <malloc+0x876>
     f14:	091040ef          	jal	57a4 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	5bc50513          	addi	a0,a0,1468 # 64d8 <malloc+0x876>
     f24:	071040ef          	jal	5794 <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	051040ef          	jal	577c <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	59e98993          	addi	s3,s3,1438 # 64d8 <malloc+0x876>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	03d040ef          	jal	57b4 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	55250513          	addi	a0,a0,1362 # 64d8 <malloc+0x876>
     f8e:	017040ef          	jal	57a4 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	7d6040ef          	jal	57a4 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	4ee50513          	addi	a0,a0,1262 # 64e0 <malloc+0x87e>
     ffa:	3b1040ef          	jal	5baa <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	754040ef          	jal	5754 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	4f450513          	addi	a0,a0,1268 # 6500 <malloc+0x89e>
    1014:	397040ef          	jal	5baa <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	73a040ef          	jal	5754 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	50850513          	addi	a0,a0,1288 # 6528 <malloc+0x8c6>
    1028:	383040ef          	jal	5baa <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	726040ef          	jal	5754 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00009497          	auipc	s1,0x9
    1044:	fc048493          	addi	s1,s1,-64 # a000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	73e040ef          	jal	578c <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	710040ef          	jal	5764 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	6fa040ef          	jal	5754 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0xd68>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00005997          	auipc	s3,0x5
    1082:	d1a98993          	addi	s3,s3,-742 # 5d98 <malloc+0x136>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	6fa040ef          	jal	578c <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	6b8040ef          	jal	5754 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	6de040ef          	jal	57a4 <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	6bc040ef          	jal	5794 <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	6cc040ef          	jal	57b4 <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	51e78793          	addi	a5,a5,1310 # 7610 <malloc+0x19ae>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	682040ef          	jal	578c <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	638040ef          	jal	574c <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00009797          	auipc	a5,0x9
    1124:	4c078793          	addi	a5,a5,1216 # a5e0 <big.0>
    1128:	0000a697          	auipc	a3,0xa
    112c:	4b868693          	addi	a3,a3,1208 # b5e0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	0000a797          	auipc	a5,0xa
    1142:	4a078123          	sb	zero,1186(a5) # b5e0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	54a78793          	addi	a5,a5,1354 # 8690 <malloc+0x2a2e>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00005517          	auipc	a0,0x5
    116e:	c2e50513          	addi	a0,a0,-978 # 5d98 <malloc+0x136>
    1172:	61a040ef          	jal	578c <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	45250513          	addi	a0,a0,1106 # 65d0 <malloc+0x96e>
    1186:	225040ef          	jal	5baa <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	5c8040ef          	jal	5754 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	3b250513          	addi	a0,a0,946 # 6548 <malloc+0x8e6>
    119e:	20d040ef          	jal	5baa <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	5b0040ef          	jal	5754 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	3ba50513          	addi	a0,a0,954 # 6568 <malloc+0x906>
    11b6:	1f5040ef          	jal	5baa <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	598040ef          	jal	5754 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	3c050513          	addi	a0,a0,960 # 6588 <malloc+0x926>
    11d0:	1db040ef          	jal	5baa <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	57e040ef          	jal	5754 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	3d050513          	addi	a0,a0,976 # 65b0 <malloc+0x94e>
    11e8:	1c3040ef          	jal	5baa <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	566040ef          	jal	5754 <exit>
    printf("fork failed\n");
    11f2:	00007517          	auipc	a0,0x7
    11f6:	b2650513          	addi	a0,a0,-1242 # 7d18 <malloc+0x20b6>
    11fa:	1b1040ef          	jal	5baa <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	554040ef          	jal	5754 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	54c040ef          	jal	5754 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	548040ef          	jal	575c <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	3cc50513          	addi	a0,a0,972 # 65f8 <malloc+0x996>
    1234:	177040ef          	jal	5baa <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	51a040ef          	jal	5754 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00005517          	auipc	a0,0x5
    1252:	ba250513          	addi	a0,a0,-1118 # 5df0 <malloc+0x18e>
    1256:	53e040ef          	jal	5794 <open>
    125a:	522040ef          	jal	577c <close>
  pid = fork();
    125e:	4ee040ef          	jal	574c <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00005997          	auipc	s3,0x5
    1282:	b7298993          	addi	s3,s3,-1166 # 5df0 <malloc+0x18e>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	3d0b0b13          	addi	s6,s6,976 # 6658 <malloc+0x9f6>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	4f8040ef          	jal	5794 <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	4ca040ef          	jal	5774 <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	4c8040ef          	jal	577c <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	4d8040ef          	jal	5794 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	4a6040ef          	jal	576c <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	4b0040ef          	jal	577c <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	47c040ef          	jal	5754 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	33a50513          	addi	a0,a0,826 # 6628 <malloc+0x9c6>
    12f6:	0b5040ef          	jal	5baa <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	458040ef          	jal	5754 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	33e50513          	addi	a0,a0,830 # 6640 <malloc+0x9de>
    130a:	0a1040ef          	jal	5baa <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	444040ef          	jal	5754 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	35050513          	addi	a0,a0,848 # 6668 <malloc+0xa06>
    1320:	08b040ef          	jal	5baa <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	42e040ef          	jal	5754 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00005a17          	auipc	s4,0x5
    1342:	ab2a0a13          	addi	s4,s4,-1358 # 5df0 <malloc+0x18e>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	340b0b13          	addi	s6,s6,832 # 6688 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	440040ef          	jal	5794 <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	412040ef          	jal	5774 <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	410040ef          	jal	577c <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	3de040ef          	jal	575c <wait>
  unlink("truncfile");
    1382:	00005517          	auipc	a0,0x5
    1386:	a6e50513          	addi	a0,a0,-1426 # 5df0 <malloc+0x18e>
    138a:	41a040ef          	jal	57a4 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	3c2040ef          	jal	5754 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	2a450513          	addi	a0,a0,676 # 6640 <malloc+0x9de>
    13a4:	007040ef          	jal	5baa <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	3aa040ef          	jal	5754 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	2da50513          	addi	a0,a0,730 # 6690 <malloc+0xa2e>
    13be:	7ec040ef          	jal	5baa <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	390040ef          	jal	5754 <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	38c040ef          	jal	5764 <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	368040ef          	jal	574c <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	384040ef          	jal	577c <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000da17          	auipc	s4,0xd
    1404:	8f8a0a13          	addi	s4,s4,-1800 # dcf8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	35c040ef          	jal	576c <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000d797          	auipc	a5,0xd
    141e:	8de78793          	addi	a5,a5,-1826 # dcf8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	25450513          	addi	a0,a0,596 # 66b0 <malloc+0xa4e>
    1464:	746040ef          	jal	5baa <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	2ea040ef          	jal	5754 <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	300040ef          	jal	577c <close>
    for (n = 0; n < N; n++) {
    1480:	0000db17          	auipc	s6,0xd
    1484:	878b0b13          	addi	s6,s6,-1928 # dcf8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x476>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	2bc040ef          	jal	5774 <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	284040ef          	jal	5754 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	1f250513          	addi	a0,a0,498 # 66c8 <malloc+0xa66>
    14de:	6cc040ef          	jal	5baa <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	270040ef          	jal	5754 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	1f650513          	addi	a0,a0,502 # 66e0 <malloc+0xa7e>
    14f2:	6b8040ef          	jal	5baa <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	1dc50513          	addi	a0,a0,476 # 66f8 <malloc+0xa96>
    1524:	686040ef          	jal	5baa <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	22a040ef          	jal	5754 <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	244040ef          	jal	577c <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	21c040ef          	jal	575c <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	20c040ef          	jal	5754 <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	1c050513          	addi	a0,a0,448 # 6718 <malloc+0xab6>
    1560:	64a040ef          	jal	5baa <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	1ee040ef          	jal	5754 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	1c4040ef          	jal	574c <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	1c6040ef          	jal	575c <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	06850513          	addi	a0,a0,104 # 6628 <malloc+0x9c6>
    15c8:	5e2040ef          	jal	5baa <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	186040ef          	jal	5754 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	15c50513          	addi	a0,a0,348 # 6730 <malloc+0xace>
    15dc:	5ce040ef          	jal	5baa <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	172040ef          	jal	5754 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	16050513          	addi	a0,a0,352 # 6748 <malloc+0xae6>
    15f0:	5ba040ef          	jal	5baa <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	15e040ef          	jal	5754 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	158040ef          	jal	5754 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	13a040ef          	jal	574c <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	130040ef          	jal	574c <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	134040ef          	jal	575c <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	12e040ef          	jal	575c <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	fe450513          	addi	a0,a0,-28 # 6628 <malloc+0x9c6>
    164c:	55e040ef          	jal	5baa <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	102040ef          	jal	5754 <exit>
      exit(0);
    1656:	0fe040ef          	jal	5754 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	fcc50513          	addi	a0,a0,-52 # 6628 <malloc+0x9c6>
    1664:	546040ef          	jal	5baa <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	0ea040ef          	jal	5754 <exit>
        exit(0);
    166e:	0e6040ef          	jal	5754 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	0ce040ef          	jal	574c <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	0c4040ef          	jal	574c <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	0c6040ef          	jal	575c <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	0b8040ef          	jal	575c <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	0ae50513          	addi	a0,a0,174 # 6768 <malloc+0xb06>
    16c2:	4e8040ef          	jal	5baa <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	08c040ef          	jal	5754 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	07c040ef          	jal	574c <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	080040ef          	jal	575c <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	06e040ef          	jal	5754 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	068040ef          	jal	5754 <exit>
          exit(0);
    16f0:	064040ef          	jal	5754 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	08250513          	addi	a0,a0,130 # 6778 <malloc+0xb16>
    16fe:	4ac040ef          	jal	5baa <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	050040ef          	jal	5754 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	036040ef          	jal	574c <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	03a040ef          	jal	575c <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	028040ef          	jal	5754 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	5e850513          	addi	a0,a0,1512 # 7d18 <malloc+0x20b6>
    1738:	472040ef          	jal	5baa <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	016040ef          	jal	5754 <exit>
      fork();
    1742:	00a040ef          	jal	574c <fork>
      fork();
    1746:	006040ef          	jal	574c <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	008040ef          	jal	5754 <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	7d9030ef          	jal	574c <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	7cf030ef          	jal	575c <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000913          	li	s2,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00005517          	auipc	a0,0x5
    17c0:	e6c50513          	addi	a0,a0,-404 # 6628 <malloc+0x9c6>
    17c4:	3e6040ef          	jal	5baa <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	78b030ef          	jal	5754 <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	fb050513          	addi	a0,a0,-80 # 6798 <malloc+0xb36>
    17f0:	3ba040ef          	jal	5baa <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	75f030ef          	jal	5754 <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	797030ef          	jal	57a4 <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	771030ef          	jal	5794 <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	751030ef          	jal	577c <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	713030ef          	jal	5754 <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	f6850513          	addi	a0,a0,-152 # 67b0 <malloc+0xb4e>
    1850:	35a040ef          	jal	5baa <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	6ff030ef          	jal	5754 <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	6f9030ef          	jal	5754 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1860:	054bf263          	bgeu	s7,s4,18a4 <createdelete+0x154>
      if (fd >= 0)
    1864:	04055e63          	bgez	a0,18c0 <createdelete+0x170>
    for (pi = 0; pi < NCHILD; pi++) {
    1868:	2485                	addiw	s1,s1,1
    186a:	0ff4f493          	zext.b	s1,s1
    186e:	05648c63          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    1872:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1876:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    187a:	4581                	li	a1,0
    187c:	8562                	mv	a0,s8
    187e:	717030ef          	jal	5794 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1882:	01f5579b          	srliw	a5,a0,0x1f
    1886:	dfe9                	beqz	a5,1860 <createdelete+0x110>
    1888:	fc098ce3          	beqz	s3,1860 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    188c:	f7040613          	addi	a2,s0,-144
    1890:	85ee                	mv	a1,s11
    1892:	00005517          	auipc	a0,0x5
    1896:	f3650513          	addi	a0,a0,-202 # 67c8 <malloc+0xb66>
    189a:	310040ef          	jal	5baa <printf>
        exit(1);
    189e:	4505                	li	a0,1
    18a0:	6b5030ef          	jal	5754 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18a4:	fc0542e3          	bltz	a0,1868 <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    18a8:	f7040613          	addi	a2,s0,-144
    18ac:	85ee                	mv	a1,s11
    18ae:	00005517          	auipc	a0,0x5
    18b2:	f4250513          	addi	a0,a0,-190 # 67f0 <malloc+0xb8e>
    18b6:	2f4040ef          	jal	5baa <printf>
        exit(1);
    18ba:	4505                	li	a0,1
    18bc:	699030ef          	jal	5754 <exit>
        close(fd);
    18c0:	6bd030ef          	jal	577c <close>
    18c4:	b755                	j	1868 <createdelete+0x118>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2905                	addiw	s2,s2,1
    18cc:	0ff97913          	zext.b	s2,s2
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab993          	seqz	s3,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f9e9b3          	or	s3,s3,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	b779                	j	1872 <createdelete+0x122>
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	69f030ef          	jal	57a4 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	4ae50513          	addi	a0,a0,1198 # 5e08 <malloc+0x1a6>
    1962:	643030ef          	jal	57a4 <unlink>
  pid = fork();
    1966:	5e7030ef          	jal	574c <fork>
  if (pid < 0) {
    196a:	04054363          	bltz	a0,19b0 <linkunlink+0x74>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	06100913          	li	s2,97
    1974:	c111                	beqz	a0,1978 <linkunlink+0x3c>
    1976:	4905                	li	s2,1
    1978:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    197c:	41c65ab7          	lui	s5,0x41c65
    1980:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c54175>
    1984:	6a0d                	lui	s4,0x3
    1986:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4af>
    if ((x % 3) == 0) {
    198a:	000ab9b7          	lui	s3,0xab
    198e:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99db3>
    1992:	09b2                	slli	s3,s3,0xc
    1994:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    1998:	4b85                	li	s7,1
      unlink("x");
    199a:	00004b17          	auipc	s6,0x4
    199e:	46eb0b13          	addi	s6,s6,1134 # 5e08 <malloc+0x1a6>
      link("cat", "x");
    19a2:	00005c97          	auipc	s9,0x5
    19a6:	e76c8c93          	addi	s9,s9,-394 # 6818 <malloc+0xbb6>
      close(open("x", O_RDWR | O_CREATE));
    19aa:	20200c13          	li	s8,514
    19ae:	a03d                	j	19dc <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    19b0:	85a6                	mv	a1,s1
    19b2:	00005517          	auipc	a0,0x5
    19b6:	c7650513          	addi	a0,a0,-906 # 6628 <malloc+0x9c6>
    19ba:	1f0040ef          	jal	5baa <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	595030ef          	jal	5754 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19c4:	85e2                	mv	a1,s8
    19c6:	855a                	mv	a0,s6
    19c8:	5cd030ef          	jal	5794 <open>
    19cc:	5b1030ef          	jal	577c <close>
    19d0:	a021                	j	19d8 <linkunlink+0x9c>
      unlink("x");
    19d2:	855a                	mv	a0,s6
    19d4:	5d1030ef          	jal	57a4 <unlink>
  for (i = 0; i < 100; i++) {
    19d8:	34fd                	addiw	s1,s1,-1
    19da:	c885                	beqz	s1,1a0a <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    19dc:	035907bb          	mulw	a5,s2,s5
    19e0:	00fa07bb          	addw	a5,s4,a5
    19e4:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19e6:	02079713          	slli	a4,a5,0x20
    19ea:	9301                	srli	a4,a4,0x20
    19ec:	03370733          	mul	a4,a4,s3
    19f0:	9305                	srli	a4,a4,0x21
    19f2:	0017169b          	slliw	a3,a4,0x1
    19f6:	9f35                	addw	a4,a4,a3
    19f8:	9f99                	subw	a5,a5,a4
    19fa:	d7e9                	beqz	a5,19c4 <linkunlink+0x88>
    } else if ((x % 3) == 1) {
    19fc:	fd779be3          	bne	a5,s7,19d2 <linkunlink+0x96>
      link("cat", "x");
    1a00:	85da                	mv	a1,s6
    1a02:	8566                	mv	a0,s9
    1a04:	5b1030ef          	jal	57b4 <link>
    1a08:	bfc1                	j	19d8 <linkunlink+0x9c>
  if (pid)
    1a0a:	020d0363          	beqz	s10,1a30 <linkunlink+0xf4>
    wait(0);
    1a0e:	4501                	li	a0,0
    1a10:	54d030ef          	jal	575c <wait>
}
    1a14:	60e6                	ld	ra,88(sp)
    1a16:	6446                	ld	s0,80(sp)
    1a18:	64a6                	ld	s1,72(sp)
    1a1a:	6906                	ld	s2,64(sp)
    1a1c:	79e2                	ld	s3,56(sp)
    1a1e:	7a42                	ld	s4,48(sp)
    1a20:	7aa2                	ld	s5,40(sp)
    1a22:	7b02                	ld	s6,32(sp)
    1a24:	6be2                	ld	s7,24(sp)
    1a26:	6c42                	ld	s8,16(sp)
    1a28:	6ca2                	ld	s9,8(sp)
    1a2a:	6d02                	ld	s10,0(sp)
    1a2c:	6125                	addi	sp,sp,96
    1a2e:	8082                	ret
    exit(0);
    1a30:	4501                	li	a0,0
    1a32:	523030ef          	jal	5754 <exit>

0000000000001a36 <forktest>:
{
    1a36:	7179                	addi	sp,sp,-48
    1a38:	f406                	sd	ra,40(sp)
    1a3a:	f022                	sd	s0,32(sp)
    1a3c:	ec26                	sd	s1,24(sp)
    1a3e:	e84a                	sd	s2,16(sp)
    1a40:	e44e                	sd	s3,8(sp)
    1a42:	1800                	addi	s0,sp,48
    1a44:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a46:	4481                	li	s1,0
    1a48:	3e800913          	li	s2,1000
    pid = fork();
    1a4c:	501030ef          	jal	574c <fork>
    if (pid < 0)
    1a50:	06054063          	bltz	a0,1ab0 <forktest+0x7a>
    if (pid == 0)
    1a54:	cd11                	beqz	a0,1a70 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a56:	2485                	addiw	s1,s1,1
    1a58:	ff249ae3          	bne	s1,s2,1a4c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a5c:	85ce                	mv	a1,s3
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	e0a50513          	addi	a0,a0,-502 # 6868 <malloc+0xc06>
    1a66:	144040ef          	jal	5baa <printf>
    exit(1);
    1a6a:	4505                	li	a0,1
    1a6c:	4e9030ef          	jal	5754 <exit>
      exit(0);
    1a70:	4e5030ef          	jal	5754 <exit>
    printf("%s: no fork at all!\n", s);
    1a74:	85ce                	mv	a1,s3
    1a76:	00005517          	auipc	a0,0x5
    1a7a:	daa50513          	addi	a0,a0,-598 # 6820 <malloc+0xbbe>
    1a7e:	12c040ef          	jal	5baa <printf>
    exit(1);
    1a82:	4505                	li	a0,1
    1a84:	4d1030ef          	jal	5754 <exit>
      printf("%s: wait stopped early\n", s);
    1a88:	85ce                	mv	a1,s3
    1a8a:	00005517          	auipc	a0,0x5
    1a8e:	dae50513          	addi	a0,a0,-594 # 6838 <malloc+0xbd6>
    1a92:	118040ef          	jal	5baa <printf>
      exit(1);
    1a96:	4505                	li	a0,1
    1a98:	4bd030ef          	jal	5754 <exit>
    printf("%s: wait got too many\n", s);
    1a9c:	85ce                	mv	a1,s3
    1a9e:	00005517          	auipc	a0,0x5
    1aa2:	db250513          	addi	a0,a0,-590 # 6850 <malloc+0xbee>
    1aa6:	104040ef          	jal	5baa <printf>
    exit(1);
    1aaa:	4505                	li	a0,1
    1aac:	4a9030ef          	jal	5754 <exit>
  if (n == 0) {
    1ab0:	d0f1                	beqz	s1,1a74 <forktest+0x3e>
  for (; n > 0; n--) {
    1ab2:	00905963          	blez	s1,1ac4 <forktest+0x8e>
    if (wait(0) < 0) {
    1ab6:	4501                	li	a0,0
    1ab8:	4a5030ef          	jal	575c <wait>
    1abc:	fc0546e3          	bltz	a0,1a88 <forktest+0x52>
  for (; n > 0; n--) {
    1ac0:	34fd                	addiw	s1,s1,-1
    1ac2:	f8f5                	bnez	s1,1ab6 <forktest+0x80>
  if (wait(0) != -1) {
    1ac4:	4501                	li	a0,0
    1ac6:	497030ef          	jal	575c <wait>
    1aca:	57fd                	li	a5,-1
    1acc:	fcf518e3          	bne	a0,a5,1a9c <forktest+0x66>
}
    1ad0:	70a2                	ld	ra,40(sp)
    1ad2:	7402                	ld	s0,32(sp)
    1ad4:	64e2                	ld	s1,24(sp)
    1ad6:	6942                	ld	s2,16(sp)
    1ad8:	69a2                	ld	s3,8(sp)
    1ada:	6145                	addi	sp,sp,48
    1adc:	8082                	ret

0000000000001ade <kernmem>:
{
    1ade:	715d                	addi	sp,sp,-80
    1ae0:	e486                	sd	ra,72(sp)
    1ae2:	e0a2                	sd	s0,64(sp)
    1ae4:	fc26                	sd	s1,56(sp)
    1ae6:	f84a                	sd	s2,48(sp)
    1ae8:	f44e                	sd	s3,40(sp)
    1aea:	f052                	sd	s4,32(sp)
    1aec:	ec56                	sd	s5,24(sp)
    1aee:	e85a                	sd	s6,16(sp)
    1af0:	0880                	addi	s0,sp,80
    1af2:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1af4:	4485                	li	s1,1
    1af6:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1af8:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1afc:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afe:	69b1                	lui	s3,0xc
    1b00:	35098993          	addi	s3,s3,848 # c350 <uninit+0xd68>
    1b04:	1003d937          	lui	s2,0x1003d
    1b08:	090e                	slli	s2,s2,0x3
    1b0a:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c788>
    pid = fork();
    1b0e:	43f030ef          	jal	574c <fork>
    if (pid < 0) {
    1b12:	02054763          	bltz	a0,1b40 <kernmem+0x62>
    if (pid == 0) {
    1b16:	cd1d                	beqz	a0,1b54 <kernmem+0x76>
    wait(&xstatus);
    1b18:	8556                	mv	a0,s5
    1b1a:	443030ef          	jal	575c <wait>
    if (xstatus != -1) // did kernel kill child?
    1b1e:	fbc42783          	lw	a5,-68(s0)
    1b22:	05479663          	bne	a5,s4,1b6e <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b26:	94ce                	add	s1,s1,s3
    1b28:	ff2493e3          	bne	s1,s2,1b0e <kernmem+0x30>
}
    1b2c:	60a6                	ld	ra,72(sp)
    1b2e:	6406                	ld	s0,64(sp)
    1b30:	74e2                	ld	s1,56(sp)
    1b32:	7942                	ld	s2,48(sp)
    1b34:	79a2                	ld	s3,40(sp)
    1b36:	7a02                	ld	s4,32(sp)
    1b38:	6ae2                	ld	s5,24(sp)
    1b3a:	6b42                	ld	s6,16(sp)
    1b3c:	6161                	addi	sp,sp,80
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85da                	mv	a1,s6
    1b42:	00005517          	auipc	a0,0x5
    1b46:	ae650513          	addi	a0,a0,-1306 # 6628 <malloc+0x9c6>
    1b4a:	060040ef          	jal	5baa <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	405030ef          	jal	5754 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b54:	0004c683          	lbu	a3,0(s1)
    1b58:	8626                	mv	a2,s1
    1b5a:	85da                	mv	a1,s6
    1b5c:	00005517          	auipc	a0,0x5
    1b60:	d3450513          	addi	a0,a0,-716 # 6890 <malloc+0xc2e>
    1b64:	046040ef          	jal	5baa <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	3eb030ef          	jal	5754 <exit>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	3e5030ef          	jal	5754 <exit>

0000000000001b74 <MAXVAplus>:
{
    1b74:	7139                	addi	sp,sp,-64
    1b76:	fc06                	sd	ra,56(sp)
    1b78:	f822                	sd	s0,48(sp)
    1b7a:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b7c:	4785                	li	a5,1
    1b7e:	179a                	slli	a5,a5,0x26
    1b80:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b84:	fc843783          	ld	a5,-56(s0)
    1b88:	cf9d                	beqz	a5,1bc6 <MAXVAplus+0x52>
    1b8a:	f426                	sd	s1,40(sp)
    1b8c:	f04a                	sd	s2,32(sp)
    1b8e:	ec4e                	sd	s3,24(sp)
    1b90:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b92:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b96:	54fd                	li	s1,-1
    pid = fork();
    1b98:	3b5030ef          	jal	574c <fork>
    if (pid < 0) {
    1b9c:	02054963          	bltz	a0,1bce <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba0:	c129                	beqz	a0,1be2 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba2:	854a                	mv	a0,s2
    1ba4:	3b9030ef          	jal	575c <wait>
    if (xstatus != -1) // did kernel kill child?
    1ba8:	fc442783          	lw	a5,-60(s0)
    1bac:	04979d63          	bne	a5,s1,1c06 <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb0:	fc843783          	ld	a5,-56(s0)
    1bb4:	0786                	slli	a5,a5,0x1
    1bb6:	fcf43423          	sd	a5,-56(s0)
    1bba:	fc843783          	ld	a5,-56(s0)
    1bbe:	ffe9                	bnez	a5,1b98 <MAXVAplus+0x24>
    1bc0:	74a2                	ld	s1,40(sp)
    1bc2:	7902                	ld	s2,32(sp)
    1bc4:	69e2                	ld	s3,24(sp)
}
    1bc6:	70e2                	ld	ra,56(sp)
    1bc8:	7442                	ld	s0,48(sp)
    1bca:	6121                	addi	sp,sp,64
    1bcc:	8082                	ret
      printf("%s: fork failed\n", s);
    1bce:	85ce                	mv	a1,s3
    1bd0:	00005517          	auipc	a0,0x5
    1bd4:	a5850513          	addi	a0,a0,-1448 # 6628 <malloc+0x9c6>
    1bd8:	7d3030ef          	jal	5baa <printf>
      exit(1);
    1bdc:	4505                	li	a0,1
    1bde:	377030ef          	jal	5754 <exit>
      *(char *)a = 99;
    1be2:	fc843783          	ld	a5,-56(s0)
    1be6:	06300713          	li	a4,99
    1bea:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bee:	fc843603          	ld	a2,-56(s0)
    1bf2:	85ce                	mv	a1,s3
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	cbc50513          	addi	a0,a0,-836 # 68b0 <malloc+0xc4e>
    1bfc:	7af030ef          	jal	5baa <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	353030ef          	jal	5754 <exit>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	34d030ef          	jal	5754 <exit>

0000000000001c0c <stacktest>:
{
    1c0c:	7179                	addi	sp,sp,-48
    1c0e:	f406                	sd	ra,40(sp)
    1c10:	f022                	sd	s0,32(sp)
    1c12:	ec26                	sd	s1,24(sp)
    1c14:	1800                	addi	s0,sp,48
    1c16:	84aa                	mv	s1,a0
  pid = fork();
    1c18:	335030ef          	jal	574c <fork>
  if (pid == 0) {
    1c1c:	cd11                	beqz	a0,1c38 <stacktest+0x2c>
  } else if (pid < 0) {
    1c1e:	02054c63          	bltz	a0,1c56 <stacktest+0x4a>
  wait(&xstatus);
    1c22:	fdc40513          	addi	a0,s0,-36
    1c26:	337030ef          	jal	575c <wait>
  if (xstatus == -1) // kernel killed child?
    1c2a:	fdc42503          	lw	a0,-36(s0)
    1c2e:	57fd                	li	a5,-1
    1c30:	02f50d63          	beq	a0,a5,1c6a <stacktest+0x5e>
    exit(xstatus);
    1c34:	321030ef          	jal	5754 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c38:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c3a:	80078793          	addi	a5,a5,-2048
    1c3e:	8007c603          	lbu	a2,-2048(a5)
    1c42:	85a6                	mv	a1,s1
    1c44:	00005517          	auipc	a0,0x5
    1c48:	c8450513          	addi	a0,a0,-892 # 68c8 <malloc+0xc66>
    1c4c:	75f030ef          	jal	5baa <printf>
    exit(1);
    1c50:	4505                	li	a0,1
    1c52:	303030ef          	jal	5754 <exit>
    printf("%s: fork failed\n", s);
    1c56:	85a6                	mv	a1,s1
    1c58:	00005517          	auipc	a0,0x5
    1c5c:	9d050513          	addi	a0,a0,-1584 # 6628 <malloc+0x9c6>
    1c60:	74b030ef          	jal	5baa <printf>
    exit(1);
    1c64:	4505                	li	a0,1
    1c66:	2ef030ef          	jal	5754 <exit>
    exit(0);
    1c6a:	4501                	li	a0,0
    1c6c:	2e9030ef          	jal	5754 <exit>

0000000000001c70 <nowrite>:
{
    1c70:	7159                	addi	sp,sp,-112
    1c72:	f486                	sd	ra,104(sp)
    1c74:	f0a2                	sd	s0,96(sp)
    1c76:	eca6                	sd	s1,88(sp)
    1c78:	e8ca                	sd	s2,80(sp)
    1c7a:	e4ce                	sd	s3,72(sp)
    1c7c:	e0d2                	sd	s4,64(sp)
    1c7e:	1880                	addi	s0,sp,112
    1c80:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c82:	00007797          	auipc	a5,0x7
    1c86:	a0e78793          	addi	a5,a5,-1522 # 8690 <malloc+0x2a2e>
    1c8a:	7788                	ld	a0,40(a5)
    1c8c:	7b8c                	ld	a1,48(a5)
    1c8e:	7f90                	ld	a2,56(a5)
    1c90:	63b4                	ld	a3,64(a5)
    1c92:	67b8                	ld	a4,72(a5)
    1c94:	f8a43c23          	sd	a0,-104(s0)
    1c98:	fab43023          	sd	a1,-96(s0)
    1c9c:	fac43423          	sd	a2,-88(s0)
    1ca0:	fad43823          	sd	a3,-80(s0)
    1ca4:	fae43c23          	sd	a4,-72(s0)
    1ca8:	6bbc                	ld	a5,80(a5)
    1caa:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cae:	4481                	li	s1,0
    wait(&xstatus);
    1cb0:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4999                	li	s3,6
    pid = fork();
    1cb6:	297030ef          	jal	574c <fork>
    if (pid == 0) {
    1cba:	cd19                	beqz	a0,1cd8 <nowrite+0x68>
    } else if (pid < 0) {
    1cbc:	04054163          	bltz	a0,1cfe <nowrite+0x8e>
    wait(&xstatus);
    1cc0:	854a                	mv	a0,s2
    1cc2:	29b030ef          	jal	575c <wait>
    if (xstatus == 0) {
    1cc6:	fcc42783          	lw	a5,-52(s0)
    1cca:	c7a1                	beqz	a5,1d12 <nowrite+0xa2>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1ccc:	2485                	addiw	s1,s1,1
    1cce:	ff3494e3          	bne	s1,s3,1cb6 <nowrite+0x46>
  exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	281030ef          	jal	5754 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cd8:	048e                	slli	s1,s1,0x3
    1cda:	fd048793          	addi	a5,s1,-48
    1cde:	008784b3          	add	s1,a5,s0
    1ce2:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1ce6:	47a9                	li	a5,10
    1ce8:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cea:	85d2                	mv	a1,s4
    1cec:	00005517          	auipc	a0,0x5
    1cf0:	c0450513          	addi	a0,a0,-1020 # 68f0 <malloc+0xc8e>
    1cf4:	6b7030ef          	jal	5baa <printf>
      exit(0);
    1cf8:	4501                	li	a0,0
    1cfa:	25b030ef          	jal	5754 <exit>
      printf("%s: fork failed\n", s);
    1cfe:	85d2                	mv	a1,s4
    1d00:	00005517          	auipc	a0,0x5
    1d04:	92850513          	addi	a0,a0,-1752 # 6628 <malloc+0x9c6>
    1d08:	6a3030ef          	jal	5baa <printf>
      exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	247030ef          	jal	5754 <exit>
      exit(1);
    1d12:	4505                	li	a0,1
    1d14:	241030ef          	jal	5754 <exit>

0000000000001d18 <manywrites>:
{
    1d18:	7159                	addi	sp,sp,-112
    1d1a:	f486                	sd	ra,104(sp)
    1d1c:	f0a2                	sd	s0,96(sp)
    1d1e:	eca6                	sd	s1,88(sp)
    1d20:	e8ca                	sd	s2,80(sp)
    1d22:	e4ce                	sd	s3,72(sp)
    1d24:	ec66                	sd	s9,24(sp)
    1d26:	1880                	addi	s0,sp,112
    1d28:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2a:	4901                	li	s2,0
    1d2c:	4991                	li	s3,4
    int pid = fork();
    1d2e:	21f030ef          	jal	574c <fork>
    1d32:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d34:	02054c63          	bltz	a0,1d6c <manywrites+0x54>
    if (pid == 0) {
    1d38:	c929                	beqz	a0,1d8a <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3a:	2905                	addiw	s2,s2,1
    1d3c:	ff3919e3          	bne	s2,s3,1d2e <manywrites+0x16>
    1d40:	4491                	li	s1,4
    wait(&st);
    1d42:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d46:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4a:	854a                	mv	a0,s2
    1d4c:	211030ef          	jal	575c <wait>
    if (st != 0)
    1d50:	f9842503          	lw	a0,-104(s0)
    1d54:	0e051763          	bnez	a0,1e42 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d58:	34fd                	addiw	s1,s1,-1
    1d5a:	f4f5                	bnez	s1,1d46 <manywrites+0x2e>
    1d5c:	e0d2                	sd	s4,64(sp)
    1d5e:	fc56                	sd	s5,56(sp)
    1d60:	f85a                	sd	s6,48(sp)
    1d62:	f45e                	sd	s7,40(sp)
    1d64:	f062                	sd	s8,32(sp)
    1d66:	e86a                	sd	s10,16(sp)
  exit(0);
    1d68:	1ed030ef          	jal	5754 <exit>
    1d6c:	e0d2                	sd	s4,64(sp)
    1d6e:	fc56                	sd	s5,56(sp)
    1d70:	f85a                	sd	s6,48(sp)
    1d72:	f45e                	sd	s7,40(sp)
    1d74:	f062                	sd	s8,32(sp)
    1d76:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d78:	00006517          	auipc	a0,0x6
    1d7c:	fa050513          	addi	a0,a0,-96 # 7d18 <malloc+0x20b6>
    1d80:	62b030ef          	jal	5baa <printf>
      exit(1);
    1d84:	4505                	li	a0,1
    1d86:	1cf030ef          	jal	5754 <exit>
    1d8a:	e0d2                	sd	s4,64(sp)
    1d8c:	fc56                	sd	s5,56(sp)
    1d8e:	f85a                	sd	s6,48(sp)
    1d90:	f45e                	sd	s7,40(sp)
    1d92:	f062                	sd	s8,32(sp)
    1d94:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d96:	06200793          	li	a5,98
    1d9a:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1d9e:	0619079b          	addiw	a5,s2,97
    1da2:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1da6:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1daa:	f9840513          	addi	a0,s0,-104
    1dae:	1f7030ef          	jal	57a4 <unlink>
    1db2:	47f9                	li	a5,30
    1db4:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1db6:	f9840b93          	addi	s7,s0,-104
    1dba:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dbe:	6a8d                	lui	s5,0x3
    1dc0:	0000cc17          	auipc	s8,0xc
    1dc4:	f38c0c13          	addi	s8,s8,-200 # dcf8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dc8:	8a26                	mv	s4,s1
    1dca:	02094563          	bltz	s2,1df4 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dce:	85da                	mv	a1,s6
    1dd0:	855e                	mv	a0,s7
    1dd2:	1c3030ef          	jal	5794 <open>
    1dd6:	89aa                	mv	s3,a0
          if (fd < 0) {
    1dd8:	02054d63          	bltz	a0,1e12 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1ddc:	8656                	mv	a2,s5
    1dde:	85e2                	mv	a1,s8
    1de0:	195030ef          	jal	5774 <write>
          if (cc != sz) {
    1de4:	05551363          	bne	a0,s5,1e2a <manywrites+0x112>
          close(fd);
    1de8:	854e                	mv	a0,s3
    1dea:	193030ef          	jal	577c <close>
        for (int i = 0; i < ci + 1; i++) {
    1dee:	2a05                	addiw	s4,s4,1
    1df0:	fd495fe3          	bge	s2,s4,1dce <manywrites+0xb6>
        unlink(name);
    1df4:	f9840513          	addi	a0,s0,-104
    1df8:	1ad030ef          	jal	57a4 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1dfc:	fffd079b          	addiw	a5,s10,-1
    1e00:	8d3e                	mv	s10,a5
    1e02:	f3f9                	bnez	a5,1dc8 <manywrites+0xb0>
      unlink(name);
    1e04:	f9840513          	addi	a0,s0,-104
    1e08:	19d030ef          	jal	57a4 <unlink>
      exit(0);
    1e0c:	4501                	li	a0,0
    1e0e:	147030ef          	jal	5754 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e12:	f9840613          	addi	a2,s0,-104
    1e16:	85e6                	mv	a1,s9
    1e18:	00005517          	auipc	a0,0x5
    1e1c:	af850513          	addi	a0,a0,-1288 # 6910 <malloc+0xcae>
    1e20:	58b030ef          	jal	5baa <printf>
            exit(1);
    1e24:	4505                	li	a0,1
    1e26:	12f030ef          	jal	5754 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2a:	86aa                	mv	a3,a0
    1e2c:	660d                	lui	a2,0x3
    1e2e:	85e6                	mv	a1,s9
    1e30:	00004517          	auipc	a0,0x4
    1e34:	03850513          	addi	a0,a0,56 # 5e68 <malloc+0x206>
    1e38:	573030ef          	jal	5baa <printf>
            exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	117030ef          	jal	5754 <exit>
    1e42:	e0d2                	sd	s4,64(sp)
    1e44:	fc56                	sd	s5,56(sp)
    1e46:	f85a                	sd	s6,48(sp)
    1e48:	f45e                	sd	s7,40(sp)
    1e4a:	f062                	sd	s8,32(sp)
    1e4c:	e86a                	sd	s10,16(sp)
      exit(st);
    1e4e:	107030ef          	jal	5754 <exit>

0000000000001e52 <copyinstr3>:
{
    1e52:	7179                	addi	sp,sp,-48
    1e54:	f406                	sd	ra,40(sp)
    1e56:	f022                	sd	s0,32(sp)
    1e58:	ec26                	sd	s1,24(sp)
    1e5a:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e5c:	6509                	lui	a0,0x2
    1e5e:	0c3030ef          	jal	5720 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e62:	4501                	li	a0,0
    1e64:	0bd030ef          	jal	5720 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e68:	03451793          	slli	a5,a0,0x34
    1e6c:	e7bd                	bnez	a5,1eda <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e6e:	4501                	li	a0,0
    1e70:	0b1030ef          	jal	5720 <sbrk>
  if (top % PGSIZE) {
    1e74:	03451793          	slli	a5,a0,0x34
    1e78:	ebad                	bnez	a5,1eea <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7a:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa9>
  *b = 'x';
    1e7e:	07800793          	li	a5,120
    1e82:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e86:	8526                	mv	a0,s1
    1e88:	11d030ef          	jal	57a4 <unlink>
  if (ret != -1) {
    1e8c:	57fd                	li	a5,-1
    1e8e:	06f51763          	bne	a0,a5,1efc <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e92:	20100593          	li	a1,513
    1e96:	8526                	mv	a0,s1
    1e98:	0fd030ef          	jal	5794 <open>
  if (fd != -1) {
    1e9c:	57fd                	li	a5,-1
    1e9e:	06f51a63          	bne	a0,a5,1f12 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea2:	85a6                	mv	a1,s1
    1ea4:	8526                	mv	a0,s1
    1ea6:	10f030ef          	jal	57b4 <link>
  if (ret != -1) {
    1eaa:	57fd                	li	a5,-1
    1eac:	06f51e63          	bne	a0,a5,1f28 <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb0:	00005797          	auipc	a5,0x5
    1eb4:	76078793          	addi	a5,a5,1888 # 7610 <malloc+0x19ae>
    1eb8:	fcf43823          	sd	a5,-48(s0)
    1ebc:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec0:	fd040593          	addi	a1,s0,-48
    1ec4:	8526                	mv	a0,s1
    1ec6:	0c7030ef          	jal	578c <exec>
  if (ret != -1) {
    1eca:	57fd                	li	a5,-1
    1ecc:	06f51a63          	bne	a0,a5,1f40 <copyinstr3+0xee>
}
    1ed0:	70a2                	ld	ra,40(sp)
    1ed2:	7402                	ld	s0,32(sp)
    1ed4:	64e2                	ld	s1,24(sp)
    1ed6:	6145                	addi	sp,sp,48
    1ed8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1eda:	0347d513          	srli	a0,a5,0x34
    1ede:	6785                	lui	a5,0x1
    1ee0:	40a7853b          	subw	a0,a5,a0
    1ee4:	03d030ef          	jal	5720 <sbrk>
    1ee8:	b759                	j	1e6e <copyinstr3+0x1c>
    printf("oops\n");
    1eea:	00005517          	auipc	a0,0x5
    1eee:	a3e50513          	addi	a0,a0,-1474 # 6928 <malloc+0xcc6>
    1ef2:	4b9030ef          	jal	5baa <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	05d030ef          	jal	5754 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1efc:	862a                	mv	a2,a0
    1efe:	85a6                	mv	a1,s1
    1f00:	00004517          	auipc	a0,0x4
    1f04:	64850513          	addi	a0,a0,1608 # 6548 <malloc+0x8e6>
    1f08:	4a3030ef          	jal	5baa <printf>
    exit(1);
    1f0c:	4505                	li	a0,1
    1f0e:	047030ef          	jal	5754 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f12:	862a                	mv	a2,a0
    1f14:	85a6                	mv	a1,s1
    1f16:	00004517          	auipc	a0,0x4
    1f1a:	65250513          	addi	a0,a0,1618 # 6568 <malloc+0x906>
    1f1e:	48d030ef          	jal	5baa <printf>
    exit(1);
    1f22:	4505                	li	a0,1
    1f24:	031030ef          	jal	5754 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f28:	86aa                	mv	a3,a0
    1f2a:	8626                	mv	a2,s1
    1f2c:	85a6                	mv	a1,s1
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	65a50513          	addi	a0,a0,1626 # 6588 <malloc+0x926>
    1f36:	475030ef          	jal	5baa <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	019030ef          	jal	5754 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f40:	863e                	mv	a2,a5
    1f42:	85a6                	mv	a1,s1
    1f44:	00004517          	auipc	a0,0x4
    1f48:	66c50513          	addi	a0,a0,1644 # 65b0 <malloc+0x94e>
    1f4c:	45f030ef          	jal	5baa <printf>
    exit(1);
    1f50:	4505                	li	a0,1
    1f52:	003030ef          	jal	5754 <exit>

0000000000001f56 <rwsbrk>:
{
    1f56:	1101                	addi	sp,sp,-32
    1f58:	ec06                	sd	ra,24(sp)
    1f5a:	e822                	sd	s0,16(sp)
    1f5c:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f5e:	6509                	lui	a0,0x2
    1f60:	7c0030ef          	jal	5720 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f64:	57fd                	li	a5,-1
    1f66:	04f50a63          	beq	a0,a5,1fba <rwsbrk+0x64>
    1f6a:	e426                	sd	s1,8(sp)
    1f6c:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f6e:	7579                	lui	a0,0xffffe
    1f70:	7b0030ef          	jal	5720 <sbrk>
    1f74:	57fd                	li	a5,-1
    1f76:	04f50d63          	beq	a0,a5,1fd0 <rwsbrk+0x7a>
    1f7a:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f7c:	20100593          	li	a1,513
    1f80:	00005517          	auipc	a0,0x5
    1f84:	9e850513          	addi	a0,a0,-1560 # 6968 <malloc+0xd06>
    1f88:	00d030ef          	jal	5794 <open>
    1f8c:	892a                	mv	s2,a0
  if (fd < 0) {
    1f8e:	04054b63          	bltz	a0,1fe4 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f92:	6785                	lui	a5,0x1
    1f94:	94be                	add	s1,s1,a5
    1f96:	40000613          	li	a2,1024
    1f9a:	85a6                	mv	a1,s1
    1f9c:	7d8030ef          	jal	5774 <write>
    1fa0:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa2:	04054a63          	bltz	a0,1ff6 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1fa6:	85a6                	mv	a1,s1
    1fa8:	00005517          	auipc	a0,0x5
    1fac:	9e050513          	addi	a0,a0,-1568 # 6988 <malloc+0xd26>
    1fb0:	3fb030ef          	jal	5baa <printf>
    exit(1);
    1fb4:	4505                	li	a0,1
    1fb6:	79e030ef          	jal	5754 <exit>
    1fba:	e426                	sd	s1,8(sp)
    1fbc:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fbe:	00005517          	auipc	a0,0x5
    1fc2:	97250513          	addi	a0,a0,-1678 # 6930 <malloc+0xcce>
    1fc6:	3e5030ef          	jal	5baa <printf>
    exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	788030ef          	jal	5754 <exit>
    1fd0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd2:	00005517          	auipc	a0,0x5
    1fd6:	97650513          	addi	a0,a0,-1674 # 6948 <malloc+0xce6>
    1fda:	3d1030ef          	jal	5baa <printf>
    exit(1);
    1fde:	4505                	li	a0,1
    1fe0:	774030ef          	jal	5754 <exit>
    printf("open(rwsbrk) failed\n");
    1fe4:	00005517          	auipc	a0,0x5
    1fe8:	98c50513          	addi	a0,a0,-1652 # 6970 <malloc+0xd0e>
    1fec:	3bf030ef          	jal	5baa <printf>
    exit(1);
    1ff0:	4505                	li	a0,1
    1ff2:	762030ef          	jal	5754 <exit>
  close(fd);
    1ff6:	854a                	mv	a0,s2
    1ff8:	784030ef          	jal	577c <close>
  unlink("rwsbrk");
    1ffc:	00005517          	auipc	a0,0x5
    2000:	96c50513          	addi	a0,a0,-1684 # 6968 <malloc+0xd06>
    2004:	7a0030ef          	jal	57a4 <unlink>
  fd = open("README", O_RDONLY);
    2008:	4581                	li	a1,0
    200a:	00004517          	auipc	a0,0x4
    200e:	f6650513          	addi	a0,a0,-154 # 5f70 <malloc+0x30e>
    2012:	782030ef          	jal	5794 <open>
    2016:	892a                	mv	s2,a0
  if (fd < 0) {
    2018:	02054363          	bltz	a0,203e <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    201c:	4629                	li	a2,10
    201e:	85a6                	mv	a1,s1
    2020:	74c030ef          	jal	576c <read>
    2024:	862a                	mv	a2,a0
  if (n >= 0) {
    2026:	02054563          	bltz	a0,2050 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202a:	85a6                	mv	a1,s1
    202c:	00005517          	auipc	a0,0x5
    2030:	98c50513          	addi	a0,a0,-1652 # 69b8 <malloc+0xd56>
    2034:	377030ef          	jal	5baa <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	71a030ef          	jal	5754 <exit>
    printf("open(README) failed\n");
    203e:	00004517          	auipc	a0,0x4
    2042:	f3a50513          	addi	a0,a0,-198 # 5f78 <malloc+0x316>
    2046:	365030ef          	jal	5baa <printf>
    exit(1);
    204a:	4505                	li	a0,1
    204c:	708030ef          	jal	5754 <exit>
  close(fd);
    2050:	854a                	mv	a0,s2
    2052:	72a030ef          	jal	577c <close>
  exit(0);
    2056:	4501                	li	a0,0
    2058:	6fc030ef          	jal	5754 <exit>

000000000000205c <sbrkbasic>:
{
    205c:	715d                	addi	sp,sp,-80
    205e:	e486                	sd	ra,72(sp)
    2060:	e0a2                	sd	s0,64(sp)
    2062:	ec56                	sd	s5,24(sp)
    2064:	0880                	addi	s0,sp,80
    2066:	8aaa                	mv	s5,a0
  pid = fork();
    2068:	6e4030ef          	jal	574c <fork>
  if (pid < 0) {
    206c:	02054c63          	bltz	a0,20a4 <sbrkbasic+0x48>
  if (pid == 0) {
    2070:	ed31                	bnez	a0,20cc <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2072:	40000537          	lui	a0,0x40000
    2076:	6aa030ef          	jal	5720 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207a:	57fd                	li	a5,-1
    207c:	04f50163          	beq	a0,a5,20be <sbrkbasic+0x62>
    2080:	fc26                	sd	s1,56(sp)
    2082:	f84a                	sd	s2,48(sp)
    2084:	f44e                	sd	s3,40(sp)
    2086:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2088:	400007b7          	lui	a5,0x40000
    208c:	97aa                	add	a5,a5,a0
      *b = 99;
    208e:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2092:	6705                	lui	a4,0x1
      *b = 99;
    2094:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef308>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2098:	953a                	add	a0,a0,a4
    209a:	fef51de3          	bne	a0,a5,2094 <sbrkbasic+0x38>
    exit(1);
    209e:	4505                	li	a0,1
    20a0:	6b4030ef          	jal	5754 <exit>
    20a4:	fc26                	sd	s1,56(sp)
    20a6:	f84a                	sd	s2,48(sp)
    20a8:	f44e                	sd	s3,40(sp)
    20aa:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20ac:	00005517          	auipc	a0,0x5
    20b0:	93450513          	addi	a0,a0,-1740 # 69e0 <malloc+0xd7e>
    20b4:	2f7030ef          	jal	5baa <printf>
    exit(1);
    20b8:	4505                	li	a0,1
    20ba:	69a030ef          	jal	5754 <exit>
    20be:	fc26                	sd	s1,56(sp)
    20c0:	f84a                	sd	s2,48(sp)
    20c2:	f44e                	sd	s3,40(sp)
    20c4:	f052                	sd	s4,32(sp)
      exit(0);
    20c6:	4501                	li	a0,0
    20c8:	68c030ef          	jal	5754 <exit>
  wait(&xstatus);
    20cc:	fbc40513          	addi	a0,s0,-68
    20d0:	68c030ef          	jal	575c <wait>
  if (xstatus == 1) {
    20d4:	fbc42703          	lw	a4,-68(s0)
    20d8:	4785                	li	a5,1
    20da:	02f70063          	beq	a4,a5,20fa <sbrkbasic+0x9e>
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20e6:	4501                	li	a0,0
    20e8:	638030ef          	jal	5720 <sbrk>
    20ec:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20ee:	4901                	li	s2,0
    b = sbrk(1);
    20f0:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f2:	6a05                	lui	s4,0x1
    20f4:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20f8:	a005                	j	2118 <sbrkbasic+0xbc>
    20fa:	fc26                	sd	s1,56(sp)
    20fc:	f84a                	sd	s2,48(sp)
    20fe:	f44e                	sd	s3,40(sp)
    2100:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2102:	85d6                	mv	a1,s5
    2104:	00005517          	auipc	a0,0x5
    2108:	8fc50513          	addi	a0,a0,-1796 # 6a00 <malloc+0xd9e>
    210c:	29f030ef          	jal	5baa <printf>
    exit(1);
    2110:	4505                	li	a0,1
    2112:	642030ef          	jal	5754 <exit>
    2116:	84be                	mv	s1,a5
    b = sbrk(1);
    2118:	854e                	mv	a0,s3
    211a:	606030ef          	jal	5720 <sbrk>
    if (b != a) {
    211e:	04951163          	bne	a0,s1,2160 <sbrkbasic+0x104>
    *b = 1;
    2122:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2126:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212a:	2905                	addiw	s2,s2,1
    212c:	ff4915e3          	bne	s2,s4,2116 <sbrkbasic+0xba>
  pid = fork();
    2130:	61c030ef          	jal	574c <fork>
    2134:	892a                	mv	s2,a0
  if (pid < 0) {
    2136:	04054263          	bltz	a0,217a <sbrkbasic+0x11e>
  c = sbrk(1);
    213a:	4505                	li	a0,1
    213c:	5e4030ef          	jal	5720 <sbrk>
  c = sbrk(1);
    2140:	4505                	li	a0,1
    2142:	5de030ef          	jal	5720 <sbrk>
  if (c != a + 1) {
    2146:	0489                	addi	s1,s1,2
    2148:	04950363          	beq	a0,s1,218e <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    214c:	85d6                	mv	a1,s5
    214e:	00005517          	auipc	a0,0x5
    2152:	91250513          	addi	a0,a0,-1774 # 6a60 <malloc+0xdfe>
    2156:	255030ef          	jal	5baa <printf>
    exit(1);
    215a:	4505                	li	a0,1
    215c:	5f8030ef          	jal	5754 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2160:	872a                	mv	a4,a0
    2162:	86a6                	mv	a3,s1
    2164:	864a                	mv	a2,s2
    2166:	85d6                	mv	a1,s5
    2168:	00005517          	auipc	a0,0x5
    216c:	8b850513          	addi	a0,a0,-1864 # 6a20 <malloc+0xdbe>
    2170:	23b030ef          	jal	5baa <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	5de030ef          	jal	5754 <exit>
    printf("%s: sbrk test fork failed\n", s);
    217a:	85d6                	mv	a1,s5
    217c:	00005517          	auipc	a0,0x5
    2180:	8c450513          	addi	a0,a0,-1852 # 6a40 <malloc+0xdde>
    2184:	227030ef          	jal	5baa <printf>
    exit(1);
    2188:	4505                	li	a0,1
    218a:	5ca030ef          	jal	5754 <exit>
  if (pid == 0)
    218e:	00091563          	bnez	s2,2198 <sbrkbasic+0x13c>
    exit(0);
    2192:	4501                	li	a0,0
    2194:	5c0030ef          	jal	5754 <exit>
  wait(&xstatus);
    2198:	fbc40513          	addi	a0,s0,-68
    219c:	5c0030ef          	jal	575c <wait>
  exit(xstatus);
    21a0:	fbc42503          	lw	a0,-68(s0)
    21a4:	5b0030ef          	jal	5754 <exit>

00000000000021a8 <sbrkmuch>:
{
    21a8:	7179                	addi	sp,sp,-48
    21aa:	f406                	sd	ra,40(sp)
    21ac:	f022                	sd	s0,32(sp)
    21ae:	ec26                	sd	s1,24(sp)
    21b0:	e84a                	sd	s2,16(sp)
    21b2:	e44e                	sd	s3,8(sp)
    21b4:	e052                	sd	s4,0(sp)
    21b6:	1800                	addi	s0,sp,48
    21b8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21ba:	4501                	li	a0,0
    21bc:	564030ef          	jal	5720 <sbrk>
    21c0:	892a                	mv	s2,a0
  a = sbrk(0);
    21c2:	4501                	li	a0,0
    21c4:	55c030ef          	jal	5720 <sbrk>
    21c8:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ca:	06400537          	lui	a0,0x6400
    21ce:	9d05                	subw	a0,a0,s1
    21d0:	550030ef          	jal	5720 <sbrk>
  if (p != a) {
    21d4:	08a49963          	bne	s1,a0,2266 <sbrkmuch+0xbe>
  *lastaddr = 99;
    21d8:	064007b7          	lui	a5,0x6400
    21dc:	06300713          	li	a4,99
    21e0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef307>
  a = sbrk(0);
    21e4:	4501                	li	a0,0
    21e6:	53a030ef          	jal	5720 <sbrk>
    21ea:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21ec:	757d                	lui	a0,0xfffff
    21ee:	532030ef          	jal	5720 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f2:	57fd                	li	a5,-1
    21f4:	08f50363          	beq	a0,a5,227a <sbrkmuch+0xd2>
  c = sbrk(0);
    21f8:	4501                	li	a0,0
    21fa:	526030ef          	jal	5720 <sbrk>
  if (c != a - PGSIZE) {
    21fe:	80048793          	addi	a5,s1,-2048
    2202:	80078793          	addi	a5,a5,-2048
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe6>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	514030ef          	jal	5720 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	50c030ef          	jal	5720 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfe>
    221e:	4501                	li	a0,0
    2220:	500030ef          	jal	5720 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfe>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef307>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x116>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	4e2030ef          	jal	5720 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	4da030ef          	jal	5720 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	4d2030ef          	jal	5720 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x12a>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00005517          	auipc	a0,0x5
    226c:	81850513          	addi	a0,a0,-2024 # 6a80 <malloc+0xe1e>
    2270:	13b030ef          	jal	5baa <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	4de030ef          	jal	5754 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00005517          	auipc	a0,0x5
    2280:	84c50513          	addi	a0,a0,-1972 # 6ac8 <malloc+0xe66>
    2284:	127030ef          	jal	5baa <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	4ca030ef          	jal	5754 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00005517          	auipc	a0,0x5
    2298:	85450513          	addi	a0,a0,-1964 # 6ae8 <malloc+0xe86>
    229c:	10f030ef          	jal	5baa <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	4b2030ef          	jal	5754 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00005517          	auipc	a0,0x5
    22b0:	87c50513          	addi	a0,a0,-1924 # 6b28 <malloc+0xec6>
    22b4:	0f7030ef          	jal	5baa <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	49a030ef          	jal	5754 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	89850513          	addi	a0,a0,-1896 # 6b58 <malloc+0xef6>
    22c8:	0e3030ef          	jal	5baa <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	486030ef          	jal	5754 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00005517          	auipc	a0,0x5
    22dc:	8b850513          	addi	a0,a0,-1864 # 6b90 <malloc+0xf2e>
    22e0:	0cb030ef          	jal	5baa <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	46e030ef          	jal	5754 <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	424030ef          	jal	5720 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00005517          	auipc	a0,0x5
    230a:	8b250513          	addi	a0,a0,-1870 # 6bb8 <malloc+0xf56>
    230e:	486030ef          	jal	5794 <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00005517          	auipc	a0,0x5
    2318:	8a450513          	addi	a0,a0,-1884 # 6bb8 <malloc+0xf56>
    231c:	488030ef          	jal	57a4 <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	44a030ef          	jal	5774 <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	448030ef          	jal	577c <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	3e6030ef          	jal	5720 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	426030ef          	jal	5764 <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00005517          	auipc	a0,0x5
    2358:	86c50513          	addi	a0,a0,-1940 # 6bc0 <malloc+0xf5e>
    235c:	04f030ef          	jal	5baa <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	3f2030ef          	jal	5754 <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00005517          	auipc	a0,0x5
    236c:	87050513          	addi	a0,a0,-1936 # 6bd8 <malloc+0xf76>
    2370:	03b030ef          	jal	5baa <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	3de030ef          	jal	5754 <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	33450513          	addi	a0,a0,820 # 66b0 <malloc+0xa4e>
    2384:	027030ef          	jal	5baa <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	3ca030ef          	jal	5754 <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00005517          	auipc	a0,0x5
    23a2:	85250513          	addi	a0,a0,-1966 # 6bf0 <malloc+0xf8e>
    23a6:	3ee030ef          	jal	5794 <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	36e030ef          	jal	5720 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	3ae030ef          	jal	576c <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	3b8030ef          	jal	577c <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	26a50513          	addi	a0,a0,618 # 6640 <malloc+0x9de>
    23de:	7cc030ef          	jal	5baa <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	370030ef          	jal	5754 <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	35c030ef          	jal	574c <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	326030ef          	jal	5720 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	31e030ef          	jal	5720 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	34c030ef          	jal	5754 <exit>
    printf("fork failed\n");
    240c:	00006517          	auipc	a0,0x6
    2410:	90c50513          	addi	a0,a0,-1780 # 7d18 <malloc+0x20b6>
    2414:	796030ef          	jal	5baa <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	33a030ef          	jal	5754 <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	33c030ef          	jal	575c <wait>
  pid = fork();
    2424:	328030ef          	jal	574c <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	2f2030ef          	jal	5720 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	2e4030ef          	jal	5720 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	312030ef          	jal	5754 <exit>
    printf("fork failed\n");
    2446:	00006517          	auipc	a0,0x6
    244a:	8d250513          	addi	a0,a0,-1838 # 7d18 <malloc+0x20b6>
    244e:	75c030ef          	jal	5baa <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	300030ef          	jal	5754 <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	302030ef          	jal	575c <wait>
  pid = fork();
    245e:	2ee030ef          	jal	574c <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	2b8030ef          	jal	5720 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x220>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	2aa030ef          	jal	5720 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	2a4030ef          	jal	5720 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	2d2030ef          	jal	5754 <exit>
    printf("fork failed\n");
    2486:	00006517          	auipc	a0,0x6
    248a:	89250513          	addi	a0,a0,-1902 # 7d18 <malloc+0x20b6>
    248e:	71c030ef          	jal	5baa <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	2c0030ef          	jal	5754 <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	2c2030ef          	jal	575c <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	2b4030ef          	jal	5754 <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	26a030ef          	jal	5720 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	25e030ef          	jal	5720 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	258030ef          	jal	5720 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	252030ef          	jal	5720 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	24c030ef          	jal	5720 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	2a4030ef          	jal	5794 <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	27a030ef          	jal	5774 <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	27c030ef          	jal	577c <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	28c030ef          	jal	5794 <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	258030ef          	jal	576c <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	1e6030ef          	jal	5720 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	212030ef          	jal	5754 <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef30c>
    2554:	1cc030ef          	jal	5720 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	1c6030ef          	jal	5720 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	0ff7f793          	zext.b	a5,a5
    2568:	fef50fa3          	sb	a5,-1(a0)
}
    256c:	60a2                	ld	ra,8(sp)
    256e:	6402                	ld	s0,0(sp)
    2570:	0141                	addi	sp,sp,16
    2572:	8082                	ret

0000000000002574 <execout>:
{
    2574:	711d                	addi	sp,sp,-96
    2576:	ec86                	sd	ra,88(sp)
    2578:	e8a2                	sd	s0,80(sp)
    257a:	e4a6                	sd	s1,72(sp)
    257c:	e0ca                	sd	s2,64(sp)
    257e:	fc4e                	sd	s3,56(sp)
    2580:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    2582:	4901                	li	s2,0
    2584:	49bd                	li	s3,15
    int pid = fork();
    2586:	1c6030ef          	jal	574c <fork>
    258a:	84aa                	mv	s1,a0
    if (pid < 0) {
    258c:	00054e63          	bltz	a0,25a8 <execout+0x34>
    } else if (pid == 0) {
    2590:	c51d                	beqz	a0,25be <execout+0x4a>
      wait((int *)0);
    2592:	4501                	li	a0,0
    2594:	1c8030ef          	jal	575c <wait>
  for (int avail = 0; avail < 15; avail++) {
    2598:	2905                	addiw	s2,s2,1
    259a:	ff3916e3          	bne	s2,s3,2586 <execout+0x12>
    259e:	f852                	sd	s4,48(sp)
    25a0:	f456                	sd	s5,40(sp)
  exit(0);
    25a2:	4501                	li	a0,0
    25a4:	1b0030ef          	jal	5754 <exit>
    25a8:	f852                	sd	s4,48(sp)
    25aa:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25ac:	00005517          	auipc	a0,0x5
    25b0:	76c50513          	addi	a0,a0,1900 # 7d18 <malloc+0x20b6>
    25b4:	5f6030ef          	jal	5baa <printf>
      exit(1);
    25b8:	4505                	li	a0,1
    25ba:	19a030ef          	jal	5754 <exit>
    25be:	f852                	sd	s4,48(sp)
    25c0:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25c2:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c4:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c6:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c8:	854e                	mv	a0,s3
    25ca:	156030ef          	jal	5720 <sbrk>
        if (a == SBRK_ERROR)
    25ce:	01450663          	beq	a0,s4,25da <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25d2:	954e                	add	a0,a0,s3
    25d4:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d8:	bfc5                	j	25c8 <execout+0x54>
        sbrk(-PGSIZE);
    25da:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25dc:	01205863          	blez	s2,25ec <execout+0x78>
        sbrk(-PGSIZE);
    25e0:	854e                	mv	a0,s3
    25e2:	13e030ef          	jal	5720 <sbrk>
      for (int i = 0; i < avail; i++)
    25e6:	2485                	addiw	s1,s1,1
    25e8:	ff249ce3          	bne	s1,s2,25e0 <execout+0x6c>
      close(1);
    25ec:	4505                	li	a0,1
    25ee:	18e030ef          	jal	577c <close>
      char *args[] = {"echo", "x", 0};
    25f2:	00003797          	auipc	a5,0x3
    25f6:	7a678793          	addi	a5,a5,1958 # 5d98 <malloc+0x136>
    25fa:	faf43423          	sd	a5,-88(s0)
    25fe:	00004797          	auipc	a5,0x4
    2602:	80a78793          	addi	a5,a5,-2038 # 5e08 <malloc+0x1a6>
    2606:	faf43823          	sd	a5,-80(s0)
    260a:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260e:	fa840593          	addi	a1,s0,-88
    2612:	00003517          	auipc	a0,0x3
    2616:	78650513          	addi	a0,a0,1926 # 5d98 <malloc+0x136>
    261a:	172030ef          	jal	578c <exec>
      exit(0);
    261e:	4501                	li	a0,0
    2620:	134030ef          	jal	5754 <exit>

0000000000002624 <fourteen>:
{
    2624:	1101                	addi	sp,sp,-32
    2626:	ec06                	sd	ra,24(sp)
    2628:	e822                	sd	s0,16(sp)
    262a:	e426                	sd	s1,8(sp)
    262c:	1000                	addi	s0,sp,32
    262e:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2630:	00004517          	auipc	a0,0x4
    2634:	79850513          	addi	a0,a0,1944 # 6dc8 <malloc+0x1166>
    2638:	184030ef          	jal	57bc <mkdir>
    263c:	e555                	bnez	a0,26e8 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263e:	00004517          	auipc	a0,0x4
    2642:	5e250513          	addi	a0,a0,1506 # 6c20 <malloc+0xfbe>
    2646:	176030ef          	jal	57bc <mkdir>
    264a:	e94d                	bnez	a0,26fc <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    264c:	20000593          	li	a1,512
    2650:	00004517          	auipc	a0,0x4
    2654:	62850513          	addi	a0,a0,1576 # 6c78 <malloc+0x1016>
    2658:	13c030ef          	jal	5794 <open>
  if (fd < 0) {
    265c:	0a054a63          	bltz	a0,2710 <fourteen+0xec>
  close(fd);
    2660:	11c030ef          	jal	577c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2664:	4581                	li	a1,0
    2666:	00004517          	auipc	a0,0x4
    266a:	68a50513          	addi	a0,a0,1674 # 6cf0 <malloc+0x108e>
    266e:	126030ef          	jal	5794 <open>
  if (fd < 0) {
    2672:	0a054963          	bltz	a0,2724 <fourteen+0x100>
  close(fd);
    2676:	106030ef          	jal	577c <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    267a:	00004517          	auipc	a0,0x4
    267e:	6e650513          	addi	a0,a0,1766 # 6d60 <malloc+0x10fe>
    2682:	13a030ef          	jal	57bc <mkdir>
    2686:	c94d                	beqz	a0,2738 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2688:	00004517          	auipc	a0,0x4
    268c:	73050513          	addi	a0,a0,1840 # 6db8 <malloc+0x1156>
    2690:	12c030ef          	jal	57bc <mkdir>
    2694:	cd45                	beqz	a0,274c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2696:	00004517          	auipc	a0,0x4
    269a:	72250513          	addi	a0,a0,1826 # 6db8 <malloc+0x1156>
    269e:	106030ef          	jal	57a4 <unlink>
  unlink("12345678901234/12345678901234");
    26a2:	00004517          	auipc	a0,0x4
    26a6:	6be50513          	addi	a0,a0,1726 # 6d60 <malloc+0x10fe>
    26aa:	0fa030ef          	jal	57a4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ae:	00004517          	auipc	a0,0x4
    26b2:	64250513          	addi	a0,a0,1602 # 6cf0 <malloc+0x108e>
    26b6:	0ee030ef          	jal	57a4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26ba:	00004517          	auipc	a0,0x4
    26be:	5be50513          	addi	a0,a0,1470 # 6c78 <malloc+0x1016>
    26c2:	0e2030ef          	jal	57a4 <unlink>
  unlink("12345678901234/123456789012345");
    26c6:	00004517          	auipc	a0,0x4
    26ca:	55a50513          	addi	a0,a0,1370 # 6c20 <malloc+0xfbe>
    26ce:	0d6030ef          	jal	57a4 <unlink>
  unlink("12345678901234");
    26d2:	00004517          	auipc	a0,0x4
    26d6:	6f650513          	addi	a0,a0,1782 # 6dc8 <malloc+0x1166>
    26da:	0ca030ef          	jal	57a4 <unlink>
}
    26de:	60e2                	ld	ra,24(sp)
    26e0:	6442                	ld	s0,16(sp)
    26e2:	64a2                	ld	s1,8(sp)
    26e4:	6105                	addi	sp,sp,32
    26e6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e8:	85a6                	mv	a1,s1
    26ea:	00004517          	auipc	a0,0x4
    26ee:	50e50513          	addi	a0,a0,1294 # 6bf8 <malloc+0xf96>
    26f2:	4b8030ef          	jal	5baa <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	05c030ef          	jal	5754 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26fc:	85a6                	mv	a1,s1
    26fe:	00004517          	auipc	a0,0x4
    2702:	54250513          	addi	a0,a0,1346 # 6c40 <malloc+0xfde>
    2706:	4a4030ef          	jal	5baa <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	048030ef          	jal	5754 <exit>
    printf(
    2710:	85a6                	mv	a1,s1
    2712:	00004517          	auipc	a0,0x4
    2716:	59650513          	addi	a0,a0,1430 # 6ca8 <malloc+0x1046>
    271a:	490030ef          	jal	5baa <printf>
    exit(1);
    271e:	4505                	li	a0,1
    2720:	034030ef          	jal	5754 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2724:	85a6                	mv	a1,s1
    2726:	00004517          	auipc	a0,0x4
    272a:	5fa50513          	addi	a0,a0,1530 # 6d20 <malloc+0x10be>
    272e:	47c030ef          	jal	5baa <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	020030ef          	jal	5754 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2738:	85a6                	mv	a1,s1
    273a:	00004517          	auipc	a0,0x4
    273e:	64650513          	addi	a0,a0,1606 # 6d80 <malloc+0x111e>
    2742:	468030ef          	jal	5baa <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	00c030ef          	jal	5754 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    274c:	85a6                	mv	a1,s1
    274e:	00004517          	auipc	a0,0x4
    2752:	68a50513          	addi	a0,a0,1674 # 6dd8 <malloc+0x1176>
    2756:	454030ef          	jal	5baa <printf>
    exit(1);
    275a:	4505                	li	a0,1
    275c:	7f9020ef          	jal	5754 <exit>

0000000000002760 <diskfull>:
{
    2760:	b6010113          	addi	sp,sp,-1184
    2764:	48113c23          	sd	ra,1176(sp)
    2768:	48813823          	sd	s0,1168(sp)
    276c:	48913423          	sd	s1,1160(sp)
    2770:	49213023          	sd	s2,1152(sp)
    2774:	47313c23          	sd	s3,1144(sp)
    2778:	47413823          	sd	s4,1136(sp)
    277c:	47513423          	sd	s5,1128(sp)
    2780:	47613023          	sd	s6,1120(sp)
    2784:	45713c23          	sd	s7,1112(sp)
    2788:	45813823          	sd	s8,1104(sp)
    278c:	45913423          	sd	s9,1096(sp)
    2790:	45a13023          	sd	s10,1088(sp)
    2794:	43b13c23          	sd	s11,1080(sp)
    2798:	4a010413          	addi	s0,sp,1184
    279c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    27a0:	00004517          	auipc	a0,0x4
    27a4:	67050513          	addi	a0,a0,1648 # 6e10 <malloc+0x11ae>
    27a8:	7fd020ef          	jal	57a4 <unlink>
    27ac:	03000a93          	li	s5,48
    name[0] = 'b';
    27b0:	06200d13          	li	s10,98
    name[1] = 'i';
    27b4:	06900c93          	li	s9,105
    name[2] = 'g';
    27b8:	06700c13          	li	s8,103
    unlink(name);
    27bc:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27c0:	60200b93          	li	s7,1538
    27c4:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c8:	b9040a13          	addi	s4,s0,-1136
    27cc:	aa8d                	j	293e <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ce:	b7040613          	addi	a2,s0,-1168
    27d2:	b6843583          	ld	a1,-1176(s0)
    27d6:	00004517          	auipc	a0,0x4
    27da:	64a50513          	addi	a0,a0,1610 # 6e20 <malloc+0x11be>
    27de:	3cc030ef          	jal	5baa <printf>
      break;
    27e2:	a039                	j	27f0 <diskfull+0x90>
        close(fd);
    27e4:	854e                	mv	a0,s3
    27e6:	797020ef          	jal	577c <close>
    close(fd);
    27ea:	854e                	mv	a0,s3
    27ec:	791020ef          	jal	577c <close>
  for (int i = 0; i < nzz; i++) {
    27f0:	4481                	li	s1,0
    name[0] = 'z';
    27f2:	07a00993          	li	s3,122
    unlink(name);
    27f6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fe:	08000a93          	li	s5,128
    name[0] = 'z';
    2802:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2806:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    280a:	41f4d71b          	sraiw	a4,s1,0x1f
    280e:	01b7571b          	srliw	a4,a4,0x1b
    2812:	009707bb          	addw	a5,a4,s1
    2816:	4057d69b          	sraiw	a3,a5,0x5
    281a:	0306869b          	addiw	a3,a3,48
    281e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2822:	8bfd                	andi	a5,a5,31
    2824:	9f99                	subw	a5,a5,a4
    2826:	0307879b          	addiw	a5,a5,48
    282a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2832:	854a                	mv	a0,s2
    2834:	771020ef          	jal	57a4 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2838:	85d2                	mv	a1,s4
    283a:	854a                	mv	a0,s2
    283c:	759020ef          	jal	5794 <open>
    if (fd < 0)
    2840:	00054763          	bltz	a0,284e <diskfull+0xee>
    close(fd);
    2844:	739020ef          	jal	577c <close>
  for (int i = 0; i < nzz; i++) {
    2848:	2485                	addiw	s1,s1,1
    284a:	fb549ce3          	bne	s1,s5,2802 <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284e:	00004517          	auipc	a0,0x4
    2852:	5c250513          	addi	a0,a0,1474 # 6e10 <malloc+0x11ae>
    2856:	767020ef          	jal	57bc <mkdir>
    285a:	12050363          	beqz	a0,2980 <diskfull+0x220>
  unlink("diskfulldir");
    285e:	00004517          	auipc	a0,0x4
    2862:	5b250513          	addi	a0,a0,1458 # 6e10 <malloc+0x11ae>
    2866:	73f020ef          	jal	57a4 <unlink>
  for (int i = 0; i < nzz; i++) {
    286a:	4481                	li	s1,0
    name[0] = 'z';
    286c:	07a00913          	li	s2,122
    unlink(name);
    2870:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2874:	08000993          	li	s3,128
    name[0] = 'z';
    2878:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    287c:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2880:	41f4d71b          	sraiw	a4,s1,0x1f
    2884:	01b7571b          	srliw	a4,a4,0x1b
    2888:	009707bb          	addw	a5,a4,s1
    288c:	4057d69b          	sraiw	a3,a5,0x5
    2890:	0306869b          	addiw	a3,a3,48
    2894:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2898:	8bfd                	andi	a5,a5,31
    289a:	9f99                	subw	a5,a5,a4
    289c:	0307879b          	addiw	a5,a5,48
    28a0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a8:	8552                	mv	a0,s4
    28aa:	6fb020ef          	jal	57a4 <unlink>
  for (int i = 0; i < nzz; i++) {
    28ae:	2485                	addiw	s1,s1,1
    28b0:	fd3494e3          	bne	s1,s3,2878 <diskfull+0x118>
    28b4:	03000493          	li	s1,48
    name[0] = 'b';
    28b8:	06200b13          	li	s6,98
    name[1] = 'i';
    28bc:	06900a93          	li	s5,105
    name[2] = 'g';
    28c0:	06700a13          	li	s4,103
    unlink(name);
    28c4:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c8:	07f00913          	li	s2,127
    name[0] = 'b';
    28cc:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28d0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d4:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d8:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28dc:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28e0:	854e                	mv	a0,s3
    28e2:	6c3020ef          	jal	57a4 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e6:	2485                	addiw	s1,s1,1
    28e8:	0ff4f493          	zext.b	s1,s1
    28ec:	ff2490e3          	bne	s1,s2,28cc <diskfull+0x16c>
}
    28f0:	49813083          	ld	ra,1176(sp)
    28f4:	49013403          	ld	s0,1168(sp)
    28f8:	48813483          	ld	s1,1160(sp)
    28fc:	48013903          	ld	s2,1152(sp)
    2900:	47813983          	ld	s3,1144(sp)
    2904:	47013a03          	ld	s4,1136(sp)
    2908:	46813a83          	ld	s5,1128(sp)
    290c:	46013b03          	ld	s6,1120(sp)
    2910:	45813b83          	ld	s7,1112(sp)
    2914:	45013c03          	ld	s8,1104(sp)
    2918:	44813c83          	ld	s9,1096(sp)
    291c:	44013d03          	ld	s10,1088(sp)
    2920:	43813d83          	ld	s11,1080(sp)
    2924:	4a010113          	addi	sp,sp,1184
    2928:	8082                	ret
    close(fd);
    292a:	854e                	mv	a0,s3
    292c:	651020ef          	jal	577c <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    2930:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x477>
    2932:	0ffafa93          	zext.b	s5,s5
    2936:	07f00793          	li	a5,127
    293a:	eafa8be3          	beq	s5,a5,27f0 <diskfull+0x90>
    name[0] = 'b';
    293e:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2942:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2946:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    294a:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294e:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2952:	855a                	mv	a0,s6
    2954:	651020ef          	jal	57a4 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2958:	85de                	mv	a1,s7
    295a:	855a                	mv	a0,s6
    295c:	639020ef          	jal	5794 <open>
    2960:	89aa                	mv	s3,a0
    if (fd < 0) {
    2962:	e60546e3          	bltz	a0,27ce <diskfull+0x6e>
    2966:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2968:	40000913          	li	s2,1024
    296c:	864a                	mv	a2,s2
    296e:	85d2                	mv	a1,s4
    2970:	854e                	mv	a0,s3
    2972:	603020ef          	jal	5774 <write>
    2976:	e72517e3          	bne	a0,s2,27e4 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    297a:	34fd                	addiw	s1,s1,-1
    297c:	f8e5                	bnez	s1,296c <diskfull+0x20c>
    297e:	b775                	j	292a <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2980:	b6843583          	ld	a1,-1176(s0)
    2984:	00004517          	auipc	a0,0x4
    2988:	4bc50513          	addi	a0,a0,1212 # 6e40 <malloc+0x11de>
    298c:	21e030ef          	jal	5baa <printf>
    2990:	b5f9                	j	285e <diskfull+0xfe>

0000000000002992 <iputtest>:
{
    2992:	1101                	addi	sp,sp,-32
    2994:	ec06                	sd	ra,24(sp)
    2996:	e822                	sd	s0,16(sp)
    2998:	e426                	sd	s1,8(sp)
    299a:	1000                	addi	s0,sp,32
    299c:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299e:	00004517          	auipc	a0,0x4
    29a2:	4d250513          	addi	a0,a0,1234 # 6e70 <malloc+0x120e>
    29a6:	617020ef          	jal	57bc <mkdir>
    29aa:	02054f63          	bltz	a0,29e8 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29ae:	00004517          	auipc	a0,0x4
    29b2:	4c250513          	addi	a0,a0,1218 # 6e70 <malloc+0x120e>
    29b6:	60f020ef          	jal	57c4 <chdir>
    29ba:	04054163          	bltz	a0,29fc <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29be:	00004517          	auipc	a0,0x4
    29c2:	4f250513          	addi	a0,a0,1266 # 6eb0 <malloc+0x124e>
    29c6:	5df020ef          	jal	57a4 <unlink>
    29ca:	04054363          	bltz	a0,2a10 <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ce:	00004517          	auipc	a0,0x4
    29d2:	51250513          	addi	a0,a0,1298 # 6ee0 <malloc+0x127e>
    29d6:	5ef020ef          	jal	57c4 <chdir>
    29da:	04054563          	bltz	a0,2a24 <iputtest+0x92>
}
    29de:	60e2                	ld	ra,24(sp)
    29e0:	6442                	ld	s0,16(sp)
    29e2:	64a2                	ld	s1,8(sp)
    29e4:	6105                	addi	sp,sp,32
    29e6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e8:	85a6                	mv	a1,s1
    29ea:	00004517          	auipc	a0,0x4
    29ee:	48e50513          	addi	a0,a0,1166 # 6e78 <malloc+0x1216>
    29f2:	1b8030ef          	jal	5baa <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	55d020ef          	jal	5754 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29fc:	85a6                	mv	a1,s1
    29fe:	00004517          	auipc	a0,0x4
    2a02:	49250513          	addi	a0,a0,1170 # 6e90 <malloc+0x122e>
    2a06:	1a4030ef          	jal	5baa <printf>
    exit(1);
    2a0a:	4505                	li	a0,1
    2a0c:	549020ef          	jal	5754 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a10:	85a6                	mv	a1,s1
    2a12:	00004517          	auipc	a0,0x4
    2a16:	4ae50513          	addi	a0,a0,1198 # 6ec0 <malloc+0x125e>
    2a1a:	190030ef          	jal	5baa <printf>
    exit(1);
    2a1e:	4505                	li	a0,1
    2a20:	535020ef          	jal	5754 <exit>
    printf("%s: chdir / failed\n", s);
    2a24:	85a6                	mv	a1,s1
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	4c250513          	addi	a0,a0,1218 # 6ee8 <malloc+0x1286>
    2a2e:	17c030ef          	jal	5baa <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	521020ef          	jal	5754 <exit>

0000000000002a38 <exitiputtest>:
{
    2a38:	7179                	addi	sp,sp,-48
    2a3a:	f406                	sd	ra,40(sp)
    2a3c:	f022                	sd	s0,32(sp)
    2a3e:	ec26                	sd	s1,24(sp)
    2a40:	1800                	addi	s0,sp,48
    2a42:	84aa                	mv	s1,a0
  pid = fork();
    2a44:	509020ef          	jal	574c <fork>
  if (pid < 0) {
    2a48:	02054e63          	bltz	a0,2a84 <exitiputtest+0x4c>
  if (pid == 0) {
    2a4c:	e541                	bnez	a0,2ad4 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	42250513          	addi	a0,a0,1058 # 6e70 <malloc+0x120e>
    2a56:	567020ef          	jal	57bc <mkdir>
    2a5a:	02054f63          	bltz	a0,2a98 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	41250513          	addi	a0,a0,1042 # 6e70 <malloc+0x120e>
    2a66:	55f020ef          	jal	57c4 <chdir>
    2a6a:	04054163          	bltz	a0,2aac <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6e:	00004517          	auipc	a0,0x4
    2a72:	44250513          	addi	a0,a0,1090 # 6eb0 <malloc+0x124e>
    2a76:	52f020ef          	jal	57a4 <unlink>
    2a7a:	04054363          	bltz	a0,2ac0 <exitiputtest+0x88>
    exit(0);
    2a7e:	4501                	li	a0,0
    2a80:	4d5020ef          	jal	5754 <exit>
    printf("%s: fork failed\n", s);
    2a84:	85a6                	mv	a1,s1
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	ba250513          	addi	a0,a0,-1118 # 6628 <malloc+0x9c6>
    2a8e:	11c030ef          	jal	5baa <printf>
    exit(1);
    2a92:	4505                	li	a0,1
    2a94:	4c1020ef          	jal	5754 <exit>
      printf("%s: mkdir failed\n", s);
    2a98:	85a6                	mv	a1,s1
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	3de50513          	addi	a0,a0,990 # 6e78 <malloc+0x1216>
    2aa2:	108030ef          	jal	5baa <printf>
      exit(1);
    2aa6:	4505                	li	a0,1
    2aa8:	4ad020ef          	jal	5754 <exit>
      printf("%s: child chdir failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	45250513          	addi	a0,a0,1106 # 6f00 <malloc+0x129e>
    2ab6:	0f4030ef          	jal	5baa <printf>
      exit(1);
    2aba:	4505                	li	a0,1
    2abc:	499020ef          	jal	5754 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ac0:	85a6                	mv	a1,s1
    2ac2:	00004517          	auipc	a0,0x4
    2ac6:	3fe50513          	addi	a0,a0,1022 # 6ec0 <malloc+0x125e>
    2aca:	0e0030ef          	jal	5baa <printf>
      exit(1);
    2ace:	4505                	li	a0,1
    2ad0:	485020ef          	jal	5754 <exit>
  wait(&xstatus);
    2ad4:	fdc40513          	addi	a0,s0,-36
    2ad8:	485020ef          	jal	575c <wait>
  exit(xstatus);
    2adc:	fdc42503          	lw	a0,-36(s0)
    2ae0:	475020ef          	jal	5754 <exit>

0000000000002ae4 <dirtest>:
{
    2ae4:	1101                	addi	sp,sp,-32
    2ae6:	ec06                	sd	ra,24(sp)
    2ae8:	e822                	sd	s0,16(sp)
    2aea:	e426                	sd	s1,8(sp)
    2aec:	1000                	addi	s0,sp,32
    2aee:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2af0:	00004517          	auipc	a0,0x4
    2af4:	42850513          	addi	a0,a0,1064 # 6f18 <malloc+0x12b6>
    2af8:	4c5020ef          	jal	57bc <mkdir>
    2afc:	02054f63          	bltz	a0,2b3a <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2b00:	00004517          	auipc	a0,0x4
    2b04:	41850513          	addi	a0,a0,1048 # 6f18 <malloc+0x12b6>
    2b08:	4bd020ef          	jal	57c4 <chdir>
    2b0c:	04054163          	bltz	a0,2b4e <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b10:	00004517          	auipc	a0,0x4
    2b14:	42850513          	addi	a0,a0,1064 # 6f38 <malloc+0x12d6>
    2b18:	4ad020ef          	jal	57c4 <chdir>
    2b1c:	04054363          	bltz	a0,2b62 <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b20:	00004517          	auipc	a0,0x4
    2b24:	3f850513          	addi	a0,a0,1016 # 6f18 <malloc+0x12b6>
    2b28:	47d020ef          	jal	57a4 <unlink>
    2b2c:	04054563          	bltz	a0,2b76 <dirtest+0x92>
}
    2b30:	60e2                	ld	ra,24(sp)
    2b32:	6442                	ld	s0,16(sp)
    2b34:	64a2                	ld	s1,8(sp)
    2b36:	6105                	addi	sp,sp,32
    2b38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b3a:	85a6                	mv	a1,s1
    2b3c:	00004517          	auipc	a0,0x4
    2b40:	33c50513          	addi	a0,a0,828 # 6e78 <malloc+0x1216>
    2b44:	066030ef          	jal	5baa <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	40b020ef          	jal	5754 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4e:	85a6                	mv	a1,s1
    2b50:	00004517          	auipc	a0,0x4
    2b54:	3d050513          	addi	a0,a0,976 # 6f20 <malloc+0x12be>
    2b58:	052030ef          	jal	5baa <printf>
    exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	3f7020ef          	jal	5754 <exit>
    printf("%s: chdir .. failed\n", s);
    2b62:	85a6                	mv	a1,s1
    2b64:	00004517          	auipc	a0,0x4
    2b68:	3dc50513          	addi	a0,a0,988 # 6f40 <malloc+0x12de>
    2b6c:	03e030ef          	jal	5baa <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	3e3020ef          	jal	5754 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b76:	85a6                	mv	a1,s1
    2b78:	00004517          	auipc	a0,0x4
    2b7c:	3e050513          	addi	a0,a0,992 # 6f58 <malloc+0x12f6>
    2b80:	02a030ef          	jal	5baa <printf>
    exit(1);
    2b84:	4505                	li	a0,1
    2b86:	3cf020ef          	jal	5754 <exit>

0000000000002b8a <subdir>:
{
    2b8a:	1101                	addi	sp,sp,-32
    2b8c:	ec06                	sd	ra,24(sp)
    2b8e:	e822                	sd	s0,16(sp)
    2b90:	e426                	sd	s1,8(sp)
    2b92:	e04a                	sd	s2,0(sp)
    2b94:	1000                	addi	s0,sp,32
    2b96:	892a                	mv	s2,a0
  unlink("ff");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	50850513          	addi	a0,a0,1288 # 70a0 <malloc+0x143e>
    2ba0:	405020ef          	jal	57a4 <unlink>
  if (mkdir("dd") != 0) {
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	3cc50513          	addi	a0,a0,972 # 6f70 <malloc+0x130e>
    2bac:	411020ef          	jal	57bc <mkdir>
    2bb0:	2e051263          	bnez	a0,2e94 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb4:	20200593          	li	a1,514
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	3d850513          	addi	a0,a0,984 # 6f90 <malloc+0x132e>
    2bc0:	3d5020ef          	jal	5794 <open>
    2bc4:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc6:	2e054163          	bltz	a0,2ea8 <subdir+0x31e>
  write(fd, "ff", 2);
    2bca:	4609                	li	a2,2
    2bcc:	00004597          	auipc	a1,0x4
    2bd0:	4d458593          	addi	a1,a1,1236 # 70a0 <malloc+0x143e>
    2bd4:	3a1020ef          	jal	5774 <write>
  close(fd);
    2bd8:	8526                	mv	a0,s1
    2bda:	3a3020ef          	jal	577c <close>
  if (unlink("dd") >= 0) {
    2bde:	00004517          	auipc	a0,0x4
    2be2:	39250513          	addi	a0,a0,914 # 6f70 <malloc+0x130e>
    2be6:	3bf020ef          	jal	57a4 <unlink>
    2bea:	2c055963          	bgez	a0,2ebc <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	3fa50513          	addi	a0,a0,1018 # 6fe8 <malloc+0x1386>
    2bf6:	3c7020ef          	jal	57bc <mkdir>
    2bfa:	2c051b63          	bnez	a0,2ed0 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfe:	20200593          	li	a1,514
    2c02:	00004517          	auipc	a0,0x4
    2c06:	40e50513          	addi	a0,a0,1038 # 7010 <malloc+0x13ae>
    2c0a:	38b020ef          	jal	5794 <open>
    2c0e:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c10:	2c054a63          	bltz	a0,2ee4 <subdir+0x35a>
  write(fd, "FF", 2);
    2c14:	4609                	li	a2,2
    2c16:	00004597          	auipc	a1,0x4
    2c1a:	42a58593          	addi	a1,a1,1066 # 7040 <malloc+0x13de>
    2c1e:	357020ef          	jal	5774 <write>
  close(fd);
    2c22:	8526                	mv	a0,s1
    2c24:	359020ef          	jal	577c <close>
  fd = open("dd/dd/../ff", 0);
    2c28:	4581                	li	a1,0
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	41e50513          	addi	a0,a0,1054 # 7048 <malloc+0x13e6>
    2c32:	363020ef          	jal	5794 <open>
    2c36:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c38:	2c054063          	bltz	a0,2ef8 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c3c:	660d                	lui	a2,0x3
    2c3e:	0000b597          	auipc	a1,0xb
    2c42:	0ba58593          	addi	a1,a1,186 # dcf8 <buf>
    2c46:	327020ef          	jal	576c <read>
  if (cc != 2 || buf[0] != 'f') {
    2c4a:	4789                	li	a5,2
    2c4c:	2cf51063          	bne	a0,a5,2f0c <subdir+0x382>
    2c50:	0000b717          	auipc	a4,0xb
    2c54:	0a874703          	lbu	a4,168(a4) # dcf8 <buf>
    2c58:	06600793          	li	a5,102
    2c5c:	2af71863          	bne	a4,a5,2f0c <subdir+0x382>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	31b020ef          	jal	577c <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c66:	00004597          	auipc	a1,0x4
    2c6a:	43258593          	addi	a1,a1,1074 # 7098 <malloc+0x1436>
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	3a250513          	addi	a0,a0,930 # 7010 <malloc+0x13ae>
    2c76:	33f020ef          	jal	57b4 <link>
    2c7a:	2a051363          	bnez	a0,2f20 <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	39250513          	addi	a0,a0,914 # 7010 <malloc+0x13ae>
    2c86:	31f020ef          	jal	57a4 <unlink>
    2c8a:	2a051563          	bnez	a0,2f34 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8e:	4581                	li	a1,0
    2c90:	00004517          	auipc	a0,0x4
    2c94:	38050513          	addi	a0,a0,896 # 7010 <malloc+0x13ae>
    2c98:	2fd020ef          	jal	5794 <open>
    2c9c:	2a055663          	bgez	a0,2f48 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	2d050513          	addi	a0,a0,720 # 6f70 <malloc+0x130e>
    2ca8:	31d020ef          	jal	57c4 <chdir>
    2cac:	2a051863          	bnez	a0,2f5c <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	48050513          	addi	a0,a0,1152 # 7130 <malloc+0x14ce>
    2cb8:	30d020ef          	jal	57c4 <chdir>
    2cbc:	2a051a63          	bnez	a0,2f70 <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	4a050513          	addi	a0,a0,1184 # 7160 <malloc+0x14fe>
    2cc8:	2fd020ef          	jal	57c4 <chdir>
    2ccc:	2a051c63          	bnez	a0,2f84 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	4c850513          	addi	a0,a0,1224 # 7198 <malloc+0x1536>
    2cd8:	2ed020ef          	jal	57c4 <chdir>
    2cdc:	2a051e63          	bnez	a0,2f98 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ce0:	4581                	li	a1,0
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	3b650513          	addi	a0,a0,950 # 7098 <malloc+0x1436>
    2cea:	2ab020ef          	jal	5794 <open>
    2cee:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cf0:	2a054e63          	bltz	a0,2fac <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf4:	660d                	lui	a2,0x3
    2cf6:	0000b597          	auipc	a1,0xb
    2cfa:	00258593          	addi	a1,a1,2 # dcf8 <buf>
    2cfe:	26f020ef          	jal	576c <read>
    2d02:	4789                	li	a5,2
    2d04:	2af51e63          	bne	a0,a5,2fc0 <subdir+0x436>
  close(fd);
    2d08:	8526                	mv	a0,s1
    2d0a:	273020ef          	jal	577c <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0e:	4581                	li	a1,0
    2d10:	00004517          	auipc	a0,0x4
    2d14:	30050513          	addi	a0,a0,768 # 7010 <malloc+0x13ae>
    2d18:	27d020ef          	jal	5794 <open>
    2d1c:	2a055c63          	bgez	a0,2fd4 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d20:	20200593          	li	a1,514
    2d24:	00004517          	auipc	a0,0x4
    2d28:	50450513          	addi	a0,a0,1284 # 7228 <malloc+0x15c6>
    2d2c:	269020ef          	jal	5794 <open>
    2d30:	2a055c63          	bgez	a0,2fe8 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d34:	20200593          	li	a1,514
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	52050513          	addi	a0,a0,1312 # 7258 <malloc+0x15f6>
    2d40:	255020ef          	jal	5794 <open>
    2d44:	2a055c63          	bgez	a0,2ffc <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d48:	20000593          	li	a1,512
    2d4c:	00004517          	auipc	a0,0x4
    2d50:	22450513          	addi	a0,a0,548 # 6f70 <malloc+0x130e>
    2d54:	241020ef          	jal	5794 <open>
    2d58:	2a055c63          	bgez	a0,3010 <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d5c:	4589                	li	a1,2
    2d5e:	00004517          	auipc	a0,0x4
    2d62:	21250513          	addi	a0,a0,530 # 6f70 <malloc+0x130e>
    2d66:	22f020ef          	jal	5794 <open>
    2d6a:	2a055d63          	bgez	a0,3024 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6e:	4585                	li	a1,1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	20050513          	addi	a0,a0,512 # 6f70 <malloc+0x130e>
    2d78:	21d020ef          	jal	5794 <open>
    2d7c:	2a055e63          	bgez	a0,3038 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d80:	00004597          	auipc	a1,0x4
    2d84:	56858593          	addi	a1,a1,1384 # 72e8 <malloc+0x1686>
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	4a050513          	addi	a0,a0,1184 # 7228 <malloc+0x15c6>
    2d90:	225020ef          	jal	57b4 <link>
    2d94:	2a050c63          	beqz	a0,304c <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d98:	00004597          	auipc	a1,0x4
    2d9c:	55058593          	addi	a1,a1,1360 # 72e8 <malloc+0x1686>
    2da0:	00004517          	auipc	a0,0x4
    2da4:	4b850513          	addi	a0,a0,1208 # 7258 <malloc+0x15f6>
    2da8:	20d020ef          	jal	57b4 <link>
    2dac:	2a050a63          	beqz	a0,3060 <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2db0:	00004597          	auipc	a1,0x4
    2db4:	2e858593          	addi	a1,a1,744 # 7098 <malloc+0x1436>
    2db8:	00004517          	auipc	a0,0x4
    2dbc:	1d850513          	addi	a0,a0,472 # 6f90 <malloc+0x132e>
    2dc0:	1f5020ef          	jal	57b4 <link>
    2dc4:	2a050863          	beqz	a0,3074 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	46050513          	addi	a0,a0,1120 # 7228 <malloc+0x15c6>
    2dd0:	1ed020ef          	jal	57bc <mkdir>
    2dd4:	2a050a63          	beqz	a0,3088 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	48050513          	addi	a0,a0,1152 # 7258 <malloc+0x15f6>
    2de0:	1dd020ef          	jal	57bc <mkdir>
    2de4:	2a050c63          	beqz	a0,309c <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de8:	00004517          	auipc	a0,0x4
    2dec:	2b050513          	addi	a0,a0,688 # 7098 <malloc+0x1436>
    2df0:	1cd020ef          	jal	57bc <mkdir>
    2df4:	2a050e63          	beqz	a0,30b0 <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	46050513          	addi	a0,a0,1120 # 7258 <malloc+0x15f6>
    2e00:	1a5020ef          	jal	57a4 <unlink>
    2e04:	2c050063          	beqz	a0,30c4 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e08:	00004517          	auipc	a0,0x4
    2e0c:	42050513          	addi	a0,a0,1056 # 7228 <malloc+0x15c6>
    2e10:	195020ef          	jal	57a4 <unlink>
    2e14:	2c050263          	beqz	a0,30d8 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	17850513          	addi	a0,a0,376 # 6f90 <malloc+0x132e>
    2e20:	1a5020ef          	jal	57c4 <chdir>
    2e24:	2c050463          	beqz	a0,30ec <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e28:	00004517          	auipc	a0,0x4
    2e2c:	61050513          	addi	a0,a0,1552 # 7438 <malloc+0x17d6>
    2e30:	195020ef          	jal	57c4 <chdir>
    2e34:	2c050663          	beqz	a0,3100 <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	26050513          	addi	a0,a0,608 # 7098 <malloc+0x1436>
    2e40:	165020ef          	jal	57a4 <unlink>
    2e44:	2c051863          	bnez	a0,3114 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	14850513          	addi	a0,a0,328 # 6f90 <malloc+0x132e>
    2e50:	155020ef          	jal	57a4 <unlink>
    2e54:	2c051a63          	bnez	a0,3128 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	11850513          	addi	a0,a0,280 # 6f70 <malloc+0x130e>
    2e60:	145020ef          	jal	57a4 <unlink>
    2e64:	2c050c63          	beqz	a0,313c <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	64050513          	addi	a0,a0,1600 # 74a8 <malloc+0x1846>
    2e70:	135020ef          	jal	57a4 <unlink>
    2e74:	2c054e63          	bltz	a0,3150 <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	0f850513          	addi	a0,a0,248 # 6f70 <malloc+0x130e>
    2e80:	125020ef          	jal	57a4 <unlink>
    2e84:	2e054063          	bltz	a0,3164 <subdir+0x5da>
}
    2e88:	60e2                	ld	ra,24(sp)
    2e8a:	6442                	ld	s0,16(sp)
    2e8c:	64a2                	ld	s1,8(sp)
    2e8e:	6902                	ld	s2,0(sp)
    2e90:	6105                	addi	sp,sp,32
    2e92:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e94:	85ca                	mv	a1,s2
    2e96:	00004517          	auipc	a0,0x4
    2e9a:	0e250513          	addi	a0,a0,226 # 6f78 <malloc+0x1316>
    2e9e:	50d020ef          	jal	5baa <printf>
    exit(1);
    2ea2:	4505                	li	a0,1
    2ea4:	0b1020ef          	jal	5754 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea8:	85ca                	mv	a1,s2
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	0ee50513          	addi	a0,a0,238 # 6f98 <malloc+0x1336>
    2eb2:	4f9020ef          	jal	5baa <printf>
    exit(1);
    2eb6:	4505                	li	a0,1
    2eb8:	09d020ef          	jal	5754 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ebc:	85ca                	mv	a1,s2
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	0fa50513          	addi	a0,a0,250 # 6fb8 <malloc+0x1356>
    2ec6:	4e5020ef          	jal	5baa <printf>
    exit(1);
    2eca:	4505                	li	a0,1
    2ecc:	089020ef          	jal	5754 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ed0:	85ca                	mv	a1,s2
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	11e50513          	addi	a0,a0,286 # 6ff0 <malloc+0x138e>
    2eda:	4d1020ef          	jal	5baa <printf>
    exit(1);
    2ede:	4505                	li	a0,1
    2ee0:	075020ef          	jal	5754 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee4:	85ca                	mv	a1,s2
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	13a50513          	addi	a0,a0,314 # 7020 <malloc+0x13be>
    2eee:	4bd020ef          	jal	5baa <printf>
    exit(1);
    2ef2:	4505                	li	a0,1
    2ef4:	061020ef          	jal	5754 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef8:	85ca                	mv	a1,s2
    2efa:	00004517          	auipc	a0,0x4
    2efe:	15e50513          	addi	a0,a0,350 # 7058 <malloc+0x13f6>
    2f02:	4a9020ef          	jal	5baa <printf>
    exit(1);
    2f06:	4505                	li	a0,1
    2f08:	04d020ef          	jal	5754 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f0c:	85ca                	mv	a1,s2
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	16a50513          	addi	a0,a0,362 # 7078 <malloc+0x1416>
    2f16:	495020ef          	jal	5baa <printf>
    exit(1);
    2f1a:	4505                	li	a0,1
    2f1c:	039020ef          	jal	5754 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f20:	85ca                	mv	a1,s2
    2f22:	00004517          	auipc	a0,0x4
    2f26:	18650513          	addi	a0,a0,390 # 70a8 <malloc+0x1446>
    2f2a:	481020ef          	jal	5baa <printf>
    exit(1);
    2f2e:	4505                	li	a0,1
    2f30:	025020ef          	jal	5754 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f34:	85ca                	mv	a1,s2
    2f36:	00004517          	auipc	a0,0x4
    2f3a:	19a50513          	addi	a0,a0,410 # 70d0 <malloc+0x146e>
    2f3e:	46d020ef          	jal	5baa <printf>
    exit(1);
    2f42:	4505                	li	a0,1
    2f44:	011020ef          	jal	5754 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f48:	85ca                	mv	a1,s2
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	1a650513          	addi	a0,a0,422 # 70f0 <malloc+0x148e>
    2f52:	459020ef          	jal	5baa <printf>
    exit(1);
    2f56:	4505                	li	a0,1
    2f58:	7fc020ef          	jal	5754 <exit>
    printf("%s: chdir dd failed\n", s);
    2f5c:	85ca                	mv	a1,s2
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	1ba50513          	addi	a0,a0,442 # 7118 <malloc+0x14b6>
    2f66:	445020ef          	jal	5baa <printf>
    exit(1);
    2f6a:	4505                	li	a0,1
    2f6c:	7e8020ef          	jal	5754 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f70:	85ca                	mv	a1,s2
    2f72:	00004517          	auipc	a0,0x4
    2f76:	1ce50513          	addi	a0,a0,462 # 7140 <malloc+0x14de>
    2f7a:	431020ef          	jal	5baa <printf>
    exit(1);
    2f7e:	4505                	li	a0,1
    2f80:	7d4020ef          	jal	5754 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f84:	85ca                	mv	a1,s2
    2f86:	00004517          	auipc	a0,0x4
    2f8a:	1ea50513          	addi	a0,a0,490 # 7170 <malloc+0x150e>
    2f8e:	41d020ef          	jal	5baa <printf>
    exit(1);
    2f92:	4505                	li	a0,1
    2f94:	7c0020ef          	jal	5754 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f98:	85ca                	mv	a1,s2
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	20650513          	addi	a0,a0,518 # 71a0 <malloc+0x153e>
    2fa2:	409020ef          	jal	5baa <printf>
    exit(1);
    2fa6:	4505                	li	a0,1
    2fa8:	7ac020ef          	jal	5754 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fac:	85ca                	mv	a1,s2
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	20a50513          	addi	a0,a0,522 # 71b8 <malloc+0x1556>
    2fb6:	3f5020ef          	jal	5baa <printf>
    exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	798020ef          	jal	5754 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fc0:	85ca                	mv	a1,s2
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	21650513          	addi	a0,a0,534 # 71d8 <malloc+0x1576>
    2fca:	3e1020ef          	jal	5baa <printf>
    exit(1);
    2fce:	4505                	li	a0,1
    2fd0:	784020ef          	jal	5754 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd4:	85ca                	mv	a1,s2
    2fd6:	00004517          	auipc	a0,0x4
    2fda:	22250513          	addi	a0,a0,546 # 71f8 <malloc+0x1596>
    2fde:	3cd020ef          	jal	5baa <printf>
    exit(1);
    2fe2:	4505                	li	a0,1
    2fe4:	770020ef          	jal	5754 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe8:	85ca                	mv	a1,s2
    2fea:	00004517          	auipc	a0,0x4
    2fee:	24e50513          	addi	a0,a0,590 # 7238 <malloc+0x15d6>
    2ff2:	3b9020ef          	jal	5baa <printf>
    exit(1);
    2ff6:	4505                	li	a0,1
    2ff8:	75c020ef          	jal	5754 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ffc:	85ca                	mv	a1,s2
    2ffe:	00004517          	auipc	a0,0x4
    3002:	26a50513          	addi	a0,a0,618 # 7268 <malloc+0x1606>
    3006:	3a5020ef          	jal	5baa <printf>
    exit(1);
    300a:	4505                	li	a0,1
    300c:	748020ef          	jal	5754 <exit>
    printf("%s: create dd succeeded!\n", s);
    3010:	85ca                	mv	a1,s2
    3012:	00004517          	auipc	a0,0x4
    3016:	27650513          	addi	a0,a0,630 # 7288 <malloc+0x1626>
    301a:	391020ef          	jal	5baa <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	734020ef          	jal	5754 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3024:	85ca                	mv	a1,s2
    3026:	00004517          	auipc	a0,0x4
    302a:	28250513          	addi	a0,a0,642 # 72a8 <malloc+0x1646>
    302e:	37d020ef          	jal	5baa <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	720020ef          	jal	5754 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3038:	85ca                	mv	a1,s2
    303a:	00004517          	auipc	a0,0x4
    303e:	28e50513          	addi	a0,a0,654 # 72c8 <malloc+0x1666>
    3042:	369020ef          	jal	5baa <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	70c020ef          	jal	5754 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    304c:	85ca                	mv	a1,s2
    304e:	00004517          	auipc	a0,0x4
    3052:	2aa50513          	addi	a0,a0,682 # 72f8 <malloc+0x1696>
    3056:	355020ef          	jal	5baa <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	6f8020ef          	jal	5754 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3060:	85ca                	mv	a1,s2
    3062:	00004517          	auipc	a0,0x4
    3066:	2be50513          	addi	a0,a0,702 # 7320 <malloc+0x16be>
    306a:	341020ef          	jal	5baa <printf>
    exit(1);
    306e:	4505                	li	a0,1
    3070:	6e4020ef          	jal	5754 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3074:	85ca                	mv	a1,s2
    3076:	00004517          	auipc	a0,0x4
    307a:	2d250513          	addi	a0,a0,722 # 7348 <malloc+0x16e6>
    307e:	32d020ef          	jal	5baa <printf>
    exit(1);
    3082:	4505                	li	a0,1
    3084:	6d0020ef          	jal	5754 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3088:	85ca                	mv	a1,s2
    308a:	00004517          	auipc	a0,0x4
    308e:	2e650513          	addi	a0,a0,742 # 7370 <malloc+0x170e>
    3092:	319020ef          	jal	5baa <printf>
    exit(1);
    3096:	4505                	li	a0,1
    3098:	6bc020ef          	jal	5754 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00004517          	auipc	a0,0x4
    30a2:	2f250513          	addi	a0,a0,754 # 7390 <malloc+0x172e>
    30a6:	305020ef          	jal	5baa <printf>
    exit(1);
    30aa:	4505                	li	a0,1
    30ac:	6a8020ef          	jal	5754 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	2fe50513          	addi	a0,a0,766 # 73b0 <malloc+0x174e>
    30ba:	2f1020ef          	jal	5baa <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	694020ef          	jal	5754 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c4:	85ca                	mv	a1,s2
    30c6:	00004517          	auipc	a0,0x4
    30ca:	31250513          	addi	a0,a0,786 # 73d8 <malloc+0x1776>
    30ce:	2dd020ef          	jal	5baa <printf>
    exit(1);
    30d2:	4505                	li	a0,1
    30d4:	680020ef          	jal	5754 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d8:	85ca                	mv	a1,s2
    30da:	00004517          	auipc	a0,0x4
    30de:	31e50513          	addi	a0,a0,798 # 73f8 <malloc+0x1796>
    30e2:	2c9020ef          	jal	5baa <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	66c020ef          	jal	5754 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ec:	85ca                	mv	a1,s2
    30ee:	00004517          	auipc	a0,0x4
    30f2:	32a50513          	addi	a0,a0,810 # 7418 <malloc+0x17b6>
    30f6:	2b5020ef          	jal	5baa <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	658020ef          	jal	5754 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	33e50513          	addi	a0,a0,830 # 7440 <malloc+0x17de>
    310a:	2a1020ef          	jal	5baa <printf>
    exit(1);
    310e:	4505                	li	a0,1
    3110:	644020ef          	jal	5754 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3114:	85ca                	mv	a1,s2
    3116:	00004517          	auipc	a0,0x4
    311a:	fba50513          	addi	a0,a0,-70 # 70d0 <malloc+0x146e>
    311e:	28d020ef          	jal	5baa <printf>
    exit(1);
    3122:	4505                	li	a0,1
    3124:	630020ef          	jal	5754 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00004517          	auipc	a0,0x4
    312e:	33650513          	addi	a0,a0,822 # 7460 <malloc+0x17fe>
    3132:	279020ef          	jal	5baa <printf>
    exit(1);
    3136:	4505                	li	a0,1
    3138:	61c020ef          	jal	5754 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	34250513          	addi	a0,a0,834 # 7480 <malloc+0x181e>
    3146:	265020ef          	jal	5baa <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	608020ef          	jal	5754 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3150:	85ca                	mv	a1,s2
    3152:	00004517          	auipc	a0,0x4
    3156:	35e50513          	addi	a0,a0,862 # 74b0 <malloc+0x184e>
    315a:	251020ef          	jal	5baa <printf>
    exit(1);
    315e:	4505                	li	a0,1
    3160:	5f4020ef          	jal	5754 <exit>
    printf("%s: unlink dd failed\n", s);
    3164:	85ca                	mv	a1,s2
    3166:	00004517          	auipc	a0,0x4
    316a:	36a50513          	addi	a0,a0,874 # 74d0 <malloc+0x186e>
    316e:	23d020ef          	jal	5baa <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	5e0020ef          	jal	5754 <exit>

0000000000003178 <rmdot>:
{
    3178:	1101                	addi	sp,sp,-32
    317a:	ec06                	sd	ra,24(sp)
    317c:	e822                	sd	s0,16(sp)
    317e:	e426                	sd	s1,8(sp)
    3180:	1000                	addi	s0,sp,32
    3182:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3184:	00004517          	auipc	a0,0x4
    3188:	36450513          	addi	a0,a0,868 # 74e8 <malloc+0x1886>
    318c:	630020ef          	jal	57bc <mkdir>
    3190:	e53d                	bnez	a0,31fe <rmdot+0x86>
  if (chdir("dots") != 0) {
    3192:	00004517          	auipc	a0,0x4
    3196:	35650513          	addi	a0,a0,854 # 74e8 <malloc+0x1886>
    319a:	62a020ef          	jal	57c4 <chdir>
    319e:	e935                	bnez	a0,3212 <rmdot+0x9a>
  if (unlink(".") == 0) {
    31a0:	00003517          	auipc	a0,0x3
    31a4:	2e050513          	addi	a0,a0,736 # 6480 <malloc+0x81e>
    31a8:	5fc020ef          	jal	57a4 <unlink>
    31ac:	cd2d                	beqz	a0,3226 <rmdot+0xae>
  if (unlink("..") == 0) {
    31ae:	00004517          	auipc	a0,0x4
    31b2:	d8a50513          	addi	a0,a0,-630 # 6f38 <malloc+0x12d6>
    31b6:	5ee020ef          	jal	57a4 <unlink>
    31ba:	c141                	beqz	a0,323a <rmdot+0xc2>
  if (chdir("/") != 0) {
    31bc:	00004517          	auipc	a0,0x4
    31c0:	d2450513          	addi	a0,a0,-732 # 6ee0 <malloc+0x127e>
    31c4:	600020ef          	jal	57c4 <chdir>
    31c8:	e159                	bnez	a0,324e <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31ca:	00004517          	auipc	a0,0x4
    31ce:	38650513          	addi	a0,a0,902 # 7550 <malloc+0x18ee>
    31d2:	5d2020ef          	jal	57a4 <unlink>
    31d6:	c551                	beqz	a0,3262 <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d8:	00004517          	auipc	a0,0x4
    31dc:	3a050513          	addi	a0,a0,928 # 7578 <malloc+0x1916>
    31e0:	5c4020ef          	jal	57a4 <unlink>
    31e4:	c949                	beqz	a0,3276 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e6:	00004517          	auipc	a0,0x4
    31ea:	30250513          	addi	a0,a0,770 # 74e8 <malloc+0x1886>
    31ee:	5b6020ef          	jal	57a4 <unlink>
    31f2:	ed41                	bnez	a0,328a <rmdot+0x112>
}
    31f4:	60e2                	ld	ra,24(sp)
    31f6:	6442                	ld	s0,16(sp)
    31f8:	64a2                	ld	s1,8(sp)
    31fa:	6105                	addi	sp,sp,32
    31fc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fe:	85a6                	mv	a1,s1
    3200:	00004517          	auipc	a0,0x4
    3204:	2f050513          	addi	a0,a0,752 # 74f0 <malloc+0x188e>
    3208:	1a3020ef          	jal	5baa <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	546020ef          	jal	5754 <exit>
    printf("%s: chdir dots failed\n", s);
    3212:	85a6                	mv	a1,s1
    3214:	00004517          	auipc	a0,0x4
    3218:	2f450513          	addi	a0,a0,756 # 7508 <malloc+0x18a6>
    321c:	18f020ef          	jal	5baa <printf>
    exit(1);
    3220:	4505                	li	a0,1
    3222:	532020ef          	jal	5754 <exit>
    printf("%s: rm . worked!\n", s);
    3226:	85a6                	mv	a1,s1
    3228:	00004517          	auipc	a0,0x4
    322c:	2f850513          	addi	a0,a0,760 # 7520 <malloc+0x18be>
    3230:	17b020ef          	jal	5baa <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	51e020ef          	jal	5754 <exit>
    printf("%s: rm .. worked!\n", s);
    323a:	85a6                	mv	a1,s1
    323c:	00004517          	auipc	a0,0x4
    3240:	2fc50513          	addi	a0,a0,764 # 7538 <malloc+0x18d6>
    3244:	167020ef          	jal	5baa <printf>
    exit(1);
    3248:	4505                	li	a0,1
    324a:	50a020ef          	jal	5754 <exit>
    printf("%s: chdir / failed\n", s);
    324e:	85a6                	mv	a1,s1
    3250:	00004517          	auipc	a0,0x4
    3254:	c9850513          	addi	a0,a0,-872 # 6ee8 <malloc+0x1286>
    3258:	153020ef          	jal	5baa <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	4f6020ef          	jal	5754 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3262:	85a6                	mv	a1,s1
    3264:	00004517          	auipc	a0,0x4
    3268:	2f450513          	addi	a0,a0,756 # 7558 <malloc+0x18f6>
    326c:	13f020ef          	jal	5baa <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	4e2020ef          	jal	5754 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3276:	85a6                	mv	a1,s1
    3278:	00004517          	auipc	a0,0x4
    327c:	30850513          	addi	a0,a0,776 # 7580 <malloc+0x191e>
    3280:	12b020ef          	jal	5baa <printf>
    exit(1);
    3284:	4505                	li	a0,1
    3286:	4ce020ef          	jal	5754 <exit>
    printf("%s: unlink dots failed!\n", s);
    328a:	85a6                	mv	a1,s1
    328c:	00004517          	auipc	a0,0x4
    3290:	31450513          	addi	a0,a0,788 # 75a0 <malloc+0x193e>
    3294:	117020ef          	jal	5baa <printf>
    exit(1);
    3298:	4505                	li	a0,1
    329a:	4ba020ef          	jal	5754 <exit>

000000000000329e <dirfile>:
{
    329e:	1101                	addi	sp,sp,-32
    32a0:	ec06                	sd	ra,24(sp)
    32a2:	e822                	sd	s0,16(sp)
    32a4:	e426                	sd	s1,8(sp)
    32a6:	e04a                	sd	s2,0(sp)
    32a8:	1000                	addi	s0,sp,32
    32aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32ac:	20000593          	li	a1,512
    32b0:	00004517          	auipc	a0,0x4
    32b4:	31050513          	addi	a0,a0,784 # 75c0 <malloc+0x195e>
    32b8:	4dc020ef          	jal	5794 <open>
  if (fd < 0) {
    32bc:	0c054563          	bltz	a0,3386 <dirfile+0xe8>
  close(fd);
    32c0:	4bc020ef          	jal	577c <close>
  if (chdir("dirfile") == 0) {
    32c4:	00004517          	auipc	a0,0x4
    32c8:	2fc50513          	addi	a0,a0,764 # 75c0 <malloc+0x195e>
    32cc:	4f8020ef          	jal	57c4 <chdir>
    32d0:	c569                	beqz	a0,339a <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d2:	4581                	li	a1,0
    32d4:	00004517          	auipc	a0,0x4
    32d8:	33450513          	addi	a0,a0,820 # 7608 <malloc+0x19a6>
    32dc:	4b8020ef          	jal	5794 <open>
  if (fd >= 0) {
    32e0:	0c055763          	bgez	a0,33ae <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e4:	20000593          	li	a1,512
    32e8:	00004517          	auipc	a0,0x4
    32ec:	32050513          	addi	a0,a0,800 # 7608 <malloc+0x19a6>
    32f0:	4a4020ef          	jal	5794 <open>
  if (fd >= 0) {
    32f4:	0c055763          	bgez	a0,33c2 <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f8:	00004517          	auipc	a0,0x4
    32fc:	31050513          	addi	a0,a0,784 # 7608 <malloc+0x19a6>
    3300:	4bc020ef          	jal	57bc <mkdir>
    3304:	0c050963          	beqz	a0,33d6 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3308:	00004517          	auipc	a0,0x4
    330c:	30050513          	addi	a0,a0,768 # 7608 <malloc+0x19a6>
    3310:	494020ef          	jal	57a4 <unlink>
    3314:	0c050b63          	beqz	a0,33ea <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3318:	00004597          	auipc	a1,0x4
    331c:	2f058593          	addi	a1,a1,752 # 7608 <malloc+0x19a6>
    3320:	00003517          	auipc	a0,0x3
    3324:	c5050513          	addi	a0,a0,-944 # 5f70 <malloc+0x30e>
    3328:	48c020ef          	jal	57b4 <link>
    332c:	0c050963          	beqz	a0,33fe <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    3330:	00004517          	auipc	a0,0x4
    3334:	29050513          	addi	a0,a0,656 # 75c0 <malloc+0x195e>
    3338:	46c020ef          	jal	57a4 <unlink>
    333c:	0c051b63          	bnez	a0,3412 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3340:	4589                	li	a1,2
    3342:	00003517          	auipc	a0,0x3
    3346:	13e50513          	addi	a0,a0,318 # 6480 <malloc+0x81e>
    334a:	44a020ef          	jal	5794 <open>
  if (fd >= 0) {
    334e:	0c055c63          	bgez	a0,3426 <dirfile+0x188>
  fd = open(".", 0);
    3352:	4581                	li	a1,0
    3354:	00003517          	auipc	a0,0x3
    3358:	12c50513          	addi	a0,a0,300 # 6480 <malloc+0x81e>
    335c:	438020ef          	jal	5794 <open>
    3360:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3362:	4605                	li	a2,1
    3364:	00003597          	auipc	a1,0x3
    3368:	aa458593          	addi	a1,a1,-1372 # 5e08 <malloc+0x1a6>
    336c:	408020ef          	jal	5774 <write>
    3370:	0ca04563          	bgtz	a0,343a <dirfile+0x19c>
  close(fd);
    3374:	8526                	mv	a0,s1
    3376:	406020ef          	jal	577c <close>
}
    337a:	60e2                	ld	ra,24(sp)
    337c:	6442                	ld	s0,16(sp)
    337e:	64a2                	ld	s1,8(sp)
    3380:	6902                	ld	s2,0(sp)
    3382:	6105                	addi	sp,sp,32
    3384:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3386:	85ca                	mv	a1,s2
    3388:	00004517          	auipc	a0,0x4
    338c:	24050513          	addi	a0,a0,576 # 75c8 <malloc+0x1966>
    3390:	01b020ef          	jal	5baa <printf>
    exit(1);
    3394:	4505                	li	a0,1
    3396:	3be020ef          	jal	5754 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00004517          	auipc	a0,0x4
    33a0:	24c50513          	addi	a0,a0,588 # 75e8 <malloc+0x1986>
    33a4:	007020ef          	jal	5baa <printf>
    exit(1);
    33a8:	4505                	li	a0,1
    33aa:	3aa020ef          	jal	5754 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ae:	85ca                	mv	a1,s2
    33b0:	00004517          	auipc	a0,0x4
    33b4:	26850513          	addi	a0,a0,616 # 7618 <malloc+0x19b6>
    33b8:	7f2020ef          	jal	5baa <printf>
    exit(1);
    33bc:	4505                	li	a0,1
    33be:	396020ef          	jal	5754 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c2:	85ca                	mv	a1,s2
    33c4:	00004517          	auipc	a0,0x4
    33c8:	25450513          	addi	a0,a0,596 # 7618 <malloc+0x19b6>
    33cc:	7de020ef          	jal	5baa <printf>
    exit(1);
    33d0:	4505                	li	a0,1
    33d2:	382020ef          	jal	5754 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d6:	85ca                	mv	a1,s2
    33d8:	00004517          	auipc	a0,0x4
    33dc:	26850513          	addi	a0,a0,616 # 7640 <malloc+0x19de>
    33e0:	7ca020ef          	jal	5baa <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	36e020ef          	jal	5754 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ea:	85ca                	mv	a1,s2
    33ec:	00004517          	auipc	a0,0x4
    33f0:	27c50513          	addi	a0,a0,636 # 7668 <malloc+0x1a06>
    33f4:	7b6020ef          	jal	5baa <printf>
    exit(1);
    33f8:	4505                	li	a0,1
    33fa:	35a020ef          	jal	5754 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fe:	85ca                	mv	a1,s2
    3400:	00004517          	auipc	a0,0x4
    3404:	29050513          	addi	a0,a0,656 # 7690 <malloc+0x1a2e>
    3408:	7a2020ef          	jal	5baa <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	346020ef          	jal	5754 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	2a450513          	addi	a0,a0,676 # 76b8 <malloc+0x1a56>
    341c:	78e020ef          	jal	5baa <printf>
    exit(1);
    3420:	4505                	li	a0,1
    3422:	332020ef          	jal	5754 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	2b050513          	addi	a0,a0,688 # 76d8 <malloc+0x1a76>
    3430:	77a020ef          	jal	5baa <printf>
    exit(1);
    3434:	4505                	li	a0,1
    3436:	31e020ef          	jal	5754 <exit>
    printf("%s: write . succeeded!\n", s);
    343a:	85ca                	mv	a1,s2
    343c:	00004517          	auipc	a0,0x4
    3440:	2c450513          	addi	a0,a0,708 # 7700 <malloc+0x1a9e>
    3444:	766020ef          	jal	5baa <printf>
    exit(1);
    3448:	4505                	li	a0,1
    344a:	30a020ef          	jal	5754 <exit>

000000000000344e <iref>:
{
    344e:	715d                	addi	sp,sp,-80
    3450:	e486                	sd	ra,72(sp)
    3452:	e0a2                	sd	s0,64(sp)
    3454:	fc26                	sd	s1,56(sp)
    3456:	f84a                	sd	s2,48(sp)
    3458:	f44e                	sd	s3,40(sp)
    345a:	f052                	sd	s4,32(sp)
    345c:	ec56                	sd	s5,24(sp)
    345e:	e85a                	sd	s6,16(sp)
    3460:	e45e                	sd	s7,8(sp)
    3462:	0880                	addi	s0,sp,80
    3464:	8baa                	mv	s7,a0
    3466:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    346a:	00004a97          	auipc	s5,0x4
    346e:	2aea8a93          	addi	s5,s5,686 # 7718 <malloc+0x1ab6>
    mkdir("");
    3472:	00004497          	auipc	s1,0x4
    3476:	dae48493          	addi	s1,s1,-594 # 7220 <malloc+0x15be>
    link("README", "");
    347a:	00003b17          	auipc	s6,0x3
    347e:	af6b0b13          	addi	s6,s6,-1290 # 5f70 <malloc+0x30e>
    fd = open("", O_CREATE);
    3482:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3486:	00004997          	auipc	s3,0x4
    348a:	18a98993          	addi	s3,s3,394 # 7610 <malloc+0x19ae>
    348e:	a835                	j	34ca <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3490:	85de                	mv	a1,s7
    3492:	00004517          	auipc	a0,0x4
    3496:	28e50513          	addi	a0,a0,654 # 7720 <malloc+0x1abe>
    349a:	710020ef          	jal	5baa <printf>
      exit(1);
    349e:	4505                	li	a0,1
    34a0:	2b4020ef          	jal	5754 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a4:	85de                	mv	a1,s7
    34a6:	00004517          	auipc	a0,0x4
    34aa:	29250513          	addi	a0,a0,658 # 7738 <malloc+0x1ad6>
    34ae:	6fc020ef          	jal	5baa <printf>
      exit(1);
    34b2:	4505                	li	a0,1
    34b4:	2a0020ef          	jal	5754 <exit>
      close(fd);
    34b8:	2c4020ef          	jal	577c <close>
    34bc:	a825                	j	34f4 <iref+0xa6>
    unlink("xx");
    34be:	854e                	mv	a0,s3
    34c0:	2e4020ef          	jal	57a4 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c4:	397d                	addiw	s2,s2,-1
    34c6:	04090063          	beqz	s2,3506 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34ca:	8556                	mv	a0,s5
    34cc:	2f0020ef          	jal	57bc <mkdir>
    34d0:	f161                	bnez	a0,3490 <iref+0x42>
    if (chdir("irefd") != 0) {
    34d2:	8556                	mv	a0,s5
    34d4:	2f0020ef          	jal	57c4 <chdir>
    34d8:	f571                	bnez	a0,34a4 <iref+0x56>
    mkdir("");
    34da:	8526                	mv	a0,s1
    34dc:	2e0020ef          	jal	57bc <mkdir>
    link("README", "");
    34e0:	85a6                	mv	a1,s1
    34e2:	855a                	mv	a0,s6
    34e4:	2d0020ef          	jal	57b4 <link>
    fd = open("", O_CREATE);
    34e8:	85d2                	mv	a1,s4
    34ea:	8526                	mv	a0,s1
    34ec:	2a8020ef          	jal	5794 <open>
    if (fd >= 0)
    34f0:	fc0554e3          	bgez	a0,34b8 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f4:	85d2                	mv	a1,s4
    34f6:	854e                	mv	a0,s3
    34f8:	29c020ef          	jal	5794 <open>
    if (fd >= 0)
    34fc:	fc0541e3          	bltz	a0,34be <iref+0x70>
      close(fd);
    3500:	27c020ef          	jal	577c <close>
    3504:	bf6d                	j	34be <iref+0x70>
    3506:	03300493          	li	s1,51
    chdir("..");
    350a:	00004997          	auipc	s3,0x4
    350e:	a2e98993          	addi	s3,s3,-1490 # 6f38 <malloc+0x12d6>
    unlink("irefd");
    3512:	00004917          	auipc	s2,0x4
    3516:	20690913          	addi	s2,s2,518 # 7718 <malloc+0x1ab6>
    chdir("..");
    351a:	854e                	mv	a0,s3
    351c:	2a8020ef          	jal	57c4 <chdir>
    unlink("irefd");
    3520:	854a                	mv	a0,s2
    3522:	282020ef          	jal	57a4 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3526:	34fd                	addiw	s1,s1,-1
    3528:	f8ed                	bnez	s1,351a <iref+0xcc>
  chdir("/");
    352a:	00004517          	auipc	a0,0x4
    352e:	9b650513          	addi	a0,a0,-1610 # 6ee0 <malloc+0x127e>
    3532:	292020ef          	jal	57c4 <chdir>
}
    3536:	60a6                	ld	ra,72(sp)
    3538:	6406                	ld	s0,64(sp)
    353a:	74e2                	ld	s1,56(sp)
    353c:	7942                	ld	s2,48(sp)
    353e:	79a2                	ld	s3,40(sp)
    3540:	7a02                	ld	s4,32(sp)
    3542:	6ae2                	ld	s5,24(sp)
    3544:	6b42                	ld	s6,16(sp)
    3546:	6ba2                	ld	s7,8(sp)
    3548:	6161                	addi	sp,sp,80
    354a:	8082                	ret

000000000000354c <unlinkcwd>:
{
    354c:	1101                	addi	sp,sp,-32
    354e:	ec06                	sd	ra,24(sp)
    3550:	e822                	sd	s0,16(sp)
    3552:	e426                	sd	s1,8(sp)
    3554:	1000                	addi	s0,sp,32
    3556:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    3558:	00004517          	auipc	a0,0x4
    355c:	1f850513          	addi	a0,a0,504 # 7750 <malloc+0x1aee>
    3560:	25c020ef          	jal	57bc <mkdir>
    3564:	06054a63          	bltz	a0,35d8 <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    3568:	00004517          	auipc	a0,0x4
    356c:	20850513          	addi	a0,a0,520 # 7770 <malloc+0x1b0e>
    3570:	24c020ef          	jal	57bc <mkdir>
    3574:	06054c63          	bltz	a0,35ec <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    3578:	00004517          	auipc	a0,0x4
    357c:	1f850513          	addi	a0,a0,504 # 7770 <malloc+0x1b0e>
    3580:	244020ef          	jal	57c4 <chdir>
    3584:	06054e63          	bltz	a0,3600 <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    3588:	00004517          	auipc	a0,0x4
    358c:	1e850513          	addi	a0,a0,488 # 7770 <malloc+0x1b0e>
    3590:	214020ef          	jal	57a4 <unlink>
    3594:	08054063          	bltz	a0,3614 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    3598:	00004517          	auipc	a0,0x4
    359c:	1b850513          	addi	a0,a0,440 # 7750 <malloc+0x1aee>
    35a0:	204020ef          	jal	57a4 <unlink>
    35a4:	08054263          	bltz	a0,3628 <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    35a8:	4581                	li	a1,0
    35aa:	00004517          	auipc	a0,0x4
    35ae:	22e50513          	addi	a0,a0,558 # 77d8 <malloc+0x1b76>
    35b2:	1e2020ef          	jal	5794 <open>
    35b6:	08a04363          	bgtz	a0,363c <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    35ba:	20000593          	li	a1,512
    35be:	00004517          	auipc	a0,0x4
    35c2:	24a50513          	addi	a0,a0,586 # 7808 <malloc+0x1ba6>
    35c6:	1ce020ef          	jal	5794 <open>
    35ca:	08a04163          	bgtz	a0,364c <unlinkcwd+0x100>
}
    35ce:	60e2                	ld	ra,24(sp)
    35d0:	6442                	ld	s0,16(sp)
    35d2:	64a2                	ld	s1,8(sp)
    35d4:	6105                	addi	sp,sp,32
    35d6:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00004517          	auipc	a0,0x4
    35de:	17e50513          	addi	a0,a0,382 # 7758 <malloc+0x1af6>
    35e2:	5c8020ef          	jal	5baa <printf>
    exit(1);
    35e6:	4505                	li	a0,1
    35e8:	16c020ef          	jal	5754 <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35ec:	85a6                	mv	a1,s1
    35ee:	00004517          	auipc	a0,0x4
    35f2:	18a50513          	addi	a0,a0,394 # 7778 <malloc+0x1b16>
    35f6:	5b4020ef          	jal	5baa <printf>
    exit(1);
    35fa:	4505                	li	a0,1
    35fc:	158020ef          	jal	5754 <exit>
    printf("%s: chdir failed\n", s);
    3600:	85a6                	mv	a1,s1
    3602:	00004517          	auipc	a0,0x4
    3606:	18e50513          	addi	a0,a0,398 # 7790 <malloc+0x1b2e>
    360a:	5a0020ef          	jal	5baa <printf>
    exit(1);
    360e:	4505                	li	a0,1
    3610:	144020ef          	jal	5754 <exit>
    printf("%s: unlink /a/b failed\n", s);
    3614:	85a6                	mv	a1,s1
    3616:	00004517          	auipc	a0,0x4
    361a:	19250513          	addi	a0,a0,402 # 77a8 <malloc+0x1b46>
    361e:	58c020ef          	jal	5baa <printf>
    exit(1);
    3622:	4505                	li	a0,1
    3624:	130020ef          	jal	5754 <exit>
    printf("%s: unlink /a failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00004517          	auipc	a0,0x4
    362e:	19650513          	addi	a0,a0,406 # 77c0 <malloc+0x1b5e>
    3632:	578020ef          	jal	5baa <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	11c020ef          	jal	5754 <exit>
    printf("%s: open ../ non-existing directory\n", s);
    363c:	85a6                	mv	a1,s1
    363e:	00004517          	auipc	a0,0x4
    3642:	1a250513          	addi	a0,a0,418 # 77e0 <malloc+0x1b7e>
    3646:	564020ef          	jal	5baa <printf>
    364a:	bf85                	j	35ba <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    364c:	85a6                	mv	a1,s1
    364e:	00004517          	auipc	a0,0x4
    3652:	1c250513          	addi	a0,a0,450 # 7810 <malloc+0x1bae>
    3656:	554020ef          	jal	5baa <printf>
}
    365a:	bf95                	j	35ce <unlinkcwd+0x82>

000000000000365c <openiputtest>:
{
    365c:	7179                	addi	sp,sp,-48
    365e:	f406                	sd	ra,40(sp)
    3660:	f022                	sd	s0,32(sp)
    3662:	ec26                	sd	s1,24(sp)
    3664:	1800                	addi	s0,sp,48
    3666:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3668:	00004517          	auipc	a0,0x4
    366c:	1d050513          	addi	a0,a0,464 # 7838 <malloc+0x1bd6>
    3670:	14c020ef          	jal	57bc <mkdir>
    3674:	02054a63          	bltz	a0,36a8 <openiputtest+0x4c>
  pid = fork();
    3678:	0d4020ef          	jal	574c <fork>
  if (pid < 0) {
    367c:	04054063          	bltz	a0,36bc <openiputtest+0x60>
  if (pid == 0) {
    3680:	e939                	bnez	a0,36d6 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3682:	4589                	li	a1,2
    3684:	00004517          	auipc	a0,0x4
    3688:	1b450513          	addi	a0,a0,436 # 7838 <malloc+0x1bd6>
    368c:	108020ef          	jal	5794 <open>
    if (fd >= 0) {
    3690:	04054063          	bltz	a0,36d0 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3694:	85a6                	mv	a1,s1
    3696:	00004517          	auipc	a0,0x4
    369a:	1c250513          	addi	a0,a0,450 # 7858 <malloc+0x1bf6>
    369e:	50c020ef          	jal	5baa <printf>
      exit(1);
    36a2:	4505                	li	a0,1
    36a4:	0b0020ef          	jal	5754 <exit>
    printf("%s: mkdir oidir failed\n", s);
    36a8:	85a6                	mv	a1,s1
    36aa:	00004517          	auipc	a0,0x4
    36ae:	19650513          	addi	a0,a0,406 # 7840 <malloc+0x1bde>
    36b2:	4f8020ef          	jal	5baa <printf>
    exit(1);
    36b6:	4505                	li	a0,1
    36b8:	09c020ef          	jal	5754 <exit>
    printf("%s: fork failed\n", s);
    36bc:	85a6                	mv	a1,s1
    36be:	00003517          	auipc	a0,0x3
    36c2:	f6a50513          	addi	a0,a0,-150 # 6628 <malloc+0x9c6>
    36c6:	4e4020ef          	jal	5baa <printf>
    exit(1);
    36ca:	4505                	li	a0,1
    36cc:	088020ef          	jal	5754 <exit>
    exit(0);
    36d0:	4501                	li	a0,0
    36d2:	082020ef          	jal	5754 <exit>
  pause(1);
    36d6:	4505                	li	a0,1
    36d8:	10c020ef          	jal	57e4 <pause>
  if (unlink("oidir") != 0) {
    36dc:	00004517          	auipc	a0,0x4
    36e0:	15c50513          	addi	a0,a0,348 # 7838 <malloc+0x1bd6>
    36e4:	0c0020ef          	jal	57a4 <unlink>
    36e8:	c919                	beqz	a0,36fe <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36ea:	85a6                	mv	a1,s1
    36ec:	00003517          	auipc	a0,0x3
    36f0:	0c450513          	addi	a0,a0,196 # 67b0 <malloc+0xb4e>
    36f4:	4b6020ef          	jal	5baa <printf>
    exit(1);
    36f8:	4505                	li	a0,1
    36fa:	05a020ef          	jal	5754 <exit>
  wait(&xstatus);
    36fe:	fdc40513          	addi	a0,s0,-36
    3702:	05a020ef          	jal	575c <wait>
  exit(xstatus);
    3706:	fdc42503          	lw	a0,-36(s0)
    370a:	04a020ef          	jal	5754 <exit>

000000000000370e <forkforkfork>:
{
    370e:	1101                	addi	sp,sp,-32
    3710:	ec06                	sd	ra,24(sp)
    3712:	e822                	sd	s0,16(sp)
    3714:	e426                	sd	s1,8(sp)
    3716:	1000                	addi	s0,sp,32
    3718:	84aa                	mv	s1,a0
  unlink("stopforking");
    371a:	00004517          	auipc	a0,0x4
    371e:	16650513          	addi	a0,a0,358 # 7880 <malloc+0x1c1e>
    3722:	082020ef          	jal	57a4 <unlink>
  int pid = fork();
    3726:	026020ef          	jal	574c <fork>
  if (pid < 0) {
    372a:	02054b63          	bltz	a0,3760 <forkforkfork+0x52>
  if (pid == 0) {
    372e:	c139                	beqz	a0,3774 <forkforkfork+0x66>
  pause(20); // two seconds
    3730:	4551                	li	a0,20
    3732:	0b2020ef          	jal	57e4 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3736:	20200593          	li	a1,514
    373a:	00004517          	auipc	a0,0x4
    373e:	14650513          	addi	a0,a0,326 # 7880 <malloc+0x1c1e>
    3742:	052020ef          	jal	5794 <open>
    3746:	036020ef          	jal	577c <close>
  wait(0);
    374a:	4501                	li	a0,0
    374c:	010020ef          	jal	575c <wait>
  pause(10); // one second
    3750:	4529                	li	a0,10
    3752:	092020ef          	jal	57e4 <pause>
}
    3756:	60e2                	ld	ra,24(sp)
    3758:	6442                	ld	s0,16(sp)
    375a:	64a2                	ld	s1,8(sp)
    375c:	6105                	addi	sp,sp,32
    375e:	8082                	ret
    printf("%s: fork failed", s);
    3760:	85a6                	mv	a1,s1
    3762:	00003517          	auipc	a0,0x3
    3766:	00650513          	addi	a0,a0,6 # 6768 <malloc+0xb06>
    376a:	440020ef          	jal	5baa <printf>
    exit(1);
    376e:	4505                	li	a0,1
    3770:	7e5010ef          	jal	5754 <exit>
      int fd = open("stopforking", 0);
    3774:	4581                	li	a1,0
    3776:	00004517          	auipc	a0,0x4
    377a:	10a50513          	addi	a0,a0,266 # 7880 <malloc+0x1c1e>
    377e:	016020ef          	jal	5794 <open>
      if (fd >= 0) {
    3782:	02055163          	bgez	a0,37a4 <forkforkfork+0x96>
      if (fork() < 0) {
    3786:	7c7010ef          	jal	574c <fork>
    378a:	fe0555e3          	bgez	a0,3774 <forkforkfork+0x66>
        close(open("stopforking", O_CREATE | O_RDWR));
    378e:	20200593          	li	a1,514
    3792:	00004517          	auipc	a0,0x4
    3796:	0ee50513          	addi	a0,a0,238 # 7880 <malloc+0x1c1e>
    379a:	7fb010ef          	jal	5794 <open>
    379e:	7df010ef          	jal	577c <close>
    37a2:	bfc9                	j	3774 <forkforkfork+0x66>
        exit(0);
    37a4:	4501                	li	a0,0
    37a6:	7af010ef          	jal	5754 <exit>

00000000000037aa <exectest>:
{
    37aa:	711d                	addi	sp,sp,-96
    37ac:	ec86                	sd	ra,88(sp)
    37ae:	e8a2                	sd	s0,80(sp)
    37b0:	e0ca                	sd	s2,64(sp)
    37b2:	1080                	addi	s0,sp,96
    37b4:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    37b6:	00002797          	auipc	a5,0x2
    37ba:	5e278793          	addi	a5,a5,1506 # 5d98 <malloc+0x136>
    37be:	faf43823          	sd	a5,-80(s0)
    37c2:	00004797          	auipc	a5,0x4
    37c6:	0ce78793          	addi	a5,a5,206 # 7890 <malloc+0x1c2e>
    37ca:	faf43c23          	sd	a5,-72(s0)
    37ce:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37d2:	00004517          	auipc	a0,0x4
    37d6:	0c650513          	addi	a0,a0,198 # 7898 <malloc+0x1c36>
    37da:	7cb010ef          	jal	57a4 <unlink>
  pid = fork();
    37de:	76f010ef          	jal	574c <fork>
  if (pid < 0) {
    37e2:	04054763          	bltz	a0,3830 <exectest+0x86>
    37e6:	e4a6                	sd	s1,72(sp)
    37e8:	fc4e                	sd	s3,56(sp)
    37ea:	84aa                	mv	s1,a0
  if (pid == 0) {
    37ec:	ed49                	bnez	a0,3886 <exectest+0xdc>
    int errfd = dup(1);
    37ee:	4505                	li	a0,1
    37f0:	7dd010ef          	jal	57cc <dup>
    37f4:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37f6:	04054963          	bltz	a0,3848 <exectest+0x9e>
    close(1);
    37fa:	4505                	li	a0,1
    37fc:	781010ef          	jal	577c <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    3800:	20100593          	li	a1,513
    3804:	00004517          	auipc	a0,0x4
    3808:	09450513          	addi	a0,a0,148 # 7898 <malloc+0x1c36>
    380c:	789010ef          	jal	5794 <open>
    if (fd < 0) {
    3810:	04054663          	bltz	a0,385c <exectest+0xb2>
    if (fd != 1) {
    3814:	4785                	li	a5,1
    3816:	04f50e63          	beq	a0,a5,3872 <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    381a:	864a                	mv	a2,s2
    381c:	00004597          	auipc	a1,0x4
    3820:	09458593          	addi	a1,a1,148 # 78b0 <malloc+0x1c4e>
    3824:	854e                	mv	a0,s3
    3826:	35a020ef          	jal	5b80 <fprintf>
      exit(1);
    382a:	4505                	li	a0,1
    382c:	729010ef          	jal	5754 <exit>
    3830:	e4a6                	sd	s1,72(sp)
    3832:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3834:	85ca                	mv	a1,s2
    3836:	00003517          	auipc	a0,0x3
    383a:	df250513          	addi	a0,a0,-526 # 6628 <malloc+0x9c6>
    383e:	36c020ef          	jal	5baa <printf>
    exit(1);
    3842:	4505                	li	a0,1
    3844:	711010ef          	jal	5754 <exit>
      printf("%s: dup failed\n", s);
    3848:	85ca                	mv	a1,s2
    384a:	00004517          	auipc	a0,0x4
    384e:	05650513          	addi	a0,a0,86 # 78a0 <malloc+0x1c3e>
    3852:	358020ef          	jal	5baa <printf>
      exit(1);
    3856:	4505                	li	a0,1
    3858:	6fd010ef          	jal	5754 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    385c:	864a                	mv	a2,s2
    385e:	00003597          	auipc	a1,0x3
    3862:	f3a58593          	addi	a1,a1,-198 # 6798 <malloc+0xb36>
    3866:	854e                	mv	a0,s3
    3868:	318020ef          	jal	5b80 <fprintf>
      exit(1);
    386c:	4505                	li	a0,1
    386e:	6e7010ef          	jal	5754 <exit>
    if (exec("echo", echoargv) < 0) {
    3872:	fb040593          	addi	a1,s0,-80
    3876:	00002517          	auipc	a0,0x2
    387a:	52250513          	addi	a0,a0,1314 # 5d98 <malloc+0x136>
    387e:	70f010ef          	jal	578c <exec>
    3882:	02054563          	bltz	a0,38ac <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3886:	fcc40513          	addi	a0,s0,-52
    388a:	6d3010ef          	jal	575c <wait>
    388e:	02951a63          	bne	a0,s1,38c2 <exectest+0x118>
  if (xstatus != 0) {
    3892:	fcc42603          	lw	a2,-52(s0)
    3896:	ce15                	beqz	a2,38d2 <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3898:	85ca                	mv	a1,s2
    389a:	00004517          	auipc	a0,0x4
    389e:	05650513          	addi	a0,a0,86 # 78f0 <malloc+0x1c8e>
    38a2:	308020ef          	jal	5baa <printf>
    exit(1);
    38a6:	4505                	li	a0,1
    38a8:	6ad010ef          	jal	5754 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    38ac:	864a                	mv	a2,s2
    38ae:	00004597          	auipc	a1,0x4
    38b2:	01258593          	addi	a1,a1,18 # 78c0 <malloc+0x1c5e>
    38b6:	854e                	mv	a0,s3
    38b8:	2c8020ef          	jal	5b80 <fprintf>
      exit(1);
    38bc:	4505                	li	a0,1
    38be:	697010ef          	jal	5754 <exit>
    printf("%s: wait failed!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	01450513          	addi	a0,a0,20 # 78d8 <malloc+0x1c76>
    38cc:	2de020ef          	jal	5baa <printf>
    38d0:	b7c9                	j	3892 <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38d2:	4581                	li	a1,0
    38d4:	00004517          	auipc	a0,0x4
    38d8:	fc450513          	addi	a0,a0,-60 # 7898 <malloc+0x1c36>
    38dc:	6b9010ef          	jal	5794 <open>
  if (fd < 0) {
    38e0:	02054463          	bltz	a0,3908 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38e4:	4609                	li	a2,2
    38e6:	fa840593          	addi	a1,s0,-88
    38ea:	683010ef          	jal	576c <read>
    38ee:	4789                	li	a5,2
    38f0:	02f50663          	beq	a0,a5,391c <exectest+0x172>
    printf("%s: read failed\n", s);
    38f4:	85ca                	mv	a1,s2
    38f6:	00003517          	auipc	a0,0x3
    38fa:	87250513          	addi	a0,a0,-1934 # 6168 <malloc+0x506>
    38fe:	2ac020ef          	jal	5baa <printf>
    exit(1);
    3902:	4505                	li	a0,1
    3904:	651010ef          	jal	5754 <exit>
    printf("%s: open failed\n", s);
    3908:	85ca                	mv	a1,s2
    390a:	00003517          	auipc	a0,0x3
    390e:	d3650513          	addi	a0,a0,-714 # 6640 <malloc+0x9de>
    3912:	298020ef          	jal	5baa <printf>
    exit(1);
    3916:	4505                	li	a0,1
    3918:	63d010ef          	jal	5754 <exit>
  unlink("echo-ok");
    391c:	00004517          	auipc	a0,0x4
    3920:	f7c50513          	addi	a0,a0,-132 # 7898 <malloc+0x1c36>
    3924:	681010ef          	jal	57a4 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3928:	fa844703          	lbu	a4,-88(s0)
    392c:	04f00793          	li	a5,79
    3930:	00f71863          	bne	a4,a5,3940 <exectest+0x196>
    3934:	fa944703          	lbu	a4,-87(s0)
    3938:	04b00793          	li	a5,75
    393c:	00f70c63          	beq	a4,a5,3954 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    3940:	85ca                	mv	a1,s2
    3942:	00004517          	auipc	a0,0x4
    3946:	fce50513          	addi	a0,a0,-50 # 7910 <malloc+0x1cae>
    394a:	260020ef          	jal	5baa <printf>
    exit(1);
    394e:	4505                	li	a0,1
    3950:	605010ef          	jal	5754 <exit>
    exit(0);
    3954:	4501                	li	a0,0
    3956:	5ff010ef          	jal	5754 <exit>

000000000000395a <killstatus>:
{
    395a:	715d                	addi	sp,sp,-80
    395c:	e486                	sd	ra,72(sp)
    395e:	e0a2                	sd	s0,64(sp)
    3960:	fc26                	sd	s1,56(sp)
    3962:	f84a                	sd	s2,48(sp)
    3964:	f44e                	sd	s3,40(sp)
    3966:	f052                	sd	s4,32(sp)
    3968:	ec56                	sd	s5,24(sp)
    396a:	e85a                	sd	s6,16(sp)
    396c:	0880                	addi	s0,sp,80
    396e:	8b2a                	mv	s6,a0
    3970:	06400913          	li	s2,100
    pause(1);
    3974:	4a85                	li	s5,1
    wait(&xst);
    3976:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    397a:	59fd                	li	s3,-1
    int pid1 = fork();
    397c:	5d1010ef          	jal	574c <fork>
    3980:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3982:	02054663          	bltz	a0,39ae <killstatus+0x54>
    if (pid1 == 0) {
    3986:	cd15                	beqz	a0,39c2 <killstatus+0x68>
    pause(1);
    3988:	8556                	mv	a0,s5
    398a:	65b010ef          	jal	57e4 <pause>
    kill(pid1);
    398e:	8526                	mv	a0,s1
    3990:	5f5010ef          	jal	5784 <kill>
    wait(&xst);
    3994:	8552                	mv	a0,s4
    3996:	5c7010ef          	jal	575c <wait>
    if (xst != -1) {
    399a:	fbc42783          	lw	a5,-68(s0)
    399e:	03379563          	bne	a5,s3,39c8 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    39a2:	397d                	addiw	s2,s2,-1
    39a4:	fc091ce3          	bnez	s2,397c <killstatus+0x22>
  exit(0);
    39a8:	4501                	li	a0,0
    39aa:	5ab010ef          	jal	5754 <exit>
      printf("%s: fork failed\n", s);
    39ae:	85da                	mv	a1,s6
    39b0:	00003517          	auipc	a0,0x3
    39b4:	c7850513          	addi	a0,a0,-904 # 6628 <malloc+0x9c6>
    39b8:	1f2020ef          	jal	5baa <printf>
      exit(1);
    39bc:	4505                	li	a0,1
    39be:	597010ef          	jal	5754 <exit>
        getpid();
    39c2:	613010ef          	jal	57d4 <getpid>
      while (1) {
    39c6:	bff5                	j	39c2 <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    39c8:	85da                	mv	a1,s6
    39ca:	00004517          	auipc	a0,0x4
    39ce:	f5e50513          	addi	a0,a0,-162 # 7928 <malloc+0x1cc6>
    39d2:	1d8020ef          	jal	5baa <printf>
      exit(1);
    39d6:	4505                	li	a0,1
    39d8:	57d010ef          	jal	5754 <exit>

00000000000039dc <killzero>:
{
    39dc:	7179                	addi	sp,sp,-48
    39de:	f406                	sd	ra,40(sp)
    39e0:	f022                	sd	s0,32(sp)
    39e2:	e84a                	sd	s2,16(sp)
    39e4:	1800                	addi	s0,sp,48
    39e6:	892a                	mv	s2,a0
  kill(0);
    39e8:	4501                	li	a0,0
    39ea:	59b010ef          	jal	5784 <kill>
  pid = fork();
    39ee:	55f010ef          	jal	574c <fork>
  if (pid < 0) {
    39f2:	00054863          	bltz	a0,3a02 <killzero+0x26>
    39f6:	ec26                	sd	s1,24(sp)
    39f8:	84aa                	mv	s1,a0
  if (pid == 0) {
    39fa:	ed19                	bnez	a0,3a18 <killzero+0x3c>
    exit(7);
    39fc:	451d                	li	a0,7
    39fe:	557010ef          	jal	5754 <exit>
    3a02:	ec26                	sd	s1,24(sp)
    printf("%s: fork failed\n", s);
    3a04:	85ca                	mv	a1,s2
    3a06:	00003517          	auipc	a0,0x3
    3a0a:	c2250513          	addi	a0,a0,-990 # 6628 <malloc+0x9c6>
    3a0e:	19c020ef          	jal	5baa <printf>
    exit(1);
    3a12:	4505                	li	a0,1
    3a14:	541010ef          	jal	5754 <exit>
  if (wait(&xst) != pid) {
    3a18:	fdc40513          	addi	a0,s0,-36
    3a1c:	541010ef          	jal	575c <wait>
    3a20:	02951163          	bne	a0,s1,3a42 <killzero+0x66>
  if (xst != 7) {
    3a24:	fdc42603          	lw	a2,-36(s0)
    3a28:	479d                	li	a5,7
    3a2a:	02f60663          	beq	a2,a5,3a56 <killzero+0x7a>
    printf("%s: child exited with status %d, expected 7\n", s, xst);
    3a2e:	85ca                	mv	a1,s2
    3a30:	00004517          	auipc	a0,0x4
    3a34:	f1850513          	addi	a0,a0,-232 # 7948 <malloc+0x1ce6>
    3a38:	172020ef          	jal	5baa <printf>
    exit(1);
    3a3c:	4505                	li	a0,1
    3a3e:	517010ef          	jal	5754 <exit>
    printf("%s: wait wrong pid\n", s);
    3a42:	85ca                	mv	a1,s2
    3a44:	00003517          	auipc	a0,0x3
    3a48:	cec50513          	addi	a0,a0,-788 # 6730 <malloc+0xace>
    3a4c:	15e020ef          	jal	5baa <printf>
    exit(1);
    3a50:	4505                	li	a0,1
    3a52:	503010ef          	jal	5754 <exit>
  exit(0);
    3a56:	4501                	li	a0,0
    3a58:	4fd010ef          	jal	5754 <exit>

0000000000003a5c <preempt>:
{
    3a5c:	7139                	addi	sp,sp,-64
    3a5e:	fc06                	sd	ra,56(sp)
    3a60:	f822                	sd	s0,48(sp)
    3a62:	f426                	sd	s1,40(sp)
    3a64:	f04a                	sd	s2,32(sp)
    3a66:	ec4e                	sd	s3,24(sp)
    3a68:	e852                	sd	s4,16(sp)
    3a6a:	0080                	addi	s0,sp,64
    3a6c:	892a                	mv	s2,a0
  pid1 = fork();
    3a6e:	4df010ef          	jal	574c <fork>
  if (pid1 < 0) {
    3a72:	00054563          	bltz	a0,3a7c <preempt+0x20>
    3a76:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3a78:	ed01                	bnez	a0,3a90 <preempt+0x34>
    for (;;)
    3a7a:	a001                	j	3a7a <preempt+0x1e>
    printf("%s: fork failed", s);
    3a7c:	85ca                	mv	a1,s2
    3a7e:	00003517          	auipc	a0,0x3
    3a82:	cea50513          	addi	a0,a0,-790 # 6768 <malloc+0xb06>
    3a86:	124020ef          	jal	5baa <printf>
    exit(1);
    3a8a:	4505                	li	a0,1
    3a8c:	4c9010ef          	jal	5754 <exit>
  pid2 = fork();
    3a90:	4bd010ef          	jal	574c <fork>
    3a94:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3a96:	00054463          	bltz	a0,3a9e <preempt+0x42>
  if (pid2 == 0)
    3a9a:	ed01                	bnez	a0,3ab2 <preempt+0x56>
    for (;;)
    3a9c:	a001                	j	3a9c <preempt+0x40>
    printf("%s: fork failed\n", s);
    3a9e:	85ca                	mv	a1,s2
    3aa0:	00003517          	auipc	a0,0x3
    3aa4:	b8850513          	addi	a0,a0,-1144 # 6628 <malloc+0x9c6>
    3aa8:	102020ef          	jal	5baa <printf>
    exit(1);
    3aac:	4505                	li	a0,1
    3aae:	4a7010ef          	jal	5754 <exit>
  pipe(pfds);
    3ab2:	fc840513          	addi	a0,s0,-56
    3ab6:	4af010ef          	jal	5764 <pipe>
  pid3 = fork();
    3aba:	493010ef          	jal	574c <fork>
    3abe:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3ac0:	02054863          	bltz	a0,3af0 <preempt+0x94>
  if (pid3 == 0) {
    3ac4:	e921                	bnez	a0,3b14 <preempt+0xb8>
    close(pfds[0]);
    3ac6:	fc842503          	lw	a0,-56(s0)
    3aca:	4b3010ef          	jal	577c <close>
    if (write(pfds[1], "x", 1) != 1)
    3ace:	4605                	li	a2,1
    3ad0:	00002597          	auipc	a1,0x2
    3ad4:	33858593          	addi	a1,a1,824 # 5e08 <malloc+0x1a6>
    3ad8:	fcc42503          	lw	a0,-52(s0)
    3adc:	499010ef          	jal	5774 <write>
    3ae0:	4785                	li	a5,1
    3ae2:	02f51163          	bne	a0,a5,3b04 <preempt+0xa8>
    close(pfds[1]);
    3ae6:	fcc42503          	lw	a0,-52(s0)
    3aea:	493010ef          	jal	577c <close>
    for (;;)
    3aee:	a001                	j	3aee <preempt+0x92>
    printf("%s: fork failed\n", s);
    3af0:	85ca                	mv	a1,s2
    3af2:	00003517          	auipc	a0,0x3
    3af6:	b3650513          	addi	a0,a0,-1226 # 6628 <malloc+0x9c6>
    3afa:	0b0020ef          	jal	5baa <printf>
    exit(1);
    3afe:	4505                	li	a0,1
    3b00:	455010ef          	jal	5754 <exit>
      printf("%s: preempt write error", s);
    3b04:	85ca                	mv	a1,s2
    3b06:	00004517          	auipc	a0,0x4
    3b0a:	e7250513          	addi	a0,a0,-398 # 7978 <malloc+0x1d16>
    3b0e:	09c020ef          	jal	5baa <printf>
    3b12:	bfd1                	j	3ae6 <preempt+0x8a>
  close(pfds[1]);
    3b14:	fcc42503          	lw	a0,-52(s0)
    3b18:	465010ef          	jal	577c <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3b1c:	660d                	lui	a2,0x3
    3b1e:	0000a597          	auipc	a1,0xa
    3b22:	1da58593          	addi	a1,a1,474 # dcf8 <buf>
    3b26:	fc842503          	lw	a0,-56(s0)
    3b2a:	443010ef          	jal	576c <read>
    3b2e:	4785                	li	a5,1
    3b30:	02f50163          	beq	a0,a5,3b52 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3b34:	85ca                	mv	a1,s2
    3b36:	00004517          	auipc	a0,0x4
    3b3a:	e5a50513          	addi	a0,a0,-422 # 7990 <malloc+0x1d2e>
    3b3e:	06c020ef          	jal	5baa <printf>
}
    3b42:	70e2                	ld	ra,56(sp)
    3b44:	7442                	ld	s0,48(sp)
    3b46:	74a2                	ld	s1,40(sp)
    3b48:	7902                	ld	s2,32(sp)
    3b4a:	69e2                	ld	s3,24(sp)
    3b4c:	6a42                	ld	s4,16(sp)
    3b4e:	6121                	addi	sp,sp,64
    3b50:	8082                	ret
  close(pfds[0]);
    3b52:	fc842503          	lw	a0,-56(s0)
    3b56:	427010ef          	jal	577c <close>
  printf("kill... ");
    3b5a:	00004517          	auipc	a0,0x4
    3b5e:	e4e50513          	addi	a0,a0,-434 # 79a8 <malloc+0x1d46>
    3b62:	048020ef          	jal	5baa <printf>
  kill(pid1);
    3b66:	8526                	mv	a0,s1
    3b68:	41d010ef          	jal	5784 <kill>
  kill(pid2);
    3b6c:	854e                	mv	a0,s3
    3b6e:	417010ef          	jal	5784 <kill>
  kill(pid3);
    3b72:	8552                	mv	a0,s4
    3b74:	411010ef          	jal	5784 <kill>
  printf("wait... ");
    3b78:	00004517          	auipc	a0,0x4
    3b7c:	e4050513          	addi	a0,a0,-448 # 79b8 <malloc+0x1d56>
    3b80:	02a020ef          	jal	5baa <printf>
  wait(0);
    3b84:	4501                	li	a0,0
    3b86:	3d7010ef          	jal	575c <wait>
  wait(0);
    3b8a:	4501                	li	a0,0
    3b8c:	3d1010ef          	jal	575c <wait>
  wait(0);
    3b90:	4501                	li	a0,0
    3b92:	3cb010ef          	jal	575c <wait>
    3b96:	b775                	j	3b42 <preempt+0xe6>

0000000000003b98 <reparent>:
{
    3b98:	7179                	addi	sp,sp,-48
    3b9a:	f406                	sd	ra,40(sp)
    3b9c:	f022                	sd	s0,32(sp)
    3b9e:	ec26                	sd	s1,24(sp)
    3ba0:	e84a                	sd	s2,16(sp)
    3ba2:	e44e                	sd	s3,8(sp)
    3ba4:	e052                	sd	s4,0(sp)
    3ba6:	1800                	addi	s0,sp,48
    3ba8:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3baa:	42b010ef          	jal	57d4 <getpid>
    3bae:	8a2a                	mv	s4,a0
    3bb0:	0c800913          	li	s2,200
    int pid = fork();
    3bb4:	399010ef          	jal	574c <fork>
    3bb8:	84aa                	mv	s1,a0
    if (pid < 0) {
    3bba:	00054e63          	bltz	a0,3bd6 <reparent+0x3e>
    if (pid) {
    3bbe:	c121                	beqz	a0,3bfe <reparent+0x66>
      if (wait(0) != pid) {
    3bc0:	4501                	li	a0,0
    3bc2:	39b010ef          	jal	575c <wait>
    3bc6:	02951263          	bne	a0,s1,3bea <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3bca:	397d                	addiw	s2,s2,-1
    3bcc:	fe0914e3          	bnez	s2,3bb4 <reparent+0x1c>
  exit(0);
    3bd0:	4501                	li	a0,0
    3bd2:	383010ef          	jal	5754 <exit>
      printf("%s: fork failed\n", s);
    3bd6:	85ce                	mv	a1,s3
    3bd8:	00003517          	auipc	a0,0x3
    3bdc:	a5050513          	addi	a0,a0,-1456 # 6628 <malloc+0x9c6>
    3be0:	7cb010ef          	jal	5baa <printf>
      exit(1);
    3be4:	4505                	li	a0,1
    3be6:	36f010ef          	jal	5754 <exit>
        printf("%s: wait wrong pid\n", s);
    3bea:	85ce                	mv	a1,s3
    3bec:	00003517          	auipc	a0,0x3
    3bf0:	b4450513          	addi	a0,a0,-1212 # 6730 <malloc+0xace>
    3bf4:	7b7010ef          	jal	5baa <printf>
        exit(1);
    3bf8:	4505                	li	a0,1
    3bfa:	35b010ef          	jal	5754 <exit>
      int pid2 = fork();
    3bfe:	34f010ef          	jal	574c <fork>
      if (pid2 < 0) {
    3c02:	00054563          	bltz	a0,3c0c <reparent+0x74>
      exit(0);
    3c06:	4501                	li	a0,0
    3c08:	34d010ef          	jal	5754 <exit>
        kill(master_pid);
    3c0c:	8552                	mv	a0,s4
    3c0e:	377010ef          	jal	5784 <kill>
        exit(1);
    3c12:	4505                	li	a0,1
    3c14:	341010ef          	jal	5754 <exit>

0000000000003c18 <sbrkfail>:
{
    3c18:	7175                	addi	sp,sp,-144
    3c1a:	e506                	sd	ra,136(sp)
    3c1c:	e122                	sd	s0,128(sp)
    3c1e:	fca6                	sd	s1,120(sp)
    3c20:	f8ca                	sd	s2,112(sp)
    3c22:	f4ce                	sd	s3,104(sp)
    3c24:	f0d2                	sd	s4,96(sp)
    3c26:	ecd6                	sd	s5,88(sp)
    3c28:	e8da                	sd	s6,80(sp)
    3c2a:	e4de                	sd	s7,72(sp)
    3c2c:	e0e2                	sd	s8,64(sp)
    3c2e:	0900                	addi	s0,sp,144
    3c30:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3c32:	fa040513          	addi	a0,s0,-96
    3c36:	32f010ef          	jal	5764 <pipe>
    3c3a:	ed01                	bnez	a0,3c52 <sbrkfail+0x3a>
    3c3c:	8baa                	mv	s7,a0
    3c3e:	f7040493          	addi	s1,s0,-144
    3c42:	f9840993          	addi	s3,s0,-104
    3c46:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3c48:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3c4a:	f9f40b13          	addi	s6,s0,-97
    3c4e:	4a85                	li	s5,1
    3c50:	a095                	j	3cb4 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3c52:	85e2                	mv	a1,s8
    3c54:	00003517          	auipc	a0,0x3
    3c58:	a5c50513          	addi	a0,a0,-1444 # 66b0 <malloc+0xa4e>
    3c5c:	74f010ef          	jal	5baa <printf>
    exit(1);
    3c60:	4505                	li	a0,1
    3c62:	2f3010ef          	jal	5754 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3c66:	2bb010ef          	jal	5720 <sbrk>
    3c6a:	064007b7          	lui	a5,0x6400
    3c6e:	40a7853b          	subw	a0,a5,a0
    3c72:	2af010ef          	jal	5720 <sbrk>
    3c76:	57fd                	li	a5,-1
    3c78:	02f50163          	beq	a0,a5,3c9a <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3c7c:	4605                	li	a2,1
    3c7e:	00004597          	auipc	a1,0x4
    3c82:	6f258593          	addi	a1,a1,1778 # 8370 <malloc+0x270e>
    3c86:	fa442503          	lw	a0,-92(s0)
    3c8a:	2eb010ef          	jal	5774 <write>
        pause(1000);
    3c8e:	3e800493          	li	s1,1000
    3c92:	8526                	mv	a0,s1
    3c94:	351010ef          	jal	57e4 <pause>
      for (;;)
    3c98:	bfed                	j	3c92 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3c9a:	4605                	li	a2,1
    3c9c:	00004597          	auipc	a1,0x4
    3ca0:	d2c58593          	addi	a1,a1,-724 # 79c8 <malloc+0x1d66>
    3ca4:	fa442503          	lw	a0,-92(s0)
    3ca8:	2cd010ef          	jal	5774 <write>
    3cac:	b7cd                	j	3c8e <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3cae:	0911                	addi	s2,s2,4
    3cb0:	03390a63          	beq	s2,s3,3ce4 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3cb4:	299010ef          	jal	574c <fork>
    3cb8:	00a92023          	sw	a0,0(s2)
    3cbc:	d54d                	beqz	a0,3c66 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3cbe:	ff4508e3          	beq	a0,s4,3cae <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3cc2:	8656                	mv	a2,s5
    3cc4:	85da                	mv	a1,s6
    3cc6:	fa042503          	lw	a0,-96(s0)
    3cca:	2a3010ef          	jal	576c <read>
      if (scratch == '0')
    3cce:	f9f44783          	lbu	a5,-97(s0)
    3cd2:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef2d8>
    3cd6:	0017b793          	seqz	a5,a5
    3cda:	00fbe7b3          	or	a5,s7,a5
    3cde:	00078b9b          	sext.w	s7,a5
    3ce2:	b7f1                	j	3cae <sbrkfail+0x96>
  if (!failed) {
    3ce4:	000b8863          	beqz	s7,3cf4 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3ce8:	6505                	lui	a0,0x1
    3cea:	237010ef          	jal	5720 <sbrk>
    3cee:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3cf0:	597d                	li	s2,-1
    3cf2:	a821                	j	3d0a <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3cf4:	85e2                	mv	a1,s8
    3cf6:	00004517          	auipc	a0,0x4
    3cfa:	cda50513          	addi	a0,a0,-806 # 79d0 <malloc+0x1d6e>
    3cfe:	6ad010ef          	jal	5baa <printf>
    3d02:	b7dd                	j	3ce8 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3d04:	0491                	addi	s1,s1,4
    3d06:	01348b63          	beq	s1,s3,3d1c <sbrkfail+0x104>
    if (pids[i] == -1)
    3d0a:	4088                	lw	a0,0(s1)
    3d0c:	ff250ce3          	beq	a0,s2,3d04 <sbrkfail+0xec>
    kill(pids[i]);
    3d10:	275010ef          	jal	5784 <kill>
    wait(0);
    3d14:	4501                	li	a0,0
    3d16:	247010ef          	jal	575c <wait>
    3d1a:	b7ed                	j	3d04 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3d1c:	57fd                	li	a5,-1
    3d1e:	02fa0a63          	beq	s4,a5,3d52 <sbrkfail+0x13a>
  pid = fork();
    3d22:	22b010ef          	jal	574c <fork>
  if (pid < 0) {
    3d26:	04054063          	bltz	a0,3d66 <sbrkfail+0x14e>
  if (pid == 0) {
    3d2a:	e939                	bnez	a0,3d80 <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3d2c:	3e800537          	lui	a0,0x3e800
    3d30:	1f1010ef          	jal	5720 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3d34:	57fd                	li	a5,-1
    3d36:	04f50263          	beq	a0,a5,3d7a <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3d3a:	3e800637          	lui	a2,0x3e800
    3d3e:	85e2                	mv	a1,s8
    3d40:	00004517          	auipc	a0,0x4
    3d44:	ce050513          	addi	a0,a0,-800 # 7a20 <malloc+0x1dbe>
    3d48:	663010ef          	jal	5baa <printf>
    exit(1);
    3d4c:	4505                	li	a0,1
    3d4e:	207010ef          	jal	5754 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3d52:	85e2                	mv	a1,s8
    3d54:	00004517          	auipc	a0,0x4
    3d58:	cac50513          	addi	a0,a0,-852 # 7a00 <malloc+0x1d9e>
    3d5c:	64f010ef          	jal	5baa <printf>
    exit(1);
    3d60:	4505                	li	a0,1
    3d62:	1f3010ef          	jal	5754 <exit>
    printf("%s: fork failed\n", s);
    3d66:	85e2                	mv	a1,s8
    3d68:	00003517          	auipc	a0,0x3
    3d6c:	8c050513          	addi	a0,a0,-1856 # 6628 <malloc+0x9c6>
    3d70:	63b010ef          	jal	5baa <printf>
    exit(1);
    3d74:	4505                	li	a0,1
    3d76:	1df010ef          	jal	5754 <exit>
      exit(0);
    3d7a:	4501                	li	a0,0
    3d7c:	1d9010ef          	jal	5754 <exit>
  wait(&xstatus);
    3d80:	fac40513          	addi	a0,s0,-84
    3d84:	1d9010ef          	jal	575c <wait>
  if (xstatus != 0)
    3d88:	fac42783          	lw	a5,-84(s0)
    3d8c:	ef89                	bnez	a5,3da6 <sbrkfail+0x18e>
}
    3d8e:	60aa                	ld	ra,136(sp)
    3d90:	640a                	ld	s0,128(sp)
    3d92:	74e6                	ld	s1,120(sp)
    3d94:	7946                	ld	s2,112(sp)
    3d96:	79a6                	ld	s3,104(sp)
    3d98:	7a06                	ld	s4,96(sp)
    3d9a:	6ae6                	ld	s5,88(sp)
    3d9c:	6b46                	ld	s6,80(sp)
    3d9e:	6ba6                	ld	s7,72(sp)
    3da0:	6c06                	ld	s8,64(sp)
    3da2:	6149                	addi	sp,sp,144
    3da4:	8082                	ret
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	1ad010ef          	jal	5754 <exit>

0000000000003dac <mem>:
{
    3dac:	7139                	addi	sp,sp,-64
    3dae:	fc06                	sd	ra,56(sp)
    3db0:	f822                	sd	s0,48(sp)
    3db2:	f426                	sd	s1,40(sp)
    3db4:	f04a                	sd	s2,32(sp)
    3db6:	ec4e                	sd	s3,24(sp)
    3db8:	0080                	addi	s0,sp,64
    3dba:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3dbc:	191010ef          	jal	574c <fork>
    m1 = 0;
    3dc0:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3dc2:	6909                	lui	s2,0x2
    3dc4:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xed>
  if ((pid = fork()) == 0) {
    3dc8:	cd11                	beqz	a0,3de4 <mem+0x38>
    wait(&xstatus);
    3dca:	fcc40513          	addi	a0,s0,-52
    3dce:	18f010ef          	jal	575c <wait>
    if (xstatus == -1) {
    3dd2:	fcc42503          	lw	a0,-52(s0)
    3dd6:	57fd                	li	a5,-1
    3dd8:	04f50363          	beq	a0,a5,3e1e <mem+0x72>
    exit(xstatus);
    3ddc:	179010ef          	jal	5754 <exit>
      *(char **)m2 = m1;
    3de0:	e104                	sd	s1,0(a0)
      m1 = m2;
    3de2:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3de4:	854a                	mv	a0,s2
    3de6:	67d010ef          	jal	5c62 <malloc>
    3dea:	f97d                	bnez	a0,3de0 <mem+0x34>
    while (m1) {
    3dec:	c491                	beqz	s1,3df8 <mem+0x4c>
      m2 = *(char **)m1;
    3dee:	8526                	mv	a0,s1
    3df0:	6084                	ld	s1,0(s1)
      free(m1);
    3df2:	5eb010ef          	jal	5bdc <free>
    while (m1) {
    3df6:	fce5                	bnez	s1,3dee <mem+0x42>
    m1 = malloc(1024 * 20);
    3df8:	6515                	lui	a0,0x5
    3dfa:	669010ef          	jal	5c62 <malloc>
    if (m1 == 0) {
    3dfe:	c511                	beqz	a0,3e0a <mem+0x5e>
    free(m1);
    3e00:	5dd010ef          	jal	5bdc <free>
    exit(0);
    3e04:	4501                	li	a0,0
    3e06:	14f010ef          	jal	5754 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3e0a:	85ce                	mv	a1,s3
    3e0c:	00004517          	auipc	a0,0x4
    3e10:	c4450513          	addi	a0,a0,-956 # 7a50 <malloc+0x1dee>
    3e14:	597010ef          	jal	5baa <printf>
      exit(1);
    3e18:	4505                	li	a0,1
    3e1a:	13b010ef          	jal	5754 <exit>
      exit(0);
    3e1e:	4501                	li	a0,0
    3e20:	135010ef          	jal	5754 <exit>

0000000000003e24 <sharedfd>:
{
    3e24:	7159                	addi	sp,sp,-112
    3e26:	f486                	sd	ra,104(sp)
    3e28:	f0a2                	sd	s0,96(sp)
    3e2a:	eca6                	sd	s1,88(sp)
    3e2c:	f85a                	sd	s6,48(sp)
    3e2e:	1880                	addi	s0,sp,112
    3e30:	84aa                	mv	s1,a0
    3e32:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3e34:	00004517          	auipc	a0,0x4
    3e38:	c3c50513          	addi	a0,a0,-964 # 7a70 <malloc+0x1e0e>
    3e3c:	169010ef          	jal	57a4 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3e40:	20200593          	li	a1,514
    3e44:	00004517          	auipc	a0,0x4
    3e48:	c2c50513          	addi	a0,a0,-980 # 7a70 <malloc+0x1e0e>
    3e4c:	149010ef          	jal	5794 <open>
  if (fd < 0) {
    3e50:	04054863          	bltz	a0,3ea0 <sharedfd+0x7c>
    3e54:	e8ca                	sd	s2,80(sp)
    3e56:	e4ce                	sd	s3,72(sp)
    3e58:	e0d2                	sd	s4,64(sp)
    3e5a:	fc56                	sd	s5,56(sp)
    3e5c:	89aa                	mv	s3,a0
  pid = fork();
    3e5e:	0ef010ef          	jal	574c <fork>
    3e62:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3e64:	07000593          	li	a1,112
    3e68:	e119                	bnez	a0,3e6e <sharedfd+0x4a>
    3e6a:	06300593          	li	a1,99
    3e6e:	4629                	li	a2,10
    3e70:	fa040513          	addi	a0,s0,-96
    3e74:	6b6010ef          	jal	552a <memset>
    3e78:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3e7c:	fa040a13          	addi	s4,s0,-96
    3e80:	4929                	li	s2,10
    3e82:	864a                	mv	a2,s2
    3e84:	85d2                	mv	a1,s4
    3e86:	854e                	mv	a0,s3
    3e88:	0ed010ef          	jal	5774 <write>
    3e8c:	03251963          	bne	a0,s2,3ebe <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3e90:	34fd                	addiw	s1,s1,-1
    3e92:	f8e5                	bnez	s1,3e82 <sharedfd+0x5e>
  if (pid == 0) {
    3e94:	040a9063          	bnez	s5,3ed4 <sharedfd+0xb0>
    3e98:	f45e                	sd	s7,40(sp)
    exit(0);
    3e9a:	4501                	li	a0,0
    3e9c:	0b9010ef          	jal	5754 <exit>
    3ea0:	e8ca                	sd	s2,80(sp)
    3ea2:	e4ce                	sd	s3,72(sp)
    3ea4:	e0d2                	sd	s4,64(sp)
    3ea6:	fc56                	sd	s5,56(sp)
    3ea8:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3eaa:	85a6                	mv	a1,s1
    3eac:	00004517          	auipc	a0,0x4
    3eb0:	bd450513          	addi	a0,a0,-1068 # 7a80 <malloc+0x1e1e>
    3eb4:	4f7010ef          	jal	5baa <printf>
    exit(1);
    3eb8:	4505                	li	a0,1
    3eba:	09b010ef          	jal	5754 <exit>
    3ebe:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3ec0:	85da                	mv	a1,s6
    3ec2:	00004517          	auipc	a0,0x4
    3ec6:	be650513          	addi	a0,a0,-1050 # 7aa8 <malloc+0x1e46>
    3eca:	4e1010ef          	jal	5baa <printf>
      exit(1);
    3ece:	4505                	li	a0,1
    3ed0:	085010ef          	jal	5754 <exit>
    wait(&xstatus);
    3ed4:	f9c40513          	addi	a0,s0,-100
    3ed8:	085010ef          	jal	575c <wait>
    if (xstatus != 0)
    3edc:	f9c42a03          	lw	s4,-100(s0)
    3ee0:	000a0663          	beqz	s4,3eec <sharedfd+0xc8>
    3ee4:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3ee6:	8552                	mv	a0,s4
    3ee8:	06d010ef          	jal	5754 <exit>
    3eec:	f45e                	sd	s7,40(sp)
  close(fd);
    3eee:	854e                	mv	a0,s3
    3ef0:	08d010ef          	jal	577c <close>
  fd = open("sharedfd", 0);
    3ef4:	4581                	li	a1,0
    3ef6:	00004517          	auipc	a0,0x4
    3efa:	b7a50513          	addi	a0,a0,-1158 # 7a70 <malloc+0x1e0e>
    3efe:	097010ef          	jal	5794 <open>
    3f02:	8baa                	mv	s7,a0
  nc = np = 0;
    3f04:	89d2                	mv	s3,s4
  if (fd < 0) {
    3f06:	02054363          	bltz	a0,3f2c <sharedfd+0x108>
    3f0a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3f0e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3f12:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f16:	4629                	li	a2,10
    3f18:	fa040593          	addi	a1,s0,-96
    3f1c:	855e                	mv	a0,s7
    3f1e:	04f010ef          	jal	576c <read>
    3f22:	02a05b63          	blez	a0,3f58 <sharedfd+0x134>
    3f26:	fa040793          	addi	a5,s0,-96
    3f2a:	a839                	j	3f48 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3f2c:	85da                	mv	a1,s6
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	b9a50513          	addi	a0,a0,-1126 # 7ac8 <malloc+0x1e66>
    3f36:	475010ef          	jal	5baa <printf>
    exit(1);
    3f3a:	4505                	li	a0,1
    3f3c:	019010ef          	jal	5754 <exit>
        nc++;
    3f40:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3f42:	0785                	addi	a5,a5,1
    3f44:	fd2789e3          	beq	a5,s2,3f16 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3f48:	0007c703          	lbu	a4,0(a5)
    3f4c:	fe970ae3          	beq	a4,s1,3f40 <sharedfd+0x11c>
      if (buf[i] == 'p')
    3f50:	ff5719e3          	bne	a4,s5,3f42 <sharedfd+0x11e>
        np++;
    3f54:	2985                	addiw	s3,s3,1
    3f56:	b7f5                	j	3f42 <sharedfd+0x11e>
  close(fd);
    3f58:	855e                	mv	a0,s7
    3f5a:	023010ef          	jal	577c <close>
  unlink("sharedfd");
    3f5e:	00004517          	auipc	a0,0x4
    3f62:	b1250513          	addi	a0,a0,-1262 # 7a70 <malloc+0x1e0e>
    3f66:	03f010ef          	jal	57a4 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3f6a:	6789                	lui	a5,0x2
    3f6c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xec>
    3f70:	00fa1763          	bne	s4,a5,3f7e <sharedfd+0x15a>
    3f74:	01499563          	bne	s3,s4,3f7e <sharedfd+0x15a>
    exit(0);
    3f78:	4501                	li	a0,0
    3f7a:	7da010ef          	jal	5754 <exit>
    printf("%s: nc/np test fails\n", s);
    3f7e:	85da                	mv	a1,s6
    3f80:	00004517          	auipc	a0,0x4
    3f84:	b7050513          	addi	a0,a0,-1168 # 7af0 <malloc+0x1e8e>
    3f88:	423010ef          	jal	5baa <printf>
    exit(1);
    3f8c:	4505                	li	a0,1
    3f8e:	7c6010ef          	jal	5754 <exit>

0000000000003f92 <fourfiles>:
{
    3f92:	7135                	addi	sp,sp,-160
    3f94:	ed06                	sd	ra,152(sp)
    3f96:	e922                	sd	s0,144(sp)
    3f98:	e526                	sd	s1,136(sp)
    3f9a:	e14a                	sd	s2,128(sp)
    3f9c:	fcce                	sd	s3,120(sp)
    3f9e:	f8d2                	sd	s4,112(sp)
    3fa0:	f4d6                	sd	s5,104(sp)
    3fa2:	f0da                	sd	s6,96(sp)
    3fa4:	ecde                	sd	s7,88(sp)
    3fa6:	e8e2                	sd	s8,80(sp)
    3fa8:	e4e6                	sd	s9,72(sp)
    3faa:	e0ea                	sd	s10,64(sp)
    3fac:	fc6e                	sd	s11,56(sp)
    3fae:	1100                	addi	s0,sp,160
    3fb0:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fb2:	00004797          	auipc	a5,0x4
    3fb6:	b5678793          	addi	a5,a5,-1194 # 7b08 <malloc+0x1ea6>
    3fba:	f6f43823          	sd	a5,-144(s0)
    3fbe:	00004797          	auipc	a5,0x4
    3fc2:	b5278793          	addi	a5,a5,-1198 # 7b10 <malloc+0x1eae>
    3fc6:	f6f43c23          	sd	a5,-136(s0)
    3fca:	00004797          	auipc	a5,0x4
    3fce:	b4e78793          	addi	a5,a5,-1202 # 7b18 <malloc+0x1eb6>
    3fd2:	f8f43023          	sd	a5,-128(s0)
    3fd6:	00004797          	auipc	a5,0x4
    3fda:	b4a78793          	addi	a5,a5,-1206 # 7b20 <malloc+0x1ebe>
    3fde:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3fe2:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fe6:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3fe8:	4481                	li	s1,0
    3fea:	4a11                	li	s4,4
    fname = names[pi];
    3fec:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3ff0:	854e                	mv	a0,s3
    3ff2:	7b2010ef          	jal	57a4 <unlink>
    pid = fork();
    3ff6:	756010ef          	jal	574c <fork>
    if (pid < 0) {
    3ffa:	04054063          	bltz	a0,403a <fourfiles+0xa8>
    if (pid == 0) {
    3ffe:	c921                	beqz	a0,404e <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    4000:	2485                	addiw	s1,s1,1
    4002:	0921                	addi	s2,s2,8
    4004:	ff4494e3          	bne	s1,s4,3fec <fourfiles+0x5a>
    4008:	4491                	li	s1,4
    wait(&xstatus);
    400a:	f6c40913          	addi	s2,s0,-148
    400e:	854a                	mv	a0,s2
    4010:	74c010ef          	jal	575c <wait>
    if (xstatus != 0)
    4014:	f6c42b03          	lw	s6,-148(s0)
    4018:	0a0b1463          	bnez	s6,40c0 <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    401c:	34fd                	addiw	s1,s1,-1
    401e:	f8e5                	bnez	s1,400e <fourfiles+0x7c>
    4020:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4024:	6a8d                	lui	s5,0x3
    4026:	0000aa17          	auipc	s4,0xa
    402a:	cd2a0a13          	addi	s4,s4,-814 # dcf8 <buf>
    if (total != N * SZ) {
    402e:	6d05                	lui	s10,0x1
    4030:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    4034:	03400d93          	li	s11,52
    4038:	a86d                	j	40f2 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    403a:	85e6                	mv	a1,s9
    403c:	00002517          	auipc	a0,0x2
    4040:	5ec50513          	addi	a0,a0,1516 # 6628 <malloc+0x9c6>
    4044:	367010ef          	jal	5baa <printf>
      exit(1);
    4048:	4505                	li	a0,1
    404a:	70a010ef          	jal	5754 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    404e:	20200593          	li	a1,514
    4052:	854e                	mv	a0,s3
    4054:	740010ef          	jal	5794 <open>
    4058:	892a                	mv	s2,a0
      if (fd < 0) {
    405a:	04054063          	bltz	a0,409a <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    405e:	1f400613          	li	a2,500
    4062:	0304859b          	addiw	a1,s1,48
    4066:	0000a517          	auipc	a0,0xa
    406a:	c9250513          	addi	a0,a0,-878 # dcf8 <buf>
    406e:	4bc010ef          	jal	552a <memset>
    4072:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4074:	1f400993          	li	s3,500
    4078:	0000aa17          	auipc	s4,0xa
    407c:	c80a0a13          	addi	s4,s4,-896 # dcf8 <buf>
    4080:	864e                	mv	a2,s3
    4082:	85d2                	mv	a1,s4
    4084:	854a                	mv	a0,s2
    4086:	6ee010ef          	jal	5774 <write>
    408a:	85aa                	mv	a1,a0
    408c:	03351163          	bne	a0,s3,40ae <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    4090:	34fd                	addiw	s1,s1,-1
    4092:	f4fd                	bnez	s1,4080 <fourfiles+0xee>
      exit(0);
    4094:	4501                	li	a0,0
    4096:	6be010ef          	jal	5754 <exit>
        printf("%s: create failed\n", s);
    409a:	85e6                	mv	a1,s9
    409c:	00002517          	auipc	a0,0x2
    40a0:	6fc50513          	addi	a0,a0,1788 # 6798 <malloc+0xb36>
    40a4:	307010ef          	jal	5baa <printf>
        exit(1);
    40a8:	4505                	li	a0,1
    40aa:	6aa010ef          	jal	5754 <exit>
          printf("write failed %d\n", n);
    40ae:	00004517          	auipc	a0,0x4
    40b2:	a7a50513          	addi	a0,a0,-1414 # 7b28 <malloc+0x1ec6>
    40b6:	2f5010ef          	jal	5baa <printf>
          exit(1);
    40ba:	4505                	li	a0,1
    40bc:	698010ef          	jal	5754 <exit>
      exit(xstatus);
    40c0:	855a                	mv	a0,s6
    40c2:	692010ef          	jal	5754 <exit>
          printf("%s: wrong char\n", s);
    40c6:	85e6                	mv	a1,s9
    40c8:	00004517          	auipc	a0,0x4
    40cc:	a7850513          	addi	a0,a0,-1416 # 7b40 <malloc+0x1ede>
    40d0:	2db010ef          	jal	5baa <printf>
          exit(1);
    40d4:	4505                	li	a0,1
    40d6:	67e010ef          	jal	5754 <exit>
    close(fd);
    40da:	854e                	mv	a0,s3
    40dc:	6a0010ef          	jal	577c <close>
    if (total != N * SZ) {
    40e0:	05a91863          	bne	s2,s10,4130 <fourfiles+0x19e>
    unlink(fname);
    40e4:	8562                	mv	a0,s8
    40e6:	6be010ef          	jal	57a4 <unlink>
  for (i = 0; i < NCHILD; i++) {
    40ea:	0ba1                	addi	s7,s7,8
    40ec:	2485                	addiw	s1,s1,1
    40ee:	05b48b63          	beq	s1,s11,4144 <fourfiles+0x1b2>
    fname = names[i];
    40f2:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    40f6:	4581                	li	a1,0
    40f8:	8562                	mv	a0,s8
    40fa:	69a010ef          	jal	5794 <open>
    40fe:	89aa                	mv	s3,a0
    total = 0;
    4100:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4102:	8656                	mv	a2,s5
    4104:	85d2                	mv	a1,s4
    4106:	854e                	mv	a0,s3
    4108:	664010ef          	jal	576c <read>
    410c:	fca057e3          	blez	a0,40da <fourfiles+0x148>
    4110:	0000a797          	auipc	a5,0xa
    4114:	be878793          	addi	a5,a5,-1048 # dcf8 <buf>
    4118:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    411c:	0007c703          	lbu	a4,0(a5)
    4120:	fa9713e3          	bne	a4,s1,40c6 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    4124:	0785                	addi	a5,a5,1
    4126:	fed79be3          	bne	a5,a3,411c <fourfiles+0x18a>
      total += n;
    412a:	00a9093b          	addw	s2,s2,a0
    412e:	bfd1                	j	4102 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    4130:	85ca                	mv	a1,s2
    4132:	00004517          	auipc	a0,0x4
    4136:	a1e50513          	addi	a0,a0,-1506 # 7b50 <malloc+0x1eee>
    413a:	271010ef          	jal	5baa <printf>
      exit(1);
    413e:	4505                	li	a0,1
    4140:	614010ef          	jal	5754 <exit>
}
    4144:	60ea                	ld	ra,152(sp)
    4146:	644a                	ld	s0,144(sp)
    4148:	64aa                	ld	s1,136(sp)
    414a:	690a                	ld	s2,128(sp)
    414c:	79e6                	ld	s3,120(sp)
    414e:	7a46                	ld	s4,112(sp)
    4150:	7aa6                	ld	s5,104(sp)
    4152:	7b06                	ld	s6,96(sp)
    4154:	6be6                	ld	s7,88(sp)
    4156:	6c46                	ld	s8,80(sp)
    4158:	6ca6                	ld	s9,72(sp)
    415a:	6d06                	ld	s10,64(sp)
    415c:	7de2                	ld	s11,56(sp)
    415e:	610d                	addi	sp,sp,160
    4160:	8082                	ret

0000000000004162 <concreate>:
{
    4162:	7171                	addi	sp,sp,-176
    4164:	f506                	sd	ra,168(sp)
    4166:	f122                	sd	s0,160(sp)
    4168:	ed26                	sd	s1,152(sp)
    416a:	e94a                	sd	s2,144(sp)
    416c:	e54e                	sd	s3,136(sp)
    416e:	e152                	sd	s4,128(sp)
    4170:	fcd6                	sd	s5,120(sp)
    4172:	f8da                	sd	s6,112(sp)
    4174:	f4de                	sd	s7,104(sp)
    4176:	f0e2                	sd	s8,96(sp)
    4178:	ece6                	sd	s9,88(sp)
    417a:	e8ea                	sd	s10,80(sp)
    417c:	1900                	addi	s0,sp,176
    417e:	8d2a                	mv	s10,a0
  file[0] = 'C';
    4180:	04300793          	li	a5,67
    4184:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4188:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    418c:	4901                	li	s2,0
    unlink(file);
    418e:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    4192:	55555b37          	lui	s6,0x55555
    4196:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554485e>
    419a:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    419c:	20200c13          	li	s8,514
      link("C0", file);
    41a0:	00004c97          	auipc	s9,0x4
    41a4:	9c8c8c93          	addi	s9,s9,-1592 # 7b68 <malloc+0x1f06>
      wait(&xstatus);
    41a8:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    41ac:	02800a13          	li	s4,40
    41b0:	ac25                	j	43e8 <concreate+0x286>
      link("C0", file);
    41b2:	85ce                	mv	a1,s3
    41b4:	8566                	mv	a0,s9
    41b6:	5fe010ef          	jal	57b4 <link>
    if (pid == 0) {
    41ba:	ac29                	j	43d4 <concreate+0x272>
    } else if (pid == 0 && (i % 5) == 1) {
    41bc:	666667b7          	lui	a5,0x66666
    41c0:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665596f>
    41c4:	02f907b3          	mul	a5,s2,a5
    41c8:	9785                	srai	a5,a5,0x21
    41ca:	41f9571b          	sraiw	a4,s2,0x1f
    41ce:	9f99                	subw	a5,a5,a4
    41d0:	0027971b          	slliw	a4,a5,0x2
    41d4:	9fb9                	addw	a5,a5,a4
    41d6:	40f9093b          	subw	s2,s2,a5
    41da:	4785                	li	a5,1
    41dc:	02f90563          	beq	s2,a5,4206 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    41e0:	20200593          	li	a1,514
    41e4:	f9840513          	addi	a0,s0,-104
    41e8:	5ac010ef          	jal	5794 <open>
      if (fd < 0) {
    41ec:	1c055f63          	bgez	a0,43ca <concreate+0x268>
        printf("concreate create %s failed\n", file);
    41f0:	f9840593          	addi	a1,s0,-104
    41f4:	00004517          	auipc	a0,0x4
    41f8:	97c50513          	addi	a0,a0,-1668 # 7b70 <malloc+0x1f0e>
    41fc:	1af010ef          	jal	5baa <printf>
        exit(1);
    4200:	4505                	li	a0,1
    4202:	552010ef          	jal	5754 <exit>
      link("C0", file);
    4206:	f9840593          	addi	a1,s0,-104
    420a:	00004517          	auipc	a0,0x4
    420e:	95e50513          	addi	a0,a0,-1698 # 7b68 <malloc+0x1f06>
    4212:	5a2010ef          	jal	57b4 <link>
      exit(0);
    4216:	4501                	li	a0,0
    4218:	53c010ef          	jal	5754 <exit>
        exit(1);
    421c:	4505                	li	a0,1
    421e:	536010ef          	jal	5754 <exit>
  memset(fa, 0, sizeof(fa));
    4222:	02800613          	li	a2,40
    4226:	4581                	li	a1,0
    4228:	f7040513          	addi	a0,s0,-144
    422c:	2fe010ef          	jal	552a <memset>
  fd = open(".", 0);
    4230:	4581                	li	a1,0
    4232:	00002517          	auipc	a0,0x2
    4236:	24e50513          	addi	a0,a0,590 # 6480 <malloc+0x81e>
    423a:	55a010ef          	jal	5794 <open>
    423e:	892a                	mv	s2,a0
  n = 0;
    4240:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    4242:	f6040a13          	addi	s4,s0,-160
    4246:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4248:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    424c:	02700b93          	li	s7,39
      fa[i] = 1;
    4250:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    4252:	864e                	mv	a2,s3
    4254:	85d2                	mv	a1,s4
    4256:	854a                	mv	a0,s2
    4258:	514010ef          	jal	576c <read>
    425c:	06a05763          	blez	a0,42ca <concreate+0x168>
    if (de.inum == 0)
    4260:	f6045783          	lhu	a5,-160(s0)
    4264:	d7fd                	beqz	a5,4252 <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4266:	f6244783          	lbu	a5,-158(s0)
    426a:	ff5794e3          	bne	a5,s5,4252 <concreate+0xf0>
    426e:	f6444783          	lbu	a5,-156(s0)
    4272:	f3e5                	bnez	a5,4252 <concreate+0xf0>
      i = de.name[1] - '0';
    4274:	f6344783          	lbu	a5,-157(s0)
    4278:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    427c:	00fbef63          	bltu	s7,a5,429a <concreate+0x138>
      if (fa[i]) {
    4280:	fa078713          	addi	a4,a5,-96
    4284:	9722                	add	a4,a4,s0
    4286:	fd074703          	lbu	a4,-48(a4)
    428a:	e705                	bnez	a4,42b2 <concreate+0x150>
      fa[i] = 1;
    428c:	fa078793          	addi	a5,a5,-96
    4290:	97a2                	add	a5,a5,s0
    4292:	fd878823          	sb	s8,-48(a5)
      n++;
    4296:	2b05                	addiw	s6,s6,1
    4298:	bf6d                	j	4252 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    429a:	f6240613          	addi	a2,s0,-158
    429e:	85ea                	mv	a1,s10
    42a0:	00004517          	auipc	a0,0x4
    42a4:	8f050513          	addi	a0,a0,-1808 # 7b90 <malloc+0x1f2e>
    42a8:	103010ef          	jal	5baa <printf>
        exit(1);
    42ac:	4505                	li	a0,1
    42ae:	4a6010ef          	jal	5754 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    42b2:	f6240613          	addi	a2,s0,-158
    42b6:	85ea                	mv	a1,s10
    42b8:	00004517          	auipc	a0,0x4
    42bc:	8f850513          	addi	a0,a0,-1800 # 7bb0 <malloc+0x1f4e>
    42c0:	0eb010ef          	jal	5baa <printf>
        exit(1);
    42c4:	4505                	li	a0,1
    42c6:	48e010ef          	jal	5754 <exit>
  close(fd);
    42ca:	854a                	mv	a0,s2
    42cc:	4b0010ef          	jal	577c <close>
  if (n != N) {
    42d0:	02800793          	li	a5,40
    42d4:	00fb1a63          	bne	s6,a5,42e8 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42d8:	55555a37          	lui	s4,0x55555
    42dc:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554485e>
      close(open(file, 0));
    42e0:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    42e4:	8ada                	mv	s5,s6
    42e6:	a049                	j	4368 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    42e8:	85ea                	mv	a1,s10
    42ea:	00004517          	auipc	a0,0x4
    42ee:	8ee50513          	addi	a0,a0,-1810 # 7bd8 <malloc+0x1f76>
    42f2:	0b9010ef          	jal	5baa <printf>
    exit(1);
    42f6:	4505                	li	a0,1
    42f8:	45c010ef          	jal	5754 <exit>
      printf("%s: fork failed\n", s);
    42fc:	85ea                	mv	a1,s10
    42fe:	00002517          	auipc	a0,0x2
    4302:	32a50513          	addi	a0,a0,810 # 6628 <malloc+0x9c6>
    4306:	0a5010ef          	jal	5baa <printf>
      exit(1);
    430a:	4505                	li	a0,1
    430c:	448010ef          	jal	5754 <exit>
      close(open(file, 0));
    4310:	4581                	li	a1,0
    4312:	854e                	mv	a0,s3
    4314:	480010ef          	jal	5794 <open>
    4318:	464010ef          	jal	577c <close>
      close(open(file, 0));
    431c:	4581                	li	a1,0
    431e:	854e                	mv	a0,s3
    4320:	474010ef          	jal	5794 <open>
    4324:	458010ef          	jal	577c <close>
      close(open(file, 0));
    4328:	4581                	li	a1,0
    432a:	854e                	mv	a0,s3
    432c:	468010ef          	jal	5794 <open>
    4330:	44c010ef          	jal	577c <close>
      close(open(file, 0));
    4334:	4581                	li	a1,0
    4336:	854e                	mv	a0,s3
    4338:	45c010ef          	jal	5794 <open>
    433c:	440010ef          	jal	577c <close>
      close(open(file, 0));
    4340:	4581                	li	a1,0
    4342:	854e                	mv	a0,s3
    4344:	450010ef          	jal	5794 <open>
    4348:	434010ef          	jal	577c <close>
      close(open(file, 0));
    434c:	4581                	li	a1,0
    434e:	854e                	mv	a0,s3
    4350:	444010ef          	jal	5794 <open>
    4354:	428010ef          	jal	577c <close>
    if (pid == 0)
    4358:	06090663          	beqz	s2,43c4 <concreate+0x262>
      wait(0);
    435c:	4501                	li	a0,0
    435e:	3fe010ef          	jal	575c <wait>
  for (i = 0; i < N; i++) {
    4362:	2485                	addiw	s1,s1,1
    4364:	0d548163          	beq	s1,s5,4426 <concreate+0x2c4>
    file[1] = '0' + i;
    4368:	0304879b          	addiw	a5,s1,48
    436c:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    4370:	3dc010ef          	jal	574c <fork>
    4374:	892a                	mv	s2,a0
    if (pid < 0) {
    4376:	f80543e3          	bltz	a0,42fc <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    437a:	03448733          	mul	a4,s1,s4
    437e:	9301                	srli	a4,a4,0x20
    4380:	41f4d79b          	sraiw	a5,s1,0x1f
    4384:	9f1d                	subw	a4,a4,a5
    4386:	0017179b          	slliw	a5,a4,0x1
    438a:	9fb9                	addw	a5,a5,a4
    438c:	40f487bb          	subw	a5,s1,a5
    4390:	00a7e733          	or	a4,a5,a0
    4394:	2701                	sext.w	a4,a4
    4396:	df2d                	beqz	a4,4310 <concreate+0x1ae>
    4398:	c119                	beqz	a0,439e <concreate+0x23c>
    439a:	17fd                	addi	a5,a5,-1
    439c:	dbb5                	beqz	a5,4310 <concreate+0x1ae>
      unlink(file);
    439e:	854e                	mv	a0,s3
    43a0:	404010ef          	jal	57a4 <unlink>
      unlink(file);
    43a4:	854e                	mv	a0,s3
    43a6:	3fe010ef          	jal	57a4 <unlink>
      unlink(file);
    43aa:	854e                	mv	a0,s3
    43ac:	3f8010ef          	jal	57a4 <unlink>
      unlink(file);
    43b0:	854e                	mv	a0,s3
    43b2:	3f2010ef          	jal	57a4 <unlink>
      unlink(file);
    43b6:	854e                	mv	a0,s3
    43b8:	3ec010ef          	jal	57a4 <unlink>
      unlink(file);
    43bc:	854e                	mv	a0,s3
    43be:	3e6010ef          	jal	57a4 <unlink>
    43c2:	bf59                	j	4358 <concreate+0x1f6>
      exit(0);
    43c4:	4501                	li	a0,0
    43c6:	38e010ef          	jal	5754 <exit>
      close(fd);
    43ca:	3b2010ef          	jal	577c <close>
    if (pid == 0) {
    43ce:	b5a1                	j	4216 <concreate+0xb4>
      close(fd);
    43d0:	3ac010ef          	jal	577c <close>
      wait(&xstatus);
    43d4:	8556                	mv	a0,s5
    43d6:	386010ef          	jal	575c <wait>
      if (xstatus != 0)
    43da:	f5c42483          	lw	s1,-164(s0)
    43de:	e2049fe3          	bnez	s1,421c <concreate+0xba>
  for (i = 0; i < N; i++) {
    43e2:	2905                	addiw	s2,s2,1
    43e4:	e3490fe3          	beq	s2,s4,4222 <concreate+0xc0>
    file[1] = '0' + i;
    43e8:	0309079b          	addiw	a5,s2,48
    43ec:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    43f0:	854e                	mv	a0,s3
    43f2:	3b2010ef          	jal	57a4 <unlink>
    pid = fork();
    43f6:	356010ef          	jal	574c <fork>
    if (pid && (i % 3) == 1) {
    43fa:	dc0501e3          	beqz	a0,41bc <concreate+0x5a>
    43fe:	036907b3          	mul	a5,s2,s6
    4402:	9381                	srli	a5,a5,0x20
    4404:	41f9571b          	sraiw	a4,s2,0x1f
    4408:	9f99                	subw	a5,a5,a4
    440a:	0017971b          	slliw	a4,a5,0x1
    440e:	9fb9                	addw	a5,a5,a4
    4410:	40f907bb          	subw	a5,s2,a5
    4414:	d9778fe3          	beq	a5,s7,41b2 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4418:	85e2                	mv	a1,s8
    441a:	854e                	mv	a0,s3
    441c:	378010ef          	jal	5794 <open>
      if (fd < 0) {
    4420:	fa0558e3          	bgez	a0,43d0 <concreate+0x26e>
    4424:	b3f1                	j	41f0 <concreate+0x8e>
}
    4426:	70aa                	ld	ra,168(sp)
    4428:	740a                	ld	s0,160(sp)
    442a:	64ea                	ld	s1,152(sp)
    442c:	694a                	ld	s2,144(sp)
    442e:	69aa                	ld	s3,136(sp)
    4430:	6a0a                	ld	s4,128(sp)
    4432:	7ae6                	ld	s5,120(sp)
    4434:	7b46                	ld	s6,112(sp)
    4436:	7ba6                	ld	s7,104(sp)
    4438:	7c06                	ld	s8,96(sp)
    443a:	6ce6                	ld	s9,88(sp)
    443c:	6d46                	ld	s10,80(sp)
    443e:	614d                	addi	sp,sp,176
    4440:	8082                	ret

0000000000004442 <bigfile>:
{
    4442:	7139                	addi	sp,sp,-64
    4444:	fc06                	sd	ra,56(sp)
    4446:	f822                	sd	s0,48(sp)
    4448:	f426                	sd	s1,40(sp)
    444a:	f04a                	sd	s2,32(sp)
    444c:	ec4e                	sd	s3,24(sp)
    444e:	e852                	sd	s4,16(sp)
    4450:	e456                	sd	s5,8(sp)
    4452:	e05a                	sd	s6,0(sp)
    4454:	0080                	addi	s0,sp,64
    4456:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    4458:	00003517          	auipc	a0,0x3
    445c:	7b850513          	addi	a0,a0,1976 # 7c10 <malloc+0x1fae>
    4460:	344010ef          	jal	57a4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4464:	20200593          	li	a1,514
    4468:	00003517          	auipc	a0,0x3
    446c:	7a850513          	addi	a0,a0,1960 # 7c10 <malloc+0x1fae>
    4470:	324010ef          	jal	5794 <open>
  if (fd < 0) {
    4474:	08054a63          	bltz	a0,4508 <bigfile+0xc6>
    4478:	8a2a                	mv	s4,a0
    447a:	4481                	li	s1,0
    memset(buf, i, SZ);
    447c:	25800913          	li	s2,600
    4480:	0000a997          	auipc	s3,0xa
    4484:	87898993          	addi	s3,s3,-1928 # dcf8 <buf>
  for (i = 0; i < N; i++) {
    4488:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    448a:	864a                	mv	a2,s2
    448c:	85a6                	mv	a1,s1
    448e:	854e                	mv	a0,s3
    4490:	09a010ef          	jal	552a <memset>
    if (write(fd, buf, SZ) != SZ) {
    4494:	864a                	mv	a2,s2
    4496:	85ce                	mv	a1,s3
    4498:	8552                	mv	a0,s4
    449a:	2da010ef          	jal	5774 <write>
    449e:	07251f63          	bne	a0,s2,451c <bigfile+0xda>
  for (i = 0; i < N; i++) {
    44a2:	2485                	addiw	s1,s1,1
    44a4:	ff5493e3          	bne	s1,s5,448a <bigfile+0x48>
  close(fd);
    44a8:	8552                	mv	a0,s4
    44aa:	2d2010ef          	jal	577c <close>
  fd = open("bigfile.dat", 0);
    44ae:	4581                	li	a1,0
    44b0:	00003517          	auipc	a0,0x3
    44b4:	76050513          	addi	a0,a0,1888 # 7c10 <malloc+0x1fae>
    44b8:	2dc010ef          	jal	5794 <open>
    44bc:	8aaa                	mv	s5,a0
  total = 0;
    44be:	4a01                	li	s4,0
  for (i = 0;; i++) {
    44c0:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    44c2:	12c00993          	li	s3,300
    44c6:	0000a917          	auipc	s2,0xa
    44ca:	83290913          	addi	s2,s2,-1998 # dcf8 <buf>
  if (fd < 0) {
    44ce:	06054163          	bltz	a0,4530 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    44d2:	864e                	mv	a2,s3
    44d4:	85ca                	mv	a1,s2
    44d6:	8556                	mv	a0,s5
    44d8:	294010ef          	jal	576c <read>
    if (cc < 0) {
    44dc:	06054463          	bltz	a0,4544 <bigfile+0x102>
    if (cc == 0)
    44e0:	c145                	beqz	a0,4580 <bigfile+0x13e>
    if (cc != SZ / 2) {
    44e2:	07351b63          	bne	a0,s3,4558 <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    44e6:	01f4d79b          	srliw	a5,s1,0x1f
    44ea:	9fa5                	addw	a5,a5,s1
    44ec:	4017d79b          	sraiw	a5,a5,0x1
    44f0:	00094703          	lbu	a4,0(s2)
    44f4:	06f71c63          	bne	a4,a5,456c <bigfile+0x12a>
    44f8:	12b94703          	lbu	a4,299(s2)
    44fc:	06f71863          	bne	a4,a5,456c <bigfile+0x12a>
    total += cc;
    4500:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4504:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    4506:	b7f1                	j	44d2 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4508:	85da                	mv	a1,s6
    450a:	00003517          	auipc	a0,0x3
    450e:	71650513          	addi	a0,a0,1814 # 7c20 <malloc+0x1fbe>
    4512:	698010ef          	jal	5baa <printf>
    exit(1);
    4516:	4505                	li	a0,1
    4518:	23c010ef          	jal	5754 <exit>
      printf("%s: write bigfile failed\n", s);
    451c:	85da                	mv	a1,s6
    451e:	00003517          	auipc	a0,0x3
    4522:	72250513          	addi	a0,a0,1826 # 7c40 <malloc+0x1fde>
    4526:	684010ef          	jal	5baa <printf>
      exit(1);
    452a:	4505                	li	a0,1
    452c:	228010ef          	jal	5754 <exit>
    printf("%s: cannot open bigfile\n", s);
    4530:	85da                	mv	a1,s6
    4532:	00003517          	auipc	a0,0x3
    4536:	72e50513          	addi	a0,a0,1838 # 7c60 <malloc+0x1ffe>
    453a:	670010ef          	jal	5baa <printf>
    exit(1);
    453e:	4505                	li	a0,1
    4540:	214010ef          	jal	5754 <exit>
      printf("%s: read bigfile failed\n", s);
    4544:	85da                	mv	a1,s6
    4546:	00003517          	auipc	a0,0x3
    454a:	73a50513          	addi	a0,a0,1850 # 7c80 <malloc+0x201e>
    454e:	65c010ef          	jal	5baa <printf>
      exit(1);
    4552:	4505                	li	a0,1
    4554:	200010ef          	jal	5754 <exit>
      printf("%s: short read bigfile\n", s);
    4558:	85da                	mv	a1,s6
    455a:	00003517          	auipc	a0,0x3
    455e:	74650513          	addi	a0,a0,1862 # 7ca0 <malloc+0x203e>
    4562:	648010ef          	jal	5baa <printf>
      exit(1);
    4566:	4505                	li	a0,1
    4568:	1ec010ef          	jal	5754 <exit>
      printf("%s: read bigfile wrong data\n", s);
    456c:	85da                	mv	a1,s6
    456e:	00003517          	auipc	a0,0x3
    4572:	74a50513          	addi	a0,a0,1866 # 7cb8 <malloc+0x2056>
    4576:	634010ef          	jal	5baa <printf>
      exit(1);
    457a:	4505                	li	a0,1
    457c:	1d8010ef          	jal	5754 <exit>
  close(fd);
    4580:	8556                	mv	a0,s5
    4582:	1fa010ef          	jal	577c <close>
  if (total != N * SZ) {
    4586:	678d                	lui	a5,0x3
    4588:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x356>
    458c:	02fa1263          	bne	s4,a5,45b0 <bigfile+0x16e>
  unlink("bigfile.dat");
    4590:	00003517          	auipc	a0,0x3
    4594:	68050513          	addi	a0,a0,1664 # 7c10 <malloc+0x1fae>
    4598:	20c010ef          	jal	57a4 <unlink>
}
    459c:	70e2                	ld	ra,56(sp)
    459e:	7442                	ld	s0,48(sp)
    45a0:	74a2                	ld	s1,40(sp)
    45a2:	7902                	ld	s2,32(sp)
    45a4:	69e2                	ld	s3,24(sp)
    45a6:	6a42                	ld	s4,16(sp)
    45a8:	6aa2                	ld	s5,8(sp)
    45aa:	6b02                	ld	s6,0(sp)
    45ac:	6121                	addi	sp,sp,64
    45ae:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    45b0:	85da                	mv	a1,s6
    45b2:	00003517          	auipc	a0,0x3
    45b6:	72650513          	addi	a0,a0,1830 # 7cd8 <malloc+0x2076>
    45ba:	5f0010ef          	jal	5baa <printf>
    exit(1);
    45be:	4505                	li	a0,1
    45c0:	194010ef          	jal	5754 <exit>

00000000000045c4 <bigargtest>:
{
    45c4:	7121                	addi	sp,sp,-448
    45c6:	ff06                	sd	ra,440(sp)
    45c8:	fb22                	sd	s0,432(sp)
    45ca:	f726                	sd	s1,424(sp)
    45cc:	0380                	addi	s0,sp,448
    45ce:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    45d0:	00003517          	auipc	a0,0x3
    45d4:	72850513          	addi	a0,a0,1832 # 7cf8 <malloc+0x2096>
    45d8:	1cc010ef          	jal	57a4 <unlink>
  pid = fork();
    45dc:	170010ef          	jal	574c <fork>
  if (pid == 0) {
    45e0:	c915                	beqz	a0,4614 <bigargtest+0x50>
  } else if (pid < 0) {
    45e2:	08054c63          	bltz	a0,467a <bigargtest+0xb6>
  wait(&xstatus);
    45e6:	fdc40513          	addi	a0,s0,-36
    45ea:	172010ef          	jal	575c <wait>
  if (xstatus != 0)
    45ee:	fdc42503          	lw	a0,-36(s0)
    45f2:	ed51                	bnez	a0,468e <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    45f4:	4581                	li	a1,0
    45f6:	00003517          	auipc	a0,0x3
    45fa:	70250513          	addi	a0,a0,1794 # 7cf8 <malloc+0x2096>
    45fe:	196010ef          	jal	5794 <open>
  if (fd < 0) {
    4602:	08054863          	bltz	a0,4692 <bigargtest+0xce>
  close(fd);
    4606:	176010ef          	jal	577c <close>
}
    460a:	70fa                	ld	ra,440(sp)
    460c:	745a                	ld	s0,432(sp)
    460e:	74ba                	ld	s1,424(sp)
    4610:	6139                	addi	sp,sp,448
    4612:	8082                	ret
    memset(big, ' ', sizeof(big));
    4614:	19000613          	li	a2,400
    4618:	02000593          	li	a1,32
    461c:	e4840513          	addi	a0,s0,-440
    4620:	70b000ef          	jal	552a <memset>
    big[sizeof(big) - 1] = '\0';
    4624:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    4628:	00006797          	auipc	a5,0x6
    462c:	eb878793          	addi	a5,a5,-328 # a4e0 <args.1>
    4630:	00006697          	auipc	a3,0x6
    4634:	fa868693          	addi	a3,a3,-88 # a5d8 <args.1+0xf8>
      args[i] = big;
    4638:	e4840713          	addi	a4,s0,-440
    463c:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    463e:	07a1                	addi	a5,a5,8
    4640:	fed79ee3          	bne	a5,a3,463c <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    4644:	00006797          	auipc	a5,0x6
    4648:	f807ba23          	sd	zero,-108(a5) # a5d8 <args.1+0xf8>
    exec("echo", args);
    464c:	00006597          	auipc	a1,0x6
    4650:	e9458593          	addi	a1,a1,-364 # a4e0 <args.1>
    4654:	00001517          	auipc	a0,0x1
    4658:	74450513          	addi	a0,a0,1860 # 5d98 <malloc+0x136>
    465c:	130010ef          	jal	578c <exec>
    fd = open("bigarg-ok", O_CREATE);
    4660:	20000593          	li	a1,512
    4664:	00003517          	auipc	a0,0x3
    4668:	69450513          	addi	a0,a0,1684 # 7cf8 <malloc+0x2096>
    466c:	128010ef          	jal	5794 <open>
    close(fd);
    4670:	10c010ef          	jal	577c <close>
    exit(0);
    4674:	4501                	li	a0,0
    4676:	0de010ef          	jal	5754 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    467a:	85a6                	mv	a1,s1
    467c:	00003517          	auipc	a0,0x3
    4680:	68c50513          	addi	a0,a0,1676 # 7d08 <malloc+0x20a6>
    4684:	526010ef          	jal	5baa <printf>
    exit(1);
    4688:	4505                	li	a0,1
    468a:	0ca010ef          	jal	5754 <exit>
    exit(xstatus);
    468e:	0c6010ef          	jal	5754 <exit>
    printf("%s: bigarg test failed!\n", s);
    4692:	85a6                	mv	a1,s1
    4694:	00003517          	auipc	a0,0x3
    4698:	69450513          	addi	a0,a0,1684 # 7d28 <malloc+0x20c6>
    469c:	50e010ef          	jal	5baa <printf>
    exit(1);
    46a0:	4505                	li	a0,1
    46a2:	0b2010ef          	jal	5754 <exit>

00000000000046a6 <partial_write>:
{
    46a6:	bb010113          	addi	sp,sp,-1104
    46aa:	44113423          	sd	ra,1096(sp)
    46ae:	44813023          	sd	s0,1088(sp)
    46b2:	42913c23          	sd	s1,1080(sp)
    46b6:	43213823          	sd	s2,1072(sp)
    46ba:	43313423          	sd	s3,1064(sp)
    46be:	43413023          	sd	s4,1056(sp)
    46c2:	41513c23          	sd	s5,1048(sp)
    46c6:	45010413          	addi	s0,sp,1104
    46ca:	8aaa                	mv	s5,a0
  unlink("testfile");
    46cc:	00003517          	auipc	a0,0x3
    46d0:	67c50513          	addi	a0,a0,1660 # 7d48 <malloc+0x20e6>
    46d4:	0d0010ef          	jal	57a4 <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    46d8:	20200593          	li	a1,514
    46dc:	00003517          	auipc	a0,0x3
    46e0:	66c50513          	addi	a0,a0,1644 # 7d48 <malloc+0x20e6>
    46e4:	0b0010ef          	jal	5794 <open>
  if (fd < 0) {
    46e8:	14054f63          	bltz	a0,4846 <partial_write+0x1a0>
    46ec:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    46ee:	4605                	li	a2,1
    46f0:	00003597          	auipc	a1,0x3
    46f4:	68858593          	addi	a1,a1,1672 # 7d78 <malloc+0x2116>
    46f8:	07c010ef          	jal	5774 <write>
  if (cc != 1) {
    46fc:	4785                	li	a5,1
    46fe:	14f51e63          	bne	a0,a5,485a <partial_write+0x1b4>
  close(fd);
    4702:	8526                	mv	a0,s1
    4704:	078010ef          	jal	577c <close>
  fd = open("testfile", O_RDWR);
    4708:	4589                	li	a1,2
    470a:	00003517          	auipc	a0,0x3
    470e:	63e50513          	addi	a0,a0,1598 # 7d48 <malloc+0x20e6>
    4712:	082010ef          	jal	5794 <open>
    4716:	892a                	mv	s2,a0
  if (fd < 0) {
    4718:	14054b63          	bltz	a0,486e <partial_write+0x1c8>
  char *p = sbrk(0);
    471c:	4501                	li	a0,0
    471e:	002010ef          	jal	5720 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4722:	6485                	lui	s1,0x1
    4724:	14fd                	addi	s1,s1,-1 # fff <bigdir+0x10b>
    4726:	009577b3          	and	a5,a0,s1
    472a:	6505                	lui	a0,0x1
    472c:	9d1d                	subw	a0,a0,a5
    472e:	7f3000ef          	jal	5720 <sbrk>
  p = sbrk(0);
    4732:	4501                	li	a0,0
    4734:	7ed000ef          	jal	5720 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4738:	8ce9                	and	s1,s1,a0
    473a:	14049463          	bnez	s1,4882 <partial_write+0x1dc>
  p[-1] = 'X';
    473e:	05800793          	li	a5,88
    4742:	fef50fa3          	sb	a5,-1(a0) # fff <bigdir+0x10b>
  cc = write(fd, p - 1, 2);
    4746:	4609                	li	a2,2
    4748:	fff50593          	addi	a1,a0,-1
    474c:	854a                	mv	a0,s2
    474e:	026010ef          	jal	5774 <write>
  if (cc != -1) {
    4752:	57fd                	li	a5,-1
    4754:	14f51163          	bne	a0,a5,4896 <partial_write+0x1f0>
  close(fd);
    4758:	854a                	mv	a0,s2
    475a:	022010ef          	jal	577c <close>
  fd = open("testfile", O_RDONLY);
    475e:	4581                	li	a1,0
    4760:	00003517          	auipc	a0,0x3
    4764:	5e850513          	addi	a0,a0,1512 # 7d48 <malloc+0x20e6>
    4768:	02c010ef          	jal	5794 <open>
    476c:	84aa                	mv	s1,a0
  if (fd < 0) {
    476e:	12054e63          	bltz	a0,48aa <partial_write+0x204>
  cc = read(fd, &b, 1);
    4772:	4605                	li	a2,1
    4774:	fbf40593          	addi	a1,s0,-65
    4778:	7f5000ef          	jal	576c <read>
  if (cc != 1) {
    477c:	4785                	li	a5,1
    477e:	14f51063          	bne	a0,a5,48be <partial_write+0x218>
  close(fd);
    4782:	8526                	mv	a0,s1
    4784:	7f9000ef          	jal	577c <close>
  if (b != 'X') {
    4788:	fbf44603          	lbu	a2,-65(s0)
    478c:	05800793          	li	a5,88
    4790:	14f61163          	bne	a2,a5,48d2 <partial_write+0x22c>
  fd = open("bigfile", O_CREATE | O_RDWR);
    4794:	20200593          	li	a1,514
    4798:	00003517          	auipc	a0,0x3
    479c:	6b050513          	addi	a0,a0,1712 # 7e48 <malloc+0x21e6>
    47a0:	7f5000ef          	jal	5794 <open>
    47a4:	8a2a                	mv	s4,a0
    47a6:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    47aa:	bb840993          	addi	s3,s0,-1096
    47ae:	40000493          	li	s1,1024
    47b2:	8626                	mv	a2,s1
    47b4:	4581                	li	a1,0
    47b6:	854e                	mv	a0,s3
    47b8:	573000ef          	jal	552a <memset>
    cc = write(fd, buf, sizeof(buf));
    47bc:	8626                	mv	a2,s1
    47be:	85ce                	mv	a1,s3
    47c0:	8552                	mv	a0,s4
    47c2:	7b3000ef          	jal	5774 <write>
    if (cc != sizeof(buf)) {
    47c6:	12951063          	bne	a0,s1,48e6 <partial_write+0x240>
  for (int i = 0; i < 64; i++) {
    47ca:	397d                	addiw	s2,s2,-1
    47cc:	fe0913e3          	bnez	s2,47b2 <partial_write+0x10c>
  close(fd);
    47d0:	8552                	mv	a0,s4
    47d2:	7ab000ef          	jal	577c <close>
  unlink("bigfile");
    47d6:	00003517          	auipc	a0,0x3
    47da:	67250513          	addi	a0,a0,1650 # 7e48 <malloc+0x21e6>
    47de:	7c7000ef          	jal	57a4 <unlink>
  fd = open("testfile", O_RDONLY);
    47e2:	4581                	li	a1,0
    47e4:	00003517          	auipc	a0,0x3
    47e8:	56450513          	addi	a0,a0,1380 # 7d48 <malloc+0x20e6>
    47ec:	7a9000ef          	jal	5794 <open>
    47f0:	84aa                	mv	s1,a0
  if (fd < 0) {
    47f2:	10054463          	bltz	a0,48fa <partial_write+0x254>
  cc = read(fd, &b, 1);
    47f6:	4605                	li	a2,1
    47f8:	fbf40593          	addi	a1,s0,-65
    47fc:	771000ef          	jal	576c <read>
  if (cc != 1) {
    4800:	4785                	li	a5,1
    4802:	10f51663          	bne	a0,a5,490e <partial_write+0x268>
  close(fd);
    4806:	8526                	mv	a0,s1
    4808:	775000ef          	jal	577c <close>
  if (b != 'X') {
    480c:	fbf44603          	lbu	a2,-65(s0)
    4810:	05800793          	li	a5,88
    4814:	10f61763          	bne	a2,a5,4922 <partial_write+0x27c>
  unlink("testfile");
    4818:	00003517          	auipc	a0,0x3
    481c:	53050513          	addi	a0,a0,1328 # 7d48 <malloc+0x20e6>
    4820:	785000ef          	jal	57a4 <unlink>
}
    4824:	44813083          	ld	ra,1096(sp)
    4828:	44013403          	ld	s0,1088(sp)
    482c:	43813483          	ld	s1,1080(sp)
    4830:	43013903          	ld	s2,1072(sp)
    4834:	42813983          	ld	s3,1064(sp)
    4838:	42013a03          	ld	s4,1056(sp)
    483c:	41813a83          	ld	s5,1048(sp)
    4840:	45010113          	addi	sp,sp,1104
    4844:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    4846:	85d6                	mv	a1,s5
    4848:	00003517          	auipc	a0,0x3
    484c:	51050513          	addi	a0,a0,1296 # 7d58 <malloc+0x20f6>
    4850:	35a010ef          	jal	5baa <printf>
    exit(1);
    4854:	4505                	li	a0,1
    4856:	6ff000ef          	jal	5754 <exit>
    printf("%s: could not write A\n", s);
    485a:	85d6                	mv	a1,s5
    485c:	00003517          	auipc	a0,0x3
    4860:	52450513          	addi	a0,a0,1316 # 7d80 <malloc+0x211e>
    4864:	346010ef          	jal	5baa <printf>
    exit(1);
    4868:	4505                	li	a0,1
    486a:	6eb000ef          	jal	5754 <exit>
    printf("%s: cannot re-open testfile\n", s);
    486e:	85d6                	mv	a1,s5
    4870:	00003517          	auipc	a0,0x3
    4874:	52850513          	addi	a0,a0,1320 # 7d98 <malloc+0x2136>
    4878:	332010ef          	jal	5baa <printf>
    exit(1);
    487c:	4505                	li	a0,1
    487e:	6d7000ef          	jal	5754 <exit>
    printf("%s: sbrk did not align\n", s);
    4882:	85d6                	mv	a1,s5
    4884:	00003517          	auipc	a0,0x3
    4888:	53450513          	addi	a0,a0,1332 # 7db8 <malloc+0x2156>
    488c:	31e010ef          	jal	5baa <printf>
    exit(1);
    4890:	4505                	li	a0,1
    4892:	6c3000ef          	jal	5754 <exit>
    printf("%s: write succeeded, should have failed\n", s);
    4896:	85d6                	mv	a1,s5
    4898:	00003517          	auipc	a0,0x3
    489c:	53850513          	addi	a0,a0,1336 # 7dd0 <malloc+0x216e>
    48a0:	30a010ef          	jal	5baa <printf>
    exit(1);
    48a4:	4505                	li	a0,1
    48a6:	6af000ef          	jal	5754 <exit>
    printf("%s: cannot re-open testfile\n", s);
    48aa:	85d6                	mv	a1,s5
    48ac:	00003517          	auipc	a0,0x3
    48b0:	4ec50513          	addi	a0,a0,1260 # 7d98 <malloc+0x2136>
    48b4:	2f6010ef          	jal	5baa <printf>
    exit(1);
    48b8:	4505                	li	a0,1
    48ba:	69b000ef          	jal	5754 <exit>
    printf("%s: cannot read testfile\n", s);
    48be:	85d6                	mv	a1,s5
    48c0:	00003517          	auipc	a0,0x3
    48c4:	54050513          	addi	a0,a0,1344 # 7e00 <malloc+0x219e>
    48c8:	2e2010ef          	jal	5baa <printf>
    exit(1);
    48cc:	4505                	li	a0,1
    48ce:	687000ef          	jal	5754 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    48d2:	85d6                	mv	a1,s5
    48d4:	00003517          	auipc	a0,0x3
    48d8:	54c50513          	addi	a0,a0,1356 # 7e20 <malloc+0x21be>
    48dc:	2ce010ef          	jal	5baa <printf>
    exit(1);
    48e0:	4505                	li	a0,1
    48e2:	673000ef          	jal	5754 <exit>
      printf("%s: could not write to bigfile\n", s);
    48e6:	85d6                	mv	a1,s5
    48e8:	00003517          	auipc	a0,0x3
    48ec:	56850513          	addi	a0,a0,1384 # 7e50 <malloc+0x21ee>
    48f0:	2ba010ef          	jal	5baa <printf>
      exit(-1);
    48f4:	557d                	li	a0,-1
    48f6:	65f000ef          	jal	5754 <exit>
    printf("%s: cannot re-open testfile\n", s);
    48fa:	85d6                	mv	a1,s5
    48fc:	00003517          	auipc	a0,0x3
    4900:	49c50513          	addi	a0,a0,1180 # 7d98 <malloc+0x2136>
    4904:	2a6010ef          	jal	5baa <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	64b000ef          	jal	5754 <exit>
    printf("%s: cannot read testfile\n", s);
    490e:	85d6                	mv	a1,s5
    4910:	00003517          	auipc	a0,0x3
    4914:	4f050513          	addi	a0,a0,1264 # 7e00 <malloc+0x219e>
    4918:	292010ef          	jal	5baa <printf>
    exit(1);
    491c:	4505                	li	a0,1
    491e:	637000ef          	jal	5754 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4922:	85d6                	mv	a1,s5
    4924:	00003517          	auipc	a0,0x3
    4928:	4fc50513          	addi	a0,a0,1276 # 7e20 <malloc+0x21be>
    492c:	27e010ef          	jal	5baa <printf>
    exit(1);
    4930:	4505                	li	a0,1
    4932:	623000ef          	jal	5754 <exit>

0000000000004936 <lazy_alloc>:
{
    4936:	1141                	addi	sp,sp,-16
    4938:	e406                	sd	ra,8(sp)
    493a:	e022                	sd	s0,0(sp)
    493c:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    493e:	40000537          	lui	a0,0x40000
    4942:	5f5000ef          	jal	5736 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4946:	57fd                	li	a5,-1
    4948:	02f50a63          	beq	a0,a5,497c <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    494c:	6605                	lui	a2,0x1
    494e:	962a                	add	a2,a2,a0
    4950:	400017b7          	lui	a5,0x40001
    4954:	00f50733          	add	a4,a0,a5
    4958:	87b2                	mv	a5,a2
    495a:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    495e:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4960:	97b6                	add	a5,a5,a3
    4962:	fee79ee3          	bne	a5,a4,495e <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4966:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    496a:	621c                	ld	a5,0(a2)
    496c:	02c79163          	bne	a5,a2,498e <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4970:	9636                	add	a2,a2,a3
    4972:	fee61ce3          	bne	a2,a4,496a <lazy_alloc+0x34>
  exit(0);
    4976:	4501                	li	a0,0
    4978:	5dd000ef          	jal	5754 <exit>
    printf("sbrklazy() failed\n");
    497c:	00003517          	auipc	a0,0x3
    4980:	4f450513          	addi	a0,a0,1268 # 7e70 <malloc+0x220e>
    4984:	226010ef          	jal	5baa <printf>
    exit(1);
    4988:	4505                	li	a0,1
    498a:	5cb000ef          	jal	5754 <exit>
      printf("failed to read value from memory\n");
    498e:	00003517          	auipc	a0,0x3
    4992:	4fa50513          	addi	a0,a0,1274 # 7e88 <malloc+0x2226>
    4996:	214010ef          	jal	5baa <printf>
      exit(1);
    499a:	4505                	li	a0,1
    499c:	5b9000ef          	jal	5754 <exit>

00000000000049a0 <lazy_unmap>:
{
    49a0:	7139                	addi	sp,sp,-64
    49a2:	fc06                	sd	ra,56(sp)
    49a4:	f822                	sd	s0,48(sp)
    49a6:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    49a8:	40000537          	lui	a0,0x40000
    49ac:	58b000ef          	jal	5736 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    49b0:	57fd                	li	a5,-1
    49b2:	04f50863          	beq	a0,a5,4a02 <lazy_unmap+0x62>
    49b6:	f426                	sd	s1,40(sp)
    49b8:	f04a                	sd	s2,32(sp)
    49ba:	ec4e                	sd	s3,24(sp)
    49bc:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49be:	6905                	lui	s2,0x1
    49c0:	992a                	add	s2,s2,a0
    49c2:	400017b7          	lui	a5,0x40001
    49c6:	00f504b3          	add	s1,a0,a5
    49ca:	87ca                	mv	a5,s2
    49cc:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    49d0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49d2:	97ba                	add	a5,a5,a4
    49d4:	fe979ee3          	bne	a5,s1,49d0 <lazy_unmap+0x30>
      wait(&status);
    49d8:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49dc:	01000a37          	lui	s4,0x1000
    pid = fork();
    49e0:	56d000ef          	jal	574c <fork>
    if (pid < 0) {
    49e4:	02054c63          	bltz	a0,4a1c <lazy_unmap+0x7c>
    } else if (pid == 0) {
    49e8:	c139                	beqz	a0,4a2e <lazy_unmap+0x8e>
      wait(&status);
    49ea:	854e                	mv	a0,s3
    49ec:	571000ef          	jal	575c <wait>
      if (status == 0) {
    49f0:	fcc42783          	lw	a5,-52(s0)
    49f4:	c7b1                	beqz	a5,4a40 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49f6:	9952                	add	s2,s2,s4
    49f8:	fe9914e3          	bne	s2,s1,49e0 <lazy_unmap+0x40>
  exit(0);
    49fc:	4501                	li	a0,0
    49fe:	557000ef          	jal	5754 <exit>
    4a02:	f426                	sd	s1,40(sp)
    4a04:	f04a                	sd	s2,32(sp)
    4a06:	ec4e                	sd	s3,24(sp)
    4a08:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    4a0a:	00003517          	auipc	a0,0x3
    4a0e:	46650513          	addi	a0,a0,1126 # 7e70 <malloc+0x220e>
    4a12:	198010ef          	jal	5baa <printf>
    exit(1);
    4a16:	4505                	li	a0,1
    4a18:	53d000ef          	jal	5754 <exit>
      printf("error forking\n");
    4a1c:	00003517          	auipc	a0,0x3
    4a20:	49450513          	addi	a0,a0,1172 # 7eb0 <malloc+0x224e>
    4a24:	186010ef          	jal	5baa <printf>
      exit(1);
    4a28:	4505                	li	a0,1
    4a2a:	52b000ef          	jal	5754 <exit>
      sbrklazy(-1L * REGION_SZ);
    4a2e:	c0000537          	lui	a0,0xc0000
    4a32:	505000ef          	jal	5736 <sbrklazy>
      *(char **)i = i;
    4a36:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    4a3a:	4501                	li	a0,0
    4a3c:	519000ef          	jal	5754 <exit>
        printf("memory not unmapped\n");
    4a40:	00003517          	auipc	a0,0x3
    4a44:	48050513          	addi	a0,a0,1152 # 7ec0 <malloc+0x225e>
    4a48:	162010ef          	jal	5baa <printf>
        exit(1);
    4a4c:	4505                	li	a0,1
    4a4e:	507000ef          	jal	5754 <exit>

0000000000004a52 <lazy_copy>:
{
    4a52:	7119                	addi	sp,sp,-128
    4a54:	fc86                	sd	ra,120(sp)
    4a56:	f8a2                	sd	s0,112(sp)
    4a58:	f4a6                	sd	s1,104(sp)
    4a5a:	f0ca                	sd	s2,96(sp)
    4a5c:	ecce                	sd	s3,88(sp)
    4a5e:	e8d2                	sd	s4,80(sp)
    4a60:	e4d6                	sd	s5,72(sp)
    4a62:	e0da                	sd	s6,64(sp)
    4a64:	fc5e                	sd	s7,56(sp)
    4a66:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4a68:	4501                	li	a0,0
    4a6a:	4b7000ef          	jal	5720 <sbrk>
    4a6e:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4a70:	6511                	lui	a0,0x4
    4a72:	4c5000ef          	jal	5736 <sbrklazy>
    open(p + 8192, 0);
    4a76:	4581                	li	a1,0
    4a78:	6509                	lui	a0,0x2
    4a7a:	9526                	add	a0,a0,s1
    4a7c:	519000ef          	jal	5794 <open>
    void *xx = sbrk(0);
    4a80:	4501                	li	a0,0
    4a82:	49f000ef          	jal	5720 <sbrk>
    4a86:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4a88:	fff54513          	not	a0,a0
    4a8c:	2501                	sext.w	a0,a0
    4a8e:	493000ef          	jal	5720 <sbrk>
    if (ret != xx) {
    4a92:	00a48c63          	beq	s1,a0,4aaa <lazy_copy+0x58>
    4a96:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4a98:	00003517          	auipc	a0,0x3
    4a9c:	44050513          	addi	a0,a0,1088 # 7ed8 <malloc+0x2276>
    4aa0:	10a010ef          	jal	5baa <printf>
      exit(1);
    4aa4:	4505                	li	a0,1
    4aa6:	4af000ef          	jal	5754 <exit>
  unsigned long bad[] = {
    4aaa:	00004797          	auipc	a5,0x4
    4aae:	be678793          	addi	a5,a5,-1050 # 8690 <malloc+0x2a2e>
    4ab2:	7fa8                	ld	a0,120(a5)
    4ab4:	63cc                	ld	a1,128(a5)
    4ab6:	67d0                	ld	a2,136(a5)
    4ab8:	6bd4                	ld	a3,144(a5)
    4aba:	6fd8                	ld	a4,152(a5)
    4abc:	f8a43023          	sd	a0,-128(s0)
    4ac0:	f8b43423          	sd	a1,-120(s0)
    4ac4:	f8c43823          	sd	a2,-112(s0)
    4ac8:	f8d43c23          	sd	a3,-104(s0)
    4acc:	fae43023          	sd	a4,-96(s0)
    4ad0:	73dc                	ld	a5,160(a5)
    4ad2:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4ad6:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4ada:	00001a97          	auipc	s5,0x1
    4ade:	496a8a93          	addi	s5,s5,1174 # 5f70 <malloc+0x30e>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4ae2:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4ae6:	60200b93          	li	s7,1538
    4aea:	00001b17          	auipc	s6,0x1
    4aee:	396b0b13          	addi	s6,s6,918 # 5e80 <malloc+0x21e>
    int fd = open("README", 0);
    4af2:	4581                	li	a1,0
    4af4:	8556                	mv	a0,s5
    4af6:	49f000ef          	jal	5794 <open>
    4afa:	84aa                	mv	s1,a0
    if (fd < 0) {
    4afc:	04054563          	bltz	a0,4b46 <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4b00:	00093983          	ld	s3,0(s2)
    4b04:	8652                	mv	a2,s4
    4b06:	85ce                	mv	a1,s3
    4b08:	465000ef          	jal	576c <read>
    4b0c:	04055663          	bgez	a0,4b58 <lazy_copy+0x106>
    close(fd);
    4b10:	8526                	mv	a0,s1
    4b12:	46b000ef          	jal	577c <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4b16:	85de                	mv	a1,s7
    4b18:	855a                	mv	a0,s6
    4b1a:	47b000ef          	jal	5794 <open>
    4b1e:	84aa                	mv	s1,a0
    if (fd < 0) {
    4b20:	04054563          	bltz	a0,4b6a <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4b24:	8652                	mv	a2,s4
    4b26:	85ce                	mv	a1,s3
    4b28:	44d000ef          	jal	5774 <write>
    4b2c:	04055863          	bgez	a0,4b7c <lazy_copy+0x12a>
    close(fd);
    4b30:	8526                	mv	a0,s1
    4b32:	44b000ef          	jal	577c <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4b36:	0921                	addi	s2,s2,8
    4b38:	fb040793          	addi	a5,s0,-80
    4b3c:	faf91be3          	bne	s2,a5,4af2 <lazy_copy+0xa0>
  exit(0);
    4b40:	4501                	li	a0,0
    4b42:	413000ef          	jal	5754 <exit>
      printf("cannot open README\n");
    4b46:	00003517          	auipc	a0,0x3
    4b4a:	3c250513          	addi	a0,a0,962 # 7f08 <malloc+0x22a6>
    4b4e:	05c010ef          	jal	5baa <printf>
      exit(1);
    4b52:	4505                	li	a0,1
    4b54:	401000ef          	jal	5754 <exit>
      printf("read succeeded\n");
    4b58:	00003517          	auipc	a0,0x3
    4b5c:	3c850513          	addi	a0,a0,968 # 7f20 <malloc+0x22be>
    4b60:	04a010ef          	jal	5baa <printf>
      exit(1);
    4b64:	4505                	li	a0,1
    4b66:	3ef000ef          	jal	5754 <exit>
      printf("cannot open junk\n");
    4b6a:	00003517          	auipc	a0,0x3
    4b6e:	3c650513          	addi	a0,a0,966 # 7f30 <malloc+0x22ce>
    4b72:	038010ef          	jal	5baa <printf>
      exit(1);
    4b76:	4505                	li	a0,1
    4b78:	3dd000ef          	jal	5754 <exit>
      printf("write succeeded\n");
    4b7c:	00003517          	auipc	a0,0x3
    4b80:	3cc50513          	addi	a0,a0,972 # 7f48 <malloc+0x22e6>
    4b84:	026010ef          	jal	5baa <printf>
      exit(1);
    4b88:	4505                	li	a0,1
    4b8a:	3cb000ef          	jal	5754 <exit>

0000000000004b8e <lazy_sbrk>:
{
    4b8e:	7179                	addi	sp,sp,-48
    4b90:	f406                	sd	ra,40(sp)
    4b92:	f022                	sd	s0,32(sp)
    4b94:	ec26                	sd	s1,24(sp)
    4b96:	e84a                	sd	s2,16(sp)
    4b98:	e44e                	sd	s3,8(sp)
    4b9a:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4b9c:	4501                	li	a0,0
    4b9e:	383000ef          	jal	5720 <sbrk>
    4ba2:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4ba4:	0ff00793          	li	a5,255
    4ba8:	07fa                	slli	a5,a5,0x1e
    4baa:	00f57e63          	bgeu	a0,a5,4bc6 <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4bae:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bb2:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4bb4:	854e                	mv	a0,s3
    4bb6:	381000ef          	jal	5736 <sbrklazy>
    p = sbrklazy(0);
    4bba:	4501                	li	a0,0
    4bbc:	37b000ef          	jal	5736 <sbrklazy>
    4bc0:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bc2:	ff2569e3          	bltu	a0,s2,4bb4 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4bc6:	7975                	lui	s2,0xffffd
    4bc8:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4bcc:	854a                	mv	a0,s2
    4bce:	369000ef          	jal	5736 <sbrklazy>
    4bd2:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4bd4:	00950d63          	beq	a0,s1,4bee <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4bd8:	86a6                	mv	a3,s1
    4bda:	85ca                	mv	a1,s2
    4bdc:	00003517          	auipc	a0,0x3
    4be0:	38450513          	addi	a0,a0,900 # 7f60 <malloc+0x22fe>
    4be4:	7c7000ef          	jal	5baa <printf>
    exit(1);
    4be8:	4505                	li	a0,1
    4bea:	36b000ef          	jal	5754 <exit>
  p = sbrk(PGSIZE);
    4bee:	6505                	lui	a0,0x1
    4bf0:	331000ef          	jal	5720 <sbrk>
    4bf4:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4bf6:	040007b7          	lui	a5,0x4000
    4bfa:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef305>
    4bfc:	07b2                	slli	a5,a5,0xc
    4bfe:	00f50c63          	beq	a0,a5,4c16 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4c02:	6585                	lui	a1,0x1
    4c04:	00003517          	auipc	a0,0x3
    4c08:	38c50513          	addi	a0,a0,908 # 7f90 <malloc+0x232e>
    4c0c:	79f000ef          	jal	5baa <printf>
    exit(1);
    4c10:	4505                	li	a0,1
    4c12:	343000ef          	jal	5754 <exit>
  p[0] = 1;
    4c16:	040007b7          	lui	a5,0x4000
    4c1a:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef305>
    4c1c:	07b2                	slli	a5,a5,0xc
    4c1e:	4705                	li	a4,1
    4c20:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4c24:	0017c783          	lbu	a5,1(a5)
    4c28:	cb91                	beqz	a5,4c3c <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    4c2a:	00003517          	auipc	a0,0x3
    4c2e:	39e50513          	addi	a0,a0,926 # 7fc8 <malloc+0x2366>
    4c32:	779000ef          	jal	5baa <printf>
    exit(1);
    4c36:	4505                	li	a0,1
    4c38:	31d000ef          	jal	5754 <exit>
  p = sbrk(1);
    4c3c:	4505                	li	a0,1
    4c3e:	2e3000ef          	jal	5720 <sbrk>
    4c42:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c44:	57fd                	li	a5,-1
    4c46:	00f50b63          	beq	a0,a5,4c5c <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	3a650513          	addi	a0,a0,934 # 7ff0 <malloc+0x238e>
    4c52:	759000ef          	jal	5baa <printf>
    exit(1);
    4c56:	4505                	li	a0,1
    4c58:	2fd000ef          	jal	5754 <exit>
  p = sbrklazy(1);
    4c5c:	4505                	li	a0,1
    4c5e:	2d9000ef          	jal	5736 <sbrklazy>
    4c62:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c64:	57fd                	li	a5,-1
    4c66:	00f50b63          	beq	a0,a5,4c7c <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4c6a:	00003517          	auipc	a0,0x3
    4c6e:	3ae50513          	addi	a0,a0,942 # 8018 <malloc+0x23b6>
    4c72:	739000ef          	jal	5baa <printf>
    exit(1);
    4c76:	4505                	li	a0,1
    4c78:	2dd000ef          	jal	5754 <exit>
  exit(0);
    4c7c:	4501                	li	a0,0
    4c7e:	2d7000ef          	jal	5754 <exit>

0000000000004c82 <lazy_copyinstr>:
{
    4c82:	715d                	addi	sp,sp,-80
    4c84:	e486                	sd	ra,72(sp)
    4c86:	e0a2                	sd	s0,64(sp)
    4c88:	fc26                	sd	s1,56(sp)
    4c8a:	f84a                	sd	s2,48(sp)
    4c8c:	f44e                	sd	s3,40(sp)
    4c8e:	0880                	addi	s0,sp,80
    4c90:	89aa                	mv	s3,a0
  char *p = sbrk(0);
    4c92:	4501                	li	a0,0
    4c94:	28d000ef          	jal	5720 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4c98:	6485                	lui	s1,0x1
    4c9a:	14fd                	addi	s1,s1,-1 # fff <bigdir+0x10b>
    4c9c:	009577b3          	and	a5,a0,s1
    4ca0:	6505                	lui	a0,0x1
    4ca2:	9d1d                	subw	a0,a0,a5
    4ca4:	27d000ef          	jal	5720 <sbrk>
  p = sbrk(0);
    4ca8:	4501                	li	a0,0
    4caa:	277000ef          	jal	5720 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4cae:	8ce9                	and	s1,s1,a0
    4cb0:	e8a9                	bnez	s1,4d02 <lazy_copyinstr+0x80>
    4cb2:	892a                	mv	s2,a0
  sbrklazy(2 * PGSIZE);
    4cb4:	6509                	lui	a0,0x2
    4cb6:	281000ef          	jal	5736 <sbrklazy>
  p[4095] = '/';
    4cba:	6505                	lui	a0,0x1
    4cbc:	00a907b3          	add	a5,s2,a0
    4cc0:	02f00713          	li	a4,47
    4cc4:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4cc8:	157d                	addi	a0,a0,-1 # fff <bigdir+0x10b>
    4cca:	4581                	li	a1,0
    4ccc:	954a                	add	a0,a0,s2
    4cce:	2c7000ef          	jal	5794 <open>
    4cd2:	84aa                	mv	s1,a0
  if (fd < 0) {
    4cd4:	04054163          	bltz	a0,4d16 <lazy_copyinstr+0x94>
  int r = fstat(fd, &st);
    4cd8:	fb840593          	addi	a1,s0,-72
    4cdc:	2d1000ef          	jal	57ac <fstat>
  if (r < 0) {
    4ce0:	04054463          	bltz	a0,4d28 <lazy_copyinstr+0xa6>
  if (st.type != T_DIR) {
    4ce4:	fc041703          	lh	a4,-64(s0)
    4ce8:	4785                	li	a5,1
    4cea:	04f71863          	bne	a4,a5,4d3a <lazy_copyinstr+0xb8>
  close(fd);
    4cee:	8526                	mv	a0,s1
    4cf0:	28d000ef          	jal	577c <close>
}
    4cf4:	60a6                	ld	ra,72(sp)
    4cf6:	6406                	ld	s0,64(sp)
    4cf8:	74e2                	ld	s1,56(sp)
    4cfa:	7942                	ld	s2,48(sp)
    4cfc:	79a2                	ld	s3,40(sp)
    4cfe:	6161                	addi	sp,sp,80
    4d00:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4d02:	85ce                	mv	a1,s3
    4d04:	00003517          	auipc	a0,0x3
    4d08:	0b450513          	addi	a0,a0,180 # 7db8 <malloc+0x2156>
    4d0c:	69f000ef          	jal	5baa <printf>
    exit(1);
    4d10:	4505                	li	a0,1
    4d12:	243000ef          	jal	5754 <exit>
    printf("could not open /");
    4d16:	00003517          	auipc	a0,0x3
    4d1a:	33250513          	addi	a0,a0,818 # 8048 <malloc+0x23e6>
    4d1e:	68d000ef          	jal	5baa <printf>
    exit(1);
    4d22:	4505                	li	a0,1
    4d24:	231000ef          	jal	5754 <exit>
    printf("could not stat /");
    4d28:	00003517          	auipc	a0,0x3
    4d2c:	33850513          	addi	a0,a0,824 # 8060 <malloc+0x23fe>
    4d30:	67b000ef          	jal	5baa <printf>
    exit(1);
    4d34:	4505                	li	a0,1
    4d36:	21f000ef          	jal	5754 <exit>
    printf("/ is not T_DIR");
    4d3a:	00003517          	auipc	a0,0x3
    4d3e:	33e50513          	addi	a0,a0,830 # 8078 <malloc+0x2416>
    4d42:	669000ef          	jal	5baa <printf>
    exit(1);
    4d46:	4505                	li	a0,1
    4d48:	20d000ef          	jal	5754 <exit>

0000000000004d4c <fsfull>:
{
    4d4c:	7131                	addi	sp,sp,-192
    4d4e:	fd06                	sd	ra,184(sp)
    4d50:	f922                	sd	s0,176(sp)
    4d52:	f526                	sd	s1,168(sp)
    4d54:	f14a                	sd	s2,160(sp)
    4d56:	ed4e                	sd	s3,152(sp)
    4d58:	e952                	sd	s4,144(sp)
    4d5a:	e556                	sd	s5,136(sp)
    4d5c:	e15a                	sd	s6,128(sp)
    4d5e:	fcde                	sd	s7,120(sp)
    4d60:	f8e2                	sd	s8,112(sp)
    4d62:	f4e6                	sd	s9,104(sp)
    4d64:	f0ea                	sd	s10,96(sp)
    4d66:	ecee                	sd	s11,88(sp)
    4d68:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4d6a:	00003517          	auipc	a0,0x3
    4d6e:	31e50513          	addi	a0,a0,798 # 8088 <malloc+0x2426>
    4d72:	639000ef          	jal	5baa <printf>
  int fsblocks = 0;
    4d76:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4d78:	4481                	li	s1,0
    name[0] = 'f';
    4d7a:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4d7e:	106257b7          	lui	a5,0x10625
    4d82:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106140db>
    4d86:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d8a:	51eb8b37          	lui	s6,0x51eb8
    4d8e:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea7827>
    name[3] = '0' + (nfiles % 100) / 10;
    4d92:	66666ab7          	lui	s5,0x66666
    4d96:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665596f>
    printf("writing %s\n", name);
    4d9a:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4d9e:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4da2:	f4843783          	ld	a5,-184(s0)
    4da6:	02f487b3          	mul	a5,s1,a5
    4daa:	9799                	srai	a5,a5,0x26
    4dac:	41f4d69b          	sraiw	a3,s1,0x1f
    4db0:	9f95                	subw	a5,a5,a3
    4db2:	0307871b          	addiw	a4,a5,48
    4db6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4dba:	3e800713          	li	a4,1000
    4dbe:	02f707bb          	mulw	a5,a4,a5
    4dc2:	40f487bb          	subw	a5,s1,a5
    4dc6:	03678733          	mul	a4,a5,s6
    4dca:	9715                	srai	a4,a4,0x25
    4dcc:	41f7d79b          	sraiw	a5,a5,0x1f
    4dd0:	40f707bb          	subw	a5,a4,a5
    4dd4:	0307879b          	addiw	a5,a5,48
    4dd8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ddc:	036487b3          	mul	a5,s1,s6
    4de0:	9795                	srai	a5,a5,0x25
    4de2:	9f95                	subw	a5,a5,a3
    4de4:	06400713          	li	a4,100
    4de8:	02f707bb          	mulw	a5,a4,a5
    4dec:	40f487bb          	subw	a5,s1,a5
    4df0:	03578733          	mul	a4,a5,s5
    4df4:	9709                	srai	a4,a4,0x22
    4df6:	41f7d79b          	sraiw	a5,a5,0x1f
    4dfa:	40f707bb          	subw	a5,a4,a5
    4dfe:	0307879b          	addiw	a5,a5,48
    4e02:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e06:	03548733          	mul	a4,s1,s5
    4e0a:	9709                	srai	a4,a4,0x22
    4e0c:	9f15                	subw	a4,a4,a3
    4e0e:	0027179b          	slliw	a5,a4,0x2
    4e12:	9fb9                	addw	a5,a5,a4
    4e14:	0017979b          	slliw	a5,a5,0x1
    4e18:	40f487bb          	subw	a5,s1,a5
    4e1c:	0307879b          	addiw	a5,a5,48
    4e20:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e24:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e28:	85ea                	mv	a1,s10
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	26e50513          	addi	a0,a0,622 # 8098 <malloc+0x2436>
    4e32:	579000ef          	jal	5baa <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4e36:	20200593          	li	a1,514
    4e3a:	856a                	mv	a0,s10
    4e3c:	159000ef          	jal	5794 <open>
    4e40:	892a                	mv	s2,a0
    if (fd < 0) {
    4e42:	0e055c63          	bgez	a0,4f3a <fsfull+0x1ee>
      printf("open %s failed\n", name);
    4e46:	f5040593          	addi	a1,s0,-176
    4e4a:	00003517          	auipc	a0,0x3
    4e4e:	25e50513          	addi	a0,a0,606 # 80a8 <malloc+0x2446>
    4e52:	559000ef          	jal	5baa <printf>
  while (nfiles >= 0) {
    4e56:	0a04cc63          	bltz	s1,4f0e <fsfull+0x1c2>
    name[0] = 'f';
    4e5a:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    4e5e:	10625ab7          	lui	s5,0x10625
    4e62:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106140db>
    name[2] = '0' + (nfiles % 1000) / 100;
    4e66:	3e800c13          	li	s8,1000
    4e6a:	51eb8a37          	lui	s4,0x51eb8
    4e6e:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea7827>
    name[3] = '0' + (nfiles % 100) / 10;
    4e72:	06400b93          	li	s7,100
    4e76:	66666937          	lui	s2,0x66666
    4e7a:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665596f>
    unlink(name);
    4e7e:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    4e82:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e86:	035487b3          	mul	a5,s1,s5
    4e8a:	9799                	srai	a5,a5,0x26
    4e8c:	41f4d69b          	sraiw	a3,s1,0x1f
    4e90:	9f95                	subw	a5,a5,a3
    4e92:	0307871b          	addiw	a4,a5,48
    4e96:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e9a:	02fc07bb          	mulw	a5,s8,a5
    4e9e:	40f487bb          	subw	a5,s1,a5
    4ea2:	03478733          	mul	a4,a5,s4
    4ea6:	9715                	srai	a4,a4,0x25
    4ea8:	41f7d79b          	sraiw	a5,a5,0x1f
    4eac:	40f707bb          	subw	a5,a4,a5
    4eb0:	0307879b          	addiw	a5,a5,48
    4eb4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4eb8:	034487b3          	mul	a5,s1,s4
    4ebc:	9795                	srai	a5,a5,0x25
    4ebe:	9f95                	subw	a5,a5,a3
    4ec0:	02fb87bb          	mulw	a5,s7,a5
    4ec4:	40f487bb          	subw	a5,s1,a5
    4ec8:	03278733          	mul	a4,a5,s2
    4ecc:	9709                	srai	a4,a4,0x22
    4ece:	41f7d79b          	sraiw	a5,a5,0x1f
    4ed2:	40f707bb          	subw	a5,a4,a5
    4ed6:	0307879b          	addiw	a5,a5,48
    4eda:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ede:	03248733          	mul	a4,s1,s2
    4ee2:	9709                	srai	a4,a4,0x22
    4ee4:	9f15                	subw	a4,a4,a3
    4ee6:	0027179b          	slliw	a5,a4,0x2
    4eea:	9fb9                	addw	a5,a5,a4
    4eec:	0017979b          	slliw	a5,a5,0x1
    4ef0:	40f487bb          	subw	a5,s1,a5
    4ef4:	0307879b          	addiw	a5,a5,48
    4ef8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4efc:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f00:	855a                	mv	a0,s6
    4f02:	0a3000ef          	jal	57a4 <unlink>
    nfiles--;
    4f06:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4f08:	57fd                	li	a5,-1
    4f0a:	f6f49ce3          	bne	s1,a5,4e82 <fsfull+0x136>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    4f0e:	85ce                	mv	a1,s3
    4f10:	00003517          	auipc	a0,0x3
    4f14:	1b850513          	addi	a0,a0,440 # 80c8 <malloc+0x2466>
    4f18:	493000ef          	jal	5baa <printf>
}
    4f1c:	70ea                	ld	ra,184(sp)
    4f1e:	744a                	ld	s0,176(sp)
    4f20:	74aa                	ld	s1,168(sp)
    4f22:	790a                	ld	s2,160(sp)
    4f24:	69ea                	ld	s3,152(sp)
    4f26:	6a4a                	ld	s4,144(sp)
    4f28:	6aaa                	ld	s5,136(sp)
    4f2a:	6b0a                	ld	s6,128(sp)
    4f2c:	7be6                	ld	s7,120(sp)
    4f2e:	7c46                	ld	s8,112(sp)
    4f30:	7ca6                	ld	s9,104(sp)
    4f32:	7d06                	ld	s10,96(sp)
    4f34:	6de6                	ld	s11,88(sp)
    4f36:	6129                	addi	sp,sp,192
    4f38:	8082                	ret
    int total = 0;
    4f3a:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    4f3c:	40000c93          	li	s9,1024
    4f40:	00009c17          	auipc	s8,0x9
    4f44:	db8c0c13          	addi	s8,s8,-584 # dcf8 <buf>
      if (cc < BSIZE)
    4f48:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    4f4c:	8666                	mv	a2,s9
    4f4e:	85e2                	mv	a1,s8
    4f50:	854a                	mv	a0,s2
    4f52:	023000ef          	jal	5774 <write>
      if (cc < BSIZE)
    4f56:	00abd663          	bge	s7,a0,4f62 <fsfull+0x216>
      total += cc;
    4f5a:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    4f5e:	2985                	addiw	s3,s3,1 # 40000001 <base+0x3ffef309>
    while (1) {
    4f60:	b7f5                	j	4f4c <fsfull+0x200>
    printf("wrote %d bytes\n", total);
    4f62:	85d2                	mv	a1,s4
    4f64:	00003517          	auipc	a0,0x3
    4f68:	15450513          	addi	a0,a0,340 # 80b8 <malloc+0x2456>
    4f6c:	43f000ef          	jal	5baa <printf>
    close(fd);
    4f70:	854a                	mv	a0,s2
    4f72:	00b000ef          	jal	577c <close>
    if (total == 0)
    4f76:	ee0a00e3          	beqz	s4,4e56 <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    4f7a:	2485                	addiw	s1,s1,1
    4f7c:	b50d                	j	4d9e <fsfull+0x52>

0000000000004f7e <linkoverflow>:

void
linkoverflow(char *s)
{
    4f7e:	7175                	addi	sp,sp,-144
    4f80:	e506                	sd	ra,136(sp)
    4f82:	e122                	sd	s0,128(sp)
    4f84:	fca6                	sd	s1,120(sp)
    4f86:	f8ca                	sd	s2,112(sp)
    4f88:	f4ce                	sd	s3,104(sp)
    4f8a:	f0d2                	sd	s4,96(sp)
    4f8c:	ecd6                	sd	s5,88(sp)
    4f8e:	e8da                	sd	s6,80(sp)
    4f90:	e4de                	sd	s7,72(sp)
    4f92:	e0e2                	sd	s8,64(sp)
    4f94:	fc66                	sd	s9,56(sp)
    4f96:	f86a                	sd	s10,48(sp)
    4f98:	0900                	addi	s0,sp,144
    4f9a:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    4f9c:	00003517          	auipc	a0,0x3
    4fa0:	15450513          	addi	a0,a0,340 # 80f0 <malloc+0x248e>
    4fa4:	001000ef          	jal	57a4 <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    4fa8:	20200593          	li	a1,514
    4fac:	00003517          	auipc	a0,0x3
    4fb0:	14450513          	addi	a0,a0,324 # 80f0 <malloc+0x248e>
    4fb4:	7e0000ef          	jal	5794 <open>
  if (fd < 0) {
    4fb8:	02054863          	bltz	a0,4fe8 <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    4fbc:	7c0000ef          	jal	577c <close>

  for (i = 0; i < TARGET; i++) {
    4fc0:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    4fc2:	02f00993          	li	s3,47
    pn[1] = 'd';
    4fc6:	06400b93          	li	s7,100
    pn[2] = '_';
    4fca:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    4fce:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    4fd2:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    4fd6:	00003c17          	auipc	s8,0x3
    4fda:	11ac0c13          	addi	s8,s8,282 # 80f0 <malloc+0x248e>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    4fde:	51eb8ab7          	lui	s5,0x51eb8
    4fe2:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7827>
    4fe6:	a869                	j	5080 <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    4fe8:	85ea                	mv	a1,s10
    4fea:	00003517          	auipc	a0,0x3
    4fee:	10e50513          	addi	a0,a0,270 # 80f8 <malloc+0x2496>
    4ff2:	3b9000ef          	jal	5baa <printf>
    exit(1);
    4ff6:	4505                	li	a0,1
    4ff8:	75c000ef          	jal	5754 <exit>
    pn[5] = '/';
    4ffc:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    5000:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    5004:	41f9579b          	sraiw	a5,s2,0x1f
    5008:	0127d79b          	srliw	a5,a5,0x12
    500c:	012787bb          	addw	a5,a5,s2
    5010:	40e7d79b          	sraiw	a5,a5,0xe
    5014:	0617879b          	addiw	a5,a5,97
    5018:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    501c:	41f4d71b          	sraiw	a4,s1,0x1f
    5020:	01c7571b          	srliw	a4,a4,0x1c
    5024:	9cb9                	addw	s1,s1,a4
    5026:	4044d79b          	sraiw	a5,s1,0x4
    502a:	41f7d69b          	sraiw	a3,a5,0x1f
    502e:	01c6d69b          	srliw	a3,a3,0x1c
    5032:	9fb5                	addw	a5,a5,a3
    5034:	8bbd                	andi	a5,a5,15
    5036:	9f95                	subw	a5,a5,a3
    5038:	0617879b          	addiw	a5,a5,97
    503c:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    5040:	88bd                	andi	s1,s1,15
    5042:	9c99                	subw	s1,s1,a4
    5044:	0614849b          	addiw	s1,s1,97
    5048:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    504c:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    5050:	85d2                	mv	a1,s4
    5052:	8562                	mv	a0,s8
    5054:	760000ef          	jal	57b4 <link>
    5058:	08054a63          	bltz	a0,50ec <linkoverflow+0x16e>
    if (i % 100 == 0) {
    505c:	03590733          	mul	a4,s2,s5
    5060:	9715                	srai	a4,a4,0x25
    5062:	41f9579b          	sraiw	a5,s2,0x1f
    5066:	9f1d                	subw	a4,a4,a5
    5068:	06400793          	li	a5,100
    506c:	02e787bb          	mulw	a5,a5,a4
    5070:	40f907bb          	subw	a5,s2,a5
    5074:	10078363          	beqz	a5,517a <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    5078:	2905                	addiw	s2,s2,1
    507a:	67a1                	lui	a5,0x8
    507c:	08f90863          	beq	s2,a5,510c <linkoverflow+0x18e>
    int d = i % DIRS;
    5080:	41f9571b          	sraiw	a4,s2,0x1f
    5084:	01a7571b          	srliw	a4,a4,0x1a
    5088:	012704bb          	addw	s1,a4,s2
    508c:	03f4f793          	andi	a5,s1,63
    5090:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    5092:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    5096:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    509a:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    509e:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    50a2:	41f7d71b          	sraiw	a4,a5,0x1f
    50a6:	01c7571b          	srliw	a4,a4,0x1c
    50aa:	9fb9                	addw	a5,a5,a4
    50ac:	4047d69b          	sraiw	a3,a5,0x4
    50b0:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x2f369>
    50b4:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    50b8:	8bbd                	andi	a5,a5,15
    50ba:	9f99                	subw	a5,a5,a4
    50bc:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x23ff>
    50c0:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    50c4:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    50c8:	f895                	bnez	s1,4ffc <linkoverflow+0x7e>
    50ca:	8552                	mv	a0,s4
    50cc:	6f0000ef          	jal	57bc <mkdir>
    50d0:	f20556e3          	bgez	a0,4ffc <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    50d4:	f7840613          	addi	a2,s0,-136
    50d8:	85ea                	mv	a1,s10
    50da:	00003517          	auipc	a0,0x3
    50de:	03650513          	addi	a0,a0,54 # 8110 <malloc+0x24ae>
    50e2:	2c9000ef          	jal	5baa <printf>
      exit(1);
    50e6:	4505                	li	a0,1
    50e8:	66c000ef          	jal	5754 <exit>
      if (stat("/lof", &st) < 0) {
    50ec:	f8840593          	addi	a1,s0,-120
    50f0:	00003517          	auipc	a0,0x3
    50f4:	00050513          	mv	a0,a0
    50f8:	4f6000ef          	jal	55ee <stat>
    50fc:	04054a63          	bltz	a0,5150 <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    5100:	f9241683          	lh	a3,-110(s0)
    5104:	67a1                	lui	a5,0x8
    5106:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x239d>
    5108:	04f69e63          	bne	a3,a5,5164 <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    510c:	f8840593          	addi	a1,s0,-120
    5110:	00003517          	auipc	a0,0x3
    5114:	fe050513          	addi	a0,a0,-32 # 80f0 <malloc+0x248e>
    5118:	4d6000ef          	jal	55ee <stat>
    511c:	06054963          	bltz	a0,518e <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    5120:	00003517          	auipc	a0,0x3
    5124:	fd050513          	addi	a0,a0,-48 # 80f0 <malloc+0x248e>
    5128:	67c000ef          	jal	57a4 <unlink>

  if (st.nlink < 0) {
    512c:	f9241603          	lh	a2,-110(s0)
    5130:	06064963          	bltz	a2,51a2 <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    5134:	60aa                	ld	ra,136(sp)
    5136:	640a                	ld	s0,128(sp)
    5138:	74e6                	ld	s1,120(sp)
    513a:	7946                	ld	s2,112(sp)
    513c:	79a6                	ld	s3,104(sp)
    513e:	7a06                	ld	s4,96(sp)
    5140:	6ae6                	ld	s5,88(sp)
    5142:	6b46                	ld	s6,80(sp)
    5144:	6ba6                	ld	s7,72(sp)
    5146:	6c06                	ld	s8,64(sp)
    5148:	7ce2                	ld	s9,56(sp)
    514a:	7d42                	ld	s10,48(sp)
    514c:	6149                	addi	sp,sp,144
    514e:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    5150:	85ea                	mv	a1,s10
    5152:	00003517          	auipc	a0,0x3
    5156:	fd650513          	addi	a0,a0,-42 # 8128 <malloc+0x24c6>
    515a:	251000ef          	jal	5baa <printf>
        exit(1);
    515e:	4505                	li	a0,1
    5160:	5f4000ef          	jal	5754 <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    5164:	864a                	mv	a2,s2
    5166:	85ea                	mv	a1,s10
    5168:	00003517          	auipc	a0,0x3
    516c:	fd850513          	addi	a0,a0,-40 # 8140 <malloc+0x24de>
    5170:	23b000ef          	jal	5baa <printf>
      exit(1);
    5174:	4505                	li	a0,1
    5176:	5de000ef          	jal	5754 <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    517a:	86d2                	mv	a3,s4
    517c:	864a                	mv	a2,s2
    517e:	85ea                	mv	a1,s10
    5180:	00003517          	auipc	a0,0x3
    5184:	ff050513          	addi	a0,a0,-16 # 8170 <malloc+0x250e>
    5188:	223000ef          	jal	5baa <printf>
    518c:	b5f5                	j	5078 <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    518e:	85ea                	mv	a1,s10
    5190:	00003517          	auipc	a0,0x3
    5194:	f9850513          	addi	a0,a0,-104 # 8128 <malloc+0x24c6>
    5198:	213000ef          	jal	5baa <printf>
    exit(1);
    519c:	4505                	li	a0,1
    519e:	5b6000ef          	jal	5754 <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    51a2:	85ea                	mv	a1,s10
    51a4:	00003517          	auipc	a0,0x3
    51a8:	fe450513          	addi	a0,a0,-28 # 8188 <malloc+0x2526>
    51ac:	1ff000ef          	jal	5baa <printf>
    exit(1);
    51b0:	4505                	li	a0,1
    51b2:	5a2000ef          	jal	5754 <exit>

00000000000051b6 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    51b6:	7179                	addi	sp,sp,-48
    51b8:	f406                	sd	ra,40(sp)
    51ba:	f022                	sd	s0,32(sp)
    51bc:	ec26                	sd	s1,24(sp)
    51be:	e84a                	sd	s2,16(sp)
    51c0:	1800                	addi	s0,sp,48
    51c2:	84aa                	mv	s1,a0
    51c4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    51c6:	00003517          	auipc	a0,0x3
    51ca:	fe250513          	addi	a0,a0,-30 # 81a8 <malloc+0x2546>
    51ce:	1dd000ef          	jal	5baa <printf>
  if ((pid = fork()) < 0) {
    51d2:	57a000ef          	jal	574c <fork>
    51d6:	02054a63          	bltz	a0,520a <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    51da:	c129                	beqz	a0,521c <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    51dc:	fdc40513          	addi	a0,s0,-36
    51e0:	57c000ef          	jal	575c <wait>
    if (xstatus != 0)
    51e4:	fdc42783          	lw	a5,-36(s0)
    51e8:	cf9d                	beqz	a5,5226 <run+0x70>
      printf("FAILED\n");
    51ea:	00003517          	auipc	a0,0x3
    51ee:	fe650513          	addi	a0,a0,-26 # 81d0 <malloc+0x256e>
    51f2:	1b9000ef          	jal	5baa <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51f6:	fdc42503          	lw	a0,-36(s0)
  }
}
    51fa:	00153513          	seqz	a0,a0
    51fe:	70a2                	ld	ra,40(sp)
    5200:	7402                	ld	s0,32(sp)
    5202:	64e2                	ld	s1,24(sp)
    5204:	6942                	ld	s2,16(sp)
    5206:	6145                	addi	sp,sp,48
    5208:	8082                	ret
    printf("runtest: fork error\n");
    520a:	00003517          	auipc	a0,0x3
    520e:	fae50513          	addi	a0,a0,-82 # 81b8 <malloc+0x2556>
    5212:	199000ef          	jal	5baa <printf>
    exit(1);
    5216:	4505                	li	a0,1
    5218:	53c000ef          	jal	5754 <exit>
    f(s);
    521c:	854a                	mv	a0,s2
    521e:	9482                	jalr	s1
    exit(0);
    5220:	4501                	li	a0,0
    5222:	532000ef          	jal	5754 <exit>
      printf("OK\n");
    5226:	00003517          	auipc	a0,0x3
    522a:	fb250513          	addi	a0,a0,-78 # 81d8 <malloc+0x2576>
    522e:	17d000ef          	jal	5baa <printf>
    5232:	b7d1                	j	51f6 <run+0x40>

0000000000005234 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    5234:	7179                	addi	sp,sp,-48
    5236:	f406                	sd	ra,40(sp)
    5238:	f022                	sd	s0,32(sp)
    523a:	ec26                	sd	s1,24(sp)
    523c:	e44e                	sd	s3,8(sp)
    523e:	1800                	addi	s0,sp,48
    5240:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5242:	6508                	ld	a0,8(a0)
    5244:	cd29                	beqz	a0,529e <runtests+0x6a>
    5246:	e84a                	sd	s2,16(sp)
    5248:	e052                	sd	s4,0(sp)
    524a:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    524c:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    524e:	00c03a33          	snez	s4,a2
  int ntests = 0;
    5252:	4981                	li	s3,0
    5254:	a029                	j	525e <runtests+0x2a>
      ntests++;
    5256:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    5258:	04c1                	addi	s1,s1,16
    525a:	6488                	ld	a0,8(s1)
    525c:	c905                	beqz	a0,528c <runtests+0x58>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    525e:	00090663          	beqz	s2,526a <runtests+0x36>
    5262:	85ca                	mv	a1,s2
    5264:	26a000ef          	jal	54ce <strcmp>
    5268:	f965                	bnez	a0,5258 <runtests+0x24>
      if (!run(t->f, t->s)) {
    526a:	648c                	ld	a1,8(s1)
    526c:	6088                	ld	a0,0(s1)
    526e:	f49ff0ef          	jal	51b6 <run>
        if (continuous != 2) {
    5272:	f175                	bnez	a0,5256 <runtests+0x22>
    5274:	fe0a01e3          	beqz	s4,5256 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    5278:	00003517          	auipc	a0,0x3
    527c:	f6850513          	addi	a0,a0,-152 # 81e0 <malloc+0x257e>
    5280:	12b000ef          	jal	5baa <printf>
          return -1;
    5284:	59fd                	li	s3,-1
    5286:	6942                	ld	s2,16(sp)
    5288:	6a02                	ld	s4,0(sp)
    528a:	a019                	j	5290 <runtests+0x5c>
    528c:	6942                	ld	s2,16(sp)
    528e:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    5290:	854e                	mv	a0,s3
    5292:	70a2                	ld	ra,40(sp)
    5294:	7402                	ld	s0,32(sp)
    5296:	64e2                	ld	s1,24(sp)
    5298:	69a2                	ld	s3,8(sp)
    529a:	6145                	addi	sp,sp,48
    529c:	8082                	ret
  return ntests;
    529e:	4981                	li	s3,0
    52a0:	bfc5                	j	5290 <runtests+0x5c>

00000000000052a2 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    52a2:	7179                	addi	sp,sp,-48
    52a4:	f406                	sd	ra,40(sp)
    52a6:	f022                	sd	s0,32(sp)
    52a8:	ec26                	sd	s1,24(sp)
    52aa:	e84a                	sd	s2,16(sp)
    52ac:	e44e                	sd	s3,8(sp)
    52ae:	e052                	sd	s4,0(sp)
    52b0:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    52b2:	4501                	li	a0,0
    52b4:	46c000ef          	jal	5720 <sbrk>
    52b8:	8a2a                	mv	s4,a0
  int n = 0;
    52ba:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    52bc:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    52be:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    52c0:	854e                	mv	a0,s3
    52c2:	45e000ef          	jal	5720 <sbrk>
    if (a == SBRK_ERROR) {
    52c6:	01250463          	beq	a0,s2,52ce <countfree+0x2c>
      break;
    }
    n += 1;
    52ca:	2485                	addiw	s1,s1,1
  while (1) {
    52cc:	bfd5                	j	52c0 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    52ce:	4501                	li	a0,0
    52d0:	450000ef          	jal	5720 <sbrk>
    52d4:	40aa053b          	subw	a0,s4,a0
    52d8:	448000ef          	jal	5720 <sbrk>
  return n;
}
    52dc:	8526                	mv	a0,s1
    52de:	70a2                	ld	ra,40(sp)
    52e0:	7402                	ld	s0,32(sp)
    52e2:	64e2                	ld	s1,24(sp)
    52e4:	6942                	ld	s2,16(sp)
    52e6:	69a2                	ld	s3,8(sp)
    52e8:	6a02                	ld	s4,0(sp)
    52ea:	6145                	addi	sp,sp,48
    52ec:	8082                	ret

00000000000052ee <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    52ee:	7159                	addi	sp,sp,-112
    52f0:	f486                	sd	ra,104(sp)
    52f2:	f0a2                	sd	s0,96(sp)
    52f4:	eca6                	sd	s1,88(sp)
    52f6:	e8ca                	sd	s2,80(sp)
    52f8:	e4ce                	sd	s3,72(sp)
    52fa:	e0d2                	sd	s4,64(sp)
    52fc:	fc56                	sd	s5,56(sp)
    52fe:	f85a                	sd	s6,48(sp)
    5300:	f45e                	sd	s7,40(sp)
    5302:	f062                	sd	s8,32(sp)
    5304:	ec66                	sd	s9,24(sp)
    5306:	e86a                	sd	s10,16(sp)
    5308:	e46e                	sd	s11,8(sp)
    530a:	1880                	addi	s0,sp,112
    530c:	8aaa                	mv	s5,a0
    530e:	89ae                	mv	s3,a1
    5310:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    5312:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    5316:	00003c17          	auipc	s8,0x3
    531a:	ee2c0c13          	addi	s8,s8,-286 # 81f8 <malloc+0x2596>
    n = runtests(quicktests, justone, continuous);
    531e:	00005b97          	auipc	s7,0x5
    5322:	cf2b8b93          	addi	s7,s7,-782 # a010 <quicktests>
      if (continuous != 2) {
    5326:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    5328:	00005c97          	auipc	s9,0x5
    532c:	138c8c93          	addi	s9,s9,312 # a460 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5330:	00003d97          	auipc	s11,0x3
    5334:	f00d8d93          	addi	s11,s11,-256 # 8230 <malloc+0x25ce>
    5338:	a82d                	j	5372 <drivetests+0x84>
      if (continuous != 2) {
    533a:	0b699363          	bne	s3,s6,53e0 <drivetests+0xf2>
    int ntests = 0;
    533e:	4481                	li	s1,0
    5340:	a0b9                	j	538e <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    5342:	00003517          	auipc	a0,0x3
    5346:	ece50513          	addi	a0,a0,-306 # 8210 <malloc+0x25ae>
    534a:	061000ef          	jal	5baa <printf>
    534e:	a0a1                	j	5396 <drivetests+0xa8>
        if (continuous != 2) {
    5350:	05698b63          	beq	s3,s6,53a6 <drivetests+0xb8>
          return 1;
    5354:	4505                	li	a0,1
    5356:	a0b5                	j	53c2 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5358:	864a                	mv	a2,s2
    535a:	85aa                	mv	a1,a0
    535c:	856e                	mv	a0,s11
    535e:	04d000ef          	jal	5baa <printf>
      if (continuous != 2) {
    5362:	09699163          	bne	s3,s6,53e4 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    5366:	e491                	bnez	s1,5372 <drivetests+0x84>
    5368:	000d0563          	beqz	s10,5372 <drivetests+0x84>
    536c:	a0a1                	j	53b4 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    536e:	06098d63          	beqz	s3,53e8 <drivetests+0xfa>
    printf("usertests starting\n");
    5372:	8562                	mv	a0,s8
    5374:	037000ef          	jal	5baa <printf>
    int free0 = countfree();
    5378:	f2bff0ef          	jal	52a2 <countfree>
    537c:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    537e:	864e                	mv	a2,s3
    5380:	85d2                	mv	a1,s4
    5382:	855e                	mv	a0,s7
    5384:	eb1ff0ef          	jal	5234 <runtests>
    5388:	84aa                	mv	s1,a0
    if (n < 0) {
    538a:	fa0548e3          	bltz	a0,533a <drivetests+0x4c>
    if (!quick) {
    538e:	000a9c63          	bnez	s5,53a6 <drivetests+0xb8>
      if (justone == 0)
    5392:	fa0a08e3          	beqz	s4,5342 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    5396:	864e                	mv	a2,s3
    5398:	85d2                	mv	a1,s4
    539a:	8566                	mv	a0,s9
    539c:	e99ff0ef          	jal	5234 <runtests>
      if (n < 0) {
    53a0:	fa0548e3          	bltz	a0,5350 <drivetests+0x62>
        ntests += n;
    53a4:	9ca9                	addw	s1,s1,a0
    if ((free1 = countfree()) < free0) {
    53a6:	efdff0ef          	jal	52a2 <countfree>
    53aa:	fb2547e3          	blt	a0,s2,5358 <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    53ae:	f0e1                	bnez	s1,536e <drivetests+0x80>
    53b0:	fa0d0fe3          	beqz	s10,536e <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    53b4:	00003517          	auipc	a0,0x3
    53b8:	eac50513          	addi	a0,a0,-340 # 8260 <malloc+0x25fe>
    53bc:	7ee000ef          	jal	5baa <printf>
      return 1;
    53c0:	4505                	li	a0,1
  return 0;
}
    53c2:	70a6                	ld	ra,104(sp)
    53c4:	7406                	ld	s0,96(sp)
    53c6:	64e6                	ld	s1,88(sp)
    53c8:	6946                	ld	s2,80(sp)
    53ca:	69a6                	ld	s3,72(sp)
    53cc:	6a06                	ld	s4,64(sp)
    53ce:	7ae2                	ld	s5,56(sp)
    53d0:	7b42                	ld	s6,48(sp)
    53d2:	7ba2                	ld	s7,40(sp)
    53d4:	7c02                	ld	s8,32(sp)
    53d6:	6ce2                	ld	s9,24(sp)
    53d8:	6d42                	ld	s10,16(sp)
    53da:	6da2                	ld	s11,8(sp)
    53dc:	6165                	addi	sp,sp,112
    53de:	8082                	ret
        return 1;
    53e0:	4505                	li	a0,1
    53e2:	b7c5                	j	53c2 <drivetests+0xd4>
        return 1;
    53e4:	4505                	li	a0,1
    53e6:	bff1                	j	53c2 <drivetests+0xd4>
  return 0;
    53e8:	854e                	mv	a0,s3
    53ea:	bfe1                	j	53c2 <drivetests+0xd4>

00000000000053ec <main>:

int
main(int argc, char *argv[])
{
    53ec:	1101                	addi	sp,sp,-32
    53ee:	ec06                	sd	ra,24(sp)
    53f0:	e822                	sd	s0,16(sp)
    53f2:	e426                	sd	s1,8(sp)
    53f4:	e04a                	sd	s2,0(sp)
    53f6:	1000                	addi	s0,sp,32
    53f8:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    53fa:	4789                	li	a5,2
    53fc:	00f50e63          	beq	a0,a5,5418 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5400:	4785                	li	a5,1
    5402:	06a7c663          	blt	a5,a0,546e <main+0x82>
  char *justone = 0;
    5406:	4601                	li	a2,0
  int quick = 0;
    5408:	4501                	li	a0,0
  int continuous = 0;
    540a:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    540c:	ee3ff0ef          	jal	52ee <drivetests>
    5410:	cd35                	beqz	a0,548c <main+0xa0>
    exit(1);
    5412:	4505                	li	a0,1
    5414:	340000ef          	jal	5754 <exit>
    5418:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    541a:	00003597          	auipc	a1,0x3
    541e:	e5e58593          	addi	a1,a1,-418 # 8278 <malloc+0x2616>
    5422:	00893503          	ld	a0,8(s2)
    5426:	0a8000ef          	jal	54ce <strcmp>
    542a:	85aa                	mv	a1,a0
    542c:	e501                	bnez	a0,5434 <main+0x48>
  char *justone = 0;
    542e:	4601                	li	a2,0
    quick = 1;
    5430:	4505                	li	a0,1
    5432:	bfe9                	j	540c <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    5434:	00003597          	auipc	a1,0x3
    5438:	e4c58593          	addi	a1,a1,-436 # 8280 <malloc+0x261e>
    543c:	00893503          	ld	a0,8(s2)
    5440:	08e000ef          	jal	54ce <strcmp>
    5444:	cd15                	beqz	a0,5480 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    5446:	00003597          	auipc	a1,0x3
    544a:	e8a58593          	addi	a1,a1,-374 # 82d0 <malloc+0x266e>
    544e:	00893503          	ld	a0,8(s2)
    5452:	07c000ef          	jal	54ce <strcmp>
    5456:	c905                	beqz	a0,5486 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    5458:	00893603          	ld	a2,8(s2)
    545c:	00064703          	lbu	a4,0(a2)
    5460:	02d00793          	li	a5,45
    5464:	00f70563          	beq	a4,a5,546e <main+0x82>
  int quick = 0;
    5468:	4501                	li	a0,0
  int continuous = 0;
    546a:	4581                	li	a1,0
    546c:	b745                	j	540c <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    546e:	00003517          	auipc	a0,0x3
    5472:	e1a50513          	addi	a0,a0,-486 # 8288 <malloc+0x2626>
    5476:	734000ef          	jal	5baa <printf>
    exit(1);
    547a:	4505                	li	a0,1
    547c:	2d8000ef          	jal	5754 <exit>
  char *justone = 0;
    5480:	4601                	li	a2,0
    continuous = 1;
    5482:	4585                	li	a1,1
    5484:	b761                	j	540c <main+0x20>
    continuous = 2;
    5486:	85a6                	mv	a1,s1
  char *justone = 0;
    5488:	4601                	li	a2,0
    548a:	b749                	j	540c <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    548c:	00003517          	auipc	a0,0x3
    5490:	e2c50513          	addi	a0,a0,-468 # 82b8 <malloc+0x2656>
    5494:	716000ef          	jal	5baa <printf>
  exit(0);
    5498:	4501                	li	a0,0
    549a:	2ba000ef          	jal	5754 <exit>

000000000000549e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    549e:	1141                	addi	sp,sp,-16
    54a0:	e406                	sd	ra,8(sp)
    54a2:	e022                	sd	s0,0(sp)
    54a4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    54a6:	f47ff0ef          	jal	53ec <main>
  exit(r);
    54aa:	2aa000ef          	jal	5754 <exit>

00000000000054ae <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    54ae:	1141                	addi	sp,sp,-16
    54b0:	e406                	sd	ra,8(sp)
    54b2:	e022                	sd	s0,0(sp)
    54b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    54b6:	87aa                	mv	a5,a0
    54b8:	0585                	addi	a1,a1,1
    54ba:	0785                	addi	a5,a5,1
    54bc:	fff5c703          	lbu	a4,-1(a1)
    54c0:	fee78fa3          	sb	a4,-1(a5)
    54c4:	fb75                	bnez	a4,54b8 <strcpy+0xa>
    ;
  return os;
}
    54c6:	60a2                	ld	ra,8(sp)
    54c8:	6402                	ld	s0,0(sp)
    54ca:	0141                	addi	sp,sp,16
    54cc:	8082                	ret

00000000000054ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    54ce:	1141                	addi	sp,sp,-16
    54d0:	e406                	sd	ra,8(sp)
    54d2:	e022                	sd	s0,0(sp)
    54d4:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    54d6:	00054783          	lbu	a5,0(a0)
    54da:	cb91                	beqz	a5,54ee <strcmp+0x20>
    54dc:	0005c703          	lbu	a4,0(a1)
    54e0:	00f71763          	bne	a4,a5,54ee <strcmp+0x20>
    p++, q++;
    54e4:	0505                	addi	a0,a0,1
    54e6:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    54e8:	00054783          	lbu	a5,0(a0)
    54ec:	fbe5                	bnez	a5,54dc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    54ee:	0005c503          	lbu	a0,0(a1)
}
    54f2:	40a7853b          	subw	a0,a5,a0
    54f6:	60a2                	ld	ra,8(sp)
    54f8:	6402                	ld	s0,0(sp)
    54fa:	0141                	addi	sp,sp,16
    54fc:	8082                	ret

00000000000054fe <strlen>:

uint
strlen(const char *s)
{
    54fe:	1141                	addi	sp,sp,-16
    5500:	e406                	sd	ra,8(sp)
    5502:	e022                	sd	s0,0(sp)
    5504:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    5506:	00054783          	lbu	a5,0(a0)
    550a:	cf91                	beqz	a5,5526 <strlen+0x28>
    550c:	00150793          	addi	a5,a0,1
    5510:	86be                	mv	a3,a5
    5512:	0785                	addi	a5,a5,1
    5514:	fff7c703          	lbu	a4,-1(a5)
    5518:	ff65                	bnez	a4,5510 <strlen+0x12>
    551a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    551e:	60a2                	ld	ra,8(sp)
    5520:	6402                	ld	s0,0(sp)
    5522:	0141                	addi	sp,sp,16
    5524:	8082                	ret
  for (n = 0; s[n]; n++)
    5526:	4501                	li	a0,0
    5528:	bfdd                	j	551e <strlen+0x20>

000000000000552a <memset>:

void *
memset(void *dst, int c, uint n)
{
    552a:	1141                	addi	sp,sp,-16
    552c:	e406                	sd	ra,8(sp)
    552e:	e022                	sd	s0,0(sp)
    5530:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    5532:	ca19                	beqz	a2,5548 <memset+0x1e>
    5534:	87aa                	mv	a5,a0
    5536:	1602                	slli	a2,a2,0x20
    5538:	9201                	srli	a2,a2,0x20
    553a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    553e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    5542:	0785                	addi	a5,a5,1
    5544:	fee79de3          	bne	a5,a4,553e <memset+0x14>
  }
  return dst;
}
    5548:	60a2                	ld	ra,8(sp)
    554a:	6402                	ld	s0,0(sp)
    554c:	0141                	addi	sp,sp,16
    554e:	8082                	ret

0000000000005550 <strchr>:

char *
strchr(const char *s, char c)
{
    5550:	1141                	addi	sp,sp,-16
    5552:	e406                	sd	ra,8(sp)
    5554:	e022                	sd	s0,0(sp)
    5556:	0800                	addi	s0,sp,16
  for (; *s; s++)
    5558:	00054783          	lbu	a5,0(a0)
    555c:	cf81                	beqz	a5,5574 <strchr+0x24>
    if (*s == c)
    555e:	00f58763          	beq	a1,a5,556c <strchr+0x1c>
  for (; *s; s++)
    5562:	0505                	addi	a0,a0,1
    5564:	00054783          	lbu	a5,0(a0)
    5568:	fbfd                	bnez	a5,555e <strchr+0xe>
      return (char *)s;
  return 0;
    556a:	4501                	li	a0,0
}
    556c:	60a2                	ld	ra,8(sp)
    556e:	6402                	ld	s0,0(sp)
    5570:	0141                	addi	sp,sp,16
    5572:	8082                	ret
  return 0;
    5574:	4501                	li	a0,0
    5576:	bfdd                	j	556c <strchr+0x1c>

0000000000005578 <gets>:

char *
gets(char *buf, int max)
{
    5578:	711d                	addi	sp,sp,-96
    557a:	ec86                	sd	ra,88(sp)
    557c:	e8a2                	sd	s0,80(sp)
    557e:	e4a6                	sd	s1,72(sp)
    5580:	e0ca                	sd	s2,64(sp)
    5582:	fc4e                	sd	s3,56(sp)
    5584:	f852                	sd	s4,48(sp)
    5586:	f456                	sd	s5,40(sp)
    5588:	f05a                	sd	s6,32(sp)
    558a:	ec5e                	sd	s7,24(sp)
    558c:	e862                	sd	s8,16(sp)
    558e:	1080                	addi	s0,sp,96
    5590:	8baa                	mv	s7,a0
    5592:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5594:	892a                	mv	s2,a0
    5596:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5598:	faf40b13          	addi	s6,s0,-81
    559c:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    559e:	8c26                	mv	s8,s1
    55a0:	0014899b          	addiw	s3,s1,1
    55a4:	84ce                	mv	s1,s3
    55a6:	0349d463          	bge	s3,s4,55ce <gets+0x56>
    cc = read(0, &c, 1);
    55aa:	8656                	mv	a2,s5
    55ac:	85da                	mv	a1,s6
    55ae:	4501                	li	a0,0
    55b0:	1bc000ef          	jal	576c <read>
    if (cc < 1)
    55b4:	00a05d63          	blez	a0,55ce <gets+0x56>
      break;
    buf[i++] = c;
    55b8:	faf44783          	lbu	a5,-81(s0)
    55bc:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    55c0:	0905                	addi	s2,s2,1
    55c2:	ff678713          	addi	a4,a5,-10
    55c6:	c319                	beqz	a4,55cc <gets+0x54>
    55c8:	17cd                	addi	a5,a5,-13
    55ca:	fbf1                	bnez	a5,559e <gets+0x26>
    buf[i++] = c;
    55cc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    55ce:	9c5e                	add	s8,s8,s7
    55d0:	000c0023          	sb	zero,0(s8)
  return buf;
}
    55d4:	855e                	mv	a0,s7
    55d6:	60e6                	ld	ra,88(sp)
    55d8:	6446                	ld	s0,80(sp)
    55da:	64a6                	ld	s1,72(sp)
    55dc:	6906                	ld	s2,64(sp)
    55de:	79e2                	ld	s3,56(sp)
    55e0:	7a42                	ld	s4,48(sp)
    55e2:	7aa2                	ld	s5,40(sp)
    55e4:	7b02                	ld	s6,32(sp)
    55e6:	6be2                	ld	s7,24(sp)
    55e8:	6c42                	ld	s8,16(sp)
    55ea:	6125                	addi	sp,sp,96
    55ec:	8082                	ret

00000000000055ee <stat>:

int
stat(const char *n, struct stat *st)
{
    55ee:	1101                	addi	sp,sp,-32
    55f0:	ec06                	sd	ra,24(sp)
    55f2:	e822                	sd	s0,16(sp)
    55f4:	e04a                	sd	s2,0(sp)
    55f6:	1000                	addi	s0,sp,32
    55f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    55fa:	4581                	li	a1,0
    55fc:	198000ef          	jal	5794 <open>
  if (fd < 0)
    5600:	02054263          	bltz	a0,5624 <stat+0x36>
    5604:	e426                	sd	s1,8(sp)
    5606:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5608:	85ca                	mv	a1,s2
    560a:	1a2000ef          	jal	57ac <fstat>
    560e:	892a                	mv	s2,a0
  close(fd);
    5610:	8526                	mv	a0,s1
    5612:	16a000ef          	jal	577c <close>
  return r;
    5616:	64a2                	ld	s1,8(sp)
}
    5618:	854a                	mv	a0,s2
    561a:	60e2                	ld	ra,24(sp)
    561c:	6442                	ld	s0,16(sp)
    561e:	6902                	ld	s2,0(sp)
    5620:	6105                	addi	sp,sp,32
    5622:	8082                	ret
    return -1;
    5624:	57fd                	li	a5,-1
    5626:	893e                	mv	s2,a5
    5628:	bfc5                	j	5618 <stat+0x2a>

000000000000562a <atoi>:

int
atoi(const char *s)
{
    562a:	1141                	addi	sp,sp,-16
    562c:	e406                	sd	ra,8(sp)
    562e:	e022                	sd	s0,0(sp)
    5630:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    5632:	00054683          	lbu	a3,0(a0)
    5636:	fd06879b          	addiw	a5,a3,-48
    563a:	0ff7f793          	zext.b	a5,a5
    563e:	4625                	li	a2,9
    5640:	02f66963          	bltu	a2,a5,5672 <atoi+0x48>
    5644:	872a                	mv	a4,a0
  n = 0;
    5646:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    5648:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef309>
    564a:	0025179b          	slliw	a5,a0,0x2
    564e:	9fa9                	addw	a5,a5,a0
    5650:	0017979b          	slliw	a5,a5,0x1
    5654:	9fb5                	addw	a5,a5,a3
    5656:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    565a:	00074683          	lbu	a3,0(a4)
    565e:	fd06879b          	addiw	a5,a3,-48
    5662:	0ff7f793          	zext.b	a5,a5
    5666:	fef671e3          	bgeu	a2,a5,5648 <atoi+0x1e>
  return n;
}
    566a:	60a2                	ld	ra,8(sp)
    566c:	6402                	ld	s0,0(sp)
    566e:	0141                	addi	sp,sp,16
    5670:	8082                	ret
  n = 0;
    5672:	4501                	li	a0,0
    5674:	bfdd                	j	566a <atoi+0x40>

0000000000005676 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    5676:	1141                	addi	sp,sp,-16
    5678:	e406                	sd	ra,8(sp)
    567a:	e022                	sd	s0,0(sp)
    567c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    567e:	02b57563          	bgeu	a0,a1,56a8 <memmove+0x32>
    while (n-- > 0)
    5682:	00c05f63          	blez	a2,56a0 <memmove+0x2a>
    5686:	1602                	slli	a2,a2,0x20
    5688:	9201                	srli	a2,a2,0x20
    568a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    568e:	872a                	mv	a4,a0
      *dst++ = *src++;
    5690:	0585                	addi	a1,a1,1
    5692:	0705                	addi	a4,a4,1
    5694:	fff5c683          	lbu	a3,-1(a1)
    5698:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    569c:	fee79ae3          	bne	a5,a4,5690 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    56a0:	60a2                	ld	ra,8(sp)
    56a2:	6402                	ld	s0,0(sp)
    56a4:	0141                	addi	sp,sp,16
    56a6:	8082                	ret
    while (n-- > 0)
    56a8:	fec05ce3          	blez	a2,56a0 <memmove+0x2a>
    dst += n;
    56ac:	00c50733          	add	a4,a0,a2
    src += n;
    56b0:	95b2                	add	a1,a1,a2
    56b2:	fff6079b          	addiw	a5,a2,-1
    56b6:	1782                	slli	a5,a5,0x20
    56b8:	9381                	srli	a5,a5,0x20
    56ba:	fff7c793          	not	a5,a5
    56be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    56c0:	15fd                	addi	a1,a1,-1
    56c2:	177d                	addi	a4,a4,-1
    56c4:	0005c683          	lbu	a3,0(a1)
    56c8:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    56cc:	fef71ae3          	bne	a4,a5,56c0 <memmove+0x4a>
    56d0:	bfc1                	j	56a0 <memmove+0x2a>

00000000000056d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    56d2:	1141                	addi	sp,sp,-16
    56d4:	e406                	sd	ra,8(sp)
    56d6:	e022                	sd	s0,0(sp)
    56d8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    56da:	c61d                	beqz	a2,5708 <memcmp+0x36>
    56dc:	1602                	slli	a2,a2,0x20
    56de:	9201                	srli	a2,a2,0x20
    56e0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    56e4:	00054783          	lbu	a5,0(a0)
    56e8:	0005c703          	lbu	a4,0(a1)
    56ec:	00e79863          	bne	a5,a4,56fc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    56f0:	0505                	addi	a0,a0,1
    p2++;
    56f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    56f4:	fed518e3          	bne	a0,a3,56e4 <memcmp+0x12>
  }
  return 0;
    56f8:	4501                	li	a0,0
    56fa:	a019                	j	5700 <memcmp+0x2e>
      return *p1 - *p2;
    56fc:	40e7853b          	subw	a0,a5,a4
}
    5700:	60a2                	ld	ra,8(sp)
    5702:	6402                	ld	s0,0(sp)
    5704:	0141                	addi	sp,sp,16
    5706:	8082                	ret
  return 0;
    5708:	4501                	li	a0,0
    570a:	bfdd                	j	5700 <memcmp+0x2e>

000000000000570c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    570c:	1141                	addi	sp,sp,-16
    570e:	e406                	sd	ra,8(sp)
    5710:	e022                	sd	s0,0(sp)
    5712:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5714:	f63ff0ef          	jal	5676 <memmove>
}
    5718:	60a2                	ld	ra,8(sp)
    571a:	6402                	ld	s0,0(sp)
    571c:	0141                	addi	sp,sp,16
    571e:	8082                	ret

0000000000005720 <sbrk>:

char *
sbrk(int n)
{
    5720:	1141                	addi	sp,sp,-16
    5722:	e406                	sd	ra,8(sp)
    5724:	e022                	sd	s0,0(sp)
    5726:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    5728:	4585                	li	a1,1
    572a:	0b2000ef          	jal	57dc <sys_sbrk>
}
    572e:	60a2                	ld	ra,8(sp)
    5730:	6402                	ld	s0,0(sp)
    5732:	0141                	addi	sp,sp,16
    5734:	8082                	ret

0000000000005736 <sbrklazy>:

char *
sbrklazy(int n)
{
    5736:	1141                	addi	sp,sp,-16
    5738:	e406                	sd	ra,8(sp)
    573a:	e022                	sd	s0,0(sp)
    573c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    573e:	4589                	li	a1,2
    5740:	09c000ef          	jal	57dc <sys_sbrk>
}
    5744:	60a2                	ld	ra,8(sp)
    5746:	6402                	ld	s0,0(sp)
    5748:	0141                	addi	sp,sp,16
    574a:	8082                	ret

000000000000574c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    574c:	4885                	li	a7,1
 ecall
    574e:	00000073          	ecall
 ret
    5752:	8082                	ret

0000000000005754 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5754:	4889                	li	a7,2
 ecall
    5756:	00000073          	ecall
 ret
    575a:	8082                	ret

000000000000575c <wait>:
.global wait
wait:
 li a7, SYS_wait
    575c:	488d                	li	a7,3
 ecall
    575e:	00000073          	ecall
 ret
    5762:	8082                	ret

0000000000005764 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5764:	4891                	li	a7,4
 ecall
    5766:	00000073          	ecall
 ret
    576a:	8082                	ret

000000000000576c <read>:
.global read
read:
 li a7, SYS_read
    576c:	4895                	li	a7,5
 ecall
    576e:	00000073          	ecall
 ret
    5772:	8082                	ret

0000000000005774 <write>:
.global write
write:
 li a7, SYS_write
    5774:	48c1                	li	a7,16
 ecall
    5776:	00000073          	ecall
 ret
    577a:	8082                	ret

000000000000577c <close>:
.global close
close:
 li a7, SYS_close
    577c:	48d5                	li	a7,21
 ecall
    577e:	00000073          	ecall
 ret
    5782:	8082                	ret

0000000000005784 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5784:	4899                	li	a7,6
 ecall
    5786:	00000073          	ecall
 ret
    578a:	8082                	ret

000000000000578c <exec>:
.global exec
exec:
 li a7, SYS_exec
    578c:	489d                	li	a7,7
 ecall
    578e:	00000073          	ecall
 ret
    5792:	8082                	ret

0000000000005794 <open>:
.global open
open:
 li a7, SYS_open
    5794:	48bd                	li	a7,15
 ecall
    5796:	00000073          	ecall
 ret
    579a:	8082                	ret

000000000000579c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    579c:	48c5                	li	a7,17
 ecall
    579e:	00000073          	ecall
 ret
    57a2:	8082                	ret

00000000000057a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    57a4:	48c9                	li	a7,18
 ecall
    57a6:	00000073          	ecall
 ret
    57aa:	8082                	ret

00000000000057ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    57ac:	48a1                	li	a7,8
 ecall
    57ae:	00000073          	ecall
 ret
    57b2:	8082                	ret

00000000000057b4 <link>:
.global link
link:
 li a7, SYS_link
    57b4:	48cd                	li	a7,19
 ecall
    57b6:	00000073          	ecall
 ret
    57ba:	8082                	ret

00000000000057bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    57bc:	48d1                	li	a7,20
 ecall
    57be:	00000073          	ecall
 ret
    57c2:	8082                	ret

00000000000057c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    57c4:	48a5                	li	a7,9
 ecall
    57c6:	00000073          	ecall
 ret
    57ca:	8082                	ret

00000000000057cc <dup>:
.global dup
dup:
 li a7, SYS_dup
    57cc:	48a9                	li	a7,10
 ecall
    57ce:	00000073          	ecall
 ret
    57d2:	8082                	ret

00000000000057d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    57d4:	48ad                	li	a7,11
 ecall
    57d6:	00000073          	ecall
 ret
    57da:	8082                	ret

00000000000057dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    57dc:	48b1                	li	a7,12
 ecall
    57de:	00000073          	ecall
 ret
    57e2:	8082                	ret

00000000000057e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
    57e4:	48b5                	li	a7,13
 ecall
    57e6:	00000073          	ecall
 ret
    57ea:	8082                	ret

00000000000057ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    57ec:	48b9                	li	a7,14
 ecall
    57ee:	00000073          	ecall
 ret
    57f2:	8082                	ret

00000000000057f4 <sync>:
.global sync
sync:
 li a7, SYS_sync
    57f4:	48d9                	li	a7,22
 ecall
    57f6:	00000073          	ecall
 ret
    57fa:	8082                	ret

00000000000057fc <trace>:
.global trace
trace:
 li a7, SYS_trace
    57fc:	48dd                	li	a7,23
 ecall
    57fe:	00000073          	ecall
 ret
    5802:	8082                	ret

0000000000005804 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5804:	1101                	addi	sp,sp,-32
    5806:	ec06                	sd	ra,24(sp)
    5808:	e822                	sd	s0,16(sp)
    580a:	1000                	addi	s0,sp,32
    580c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5810:	4605                	li	a2,1
    5812:	fef40593          	addi	a1,s0,-17
    5816:	f5fff0ef          	jal	5774 <write>
}
    581a:	60e2                	ld	ra,24(sp)
    581c:	6442                	ld	s0,16(sp)
    581e:	6105                	addi	sp,sp,32
    5820:	8082                	ret

0000000000005822 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    5822:	715d                	addi	sp,sp,-80
    5824:	e486                	sd	ra,72(sp)
    5826:	e0a2                	sd	s0,64(sp)
    5828:	f84a                	sd	s2,48(sp)
    582a:	f44e                	sd	s3,40(sp)
    582c:	0880                	addi	s0,sp,80
    582e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    5830:	c6d1                	beqz	a3,58bc <printint+0x9a>
    5832:	0805d563          	bgez	a1,58bc <printint+0x9a>
    neg = 1;
    x = -xx;
    5836:	40b005b3          	neg	a1,a1
    neg = 1;
    583a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    583c:	fb840993          	addi	s3,s0,-72
  neg = 0;
    5840:	86ce                	mv	a3,s3
  i = 0;
    5842:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5844:	00003817          	auipc	a6,0x3
    5848:	ef480813          	addi	a6,a6,-268 # 8738 <digits>
    584c:	88ba                	mv	a7,a4
    584e:	0017051b          	addiw	a0,a4,1
    5852:	872a                	mv	a4,a0
    5854:	02c5f7b3          	remu	a5,a1,a2
    5858:	97c2                	add	a5,a5,a6
    585a:	0007c783          	lbu	a5,0(a5)
    585e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5862:	87ae                	mv	a5,a1
    5864:	02c5d5b3          	divu	a1,a1,a2
    5868:	0685                	addi	a3,a3,1
    586a:	fec7f1e3          	bgeu	a5,a2,584c <printint+0x2a>
  if (neg)
    586e:	00030c63          	beqz	t1,5886 <printint+0x64>
    buf[i++] = '-';
    5872:	fd050793          	addi	a5,a0,-48
    5876:	00878533          	add	a0,a5,s0
    587a:	02d00793          	li	a5,45
    587e:	fef50423          	sb	a5,-24(a0)
    5882:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    5886:	02e05563          	blez	a4,58b0 <printint+0x8e>
    588a:	fc26                	sd	s1,56(sp)
    588c:	377d                	addiw	a4,a4,-1
    588e:	00e984b3          	add	s1,s3,a4
    5892:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    5894:	99ba                	add	s3,s3,a4
    5896:	1702                	slli	a4,a4,0x20
    5898:	9301                	srli	a4,a4,0x20
    589a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    589e:	0004c583          	lbu	a1,0(s1)
    58a2:	854a                	mv	a0,s2
    58a4:	f61ff0ef          	jal	5804 <putc>
  while (--i >= 0)
    58a8:	14fd                	addi	s1,s1,-1
    58aa:	ff349ae3          	bne	s1,s3,589e <printint+0x7c>
    58ae:	74e2                	ld	s1,56(sp)
}
    58b0:	60a6                	ld	ra,72(sp)
    58b2:	6406                	ld	s0,64(sp)
    58b4:	7942                	ld	s2,48(sp)
    58b6:	79a2                	ld	s3,40(sp)
    58b8:	6161                	addi	sp,sp,80
    58ba:	8082                	ret
  neg = 0;
    58bc:	4301                	li	t1,0
    58be:	bfbd                	j	583c <printint+0x1a>

00000000000058c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    58c0:	711d                	addi	sp,sp,-96
    58c2:	ec86                	sd	ra,88(sp)
    58c4:	e8a2                	sd	s0,80(sp)
    58c6:	e4a6                	sd	s1,72(sp)
    58c8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    58ca:	0005c483          	lbu	s1,0(a1)
    58ce:	22048363          	beqz	s1,5af4 <vprintf+0x234>
    58d2:	e0ca                	sd	s2,64(sp)
    58d4:	fc4e                	sd	s3,56(sp)
    58d6:	f852                	sd	s4,48(sp)
    58d8:	f456                	sd	s5,40(sp)
    58da:	f05a                	sd	s6,32(sp)
    58dc:	ec5e                	sd	s7,24(sp)
    58de:	e862                	sd	s8,16(sp)
    58e0:	8b2a                	mv	s6,a0
    58e2:	8a2e                	mv	s4,a1
    58e4:	8bb2                	mv	s7,a2
  state = 0;
    58e6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    58e8:	4901                	li	s2,0
    58ea:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    58ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    58f0:	06400c13          	li	s8,100
    58f4:	a00d                	j	5916 <vprintf+0x56>
        putc(fd, c0);
    58f6:	85a6                	mv	a1,s1
    58f8:	855a                	mv	a0,s6
    58fa:	f0bff0ef          	jal	5804 <putc>
    58fe:	a019                	j	5904 <vprintf+0x44>
    } else if (state == '%') {
    5900:	03598363          	beq	s3,s5,5926 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    5904:	0019079b          	addiw	a5,s2,1
    5908:	893e                	mv	s2,a5
    590a:	873e                	mv	a4,a5
    590c:	97d2                	add	a5,a5,s4
    590e:	0007c483          	lbu	s1,0(a5)
    5912:	1c048a63          	beqz	s1,5ae6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    5916:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    591a:	fe0993e3          	bnez	s3,5900 <vprintf+0x40>
      if (c0 == '%') {
    591e:	fd579ce3          	bne	a5,s5,58f6 <vprintf+0x36>
        state = '%';
    5922:	89be                	mv	s3,a5
    5924:	b7c5                	j	5904 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    5926:	00ea06b3          	add	a3,s4,a4
    592a:	0016c603          	lbu	a2,1(a3)
      if (c1)
    592e:	1c060863          	beqz	a2,5afe <vprintf+0x23e>
      if (c0 == 'd') {
    5932:	03878763          	beq	a5,s8,5960 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    5936:	f9478693          	addi	a3,a5,-108
    593a:	0016b693          	seqz	a3,a3
    593e:	f9c60593          	addi	a1,a2,-100
    5942:	e99d                	bnez	a1,5978 <vprintf+0xb8>
    5944:	ca95                	beqz	a3,5978 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5946:	008b8493          	addi	s1,s7,8
    594a:	4685                	li	a3,1
    594c:	4629                	li	a2,10
    594e:	000bb583          	ld	a1,0(s7)
    5952:	855a                	mv	a0,s6
    5954:	ecfff0ef          	jal	5822 <printint>
        i += 1;
    5958:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    595a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    595c:	4981                	li	s3,0
    595e:	b75d                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5960:	008b8493          	addi	s1,s7,8
    5964:	4685                	li	a3,1
    5966:	4629                	li	a2,10
    5968:	000ba583          	lw	a1,0(s7)
    596c:	855a                	mv	a0,s6
    596e:	eb5ff0ef          	jal	5822 <printint>
    5972:	8ba6                	mv	s7,s1
      state = 0;
    5974:	4981                	li	s3,0
    5976:	b779                	j	5904 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
    5978:	9752                	add	a4,a4,s4
    597a:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    597e:	f9460713          	addi	a4,a2,-108
    5982:	00173713          	seqz	a4,a4
    5986:	8f75                	and	a4,a4,a3
    5988:	f9c58513          	addi	a0,a1,-100
    598c:	18051363          	bnez	a0,5b12 <vprintf+0x252>
    5990:	18070163          	beqz	a4,5b12 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5994:	008b8493          	addi	s1,s7,8
    5998:	4685                	li	a3,1
    599a:	4629                	li	a2,10
    599c:	000bb583          	ld	a1,0(s7)
    59a0:	855a                	mv	a0,s6
    59a2:	e81ff0ef          	jal	5822 <printint>
        i += 2;
    59a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    59a8:	8ba6                	mv	s7,s1
      state = 0;
    59aa:	4981                	li	s3,0
        i += 2;
    59ac:	bfa1                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    59ae:	008b8493          	addi	s1,s7,8
    59b2:	4681                	li	a3,0
    59b4:	4629                	li	a2,10
    59b6:	000be583          	lwu	a1,0(s7)
    59ba:	855a                	mv	a0,s6
    59bc:	e67ff0ef          	jal	5822 <printint>
    59c0:	8ba6                	mv	s7,s1
      state = 0;
    59c2:	4981                	li	s3,0
    59c4:	b781                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59c6:	008b8493          	addi	s1,s7,8
    59ca:	4681                	li	a3,0
    59cc:	4629                	li	a2,10
    59ce:	000bb583          	ld	a1,0(s7)
    59d2:	855a                	mv	a0,s6
    59d4:	e4fff0ef          	jal	5822 <printint>
        i += 1;
    59d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    59da:	8ba6                	mv	s7,s1
      state = 0;
    59dc:	4981                	li	s3,0
    59de:	b71d                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59e0:	008b8493          	addi	s1,s7,8
    59e4:	4681                	li	a3,0
    59e6:	4629                	li	a2,10
    59e8:	000bb583          	ld	a1,0(s7)
    59ec:	855a                	mv	a0,s6
    59ee:	e35ff0ef          	jal	5822 <printint>
        i += 2;
    59f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    59f4:	8ba6                	mv	s7,s1
      state = 0;
    59f6:	4981                	li	s3,0
        i += 2;
    59f8:	b731                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    59fa:	008b8493          	addi	s1,s7,8
    59fe:	4681                	li	a3,0
    5a00:	4641                	li	a2,16
    5a02:	000be583          	lwu	a1,0(s7)
    5a06:	855a                	mv	a0,s6
    5a08:	e1bff0ef          	jal	5822 <printint>
    5a0c:	8ba6                	mv	s7,s1
      state = 0;
    5a0e:	4981                	li	s3,0
    5a10:	bdd5                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a12:	008b8493          	addi	s1,s7,8
    5a16:	4681                	li	a3,0
    5a18:	4641                	li	a2,16
    5a1a:	000bb583          	ld	a1,0(s7)
    5a1e:	855a                	mv	a0,s6
    5a20:	e03ff0ef          	jal	5822 <printint>
        i += 1;
    5a24:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a26:	8ba6                	mv	s7,s1
      state = 0;
    5a28:	4981                	li	s3,0
    5a2a:	bde9                	j	5904 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a2c:	008b8493          	addi	s1,s7,8
    5a30:	4681                	li	a3,0
    5a32:	4641                	li	a2,16
    5a34:	000bb583          	ld	a1,0(s7)
    5a38:	855a                	mv	a0,s6
    5a3a:	de9ff0ef          	jal	5822 <printint>
        i += 2;
    5a3e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a40:	8ba6                	mv	s7,s1
      state = 0;
    5a42:	4981                	li	s3,0
        i += 2;
    5a44:	b5c1                	j	5904 <vprintf+0x44>
    5a46:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5a48:	008b8793          	addi	a5,s7,8
    5a4c:	8cbe                	mv	s9,a5
    5a4e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5a52:	03000593          	li	a1,48
    5a56:	855a                	mv	a0,s6
    5a58:	dadff0ef          	jal	5804 <putc>
  putc(fd, 'x');
    5a5c:	07800593          	li	a1,120
    5a60:	855a                	mv	a0,s6
    5a62:	da3ff0ef          	jal	5804 <putc>
    5a66:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a68:	00003b97          	auipc	s7,0x3
    5a6c:	cd0b8b93          	addi	s7,s7,-816 # 8738 <digits>
    5a70:	03c9d793          	srli	a5,s3,0x3c
    5a74:	97de                	add	a5,a5,s7
    5a76:	0007c583          	lbu	a1,0(a5)
    5a7a:	855a                	mv	a0,s6
    5a7c:	d89ff0ef          	jal	5804 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5a80:	0992                	slli	s3,s3,0x4
    5a82:	34fd                	addiw	s1,s1,-1
    5a84:	f4f5                	bnez	s1,5a70 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    5a86:	8be6                	mv	s7,s9
      state = 0;
    5a88:	4981                	li	s3,0
    5a8a:	6ca2                	ld	s9,8(sp)
    5a8c:	bda5                	j	5904 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5a8e:	008b8493          	addi	s1,s7,8
    5a92:	000bc583          	lbu	a1,0(s7)
    5a96:	855a                	mv	a0,s6
    5a98:	d6dff0ef          	jal	5804 <putc>
    5a9c:	8ba6                	mv	s7,s1
      state = 0;
    5a9e:	4981                	li	s3,0
    5aa0:	b595                	j	5904 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5aa2:	008b8993          	addi	s3,s7,8
    5aa6:	000bb483          	ld	s1,0(s7)
    5aaa:	cc91                	beqz	s1,5ac6 <vprintf+0x206>
        for (; *s; s++)
    5aac:	0004c583          	lbu	a1,0(s1)
    5ab0:	c985                	beqz	a1,5ae0 <vprintf+0x220>
          putc(fd, *s);
    5ab2:	855a                	mv	a0,s6
    5ab4:	d51ff0ef          	jal	5804 <putc>
        for (; *s; s++)
    5ab8:	0485                	addi	s1,s1,1
    5aba:	0004c583          	lbu	a1,0(s1)
    5abe:	f9f5                	bnez	a1,5ab2 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
    5ac0:	8bce                	mv	s7,s3
      state = 0;
    5ac2:	4981                	li	s3,0
    5ac4:	b581                	j	5904 <vprintf+0x44>
          s = "(null)";
    5ac6:	00003497          	auipc	s1,0x3
    5aca:	bc248493          	addi	s1,s1,-1086 # 8688 <malloc+0x2a26>
        for (; *s; s++)
    5ace:	02800593          	li	a1,40
    5ad2:	b7c5                	j	5ab2 <vprintf+0x1f2>
        putc(fd, '%');
    5ad4:	85be                	mv	a1,a5
    5ad6:	855a                	mv	a0,s6
    5ad8:	d2dff0ef          	jal	5804 <putc>
      state = 0;
    5adc:	4981                	li	s3,0
    5ade:	b51d                	j	5904 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5ae0:	8bce                	mv	s7,s3
      state = 0;
    5ae2:	4981                	li	s3,0
    5ae4:	b505                	j	5904 <vprintf+0x44>
    5ae6:	6906                	ld	s2,64(sp)
    5ae8:	79e2                	ld	s3,56(sp)
    5aea:	7a42                	ld	s4,48(sp)
    5aec:	7aa2                	ld	s5,40(sp)
    5aee:	7b02                	ld	s6,32(sp)
    5af0:	6be2                	ld	s7,24(sp)
    5af2:	6c42                	ld	s8,16(sp)
    }
  }
}
    5af4:	60e6                	ld	ra,88(sp)
    5af6:	6446                	ld	s0,80(sp)
    5af8:	64a6                	ld	s1,72(sp)
    5afa:	6125                	addi	sp,sp,96
    5afc:	8082                	ret
      if (c0 == 'd') {
    5afe:	06400713          	li	a4,100
    5b02:	e4e78fe3          	beq	a5,a4,5960 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
    5b06:	f9478693          	addi	a3,a5,-108
    5b0a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5b0e:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5b10:	4701                	li	a4,0
      } else if (c0 == 'u') {
    5b12:	07500513          	li	a0,117
    5b16:	e8a78ce3          	beq	a5,a0,59ae <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
    5b1a:	f8b60513          	addi	a0,a2,-117
    5b1e:	e119                	bnez	a0,5b24 <vprintf+0x264>
    5b20:	ea0693e3          	bnez	a3,59c6 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5b24:	f8b58513          	addi	a0,a1,-117
    5b28:	e119                	bnez	a0,5b2e <vprintf+0x26e>
    5b2a:	ea071be3          	bnez	a4,59e0 <vprintf+0x120>
      } else if (c0 == 'x') {
    5b2e:	07800513          	li	a0,120
    5b32:	eca784e3          	beq	a5,a0,59fa <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
    5b36:	f8860613          	addi	a2,a2,-120
    5b3a:	e219                	bnez	a2,5b40 <vprintf+0x280>
    5b3c:	ec069be3          	bnez	a3,5a12 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5b40:	f8858593          	addi	a1,a1,-120
    5b44:	e199                	bnez	a1,5b4a <vprintf+0x28a>
    5b46:	ee0713e3          	bnez	a4,5a2c <vprintf+0x16c>
      } else if (c0 == 'p') {
    5b4a:	07000713          	li	a4,112
    5b4e:	eee78ce3          	beq	a5,a4,5a46 <vprintf+0x186>
      } else if (c0 == 'c') {
    5b52:	06300713          	li	a4,99
    5b56:	f2e78ce3          	beq	a5,a4,5a8e <vprintf+0x1ce>
      } else if (c0 == 's') {
    5b5a:	07300713          	li	a4,115
    5b5e:	f4e782e3          	beq	a5,a4,5aa2 <vprintf+0x1e2>
      } else if (c0 == '%') {
    5b62:	02500713          	li	a4,37
    5b66:	f6e787e3          	beq	a5,a4,5ad4 <vprintf+0x214>
        putc(fd, '%');
    5b6a:	02500593          	li	a1,37
    5b6e:	855a                	mv	a0,s6
    5b70:	c95ff0ef          	jal	5804 <putc>
        putc(fd, c0);
    5b74:	85a6                	mv	a1,s1
    5b76:	855a                	mv	a0,s6
    5b78:	c8dff0ef          	jal	5804 <putc>
      state = 0;
    5b7c:	4981                	li	s3,0
    5b7e:	b359                	j	5904 <vprintf+0x44>

0000000000005b80 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b80:	715d                	addi	sp,sp,-80
    5b82:	ec06                	sd	ra,24(sp)
    5b84:	e822                	sd	s0,16(sp)
    5b86:	1000                	addi	s0,sp,32
    5b88:	e010                	sd	a2,0(s0)
    5b8a:	e414                	sd	a3,8(s0)
    5b8c:	e818                	sd	a4,16(s0)
    5b8e:	ec1c                	sd	a5,24(s0)
    5b90:	03043023          	sd	a6,32(s0)
    5b94:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5b98:	8622                	mv	a2,s0
    5b9a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5b9e:	d23ff0ef          	jal	58c0 <vprintf>
}
    5ba2:	60e2                	ld	ra,24(sp)
    5ba4:	6442                	ld	s0,16(sp)
    5ba6:	6161                	addi	sp,sp,80
    5ba8:	8082                	ret

0000000000005baa <printf>:

void
printf(const char *fmt, ...)
{
    5baa:	711d                	addi	sp,sp,-96
    5bac:	ec06                	sd	ra,24(sp)
    5bae:	e822                	sd	s0,16(sp)
    5bb0:	1000                	addi	s0,sp,32
    5bb2:	e40c                	sd	a1,8(s0)
    5bb4:	e810                	sd	a2,16(s0)
    5bb6:	ec14                	sd	a3,24(s0)
    5bb8:	f018                	sd	a4,32(s0)
    5bba:	f41c                	sd	a5,40(s0)
    5bbc:	03043823          	sd	a6,48(s0)
    5bc0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bc4:	00840613          	addi	a2,s0,8
    5bc8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bcc:	85aa                	mv	a1,a0
    5bce:	4505                	li	a0,1
    5bd0:	cf1ff0ef          	jal	58c0 <vprintf>
}
    5bd4:	60e2                	ld	ra,24(sp)
    5bd6:	6442                	ld	s0,16(sp)
    5bd8:	6125                	addi	sp,sp,96
    5bda:	8082                	ret

0000000000005bdc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5bdc:	1141                	addi	sp,sp,-16
    5bde:	e406                	sd	ra,8(sp)
    5be0:	e022                	sd	s0,0(sp)
    5be2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5be4:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5be8:	00005797          	auipc	a5,0x5
    5bec:	8e87b783          	ld	a5,-1816(a5) # a4d0 <freep>
    5bf0:	a039                	j	5bfe <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5bf2:	6398                	ld	a4,0(a5)
    5bf4:	00e7e463          	bltu	a5,a4,5bfc <free+0x20>
    5bf8:	00e6ea63          	bltu	a3,a4,5c0c <free+0x30>
{
    5bfc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5bfe:	fed7fae3          	bgeu	a5,a3,5bf2 <free+0x16>
    5c02:	6398                	ld	a4,0(a5)
    5c04:	00e6e463          	bltu	a3,a4,5c0c <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c08:	fee7eae3          	bltu	a5,a4,5bfc <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
    5c0c:	ff852583          	lw	a1,-8(a0)
    5c10:	6390                	ld	a2,0(a5)
    5c12:	02059813          	slli	a6,a1,0x20
    5c16:	01c85713          	srli	a4,a6,0x1c
    5c1a:	9736                	add	a4,a4,a3
    5c1c:	02e60563          	beq	a2,a4,5c46 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5c20:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    5c24:	4790                	lw	a2,8(a5)
    5c26:	02061593          	slli	a1,a2,0x20
    5c2a:	01c5d713          	srli	a4,a1,0x1c
    5c2e:	973e                	add	a4,a4,a5
    5c30:	02e68263          	beq	a3,a4,5c54 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5c34:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5c36:	00005717          	auipc	a4,0x5
    5c3a:	88f73d23          	sd	a5,-1894(a4) # a4d0 <freep>
}
    5c3e:	60a2                	ld	ra,8(sp)
    5c40:	6402                	ld	s0,0(sp)
    5c42:	0141                	addi	sp,sp,16
    5c44:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5c46:	4618                	lw	a4,8(a2)
    5c48:	9f2d                	addw	a4,a4,a1
    5c4a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c4e:	6398                	ld	a4,0(a5)
    5c50:	6310                	ld	a2,0(a4)
    5c52:	b7f9                	j	5c20 <free+0x44>
    p->s.size += bp->s.size;
    5c54:	ff852703          	lw	a4,-8(a0)
    5c58:	9f31                	addw	a4,a4,a2
    5c5a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5c5c:	ff053683          	ld	a3,-16(a0)
    5c60:	bfd1                	j	5c34 <free+0x58>

0000000000005c62 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5c62:	7139                	addi	sp,sp,-64
    5c64:	fc06                	sd	ra,56(sp)
    5c66:	f822                	sd	s0,48(sp)
    5c68:	f04a                	sd	s2,32(sp)
    5c6a:	ec4e                	sd	s3,24(sp)
    5c6c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5c6e:	02051993          	slli	s3,a0,0x20
    5c72:	0209d993          	srli	s3,s3,0x20
    5c76:	09bd                	addi	s3,s3,15
    5c78:	0049d993          	srli	s3,s3,0x4
    5c7c:	2985                	addiw	s3,s3,1
    5c7e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5c80:	00005517          	auipc	a0,0x5
    5c84:	85053503          	ld	a0,-1968(a0) # a4d0 <freep>
    5c88:	c905                	beqz	a0,5cb8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c8a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c8c:	4798                	lw	a4,8(a5)
    5c8e:	09377663          	bgeu	a4,s3,5d1a <malloc+0xb8>
    5c92:	f426                	sd	s1,40(sp)
    5c94:	e852                	sd	s4,16(sp)
    5c96:	e456                	sd	s5,8(sp)
    5c98:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5c9a:	8a4e                	mv	s4,s3
    5c9c:	6705                	lui	a4,0x1
    5c9e:	00e9f363          	bgeu	s3,a4,5ca4 <malloc+0x42>
    5ca2:	6a05                	lui	s4,0x1
    5ca4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5ca8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5cac:	00005497          	auipc	s1,0x5
    5cb0:	82448493          	addi	s1,s1,-2012 # a4d0 <freep>
  if (p == SBRK_ERROR)
    5cb4:	5afd                	li	s5,-1
    5cb6:	a83d                	j	5cf4 <malloc+0x92>
    5cb8:	f426                	sd	s1,40(sp)
    5cba:	e852                	sd	s4,16(sp)
    5cbc:	e456                	sd	s5,8(sp)
    5cbe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5cc0:	0000b797          	auipc	a5,0xb
    5cc4:	03878793          	addi	a5,a5,56 # 10cf8 <base>
    5cc8:	00005717          	auipc	a4,0x5
    5ccc:	80f73423          	sd	a5,-2040(a4) # a4d0 <freep>
    5cd0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5cd2:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5cd6:	b7d1                	j	5c9a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5cd8:	6398                	ld	a4,0(a5)
    5cda:	e118                	sd	a4,0(a0)
    5cdc:	a899                	j	5d32 <malloc+0xd0>
  hp->s.size = nu;
    5cde:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5ce2:	0541                	addi	a0,a0,16
    5ce4:	ef9ff0ef          	jal	5bdc <free>
  return freep;
    5ce8:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5cea:	c125                	beqz	a0,5d4a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5cec:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5cee:	4798                	lw	a4,8(a5)
    5cf0:	03277163          	bgeu	a4,s2,5d12 <malloc+0xb0>
    if (p == freep)
    5cf4:	6098                	ld	a4,0(s1)
    5cf6:	853e                	mv	a0,a5
    5cf8:	fef71ae3          	bne	a4,a5,5cec <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5cfc:	8552                	mv	a0,s4
    5cfe:	a23ff0ef          	jal	5720 <sbrk>
  if (p == SBRK_ERROR)
    5d02:	fd551ee3          	bne	a0,s5,5cde <malloc+0x7c>
        return 0;
    5d06:	4501                	li	a0,0
    5d08:	74a2                	ld	s1,40(sp)
    5d0a:	6a42                	ld	s4,16(sp)
    5d0c:	6aa2                	ld	s5,8(sp)
    5d0e:	6b02                	ld	s6,0(sp)
    5d10:	a03d                	j	5d3e <malloc+0xdc>
    5d12:	74a2                	ld	s1,40(sp)
    5d14:	6a42                	ld	s4,16(sp)
    5d16:	6aa2                	ld	s5,8(sp)
    5d18:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5d1a:	fae90fe3          	beq	s2,a4,5cd8 <malloc+0x76>
        p->s.size -= nunits;
    5d1e:	4137073b          	subw	a4,a4,s3
    5d22:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d24:	02071693          	slli	a3,a4,0x20
    5d28:	01c6d713          	srli	a4,a3,0x1c
    5d2c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d2e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d32:	00004717          	auipc	a4,0x4
    5d36:	78a73f23          	sd	a0,1950(a4) # a4d0 <freep>
      return (void *)(p + 1);
    5d3a:	01078513          	addi	a0,a5,16
  }
}
    5d3e:	70e2                	ld	ra,56(sp)
    5d40:	7442                	ld	s0,48(sp)
    5d42:	7902                	ld	s2,32(sp)
    5d44:	69e2                	ld	s3,24(sp)
    5d46:	6121                	addi	sp,sp,64
    5d48:	8082                	ret
    5d4a:	74a2                	ld	s1,40(sp)
    5d4c:	6a42                	ld	s4,16(sp)
    5d4e:	6aa2                	ld	s5,8(sp)
    5d50:	6b02                	ld	s6,0(sp)
    5d52:	b7f5                	j	5d3e <malloc+0xdc>
