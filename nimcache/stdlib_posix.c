/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:   gcc -c  -w -pthread -g3 -O0 -O3 -fno-strict-aliasing  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_posix.o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_posix.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#include <sys/types.h>
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
typedef struct TNimType TNimType;typedef struct TNimNode TNimNode;typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);struct TNimType {NI size;tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;TNimType* base;TNimNode* node;void* finalizer;tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;};
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;struct TNimNode {tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;NI offset;TNimType* typ;NCSTRING name;NI len;TNimNode** sons;};

#line 611 "/usr/lib/nim/posix/posix_linux_amd64.nim"
N_LIB_PRIVATE N_NIMCALL(int, WTERMSIG_9cr9a9bc3d9byCALaQhU9aObNDw)(int s);
#line 417 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, nimFrame)(TFrame* s);
#line 412 "/usr/lib/nim/system/excpt.nim"
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
#line 70 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, popFrame)(void);
#line 319 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, addInt)(NI a, NI b);
#line 13 "/usr/lib/nim/system/arithm.nim"
N_NOINLINE(void, raiseOverflow)(void);TNimType NTI_r9bTMVI8f19ah9b11jMgY4kPg_;extern NIM_THREADVAR TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;

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


#line 611 "/usr/lib/nim/posix/posix_linux_amd64.nim"
N_LIB_PRIVATE N_NIMCALL(int, WTERMSIG_9cr9a9bc3d9byCALaQhU9aObNDw)(int s) {
	int result;	nimfr_("WTERMSIG", "posix_linux_amd64.nim");	result = (int)0;
#line 611 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	nimln_(611, "posix_linux_amd64.nim");
#line 611 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	result = (NI32)(s & ((NI32) 127));	popFrame();	return result;}


#line 613 "/usr/lib/nim/posix/posix_linux_amd64.nim"
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, WIFEXITED_jey9c9a5UxiJK7PlQ0lLtE0Q)(int s) {
	NIM_BOOL result;	int T1_;	nimfr_("WIFEXITED", "posix_linux_amd64.nim");	result = (NIM_BOOL)0;
#line 613 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	nimln_(613, "posix_linux_amd64.nim");
#line 613 "/usr/lib/nim/posix/posix_linux_amd64.nim"

#line 613 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	T1_ = (int)0;	T1_ = WTERMSIG_9cr9a9bc3d9byCALaQhU9aObNDw(s);	result = (T1_ == ((NI32) 0));	popFrame();	return result;}


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


#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, WIFSIGNALED_jey9c9a5UxiJK7PlQ0lLtE0Q_2)(int s) {
	NIM_BOOL result;	NI TM_mJPr4mHlDfNAl9asG6X7NFA_2;	nimfr_("WIFSIGNALED", "posix_linux_amd64.nim");	result = (NIM_BOOL)0;
#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	nimln_(614, "posix_linux_amd64.nim");
#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"

#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"

#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"

#line 614 "/usr/lib/nim/posix/posix_linux_amd64.nim"
	TM_mJPr4mHlDfNAl9asG6X7NFA_2 = addInt((NI32)(s & ((NI32) 127)), ((NI32) 1));	if (TM_mJPr4mHlDfNAl9asG6X7NFA_2 < (-2147483647 -1) || TM_mJPr4mHlDfNAl9asG6X7NFA_2 > 2147483647) raiseOverflow();	result = (((NI8) 0) < (NI8)((NU8)(((NI8) ((NI32)(TM_mJPr4mHlDfNAl9asG6X7NFA_2)))) >> (NU64)(((NI) 1))));	popFrame();	return result;}
NIM_EXTERNC N_NOINLINE(void, stdlib_posixInit000)(void) {
	nimfr_("posix", "posix.nim");	popFrame();}

NIM_EXTERNC N_NOINLINE(void, stdlib_posixDatInit000)(void) {
NTI_r9bTMVI8f19ah9b11jMgY4kPg_.size = sizeof(pid_t);NTI_r9bTMVI8f19ah9b11jMgY4kPg_.kind = 34;NTI_r9bTMVI8f19ah9b11jMgY4kPg_.base = 0;NTI_r9bTMVI8f19ah9b11jMgY4kPg_.flags = 3;}

