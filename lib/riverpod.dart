import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vid_fetch/service/download_service.dart';

final downloadStateProvider =
    StateNotifierProvider<DownloadStateNotifier, DownloadState>(
  (ref) => DownloadStateNotifier(),
);

class DownloadState {
  final bool isDownloading;
  final String? message;

  DownloadState({
    this.isDownloading = false,
    this.message,
  });

  DownloadState copyWith({
    bool? isDownloading,
    String? filePath,
    String? message,
  }) {
    return DownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      message: message ?? this.message,
    );
  }
}

class DownloadStateNotifier extends StateNotifier<DownloadState> {
  DownloadStateNotifier() : super(DownloadState());

  Future<void> downloadFile(String url, String fileName) async {
    state =
        state.copyWith(isDownloading: true, message: "Downloading $fileName");
    final message = await VideoDownloadService().downloadVideo(url);

    state = state.copyWith(isDownloading: false, filePath: message);
  }
}
