// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)



typedef NS_ENUM(SInt32, ResultCode) {
  ResultCodeNoError = 0,
  ResultCodeErrorConnectDatabase = 1,
  ResultCodeErrorQueryDatabase = 2,
  ResultCodeErrorInsertDatabase = 3,
  ResultCodeErrorUpdateDatabase = 4,
  ResultCodeErrorDeleteDatabase = 5,
  ResultCodeErrorInvalidData = 6,
  ResultCodeErrorLoginForbidden = 101,
  ResultCodeErrorLoginAuth = 102,
  ResultCodeErrorRelogin = 103,
  ResultCodeErrorLogout = 110,
  ResultCodeErrorIllegalContent = 201,
  ResultCodeErrorCountTooMuch = 202,
  ResultCodeErrorFriendAlreadyExist = 301,
  ResultCodeErrorFriendCannotAddYourself = 302,
  ResultCodeErrorFriendRquToomuch = 303,
  ResultCodeErrorFriendStranger = 304,
  ResultCodeErrorFriendIToomuchFriends = 305,
  ResultCodeErrorFriendUToomuchFriends = 306,
  ResultCodeErrorFriendTeamToomuch = 307,
  ResultCodeErrorFriendTeamAlreadyExsit = 308,
  ResultCodeErrorFriendINull = 309,
  ResultCodeErrorFriendUNull = 310,
  ResultCodeErrorFriendYourself = 311,
  ResultCodeErrorFriendFriend = 312,
  ResultCodeErrorMsgFromid = 313,
  ResultCodeErrorMsgToid = 314,
  ResultCodeErrorMsgUserid = 315,
  ResultCodeErrorP2CKefuOffline = 401,
  ResultCodeErrorP2CUnclosed = 402,
  ResultCodeErrorP2CSessionNotExist = 403,
  ResultCodeErrorP2CSwitchNotNewkefu = 404,
  ResultCodeErrorP2CInvalidEntid = 405,
  ResultCodeErrorP2CWithoutKefuPermission = 406,
  ResultCodeErrorP2CInvalidSession = 407,
  ResultCodeErrorBpnDeviceversionError = 601,
  ResultCodeErrorBpnTokenError = 602,
  ResultCodeErrorBpnMsgidError = 603,
  ResultCodeErrorBpnToidError = 604,
  ResultCodeErrorMsgDeviceversionError = 605,
  ResultCodeErrorMsgTokenError = 606,
  ResultCodeErrorMsgMsgidError = 607,
  ResultCodeErrorMsgToidErrot = 608,
};

BOOL ResultCodeIsValidValue(ResultCode value);
NSString *NSStringFromResultCode(ResultCode value);

typedef NS_ENUM(SInt32, CommandID) {
  CommandIDSrvAuth = 1,
  CommandIDSysHeartbeat = 4097,
  CommandIDSysHeartbeatAck = 4098,
  CommandIDSysClientTimeout = 4099,
  CommandIDCmCustLogin = 8193,
  CommandIDCmCustLoginAck = 8194,
  CommandIDCmCustLogout = 8195,
  CommandIDCmCustLogoutAck = 8196,
  CommandIDCmCustKickout = 8198,
  CommandIDMsgSessionMessage = 12289,
  CommandIDMsgSessionMessageRsp = 12290,
  CommandIDMsgSessionMessageAck = 12291,
  CommandIDMsgSessionMessageAckRsp = 12292,
  CommandIDMsgSessionMessageReaded = 12293,
  CommandIDMsgSessionMessageReadedRsp = 12294,
  CommandIDMsgSessionMessageForward = 12296,
  CommandIDHistoryMessageSummary = 12297,
  CommandIDHistoryMessageSummaryRsp = 12304,
  CommandIDMsgHistoryMessageList = 12305,
  CommandIDMsgHistoryMessageListRsp = 12306,
  CommandIDMsgHistoryMessageListAck = 12307,
  CommandIDMsgHistoryMessageListAckRsp = 12308,
  CommandIDMsgHistoryMessageListReaded = 12309,
  CommandIDMsgHistoryMessageListReadedRsp = 12310,
  CommandIDHsPlatformHistoryMessageList = 12311,
  CommandIDHsPlatformHistoryMessageListRsp = 12312,
  CommandIDHsPlatformHistoryMessageListAck = 12313,
  CommandIDHsPlatformHistoryMessageListAckRsp = 12320,
  CommandIDHsPlatformHistoryMessageListReaded = 12321,
  CommandIDHsPlatformHistoryMessageListReadedRsp = 12322,
  CommandIDFriendHistoryMessageList = 12323,
  CommandIDFriendHistoryMessageListRsp = 12324,
  CommandIDFriendHistoryMessageListAck = 12325,
  CommandIDFriendHistoryMessageListAckRsp = 12326,
  CommandIDFriendHistoryMessageListReaded = 12327,
  CommandIDFriendHistoryMessageListReadedRsp = 12328,
  CommandIDP2CHistoryMessageList = 12329,
  CommandIDP2CHistoryMessageListRsp = 12336,
  CommandIDP2CHistoryMessageListAck = 12337,
  CommandIDP2CHistoryMessageListAckRsp = 12338,
  CommandIDP2CHistoryMessageListReaded = 12339,
  CommandIDP2CHistoryMessageListReadedRsp = 12340,
  CommandIDP2CAssignLeaveMessage = 12341,
  CommandIDP2CAssignLeaveMessageRsp = 12342,
  CommandIDMsgAddFriendReq = 16385,
  CommandIDMsgAddFriendRsp = 16386,
  CommandIDMsgVerifyFriendReq = 16387,
  CommandIDMsgVerifyFriendRsp = 16388,
  CommandIDMsgDelFriendReq = 16389,
  CommandIDMsgDelFriendRsp = 16390,
  CommandIDMsgModifyFriendReq = 16391,
  CommandIDMsgModifyFriendRsp = 16392,
  CommandIDMsgShieldFriendReq = 16393,
  CommandIDMsgShieldFriendRsp = 16400,
  CommandIDBpnMessagePush = 20481,
  CommandIDBpnMessagePushRsp = 20482,
  CommandIDBpnMessageAuthCm = 20483,
  CommandIDBpnMessageAuthCmRsp = 20484,
  CommandIDBpnMessageAuth = 20485,
  CommandIDBpnMessageAuthRsp = 20486,
  CommandIDP2CCreateReq = 24577,
  CommandIDP2CCreateRsp = 24578,
  CommandIDP2CCloseReq = 24579,
  CommandIDP2CCloseRsp = 24580,
  CommandIDP2CCloseForward = 24582,
  CommandIDP2CMessage = 24583,
  CommandIDP2CMessageRsp = 24584,
  CommandIDP2CMessageForward = 24592,
  CommandIDP2CMessageAckReq = 24593,
  CommandIDP2CMessageAckRsp = 24594,
  CommandIDP2CMessageReadedReq = 24595,
  CommandIDP2CMessageReadedRsp = 24596,
  CommandIDP2CSwitchReq = 24597,
  CommandIDP2CSwitchRsp = 24598,
  CommandIDP2CSwitchForward = 24600,
  CommandIDP2CSwitchForwardRsp = 24601,
  CommandIDP2CNotifySwitchC = 24608,
  CommandIDP2CNotifySwitchRsp = 24609,
  CommandIDP2CNotifySwitchP = 24610,
  CommandIDP2CLeaveMsgReq = 24611,
  CommandIDP2CLeaveMsgRsp = 24612,
  CommandIDApnsBpnPushReq = 49153,
  CommandIDApnsBpnPushRsp = 49154,
  CommandIDApnsMsgPushReq = 49155,
  CommandIDApnsMsgPushRsp = 49156,
};

BOOL CommandIDIsValidValue(CommandID value);
NSString *NSStringFromCommandID(CommandID value);

typedef NS_ENUM(SInt32, PlatformDevice) {
  PlatformDeviceUnkownDevice = 0,
  PlatformDeviceWeb = 1,
  PlatformDevicePhone = 2,
  PlatformDeviceIpad = 3,
  PlatformDeviceHspad = 4,
  PlatformDevicePc = 5,
};

BOOL PlatformDeviceIsValidValue(PlatformDevice value);
NSString *NSStringFromPlatformDevice(PlatformDevice value);


@interface ImHxcommonRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end


// @@protoc_insertion_point(global_scope)
