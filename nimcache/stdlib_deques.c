/* Generated by Nim Compiler v0.18.0 */
/*   (c) 2018 Andreas Rumpf */
/* The generated code is subject to the original license. */
/* Compiled for: Linux, amd64, gcc */
/* Command for C compiler:   gcc -c  -w -pthread -g3 -O0 -O3 -fno-strict-aliasing  -I/usr/lib/nim -o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_deques.o /home/user/Dropbox/projects/nim/stui/nimcache/stdlib_deques.c */
#define NIM_NEW_MANGLING_RULES
#define NIM_INTBITS 64

#include "nimbase.h"
#include <string.h>
#include <sys/types.h>
                          #include <pthread.h>
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
typedef struct tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg;typedef struct tySequence_WF89a8QyKeDCh4DYWTmSiBg tySequence_WF89a8QyKeDCh4DYWTmSiBg;typedef struct TNimType TNimType;typedef struct TNimNode TNimNode;typedef struct TGenericSeq TGenericSeq;typedef struct tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g;typedef struct tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w;typedef struct tyObject_GcHeap_1TRH1TZMaVZTnLNcIHuNFQ tyObject_GcHeap_1TRH1TZMaVZTnLNcIHuNFQ;typedef struct tyObject_GcStack_7fytPA5bBsob6See21YMRA tyObject_GcStack_7fytPA5bBsob6See21YMRA;typedef struct tyObject_MemRegion_x81NhDv59b8ercDZ9bi85jyg tyObject_MemRegion_x81NhDv59b8ercDZ9bi85jyg;typedef struct tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ;typedef struct tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg;typedef struct tyObject_LLChunk_XsENErzHIZV9bhvyJx56wGw tyObject_LLChunk_XsENErzHIZV9bhvyJx56wGw;typedef struct tyObject_IntSet_EZObFrE3NC9bIb3YMkY9crZA tyObject_IntSet_EZObFrE3NC9bIb3YMkY9crZA;typedef struct tyObject_Trunk_W0r8S0Y3UGke6T9bIUWnnuw tyObject_Trunk_W0r8S0Y3UGke6T9bIUWnnuw;typedef struct tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw;typedef struct tyObject_HeapLinks_PDV1HBZ8CQSQJC9aOBFNRSg tyObject_HeapLinks_PDV1HBZ8CQSQJC9aOBFNRSg;typedef struct tyTuple_ujsjpB2O9cjj3uDHsXbnSzg tyTuple_ujsjpB2O9cjj3uDHsXbnSzg;typedef struct tyObject_GcStat_0RwLoVBHZPfUAcLczmfQAg tyObject_GcStat_0RwLoVBHZPfUAcLczmfQAg;typedef struct tyObject_CellSet_jG87P0AI9aZtss9ccTYBIISQ tyObject_CellSet_jG87P0AI9aZtss9ccTYBIISQ;typedef struct tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg;typedef struct tyObject_SharedList_9cWkTIPQvNw7gFHMOEzMCLw tyObject_SharedList_9cWkTIPQvNw7gFHMOEzMCLw;typedef struct tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw;typedef struct NimStringDesc NimStringDesc;typedef struct tyObject_BaseChunk_Sdq7WpT6qAH858F5ZEdG3w tyObject_BaseChunk_Sdq7WpT6qAH858F5ZEdG3w;typedef struct tyObject_FreeCell_u6M5LHprqzkn9axr04yg9bGQ tyObject_FreeCell_u6M5LHprqzkn9axr04yg9bGQ;struct tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg {tySequence_WF89a8QyKeDCh4DYWTmSiBg* data;NI head;NI tail;NI count;NI mask;};
typedef NU8 tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A;typedef NU8 tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ;typedef N_NIMCALL_PTR(void, tyProc_ojoeKfW4VYIm36I9cpDTQIg) (void* p, NI op);typedef N_NIMCALL_PTR(void*, tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ) (void* p);struct TNimType {NI size;tyEnum_TNimKind_jIBKr1ejBgsfM33Kxw4j7A kind;tySet_tyEnum_TNimTypeFlag_v8QUszD1sWlSIWZz7mC4bQ flags;TNimType* base;TNimNode* node;void* finalizer;tyProc_ojoeKfW4VYIm36I9cpDTQIg marker;tyProc_WSm2xU5ARYv9aAR4l0z9c9auQ deepcopy;};
typedef NU8 tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ;struct TNimNode {tyEnum_TNimNodeKind_unfNsxrcATrufDZmpBq4HQ kind;NI offset;TNimType* typ;NCSTRING name;NI len;TNimNode** sons;};
typedef struct {N_NIMCALL_PTR(void, ClP_0) (void* ClE_0);void* ClE_0;} tyProc_IIomJ6ptE6vfJ5zRbATgkQ;struct TGenericSeq {NI len;NI reserved;};
struct tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g {NI refcount;TNimType* typ;};
struct tyObject_GcStack_7fytPA5bBsob6See21YMRA {void* bottom;};
struct tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w {NI len;NI cap;tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g** d;};
typedef tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ* tyArray_SiRwrEKZdLgxqz9a9aoVBglg[512];typedef NU32 tyArray_BHbOSqU1t9b3Gt7K2c6fQig[24];typedef tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg* tyArray_N1u1nqOgmuJN9cSZrnMHgOQ[32];typedef tyArray_N1u1nqOgmuJN9cSZrnMHgOQ tyArray_B6durA4ZCi1xjJvRtyYxMg[24];typedef tyObject_Trunk_W0r8S0Y3UGke6T9bIUWnnuw* tyArray_lh2A89ahMmYg9bCmpVaplLbA[256];struct tyObject_IntSet_EZObFrE3NC9bIb3YMkY9crZA {tyArray_lh2A89ahMmYg9bCmpVaplLbA data;};
typedef tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw* tyArray_0aOLqZchNi8nWtMTi8ND8w[2];struct tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw {tyArray_0aOLqZchNi8nWtMTi8ND8w link;NI key;NI upperBound;NI level;};
struct tyTuple_ujsjpB2O9cjj3uDHsXbnSzg {tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg* Field0;NI Field1;};
typedef tyTuple_ujsjpB2O9cjj3uDHsXbnSzg tyArray_LzOv2eCDGiceMKQstCLmhw[30];struct tyObject_HeapLinks_PDV1HBZ8CQSQJC9aOBFNRSg {NI len;tyArray_LzOv2eCDGiceMKQstCLmhw chunks;tyObject_HeapLinks_PDV1HBZ8CQSQJC9aOBFNRSg* next;};
struct tyObject_MemRegion_x81NhDv59b8ercDZ9bi85jyg {NI minLargeObj;NI maxLargeObj;tyArray_SiRwrEKZdLgxqz9a9aoVBglg freeSmallChunks;NU32 flBitmap;tyArray_BHbOSqU1t9b3Gt7K2c6fQig slBitmap;tyArray_B6durA4ZCi1xjJvRtyYxMg matrix;tyObject_LLChunk_XsENErzHIZV9bhvyJx56wGw* llmem;NI currMem;NI maxMem;NI freeMem;NI occ;NI lastSize;tyObject_IntSet_EZObFrE3NC9bIb3YMkY9crZA chunkStarts;tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw* root;tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw* deleted;tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw* last;tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw* freeAvlNodes;NIM_BOOL locked;NIM_BOOL blockChunkSizeIncrease;NI nextChunkSize;tyObject_AvlNode_IaqjtwKhxLEpvDS9bct9blEw bottomData;tyObject_HeapLinks_PDV1HBZ8CQSQJC9aOBFNRSg heapLinks;};
struct tyObject_GcStat_0RwLoVBHZPfUAcLczmfQAg {NI stackScans;NI cycleCollections;NI maxThreshold;NI maxStackSize;NI maxStackCells;NI cycleTableSize;NI64 maxPause;};
struct tyObject_CellSet_jG87P0AI9aZtss9ccTYBIISQ {NI counter;NI max;tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg* head;tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg** data;};
typedef long tyArray_xDUyu9aScDpt0JZLU6q9aEZQ[5];struct tyObject_SharedList_9cWkTIPQvNw7gFHMOEzMCLw {tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw* head;tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw* tail;pthread_mutex_t lock;};
struct tyObject_GcHeap_1TRH1TZMaVZTnLNcIHuNFQ {tyObject_GcStack_7fytPA5bBsob6See21YMRA stack;NI cycleThreshold;tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w zct;tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w decStack;tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w tempStack;NI recGcLock;tyObject_MemRegion_x81NhDv59b8ercDZ9bi85jyg region;tyObject_GcStat_0RwLoVBHZPfUAcLczmfQAg stat;tyObject_CellSet_jG87P0AI9aZtss9ccTYBIISQ marked;tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w additionalRoots;tyObject_SharedList_9cWkTIPQvNw7gFHMOEzMCLw toDispose;NI gcThreadId;};
struct NimStringDesc {  TGenericSeq Sup;NIM_CHAR data[SEQ_DECL_SIZE];};
struct tyObject_BaseChunk_Sdq7WpT6qAH858F5ZEdG3w {NI prevSize;NI size;};
struct tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ {  tyObject_BaseChunk_Sdq7WpT6qAH858F5ZEdG3w Sup;tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ* next;tyObject_SmallChunk_tXn60W2f8h3jgAYdEmy5NQ* prev;tyObject_FreeCell_u6M5LHprqzkn9axr04yg9bGQ* freeList;NI free;NI acc;NF data;};
struct tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg {  tyObject_BaseChunk_Sdq7WpT6qAH858F5ZEdG3w Sup;tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg* next;tyObject_BigChunk_Rv9c70Uhp2TytkX7eH78qEg* prev;NF data;};
struct tyObject_LLChunk_XsENErzHIZV9bhvyJx56wGw {NI size;NI acc;tyObject_LLChunk_XsENErzHIZV9bhvyJx56wGw* next;};
typedef NI tyArray_9a8QARi5WsUggNU9bom7kzTQ[8];struct tyObject_Trunk_W0r8S0Y3UGke6T9bIUWnnuw {tyObject_Trunk_W0r8S0Y3UGke6T9bIUWnnuw* next;NI key;tyArray_9a8QARi5WsUggNU9bom7kzTQ bits;};
struct tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg {tyObject_PageDesc_fublkgIY4LG3mT51LU2WHg* next;NI key;tyArray_9a8QARi5WsUggNU9bom7kzTQ bits;};
typedef void* tyArray_Rrw59cMvNu8cDA9cQDh4v2oA[100];struct tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw {tyObject_SharedListNodecolonObjectType__82xHhBDm9bpijSPOyEGz0Hw* next;NI dataLen;tyArray_Rrw59cMvNu8cDA9cQDh4v2oA d;};
struct tyObject_FreeCell_u6M5LHprqzkn9axr04yg9bGQ {tyObject_FreeCell_u6M5LHprqzkn9axr04yg9bGQ* next;NI zeroField;};
struct tySequence_WF89a8QyKeDCh4DYWTmSiBg {  TGenericSeq Sup;  tyProc_IIomJ6ptE6vfJ5zRbATgkQ data[SEQ_DECL_SIZE];};
#line 128 "/usr/lib/nim/pure/collections/deques.nim"
N_LIB_PRIVATE N_NIMCALL(void, expandIfNeeded_yUfcbmt639aJ6tr007RgLpQ)(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg* deq);
#line 319 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, addInt)(NI a, NI b);
#line 13 "/usr/lib/nim/system/arithm.nim"
N_NOINLINE(void, raiseOverflow)(void);
#line 728 "/usr/lib/nim/system.nim"
N_LIB_PRIVATE N_NIMCALL(tySequence_WF89a8QyKeDCh4DYWTmSiBg*, newSeq_FGDbRopuA4y4tNQGp9cEEsg)(NI len);
#line 372 "/usr/lib/nim/system/arithm.nim"
N_NIMCALL(NI, mulInt)(NI a, NI b);
#line 30 "/usr/lib/nim/system/chcks.nim"
static N_INLINE(NI, chckRange)(NI i, NI a, NI b);
#line 12 "/usr/lib/nim/system/chcks.nim"
N_NOINLINE(void, raiseRangeError)(NI64 val);
#line 18 "/usr/lib/nim/system/chcks.nim"
N_NOINLINE(void, raiseIndexError)(void);
#line 260 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, asgnRef)(void** dest, void* src);
#line 189 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, incRef_9cAA5YuQAAC3MVbnGeV86swsystem)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c);
#line 417 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, nimFrame)(TFrame* s);
#line 412 "/usr/lib/nim/system/excpt.nim"
N_LIB_PRIVATE N_NOINLINE(void, stackOverflow_II46IjNZztN9bmbxUD8dt8g)(void);
#line 70 "/usr/lib/nim/system/excpt.nim"
static N_INLINE(void, popFrame)(void);
#line 130 "/usr/lib/nim/system/gc.nim"
static N_INLINE(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*, usrToCell_yB9aH5WIlwd0xkYrcdPeXrQsystem)(void* usr);
#line 215 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, decRef_MV4BBk6J1qu70IbBxwEn4wsystem)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c);
#line 207 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, rtlAddZCT_MV4BBk6J1qu70IbBxwEn4w_2system)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c);
#line 121 "/usr/lib/nim/system/gc.nim"
N_LIB_PRIVATE N_NOINLINE(void, addZCT_fCDI7oO1NNVXXURtxSzsRw)(tyObject_CellSeq_Axo1XVm9aaQueTOldv8le5w* s, tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c);
#line 280 "/usr/lib/nim/system/gc.nim"
N_NIMCALL(void, unsureAsgnRef)(void** dest, void* src);
#line 326 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, subInt)(NI a, NI b);
#line 51 "/usr/lib/nim/system/chcks.nim"
N_NOINLINE(void, chckNil)(void* p);
#line 217 "/usr/lib/nim/system/assign.nim"
N_NIMCALL(void, genericReset)(void* dest, TNimType* mt);
#line 88 "/usr/lib/nim/pure/math.nim"
N_LIB_PRIVATE N_NIMCALL(NIM_BOOL, isPowerOfTwo_M0Db9b9cHxuUgw2ZF0P8utPg)(NI x);
#line 3773 "/usr/lib/nim/system.nim"
N_LIB_PRIVATE N_NIMCALL(void, failedAssertImpl_aDmpBTs9cPuXp0Mp9cfiNeyA)(NimStringDesc* msg);
#line 479 "/usr/lib/nim/system/gc.nim"
N_NIMCALL(void*, newSeq)(TNimType* typ, NI len);TNimType NTI_lXZKLUMbpAcAUzeVrG09bNg_;extern TNimType NTI_WF89a8QyKeDCh4DYWTmSiBg_;extern TNimType NTI_rR5Bzr1D5krxoo1NcNyeMA_;extern NIM_THREADVAR TFrame* framePtr_HRfVMH3jYeBJz6Q6X9b6Ptw;extern NIM_THREADVAR tyObject_GcHeap_1TRH1TZMaVZTnLNcIHuNFQ gch_IcYaEuuWivYAS86vFMTS3Q;STRING_LITERAL(TM_NdgYN5HU2ty0qMI5oazWyg_11, "isPowerOfTwo(initialSize) ", 26);

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


#line 30 "/usr/lib/nim/system/chcks.nim"
static N_INLINE(NI, chckRange)(NI i, NI a, NI b) {
	NI result;{	result = (NI)0;
#line 31 "/usr/lib/nim/system/chcks.nim"
	{		NIM_BOOL T3_;
#line 31 "/usr/lib/nim/system/chcks.nim"
		T3_ = (NIM_BOOL)0;
#line 31 "/usr/lib/nim/system/chcks.nim"
		T3_ = (a <= i);		if (!(T3_)) goto LA4_;
#line 31 "/usr/lib/nim/system/chcks.nim"
		T3_ = (i <= b);		LA4_: ;		if (!T3_) goto LA5_;
#line 32 "/usr/lib/nim/system/chcks.nim"

#line 32 "/usr/lib/nim/system/chcks.nim"
		result = i;		goto BeforeRet_;	}	goto LA1_;	LA5_: ;	{
#line 34 "/usr/lib/nim/system/chcks.nim"
		raiseRangeError(((NI64) (i)));	}	LA1_: ;	}BeforeRet_: ;	return result;}


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


#line 189 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, incRef_9cAA5YuQAAC3MVbnGeV86swsystem)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c) {
	nimfr_("incRef", "gc.nim");
#line 191 "/usr/lib/nim/system/gc.nim"
	nimln_(191, "gc.nim");
#line 191 "/usr/lib/nim/system/gc.nim"
	(*c).refcount = (NI)((NU64)((*c).refcount) + (NU64)(((NI) 8)));	popFrame();}


#line 130 "/usr/lib/nim/system/gc.nim"
static N_INLINE(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*, usrToCell_yB9aH5WIlwd0xkYrcdPeXrQsystem)(void* usr) {
	tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* result;	nimfr_("usrToCell", "gc.nim");	result = (tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*)0;
#line 132 "/usr/lib/nim/system/gc.nim"
	nimln_(132, "gc.nim");
#line 132 "/usr/lib/nim/system/gc.nim"

#line 132 "/usr/lib/nim/system/gc.nim"
	result = ((tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*) ((NI)((NU64)(((NI) (ptrdiff_t) (usr))) - (NU64)(((NI)sizeof(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g))))));	popFrame();	return result;}


#line 207 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, rtlAddZCT_MV4BBk6J1qu70IbBxwEn4w_2system)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c) {
	nimfr_("rtlAddZCT", "gc.nim");
#line 211 "/usr/lib/nim/system/gc.nim"
	nimln_(211, "gc.nim");	addZCT_fCDI7oO1NNVXXURtxSzsRw((&gch_IcYaEuuWivYAS86vFMTS3Q.zct), c);	popFrame();}


#line 215 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, decRef_MV4BBk6J1qu70IbBxwEn4wsystem)(tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* c) {
	nimfr_("decRef", "gc.nim");
#line 218 "/usr/lib/nim/system/gc.nim"
	nimln_(218, "gc.nim");	{
#line 218 "/usr/lib/nim/system/gc.nim"
		(*c).refcount -= ((NI) 8);
#line 218 "/usr/lib/nim/system/gc.nim"
		if (!((NU64)((*c).refcount) < (NU64)(((NI) 8)))) goto LA3_;
#line 219 "/usr/lib/nim/system/gc.nim"
		nimln_(219, "gc.nim");		rtlAddZCT_MV4BBk6J1qu70IbBxwEn4w_2system(c);	}	LA3_: ;	popFrame();}


#line 260 "/usr/lib/nim/system/gc.nim"
static N_INLINE(void, asgnRef)(void** dest, void* src) {
	nimfr_("asgnRef", "gc.nim");
#line 264 "/usr/lib/nim/system/gc.nim"
	nimln_(264, "gc.nim");	{		tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* T5_;
#line 398 "/usr/lib/nim/system.nim"
		nimln_(398, "system.nim");
#line 264 "/usr/lib/nim/system/gc.nim"
		nimln_(264, "gc.nim");		if (!!((src == NIM_NIL))) goto LA3_;
#line 264 "/usr/lib/nim/system/gc.nim"

#line 264 "/usr/lib/nim/system/gc.nim"
		T5_ = (tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*)0;		T5_ = usrToCell_yB9aH5WIlwd0xkYrcdPeXrQsystem(src);		incRef_9cAA5YuQAAC3MVbnGeV86swsystem(T5_);	}	LA3_: ;
#line 265 "/usr/lib/nim/system/gc.nim"
	nimln_(265, "gc.nim");	{		tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g* T10_;
#line 398 "/usr/lib/nim/system.nim"
		nimln_(398, "system.nim");
#line 265 "/usr/lib/nim/system/gc.nim"
		nimln_(265, "gc.nim");		if (!!(((*dest) == NIM_NIL))) goto LA8_;
#line 265 "/usr/lib/nim/system/gc.nim"

#line 265 "/usr/lib/nim/system/gc.nim"
		T10_ = (tyObject_Cell_1zcF9cV8XIAtbN8h5HRUB8g*)0;		T10_ = usrToCell_yB9aH5WIlwd0xkYrcdPeXrQsystem((*dest));		decRef_MV4BBk6J1qu70IbBxwEn4wsystem(T10_);	}	LA8_: ;
#line 266 "/usr/lib/nim/system/gc.nim"
	nimln_(266, "gc.nim");	(*dest) = src;	popFrame();}


#line 326 "/usr/lib/nim/system/arithm.nim"
static N_INLINE(NI, subInt)(NI a, NI b) {
	NI result;{	result = (NI)0;
#line 327 "/usr/lib/nim/system/arithm.nim"

#line 327 "/usr/lib/nim/system/arithm.nim"
	result = (NI)((NU64)(a) - (NU64)(b));
#line 328 "/usr/lib/nim/system/arithm.nim"
	{		NIM_BOOL T3_;
#line 328 "/usr/lib/nim/system/arithm.nim"
		T3_ = (NIM_BOOL)0;
#line 328 "/usr/lib/nim/system/arithm.nim"

#line 328 "/usr/lib/nim/system/arithm.nim"
		T3_ = (((NI) 0) <= (NI)(result ^ a));		if (T3_) goto LA4_;
#line 328 "/usr/lib/nim/system/arithm.nim"

#line 328 "/usr/lib/nim/system/arithm.nim"

#line 328 "/usr/lib/nim/system/arithm.nim"
		T3_ = (((NI) 0) <= (NI)(result ^ (NI)((NU64) ~(b))));		LA4_: ;		if (!T3_) goto LA5_;
#line 329 "/usr/lib/nim/system/arithm.nim"
		goto BeforeRet_;	}	LA5_: ;
#line 330 "/usr/lib/nim/system/arithm.nim"
	raiseOverflow();	}BeforeRet_: ;	return result;}


#line 128 "/usr/lib/nim/pure/collections/deques.nim"
N_LIB_PRIVATE N_NIMCALL(void, expandIfNeeded_yUfcbmt639aJ6tr007RgLpQ)(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg* deq) {
	NI cap;	NI TM_NdgYN5HU2ty0qMI5oazWyg_3;	nimfr_("expandIfNeeded", "deques.nim");
#line 129 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(129, "deques.nim");
#line 129 "/usr/lib/nim/pure/collections/deques.nim"
	TM_NdgYN5HU2ty0qMI5oazWyg_3 = addInt((*deq).mask, ((NI) 1));	cap = (NI)(TM_NdgYN5HU2ty0qMI5oazWyg_3);
#line 130 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(130, "deques.nim");	{		NIM_BOOL T3_;		tySequence_WF89a8QyKeDCh4DYWTmSiBg* n;		NI TM_NdgYN5HU2ty0qMI5oazWyg_4;		NI TM_NdgYN5HU2ty0qMI5oazWyg_7;		NI TM_NdgYN5HU2ty0qMI5oazWyg_8;
#line 130 "/usr/lib/nim/pure/collections/deques.nim"

#line 130 "/usr/lib/nim/pure/collections/deques.nim"
		T3_ = (NIM_BOOL)0;		T3_ = unlikely((cap <= (*deq).count));		if (!T3_) goto LA4_;
#line 131 "/usr/lib/nim/pure/collections/deques.nim"
		nimln_(131, "deques.nim");
#line 131 "/usr/lib/nim/pure/collections/deques.nim"
		TM_NdgYN5HU2ty0qMI5oazWyg_4 = mulInt(cap, ((NI) 2));		n = newSeq_FGDbRopuA4y4tNQGp9cEEsg(((NI)chckRange((NI)(TM_NdgYN5HU2ty0qMI5oazWyg_4), ((NI) 0), ((NI) IL64(9223372036854775807)))));		{			NI i;			tyProc_IIomJ6ptE6vfJ5zRbATgkQ x;			tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg colontmp_;			NI i_2;			i = (NI)0;			memset((void*)(&x), 0, sizeof(x));			memset((void*)(&colontmp_), 0, sizeof(colontmp_));
#line 132 "/usr/lib/nim/pure/collections/deques.nim"
			nimln_(132, "deques.nim");			memcpy((void*)(&colontmp_), (NIM_CONST void*)(&(*deq)), sizeof(colontmp_));
#line 112 "/usr/lib/nim/pure/collections/deques.nim"
			nimln_(112, "deques.nim");			i_2 = colontmp_.head;			{				NI c;				NI colontmp__2;				NI i_3;				c = (NI)0;				colontmp__2 = (NI)0;
#line 113 "/usr/lib/nim/pure/collections/deques.nim"
				nimln_(113, "deques.nim");				colontmp__2 = colontmp_.count;
#line 3519 "/usr/lib/nim/system.nim"
				nimln_(3519, "system.nim");				i_3 = ((NI) 0);				{
#line 3520 "/usr/lib/nim/system.nim"
					nimln_(3520, "system.nim");					while (1) {						NI TM_NdgYN5HU2ty0qMI5oazWyg_5;						NI TM_NdgYN5HU2ty0qMI5oazWyg_6;
#line 3520 "/usr/lib/nim/system.nim"
						if (!(i_3 < colontmp__2)) goto LA9;
#line 3521 "/usr/lib/nim/system.nim"
						nimln_(3521, "system.nim");						c = i_3;
#line 114 "/usr/lib/nim/pure/collections/deques.nim"
						nimln_(114, "deques.nim");						i = c;
#line 114 "/usr/lib/nim/pure/collections/deques.nim"
						if ((NU)(i_2) >= (NU)(colontmp_.data->Sup.len)) raiseIndexError();						x.ClE_0 = colontmp_.data->data[i_2].ClE_0;						x.ClP_0 = colontmp_.data->data[i_2].ClP_0;						if ((NU)(i) >= (NU)(n->Sup.len)) raiseIndexError();
#line 133 "/usr/lib/nim/pure/collections/deques.nim"
						nimln_(133, "deques.nim");						asgnRef((void**) (&n->data[i].ClE_0), x.ClE_0);						n->data[i].ClP_0 = x.ClP_0;
#line 115 "/usr/lib/nim/pure/collections/deques.nim"
						nimln_(115, "deques.nim");
#line 115 "/usr/lib/nim/pure/collections/deques.nim"

#line 115 "/usr/lib/nim/pure/collections/deques.nim"
						TM_NdgYN5HU2ty0qMI5oazWyg_5 = addInt(i_2, ((NI) 1));						i_2 = (NI)((NI)(TM_NdgYN5HU2ty0qMI5oazWyg_5) & colontmp_.mask);
#line 3522 "/usr/lib/nim/system.nim"
						nimln_(3522, "system.nim");						TM_NdgYN5HU2ty0qMI5oazWyg_6 = addInt(i_3, ((NI) 1));						i_3 = (NI)(TM_NdgYN5HU2ty0qMI5oazWyg_6);					} LA9: ;				}			}		}
#line 134 "/usr/lib/nim/pure/collections/deques.nim"
		nimln_(134, "deques.nim");		unsureAsgnRef((void**) (&(*deq).data), n);
#line 135 "/usr/lib/nim/pure/collections/deques.nim"
		nimln_(135, "deques.nim");
#line 135 "/usr/lib/nim/pure/collections/deques.nim"

#line 135 "/usr/lib/nim/pure/collections/deques.nim"
		TM_NdgYN5HU2ty0qMI5oazWyg_7 = mulInt(cap, ((NI) 2));		TM_NdgYN5HU2ty0qMI5oazWyg_8 = subInt((NI)(TM_NdgYN5HU2ty0qMI5oazWyg_7), ((NI) 1));		(*deq).mask = (NI)(TM_NdgYN5HU2ty0qMI5oazWyg_8);
#line 136 "/usr/lib/nim/pure/collections/deques.nim"
		nimln_(136, "deques.nim");		(*deq).tail = (*deq).count;
#line 137 "/usr/lib/nim/pure/collections/deques.nim"
		nimln_(137, "deques.nim");		(*deq).head = ((NI) 0);	}	LA4_: ;	popFrame();}


#line 146 "/usr/lib/nim/pure/collections/deques.nim"
N_LIB_PRIVATE N_NIMCALL(void, addLast_vqmMzAk3ZYGwAn5hysAc6w)(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg* deq, tyProc_IIomJ6ptE6vfJ5zRbATgkQ item) {
	NI TM_NdgYN5HU2ty0qMI5oazWyg_9;	NI TM_NdgYN5HU2ty0qMI5oazWyg_10;	nimfr_("addLast", "deques.nim");
#line 148 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(148, "deques.nim");	expandIfNeeded_yUfcbmt639aJ6tr007RgLpQ(deq);
#line 149 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(149, "deques.nim");	TM_NdgYN5HU2ty0qMI5oazWyg_9 = addInt((*deq).count, ((NI) 1));	(*deq).count = (NI)(TM_NdgYN5HU2ty0qMI5oazWyg_9);	if ((NU)((*deq).tail) >= (NU)((*deq).data->Sup.len)) raiseIndexError();
#line 150 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(150, "deques.nim");	asgnRef((void**) (&(*deq).data->data[(*deq).tail].ClE_0), item.ClE_0);	(*deq).data->data[(*deq).tail].ClP_0 = item.ClP_0;
#line 151 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(151, "deques.nim");
#line 151 "/usr/lib/nim/pure/collections/deques.nim"

#line 151 "/usr/lib/nim/pure/collections/deques.nim"
	TM_NdgYN5HU2ty0qMI5oazWyg_10 = addInt((*deq).tail, ((NI) 1));	(*deq).tail = (NI)((NI)(TM_NdgYN5HU2ty0qMI5oazWyg_10) & (*deq).mask);	popFrame();}


#line 49 "/usr/lib/nim/pure/collections/deques.nim"
N_LIB_PRIVATE N_NIMCALL(void, initDeque_ReEIfP39bwVCXJ79bSWPO49aw)(NI initialSize, tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg* Result) {
	NI TM_NdgYN5HU2ty0qMI5oazWyg_12;	nimfr_("initDeque", "deques.nim");	chckNil((void*)Result);	genericReset((void*)Result, (&NTI_lXZKLUMbpAcAUzeVrG09bNg_));
#line 58 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(58, "deques.nim");	{		NIM_BOOL T3_;
#line 58 "/usr/lib/nim/pure/collections/deques.nim"

#line 58 "/usr/lib/nim/pure/collections/deques.nim"
		T3_ = (NIM_BOOL)0;		T3_ = isPowerOfTwo_M0Db9b9cHxuUgw2ZF0P8utPg(initialSize);		if (!!(T3_)) goto LA4_;
#line 58 "/usr/lib/nim/pure/collections/deques.nim"
		failedAssertImpl_aDmpBTs9cPuXp0Mp9cfiNeyA(((NimStringDesc*) &TM_NdgYN5HU2ty0qMI5oazWyg_11));	}	LA4_: ;
#line 59 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(59, "deques.nim");
#line 59 "/usr/lib/nim/pure/collections/deques.nim"
	TM_NdgYN5HU2ty0qMI5oazWyg_12 = subInt(initialSize, ((NI) 1));	(*Result).mask = (NI)(TM_NdgYN5HU2ty0qMI5oazWyg_12);
#line 60 "/usr/lib/nim/pure/collections/deques.nim"
	nimln_(60, "deques.nim");	unsureAsgnRef((void**) (&(*Result).data), (tySequence_WF89a8QyKeDCh4DYWTmSiBg*) newSeq((&NTI_WF89a8QyKeDCh4DYWTmSiBg_), ((NI)chckRange(initialSize, ((NI) 0), ((NI) IL64(9223372036854775807))))));	popFrame();}
NIM_EXTERNC N_NOINLINE(void, stdlib_dequesInit000)(void) {
	nimfr_("deques", "deques.nim");	popFrame();}

NIM_EXTERNC N_NOINLINE(void, stdlib_dequesDatInit000)(void) {
static TNimNode* TM_NdgYN5HU2ty0qMI5oazWyg_2[5];static TNimNode TM_NdgYN5HU2ty0qMI5oazWyg_0[6];NTI_lXZKLUMbpAcAUzeVrG09bNg_.size = sizeof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg);NTI_lXZKLUMbpAcAUzeVrG09bNg_.kind = 18;NTI_lXZKLUMbpAcAUzeVrG09bNg_.base = 0;TM_NdgYN5HU2ty0qMI5oazWyg_2[0] = &TM_NdgYN5HU2ty0qMI5oazWyg_0[1];TM_NdgYN5HU2ty0qMI5oazWyg_0[1].kind = 1;TM_NdgYN5HU2ty0qMI5oazWyg_0[1].offset = offsetof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg, data);TM_NdgYN5HU2ty0qMI5oazWyg_0[1].typ = (&NTI_WF89a8QyKeDCh4DYWTmSiBg_);TM_NdgYN5HU2ty0qMI5oazWyg_0[1].name = "data";TM_NdgYN5HU2ty0qMI5oazWyg_2[1] = &TM_NdgYN5HU2ty0qMI5oazWyg_0[2];TM_NdgYN5HU2ty0qMI5oazWyg_0[2].kind = 1;TM_NdgYN5HU2ty0qMI5oazWyg_0[2].offset = offsetof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg, head);TM_NdgYN5HU2ty0qMI5oazWyg_0[2].typ = (&NTI_rR5Bzr1D5krxoo1NcNyeMA_);TM_NdgYN5HU2ty0qMI5oazWyg_0[2].name = "head";TM_NdgYN5HU2ty0qMI5oazWyg_2[2] = &TM_NdgYN5HU2ty0qMI5oazWyg_0[3];TM_NdgYN5HU2ty0qMI5oazWyg_0[3].kind = 1;TM_NdgYN5HU2ty0qMI5oazWyg_0[3].offset = offsetof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg, tail);TM_NdgYN5HU2ty0qMI5oazWyg_0[3].typ = (&NTI_rR5Bzr1D5krxoo1NcNyeMA_);TM_NdgYN5HU2ty0qMI5oazWyg_0[3].name = "tail";TM_NdgYN5HU2ty0qMI5oazWyg_2[3] = &TM_NdgYN5HU2ty0qMI5oazWyg_0[4];TM_NdgYN5HU2ty0qMI5oazWyg_0[4].kind = 1;TM_NdgYN5HU2ty0qMI5oazWyg_0[4].offset = offsetof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg, count);TM_NdgYN5HU2ty0qMI5oazWyg_0[4].typ = (&NTI_rR5Bzr1D5krxoo1NcNyeMA_);TM_NdgYN5HU2ty0qMI5oazWyg_0[4].name = "count";TM_NdgYN5HU2ty0qMI5oazWyg_2[4] = &TM_NdgYN5HU2ty0qMI5oazWyg_0[5];TM_NdgYN5HU2ty0qMI5oazWyg_0[5].kind = 1;TM_NdgYN5HU2ty0qMI5oazWyg_0[5].offset = offsetof(tyObject_Deque_lXZKLUMbpAcAUzeVrG09bNg, mask);TM_NdgYN5HU2ty0qMI5oazWyg_0[5].typ = (&NTI_rR5Bzr1D5krxoo1NcNyeMA_);TM_NdgYN5HU2ty0qMI5oazWyg_0[5].name = "mask";TM_NdgYN5HU2ty0qMI5oazWyg_0[0].len = 5; TM_NdgYN5HU2ty0qMI5oazWyg_0[0].kind = 2; TM_NdgYN5HU2ty0qMI5oazWyg_0[0].sons = &TM_NdgYN5HU2ty0qMI5oazWyg_2[0];NTI_lXZKLUMbpAcAUzeVrG09bNg_.node = &TM_NdgYN5HU2ty0qMI5oazWyg_0[0];}

