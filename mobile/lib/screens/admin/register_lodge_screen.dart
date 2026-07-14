import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../services/api_exception.dart';
import '../../services/lodge_options_service.dart';
import '../../services/lodge_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';

class RegisterLodgeScreen extends StatefulWidget {
  const RegisterLodgeScreen({super.key});

  @override
  State<RegisterLodgeScreen> createState() => _RegisterLodgeScreenState();
}

class _RegisterLodgeScreenState extends State<RegisterLodgeScreen> {
  int _step = 1;
  bool _isSubmitting = false;
  bool _isLookingUpCep = false;
  String? _cepError;

  Future<LodgeOptions>? _optionsFuture;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _number = TextEditingController();
  String? _rite;

  final _cep = TextEditingController();
  final _street = TextEditingController();
  final _addressNumber = TextEditingController();
  final _complement = TextEditingController();
  final _neighborhood = TextEditingController();
  final _city = TextEditingController();
  String? _state;

  final _adminName = TextEditingController();
  final _adminNickname = TextEditingController();
  final _adminCim = TextEditingController();
  final _adminCpf = TextEditingController();
  String? _adminDegree;
  final _adminEmail = TextEditingController();
  final _adminWhatsapp = TextEditingController();
  final _adminPassword = TextEditingController();
  final _adminPasswordConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _optionsFuture = LodgeOptionsService.instance.fetch();
  }

  @override
  void dispose() {
    for (final c in [
      _name, _email, _number, _cep, _street, _addressNumber, _complement,
      _neighborhood, _city, _adminName, _adminNickname, _adminCim, _adminCpf,
      _adminEmail, _adminWhatsapp, _adminPassword, _adminPasswordConfirm,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _lookupCep() async {
    final digits = onlyDigits(_cep.text);
    if (digits.length != 8) return;

    setState(() {
      _isLookingUpCep = true;
      _cepError = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://viacep.com.br/ws/$digits/json/'),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['erro'] == true) {
        setState(() => _cepError = 'CEP não encontrado.');
        return;
      }

      setState(() {
        _street.text = data['logradouro'] as String? ?? '';
        _neighborhood.text = data['bairro'] as String? ?? '';
        _city.text = data['localidade'] as String? ?? '';
        _state = data['uf'] as String?;
      });
    } catch (_) {
      setState(() => _cepError = 'Não foi possível consultar o CEP agora.');
    } finally {
      if (mounted) setState(() => _isLookingUpCep = false);
    }
  }

  void _goToStep2() {
    if (!_step1Key.currentState!.validate()) return;
    setState(() => _step = 2);
  }

  Future<void> _submit() async {
    if (!_step2Key.currentState!.validate()) return;

    if (_adminPassword.text != _adminPasswordConfirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final lodge = await LodgeService.instance.register({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'number': _number.text.trim(),
        'rite': _rite,
        'cep': onlyDigits(_cep.text),
        'address_street': _street.text.trim(),
        'address_number': _addressNumber.text.trim(),
        'address_complement': _complement.text.trim().isEmpty ? null : _complement.text.trim(),
        'address_neighborhood': _neighborhood.text.trim(),
        'city': _city.text.trim(),
        'state': _state,
        'admin_name': _adminName.text.trim(),
        'admin_nickname': _adminNickname.text.trim().isEmpty ? null : _adminNickname.text.trim(),
        'admin_cim': onlyDigits(_adminCim.text).isEmpty ? null : onlyDigits(_adminCim.text),
        'admin_cpf': onlyDigits(_adminCpf.text),
        'admin_degree': _adminDegree,
        'admin_email': _adminEmail.text.trim(),
        'admin_whatsapp': onlyDigits(_adminWhatsapp.text),
        'admin_password': _adminPassword.text,
      });

      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loja "${lodge.name}" cadastrada com sucesso.')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível conectar ao servidor.')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Loja')),
      body: FutureBuilder<LodgeOptions>(
        future: _optionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Não foi possível carregar as listas do formulário.'),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }

          final options = snapshot.data!;

          return Column(
            children: [
              _buildStepper(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: _step == 1
                      ? _buildStep1(options)
                      : _buildStep2(options),
                ),
              ),
              _buildActions(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepper() {
    Widget bar(bool filled) => Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: filled ? AppColors.navy : AppColors.powderBlueLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(children: [bar(true), bar(_step == 2)]),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border(top: BorderSide(color: AppColors.powderBlueLight, width: 1)),
      ),
      child: Row(
        children: [
          if (_step == 2) ...[
            OutlinedButton(
              onPressed: _isSubmitting ? null : () => setState(() => _step = 1),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Voltar'),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : (_step == 1 ? _goToStep2 : _submit),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : Text(_step == 1 ? 'Próximo' : 'Cadastrar Loja'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1(LodgeOptions options) {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _textField(_name, 'Nome da Loja', required: true),
          const SizedBox(height: 14),
          _textField(_email, 'E-mail de contato', required: true, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _textField(_number, 'Número da Loja', required: true),
          const SizedBox(height: 14),
          _dropdown('Rito', options.rites, _rite, (v) => setState(() => _rite = v)),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.powderBlueLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 16, color: AppColors.navy),
                SizedBox(width: 8),
                Text(
                  'Potência GOSP — constante do sistema',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2(LodgeOptions options) {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('Endereço da Loja'),
          _textField(
            _cep, 'CEP', required: true,
            inputFormatters: [CepInputFormatter()],
            keyboardType: TextInputType.number,
            onChanged: (_) => _lookupCep(),
            suffix: _isLookingUpCep
                ? const SizedBox(
                    width: 16, height: 16,
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          if (_cepError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(_cepError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ),
          const SizedBox(height: 14),
          _textField(_street, 'Logradouro', required: true),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _textField(_addressNumber, 'Número', required: true)),
              const SizedBox(width: 12),
              Expanded(child: _textField(_complement, 'Complemento', required: false)),
            ],
          ),
          const SizedBox(height: 14),
          _textField(_neighborhood, 'Bairro', required: true),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _textField(_city, 'Cidade', required: true)),
              const SizedBox(width: 12),
              Expanded(child: _dropdown('UF', options.states, _state, (v) => setState(() => _state = v))),
            ],
          ),

          _sectionLabel('Administrador da Loja'),
          _textField(_adminName, 'Nome completo', required: true),
          const SizedBox(height: 14),
          _textField(_adminNickname, 'Apelido', required: false),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _textField(
                  _adminCim, 'CIM', required: false,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _textField(
                  _adminCpf, 'CPF', required: true,
                  inputFormatters: [CpfInputFormatter()],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _dropdown('Grau', options.degrees, _adminDegree, (v) => setState(() => _adminDegree = v)),
          const SizedBox(height: 14),
          _textField(_adminEmail, 'E-mail (login)', required: true, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _textField(
            _adminWhatsapp, 'WhatsApp', required: true,
            inputFormatters: [WhatsappInputFormatter()],
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          _textField(_adminPassword, 'Senha', required: true, obscureText: true),
          const SizedBox(height: 14),
          _textField(_adminPasswordConfirm, 'Confirmar senha', required: true, obscureText: true),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.6,
          color: AppColors.navy,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    required bool required,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    int? maxLength,
    ValueChanged<String>? onChanged,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      maxLength: maxLength,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: required ? '$label *' : '$label (opcional)',
        counterText: '',
        suffixIcon: suffix,
      ),
      validator: required
          ? (value) => (value == null || value.trim().isEmpty) ? 'Campo obrigatório' : null
          : null,
    );
  }

  Widget _dropdown(
    String label,
    List<String> options,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: '$label *'),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis)))
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null || v.isEmpty ? 'Selecione uma opção' : null,
    );
  }
}
