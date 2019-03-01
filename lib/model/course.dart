class Course {
  final String name;
  final int groupSize;

  const Course({
  this.name,
  this.groupSize,
  });

  Course.fromMap(Map<String, dynamic> data, String id)
      : this(
    name: data['name'],
    groupSize: data['group_size'],
  );
}