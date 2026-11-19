import 'package:flutter/material.dart';
void main() => runApp(const KanyoviApp());
class KanyoviApp extends StatelessWidget {
  const KanyoviApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, title: 'Kanyovi Chat', home: const HomeScreen());
  }
}
enum Lang { rw, en, fr }
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  Lang lang = Lang.rw;
  bool showPhone = false;
  final phoneCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  bool codeSent = false;
  String errorMsg = '';
  String t(String rw, String en, String fr) {
    if (lang == Lang.rw) return rw;
    if (lang == Lang.en) return en;
    return fr;
  }
  Widget logo() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 68, height: 68, decoration: BoxDecoration(color: const Color(0xFF1A8A4A), borderRadius: BorderRadius.circular(14)),
        child: Center(child: Stack(clipBehavior: Clip.none, children: [
          Container(width: 48, height: 42, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('K', style: TextStyle(color: Color(0xFF1A8A4A), fontSize: 28, fontWeight: FontWeight.bold)))),
          Positioned(bottom: -4, right: 8, child: Transform.rotate(angle: 0.7, child: Container(width: 10, height: 10, color: Colors.white))),
        ]))),
      const SizedBox(width: 12),
      const Text('Kanyovi Chat', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF0F4D1F))),
    ]);
  }
  Widget flagRw() => ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 60, height: 42, child: Column(children: [
    Expanded(flex: 2, child: Container(color: const Color(0xFF00A1DE), child: const Align(alignment: Alignment.topRight, child: Text('☀️')))),
    Expanded(child: Container(color: const Color(0xFFFCD116))), Expanded(child: Container(color: const Color(0xFF20603D)))])));
  Widget flagUK() => ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 60, height: 42, color: const Color(0xFF012169), child: const Center(child: Text('🇬🇧', style: TextStyle(fontSize: 28)))));
  Widget flagFr() => ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(width: 60, height: 42, child: Row(children: [
    Expanded(child: Container(color: Colors.blue[900])), Expanded(child: Container(color: Colors.white)), Expanded(child: Container(color: Colors.red))])));

  Widget langCard(Lang l, String label, Widget flag) {
    bool sel = lang == l;
    return GestureDetector(onTap: () => setState(() => lang = l),
      child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: sel ? const Color(0xFF1A8A4A) : Colors.grey, width: sel ? 2.5 : 1.2), borderRadius: BorderRadius.circular(16), color: sel ? const Color(0xFFEAF5E8) : Colors.white),
        child: Row(children: [Icon(sel ? Icons.radio_button_checked : Icons.radio_button_off, color: sel ? const Color(0xFF1A8A4A) : Colors.black),
          const SizedBox(width: 12), Expanded(child: Text(label, style: TextStyle(fontSize: 19, fontWeight: sel ? FontWeight.bold : FontWeight.w500))), flag])));
  }

  // 1. CORRIGÉ : Verify ne marche QUE si Send SMS déjà fait + code = 123456
  void verifyCode() {
    if (!codeSent) {
      setState(() => errorMsg = t('Bananza kanda Send SMS Code!', 'First tap Send SMS Code!', 'D’abord, appuie sur Send SMS Code !'));
      return;
    }
    if (codeCtrl.text.trim() != '123456') {
      setState(() => errorMsg = t('Code si yo! Gerageza 123456', 'Wrong code! Try 123456', 'Mauvais code ! Essaie 123456'));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatListScreen(lang: lang, phone: phoneCtrl.text)));
  }

  @override
  Widget build(BuildContext context) {
    if (showPhone) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kanyovi Chat'), backgroundColor: const Color(0xFF1A8A4A), foregroundColor: Colors.white, leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => showPhone = false))),
        body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          logo(),
          const SizedBox(height: 20),
          Text(t('Injiza numero ya telefone', 'Enter your phone number', 'Entre ton numéro de téléphone'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(hintText: '+250 78...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.phone))),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { if (phoneCtrl.text.isEmpty) return; setState(() { codeSent = true; errorMsg = ''; }); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A8A4A)), child: Text(t('Send SMS Code', 'Send SMS Code', 'Envoyer le code SMS'), style: const TextStyle(color: Colors.white, fontSize: 17)))),
          if (codeSent) ...[
            const SizedBox(height: 20),
            Text(t('Injiza code ya 6', 'Enter 6-digit code', 'Entre le code à 6 chiffres'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: codeCtrl, keyboardType: TextInputType.number, maxLength: 6, decoration: InputDecoration(hintText: '123456', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: verifyCode, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text(t('Verify Code', 'Verify Code', 'Vérifier le code'), style: const TextStyle(color: Colors.white)))),
          ],
          if (errorMsg.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 12), child: Center(child: Text(errorMsg, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))),
        ])),
      );
    }
    return Scaffold(backgroundColor: Colors.white, body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Column(children: [
      logo(),
      const SizedBox(height: 16),
      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFFBFDCA0), borderRadius: BorderRadius.circular(22)),
        child: Column(children: [
          Text(t('Hitamo ururimi', 'Choose your language', 'Choisis ta langue'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F4D1F))),
          const SizedBox(height: 4),
          Text(t('Urakaza neza kuri "Kanyovi Chat"', 'Welcome to "Kanyovi Chat"', 'Bienvenue sur "Kanyovi Chat"'), style: const TextStyle(fontSize: 16, color: Color(0xFF0F4D1F))),
        ])),
      const SizedBox(height: 10),
      Text(t('HITAMO URURIMI', 'SELECT YOUR LANGUAGE', 'SÉLECTIONNE TA LANGUE'), style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 12),
      langCard(Lang.rw, '1. Kinyarwanda', flagRw()),
      langCard(Lang.en, '2. English', flagUK()),
      langCard(Lang.fr, '3. Français', flagFr()),
      const SizedBox(height: 6),
      Text(t("Nukomeza, uraba wemeye Amategeko n'Amabwiriza yacu !", 'By continuing, you agree to our Terms and Privacy Policy !', 'En continuant, tu acceptes nos Termes et Politique de confidentialité !'), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF1A8A4A), fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(onPressed: () => setState(() => showPhone = true), icon: const Icon(Icons.phone, color: Colors.white), label: Text(t('Komeza ukoresheje Telefone', 'Continue with Phone Number', 'Continuer avec Téléphone'), style: const TextStyle(color: Colors.white, fontSize: 16)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A8A4A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))))),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, height: 52, child: OutlinedButton.icon(onPressed: () {}, icon: const Text('G', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue)), label: Text(t('Komeza ukoresheje Google', 'Continue with Google', 'Continuer avec Google'), style: const TextStyle(fontSize: 17, color: Colors.black)), style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))))),
      const SizedBox(height: 16), const Text('Powered by KANYOVI-ICT Ltd.'), const Text('Contact: zirahiga@usa.com'),
    ]))));
  }
}

// 2. CORRIGÉ : TOUS les contacts sont cliquables
class ChatListScreen extends StatelessWidget {
  final Lang lang; final String phone;
  const ChatListScreen({super.key, required this.lang, required this.phone});
  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Kanyovi Support', 'msg': 'Murakaza neza kuri Kanyovi Chat !', 'time': '12:00', 'letter': 'K'},
      {'name': 'Maman', 'msg': 'Uraho?', 'time': '11:45', 'letter': 'M'},
      {'name': 'Jean', 'msg': 'Tuganire', 'time': '10:20', 'letter': 'J'},
      {'name': 'Marie', 'msg': 'Amakuru?', 'time': '09:15', 'letter': 'M'},
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Kanyovi Chat - $phone'), backgroundColor: const Color(0xFF1A8A4A), foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (_, i) {
          final c = contacts[i];
          return ListTile(
            leading: CircleAvatar(backgroundColor: const Color(0xFF1A8A4A), child: Text(c['letter']!, style: const TextStyle(color: Colors.white))),
            title: Text(c['name']!),
            subtitle: Text(c['msg']!),
            trailing: Text(c['time']!),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatDetail(name: c['name']!))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: const Color(0xFF1A8A4A), onPressed: () {}, child: const Icon(Icons.chat, color: Colors.white)),
    );
  }
}

// 3. CORRIGÉ : Bouton Envoyer envoie vraiment le message
class ChatDetail extends StatefulWidget {
  final String name;
  const ChatDetail({super.key, required this.name});
  @override
  State<ChatDetail> createState() => _ChatDetailState();
}
class _ChatDetailState extends State<ChatDetail> {
  final msgCtrl = TextEditingController();
  final List<String> messages = ['Murakaza neza! Urakoze kwinjira.'];
  void send() {
    if (msgCtrl.text.trim().isEmpty) return;
    setState(() {
      messages.add(msgCtrl.text.trim());
      msgCtrl.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name), backgroundColor: const Color(0xFF1A8A4A), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: messages.length,
            itemBuilder: (_, i) {
              bool mine = i != 0;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: mine ? const Color(0xFF1A8A4A) : Colors.grey[200], borderRadius: BorderRadius.circular(16)),
                  child: Text(messages[i], style: TextStyle(color: mine ? Colors.white : Colors.black, fontSize: 16)),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Expanded(child: TextField(controller: msgCtrl, onSubmitted: (_) => send(), decoration: const InputDecoration(hintText: 'Andika ubutumwa...', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24)))))),
            const SizedBox(width: 8),
            FloatingActionButton(mini: true, backgroundColor: const Color(0xFF1A8A4A), onPressed: send, child: const Icon(Icons.send, color: Colors.white)),
          ]),
        ),
      ]),
    );
  }
}