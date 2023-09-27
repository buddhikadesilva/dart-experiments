import 'dart:io';
import 'dart:typed_data';

void main() async {
  final String serverIp = '127.0.0.1';
  final int serverPort = 12345;

  try {
    final socket = await Socket.connect(serverIp, serverPort);

    // Send a request to the server
    socket.writeln('Hello, server!');

    // Listen for data from the server
    socket.listen(
      (data) {
        // Assuming the server sends a 32-bit integer in little-endian format
        if (data.length == 4) {
          // Convert the received bytes to a 32-bit integer
          final int receivedValue = ByteData.sublistView(Uint8List.fromList(data)).getUint32(0, Endian.little);
          
          // Handle the received 32-bit integer
          print('Received 32-bit integer from server: $receivedValue');
        } else {
          // Handle other data types or unexpected data
          print('Received unexpected data from server: ${String.fromCharCodes(data)}');
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
