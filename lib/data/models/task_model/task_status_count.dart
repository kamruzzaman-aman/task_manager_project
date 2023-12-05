import 'task_count_data.dart';

class TaskStatusCountModel {
    String? status;
    List<TaskStatusCountData>? data;

    TaskStatusCountModel({
        this.status,
        this.data,
    });

    factory TaskStatusCountModel.fromJson(Map<String, dynamic> json) => TaskStatusCountModel(
        status: json["status"],
        data: List<TaskStatusCountData>.from(json["data"].map((x) => TaskStatusCountData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}
