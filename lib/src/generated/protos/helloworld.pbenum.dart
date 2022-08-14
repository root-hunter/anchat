///
//  Generated code. Do not modify.
//  source: protos/helloworld.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class DeviceOs extends $pb.ProtobufEnum {
  static const DeviceOs ANDROID = DeviceOs._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ANDROID');
  static const DeviceOs IOS = DeviceOs._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'IOS');
  static const DeviceOs LINUX = DeviceOs._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LINUX');
  static const DeviceOs WINDOWS = DeviceOs._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WINDOWS');
  static const DeviceOs FUCHSIA = DeviceOs._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FUCHSIA');
  static const DeviceOs OTHER = DeviceOs._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OTHER');

  static const $core.List<DeviceOs> values = <DeviceOs> [
    ANDROID,
    IOS,
    LINUX,
    WINDOWS,
    FUCHSIA,
    OTHER,
  ];

  static final $core.Map<$core.int, DeviceOs> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeviceOs? valueOf($core.int value) => _byValue[value];

  const DeviceOs._($core.int v, $core.String n) : super(v, n);
}

