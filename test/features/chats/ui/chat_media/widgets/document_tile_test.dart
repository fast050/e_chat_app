import 'package:e_chat_app/features/chats/ui/chat_media/widgets/document_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the name, size and type, and reports a download tap',
      (tester) async {
    var downloads = 0;

    await tester.pumpApp(DocumentTile(
      name: 'War and Peace',
      sizeLabel: '14.2 GB',
      extension: 'pdf',
      isDownloaded: false,
      onDownload: () => downloads++,
    ));

    expect(find.text('War and Peace'), findsOneWidget);
    expect(find.text('14.2 GB'), findsOneWidget);
    expect(find.text('pdf'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.file_download_outlined));

    expect(downloads, 1);
  });

  testWidgets('shows a check and ignores taps once downloaded',
      (tester) async {
    var downloads = 0;

    await tester.pumpApp(DocumentTile(
      name: 'War and Peace',
      sizeLabel: '14.2 GB',
      extension: 'pdf',
      isDownloaded: true,
      onDownload: () => downloads++,
    ));

    expect(find.byIcon(Icons.file_download_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.check));

    expect(downloads, 0);
  });
}
