#import "KKBitWriter.h"

@interface KKBitWriter ()
{
	UInt8 outByte;
	NSInteger outCount;
}
@property (nonatomic, strong) NSMutableData *mutableData;
@end

@implementation KKBitWriter

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.mutableData = [[NSMutableData alloc] init];
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ %p> data: %@, outByte: 0x%02x, outCount: %ld",
			[self class],
			self,
			[self data],
			outByte,
			(long)outCount
			];
}

- (void)writeBit:(BOOL)bit
{
	outByte = (outByte << 1) | (bit ? 1 : 0);
	outCount++;
	if (outCount == 8) {
		[self.mutableData appendBytes:&outByte length:1];
		outByte = 0;
		outCount = 0;
	}
}

- (void)writeFilledDataWithBitCount:(NSInteger)count
{
	for (NSInteger i = 0; i< count; i++) {
		[self writeBit:YES];
	}
}

- (void)writeEmtptyDataWithBitCount:(NSInteger)count
{
	for (NSInteger i = 0; i< count; i++) {
		[self writeBit:NO];
	}
}

- (void)writeUInt8:(UInt8)input bitCount:(NSInteger)count
{
	NSAssert(count <= 8, @"Must be less then 8.");
	[self writeUInt64:(UInt64)input bitCount:count];
}

- (void)writeUInt16:(UInt16)input bitCount:(NSInteger)count
{
	NSAssert(count <= 16, @"Must be less then 16.");
	[self writeUInt64:(UInt64)input bitCount:count];
}

- (void)writeUInt32:(UInt32)input bitCount:(NSInteger)count
{
	NSAssert(count <= 32, @"Must be less then 32.");
	[self writeUInt64:(UInt64)input bitCount:count];
}

- (void)writeUInt64:(UInt64)input bitCount:(NSInteger)count
{
	NSAssert(count <= 64, @"Must be less then 64.");
	for (NSInteger i = count - 1; i >= 0; i--) {
		BOOL bit = (input & (1 << i)) != 0;
		[self writeBit:bit];
	}
}

- (void)flush
{
	if (outCount == 0) {
		return;
	}
	if (outCount < 8) {
		UInt8 diff = 8 - outCount;
		outByte <<= diff;
	}
	[self.mutableData appendBytes:&outByte length:1];
}

- (void)writeData:(NSData *)data
{
	[self flush];
	[self.mutableData appendData:data];
}

- (NSData *)data
{
	return [self.mutableData copy];
}

@end
