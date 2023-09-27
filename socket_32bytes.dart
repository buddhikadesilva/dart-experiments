import 'dart:io';

void main() async {
  final String serverIp = '127.0.0.1';
  final int serverPort = 12345;

  try {
    final socket = await Socket.connect(serverIp, serverPort);

    // Send a request to the server
    socket.writeln('Hello, server!');

    // Create a buffer to store the received data
    final receivedData = <int>[];

    // Listen for data from the server
    socket.listen(
      (data) {
        receivedData.addAll(data);

        // Check if we have received 32 bytes of data
        if (receivedData.length == 32) {
          // Handle the 32 bytes of data
          print('Received 32 bytes from server: ${receivedData}');
          
          // Clear the buffer for the next data
          receivedData.clear();
        }
      },
      onDone: () {
        print('Server disconnected.');
        socket.destroy();
      },
      onError: (error) {
        print('Error: $error');
        socket.destroy();
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}
