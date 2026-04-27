class Failure{
  int status;
  String message;

  Failure(this.status, this.message);
}

class ActiveAccountFailure extends Failure {
  ActiveAccountFailure({required int status,required String message}) : super(status,message);
}
