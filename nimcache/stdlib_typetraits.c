/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:   gcc -c  -w -pthread -g3 -O0 -O3 -fno-strict-aliasing  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_typetraits.o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_typetraits.c */
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

#line 417 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, nimFrame)(TFrame* s);
#line 412 "/usr/lib/nim/system/excpt.nim"
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
#line 70 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, popFrame)(void);extern NIM_THREADVAR TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;

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
NIM_EXTERNC N_NOINLINE(void, stdlib_typetraitsInit000)(void) {
	nimfr_("typetraits", "typetraits.nim");	popFrame();}

NIM_EXTERNC N_NOINLINE(void, stdlib_typetraitsDatInit000)(void) {
}

