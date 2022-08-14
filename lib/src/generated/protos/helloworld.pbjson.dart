///
//  Generated code. Do not modify.
//  source: protos/helloworld.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use deviceOsDescriptor instead')
const DeviceOs$json = const {
  '1': 'DeviceOs',
  '2': const [
    const {'1': 'ANDROID', '2': 0},
    const {'1': 'IOS', '2': 1},
    const {'1': 'LINUX', '2': 2},
    const {'1': 'WINDOWS', '2': 3},
    const {'1': 'FUCHSIA', '2': 4},
    const {'1': 'OTHER', '2': 5},
  ],
};

/// Descriptor for `DeviceOs`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceOsDescriptor = $convert.base64Decode('CghEZXZpY2VPcxILCgdBTkRST0lEEAASBwoDSU9TEAESCQoFTElOVVgQAhILCgdXSU5ET1dTEAMSCwoHRlVDSFNJQRAEEgkKBU9USEVSEAU=');
@$core.Deprecated('Use liveServerReplyDescriptor instead')
const LiveServerReply$json = const {
  '1': 'LiveServerReply',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'local_name', '3': 2, '4': 1, '5': 9, '10': 'localName'},
    const {'1': 'local_hostname', '3': 3, '4': 1, '5': 9, '10': 'localHostname'},
    const {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'os', '3': 5, '4': 1, '5': 14, '6': '.helloworld.DeviceOs', '10': 'os'},
    const {'1': 'ip', '3': 6, '4': 1, '5': 9, '10': 'ip'},
  ],
};

/// Descriptor for `LiveServerReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveServerReplyDescriptor = $convert.base64Decode('Cg9MaXZlU2VydmVyUmVwbHkSGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIdCgpsb2NhbF9uYW1lGAIgASgJUglsb2NhbE5hbWUSJQoObG9jYWxfaG9zdG5hbWUYAyABKAlSDWxvY2FsSG9zdG5hbWUSGAoHdmVyc2lvbhgEIAEoCVIHdmVyc2lvbhIkCgJvcxgFIAEoDjIULmhlbGxvd29ybGQuRGV2aWNlT3NSAm9zEg4KAmlwGAYgASgJUgJpcA==');
@$core.Deprecated('Use helloRequestDescriptor instead')
const HelloRequest$json = const {
  '1': 'HelloRequest',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `HelloRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloRequestDescriptor = $convert.base64Decode('CgxIZWxsb1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZQ==');
@$core.Deprecated('Use helloReplyDescriptor instead')
const HelloReply$json = const {
  '1': 'HelloReply',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `HelloReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloReplyDescriptor = $convert.base64Decode('CgpIZWxsb1JlcGx5EhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');
