//
//  CoreSymbolication.m
//  CoreSymbolication
//
//  Created by R J Cooper on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreSymbolication.h"
#import "../../CoreSymbolication/CoreSymbolication.h"



#define kSandboxPath		"//System/Library/Extensions/Sandbox.kext/Contents/MacOS/Sandbox"




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

// Util methods

- (void)getCSSymbolicator:(CSSymbolicatorRef*) symbolicator andOwner:(CSSymbolOwnerRef*) owner
{
	// Sandbox.kext UUID
	char uuidBytes[] = {0x1A, 0xBE, 0x88, 0xC6, 0x60, 0xBE, 0x32, 0x9C, 0xA7, 0xD0, 0x1D, 0x40, 0x0B, 0xE0, 0x2D, 0x66};
	
	*symbolicator = CSSymbolicatorCreateWithMachKernel();
	CFUUIDRef uuid = CFUUIDCreateFromUUIDBytes(NULL, *(CFUUIDBytes*)uuidBytes);
	*owner = CSSymbolicatorGetSymbolOwnerWithUUIDAtTime(*symbolicator, uuid, kCSNow);
}


- (void)getCSSymbolicator:(CSSymbolicatorRef*) symbolicator andSymbol:(CSSymbolRef*) symbol
{
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator:symbolicator andOwner:&owner];
	*symbol = CSSymbolOwnerGetSymbolWithName(owner, "hook_policy_syscall");
}


// Testcases
/*
- (void)testCSSymbolicatorCreateWithMachKernel
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertEquals(symbolicator.csCppData, (void*) 2, @"symbolicator.csCppData != 2");
	STAssertTrue(symbolicator.csCppObj != NULL, @"symbolicator.csCppObj != nil");	
	
	CSRelease(symbolicator);
}

- (void)testCSIsNull
{
	CSSymbolicatorRef symbolicator = kCSNull;
	
	STAssertTrue(CSIsNull(symbolicator), @"is not null");
	
	symbolicator = CSSymbolicatorCreateWithMachKernel();

	STAssertFalse(CSIsNull(symbolicator), @"is null");	
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolicatorGetPid
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertEquals(CSSymbolicatorGetPid(symbolicator), (pid_t) -1, @"kernel pid != -1");	
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolicatorGetArchitecture
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	// TODO: calculate this arch to compare against
	STAssertEquals(CSSymbolicatorGetArchitecture(symbolicator),	CPU_TYPE_X86_64, @"cpu architecture is incorrect");

	CSRelease(symbolicator);
}

- (void)testCSArchitectureIs64Bit
{
	STAssertTrue(CSArchitectureIs64Bit(CPU_TYPE_X86_64), @"CPU_TYPE_X86_64 is not 64bit");
	STAssertFalse(CSArchitectureIs64Bit(CPU_TYPE_X86), @"CPU_TYPE_X86 is not 32bit");	
}

- (void)testCSSymbolicatorGetSymbolOwnerWithUUIDAtTime
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator: &symbolicator andOwner: &owner];
	
	STAssertEquals(owner.csCppData, (void*) 3, @"owner.csCppData != 3");
	STAssertTrue(owner.csCppObj != NULL, @"owner.csCppObj == nil");	
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolOwnerGetPath
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator: &symbolicator andOwner: &owner];
	
	if (CSSymbolOwnerGetPath(owner) && CSSymbolOwnerGetName(owner)) {
		STAssertTrue(strcmp(CSSymbolOwnerGetPath(owner), kSandboxPath) == 0, @"path incorrect");	
		STAssertTrue(strcmp(CSSymbolOwnerGetName(owner), "Sandbox") == 0, @"name incorrect");	
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
*/
- (void)testCSSymbolicatorForeachSymbolOwnerAtTime
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerAtTime(symbolicator, kCSNow, ^(CSSymbolOwnerRef owner) {
		
		STAssertFalse(CSIsNull(owner), @"owner is null");
		STAssertTrue(CSSymbolOwnerGetBaseAddress(owner) > 0, @"invalid base address for symbol owner");
		if (CSSymbolOwnerIsObject(owner)) {
			STAssertTrue(CSSymbolOwnerGetDataFlags(owner) == 1, @"symbol owner has unusual data flags");
		}
		
		printf("%s, %lx\n", CSSymbolOwnerGetName(owner), CSSymbolOwnerGetBaseAddress(owner));
	}) > 0, @"no symbol owners in kernel; thats unlikley");
	CSRelease(symbolicator);
}
/*
- (void)testCSSymbolicatorForeachSymbolOwnerWithFlagsAtTime
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerWithFlagsAtTime(symbolicator, kCSSymbolOwnerIsAOut, kCSNow, ^(CSSymbolOwnerRef owner) {
		// nothing to do
	}) > 0,  @"no symbol owners in kernel; thats unlikley");
	
	CSRelease(symbolicator);
}

- (void)testCSSymbolicatorForeachSymbolOwnerWithPathAtTime
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerWithPathAtTime(symbolicator, 
																kSandboxPath, 
																kCSNow, 
																^(CSSymbolOwnerRef owner) {
		// nothing to do
	}) == 1,  @"invalid numer of symbol owners match the sandbox path");
	
	CSRelease(symbolicator);	
}

- (void)testCSSymbolicatorForeachSymbolOwnerWithNameAtTime
{
	CSSymbolicatorRef symbolicator = CSSymbolicatorCreateWithMachKernel();
	
	STAssertTrue(CSSymbolicatorForeachSymbolOwnerWithNameAtTime(symbolicator, 
																"Sandbox", 
																kCSNow, 
																^(CSSymbolOwnerRef owner) {
																	// nothing to do
																}) == 1,  @"invalid numer of symbol owners match the sandbox name");
	
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

- (void)testCSRegionForeachSymbol
{
	CSSymbolicatorRef symbolicator = kCSNull;
	CSSymbolOwnerRef owner = kCSNull;
	[self getCSSymbolicator:&symbolicator andOwner:&owner];
	
	CSRegionRef region = CSSymbolOwnerGetRegionWithName(owner, "__TEXT __text");
	STAssertTrue(CSRegionForeachSymbol(region, ^(CSSymbolRef symbol) {
		STAssertFalse(CSIsNull(symbol), @"Symbol is null");
	}) > 0, @"no symbols in region; very unlikley");
		
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
	});
	CSRelease(symbolicator);
}
*/
@end
