class MediaPreviewItem {
  final String image;
  final String title;
  final String url;
  final String? seasonDescription;

  MediaPreviewItem(
      {required this.image,
      required this.title,
      required this.url,
      this.seasonDescription});
}
