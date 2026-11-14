class EventItem {
  final String id;
  final String title;
  final String speaker;
  final String category;
  final String description;
  final String date;
  final String time;
  final String location;
  final String poster;
  final double price;

  const EventItem({
    required this.id,
    required this.title,
    required this.speaker,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.poster,
    required this.price,
  });
}
