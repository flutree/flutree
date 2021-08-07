void main() {
  String url = Uri.https('firestore.googleapis.com',
          '/v1/projects/linktree-clone-flutter/databases/(default)')
      .toString();

  print(url);
}
