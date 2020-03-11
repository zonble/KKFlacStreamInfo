@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface KKBitWriter : NSObject

- (void)writeBit:(BOOL)bit;
- (void)writeFilledDataWithBitCount:(NSInteger)count;
- (void)writeEmtptyDataWithBitCount:(NSInteger)count;
- (void)writeUInt8:(UInt8)input bitCount:(NSInteger)count;
- (void)writeUInt16:(UInt16)input bitCount:(NSInteger)count;
- (void)writeUInt32:(UInt32)input bitCount:(NSInteger)count;
- (void)writeUInt64:(UInt64)input bitCount:(NSInteger)count;
- (void)writeData:(NSData *)data;
- (void)flush;

@property (strong, nonatomic, readonly) NSData *data;

@end

NS_ASSUME_NONNULL_END
