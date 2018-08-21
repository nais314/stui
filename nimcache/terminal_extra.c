/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:   gcc -c  -w -pthread -g3 -O0 -O3 -fno-strict-aliasing  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/nimcache/terminal_extra.o /home/user/Dropbox/projects/nim/stui/nimcache/terminal_extra.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#include <stdio.h>
#include <termios.h>
#include <string.h>
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
typedef struct NimStringDesc NimStringDesc;typedef struct TGenericSeq TGenericSeq;typedef struct tyObject_StringTableObj_DKRIdH9c9cKI7YpQb9c0wKlEw tyObject_StringTableObj_DKRIdH9c9cKI7YpQb9c0wKlEw;typedef struct RootObj RootObj;typedef struct TNimType TNimType;typedef struct TNimNode TNimNode;typedef struct tySequence_4eQHGndY6XBYpFOH09apV8Q tySequence_4eQHGndY6XBYpFOH09apV8Q;typedef struct tyTuple_UV3llMMYFckfui8YMBuUZA tyTuple_UV3llMMYFckfui8YMBuUZA;struct TGenericSeq {NI len;NI reserved;};
struct NimStringDesc {  TGenericSeq Sup;NIM_CHAR data[SEQ_DECL_SIZE];};
typedef unsigned char tyArray_wo9atxlj1CQKWeAypuYX9cIg[32];typedef NimStringDesc* tyArray_Re75IspeoxXy2oCZHwcRrA[2];typedef NU8 tySet_tyEnum_ProcessOption_bnU6W8LhTMnT4JaSWtGlSA;typedef NimStringDesc* tyArray_8ZvwQIddfpj2THRVPsFzIQ[1];typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);struct TNimType {NI size;tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;TNimType* base;TNimNode* node;void* finalizer;tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;};
struct RootObj {TNimType* m_type;};
typedef NU8 tyEnum_StringTableMode_G9c4wVDFIzf0xHmQvxso9a9cQ;struct tyObject_StringTableObj_DKRIdH9c9cKI7YpQb9c0wKlEw {  RootObj Sup;NI counter;tySequence_4eQHGndY6XBYpFOH09apV8Q* data;tyEnum_StringTableMode_G9c4wVDFIzf0xHmQvxso9a9cQ mode;};
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;struct TNimNode {tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;NI offset;TNimType* typ;NCSTRING name;NI len;TNimNode** sons;};
struct tyTuple_UV3llMMYFckfui8YMBuUZA {NimStringDesc* Field0;NimStringDesc* Field1;};
struct tySequence_4eQHGndY6XBYpFOH09apV8Q {  TGenericSeq Sup;  tyTuple_UV3llMMYFckfui8YMBuUZA data[SEQ_DECL_SIZE];};
#line 110 "/usr/lib/nim/system/sysio.nim"
N_LIB_PRIVATE N_NIMCALL(void, write_c4mGyJBvK73pdM22jiweKQ)(FILE* f, NimStringDesc* s);
#line 417 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, nimFrame)(TFrame* s);
#line 412 "/usr/lib/nim/system/excpt.nim"
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
#line 70 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, popFrame)(void);
#line 142 "/usr/lib/nim/system/sysio.nim"
N_LIB_PRIVATE N_NIMCALL(int, getFileHandle_bZ9c2yojtXoDTUpfyl8h8Rg)(FILE* f);
#line 97 "/usr/lib/nim/pure/includes/osenv.nim"
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, getEnv_9b1nh9cAHhSLlHOPz8lCk5FA)(NimStringDesc* key, NimStringDesc* default_0);
#line 2423 "/usr/lib/nim/system.nim"
static N_INLINE(NIM_BOOL, contains_jPdUhZfr9a8sH2V3ZBDljzwterminal_extra)(NimStringDesc** a, NI aLen_0, NimStringDesc* item);
#line 2415 "/usr/lib/nim/system.nim"
static N_INLINE(NI, find_9basNl9bVqn7SOf9bgUeI8TEQterminal_extra)(NimStringDesc** a, NI aLen_0, NimStringDesc* item);
#line 18 "/usr/lib/nim/system/chcks.nim"
N_NOINLINE(void, raiseIndexError)(void);
#line 35 "/usr/lib/nim/system/sysstr.nim"
static N_INLINE(NIM_BOOL, eqStrings)(NimStringDesc* a, NimStringDesc* b);
#line 3249 "/usr/lib/nim/system.nim"
static N_INLINE(NIM_BOOL, equalMem_fmeFeLBvgmAHG9bC8ETS9bYQstui)(void* a, void* b, NI size);
#line 319 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, addInt)(NI a, NI b);
#line 13 "/usr/lib/nim/system/arithm.nim"
N_NOINLINE(void, raiseOverflow)(void);
#line 352 "/usr/lib/nim/pure/osproc.nim"
N_LIB_PRIVATE N_NIMCALL(NimStringDesc*, nospexecProcess)(NimStringDesc* command, NimStringDesc** args, NI argsLen_0, tyObject_StringTableObj_DKRIdH9c9cKI7YpQb9c0wKlEw* env, tySet_tyEnum_ProcessOption_bnU6W8LhTMnT4JaSWtGlSA options);extern NIM_THREADVAR TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_2, "\033[\?1049l", 8);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_3, "COLORTERM", 9);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_4, "", 0);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_8, "truecolor", 9);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_9, "24bit", 5);NIM_CONST tyArray_Re75IspeoxXy2oCZHwcRrA TM_TU9ahZ26Jf3iDK8jET6DJTQ_7 = {((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_8),((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_9)};STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_10, "tput colors", 11);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_11, "8\012", 2);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_12, "16\012", 3);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_13, "256\012", 4);STRING_LITERAL(TM_TU9ahZ26Jf3iDK8jET6DJTQ_14, "\033[\?1049h\033[H", 11);

#line 417 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, nimFrame)(TFrame* s) {
	NI T1_;
#line 418 "/usr/lib/nim/system/excpt.nim"
	T1_ = (NI)0;
#line 418 "/usr/lib/nim/system/excpt.nim"
	{
#line 418 "/usr/lib/nim/system/excpt.nim"
		if (!(framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw == NIM_NIL)) goto LA4_;		T1_ = ((NI) 0);	}	goto LA2_;	LA4_: ;	{
#line 418 "/usr/lib/nim/system/excpt.nim"
		T1_ = ((NI) ((NI16)((*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).calldepth + ((NI16) 1))));	}	LA2_: ;	(*s).calldepth = ((NI16) (T1_));
#line 419 "/usr/lib/nim/system/excpt.nim"
	(*s).prev = framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;
#line 420 "/usr/lib/nim/system/excpt.nim"
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = s;
#line 421 "/usr/lib/nim/system/excpt.nim"
	{
#line 421 "/usr/lib/nim/system/excpt.nim"
		if (!((*s).calldepth == ((NI16) 2000))) goto LA9_;
#line 421 "/usr/lib/nim/system/excpt.nim"
		stackOverflow_II46IjNZztN9bmbxUD8dt8g();	}	LA9_: ;}


#line 70 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, popFrame)(void) {

#line 71 "/usr/lib/nim/system/excpt.nim"
	framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw = (*framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw).prev;}


#line 20 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
N_LIB_PRIVATE N_NIMCALL(void, switchToNormalBuffer_ymRoPFct3VzTqDMG2Q8big)(void) {
	nimfr_("switchToNormalBuffer", "terminal_extra.nim");
#line 21 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(21, "terminal_extra.nim");	write_c4mGyJBvK73pdM22jiweKQ(stdout, ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_2));	popFrame();}


#line 48 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
N_LIB_PRIVATE N_NIMCALL(void, disableCanon_ymRoPFct3VzTqDMG2Q8big_2)(void) {
	int fd;	struct termios cur;	int T1_;	int T2_;	nimfr_("disableCanon", "terminal_extra.nim");
#line 50 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(50, "terminal_extra.nim");	fd = getFileHandle_bZ9c2yojtXoDTUpfyl8h8Rg(stdin);	memset((void*)(&cur), 0, sizeof(cur));
#line 52 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(52, "terminal_extra.nim");	T1_ = (int)0;	T1_ = tcgetattr(fd, (&cur));	T1_;

#line 53 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(53, "terminal_extra.nim");
#line 53 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	cur.c_lflag = (NU32)(cur.c_lflag | ICANON);
#line 54 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(54, "terminal_extra.nim");	T2_ = (int)0;	T2_ = tcsetattr(fd, TCSANOW, (&cur));	T2_;
	popFrame();}


#line 3249 "/usr/lib/nim/system.nim"
static N_INLINE(NIM_BOOL, equalMem_fmeFeLBvgmAHG9bC8ETS9bYQstui)(void* a, void* b, NI size) {
	NIM_BOOL result;	int T1_;	result = (NIM_BOOL)0;
#line 3250 "/usr/lib/nim/system.nim"

#line 3250 "/usr/lib/nim/system.nim"

#line 3250 "/usr/lib/nim/system.nim"
	T1_ = (int)0;	T1_ = memcmp(a, b, ((size_t) (size)));	result = (T1_ == ((NI32) 0));	return result;}


#line 35 "/usr/lib/nim/system/sysstr.nim"
static N_INLINE(NIM_BOOL, eqStrings)(NimStringDesc* a, NimStringDesc* b) {
	NIM_BOOL result;	NIM_BOOL T11_;{	result = (NIM_BOOL)0;
#line 36 "/usr/lib/nim/system/sysstr.nim"
	{
#line 36 "/usr/lib/nim/system/sysstr.nim"
		if (!(a == b)) goto LA3_;
#line 36 "/usr/lib/nim/system/sysstr.nim"

#line 36 "/usr/lib/nim/system/sysstr.nim"
		result = NIM_TRUE;		goto BeforeRet_;	}	LA3_: ;
#line 37 "/usr/lib/nim/system/sysstr.nim"
	{		NIM_BOOL T7_;
#line 37 "/usr/lib/nim/system/sysstr.nim"
		T7_ = (NIM_BOOL)0;
#line 37 "/usr/lib/nim/system/sysstr.nim"
		T7_ = (a == NIM_NIL);		if (T7_) goto LA8_;
#line 37 "/usr/lib/nim/system/sysstr.nim"
		T7_ = (b == NIM_NIL);		LA8_: ;		if (!T7_) goto LA9_;
#line 37 "/usr/lib/nim/system/sysstr.nim"

#line 37 "/usr/lib/nim/system/sysstr.nim"
		result = NIM_FALSE;		goto BeforeRet_;	}	LA9_: ;
#line 38 "/usr/lib/nim/system/sysstr.nim"

#line 38 "/usr/lib/nim/system/sysstr.nim"

#line 38 "/usr/lib/nim/system/sysstr.nim"
	T11_ = (NIM_BOOL)0;
#line 38 "/usr/lib/nim/system/sysstr.nim"
	T11_ = ((*a).Sup.len == (*b).Sup.len);	if (!(T11_)) goto LA12_;
#line 39 "/usr/lib/nim/system/sysstr.nim"
	T11_ = equalMem_fmeFeLBvgmAHG9bC8ETS9bYQstui(((void*) ((*a).data)), ((void*) ((*b).data)), ((NI) ((*a).Sup.len)));	LA12_: ;	result = T11_;	goto BeforeRet_;	}BeforeRet_: ;	return result;}


#line 319 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, addInt)(NI a, NI b) {
	NI result;{	result = (NI)0;
#line 320 "/usr/lib/nim/system/arithm.nim"

#line 320 "/usr/lib/nim/system/arithm.nim"
	result = (NI)((NU64)(a) + (NU64)(b));
#line 321 "/usr/lib/nim/system/arithm.nim"
	{		NIM_BOOL T3_;
#line 321 "/usr/lib/nim/system/arithm.nim"
		T3_ = (NIM_BOOL)0;
#line 321 "/usr/lib/nim/system/arithm.nim"

#line 321 "/usr/lib/nim/system/arithm.nim"
		T3_ = (((NI) 0) <= (NI)(result ^ a));		if (T3_) goto LA4_;
#line 321 "/usr/lib/nim/system/arithm.nim"

#line 321 "/usr/lib/nim/system/arithm.nim"
		T3_ = (((NI) 0) <= (NI)(result ^ b));		LA4_: ;		if (!T3_) goto LA5_;
#line 322 "/usr/lib/nim/system/arithm.nim"
		goto BeforeRet_;	}	LA5_: ;
#line 323 "/usr/lib/nim/system/arithm.nim"
	raiseOverflow();	}BeforeRet_: ;	return result;}


#line 2415 "/usr/lib/nim/system.nim"
static N_INLINE(NI, find_9basNl9bVqn7SOf9bgUeI8TEQterminal_extra)(NimStringDesc** a, NI aLen_0, NimStringDesc* item) {
	NI result;	nimfr_("find", "system.nim");{	result = (NI)0;	{		NimStringDesc* i;		NI i_2;		i = (NimStringDesc*)0;
#line 2185 "/usr/lib/nim/system.nim"
		nimln_(2185, "system.nim");		i_2 = ((NI) 0);		{
#line 2186 "/usr/lib/nim/system.nim"
			nimln_(2186, "system.nim");			while (1) {				NI TM_TU9ahZ26Jf3iDK8jET6DJTQ_5;				NI TM_TU9ahZ26Jf3iDK8jET6DJTQ_6;
#line 2186 "/usr/lib/nim/system.nim"

#line 2186 "/usr/lib/nim/system.nim"
				if (!(i_2 < aLen_0)) goto LA3;
#line 2187 "/usr/lib/nim/system.nim"
				nimln_(2187, "system.nim");				if ((NU)(i_2) >= (NU)(aLen_0)) raiseIndexError();				i = a[i_2];
#line 2419 "/usr/lib/nim/system.nim"
				nimln_(2419, "system.nim");				{
#line 2419 "/usr/lib/nim/system.nim"
					if (!eqStrings(i, item)) goto LA6_;
#line 2419 "/usr/lib/nim/system.nim"
					goto BeforeRet_;				}				LA6_: ;
#line 2420 "/usr/lib/nim/system.nim"
				nimln_(2420, "system.nim");				TM_TU9ahZ26Jf3iDK8jET6DJTQ_5 = addInt(result, ((NI) 1));				result = (NI)(TM_TU9ahZ26Jf3iDK8jET6DJTQ_5);
#line 2188 "/usr/lib/nim/system.nim"
				nimln_(2188, "system.nim");				TM_TU9ahZ26Jf3iDK8jET6DJTQ_6 = addInt(i_2, ((NI) 1));				i_2 = (NI)(TM_TU9ahZ26Jf3iDK8jET6DJTQ_6);			} LA3: ;		}	}
#line 2421 "/usr/lib/nim/system.nim"
	nimln_(2421, "system.nim");	result = ((NI) -1);	}BeforeRet_: ;	popFrame();	return result;}


#line 2423 "/usr/lib/nim/system.nim"
static N_INLINE(NIM_BOOL, contains_jPdUhZfr9a8sH2V3ZBDljzwterminal_extra)(NimStringDesc** a, NI aLen_0, NimStringDesc* item) {
	NIM_BOOL result;	NI T1_;	nimfr_("contains", "system.nim");{	result = (NIM_BOOL)0;
#line 2426 "/usr/lib/nim/system.nim"
	nimln_(2426, "system.nim");
#line 2426 "/usr/lib/nim/system.nim"

#line 2426 "/usr/lib/nim/system.nim"

#line 2426 "/usr/lib/nim/system.nim"
	T1_ = (NI)0;	T1_ = find_9basNl9bVqn7SOf9bgUeI8TEQterminal_extra(a, aLen_0, item);	result = (((NI) 0) <= T1_);	goto BeforeRet_;	}BeforeRet_: ;	popFrame();	return result;}


#line 4 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
N_LIB_PRIVATE N_NIMCALL(NI, getColorMode_DwJ9cUq9bmNTmGbfue9cqD9cSg)(void) {
	NI result;	NimStringDesc* str;	nimfr_("getColorMode", "terminal_extra.nim");	result = (NI)0;
#line 5 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(5, "terminal_extra.nim");	str = getEnv_9b1nh9cAHhSLlHOPz8lCk5FA(((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_3), ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_4));
#line 6 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(6, "terminal_extra.nim");	{		NIM_BOOL T3_;		tyArray_8ZvwQIddfpj2THRVPsFzIQ T6_;
#line 1212 "/usr/lib/nim/system.nim"
		nimln_(1212, "system.nim");
#line 6 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
		nimln_(6, "terminal_extra.nim");		T3_ = (NIM_BOOL)0;		T3_ = contains_jPdUhZfr9a8sH2V3ZBDljzwterminal_extra(TM_TU9ahZ26Jf3iDK8jET6DJTQ_7, 2, str);		if (!!(T3_)) goto LA4_;
#line 7 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
		nimln_(7, "terminal_extra.nim");
#line 7 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"

#line 7 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
		memset((void*)T6_, 0, sizeof(T6_));		str = nospexecProcess(((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_10), T6_, 0, NIM_NIL, 14);
#line 9 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
		nimln_(9, "terminal_extra.nim");		if (eqStrings(str, ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_11))) goto LA7_;		if (eqStrings(str, ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_12))) goto LA8_;		if (eqStrings(str, ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_13))) goto LA9_;		goto LA10_;		LA7_: ;		{
#line 10 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
			nimln_(10, "terminal_extra.nim");			result = ((NI) 0);		}		goto LA11_;		LA8_: ;		{
#line 11 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
			nimln_(11, "terminal_extra.nim");			result = ((NI) 1);		}		goto LA11_;		LA9_: ;		{
#line 12 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
			nimln_(12, "terminal_extra.nim");			result = ((NI) 2);		}		goto LA11_;		LA10_: ;		{
#line 13 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
			nimln_(13, "terminal_extra.nim");			result = ((NI) 1);		}		LA11_: ;	}	goto LA1_;	LA4_: ;	{
#line 15 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
		nimln_(15, "terminal_extra.nim");		result = ((NI) 3);	}	LA1_: ;	popFrame();	return result;}


#line 17 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
N_LIB_PRIVATE N_NIMCALL(void, switchToAlternateBuffer_ymRoPFct3VzTqDMG2Q8big_3)(void) {
	nimfr_("switchToAlternateBuffer", "terminal_extra.nim");
#line 18 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(18, "terminal_extra.nim");	write_c4mGyJBvK73pdM22jiweKQ(stdout, ((NimStringDesc*) &TM_TU9ahZ26Jf3iDK8jET6DJTQ_14));	popFrame();}


#line 58 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
N_LIB_PRIVATE N_NIMCALL(void, enableCanon_ymRoPFct3VzTqDMG2Q8big_4)(void) {
	int fd;	struct termios cur;	int T1_;	int T2_;	nimfr_("enableCanon", "terminal_extra.nim");
#line 60 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(60, "terminal_extra.nim");	fd = getFileHandle_bZ9c2yojtXoDTUpfyl8h8Rg(stdin);	memset((void*)(&cur), 0, sizeof(cur));
#line 62 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(62, "terminal_extra.nim");	T1_ = (int)0;	T1_ = tcgetattr(fd, (&cur));	T1_;

#line 63 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(63, "terminal_extra.nim");
#line 63 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"

#line 63 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	cur.c_lflag = (NU32)(cur.c_lflag & (NU32)((NU32) ~(ICANON)));
#line 64 "/home/user/Dropbox/projects/nim/stui/terminal_extra.nim"
	nimln_(64, "terminal_extra.nim");	T2_ = (int)0;	T2_ = tcsetattr(fd, TCSANOW, (&cur));	T2_;
	popFrame();}
NIM_EXTERNC N_NOINLINE(void, unknown_terminal_extraInit000)(void) {
	nimfr_("terminal_extra", "terminal_extra.nim");	popFrame();}

NIM_EXTERNC N_NOINLINE(void, unknown_terminal_extraDatInit000)(void) {
}

