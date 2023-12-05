import 'task_datum.dart';

class TaskListModel {
    String? status;
    List<Datum>? data;

    TaskListModel({
        this.status,
        this.data,
    });

    factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

