import 'package:flutter/material.dart';
import 'package:muawwanah_grosir_flutter/config/global.dart';
import 'package:muawwanah_grosir_flutter/config/string.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});
  @override
  State<Sidebar> createState() => _SidebarState();
}
String ses_nama = "", ses_hakAkses = "";
class _SidebarState extends State<Sidebar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                      Icons.person
                  ),
                  Text(
                    ses_nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      ses_hakAkses,
                      style : const TextStyle(
                        fontStyle: FontStyle.italic,
                      )
                  )
                ],
              )
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Dashboard'),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Saldo'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Item'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Pegawai'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Supplier'),
                  ),
                ),
                Visibility(
                  child: ExpansionTile(
                    title: Text('Kelola Pelanggan'),
                    children: [
                      ListTile(
                        title: Text('Pelanggan'),
                        onTap: (){
                          Navigator.pushReplacementNamed(context, '/pelanggan');
                        },
                      ),
                      ListTile(
                        title: Text('Grup Pelanggan'),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Bangunan'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Persediaan'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Piutang'),
                  ),
                ),
                Visibility(
                  child: ExpansionTile(
                    title: Text('Laporan'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Pengaturan'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Hak Akses'),
                  ),
                ),
                Visibility(
                  child: ListTile(
                    title: Text('Kelola Akun'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  setProfile() async {
    ses_nama = await sessionGet(session_nama);
    ses_hakAkses = await sessionGet(session_hakAkses);
    setState((){});
  }
}