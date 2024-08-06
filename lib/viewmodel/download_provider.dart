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

  Future<void> downloadVideo(String url) async {
    state = state.copyWith(
        isDownloading: true, message: "Downloading Video File...");
    final message = await VideoDownloadService().downloadVideo(url);

    state = state.copyWith(isDownloading: false, filePath: message);
  }

  Future<void> downloadAudio(String url) async {
    state = state.copyWith(
        isDownloading: true, message: "Downloading Audio File...");
    final message = await VideoDownloadService().downloadAudio(url);

    state = state.copyWith(isDownloading: false, filePath: message);
  }
}
