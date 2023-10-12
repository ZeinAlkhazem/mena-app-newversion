import 'meetings_config.dart';

class MyMeetingsModel {
  String? message;
  List<MeetingCollectionModel>? meetingsCollections;

  MyMeetingsModel({this.message, this.meetingsCollections});

  MyMeetingsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      meetingsCollections = <MeetingCollectionModel>[];
      json['data'].forEach((v) {
        meetingsCollections!.add(new MeetingCollectionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.meetingsCollections != null) {
      data['data'] = this.meetingsCollections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MeetingCollectionModel {
  DateTime? date;
  List<Meeting>? meetings;

  MeetingCollectionModel({this.date, this.meetings});

  MeetingCollectionModel.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    if (json['meetings'] != null) {
      meetings = <Meeting>[];
      json['meetings'].forEach((v) {
        meetings!.add(new Meeting.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.meetings != null) {
      data['meetings'] = this.meetings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meeting {
  int? id;
  String? title;
  DateTime? date;
  DateTime? from;
  DateTime? to;
  String? timeZone;
  int? duration;
  Repeat? repeat;
  String? requirePasscode;
  String? passcode;
  String? waitingRoom;
  String? partipantBeforeHost;
  String? autoRecord;
  String? toCalendar;
  String? publishToFeed;
  String? sharePermission;
  String? publishToLive;
  bool? isMine;
  ParticipantsType? participantsType;
  ParticipantsType? meetingType;

  Meeting(
      {this.id,
        this.title,
        this.date,
        this.from,
        this.to,
        this.timeZone,
        this.duration,
        this.repeat,
        this.requirePasscode,
        this.passcode,
        this.waitingRoom,
        this.partipantBeforeHost,
        this.autoRecord,
        this.isMine,
        this.toCalendar,
        this.publishToFeed,
        this.sharePermission,
        this.publishToLive,
        this.participantsType,
        this.meetingType});

  Meeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = DateTime.parse(json["date"]);
    from = DateTime.parse(json['from']);
    to =DateTime.parse( json['to']);
    timeZone = json['time_zone'];
    duration = json['duration'];
    repeat =Repeat.fromJson(json['repeat']) ;
    requirePasscode = json['require_passcode'];
    passcode = json['passcode'];
    waitingRoom = json['waiting_room'];
    isMine = json['is_mine']??false;
    partipantBeforeHost = json['partipant_before_host'];
    autoRecord = json['auto_record'];
    toCalendar = json['to_calendar'];
    publishToFeed = json['publish_to_feed'];
    sharePermission = json['share_permission'];
    publishToLive = json['publish_to_live'];
    participantsType = json['participants_type'] != null
        ? new ParticipantsType.fromJson(json['participants_type'])
        : null;
    meetingType = json['meeting_type'] != null
        ? new ParticipantsType.fromJson(json['meeting_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['from'] = this.from;
    data['to'] = this.to;
    data['time_zone'] = this.timeZone;
    data['repeat'] = this.repeat;
    data['require_passcode'] = this.requirePasscode;
    data['passcode'] = this.passcode;
    data['waiting_room'] = this.waitingRoom;
    data['partipant_before_host'] = this.partipantBeforeHost;
    data['auto_record'] = this.autoRecord;
    data['to_calendar'] = this.toCalendar;
    data['publish_to_feed'] = this.publishToFeed;
    data['publish_to_live'] = this.publishToLive;
    if (this.participantsType != null) {
      data['participants_type'] = this.participantsType!.toJson();
    }
    if (this.meetingType != null) {
      data['meeting_type'] = this.meetingType!.toJson();
    }
    return data;
  }
}

class ParticipantsType {
  int? id;
  String? title;

  ParticipantsType({this.id, this.title});

  ParticipantsType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}