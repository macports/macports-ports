--- processors/6502.c.sav	2007-11-29 08:56:32.000000000 -0500
+++ processors/6502.c	2007-11-29 08:58:43.000000000 -0500
@@ -28,39 +28,41 @@
 
 // enumerated addressing modes
 
-#define	OT_IMPLIED				0								// no operands
-#define	OT_IMMEDIATE			1								// #xx
-#define	OT_ZP					2								// xx
-#define	OT_ZP_OFF_X				3								// xx,X
-#define	OT_ZP_OFF_Y				4								// xx,Y
+#define	OT_IMPLIED		0								// no operands
+#define	OT_IMMEDIATE		1								// #xx
+#define	OT_ZP			2								// xx
+#define	OT_ZP_OFF_X		3								// xx,X
+#define	OT_ZP_OFF_Y		4								// xx,Y
 #define	OT_ZP_INDIRECT_OFF_X	5								// (xx,X)
 #define	OT_ZP_INDIRECT_OFF_Y	6								// (xx),Y
-#define	OT_ZP_INDIRECT			7								// (xx)
-#define	OT_EXTENDED				8								// xxxx
-#define	OT_EXTENDED_OFF_X		9								// xxxx,X
-#define	OT_EXTENDED_OFF_Y		10								// xxxx,Y
+#define	OT_ZP_INDIRECT		7								// (xx)
+#define	OT_EXTENDED		8								// xxxx
+#define	OT_EXTENDED_OFF_X	9								// xxxx,X
+#define	OT_EXTENDED_OFF_Y	10								// xxxx,Y
 #define	OT_EXTENDED_INDIRECT	11								// (xxxx)
-#define	OT_RELATIVE				12								// one byte relative offset
-#define	OT_IMPLIED_2			13								// two-byte implied opcode (second byte is ignored)
+#define	OT_RELATIVE		12								// one byte relative offset
+#define	OT_IMPLIED_2		13								// two-byte implied opcode (second byte is ignored)
+#define OT_ZP_RELATIVE		14								// xx, relative offset
 
-#define	OT_NUM					OT_IMPLIED_2+1					// number of addressing modes
+#define	OT_NUM					OT_ZP_RELATIVE+1					// number of addressing modes
 
 // masks for the various addressing modes
 
-#define	M_IMPLIED				(1<<OT_IMPLIED)
-#define	M_IMMEDIATE				(1<<OT_IMMEDIATE)
-#define	M_ZP					(1<<OT_ZP)
-#define	M_ZP_OFF_X				(1<<OT_ZP_OFF_X)
-#define	M_ZP_OFF_Y				(1<<OT_ZP_OFF_Y)
+#define	M_IMPLIED			(1<<OT_IMPLIED)
+#define	M_IMMEDIATE			(1<<OT_IMMEDIATE)
+#define	M_ZP				(1<<OT_ZP)
+#define	M_ZP_OFF_X			(1<<OT_ZP_OFF_X)
+#define	M_ZP_OFF_Y			(1<<OT_ZP_OFF_Y)
 #define	M_ZP_INDIRECT_OFF_X		(1<<OT_ZP_INDIRECT_OFF_X)
 #define	M_ZP_INDIRECT_OFF_Y		(1<<OT_ZP_INDIRECT_OFF_Y)
 #define	M_ZP_INDIRECT			(1<<OT_ZP_INDIRECT)
-#define	M_EXTENDED				(1<<OT_EXTENDED)
+#define	M_EXTENDED			(1<<OT_EXTENDED)
 #define	M_EXTENDED_OFF_X		(1<<OT_EXTENDED_OFF_X)
 #define	M_EXTENDED_OFF_Y		(1<<OT_EXTENDED_OFF_Y)
 #define	M_EXTENDED_INDIRECT		(1<<OT_EXTENDED_INDIRECT)
-#define	M_RELATIVE				(1<<OT_RELATIVE)
-#define	M_IMPLIED_2				(1<<OT_IMPLIED_2)
+#define	M_RELATIVE			(1<<OT_RELATIVE)
+#define	M_IMPLIED_2			(1<<OT_IMPLIED_2)
+#define M_ZP_RELATIVE			(1<<OT_ZP_RELATIVE)
 
 struct OPCODE
 {
@@ -94,141 +96,174 @@
 
 // This macro creates the typeFlags and baseOpcode list. For each non-white entry in the baseOpcode
 // list, a bit is set in typeFlags.
-#define OP_ENTRY(a,b,c,d,e,f,g,h,i,j,k,l,m,n) OP_FLAG(a,M_IMPLIED)|OP_FLAG(b,M_IMMEDIATE)|OP_FLAG(c,M_ZP)|OP_FLAG(d,M_ZP_OFF_X)|OP_FLAG(e,M_ZP_OFF_Y)|OP_FLAG(f,M_ZP_INDIRECT_OFF_X)|OP_FLAG(g,M_ZP_INDIRECT_OFF_Y)|OP_FLAG(h,M_ZP_INDIRECT)|OP_FLAG(i,M_EXTENDED)|OP_FLAG(j,M_EXTENDED_OFF_X)|OP_FLAG(k,M_EXTENDED_OFF_Y)|OP_FLAG(l,M_EXTENDED_INDIRECT)|OP_FLAG(m,M_RELATIVE)|OP_FLAG(n,M_IMPLIED_2),{OP_VAL(a),OP_VAL(b),OP_VAL(c),OP_VAL(d),OP_VAL(e),OP_VAL(f),OP_VAL(g),OP_VAL(h),OP_VAL(i),OP_VAL(j),OP_VAL(k),OP_VAL(l),OP_VAL(m),OP_VAL(n)}
+#define OP_ENTRY(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o) OP_FLAG(a,M_IMPLIED)|OP_FLAG(b,M_IMMEDIATE)|OP_FLAG(c,M_ZP)|OP_FLAG(d,M_ZP_OFF_X)|OP_FLAG(e,M_ZP_OFF_Y)|OP_FLAG(f,M_ZP_INDIRECT_OFF_X)|OP_FLAG(g,M_ZP_INDIRECT_OFF_Y)|OP_FLAG(h,M_ZP_INDIRECT)|OP_FLAG(i,M_EXTENDED)|OP_FLAG(j,M_EXTENDED_OFF_X)|OP_FLAG(k,M_EXTENDED_OFF_Y)|OP_FLAG(l,M_EXTENDED_INDIRECT)|OP_FLAG(m,M_RELATIVE)|OP_FLAG(n,M_IMPLIED_2)|OP_FLAG(o,M_ZP_RELATIVE),{OP_VAL(a),OP_VAL(b),OP_VAL(c),OP_VAL(d),OP_VAL(e),OP_VAL(f),OP_VAL(g),OP_VAL(h),OP_VAL(i),OP_VAL(j),OP_VAL(k),OP_VAL(l),OP_VAL(m),OP_VAL(n),OP_VAL(o)}
 
 static OPCODE
 	opcodes6502[]=
 	{
-//							 imp  imm  zp   zpx  zpy  indx indy (zp) ext  extx exty (ext) rel impl2
-		{"adc",		OP_ENTRY(    ,0x69,0x65,0x75,    ,0x61,0x71,    ,0x6D,0x7D,0x79,    ,    ,    )},
-		{"and",		OP_ENTRY(    ,0x29,0x25,0x35,    ,0x21,0x31,    ,0x2D,0x3D,0x39,    ,    ,    )},
-		{"asl",		OP_ENTRY(0x0A,    ,0x06,0x16,    ,    ,    ,    ,0x0E,0x1E,    ,    ,    ,    )},
-		{"bcc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x90,    )},
-		{"bcs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xB0,    )},
-		{"beq",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xF0,    )},
-		{"bit",		OP_ENTRY(    ,    ,0x24,    ,    ,    ,    ,    ,0x2C,    ,    ,    ,    ,    )},
-		{"bmi",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x30,    )},
-		{"bne",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xD0,    )},
-		{"bpl",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x10,    )},
-		{"brk",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x00)},
-		{"bvc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x50,    )},
-		{"bvs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x70,    )},
-		{"clc",		OP_ENTRY(0x18,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cld",		OP_ENTRY(0xD8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cli",		OP_ENTRY(0x58,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"clv",		OP_ENTRY(0xB8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cmp",		OP_ENTRY(    ,0xC9,0xC5,0xD5,    ,0xC1,0xD1,    ,0xCD,0xDD,0xD9,    ,    ,    )},
-		{"cpx",		OP_ENTRY(    ,0xE0,0xE4,    ,    ,    ,    ,    ,0xEC,    ,    ,    ,    ,    )},
-		{"cpy",		OP_ENTRY(    ,0xC0,0xC4,    ,    ,    ,    ,    ,0xCC,    ,    ,    ,    ,    )},
-		{"dec",		OP_ENTRY(    ,    ,0xC6,0xD6,    ,    ,    ,    ,0xCE,0xDE,    ,    ,    ,    )},
-		{"dex",		OP_ENTRY(0xCA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"dey",		OP_ENTRY(0x88,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"eor",		OP_ENTRY(    ,0x49,0x45,0x55,    ,0x41,0x51,    ,0x4D,0x5D,0x59,    ,    ,    )},
-		{"inc",		OP_ENTRY(    ,    ,0xE6,0xF6,    ,    ,    ,    ,0xEE,0xFE,    ,    ,    ,    )},
-		{"inx",		OP_ENTRY(0xE8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"iny",		OP_ENTRY(0xC8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"jmp",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x4C,    ,    ,0x6C,    ,    )},
-		{"jsr",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x20,    ,    ,    ,    ,    )},
-		{"lda",		OP_ENTRY(    ,0xA9,0xA5,0xB5,    ,0xA1,0xB1,    ,0xAD,0xBD,0xB9,    ,    ,    )},
-		{"ldx",		OP_ENTRY(    ,0xA2,0xA6,    ,0xB6,    ,    ,    ,0xAE,    ,0xBE,    ,    ,    )},
-		{"ldy",		OP_ENTRY(    ,0xA0,0xA4,0xB4,    ,    ,    ,    ,0xAC,0xBC,    ,    ,    ,    )},
-		{"lsr",		OP_ENTRY(0x4A,    ,0x46,0x56,    ,    ,    ,    ,0x4E,0x5E,    ,    ,    ,    )},
-		{"nop",		OP_ENTRY(0xEA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"ora",		OP_ENTRY(    ,0x09,0x05,0x15,    ,0x01,0x11,    ,0x0D,0x1D,0x19,    ,    ,    )},
-		{"pha",		OP_ENTRY(0x48,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"php",		OP_ENTRY(0x08,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"pla",		OP_ENTRY(0x68,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"plp",		OP_ENTRY(0x28,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"rol",		OP_ENTRY(0x2A,    ,0x26,0x36,    ,    ,    ,    ,0x2E,0x3E,    ,    ,    ,    )},
-		{"ror",		OP_ENTRY(0x6A,    ,0x66,0x76,    ,    ,    ,    ,0x6E,0x7E,    ,    ,    ,    )},
-		{"rti",		OP_ENTRY(0x40,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"rts",		OP_ENTRY(0x60,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sbc",		OP_ENTRY(    ,0xE9,0xE5,0xF5,    ,0xE1,0xF1,    ,0xED,0xFD,0xF9,    ,    ,    )},
-		{"sec",		OP_ENTRY(0x38,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sed",		OP_ENTRY(0xF8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sei",		OP_ENTRY(0x78,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sta",		OP_ENTRY(    ,    ,0x85,0x95,    ,0x81,0x91,    ,0x8D,0x9D,0x99,    ,    ,    )},
-		{"stx",		OP_ENTRY(    ,    ,0x86,    ,0x96,    ,    ,    ,0x8E,    ,    ,    ,    ,    )},
-		{"sty",		OP_ENTRY(    ,    ,0x84,0x94,    ,    ,    ,    ,0x8C,    ,    ,    ,    ,    )},
-		{"tax",		OP_ENTRY(0xAA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"tay",		OP_ENTRY(0xA8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"tsx",		OP_ENTRY(0xBA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"txa",		OP_ENTRY(0x8A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"txs",		OP_ENTRY(0x9A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"tya",		OP_ENTRY(0x98,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+//					 imp  imm  zp   zpx  zpy  indx indy (zp) ext  extx exty (ext) rel impl2 zpr
+		{"adc",		OP_ENTRY(    ,0x69,0x65,0x75,    ,0x61,0x71,    ,0x6D,0x7D,0x79,    ,    ,    ,    )},
+		{"and",		OP_ENTRY(    ,0x29,0x25,0x35,    ,0x21,0x31,    ,0x2D,0x3D,0x39,    ,    ,    ,    )},
+		{"asl",		OP_ENTRY(0x0A,    ,0x06,0x16,    ,    ,    ,    ,0x0E,0x1E,    ,    ,    ,    ,    )},
+		{"bcc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x90,    ,    )},
+		{"bcs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xB0,    ,    )},
+		{"beq",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xF0,    ,    )},
+		{"bit",		OP_ENTRY(    ,    ,0x24,    ,    ,    ,    ,    ,0x2C,    ,    ,    ,    ,    ,    )},
+		{"bmi",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x30,    ,    )},
+		{"bne",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xD0,    ,    )},
+		{"bpl",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x10,    ,    )},
+		{"brk",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x00,    )},
+		{"bvc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x50,    ,    )},
+		{"bvs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x70,    ,    )},
+		{"clc",		OP_ENTRY(0x18,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cld",		OP_ENTRY(0xD8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cli",		OP_ENTRY(0x58,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"clv",		OP_ENTRY(0xB8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cmp",		OP_ENTRY(    ,0xC9,0xC5,0xD5,    ,0xC1,0xD1,    ,0xCD,0xDD,0xD9,    ,    ,    ,    )},
+		{"cpx",		OP_ENTRY(    ,0xE0,0xE4,    ,    ,    ,    ,    ,0xEC,    ,    ,    ,    ,    ,    )},
+		{"cpy",		OP_ENTRY(    ,0xC0,0xC4,    ,    ,    ,    ,    ,0xCC,    ,    ,    ,    ,    ,    )},
+		{"dec",		OP_ENTRY(    ,    ,0xC6,0xD6,    ,    ,    ,    ,0xCE,0xDE,    ,    ,    ,    ,    )},
+		{"dex",		OP_ENTRY(0xCA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"dey",		OP_ENTRY(0x88,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"eor",		OP_ENTRY(    ,0x49,0x45,0x55,    ,0x41,0x51,    ,0x4D,0x5D,0x59,    ,    ,    ,    )},
+		{"inc",		OP_ENTRY(    ,    ,0xE6,0xF6,    ,    ,    ,    ,0xEE,0xFE,    ,    ,    ,    ,    )},
+		{"inx",		OP_ENTRY(0xE8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"iny",		OP_ENTRY(0xC8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"jmp",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x4C,    ,    ,0x6C,    ,    ,    )},
+		{"jsr",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x20,    ,    ,    ,    ,    ,    )},
+		{"lda",		OP_ENTRY(    ,0xA9,0xA5,0xB5,    ,0xA1,0xB1,    ,0xAD,0xBD,0xB9,    ,    ,    ,    )},
+		{"ldx",		OP_ENTRY(    ,0xA2,0xA6,    ,0xB6,    ,    ,    ,0xAE,    ,0xBE,    ,    ,    ,    )},
+		{"ldy",		OP_ENTRY(    ,0xA0,0xA4,0xB4,    ,    ,    ,    ,0xAC,0xBC,    ,    ,    ,    ,    )},
+		{"lsr",		OP_ENTRY(0x4A,    ,0x46,0x56,    ,    ,    ,    ,0x4E,0x5E,    ,    ,    ,    ,    )},
+		{"nop",		OP_ENTRY(0xEA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"ora",		OP_ENTRY(    ,0x09,0x05,0x15,    ,0x01,0x11,    ,0x0D,0x1D,0x19,    ,    ,    ,    )},
+		{"pha",		OP_ENTRY(0x48,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"php",		OP_ENTRY(0x08,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"pla",		OP_ENTRY(0x68,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"plp",		OP_ENTRY(0x28,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rol",		OP_ENTRY(0x2A,    ,0x26,0x36,    ,    ,    ,    ,0x2E,0x3E,    ,    ,    ,    ,    )},
+		{"ror",		OP_ENTRY(0x6A,    ,0x66,0x76,    ,    ,    ,    ,0x6E,0x7E,    ,    ,    ,    ,    )},
+		{"rti",		OP_ENTRY(0x40,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rts",		OP_ENTRY(0x60,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sbc",		OP_ENTRY(    ,0xE9,0xE5,0xF5,    ,0xE1,0xF1,    ,0xED,0xFD,0xF9,    ,    ,    ,    )},
+		{"sec",		OP_ENTRY(0x38,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sed",		OP_ENTRY(0xF8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sei",		OP_ENTRY(0x78,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sta",		OP_ENTRY(    ,    ,0x85,0x95,    ,0x81,0x91,    ,0x8D,0x9D,0x99,    ,    ,    ,    )},
+		{"stx",		OP_ENTRY(    ,    ,0x86,    ,0x96,    ,    ,    ,0x8E,    ,    ,    ,    ,    ,    )},
+		{"sty",		OP_ENTRY(    ,    ,0x84,0x94,    ,    ,    ,    ,0x8C,    ,    ,    ,    ,    ,    )},
+		{"tax",		OP_ENTRY(0xAA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"tay",		OP_ENTRY(0xA8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"tsx",		OP_ENTRY(0xBA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"txa",		OP_ENTRY(0x8A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"txs",		OP_ENTRY(0x9A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"tya",		OP_ENTRY(0x98,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
 	};
 
 // opcodes for the 65C02
 static OPCODE
 	opcodes65C02[]=
 	{
-//							 imp  imm  zp   zpx  zpy  indx indy (zp) ext  extx exty indw rel  impl2
-		{"adc",		OP_ENTRY(    ,0x69,0x65,0x75,    ,0x61,0x71,0x72,0x6D,0x7D,0x79,    ,    ,    )},
-		{"and",		OP_ENTRY(    ,0x29,0x25,0x35,    ,0x21,0x31,0x32,0x2D,0x3D,0x39,    ,    ,    )},
-		{"asl",		OP_ENTRY(0x0A,    ,0x06,0x16,    ,    ,    ,    ,0x0E,0x1E,    ,    ,    ,    )},
-		{"bcc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x90,    )},
-		{"bcs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xB0,    )},
-		{"beq",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xF0,    )},
-		{"bit",		OP_ENTRY(    ,0x89,0x24,0x34,    ,    ,    ,    ,0x2C,0x3C,    ,    ,    ,    )},
-		{"bmi",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x30,    )},
-		{"bne",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xD0,    )},
-		{"bpl",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x10,    )},
-		{"bra",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x80,    )},
-		{"brk",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x00)},
-		{"bvc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x50,    )},
-		{"bvs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x70,    )},
-		{"clc",		OP_ENTRY(0x18,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cld",		OP_ENTRY(0xD8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cli",		OP_ENTRY(0x58,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"clv",		OP_ENTRY(0xB8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"cmp",		OP_ENTRY(    ,0xC9,0xC5,0xD5,    ,0xC1,0xD1,0xD2,0xCD,0xDD,0xD9,    ,    ,    )},
-		{"cpx",		OP_ENTRY(    ,0xE0,0xE4,    ,    ,    ,    ,    ,0xEC,    ,    ,    ,    ,    )},
-		{"cpy",		OP_ENTRY(    ,0xC0,0xC4,    ,    ,    ,    ,    ,0xCC,    ,    ,    ,    ,    )},
-		{"dea",		OP_ENTRY(0x3A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"dec",		OP_ENTRY(    ,    ,0xC6,0xD6,    ,    ,    ,    ,0xCE,0xDE,    ,    ,    ,    )},
-		{"dex",		OP_ENTRY(0xCA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"dey",		OP_ENTRY(0x88,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"eor",		OP_ENTRY(    ,0x49,0x45,0x55,    ,0x41,0x51,0x52,0x4D,0x5D,0x59,    ,    ,    )},
-		{"ina",		OP_ENTRY(0x1A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"inc",		OP_ENTRY(    ,    ,0xE6,0xF6,    ,    ,    ,    ,0xEE,0xFE,    ,    ,    ,    )},
-		{"inx",		OP_ENTRY(0xE8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"iny",		OP_ENTRY(0xC8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"jmp",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x4C,0x7C,    ,0x6C,    ,    )},
-		{"jsr",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x20,    ,    ,    ,    ,    )},
-		{"lda",		OP_ENTRY(    ,0xA9,0xA5,0xB5,    ,0xA1,0xB1,0xB2,0xAD,0xBD,0xB9,    ,    ,    )},
-		{"ldx",		OP_ENTRY(    ,0xA2,0xA6,    ,0xB6,    ,    ,    ,0xAE,    ,0xBE,    ,    ,    )},
-		{"ldy",		OP_ENTRY(    ,0xA0,0xA4,0xB4,    ,    ,    ,    ,0xAC,0xBC,    ,    ,    ,    )},
-		{"lsr",		OP_ENTRY(0x4A,    ,0x46,0x56,    ,    ,    ,    ,0x4E,0x5E,    ,    ,    ,    )},
-		{"nop",		OP_ENTRY(0xEA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"ora",		OP_ENTRY(    ,0x09,0x05,0x15,    ,0x01,0x11,0x12,0x0D,0x1D,0x19,    ,    ,    )},
-		{"pha",		OP_ENTRY(0x48,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"php",		OP_ENTRY(0x08,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"phx",		OP_ENTRY(0xDA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"phy",		OP_ENTRY(0x5A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"pla",		OP_ENTRY(0x68,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"plp",		OP_ENTRY(0x28,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"plx",		OP_ENTRY(0xFA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"ply",		OP_ENTRY(0x7A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"rol",		OP_ENTRY(0x2A,    ,0x26,0x36,    ,    ,    ,    ,0x2E,0x3E,    ,    ,    ,    )},
-		{"ror",		OP_ENTRY(0x6A,    ,0x66,0x76,    ,    ,    ,    ,0x6E,0x7E,    ,    ,    ,    )},
-		{"rti",		OP_ENTRY(0x40,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"rts",		OP_ENTRY(0x60,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sbc",		OP_ENTRY(    ,0xE9,0xE5,0xF5,    ,0xE1,0xF1,0xF2,0xED,0xFD,0xF9,    ,    ,    )},
-		{"sec",		OP_ENTRY(0x38,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sed",		OP_ENTRY(0xF8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sei",		OP_ENTRY(0x78,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"sta",		OP_ENTRY(    ,    ,0x85,0x95,    ,0x81,0x91,0x92,0x8D,0x9D,0x99,    ,    ,    )},
-		{"stx",		OP_ENTRY(    ,    ,0x86,    ,0x96,    ,    ,    ,0x8E,    ,    ,    ,    ,    )},
-		{"sty",		OP_ENTRY(    ,    ,0x84,0x94,    ,    ,    ,    ,0x8C,    ,    ,    ,    ,    )},
-		{"stz",		OP_ENTRY(    ,    ,0x64,0x74,    ,    ,    ,    ,0x9C,0x9E,    ,    ,    ,    )},
-		{"tax",		OP_ENTRY(0xAA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"tay",		OP_ENTRY(0xA8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"trb",		OP_ENTRY(    ,    ,0x14,    ,    ,    ,    ,    ,0x1C,    ,    ,    ,    ,    )},
-		{"tsb",		OP_ENTRY(    ,    ,0x04,    ,    ,    ,    ,    ,0x0C,    ,    ,    ,    ,    )},
-		{"tsx",		OP_ENTRY(0xBA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"txa",		OP_ENTRY(0x8A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"txs",		OP_ENTRY(0x9A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
-		{"tya",		OP_ENTRY(0x98,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+//					 imp  imm  zp   zpx  zpy  indx indy (zp) ext  extx exty indw rel  impl2 zpr
+		{"adc",		OP_ENTRY(    ,0x69,0x65,0x75,    ,0x61,0x71,0x72,0x6D,0x7D,0x79,    ,    ,    ,    )},
+		{"and",		OP_ENTRY(    ,0x29,0x25,0x35,    ,0x21,0x31,0x32,0x2D,0x3D,0x39,    ,    ,    ,    )},
+		{"asl",		OP_ENTRY(0x0A,    ,0x06,0x16,    ,    ,    ,    ,0x0E,0x1E,    ,    ,    ,    ,    )},
+		{"bbr0",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x0f)},
+		{"bbr1",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x1f)},
+		{"bbr2",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x2f)},
+		{"bbr3",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x3f)},
+		{"bbr4",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x4f)},
+		{"bbr5",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x5f)},
+		{"bbr6",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x6f)},
+		{"bbr7",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x7f)},
+		{"bbs0",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x8f)},
+		{"bbs1",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x9f)},
+		{"bbs2",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xaf)},
+		{"bbs3",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xbf)},
+		{"bbs4",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xcf)},
+		{"bbs5",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xdf)},
+		{"bbs6",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xef)},
+		{"bbs7",	OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xff)},
+		{"bcc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x90,    ,    )},
+		{"bcs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xB0,    ,    )},
+		{"beq",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xF0,    ,    )},
+		{"bit",		OP_ENTRY(    ,0x89,0x24,0x34,    ,    ,    ,    ,0x2C,0x3C,    ,    ,    ,    ,    )},
+		{"bmi",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x30,    ,    )},
+		{"bne",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0xD0,    ,    )},
+		{"bpl",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x10,    ,    )},
+		{"bra",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x80,    ,    )},
+		{"brk",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x00,    )},
+		{"bvc",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x50,    ,    )},
+		{"bvs",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,0x70,    ,    )},
+		{"clc",		OP_ENTRY(0x18,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cld",		OP_ENTRY(0xD8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cli",		OP_ENTRY(0x58,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"clv",		OP_ENTRY(0xB8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"cmp",		OP_ENTRY(    ,0xC9,0xC5,0xD5,    ,0xC1,0xD1,0xD2,0xCD,0xDD,0xD9,    ,    ,    ,    )},
+		{"cpx",		OP_ENTRY(    ,0xE0,0xE4,    ,    ,    ,    ,    ,0xEC,    ,    ,    ,    ,    ,    )},
+		{"cpy",		OP_ENTRY(    ,0xC0,0xC4,    ,    ,    ,    ,    ,0xCC,    ,    ,    ,    ,    ,    )},
+		{"dea",		OP_ENTRY(0x3A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"dec",		OP_ENTRY(    ,    ,0xC6,0xD6,    ,    ,    ,    ,0xCE,0xDE,    ,    ,    ,    ,    )},
+		{"dex",		OP_ENTRY(0xCA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"dey",		OP_ENTRY(0x88,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"eor",		OP_ENTRY(    ,0x49,0x45,0x55,    ,0x41,0x51,0x52,0x4D,0x5D,0x59,    ,    ,    ,    )},
+		{"ina",		OP_ENTRY(0x1A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"inc",		OP_ENTRY(    ,    ,0xE6,0xF6,    ,    ,    ,    ,0xEE,0xFE,    ,    ,    ,    ,    )},
+		{"inx",		OP_ENTRY(0xE8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"iny",		OP_ENTRY(0xC8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"jmp",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x4C,0x7C,    ,0x6C,    ,    ,    )},
+		{"jsr",		OP_ENTRY(    ,    ,    ,    ,    ,    ,    ,    ,0x20,    ,    ,    ,    ,    ,    )},
+		{"lda",		OP_ENTRY(    ,0xA9,0xA5,0xB5,    ,0xA1,0xB1,0xB2,0xAD,0xBD,0xB9,    ,    ,    ,    )},
+		{"ldx",		OP_ENTRY(    ,0xA2,0xA6,    ,0xB6,    ,    ,    ,0xAE,    ,0xBE,    ,    ,    ,    )},
+		{"ldy",		OP_ENTRY(    ,0xA0,0xA4,0xB4,    ,    ,    ,    ,0xAC,0xBC,    ,    ,    ,    ,    )},
+		{"lsr",		OP_ENTRY(0x4A,    ,0x46,0x56,    ,    ,    ,    ,0x4E,0x5E,    ,    ,    ,    ,    )},
+		{"nop",		OP_ENTRY(0xEA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"ora",		OP_ENTRY(    ,0x09,0x05,0x15,    ,0x01,0x11,0x12,0x0D,0x1D,0x19,    ,    ,    ,    )},
+		{"pha",		OP_ENTRY(0x48,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"php",		OP_ENTRY(0x08,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"phx",		OP_ENTRY(0xDA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"phy",		OP_ENTRY(0x5A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"pla",		OP_ENTRY(0x68,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"plp",		OP_ENTRY(0x28,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"plx",		OP_ENTRY(0xFA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"ply",		OP_ENTRY(0x7A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb0",	OP_ENTRY(    ,    ,0x07,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb1",	OP_ENTRY(    ,    ,0x17,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb2",	OP_ENTRY(    ,    ,0x27,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb3",	OP_ENTRY(    ,    ,0x37,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb4",	OP_ENTRY(    ,    ,0x47,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb5",	OP_ENTRY(    ,    ,0x57,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb6",	OP_ENTRY(    ,    ,0x67,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rmb7",	OP_ENTRY(    ,    ,0x77,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rol",		OP_ENTRY(0x2A,    ,0x26,0x36,    ,    ,    ,    ,0x2E,0x3E,    ,    ,    ,    ,    )},
+		{"ror",		OP_ENTRY(0x6A,    ,0x66,0x76,    ,    ,    ,    ,0x6E,0x7E,    ,    ,    ,    ,    )},
+		{"rti",		OP_ENTRY(0x40,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"rts",		OP_ENTRY(0x60,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sbc",		OP_ENTRY(    ,0xE9,0xE5,0xF5,    ,0xE1,0xF1,0xF2,0xED,0xFD,0xF9,    ,    ,    ,    )},
+		{"sec",		OP_ENTRY(0x38,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sed",		OP_ENTRY(0xF8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sei",		OP_ENTRY(0x78,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb0",	OP_ENTRY(    ,    ,0x87,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb1",	OP_ENTRY(    ,    ,0x97,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb2",	OP_ENTRY(    ,    ,0xa7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb3",	OP_ENTRY(    ,    ,0xb7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb4",	OP_ENTRY(    ,    ,0xc7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb5",	OP_ENTRY(    ,    ,0xd7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb6",	OP_ENTRY(    ,    ,0xe7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"smb7",	OP_ENTRY(    ,    ,0xf7,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"sta",		OP_ENTRY(    ,    ,0x85,0x95,    ,0x81,0x91,0x92,0x8D,0x9D,0x99,    ,    ,    ,    )},
+		{"stx",		OP_ENTRY(    ,    ,0x86,    ,0x96,    ,    ,    ,0x8E,    ,    ,    ,    ,    ,    )},
+		{"sty",		OP_ENTRY(    ,    ,0x84,0x94,    ,    ,    ,    ,0x8C,    ,    ,    ,    ,    ,    )},
+		{"stz",		OP_ENTRY(    ,    ,0x64,0x74,    ,    ,    ,    ,0x9C,0x9E,    ,    ,    ,    ,    )},
+		{"tax",		OP_ENTRY(0xAA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"tay",		OP_ENTRY(0xA8,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"trb",		OP_ENTRY(    ,    ,0x14,    ,    ,    ,    ,    ,0x1C,    ,    ,    ,    ,    ,    )},
+		{"tsb",		OP_ENTRY(    ,    ,0x04,    ,    ,    ,    ,    ,0x0C,    ,    ,    ,    ,    ,    )},
+		{"tsx",		OP_ENTRY(0xBA,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"txa",		OP_ENTRY(0x8A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"txs",		OP_ENTRY(0x9A,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"tya",		OP_ENTRY(0x98,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
+		{"wai",		OP_ENTRY(0xCB,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    ,    )},
 
 // bbr, bbs, rmb, smb should be added some day
 //	BBR	#n,zp,addr	branch to addr if bit n of location zp is clear
@@ -236,7 +271,7 @@
 //	RMB	#n,zp		clear bit n of location zp
 //	SMB	#n,zp		set bit n of location zp
 
-//These might be written differently in some assemblers (n=0..7):
+//These might be written differently in some assemblers (n=0..7):`
 
 //	BBRn	zp,addr
 //	BBSn	zp,addr
@@ -291,15 +326,16 @@
 enum
 {
 	POT_IMMEDIATE,
-	POT_VALUE,					// extended, zero page, or relative	xxxx or xx
-	POT_VALUE_OFF_X,			// extended, or zero page			xxxx,X or xx,X
-	POT_VALUE_OFF_Y,			// extended							xxxx,Y
-	POT_INDIRECT,				// extended or zero page			(xxxx) or (xx)
-	POT_ZP_INDIRECT_OFF_X,		// zero page						(xx,X)
-	POT_ZP_INDIRECT_OFF_Y,		// zero page						(xx),Y
+	POT_VALUE,			// extended, zero page, or relative	xxxx or xx
+	POT_VALUE_OFF_X,		// extended, or zero page		xxxx,X or xx,X
+	POT_VALUE_OFF_Y,		// extended				xxxx,Y
+	POT_INDIRECT,			// extended or zero page		(xxxx) or (xx)
+	POT_ZP_INDIRECT_OFF_X,		// zero page				(xx,X)
+	POT_ZP_INDIRECT_OFF_Y,		// zero page				(xx),Y
+	POT_ZP_RELATIVE,		// zero page, relative offset		xx, xx
 };
 
-static bool ParseValueOperand(const char *line,unsigned int *lineIndex,unsigned int *type,int *value,bool *unresolved)
+static bool ParseValueOperand(const char *line,unsigned int *lineIndex,unsigned int *type,int *value,int *value2, bool *unresolved, bool *unresolved2)
 // parse the operand as a value with a possible offset
 {
 	if(ParseExpression(line,lineIndex,value,unresolved))
@@ -327,6 +363,14 @@
 					return(true);
 				}
 			}
+			else if (ParseExpression(line, lineIndex, value2, unresolved2))
+			{
+				if (ParseComment(line, lineIndex))
+				{
+					*type=POT_ZP_RELATIVE;
+					return(true);
+				}
+			}
 		}
 	}
 	return(false);
@@ -368,7 +412,7 @@
 	return(false);
 }
 
-static bool ParseOperand(const char *line,unsigned int *lineIndex,unsigned int *type,int *value,bool *unresolved)
+static bool ParseOperand(const char *line,unsigned int *lineIndex,unsigned int *type,int *value,int *value2, bool *unresolved, bool *unresolved2)
 // Try to parse an operand and determine its type
 // return true if the parsing succeeds
 {
@@ -414,12 +458,12 @@
 			else
 			{
 				*lineIndex=startIndex;					// value does not look indirect, so try direct approach
-				return(ParseValueOperand(line,lineIndex,type,value,unresolved));
+				return(ParseValueOperand(line,lineIndex,type,value,value2,unresolved,unresolved2));
 			}
 		}
 		else
 		{
-			return(ParseValueOperand(line,lineIndex,type,value,unresolved));
+			return(ParseValueOperand(line,lineIndex,type,value,value2,unresolved,unresolved2));
 		}
 	}
 	return(false);
@@ -883,6 +927,44 @@
 	return(!fail);
 }
 
+static bool HandleZeroPageRelative(OPCODE *opcode,int value,int value2, bool unresolved,bool unresolved2,LISTING_RECORD *listingRecord)
+// deal with zero page relative mode output only
+{
+	bool
+		fail;
+	unsigned int
+		offset;
+
+	fail=false;
+	if(opcode->typeMask&M_ZP_RELATIVE)
+	{
+		CheckUnsignedByteRange(value,true,true);
+		if(GenerateByte(opcode->baseOpcode[OT_ZP_RELATIVE],listingRecord))
+		{
+			fail=!GenerateByte(value,listingRecord);
+			offset=0;
+			
+			if(!unresolved2&&currentSegment)
+			{
+				offset=value2-(currentSegment->currentPC+currentSegment->codeGenOffset)-1;
+				Check8RelativeRange(offset,true,true);
+			}
+			fail=!GenerateByte(offset,listingRecord);
+		}
+		else
+		{
+			fail=true;
+		}
+
+	}
+	else
+	{
+		ReportBadOperands();
+	}
+	return(!fail);
+}
+
+
 static OPCODE *MatchOpcode(const char *string)
 // match opcodes for this processor, return NULL if none matched
 {
@@ -909,9 +991,9 @@
 	unsigned int
 		elementType;
 	int
-		value;
+		value, value2;
 	bool
-		unresolved;
+		unresolved, unresolved2;
 
 	result=true;					// no hard failure yet
 	*success=false;					// no match yet
@@ -924,7 +1006,7 @@
 			*success=true;
 			if(!ParseComment(line,lineIndex))
 			{
-				if(ParseOperand(line,lineIndex,&elementType,&value,&unresolved))
+				if(ParseOperand(line,lineIndex,&elementType,&value,&value2,&unresolved,&unresolved2))
 				{
 					switch(elementType)
 					{
@@ -949,6 +1031,9 @@
 						case POT_ZP_INDIRECT_OFF_Y:
 							result=HandleIndirectOffY(opcode,value,unresolved,listingRecord);
 							break;
+					        case POT_ZP_RELATIVE:
+						        result=HandleZeroPageRelative(opcode,value,value2,unresolved,unresolved2,listingRecord);
+						        break;
 					}
 				}
 				else
