
class TaskStatusCountData {
    String? id;
    int? sum;

    TaskStatusCountData({
        this.id,
        this.sum,
    });

    factory TaskStatusCountData.fromJson(Map<String, dynamic> json) => TaskStatusCountData(
        id: json["_id"],
        sum: json["sum"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "sum": sum,
    };
}
