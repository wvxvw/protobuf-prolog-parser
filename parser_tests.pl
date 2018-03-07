% -*- mode: prolog -*-

:- [parser].

test_minimal :-
    string_codes("syntax = \"proto3\";", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_preamble :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
// https://developers.google.com/protocol-buffers/
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

syntax = \"proto3\";", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_package :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

package google.protobuf;
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_import :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

package google.protobuf;

import \"google/protobuf/any.proto\";
import \"google/protobuf/source_context.proto\";
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_options :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

option csharp_namespace = \"Google.Protobuf.WellKnownTypes\";
option cc_enable_arenas = true;
option java_package = \"com.google.protobuf\";
option java_outer_classname = \"TypeProto\";
option java_multiple_files = true;
option objc_class_prefix = \"GPB\";
option go_package = \"google.golang.org/genproto/protobuf/ptype;ptype\";
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_message :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

// A protocol buffer message type.
message Type {
  /* block comment */
  // The fully qualified message name.
  string name = 1;
  // The list of fields.
  repeated Field fields = 2;
  // The list of types appearing in `oneof` definitions in this type.
  repeated string oneofs = 3;
  // The protocol buffer options.
  repeated Option options = 4;
  // The source context.
  SourceContext source_context = 5;
  // The source syntax.
  Syntax syntax = 6;
}
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_complex_message :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

message Field {
  // Basic field types.
  enum Kind {
    // Field type unknown.
    TYPE_UNKNOWN        = 0;
    // Field type double.
    TYPE_DOUBLE         = 1;
    // Field type float.
    TYPE_FLOAT          = 2;
    // Field type int64.
    TYPE_INT64          = 3;
    // Field type uint64.
    TYPE_UINT64         = 4;
    // Field type int32.
    TYPE_INT32          = 5;
    // Field type fixed64.
    TYPE_FIXED64        = 6;
    // Field type fixed32.
    TYPE_FIXED32        = 7;
    // Field type bool.
    TYPE_BOOL           = 8;
    // Field type string.
    TYPE_STRING         = 9;
    // Field type group. Proto2 syntax only, and deprecated.
    TYPE_GROUP          = 10;
    // Field type message.
    TYPE_MESSAGE        = 11;
    // Field type bytes.
    TYPE_BYTES          = 12;
    // Field type uint32.
    TYPE_UINT32         = 13;
    // Field type enum.
    TYPE_ENUM           = 14;
    // Field type sfixed32.
    TYPE_SFIXED32       = 15;
    // Field type sfixed64.
    TYPE_SFIXED64       = 16;
    // Field type sint32.
    TYPE_SINT32         = 17;
    // Field type sint64.
    TYPE_SINT64         = 18;
  };

  // Whether a field is optional, required, or repeated.
  enum Cardinality {
    // For fields with unknown cardinality.
    CARDINALITY_UNKNOWN = 0;
    // For optional fields.
    CARDINALITY_OPTIONAL = 1;
    // For required fields. Proto2 syntax only.
    CARDINALITY_REQUIRED = 2;
    // For repeated fields.
    CARDINALITY_REPEATED = 3;
  };

  // The field type.
  Kind kind = 1;
  // The field cardinality.
  Cardinality cardinality = 2;
  // The field number.
  int32 number = 3;
  // The field name.
  string name = 4;
  // The field type URL, without the scheme, for message or enumeration
  // types. Example: `\"type.googleapis.com/google.protobuf.Timestamp\"`.
  string type_url = 6;
  // The index of the field type in `Type.oneofs`, for message or enumeration
  // types. The first type has index 1; zero means the type is not in the list.
  int32 oneof_index = 7;
  // Whether to use alternative packed wire representation.
  bool packed = 8;
  // The protocol buffer options.
  repeated Option options = 9;
  // The field JSON name.
  string json_name = 10;
  // The string value of the default value of this field. Proto2 syntax only.
  string default_value = 11;
}", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_enum :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

// The syntax in which a protocol buffer element is defined.
enum Syntax {
  // Syntax `proto2`.
  SYNTAX_PROTO2 = 0;
  // Syntax `proto3`.
  SYNTAX_PROTO3 = 1;
}
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_two_messages :-
    string_codes("// Protocol Buffers - Google\'s data interchange format
// Copyright 2008 Google Inc.  All rights reserved.


syntax = \"proto3\";

// A protocol buffer message type.
message Type {
  /* block comment */
  // The fully qualified message name.
  string name = 1;
  // The list of fields.
  repeated Field fields = 2;
  // The list of types appearing in `oneof` definitions in this type.
  repeated string oneofs = 3;
  // The protocol buffer options.
  repeated Option options = 4;
  // The source context.
  SourceContext source_context = 5;
  // The source syntax.
  Syntax syntax = 6;
}

// A protocol buffer message type.
message Type {
  /* block comment */
  // The fully qualified message name.
  string name = 1;
  // The list of fields.
  repeated Field fields = 2;
  // The list of types appearing in `oneof` definitions in this type.
  repeated string oneofs = 3;
  // The protocol buffer options.
  repeated Option options = 4;
  // The source context.
  SourceContext source_context = 5;
  // The source syntax.
  Syntax syntax = 6;
}
", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_file :-
    string_codes("// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.  All rights reserved.
// https://developers.google.com/protocol-buffers/
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//     * Neither the name of Google Inc. nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

syntax = \"proto3\";

package google.protobuf;

import \"google/protobuf/any.proto\";
import \"google/protobuf/source_context.proto\";

option csharp_namespace = \"Google.Protobuf.WellKnownTypes\";
option cc_enable_arenas = true;
option java_package = \"com.google.protobuf\";
option java_outer_classname = \"TypeProto\";
option java_multiple_files = true;
option objc_class_prefix = \"GPB\";
option go_package = \"google.golang.org/genproto/protobuf/ptype;ptype\";

// A protocol buffer message type.
message Type {
  // The fully qualified message name.
  string name = 1;
  // The list of fields.
  repeated Field fields = 2;
  // The list of types appearing in `oneof` definitions in this type.
  repeated string oneofs = 3;
  // The protocol buffer options.
  repeated Option options = 4;
  // The source context.
  SourceContext source_context = 5;
  // The source syntax.
  Syntax syntax = 6;
}

// A single field of a message type.
message Field {
  // Basic field types.
  enum Kind {
    // Field type unknown.
    TYPE_UNKNOWN        = 0;
    // Field type double.
    TYPE_DOUBLE         = 1;
    // Field type float.
    TYPE_FLOAT          = 2;
    // Field type int64.
    TYPE_INT64          = 3;
    // Field type uint64.
    TYPE_UINT64         = 4;
    // Field type int32.
    TYPE_INT32          = 5;
    // Field type fixed64.
    TYPE_FIXED64        = 6;
    // Field type fixed32.
    TYPE_FIXED32        = 7;
    // Field type bool.
    TYPE_BOOL           = 8;
    // Field type string.
    TYPE_STRING         = 9;
    // Field type group. Proto2 syntax only, and deprecated.
    TYPE_GROUP          = 10;
    // Field type message.
    TYPE_MESSAGE        = 11;
    // Field type bytes.
    TYPE_BYTES          = 12;
    // Field type uint32.
    TYPE_UINT32         = 13;
    // Field type enum.
    TYPE_ENUM           = 14;
    // Field type sfixed32.
    TYPE_SFIXED32       = 15;
    // Field type sfixed64.
    TYPE_SFIXED64       = 16;
    // Field type sint32.
    TYPE_SINT32         = 17;
    // Field type sint64.
    TYPE_SINT64         = 18;
  }// ;

  // Whether a field is optional, required, or repeated.
  enum Cardinality {
    // For fields with unknown cardinality.
    CARDINALITY_UNKNOWN = 0;
    // For optional fields.
    CARDINALITY_OPTIONAL = 1;
    // For required fields. Proto2 syntax only.
    CARDINALITY_REQUIRED = 2;
    // For repeated fields.
    CARDINALITY_REPEATED = 3;
  };

  // The field type.
  Kind kind = 1;
  // The field cardinality.
  Cardinality cardinality = 2;
  // The field number.
  int32 number = 3;
  // The field name.
  string name = 4;
  // The field type URL, without the scheme, for message or enumeration
  // types. Example: `\"type.googleapis.com/google.protobuf.Timestamp\"`.
  string type_url = 6;
  // The index of the field type in `Type.oneofs`, for message or enumeration
  // types. The first type has index 1; zero means the type is not in the list.
  int32 oneof_index = 7;
  // Whether to use alternative packed wire representation.
  bool packed = 8;
  // The protocol buffer options.
  repeated Option options = 9;
  // The field JSON name.
  string json_name = 10;
  // The string value of the default value of this field. Proto2 syntax only.
  string default_value = 11;
}

// Enum type definition.
message Enum {
  // Enum type name.
  string name = 1;
  // Enum value definitions.
  repeated EnumValue enumvalue = 2;
  // Protocol buffer options.
  repeated Option options = 3;
  // The source context.
  SourceContext source_context = 4;
  // The source syntax.
  Syntax syntax = 5;
}

// Enum value definition.
message EnumValue {
  // Enum value name.
  string name = 1;
  // Enum value number.
  int32 number = 2;
  // Protocol buffer options.
  repeated Option options = 3;
}

// A protocol buffer option, which can be attached to a message, field,
// enumeration, etc.
message Option {
  // The option's name. For protobuf built-in options (options defined in
  // descriptor.proto), this is the short name. For example, `\"map_entry\"`.
  // For custom options, it should be the fully-qualified name. For example,
  // `\"google.api.http\"`.
  string name = 1;
  // The option's value packed in an Any message. If the value is a primitive,
  // the corresponding wrapper type defined in google/protobuf/wrappers.proto
  // should be used. If the value is an enum, it should be stored as an int32
  // value using the google.protobuf.Int32Value type.
  Any value = 2;
}

// The syntax in which a protocol buffer element is defined.
enum Syntax {
  // Syntax `proto2`.
  SYNTAX_PROTO2 = 0;
  // Syntax `proto3`.
  SYNTAX_PROTO3 = 1;
}", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_spakrplug_preamble :-
    string_codes("syntax = \"proto2\";

//
// To compile:
// cd client_libraries/java
// protoc --proto_path=../../ --java_out=src/main/java ../../sparkplug_b.proto 
//
package com.cirruslink.sparkplug.protobuf;

option java_package         = \"com.cirruslink.sparkplug.protobuf\";
option java_outer_classname = \"SparkplugBProto\";", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_spakrplug_message :-
    string_codes("syntax = \"proto2\";

message Payload {
    /*
        // Indexes of Data Types

        // Unknown placeholder for future expansion.
        Unknown         = 0;

        // Basic Types
        Int8            = 1;
        Int16           = 2;
        Int32           = 3;
        Int64           = 4;
        UInt8           = 5;
        UInt16          = 6;
        UInt32          = 7;
        UInt64          = 8;
        Float           = 9;
        Double          = 10;
        Boolean         = 11;
        String          = 12;
        DateTime        = 13;
        Text            = 14;

        // Additional Metric Types
        UUID            = 15;
        DataSet         = 16;
        Bytes           = 17;
        File            = 18;
        Template        = 19;
        
        // Additional PropertyValue Types
        PropertySet     = 20;
        PropertySetList = 21;

    */

    message Template {
        
        message Parameter {
            optional string name        = 1;
            optional uint32 type        = 2;

            oneof value {
                uint32 int_value        = 3;
                uint64 long_value       = 4;
                float  float_value      = 5;
                double double_value     = 6;
                bool   boolean_value    = 7;
                string string_value     = 8;
                ParameterValueExtension extension_value = 9;
            }

            message ParameterValueExtension {
                extensions              1 to max;
            }
        }

        optional string version         = 1;          // The version of the Template to prevent mismatches
        repeated Metric metrics         = 2;          // Each metric is the name of the metric and the datatype of the member but does not contain a value
        repeated Parameter parameters   = 3;
        optional string template_ref    = 4;          // Reference to a template if this is extending a Template or an instance - must exist if an instance
        optional bool is_definition     = 5;
        extensions                      6 to max;
    }

    message DataSet {

        message DataSetValue {

            oneof value {
                uint32 int_value                        = 1;
                uint64 long_value                       = 2;
                float  float_value                      = 3;
                double double_value                     = 4;
                bool   boolean_value                    = 5;
                string string_value                     = 6;
                DataSetValueExtension extension_value   = 7;
            }

            message DataSetValueExtension {
                extensions  1 to max;
            }
        }

        message Row {
            repeated DataSetValue elements  = 1;
            extensions                      2 to max;   // For third party extensions
        }

        optional uint64   num_of_columns    = 1;
        repeated string   columns           = 2;
        repeated uint32   types             = 3;
        repeated Row      rows              = 4;
        extensions                          5 to max;   // For third party extensions
    }

    message PropertyValue {

        optional uint32     type                    = 1;
        optional bool       is_null                 = 2; 

        oneof value {
            uint32          int_value               = 3;
            uint64          long_value              = 4;
            float           float_value             = 5;
            double          double_value            = 6;
            bool            boolean_value           = 7;
            string          string_value            = 8;
            PropertySet     propertyset_value       = 9;
            PropertySetList propertysets_value      = 10;      // List of Property Values
            PropertyValueExtension extension_value  = 11;
        }

        message PropertyValueExtension {
            extensions                             1 to max;
        }
    }

    message PropertySet {
        repeated string        keys     = 1;         // Names of the properties
        repeated PropertyValue values   = 2;
        extensions                      3 to max;
    }

    message PropertySetList {
        repeated PropertySet propertyset = 1;
        extensions                       2 to max;
    }

    message MetaData {
        // Bytes specific metadata
        optional bool   is_multi_part   = 1;

        // General metadata
        optional string content_type    = 2;        // Content/Media type
        optional uint64 size            = 3;        // File size, String size, Multi-part size, etc
        optional uint64 seq             = 4;        // Sequence number for multi-part messages

        // File metadata
        optional string file_name       = 5;        // File name
        optional string file_type       = 6;        // File type (i.e. xml, json, txt, cpp, etc)
        optional string md5             = 7;        // md5 of data

        // Catchalls and future expansion
        optional string description     = 8;        // Could be anything such as json or xml of custom properties
        extensions                      9 to max;
    }

    message Metric {

        optional string   name          = 1;        // Metric name - should only be included on birth
        optional uint64   alias         = 2;        // Metric alias - tied to name on birth and included in all later DATA messages
        optional uint64   timestamp     = 3;        // Timestamp associated with data acquisition time
        optional uint32   datatype      = 4;        // DataType of the metric/tag value
        optional bool     is_historical = 5;        // If this is historical data and should not update real time tag
        optional bool     is_transient  = 6;        // Tells consuming clients such as MQTT Engine to not store this as a tag
        optional bool     is_null       = 7;        // If this is null - explicitly say so rather than using -1, false, etc for some datatypes.
        optional MetaData metadata      = 8;        // Metadata for the payload
        optional PropertySet properties = 9;

        oneof value {
            uint32   int_value                      = 10;
            uint64   long_value                     = 11;
            float    float_value                    = 12;
            double   double_value                   = 13;
            bool     boolean_value                  = 14;
            string   string_value                   = 15;
            bytes    bytes_value                    = 16;       // Bytes, File
            DataSet  dataset_value                  = 17;
            Template template_value                 = 18;
            MetricValueExtension extension_value    = 19;
        }

        message MetricValueExtension {
            extensions  1 to max;
        }
    }

    optional uint64   timestamp     = 1;        // Timestamp at message sending time
    repeated Metric   metrics       = 2;        // Repeated forever - no limit in Google Protobufs
    optional uint64   seq           = 3;        // Sequence number
    optional string   uuid          = 4;        // UUID to track message type in terms of schema definitions
    optional bytes    body          = 5;        // To optionally bypass the whole definition above
    extensions                      6 to max;   // For third party extensions
}", S),
    phrase(proto(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).

test_spakrplug_message_basic :-
    string_codes("message Payload {
    /*
        // Indexes of Data Types

        // Unknown placeholder for future expansion.
        Unknown         = 0;

        // Basic Types
        Int8            = 1;
        Int16           = 2;
        Int32           = 3;
        Int64           = 4;
        UInt8           = 5;
        UInt16          = 6;
        UInt32          = 7;
        UInt64          = 8;
        Float           = 9;
        Double          = 10;
        Boolean         = 11;
        String          = 12;
        DateTime        = 13;
        Text            = 14;

        // Additional Metric Types
        UUID            = 15;
        DataSet         = 16;
        Bytes           = 17;
        File            = 18;
        Template        = 19;
        
        // Additional PropertyValue Types
        PropertySet     = 20;
        PropertySetList = 21;

    */

    optional uint64   timestamp     = 1;        // Timestamp at message sending time
    repeated Metric   metrics       = 2;        // Repeated forever - no limit in Google Protobufs
    optional uint64   seq           = 3;        // Sequence number
    optional string   uuid          = 4;        // UUID to track message type in terms of schema definitions
    optional bytes    body          = 5;        // To optionally bypass the whole definition above
    extensions                      6 to max;   // For third party extensions
}", S),
    phrase(message(X), S, Y),
    string_codes(C, Y),
    format('~w~n--- failed to parse: ---~n~w~n', [X, C]).


all :-
    test_minimal,
    test_preamble,
    test_package,
    test_import,
    test_options,
    test_message,
    test_complex_message,
    test_two_messages,
    test_enum,
    test_file.
