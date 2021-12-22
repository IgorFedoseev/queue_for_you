class Job {
  Job({ required this.id, required this.name, required this.price});
  final String? name;
  final int? price;
  final String? id;

  factory Job.fromMap(Map<String, dynamic> data, String documentID){
    final String name = data['name'];
    final int price = data['price'];
    return Job(
      name: name,
      price: price,
      id: documentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }
}
