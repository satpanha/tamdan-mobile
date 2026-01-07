String timeAgoShort(DateTime dt) {
  final d = DateTime.now().difference(dt);
  if (d.inDays >= 7) return '${(d.inDays / 7).floor()}w ago';
  if (d.inDays >= 1) return '${d.inDays}d ago';
  if (d.inHours >= 1) return '${d.inHours}h ago';
  if (d.inMinutes >= 1) return '${d.inMinutes}m ago';
  return 'just now';
}