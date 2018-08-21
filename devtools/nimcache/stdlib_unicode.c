/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:
   gcc -c  -w  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/devtools/nimcache/stdlib_unicode.o /home/user/Dropbox/projects/nim/stui/devtools/nimcache/stdlib_unicode.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#undef LANGUAGE_C
#undef MIPSEB
#undef MIPSEL
#undef PPC
#undef R3000
#undef R4000
#undef i386
#undef linux
#undef mips
#undef near
#undef powerpc
#undef unix
typedef struct NimStringDesc NimStringDesc;
typedef struct TGenericSeq TGenericSeq;
typedef struct tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA;
typedef struct tySequence_48JTohSgTy339bRxHzUD8KA tySequence_48JTohSgTy339bRxHzUD8KA;
typedef struct TNimType TNimType;
typedef struct TNimNode TNimNode;
struct TGenericSeq {
NI len;
NI reserved;
};
struct NimStringDesc {
  TGenericSeq Sup;
NIM_CHAR data[SEQ_DECL_SIZE];
};
struct tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA {
NI a;
NI b;
};
typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;
typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;
typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);
typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);
struct TNimType {
NI size;
tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;
tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;
TNimType* base;
TNimNode* node;
void* finalizer;
tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;
tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;
};
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;
struct TNimNode {
tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;
NI offset;
TNimType* typ;
NCSTRING name;
NI len;
TNimNode** sons;
};
struct tySequence_48JTohSgTy339bRxHzUD8KA {
  TGenericSeq Sup;
  NI32 data[SEQ_DECL_SIZE];
};
static N_INLINE(NimStringDesc*, X5BX5D__xiaaX9b4cczHG39bivOynT9bgunicode)(NimStringDesc* s, tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA x);
static N_INLINE(NI, subInt)(NI a, NI b);
N_NOINLINE(void, raiseOverflow)(void);
static N_INLINE(NI, addInt)(NI a, NI b);
N_NIMCALL(NimStringDesc*, mnewString)(NI len);
N_NIMCALL(NimStringDesc*, mnewString)(NI len);
static N_INLINE(NI, chckRange)(NI i, NI a, NI b);
N_NOINLINE(void, raiseRangeError)(NI64 val);
N_NOINLINE(void, raiseIndexError)(void);
static N_INLINE(void, nimFrame)(TFrame* s);
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
static N_INLINE(void, popFrame)(void);
static N_INLINE(NimStringDesc*, X5BX5D__lkBUIkH7j2jb0vaXPf2frAunicode)(NimStringDesc* s, tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA x);
N_LIB_PRIVATE N_NIMCALL(tySequence_48JTohSgTy339bRxHzUD8KA*, newSeq_eYYHkXwVzOzgg15yEr5XtA)(NI len);
extern TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
TNimType NTI_sVg18TP9cLifHyygRe9cro9aA_;

static N_INLINE(NI, subInt)(NI a, NI b) {
	NI result;
{	result = (NI)0;
	result = (NI)((NU64)(a) - (NU64)(b));
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (((NI) 0) <= (NI)(result ^ a));
		if (T3_) goto LA4_;
		T3_ = (((NI) 0) <= (NI)(result ^ (NI)((NU64) ~(b))));
		LA4_: ;
		if (!T3_) goto LA5_;
		goto BeforeRet_;
	}
	LA5_: ;
	raiseOverflow();
	}BeforeRet_: ;
	return result;
}

static N_INLINE(NI, addInt)(NI a, NI b) {
	NI result;
{	result = (NI)0;
	result = (NI)((NU64)(a) + (NU64)(b));
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (((NI) 0) <= (NI)(result ^ a));
		if (T3_) goto LA4_;
		T3_ = (((NI) 0) <= (NI)(result ^ b));
		LA4_: ;
		if (!T3_) goto LA5_;
		goto BeforeRet_;
	}
	LA5_: ;
	raiseOverflow();
	}BeforeRet_: ;
	return result;
}

static N_INLINE(NI, chckRange)(NI i, NI a, NI b) {
	NI result;
{	result = (NI)0;
	{
		NIM_BOOL T3_;
		T3_ = (NIM_BOOL)0;
		T3_ = (a <= i);
		if (!(T3_)) goto LA4_;
		T3_ = (i <= b);
		LA4_: ;
		if (!T3_) goto LA5_;
		result = i;
		goto BeforeRet_;
	}
	goto LA1_;
	LA5_: ;
	{
		raiseRangeError(((NI64) (i)));
	}
	LA1_: ;
	}BeforeRet_: ;
	return result;
}

static N_INLINE(void, nimFrame)(TFrame* s) {
	NI T1_;
	T1_ = (NI)0;
	{
		if (!(framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw == NIM_NIL)) goto LA4_;
		T1_ = ((NI) 0);
	}
	goto LA2_;
	LA4_: ;
	{
		T1_ = ((NI) ((NI16)((*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).calldepth + ((NI16) 1))));
	}
	LA2_: ;
	(*s).calldepth = ((NI16) (T1_));
	(*s).prev = framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = s;
	{
		if (!((*s).calldepth == ((NI16) 2000))) goto LA9_;
		stackOverflow_II46IjNZztN9bmbxUD8dt8g();
	}
	LA9_: ;
}

static N_INLINE(void, popFrame)(void) {
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = (*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).prev;
}

static N_INLINE(NimStringDesc*, X5BX5D__xiaaX9b4cczHG39bivOynT9bgunicode)(NimStringDesc* s, tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA x) {
	NimStringDesc* result;
	NI a;
	NI L;
	NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_2;
	NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_3;
	nimfr_("[]", "system.nim");
	result = (NimStringDesc*)0;
	nimln_(3556, "system.nim");
	a = x.a;
	nimln_(3557, "system.nim");
	nimln_(3546, "system.nim");
	TM_e1RUVS0Bw7xmj9cnDPXLJMQ_2 = subInt(x.b, a);
	TM_e1RUVS0Bw7xmj9cnDPXLJMQ_3 = addInt((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_2), ((NI) 1));
	L = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_3);
	nimln_(3558, "system.nim");
	result = mnewString(((NI)chckRange(L, ((NI) 0), ((NI) IL64(9223372036854775807)))));
	{
		NI i;
		NI i_2;
		i = (NI)0;
		nimln_(3519, "system.nim");
		i_2 = ((NI) 0);
		{
			nimln_(3520, "system.nim");
			while (1) {
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_4;
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_5;
				if (!(i_2 < L)) goto LA3;
				nimln_(3521, "system.nim");
				i = i_2;
				if ((NU)(i) > (NU)(result->Sup.len)) raiseIndexError();
				nimln_(3559, "system.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_4 = addInt(i, a);
				if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_4)) > (NU)(s->Sup.len)) raiseIndexError();
				result->data[i] = s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_4)];
				nimln_(3522, "system.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_5 = addInt(i_2, ((NI) 1));
				i_2 = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_5);
			} LA3: ;
		}
	}
	popFrame();
	return result;
}

static N_INLINE(NimStringDesc*, X5BX5D__lkBUIkH7j2jb0vaXPf2frAunicode)(NimStringDesc* s, tyObject_HSlice_x7qpDivRIi6zcMSMsudNPA x) {
	NimStringDesc* result;
	NI a;
	NI L;
	NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_6;
	NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_7;
	NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_8;
	nimfr_("[]", "system.nim");
	result = (NimStringDesc*)0;
	nimln_(3556, "system.nim");
	a = x.a;
	nimln_(3557, "system.nim");
	nimln_(3546, "system.nim");
	nimln_(3557, "system.nim");
	TM_e1RUVS0Bw7xmj9cnDPXLJMQ_6 = subInt((s ? s->Sup.len : 0), x.b);
	TM_e1RUVS0Bw7xmj9cnDPXLJMQ_7 = subInt((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_6), a);
	TM_e1RUVS0Bw7xmj9cnDPXLJMQ_8 = addInt((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_7), ((NI) 1));
	L = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_8);
	nimln_(3558, "system.nim");
	result = mnewString(((NI)chckRange(L, ((NI) 0), ((NI) IL64(9223372036854775807)))));
	{
		NI i;
		NI i_2;
		i = (NI)0;
		nimln_(3519, "system.nim");
		i_2 = ((NI) 0);
		{
			nimln_(3520, "system.nim");
			while (1) {
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_9;
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_10;
				if (!(i_2 < L)) goto LA3;
				nimln_(3521, "system.nim");
				i = i_2;
				if ((NU)(i) > (NU)(result->Sup.len)) raiseIndexError();
				nimln_(3559, "system.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_9 = addInt(i, a);
				if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_9)) > (NU)(s->Sup.len)) raiseIndexError();
				result->data[i] = s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_9)];
				nimln_(3522, "system.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_10 = addInt(i_2, ((NI) 1));
				i_2 = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_10);
			} LA3: ;
		}
	}
	popFrame();
	return result;
}

N_LIB_PRIVATE N_NIMCALL(NI, validateUtf8_Vhh4YDLBdQSeOA7s2z9bA7A)(NimStringDesc* s) {
	NI result;
	NI i;
	NI L;
	nimfr_("validateUtf8", "unicode.nim");
{	result = (NI)0;
	nimln_(133, "unicode.nim");
	i = ((NI) 0);
	nimln_(134, "unicode.nim");
	L = (s ? s->Sup.len : 0);
	{
		nimln_(135, "unicode.nim");
		while (1) {
			if (!(i < L)) goto LA2;
			nimln_(136, "unicode.nim");
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_11;
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NU64)(((NU8)(s->data[i]))) <= (NU64)(((NI) 127)))) goto LA5_;
				nimln_(137, "unicode.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_11 = addInt(i, ((NI) 1));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_11);
			}
			goto LA3_;
			LA5_: ;
			{
				nimln_(138, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 5))) == ((NI) 6))) goto LA8_;
				nimln_(139, "unicode.nim");
				{
					if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
					if (!(((NU8)(s->data[i])) < ((NI) 194))) goto LA12_;
					result = i;
					goto BeforeRet_;
				}
				LA12_: ;
				nimln_(140, "unicode.nim");
				{
					NIM_BOOL T16_;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_12;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_13;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_14;
					T16_ = (NIM_BOOL)0;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_12 = addInt(i, ((NI) 1));
					T16_ = ((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_12) < L);
					if (!(T16_)) goto LA17_;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_13 = addInt(i, ((NI) 1));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_13)) > (NU)(s->Sup.len)) raiseIndexError();
					T16_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_13)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA17_: ;
					if (!T16_) goto LA18_;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_14 = addInt(i, ((NI) 2));
					i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_14);
				}
				goto LA14_;
				LA18_: ;
				{
					nimln_(141, "unicode.nim");
					result = i;
					goto BeforeRet_;
				}
				LA14_: ;
			}
			goto LA3_;
			LA8_: ;
			{
				nimln_(142, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 4))) == ((NI) 14))) goto LA22_;
				nimln_(143, "unicode.nim");
				{
					NIM_BOOL T26_;
					NIM_BOOL T27_;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_15;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_16;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_17;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_18;
					T26_ = (NIM_BOOL)0;
					T27_ = (NIM_BOOL)0;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_15 = addInt(i, ((NI) 2));
					T27_ = ((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_15) < L);
					if (!(T27_)) goto LA28_;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_16 = addInt(i, ((NI) 1));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_16)) > (NU)(s->Sup.len)) raiseIndexError();
					T27_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_16)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA28_: ;
					T26_ = T27_;
					if (!(T26_)) goto LA29_;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_17 = addInt(i, ((NI) 2));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_17)) > (NU)(s->Sup.len)) raiseIndexError();
					T26_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_17)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA29_: ;
					if (!T26_) goto LA30_;
					nimln_(144, "unicode.nim");
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_18 = addInt(i, ((NI) 3));
					i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_18);
				}
				goto LA24_;
				LA30_: ;
				{
					nimln_(145, "unicode.nim");
					result = i;
					goto BeforeRet_;
				}
				LA24_: ;
			}
			goto LA3_;
			LA22_: ;
			{
				nimln_(146, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 3))) == ((NI) 30))) goto LA34_;
				nimln_(147, "unicode.nim");
				{
					NIM_BOOL T38_;
					NIM_BOOL T39_;
					NIM_BOOL T40_;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_19;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_20;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_21;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_22;
					NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_23;
					T38_ = (NIM_BOOL)0;
					T39_ = (NIM_BOOL)0;
					T40_ = (NIM_BOOL)0;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_19 = addInt(i, ((NI) 3));
					T40_ = ((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_19) < L);
					if (!(T40_)) goto LA41_;
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_20 = addInt(i, ((NI) 1));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_20)) > (NU)(s->Sup.len)) raiseIndexError();
					T40_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_20)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA41_: ;
					T39_ = T40_;
					if (!(T39_)) goto LA42_;
					nimln_(148, "unicode.nim");
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_21 = addInt(i, ((NI) 2));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_21)) > (NU)(s->Sup.len)) raiseIndexError();
					T39_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_21)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA42_: ;
					T38_ = T39_;
					if (!(T38_)) goto LA43_;
					nimln_(149, "unicode.nim");
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_22 = addInt(i, ((NI) 3));
					if ((NU)((NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_22)) > (NU)(s->Sup.len)) raiseIndexError();
					T38_ = ((NI)((NU64)(((NU8)(s->data[(NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_22)]))) >> (NU64)(((NI) 6))) == ((NI) 2));
					LA43_: ;
					if (!T38_) goto LA44_;
					nimln_(150, "unicode.nim");
					TM_e1RUVS0Bw7xmj9cnDPXLJMQ_23 = addInt(i, ((NI) 4));
					i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_23);
				}
				goto LA36_;
				LA44_: ;
				{
					nimln_(151, "unicode.nim");
					result = i;
					goto BeforeRet_;
				}
				LA36_: ;
			}
			goto LA3_;
			LA34_: ;
			{
				nimln_(153, "unicode.nim");
				result = i;
				goto BeforeRet_;
			}
			LA3_: ;
		} LA2: ;
	}
	nimln_(154, "unicode.nim");
	result = ((NI) -1);
	goto BeforeRet_;
	}BeforeRet_: ;
	popFrame();
	return result;
}

N_LIB_PRIVATE N_NIMCALL(NI, nucruneLen)(NimStringDesc* s) {
	NI result;
	NI i;
	nimfr_("runeLen", "unicode.nim");
	result = (NI)0;
	nimln_(31, "unicode.nim");
	i = ((NI) 0);
	{
		nimln_(32, "unicode.nim");
		while (1) {
			NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_31;
			if (!(i < (s ? s->Sup.len : 0))) goto LA2;
			nimln_(33, "unicode.nim");
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_24;
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NU64)(((NU8)(s->data[i]))) <= (NU64)(((NI) 127)))) goto LA5_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_24 = addInt(i, ((NI) 1));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_24);
			}
			goto LA3_;
			LA5_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_25;
				nimln_(34, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 5))) == ((NI) 6))) goto LA8_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_25 = addInt(i, ((NI) 2));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_25);
			}
			goto LA3_;
			LA8_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_26;
				nimln_(35, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 4))) == ((NI) 14))) goto LA11_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_26 = addInt(i, ((NI) 3));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_26);
			}
			goto LA3_;
			LA11_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_27;
				nimln_(36, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 3))) == ((NI) 30))) goto LA14_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_27 = addInt(i, ((NI) 4));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_27);
			}
			goto LA3_;
			LA14_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_28;
				nimln_(37, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 2))) == ((NI) 62))) goto LA17_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_28 = addInt(i, ((NI) 5));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_28);
			}
			goto LA3_;
			LA17_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_29;
				nimln_(38, "unicode.nim");
				if ((NU)(i) > (NU)(s->Sup.len)) raiseIndexError();
				if (!((NI)((NU64)(((NU8)(s->data[i]))) >> (NU64)(((NI) 1))) == ((NI) 126))) goto LA20_;
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_29 = addInt(i, ((NI) 6));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_29);
			}
			goto LA3_;
			LA20_: ;
			{
				NI TM_e1RUVS0Bw7xmj9cnDPXLJMQ_30;
				nimln_(39, "unicode.nim");
				TM_e1RUVS0Bw7xmj9cnDPXLJMQ_30 = addInt(i, ((NI) 1));
				i = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_30);
			}
			LA3_: ;
			nimln_(40, "unicode.nim");
			TM_e1RUVS0Bw7xmj9cnDPXLJMQ_31 = addInt(result, ((NI) 1));
			result = (NI)(TM_e1RUVS0Bw7xmj9cnDPXLJMQ_31);
		} LA2: ;
	}
	popFrame();
	return result;
}
NIM_EXTERNC N_NOINLINE(void, stdlib_unicodeInit000)(void) {
	nimfr_("unicode", "unicode.nim");
	popFrame();
}

NIM_EXTERNC N_NOINLINE(void, stdlib_unicodeDatInit000)(void) {
NTI_sVg18TP9cLifHyygRe9cro9aA_.size = sizeof(NI32);
NTI_sVg18TP9cLifHyygRe9cro9aA_.kind = 34;
NTI_sVg18TP9cLifHyygRe9cro9aA_.base = 0;
NTI_sVg18TP9cLifHyygRe9cro9aA_.flags = 3;
}

