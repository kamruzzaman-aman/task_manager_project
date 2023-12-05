class Datum {
    String? id;
    String? title;
    String? description;
    String? status;
    String? createdDate;

    Datum({
        this.id,
        this.title,
        this.description,
        this.status,
        this.createdDate,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        createdDate: json["createdDate"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "status": status,
        "createdDate": createdDate,
    };
}