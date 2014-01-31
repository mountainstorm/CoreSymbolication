//
//  CoreSymbolication.m
//  CoreSymbolication
//
//  Created by R J Cooper on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreSymbolication.h"
#import "../../CoreSymbolication/CoreSymbolication.h"
#import <mach/mach.h>


#define kExtensionName		"Sandbox"
#define kExtensionPath		"/System/Library/Extensions/" kExtensionName ".kext/Contents/MacOS/" kExtensionName
#define kExtensionSymbol	"hook_policy_syscall"


@implementation CoreSymbolication

- (void)setUp
{
	[super setUp];

	// Set-up code here.
}

- (void)tearDown
{
	// Tear-down code here.

	[super tearDown];
}

// Testcases

/*
 * Architecture functions
 */
- (void)testCSArchitectureGetArchitectureForName
{
	STAssertEquals(CSArchitectureGetArchitectureForName("i386"), CPU_TYPE_I386, @"CSArchitectureGetArchitectureForName: i386 != CPU_TYPE_I386");
}

- (void)testCSArchitectureGetCurrent
{
	STAssertEquals(CSArchitectureGetCurrent(), CPU_TYPE_X86_64, @"CSArchitectureGetCurrent != CPU_TYPE_X86_64");
}

- (void)testCSArchitectureGetFamily
{
	STAssertEquals(CSArchitectureGetFamily(CPU_TYPE_I386), CPU_TYPE_I386, @"CSArchitectureGetFamily: CPU_TYPE_I386 != CPU_TYPE_I386");
}

- (void)testCSArchitectureGetFamilyName
{
	STAssertTrue(strcmp(CSArchitectureGetFamilyName(CPU_TYPE_X86_64), "x86_64") == 0, @"CSArchitectureGetFamilyName: x86_64 != x86_64");
}

- (void)testCSArchitectureIs
{
	STAssertTrue(CSArchitectureIs32Bit(CPU_TYPE_I386), @"CSArchitectureIs32Bit: CPU_TYPE_I386 != True");
	STAssertFalse(CSArchitectureIs32Bit(CPU_TYPE_X86_64), @"CSArchitectureIs32Bit: CPU_TYPE_X86_64 != False");
	
	STAssertTrue(CSArchitectureIs64Bit(CPU_TYPE_X86_64), @"CSArchitectureIs64Bit: CPU_TYPE_X86_64 != True");
	STAssertFalse(CSArchitectureIs64Bit(CPU_TYPE_I386), @"CSArchitectureIs64Bit: CPU_TYPE_I386 != False");
	
	STAssertTrue(CSArchitectureIsArm(CPU_TYPE_ARM), @"CSArchitectureIsArm: CPU_TYPE_ARM != True");
	STAssertFalse(CSArchitectureIsArm(CPU_TYPE_I386), @"CSArchitectureIsArm: CPU_TYPE_I386 != False");

	STAssertTrue(CSArchitectureIsBigEndian(CPU_TYPE_POWERPC), @"CSArchitectureIsBigEndian: CPU_TYPE_POWERPC != True");
	STAssertFalse(CSArchitectureIsBigEndian(CPU_TYPE_I386), @"CSArchitectureIsBigEndian: CPU_TYPE_I386 != False");

	STAssertTrue(CSArchitectureIsI386(CPU_TYPE_I386), @"CSArchitectureIsI386: CPU_TYPE_I386 != True");
	STAssertFalse(CSArchitectureIsI386(CPU_TYPE_ARM), @"CSArchitectureIsI386: CPU_TYPE_ARM != False");

	STAssertTrue(CSArchitectureIsLittleEndian(CPU_TYPE_I386), @"CSArchitectureIsLittleEndian: CPU_TYPE_I386 != True");
	STAssertFalse(CSArchitectureIsLittleEndian(CPU_TYPE_POWERPC), @"CSArchitectureIsLittleEndian: CPU_TYPE_POWERPC != False");

	STAssertTrue(CSArchitectureIsPPC(CPU_TYPE_POWERPC), @"CSArchitectureIsPPC: CPU_TYPE_POWERPC != True");
	STAssertFalse(CSArchitectureIsPPC(CPU_TYPE_I386), @"CSArchitectureIsPPC: CPU_TYPE_I386 != False");

	STAssertTrue(CSArchitectureIsPPC64(CPU_TYPE_POWERPC64), @"CSArchitectureIsPPC64: CPU_TYPE_POWERPC64 != True");
	STAssertFalse(CSArchitectureIsPPC64(CPU_TYPE_I386), @"CSArchitectureIsPPC64: CPU_TYPE_I386 != False");

	STAssertTrue(CSArchitectureIsX86_64(CPU_TYPE_X86_64), @"CSArchitectureIsX86_64: CPU_TYPE_X86_64 != True");
	STAssertFalse(CSArchitectureIsX86_64(CPU_TYPE_I386), @"CSArchitectureIsX86_64: CPU_TYPE_I386 != False");
}

- (void)testCSArchitectureMatchesArchitecture
{
	STAssertTrue(CSArchitectureMatchesArchitecture(CPU_TYPE_I386, CPU_TYPE_I386), @"CSArchitectureMatchesArchitecture: CPU_TYPE_I386 != CPU_TYPE_I386");
	STAssertFalse(CSArchitectureMatchesArchitecture(CPU_TYPE_X86_64, CPU_TYPE_I386), @"CSArchitectureMatchesArchitecture: CPU_TYPE_X86_64 == CPU_TYPE_I386");
}
/*
- (void)testCSCopyDescription
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CFShow(CSCopyDescription(test));
	CFShow(CSCopyDescriptionWithIndent(test, 2));
	CSShow(test);
	CSRelease(test);
}
*/
- (void)testCSEqual
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertTrue(CSEqual(test, test), @"CSEqual True != True");
	STAssertFalse(CSEqual(test, CSSymbolicatorCreateWithMachKernel()), @"CSEqual False != False");
	CSRelease(test);
}

- (void)testCSGetRetainCount
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertEquals(CSGetRetainCount(test), (CFIndex) 1, @"CSGetRetainCount != 1");
	CSRetain(test);
	STAssertEquals(CSGetRetainCount(test), (CFIndex) 2, @"CSGetRetainCount != 2");
	CSRelease(test);
}

- (void)testCSIsNull
{
	CSSymbolicatorRef test = kCSNull;
	STAssertTrue(CSIsNull(test), @"is not null");
	test = CSSymbolicatorCreateWithMachKernel();
	STAssertFalse(CSIsNull(test), @"is null");
	CSRelease(test);
}
/*
- (void)testCSGetDyld
{
	printf("CSGetDyldSharedCacheSlide: %lx\n", CSGetDyldSharedCacheSlide(mach_task_self()));
	CFUUIDRef uuid = CSGetDyldSharedCacheUUID(mach_task_self());
	CFShow(uuid);
	CFRelease(uuid);
}
*/
- (void)testCSRange
{
	CSRange r1 = {0, 100};
	CSRange r2 = {50, 20};
	CSRange r3 = {80, 50};
	CSRange r4 = {120, 50};
	
	STAssertTrue(CSRangeContainsRange(r1, r2), @"CSRangeContainsRange r1/r2 != True");
	STAssertFalse(CSRangeContainsRange(r1, r3), @"CSRangeContainsRange r1/r3 != False");
	STAssertFalse(CSRangeContainsRange(r1, r4), @"CSRangeContainsRange r1/r4 != False");

	STAssertTrue(CSRangeIntersectsRange(r1, r2), @"CSRangeIntersectsRange r1/r2 != True");
	STAssertTrue(CSRangeIntersectsRange(r1, r3), @"CSRangeIntersectsRange r1/r3 != False");
	STAssertFalse(CSRangeIntersectsRange(r1, r4), @"CSRangeIntersectsRange r1/r4 != False");
}


/*
 * Symbolicator functions
 */
- (void)testCSSymbolicatorCreateSignature
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CFDataRef data = CSSymbolicatorCreateSignature(test);
	STAssertTrue(data != NULL, @"CSSymbolicatorCreateSignature == NULL");
	CFRelease(data);
	CSRelease(test);
}

- (void)testCSSymbolicatorCreateWithPathAndArchitecture
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPathAndArchitecture("/mach_kernel", CPU_TYPE_ANY);
	STAssertFalse(CSIsNull(test), @"CSSymbolicatorCreateWithPathAndArchitecture failed");
	CSRelease(test);
}

- (void)testCSSymbolicatorCreateWithPid
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertFalse(CSIsNull(test), @"CSSymbolicatorCreateWithPid failed");
	CSRelease(test);
}

- (void)testCSSymbolicatorCreateWithSignature
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CFDataRef data = CSSymbolicatorCreateSignature(test);
	STAssertTrue(data != NULL, @"CSSymbolicatorCreateSignature == NULL");
	CSRelease(test);
	
	CSSymbolicatorRef test1 = CSSymbolicatorCreateWithSignature(data);
	STAssertFalse(CSIsNull(test1), @"CSSymbolicatorCreateWithSignature failed");
	CFRelease(data);
	CSRelease(test1);
}

- (void)testCSSymbolicatorCreateWithTask
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithTask(mach_task_self());
	STAssertFalse(CSIsNull(test), @"CSSymbolicatorCreateWithTask failed");
	CSRelease(test);
}

- (void)testCSSymbolicatorCreateWithURLAndArchitecture
{
	const char* mk = "/mach_kernel";
	CFURLRef url = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, (const UInt8*) mk, strlen(mk), NO);
	CSSymbolicatorRef test = CSSymbolicatorCreateWithURLAndArchitecture(url, CPU_TYPE_ANY);
	STAssertFalse(CSIsNull(test), @"CSSymbolicatorCreateWithTask failed");
	CSRelease(test);
	CFRelease(url);
}

- (void)testCSSymbolicatorForceFullSymbolExtraction
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertEquals(CSSymbolicatorForceFullSymbolExtraction(test), (int) 1, @"CSSymbolicatorForceFullSymbolExtraction failed");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachRegionAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionAtTime(test, kCSNow, ^(CSRegionRef region) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachRegionAtTime, no regions found");
	CSRelease(test);
}


- (void)testCSSymbolicatorForeachRegionWithNameAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__DATA __bss", kCSNow, ^(CSRegionRef region) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachRegionWithNameAtTime, no regions found");
	CSRelease(test);
}

/*
 - (void)testCSSymbolicatorForeachSectionAtTime
 {
 __block unsigned int i = 0;
 CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
 CSSymbolicatorForeachSectionAtTime(test, kCSNow, ^(CSSectionRef section) {
 i++;
 });
 STAssertTrue(i > 0, @"CSSymbolicatorForeachSectionAtTime, no sections found");
 CSRelease(test);
 }
 
 - (void)testCSSymbolicatorForeachSegmentAtTime
 {
 __block unsigned int i = 0;
 CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
 CSSymbolicatorForeachSegmentAtTime(test, kCSNow, ^(CSSegmentRef segment) {
 i++;
 });
 STAssertTrue(i > 0, @"CSSymbolicatorForeachSegmentAtTime, no sections found");
 CSRelease(test);
 }
 */
- (void)testCSSymbolicatorForeachSourceInfoAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachSourceInfoAtTime(test, kCSNow, ^(CSSourceInfoRef info) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSourceInfoAtTime, no info's found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachSymbolAtTime(test, kCSNow, ^(CSSymbolRef sym) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSymbolAtTime, no symbols found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolOwnerAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachSymbolOwnerAtTime(test, kCSNow, ^(CSSymbolOwnerRef owner) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSymbolOwnerAtTime, no symbol owners found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolOwnerWithNameAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolicatorForeachSymbolOwnerWithNameAtTime(test, kExtensionName, kCSNow, ^(CSSymbolOwnerRef owner) {
		i++;
		return 0;
	});
	STAssertTrue(i == 1, @"CSSymbolicatorForeachSymbolOwnerWithNameAtTime, no symbol owners found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolOwnerWithPathAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolicatorForeachSymbolOwnerWithPathAtTime(test, kExtensionPath, kCSNow, ^(CSSymbolOwnerRef owner) {
		i++;
		return 0;
	});
	STAssertTrue(i == 1, @"CSSymbolicatorForeachSymbolOwnerWithPathAtTime, no symbol owners found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolWithMangledNameAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolicatorForeachSymbolWithMangledNameAtTime(test, "_" kExtensionSymbol, kCSNow, ^(CSSymbolRef syn) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSymbolWithMangledNameAtTime, no symbol found");
	CSRelease(test);
}

- (void)testCSSymbolicatorForeachSymbolWithNameAtTime
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolicatorForeachSymbolWithNameAtTime(test, kExtensionSymbol, kCSNow, ^(CSSymbolRef syn) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSymbolWithNameAtTime, no symbol found");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetAOutSymbolOwner
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertTrue(CSIsNull(CSSymbolicatorGetAOutSymbolOwner(test)) == NO, @"CSSymbolicatorGetAOutSymbolOwner: no symbol owner found");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetArchitecture
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertEquals(CSSymbolicatorGetArchitecture(test), CSArchitectureGetCurrent(), @"CSSymbolicatorGetArchitecture: incorrect result");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetDyldAllImageInfosAddress
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorGetDyldAllImageInfosAddress(test), @"CSSymbolicatorGetDyldAllImageInfosAddress nil");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetPid
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertEquals(CSSymbolicatorGetPid(test), getpid(), @"CSSymbolicatorGetPid didn't match");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetRegionCountAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorGetRegionCountAtTime(test, kCSNow) > 0, @"CSSymbolicatorGetRegionCountAtTime returned zero");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetRegionWithAddressAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "CSSymbolicatorGetSymbolWithNameAtTime", kCSNow);
	vm_address_t addr = CSSymbolGetRange(sym).location;
	CSRegionRef region = CSSymbolicatorGetRegionWithAddressAtTime(test, addr, kCSNow);
	STAssertFalse(CSIsNull(region), @"CSSymbolicatorGetRegionWithAddressAtTime returned zero");
	CSRelease(region);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetRegionWithNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSRegionRef region = CSSymbolicatorGetRegionWithNameAtTime(test, "__DATA __bss", kCSNow);
	STAssertFalse(CSIsNull(region), @"CSSymbolicatorGetRegionWithNameAtTime returned zero");
	CSRelease(region);
	CSRelease(test);
}
/*
- (void)testCSSymbolicatorGetSectionWithAddressAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "CSSymbolicatorGetSymbolWithNameAtTime", kCSNow);
	vm_address_t addr = CSSymbolGetRange(sym).location;
	CSSectionRef section = CSSymbolicatorGetSectionWithAddressAtTime(test, addr, kCSNow);
	STAssertFalse(CSIsNull(section), @"CSSymbolicatorGetSectionWithAddressAtTime returned zero");
	CSRelease(section);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSegmentWithAddressAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "CSSymbolicatorGetSymbolWithNameAtTime", kCSNow);
	vm_address_t addr = CSSymbolGetRange(sym).location;
	CSSegmentRef seg = CSSymbolicatorGetSegmentWithAddressAtTime(test, addr, kCSNow);
	STAssertFalse(CSIsNull(seg), @"CSSymbolicatorGetSegmentWithAddressAtTime returned zero");
	CSRelease(seg);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSharedCacheSlide
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorGetSharedCacheSlide(test) != 0, @"CSSymbolicatorGetSharedCacheSlide returned zero");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSharedCacheUUID
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSUUIDRef uuid = CSSymbolicatorGetSharedCacheUUID(test);
	STAssertFalse(CSIsNull(uuid), @"CSSymbolicatorGetSharedCacheUUID returned zero");
	CSRelease(uuid);
	CSRelease(test);
}
*/
- (void)testCSSymbolicatorGetSourceInfoCountAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorGetSourceInfoCountAtTime(test, kCSNow) > 0, @"CSSymbolicatorGetSourceInfoCountAtTime returned zero");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSourceInfoWithAddressAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	vm_address_t addr = CSSymbolGetRange(sym).location;
	CSSourceInfoRef info = CSSymbolicatorGetSourceInfoWithAddressAtTime(test, addr, kCSNow);
	STAssertFalse(CSIsNull(info), @"CSSymbolicatorGetSourceInfoWithAddressAtTime returned zero");
	CSRelease(info);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolCountAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorGetSymbolCountAtTime(test, kCSNow) > 0, @"CSSymbolicatorGetSymbolCountAtTime returned zero");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolOwner
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolOwnerRef owner = CSSymbolicatorGetSymbolOwner(test);
	STAssertFalse(CSIsNull(owner), @"CSSymbolicatorGetSymbolOwner returned zero");
	CSRelease(owner);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolOwnerCountAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	STAssertTrue(CSSymbolicatorGetSymbolOwnerCountAtTime(test, kCSNow) > 0, @"CSSymbolicatorGetSymbolOwnerCountAtTime returned zero");
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolOwnerWithAddressAtTime
{
	__block CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolicatorForeachSymbolOwnerAtTime(test, kCSNow, ^(CSSymbolOwnerRef owner) {
		CSSymbolOwnerRef o = CSSymbolicatorGetSymbolOwnerWithAddressAtTime(test, CSSymbolOwnerGetBaseAddress(owner), kCSNow);
		STAssertFalse(CSIsNull(o), @"CSSymbolicatorGetSymbolOwnerWithAddressAtTime is null");
		return 1;
	});
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolOwnerWithNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolOwnerRef owner = CSSymbolicatorGetSymbolOwnerWithNameAtTime(test, kExtensionName, kCSNow);
	STAssertFalse(CSIsNull(owner), @"CSSymbolicatorGetSymbolOwnerWithNameAtTime failed");
	CSRelease(owner);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolWithAddressAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	CSRange range = CSSymbolGetRange(sym);
	CSSymbolRef foundSymbol = CSSymbolicatorGetSymbolWithAddressAtTime(test, range.location, kCSNow);
	STAssertFalse(CSIsNull(foundSymbol), @"CSSymbolicatorGetSymbolWithAddressAtTime failed");
	CSRelease(sym);
	CSRelease(foundSymbol);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolWithMangledNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithMangledNameAtTime(test, "_bcopy", kCSNow);
	STAssertFalse(CSIsNull(sym), @"CSSymbolicatorGetSymbolWithMangledNameAtTime failed");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolWithMangledNameFromSymbolOwnerWithNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolOwnerRef owner = CSSymbolicatorGetSymbolOwnerWithNameAtTime(test, kExtensionName, kCSNow);
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithMangledNameFromSymbolOwnerWithNameAtTime(test, owner, "_bcopy", kCSNow);
	STAssertFalse(CSIsNull(sym), @"CSSymbolicatorGetSymbolWithMangledNameFromSymbolOwnerWithNameAtTime failed");
	CSRelease(sym);
	CSRelease(owner);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolWithNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	STAssertFalse(CSIsNull(sym), @"CSSymbolicatorGetSymbolWithNameAtTime failed");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetSymbolWithNameFromSymbolOwnerWithNameAtTime
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolOwnerRef owner = CSSymbolicatorGetSymbolOwnerWithNameAtTime(test, kExtensionName, kCSNow);
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameFromSymbolOwnerWithNameAtTime(test, owner, "bcopy", kCSNow);
	STAssertFalse(CSIsNull(sym), @"CSSymbolicatorGetSymbolWithNameFromSymbolOwnerWithNameAtTime failed");
	CSRelease(sym);
	CSRelease(owner);
	CSRelease(test);
}

- (void)testCSSymbolicatorGetTask
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	mach_port_t task = CSSymbolicatorGetTask(test);
	STAssertTrue(task != MACH_PORT_NULL, @"CSSymbolicatorGetTask failed");
	CSRelease(test);
}

- (void)testCSSymbolicatorIsKernelSymbolicator
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertFalse(CSSymbolicatorIsKernelSymbolicator(test), @"CSSymbolicatorIsKernelSymbolicator wrong?");
	CSRelease(test);

	CSSymbolicatorRef test1 = CSSymbolicatorCreateWithMachKernel();
	STAssertTrue(CSSymbolicatorIsKernelSymbolicator(test1), @"CSSymbolicatorIsKernelSymbolicator wrong?");
	CSRelease(test1);
}

- (void)testCSSymbolicatorIsTaskTranslated
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertFalse(CSSymbolicatorIsTaskTranslated(test), @"CSSymbolicatorIsTaskTranslated wrong");
	CSRelease(test);
}

- (void)testCSSymbolicatorIsTaskValid
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	STAssertTrue(CSSymbolicatorIsTaskValid(test), @"CSSymbolicatorIsTaskValid wrong");
	CSRelease(test);
}


/*
 * XXX: SymbolOwner tests
 */



/*
 * Symbol tests
 */
- (void)testCSSymbolForeachSourceInfo
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	
	__block int i = 0;
	CSSymbolForeachSourceInfo(sym, ^(CSSourceInfoRef info) {
		i++;
		return 0;
	});
	STAssertTrue(i > 0, @"CSSymbolForeachSourceInfo returned zero");
	
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetInstructionData
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	// XXX: CSSymbolGetInstructionData(sym);
//	STAssertTrue(i > 0, @"CSSymbolGetInstructionData returned zero");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetMangledName
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	STAssertTrue(strcmp(CSSymbolGetMangledName(sym), "_bcopy") == 0, @"CSSymbolGetMangledName failed");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetName
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	STAssertTrue(strcmp(CSSymbolGetName(sym), "bcopy") == 0, @"CSSymbolGetName failed");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetRange
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	STAssertTrue(CSSymbolGetRange(sym).location != 0, @"CSSymbolGetRange failed");
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetRegion
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	CSRegionRef region = CSSymbolGetRegion(sym);
	STAssertFalse(CSIsNull(region), @"CSSymbolGetRegion failed");
	CSRelease(region);
	CSRelease(sym);
	CSRelease(test);
}
/*
- (void)testCSSymbolGetSection
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	CSSectionRef sect = CSSymbolGetSection(sym);
	STAssertFalse(CSIsNull(sect), @"CSSymbolGetSection failed");
	CSRelease(sect);
	CSRelease(sym);
	CSRelease(test);
}

 - (void)testCSSymbolGetSection
 {
 CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
 CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
 CSSegmentRef seg = CSSymbolGetSegment(sym);
 STAssertFalse(CSIsNull(seg), @"CSSymbolGetSegment failed");
 CSRelease(seg);
 CSRelease(sym);
 CSRelease(test);
 }
 */
- (void)testCSSymbolGetSymbolOwner
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	CSSymbolOwnerRef owner = CSSymbolGetSymbolOwner(sym);
	STAssertFalse(CSIsNull(owner), @"CSSymbolGetSymbolOwner failed");
	CSRelease(owner);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolGetSymbolicator
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	CSSymbolicatorRef test1 = CSSymbolGetSymbolicator(sym);
	STAssertFalse(CSIsNull(test1), @"CSSymbolGetSymbolicator failed");
	CSRelease(test1);
	CSRelease(sym);
	CSRelease(test);
}

- (void)testCSSymbolIs
{
	CSSymbolicatorRef test = CSSymbolicatorCreateWithMachKernel();
	CSSymbolRef sym = CSSymbolicatorGetSymbolWithNameAtTime(test, "bcopy", kCSNow);
	STAssertTrue(CSSymbolIsArm(sym), @"CSSymbolIsArm false");
	STAssertFalse(CSSymbolIsDebugMap(sym), @"CSSymbolIsDebugMap false");
	STAssertFalse(CSSymbolIsDwarf(sym), @"CSSymbolIsDwarf false");
	STAssertFalse(CSSymbolIsDyldStub(sym), @"CSSymbolIsDyldStub false");
	STAssertTrue(CSSymbolIsExternal(sym), @"CSSymbolIsExternal false");
	STAssertFalse(CSSymbolIsFunction(sym), @"CSSymbolIsFunction false");
	STAssertFalse(CSSymbolIsFunctionStarts(sym), @"CSSymbolIsFunctionStarts false");
	STAssertFalse(CSSymbolIsKnownLength(sym), @"CSSymbolIsKnownLength false");
	STAssertFalse(CSSymbolIsMangledNameSourceDwarf(sym), @"CSSymbolIsMangledNameSourceDwarf false");
	STAssertFalse(CSSymbolIsMangledNameSourceDwarfMIPSLinkage(sym), @"CSSymbolIsMangledNameSourceDwarfMIPSLinkage false");
	STAssertTrue(CSSymbolIsMangledNameSourceNList(sym), @"CSSymbolIsMangledNameSourceNList false");
	STAssertFalse(CSSymbolIsMerged(sym), @"CSSymbolIsMerged false");
	STAssertTrue(CSSymbolIsNList(sym), @"CSSymbolIsNList false");
	STAssertFalse(CSSymbolIsNameSourceDwarf(sym), @"CSSymbolIsNameSourceDwarf false");
	STAssertFalse(CSSymbolIsNameSourceDwarfMIPSLinkage(sym), @"CSSymbolIsNameSourceDwarfMIPSLinkage false");
	STAssertTrue(CSSymbolIsNameSourceNList(sym), @"CSSymbolIsNameSourceNList false");
	STAssertFalse(CSSymbolIsObjcMethod(sym), @"CSSymbolIsObjcMethod false");
	STAssertFalse(CSSymbolIsOmitFramePointer(sym), @"CSSymbolIsOmitFramePointer false");
	STAssertFalse(CSSymbolIsPrivateExternal(sym), @"CSSymbolIsPrivateExternal false");
	STAssertFalse(CSSymbolIsThumb(sym), @"CSSymbolIsThumb false");
	STAssertFalse(CSSymbolIsUnnamed(sym), @"CSSymbolIsUnnamed false");
	CSRelease(sym);
	CSRelease(test);
}


/*
 * SourceInfo tests
 */
/*
- (void)testCSSourceInfo
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachSourceInfoAtTime(test, kCSNow, ^(CSSourceInfoRef info) {
		printf("column: %u\n", CSSourceInfoGetColumn(info));
		printf("filename: %s\n", CSSourceInfoGetFilename(info));
		printf("line number: %u\n", CSSourceInfoGetLineNumber(info));
		printf("path: %s\n", CSSourceInfoGetPath(info));
		i++;
		return 0;
	});
	printf("!@!!!!: %x\n", i);
	STAssertTrue(i > 0, @"CSSymbolicatorForeachSourceInfoAtTime, no info's found");
	CSRelease(test);
}
*/














/*
 * Region tests
 */
- (void)testCSRegionForeachSourceInfo
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		CSRegionForeachSourceInfo(region, ^(CSSourceInfoRef sourceInfo) {
			i++;
			return 0;
		});
		return 0;
	});
	STAssertTrue(i > 0, @"CSRegionForeachSourceInfo, no regions found");
	CSRelease(test);
}

- (void)testCSRegionForeachSymbol
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		CSRegionForeachSymbol(region, ^(CSSourceInfoRef sourceInfo) {
			i++;
			return 0;
		});
		return 0;
	});
	STAssertTrue(i > 0, @"CSRegionForeachSymbol, no regions found");
	CSRelease(test);
}

- (void)testCSRegionGetName
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		if (CSRegionGetName(region) != NULL) {
			i++;
		}
		return 0;
	});
	STAssertTrue(i > 0, @"CSRegionGetName, no regions found");
	CSRelease(test);
}

- (void)testCSRegionGetRange
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		if (CSRegionGetRange(region).length != 0) {
			i++;
		}
		return 0;
	});
	STAssertTrue(i > 0, @"CSRegionGetRange, no regions found");
	CSRelease(test);
}
/* XXX
- (void)testCSRegionGetSymbolOwner
{
	__block unsigned int i = 0;
	CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		if (CSRegionGetSymbolOwner(region) != NULL) {
			i++;
		}
	});
	STAssertTrue(i > 0, @"CSRegionGetSymbolOwner, no regions found");
	CSRelease(test);
}
*/
- (void)testCSRegionGetSymbolicator
{
	__block unsigned int i = 0;
	__block CSSymbolicatorRef test = CSSymbolicatorCreateWithPid(getpid());
	CSSymbolicatorForeachRegionWithNameAtTime(test, "__TEXT __text", kCSNow, ^(CSRegionRef region) {
		if (CSEqual(CSRegionGetSymbolicator(region), test)) {
			i++;
		}
		return 0;
	});
	STAssertTrue(i > 0, @"CSRegionGetSymbolicator, no regions found");
	CSRelease(test);
}























/*


- (void)testCSSymbolOwnerGetPath
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator: &symbolicator andOwner: &owner];
	
	if (CSSymbolOwnerGetPath(owner) && CSSymbolOwnerGetName(owner)) {
		STAssertTrue(strcmp(CSSymbolOwnerGetPath(owner), kExtensionPath) == 0, @"path incorrect");
		STAssertTrue(strcmp(CSSymbolOwnerGetName(owner), kExtensionName) == 0, @"name incorrect");
	}
	
	CSRelease(symbolicator);	
}

- (void)testCSSymbolOwnerGetArchitecture
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator: &symbolicator andOwner: &owner];
	
	// TODO: calculate this arch to compare against
	if (CSIsNull(owner) == false) {
		STAssertEquals(CSSymbolOwnerGetArchitecture(owner), CPU_TYPE_X86_64, @"cpu architecture incorrect");
	}
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolOwnerGetRegionWithName
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator: &symbolicator andOwner: &owner];

	CSRegionRef region = CSSymbolOwnerGetRegionWithName(owner, "__TEXT __text");
	STAssertTrue(region.csCppData != 0, @"region.csCppData == nil");	
	STAssertTrue(region.csCppObj != NULL, @"region.csCppObj == nil");	
	if (CSRegionGetName(region)) {
		STAssertTrue(strcmp(CSRegionGetName(region), "__TEXT __text") == 0, @"invalid region name");
	}
	
	CSRelease(symbolicator);
}



- (void)testCSSymbolicatorForeachSymbolOwnerWithFlagsAtTime
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerWithFlagsAtTime(symbolicator, kCSSymbolOwnerIsAOut, kCSNow, ^(CSSymbolOwnerRef owner) {
		// nothing to do
	}) > 0,  @"no symbol owners in kernel; thats unlikley");
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolicatorGetSymbolOwnerWithAddressAtTime
{
	__block CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerAtTime(symbolicator, kCSNow, ^(CSSymbolOwnerRef owner) {
		
		CSSymbolOwnerRef ownerFromAddr = CSSymbolicatorGetSymbolOwnerWithAddressAtTime(symbolicator, 
																					   CSSymbolOwnerGetBaseAddress(owner), 
																					   kCSNow);
		STAssertTrue(owner.csCppData == ownerFromAddr.csCppData && owner.csCppObj == ownerFromAddr.csCppObj,
					 @"symbol owner not being return correctly - should be same object");
	}) > 0, @"no symbol owners in kernel; thats unlikley");
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolOwnerGetSymbolWithName
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator:&symbolicator andOwner:&owner];
	
	CSSymbolRef symbol = CSSymbolOwnerGetSymbolWithName(owner, "hook_policy_syscall");
	STAssertTrue(symbol.csCppData != NULL, @"symbol.csCppData == NULL");
	STAssertTrue(symbol.csCppObj != NULL, @"symbol.csCppObj == NULL");	
	
	symbol = CSSymbolOwnerGetSymbolWithName(owner, "_hook_policy_syscall");
	STAssertFalse(symbol.csCppData != NULL, @"symbol.csCppData != NULL");
	STAssertFalse(symbol.csCppObj != NULL, @"symbol.csCppObj != NULL");	
	
	CSRelease(symbolicator);
}



- (void)testCSSymbolOwnerForeachSymbol
{
	CSSymbolicatorRef symbolicator = kCSNull;
	__block CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator:&symbolicator andOwner:&owner];
	
	__block size_t seenExternal = 0;
	__block size_t seenNotExternal = 0;
	__block size_t seenFunction = 0;
	__block size_t seenNotFunction = 0;
	__block size_t seenUnnamed = 0;
	__block size_t seenNotUnnamed = 0;
	
	STAssertTrue(CSSymbolOwnerForeachSymbol(owner, ^(CSSymbolRef symbol) {
		
		STAssertFalse(CSIsNull(symbol), @"Symbol is null");
		CSSymbolIsExternal(symbol) ? (seenExternal++): (seenNotExternal++);
		CSSymbolIsFunction(symbol) ? (seenFunction++): (seenNotFunction++);
		CSSymbolIsUnnamed(symbol) ? (seenUnnamed++): (seenNotUnnamed++);
		
		CSSymbolOwnerRef symbolOwner = CSSymbolGetSymbolOwner(symbol);
		STAssertTrue(owner.csCppData == symbolOwner.csCppData && owner.csCppObj == symbolOwner.csCppObj,
					 @"symbol owner not being return correctly - should be same object");
		
	}) > 0, @"no symbols in owner; very unlikley");
	
	STAssertTrue(	 (seenExternal > 0)
				  && (seenNotExternal > 0)
				  && (seenFunction > 0)
				  && (seenNotFunction > 0)
				  && (seenUnnamed == 0)
				  && (seenNotUnnamed > 0), @"Incorrect symbol type count: %lu, %lu, %lu, %lu, %lu, %lu\n", seenExternal, seenNotExternal, seenFunction, seenNotFunction, seenUnnamed, seenNotUnnamed);
	
	CSRelease(symbolicator);	
}

- (void)testCSSymbolGetName
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolRef symbol = kCSNull;
	[self getCSSymbolicator:&symbolicator andSymbol:&symbol];
	
	if (CSSymbolGetName(symbol) && CSSymbolGetMangledName(symbol)) {
		STAssertTrue(	 (strcmp(CSSymbolGetName(symbol), "hook_policy_syscall") == 0)
					  && (strcmp(CSSymbolGetMangledName(symbol), "_hook_policy_syscall") == 0),
					 @"invalid symbol names returned");
	}
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolGetRange
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolRef symbol = kCSNull;
	[self getCSSymbolicator:&symbolicator andSymbol:&symbol];
	
	CSRange range = CSSymbolGetRange(symbol);
	STAssertTrue(range.length != 0, @"symbol length wrong");
	STAssertTrue(range.location != 0, @"symbol location wrong");
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolicatorGetSymbolWithAddressAtTime
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolRef symbol = kCSNull;
	[self getCSSymbolicator:&symbolicator andSymbol:&symbol];

	CSRange range = CSSymbolGetRange(symbol);
	CSSymbolRef foundSymbol = CSSymbolicatorGetSymbolWithAddressAtTime(symbolicator, range.location, kCSNow);
	STAssertTrue(symbol.csCppData == foundSymbol.csCppData && symbol.csCppObj == foundSymbol.csCppObj,
				 @"symbol not being return correctly - should be same object");

	CSRelease(symbolicator);
}

- (void)testCSSymbolOwnerGetSymbolWithAddress
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	CSSymbolRef symbol = kCSNull;
	[self getCSSymbolicator:&symbolicator andOwner:&owner];
	symbol = CSSymbolOwnerGetSymbolWithName(owner, "hook_policy_syscall");
	
	CSRange range = CSSymbolGetRange(symbol);
	CSSymbolRef foundSymbol = CSSymbolOwnerGetSymbolWithAddress(owner, range.location);
	STAssertTrue(symbol.csCppData == foundSymbol.csCppData && symbol.csCppObj == foundSymbol.csCppObj,
				 @"symbol not being return correctly - should be same object");
	
	CSRelease(symbolicator);
}
*/
- (void)testCSSymbolicatorCreateWithTaskFlagsAndNotification
{
	pid_t pid = getpid();
	//printf("pid: %d\n", pid);
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithTaskFlagsAndNotification(mach_task_self(),
																					  kCSSymbolicatorTrackDyldActivity,
																					  ^(uint32_t notification_type, CSNotificationData data) {
		switch (notification_type) {
			case kCSNotificationPing:
				//printf("kCSNotificationPing, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
				
			case kCSNotificationInitialized:
				//printf("kCSNotificationInitialized, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
				
			case kCSNotificationDyldLoad:
				//printf("kCSNotificationDyldLoad, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
				
			case kCSNotificationDyldUnload:
				//printf("kCSNotificationDyldUnload, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
				
			case kCSNotificationTimeout:
				//printf("kCSNotificationTimeout, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
				
			case kCSNotificationTaskExit:
				//printf("kCSNotificationTaskExit, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
			
			case kCSNotificationFini:
				//printf("kCSNotificationFini, pid: %d\n", CSSymbolicatorGetPid(data.symbolicator));
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;				
			
			default:
				//printf("default\n");
				STAssertEquals(pid, CSSymbolicatorGetPid(data.symbolicator), @"pids dont match");
				break;
		}
		return 0;
	});
	CSRelease(symbolicator);
}

@end
