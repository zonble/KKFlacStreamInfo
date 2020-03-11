#import "KKFlacStreamInfo.h"
#import "KKBitWriter.h"

static const unsigned FLAC__STREAM_METADATA_STREAMINFO_MIN_BLOCK_SIZE_LEN = 16; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_MAX_BLOCK_SIZE_LEN = 16; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_MIN_FRAME_SIZE_LEN = 24; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_MAX_FRAME_SIZE_LEN = 24; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_SAMPLE_RATE_LEN = 20; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_CHANNELS_LEN = 3; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_BITS_PER_SAMPLE_LEN = 5; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_TOTAL_SAMPLES_LEN = 36; /* bits */
static const unsigned FLAC__STREAM_METADATA_STREAMINFO_MD5SUM_LEN = 128; /* bits */

@implementation KKFlacStreamInfo

@end

KKFlacStreamInfo * makeSimpleStreamInfo(void)
{
	KKFlacStreamInfo *info = [[KKFlacStreamInfo alloc] init];
	info.minBlockSize = 4608;
	info.maxBlockSize = 4608;
	info.minFrameSize = 14;
	info.maxFrameSize = 15521;
	info.sampleRate = 48000;
	info.numberOfChannels = 2;
	info.bitsPerChannel = 16;
	info.sampleCount = 0;
	return info;
}

@implementation KKFlacStreamInfo (Data)

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ %p -\nminBlockSize: %d\nmaxBlockSize: %d\nminFrameSize: %d\nmaxFrameSize: %d\nsampleRate: %d\nnumberOfChannels: %d\nbitsPerChannel: %d\nsampleCount: %llu>",
			[self class],
			self,
			self.minBlockSize,
			self.maxBlockSize,
			self.minFrameSize,
			self.maxFrameSize,
			self.sampleRate,
			self.numberOfChannels,
			self.bitsPerChannel,
			self.sampleCount
			];
}

- (void)_writeStreamInfo:(KKBitWriter *)writer
{
	[writer writeUInt16:self.minBlockSize bitCount:FLAC__STREAM_METADATA_STREAMINFO_MIN_BLOCK_SIZE_LEN];
	[writer writeUInt16:self.maxBlockSize bitCount:FLAC__STREAM_METADATA_STREAMINFO_MAX_BLOCK_SIZE_LEN];
	[writer writeUInt32:self.minFrameSize bitCount:FLAC__STREAM_METADATA_STREAMINFO_MIN_FRAME_SIZE_LEN];
	[writer writeUInt32:self.maxFrameSize bitCount:FLAC__STREAM_METADATA_STREAMINFO_MAX_FRAME_SIZE_LEN];
	[writer writeUInt32:self.sampleRate bitCount:FLAC__STREAM_METADATA_STREAMINFO_SAMPLE_RATE_LEN];
	[writer writeUInt8:(self.numberOfChannels -1) bitCount:FLAC__STREAM_METADATA_STREAMINFO_CHANNELS_LEN];
	[writer writeUInt8:(self.bitsPerChannel -1) bitCount:FLAC__STREAM_METADATA_STREAMINFO_BITS_PER_SAMPLE_LEN];
	[writer writeUInt64:self.sampleCount bitCount:FLAC__STREAM_METADATA_STREAMINFO_TOTAL_SAMPLES_LEN];
	if (self.md5Signature && self.md5Signature.length == 16) {
		[writer writeData:self.md5Signature];
	}
	else {
		[writer writeEmtptyDataWithBitCount:FLAC__STREAM_METADATA_STREAMINFO_MD5SUM_LEN];
	}
}

- (NSData *)dataWithBlockHeader:(BOOL)isLastBlock
{
	KKBitWriter *writer = [[KKBitWriter alloc] init];
	// If this is the last metadata block.
	[writer writeUInt8:(isLastBlock ? 1:0) bitCount:1];
	// 0 presents METADATA_BLOCK_STREAMINFO
	[writer writeUInt8:0 bitCount:7];
	UInt32 length = (FLAC__STREAM_METADATA_STREAMINFO_MIN_BLOCK_SIZE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_MAX_BLOCK_SIZE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_MIN_FRAME_SIZE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_MAX_FRAME_SIZE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_SAMPLE_RATE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_CHANNELS_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_BITS_PER_SAMPLE_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_TOTAL_SAMPLES_LEN +
	FLAC__STREAM_METADATA_STREAMINFO_MD5SUM_LEN) / 8;
	[writer writeUInt32:length bitCount:24];
	[self _writeStreamInfo:writer];
	return writer.data;
}

- (NSData *)streamInfoData
{
	KKBitWriter *writer = [[KKBitWriter alloc] init];
	[self _writeStreamInfo:writer];
	return writer.data;
}

@end

