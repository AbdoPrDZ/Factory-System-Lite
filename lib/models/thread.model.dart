class ThreadModel {
  final String type, color;
  final int count;
  final double weight;

  ThreadModel(this.type, this.color, this.count, this.weight);

  factory ThreadModel.fromMap(Map data) => ThreadModel(
        data['type'],
        data['color'],
        data['count'],
        double.parse(data['weight'].toString()),
      );

  Map toMap() => {
        'type': type,
        'color': color,
        'count': count,
        'weight': weight,
      };
}
