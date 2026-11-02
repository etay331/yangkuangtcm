import 'package:flutter/material.dart';

void main() => runApp(const BookingApp());

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: '陽光中醫｜線上掛號',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff426b57)), scaffoldBackgroundColor: const Color(0xfff7f8f3)),
    home: const BookingPage(),
  );
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  String clinic = '示範院所';
  String? slot;
  DateTime date = DateUtils.dateOnly(DateTime.now().add(const Duration(days: 1)));
  bool booked = false;
  @override
  void dispose() { name.dispose(); phone.dispose(); super.dispose(); }
  String get dateText => '${date.year} 年 ${date.month} 月 ${date.day} 日';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: const Color(0xfff7f8f3), title: const Text('陽光中醫', style: TextStyle(fontWeight: FontWeight.w700)), centerTitle: true),
    body: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(22, 12, 22, 28), children: [
      const Text('用心照顧，從容就醫', style: TextStyle(color: Color(0xff668172), fontSize: 14)),
      const SizedBox(height: 8),
      const Text('線上掛號', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1)),
      const SizedBox(height: 8),
      const Text('選擇方便的時間，預約您的看診。', style: TextStyle(color: Colors.black54)),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xffe8efe9), borderRadius: BorderRadius.circular(14)), child: const Text('目前為操作示範，資料不會送出，也不會完成實際掛號。', style: TextStyle(color: Color(0xff426b57)))),
      const SizedBox(height: 24),
      if (booked) ...[
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.check_circle, color: Color(0xff426b57), size: 40), const SizedBox(height: 12),
          const Text('示範預約已建立', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12), Text('$clinic\n$dateText・$slot\n${name.text}'),
          const SizedBox(height: 12), const Text('這不是實際掛號，請勿以此作為就診憑證。'),
          TextButton(onPressed: () => setState(() => booked = false), child: const Text('修改預約')),
        ]))),
      ] else Form(key: form, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        label('選擇院所'),
        DropdownButtonFormField<String>(value: clinic, decoration: field(), items: const [DropdownMenuItem(value: '示範院所', child: Text('示範院所'))], onChanged: (v) => setState(() => clinic = v!)),
        const SizedBox(height: 20), label('選擇日期'),
        InkWell(onTap: () async { final selected = await showDatePicker(context: context, initialDate: date, firstDate: DateUtils.dateOnly(DateTime.now()), lastDate: DateTime.now().add(const Duration(days: 90))); if (selected != null) setState(() { date = selected; slot = null; }); }, child: InputDecorator(decoration: field(suffix: Icons.calendar_today_outlined), child: Text(dateText))),
        const SizedBox(height: 20), label('選擇時段'),
        Wrap(spacing: 8, runSpacing: 8, children: ['上午 09:00', '下午 14:00', '晚上 18:30'].map((s) => ChoiceChip(label: Text(s), selected: slot == s, onSelected: (_) => setState(() => slot = s))).toList()),
        const SizedBox(height: 20), label('姓名'),
        TextFormField(controller: name, decoration: field(hint: '請輸入姓名'), validator: (v) => v == null || v.trim().isEmpty ? '請輸入姓名' : null),
        const SizedBox(height: 20), label('手機號碼'),
        TextFormField(controller: phone, keyboardType: TextInputType.phone, decoration: field(hint: '請輸入手機號碼'), validator: (v) => v == null || !RegExp(r'^09\d{8}$').hasMatch(v.trim()) ? '請輸入 10 碼手機號碼' : null),
        const SizedBox(height: 26),
        SizedBox(width: double.infinity, height: 54, child: FilledButton(onPressed: () { if (form.currentState!.validate()) { if (slot == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請選擇看診時段'))); return; } setState(() => booked = true); } }, child: const Text('確認示範預約', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 12), const Center(child: Text('實際門診資訊與掛號規則需由院所提供', style: TextStyle(color: Colors.black45, fontSize: 12))),
      ])),
    ])),
  );
  Widget label(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)));
  InputDecoration field({String? hint, IconData? suffix}) => InputDecoration(hintText: hint, suffixIcon: suffix == null ? null : Icon(suffix), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffdce4dc))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffdce4dc))));
}
