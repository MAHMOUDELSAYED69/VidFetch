import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vid_fetch/utils/extentions/extentions.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloadService {
  final YoutubeExplode _youtubeExplode = YoutubeExplode();

  Future<String> downloadVideo(String videoUrl,
      {String quality = 'high'}) async {
    try {
      final videoId = VideoId(videoUrl);
      final video = await _youtubeExplode.videos.get(videoId);
      final manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      StreamInfo? streamInfo;
      switch (quality) {
        case '1080p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.high1080);
          break;
        case '720p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.high720);
          break;
        case '480p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.medium480);
          break;
        case '360p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.medium360);
          break;
        case '240p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.low240);
          break;
        case '144p':
          streamInfo = manifest.muxed.firstWhereOrNull(
              (stream) => stream.videoQuality == VideoQuality.low144);
          break;
        case 'highest':
        default:
          streamInfo = manifest.muxed.withHighestBitrate();
          break;
      }

      streamInfo ??= manifest.muxed.withHighestBitrate();

      final filePath = await _getFilePath(video.title, 'mp4');
      if (filePath == null) {
        return "File path not selected";
      }

      final fileStream = File(filePath).openWrite();
      final videoStream = _youtubeExplode.videos.streamsClient.get(streamInfo);

      await videoStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      if (Platform.isAndroid) {
        await ImageGallerySaver.saveFile(filePath);
        log('Video downloaded and saved to gallery: $filePath');
        return "Downloaded and saved to gallery";
      } else {
        log('Video downloaded: $filePath');
        return "Downloaded to $filePath";
      }
    } catch (err) {
      log(err.toString());
      return "Error downloading video";
    }
  }

  Future<String> downloadAudio(String videoUrl,
      {String quality = 'high'}) async {
    try {
      final videoId = VideoId(videoUrl);
      final video = await _youtubeExplode.videos.get(videoId);
      final manifest =
          await _youtubeExplode.videos.streamsClient.getManifest(videoId);

      StreamInfo? streamInfo;
      switch (quality) {
        case 'high':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        case 'medium':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        case 'low':
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
        default:
          streamInfo = manifest.audioOnly.withHighestBitrate();
          break;
      }

      final filePath = await _getAudioFilePath(video.title, 'mp3');
      if (filePath == null) {
        return "File path not selected";
      }

      final fileStream = File(filePath).openWrite();
      final audioStream = _youtubeExplode.videos.streamsClient.get(streamInfo);

      await audioStream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
      log('Audio downloaded: $filePath');
      return "Downloaded to $filePath";
    } catch (err) {
      log(err.toString());
      return "Error downloading audio";
    }
  }

  Future<String?> _getAudioFilePath(String title, String extension) async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      final musicDir = Directory('${directory?.path}/Music');
      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }
      return '${musicDir.path}/Vid_Fetch_${title.replaceAll(' ', '_')}.$extension';
    } else if (Platform.isWindows) {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Vid_Fetch_${title.replaceAll(' ', '_')}.$extension',
      );

      if (result != null) {
        return result;
      } else {
        log('User canceled the picker');
        return null;
      }
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }

  Future<String?> _getFilePath(String title, String extension) async {
    if (Platform.isAndroid) {
      final directory = await getTemporaryDirectory();
      return '${directory.path}/Vid_Fetch_${title.replaceAll(' ', '_')}.$extension';
    } else if (Platform.isWindows) {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'Vid_Fetch_${title.replaceAll(' ', '_')}.$extension',
      );

      if (result != null) {
        return result;
      } else {
        log('User canceled the picker');
        return null;
      }
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }
}

// class DownloadService {
//   final Dio _dio = Dio();

//   Future<String?> downloadFile(String url, String fileName) async {
//     try {
//       final dir = await getApplicationDocumentsDirectory();
//       final savePath = "${dir.path}/$fileName";

//       log("Save path: $savePath");

//       final response = await _dio.download(
//         url,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             log("${(received / total * 100).toStringAsFixed(0)}%");
//           }
//         },
//       );

//       if (response.statusCode == 200) {
//         log("Download completed successfully");
//       } else {
//         log("Download failed with status code: ${response.statusCode}");
//       }

//       final file = File(savePath);
//       final fileSize = await file.length();
//       log("Downloaded file size: $fileSize bytes");

//       if (fileSize < 1000) {
//         log("Downloaded file is too small, possibly incomplete.");
//         file.deleteSync();
//         throw Exception("Downloaded file is incomplete.");
//       }

//       if (Platform.isAndroid) {
//         final result = await ImageGallerySaver.saveFile(savePath);
//         log("File saved to gallery: $result");
//       } else {
//         log("Web platform: Download completed.");
//       }

//       return savePath;
//     } catch (e) {
//       log("Download failed: $e");
//       return null;
//     }
//   }
// }
