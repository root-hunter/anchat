import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:anchat/src/generated/protos/helloworld.pbgrpc.dart';

import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
//TODO STREAMING BIDIREZIONALE PER BINDING INIZIALE

void main() async {
  await GetStorage.init();
  final box = GetStorage();

  if(box.read('uuid') == null){
    var uuid = Uuid();
    box.write('uuid', uuid.v4());
  }
  runApp(const MyApp());

}
class GreeterService extends GreeterServiceBase {
  final List<LiveServerReply> device;
  final Function(LiveServerReply) onNewDevice;

  GreeterService({required this.device, required this.onNewDevice}) : super();

  @override
  Future<HelloReply> sayHello(ServiceCall call, HelloRequest request) async {
    return HelloReply()..message = 'Hello, ${request.name}!';
  }

  @override
  Future<LiveServerReply> activeServer(ServiceCall call, LiveServerReply request) async {
    log("RICHIESTA");

    onNewDevice(request);
    return await generateLiveServerReply();
  }

  static Future<LiveServerReply> generateLiveServerReply() async {
    final LiveServerReply response = LiveServerReply();

    final box = GetStorage();

    response.deviceId = box.read('uuid') ?? "";

    response.localName = Platform.localeName;
    response.localHostname = Platform.localHostname;
    response.version = Platform.version;
    response.ip = await NetworkInfo().getWifiIP() ?? "0.0.0.0";

    if(Platform.isAndroid){
      response.os = DeviceOs.ANDROID;
    }else if(Platform.isIOS){
      response.os = DeviceOs.IOS;
    }else if(Platform.isLinux){
      response.os = DeviceOs.LINUX;
    }else if(Platform.isWindows){
      response.os = DeviceOs.WINDOWS;
    }else if(Platform.isFuchsia){
      response.os = DeviceOs.FUCHSIA;
    }else{
      response.os = DeviceOs.OTHER;
    }

    return response;
  }
}

enum DiscoveryState{
  STOP,
  PAUSE,
  RUN,
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ElevatedCardExample extends StatelessWidget {
  final LiveServerReply response;

  const ElevatedCardExample({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image logo = setOsLogoImage();

    return Center(
      child: Card(
        child: FlatButton(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20), child: logo,),
              Divider(color: Colors.black26, height: 2,),
              Padding(padding: EdgeInsets.all(5), child: Text("${response.ip}"),),
            ],
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Image setOsLogoImage() {
    Image logo;

    if(response.os == DeviceOs.ANDROID){
      logo = Image.asset("assets/os/logos/android.png");
    }else if(response.os == DeviceOs.IOS){
      logo = Image.asset("assets/os/logos/ios.png");
    }else if(response.os == DeviceOs.LINUX){
      logo = Image.asset("assets/os/logos/linux.png");
    }else if(response.os == DeviceOs.WINDOWS){
      logo = Image.asset("assets/os/logos/windows.png");
    }else if(response.os == DeviceOs.FUCHSIA){
      logo = Image.asset("assets/os/logos/fuchsia.png");
    }else{
      logo = Image.asset("assets/os/logos/other.png");
    }
    return logo;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  DiscoveryState discoveryState = DiscoveryState.STOP;

  late String uuid;
  late Socket socket;

  void dataHandler(data){
    print("LA ROBA FUNZIONA");
  }

  void errorHandler(error, StackTrace trace){
  }

  void doneHandler(){
    socket.destroy();
  }

  Future<void> discoveryDevice(List<String> args) async {
    try{
      String? ip = await NetworkInfo().getWifiIP() ;
      String? subnet = await NetworkInfo().getWifiSubmask();

      List<int> ipA = ip!.split('.').map<int>((e) {
        return int.parse(e);
      }).toList();

      List<int> subnetA = subnet!.split('.').map<int>((e) {
        return int.parse(e);
      }).toList();

      final List fixedList = Iterable<int>.generate(ipA.length).toList();

      List<List<int>> el = fixedList.map((idx) {
        int value = ipA[idx] & subnetA[idx];

        if(value != ipA[idx]){
          return [1, value];
        }else{
          return [0, value];
        }
      }).toList();

      int pckN = el.where((element) => element[0] == 1).length;

      List<String> rangeIp = [];

      if(pckN == 3){

      }else if(pckN == 2){
        int f1 = el[2][1];
        for(int j = f1; j < 255; ++j){
          for(int k = 1; k < 255; ++k){
            String tmpIp = el.map((e) => e[1]).join(".");
            checkSocket(tmpIp, ip);

            if(el[3][1] < 255){
              el[3][1] += 1;
            }else{
              el[3][1] = 0;
            }
          }
          el[2][1] += 1;
        }
      }else if(pckN == 1){
        for(int i = pckN; i > 0; --i){
          int w = el.length - i;
          for(int k = el[w][1]; k < 255; ++k){
            el[w][1] += 1;
            String tmpIp = el.map((e) => e[1]).join(".");
            checkSocket(tmpIp, ip);
          }
        }
      }
    }catch(e){

    }
  }

  void checkSocket(String tmpIp, String ip) {
    Socket
        .connect(tmpIp, 50051)
        .then((Socket sock) {
      socket = sock;
      socket
          .listen(
              (event) async {
            if(ip != tmpIp){
              log("TROVATO IP VALIDO: $tmpIp");

              log(Platform.localeName);
              log(Platform.localHostname);
              log(Platform.version);
              log(tmpIp);

              /*
              final cert = await rootBundle.load('assets/cert/cert.pem');

              final certAsList = cert.buffer
                  .asUint8List(cert.offsetInBytes, cert.lengthInBytes);
              log(cert.toString());
              */

              final channel = ClientChannel(
                tmpIp,
                port: 50051,
                options: ChannelOptions(
                  credentials: ChannelCredentials.insecure(),
                  codecRegistry: CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
                ),
              );
              final stub = GreeterClient(channel);

              try {
                final response = await stub.activeServer(
                  await GreeterService.generateLiveServerReply(),
                  options: CallOptions(compression: const GzipCodec()),
                );
                print('Greeter client received: ${response.ip}');
                
                addDeviceIfNotPresent(response);
                await writeDeviceToDisk(response);
              } catch (e) {
                print('Caught error: $e');
              }
              await channel.shutdown();
            }
          },
          onError: errorHandler,
          cancelOnError: true
      );
    })
        .onError((error, stackTrace) {});
  }

  Future<void> writeDeviceToDisk(LiveServerReply response) async {
    final path = await _localPath;
    
    Directory("$path/devices").createSync(recursive: true);
    final file = File("$path/devices/${response.deviceId}");
    file.writeAsBytes(response.writeToBuffer(),
        flush: true,
        mode: FileMode.writeOnly)
        .then((value) {
      log("FILE SCRITTO");
      log(value.toString());
    });
  }

  void addDeviceIfNotPresent(LiveServerReply response) {
    int isPresent = -1;

    for(int i = 0; i < device.length; ++i){
      if(device[i].deviceId == response.deviceId){
        isPresent = i;
        break;
      }
    }

    setState(() {
      if(isPresent >= 0){
        device[isPresent] = response;
      }else{
        device.add(response);
      }
      log(response.toDebugString());
    });
  }

  void _incrementCounter() {
    if(discoveryState == DiscoveryState.STOP){
      discoveryState = DiscoveryState.RUN;
    }else if(discoveryState == DiscoveryState.PAUSE){
      discoveryState = DiscoveryState.RUN;
    }else if(discoveryState == DiscoveryState.RUN){
      discoveryState = DiscoveryState.STOP;
    }
    discoveryDevice([]);
  }

  List<LiveServerReply> device = [];

  @override
  void initState() {
    final box = GetStorage();

    uuid = box.read('uuid') ?? "ERROR";

    startServer();
    loadDevicesFromDisk();
    super.initState();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<void> startServer() async {

    final cert = await rootBundle.load('assets/cert/cert.pem');

    final certAsList = cert.buffer
        .asUint8List(cert.offsetInBytes, cert.lengthInBytes);

    final key = await rootBundle.load('assets/cert/key.pem');

    final keyAsList = key.buffer
        .asUint8List(key.offsetInBytes, key.lengthInBytes);

    log(certAsList.toString());

    final server = Server(
      [GreeterService(
          device: device,
          onNewDevice: (newDevice) {
        addDeviceIfNotPresent(newDevice);
      })],
      const <Interceptor>[],
      CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
    );
    await server.serve(
        port: 50051,
    )
        .then((value) => print("RICHIESTA"));

    
    print('Server listening on port ${server.port}...');
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Flexible(child: Text("UUID: $uuid"))
            ],
          ),
          GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: EdgeInsets.all(20),
              children: device.map((e) => ElevatedCardExample(response: e)).toList()
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> loadDevicesFromDisk() async {
    final path = await _localPath;
    
    Directory("$path/devices")
        .list(recursive: false)
        .forEach((element) async {
          log(element.toString());
          final file = File(element.path);
    
          LiveServerReply loadedDevice =  LiveServerReply.fromBuffer(file.readAsBytesSync());
    
          checkSocket(loadedDevice.ip, await NetworkInfo().getWifiIP() ?? '');
        });
  }
}
