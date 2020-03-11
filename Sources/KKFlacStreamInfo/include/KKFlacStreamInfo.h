@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// Represents the stream info metadata block of a Flac file.
///
/// For example, if you want to generate a Flac file:
///
/// ``` objc
/// NSMutableData *flacData = [NSMutableData data];
/// [flacData appendBytes:"fLaC" length:4];
/// KKFlacStreamInfo *info  = makeSimpleStreamInfo();
/// [flacData appendData:[info dataWithBlockHeader:YES]];
/// [flacData appendData:FRAMES...];
/// ```
///
/// See Flac spec: https://xiph.org/flac/format.html#metadata_block_streaminfo
@interface KKFlacStreamInfo : NSObject
/// The minimal block size.
@property (assign, nonatomic) UInt16 minBlockSize;
/// The maximal block size.
@property (assign, nonatomic) UInt16 maxBlockSize;
/// The minimal frame size.
@property (assign, nonatomic) UInt32 minFrameSize;
/// The maximal frame size.
@property (assign, nonatomic) UInt32 maxFrameSize;
/// The sample rate.
@property (assign, nonatomic) UInt32 sampleRate;
/// The number of channels.
@property (assign, nonatomic) UInt8 numberOfChannels;
/// Bits per seconds.
@property (assign, nonatomic) UInt8 bitsPerChannel;
/// The count of samples in the Flac file.
@property (assign, nonatomic) UInt64 sampleCount;
/// The MD5 signature.
@property (retain, nonatomic, nullable) NSData *md5Signature;
@end

/// Creates a simple stream info object.
///
/// * minBlockSize = 4608;
/// * maxBlockSize = 4608;
/// * minFrameSize = 14;
/// * maxFrameSize = 15521;
/// * sampleRate = 48000;
/// * numberOfChannels = 2;
/// * bitsPerChannel = 16;
/// * sampleCount = 0;
KKFlacStreamInfo * makeSimpleStreamInfo(void);

@interface KKFlacStreamInfo (Data)
/// Data for stream info with block header.
/// @param isLastBlock If we want the block to be the last metadata block.
- (NSData *)dataWithBlockHeader:(BOOL)isLastBlock;
/// Data for stream info without block header.
- (NSData *)streamInfoData;
@end

NS_ASSUME_NONNULL_END

