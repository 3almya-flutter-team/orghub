class DownloadFileStates {}

class FileDownloadStatesStart extends DownloadFileStates {}

class FileDownloadStatesSuccess extends DownloadFileStates {}

class FileDownloadStatesFailed extends DownloadFileStates {
  int errType;
  String msg;
  FileDownloadStatesFailed({
    this.errType,
    this.msg,
  });
}
