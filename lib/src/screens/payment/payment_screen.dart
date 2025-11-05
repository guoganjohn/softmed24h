import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/services/ibge_service.dart';
import 'package:softmed24h/src/services/viacep_service.dart';
import 'package:softmed24h/src/utils/api_service.dart'; // Import ApiService
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:softmed24h/src/utils/input_formatters.dart';
import 'package:softmed24h/src/utils/session_manager.dart'; // Import SessionManager
import 'package:softmed24h/src/widgets/app_button.dart';

// --- ENUM FOR PAYMENT METHOD ---
enum PaymentMethod { creditCard, pixBoleto }

// --- MAIN SCREEN WIDGET ---
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;
  bool _saveCardChecked = false;
  User? _currentUser; // Declare User state variable

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _pagadorController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();

  Map<String, dynamic>? _addressData;
  bool _isCepFilled = false;
  bool _showManualAddress = false;
  List<String> _states = [];
  List<String> _cities = [];
  String? _selectedState;
  String? _selectedCity;

  final ViaCepService _viaCepService = ViaCepService();
  final IbgeService _ibgeService = IbgeService();

  // Global key for form validation
  final _formKey = GlobalKey<FormState>();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {}); // To rebuild the widget when tab changes
    });
    _fetchUserData(); // Fetch user data on init
    _fetchStates();
    _cepController.addListener(() {
      if (_cepController.text.length == 9) {
        _fetchAddressFromCep();
      }
    });
  }

  Future<void> _fetchUserData() async {
    final sessionManager = SessionManager();
    final apiService = ApiService();
    bool shouldLogout = false;
    try {
      final token = await sessionManager.getToken();
      if (token == null) {
        await sessionManager.clearToken();
        shouldLogout = true;
      } else {
        final isExpired = await sessionManager.isTokenExpired();
        if (isExpired) {
          await sessionManager.clearToken();
          shouldLogout = true;
        } else {
          final user = await apiService.getCurrentUser(token);
          setState(() {
            _currentUser = user;
          });
        }
      }
    } catch (e) {
      await sessionManager.clearToken();
      shouldLogout = true;
    }

    if (shouldLogout && mounted) {
      context.go('/');
    }
  }

  Future<void> _fetchStates() async {
    try {
      final states = await _ibgeService.fetchStates();
      setState(() {
        _states = states;
      });
    } catch (e) {
      _showSnackBar('Failed to load states', Colors.red);
    }
  }

  Future<void> _fetchCities(String state) async {
    if (!mounted) return;
    try {
      final cities = await _ibgeService.fetchCities(state);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      _showSnackBar('Failed to load cities', Colors.red);
    }
  }

  Future<void> _fetchAddressFromCep() async {
    try {
      final address = await _viaCepService.fetchAddress(_cepController.text);
      setState(() {
        _addressData = address;
        _logradouroController.text = address['logradouro'] ?? '';
        _bairroController.text = address['bairro'] ?? '';
        _selectedState = address['uf'] ?? '';
        _fetchCities(_selectedState!).then((_) {
          setState(() {
            _selectedCity = address['localidade'] ?? '';
          });
        });
        _isCepFilled = true;
      });
    } catch (e) {
      _showSnackBar('Failed to load address from CEP', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    _pagadorController.dispose();
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    super.dispose();
  }

  // Mock function for payment
  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethod == PaymentMethod.pixBoleto) {
        // Handle PIX payment
        final sessionManager = SessionManager();
        final apiService = ApiService();
        final token = await sessionManager.getToken();
        if (token == null) {
          if (mounted) {
            _showSnackBar(
              'Sessão expirada. Por favor, faça login novamente.',
              Colors.red,
            );
            context.go('/');
          }
          return;
        }

        _showSnackBar('Gerando PIX...', AppColors.primary);
        await apiService.createPixPayment(
          token,
          4990,
          "Assinatura Softmed24h",
        ); // Amount in cents
        _showSnackBar('PIX gerado com sucesso!', Colors.green);
      } else {
        // Handle Credit Card or Pix/Boleto payment
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pagamento em processamento...')),
        );
        // Simulate API call delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sucesso! Simulação de pagamento concluída.'),
              ),
            );
          }
        });
      }
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/home');
              },
              child: const Text(
                'Minha Conta',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Sair',
              width: 150,
              height: 40,
              fontSize: 18,
              icon: Icons.logout,
              iconSize: 20,
              onPressed: _logout,
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    await SessionManager().clearToken();
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    // Determine the maximum width for the form card on large screens
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: contentWidth),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Inactive Subscription Warning
                _buildWarningBanner(),
                const SizedBox(height: 16),
                // 2. Main Content Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Tabs (Mocked as just Payment)
                          _buildTabs(),
                          const SizedBox(height: 32),
                          if (_tabController?.index == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Plan Details
                                _buildPlanDetails(),
                                const Divider(height: 32),
                                // Order Data
                                _buildOrderData(),
                                const Divider(height: 32),
                                // Account Data
                                _buildAccountData(),
                                const Divider(height: 32),
                                // Payment Data (Credit Card Form)
                                _buildPaymentData(),
                              ],
                            )
                          else
                            _buildEmptyHistory(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Payment Button
                if (_tabController?.index == 0 &&
                    (_selectedPaymentMethod == PaymentMethod.creditCard ||
                        _selectedPaymentMethod == PaymentMethod.pixBoleto))
                  _buildPaymentButton(),
                const SizedBox(height: 24),
                // Legal Disclaimer
                _buildLegalDisclaimer(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildWarningBanner() {
    if (_currentUser == null || _currentUser!.hasActivePayment) {
      return const SizedBox.shrink(); // Don't show banner if user data is not loaded or if there's an active payment
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE), // Light red background
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Atenção: Sua assinatura encontra-se inativa. Pague agora mesmo para desfrutar dos benefícios de fazer parte da plataforma de saúde.',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Pagamento'),
        Tab(text: 'Histórico de Pagamentos'),
      ],
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade600,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.0),
        child: Text(
          'Nenhum histórico de pagamento encontrado.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF), // Very light blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Icon and Title
          Column(
            children: [
              Image.asset('assets/images/logo.png', height: 40),
              const SizedBox(height: 8),
              const Text(
                'R\$ 49,90',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Right side: Plan description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atendimento Médico 24H',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ATENDIMENTO PREMIUM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                // Features list
                _buildFeatureBullet('Atendimento para todas as idades.'),
                _buildFeatureBullet('Telemedicina.'),
                _buildFeatureBullet('Receitas e Atestados.'),
                _buildFeatureBullet('Solicitação de exames e acompanhamento.'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      side: BorderSide(color: Colors.blue.shade700),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Selecionar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.black)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildOrderData() {
    return _InfoSection(
      title: 'Dados do Pedido',
      children: [
        const SizedBox(height: 8),
        // Credit Card Radio
        _buildPaymentRadio(
          title: 'Cartão de Crédito',
          value: PaymentMethod.creditCard,
        ),

        // Pix/Boleto Radio
        _buildPaymentRadio(
          title: 'Pix / Boleto de Consulta',
          value: PaymentMethod.pixBoleto,
        ),
        const SizedBox(height: 8),
        if (_selectedPaymentMethod == PaymentMethod.creditCard)
          const Text(
            'O seu pedido é pago online, utilizando cartão de crédito. Todo o processamento do pagamento é realizado de maneira automatizada.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        else if (_selectedPaymentMethod == PaymentMethod.pixBoleto)
          const Text(
            'O seu pedido é pago online, utilizando Pix. Todo o processamento do pagamento é realizado de maneira automatizada.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
      ],
    );
  }

  Widget _buildPaymentRadio({
    required String title,
    required PaymentMethod value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      leading: Radio<PaymentMethod>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue!;
          });
        },
      ),
      dense: true,
      horizontalTitleGap: 0,
    );
  }

  Widget _buildAccountData() {
    if (_currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return _InfoSection(
      title: 'Dados da Conta',
      children: [
        const Text('Responsável:'),
        const SizedBox(height: 8),
        _buildReadOnlyField('Nome:', _currentUser!.name ?? 'N/A'),
        _buildReadOnlyField('Email:', _currentUser!.email),
        _buildReadOnlyField('Celular:', _currentUser!.phone),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentData() {
    return _InfoSection(
      title: 'Dados de Pagamento',
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              if (_currentUser != null) {
                setState(() {
                  _pagadorController.text = _currentUser!.name ?? '';
                  _cpfController.text = _currentUser!.cpf ?? '';
                  _phoneController.text = _currentUser!.phone ?? '';
                });
              }
            },
            child: const Text(
              'Utilizar Meus Dados',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        // Credit Card Form
        if (_selectedPaymentMethod == PaymentMethod.creditCard)
          Column(
            children: [
              _PaymentTextField(
                controller: _nameController,
                label: 'Nome Impresso no Cartão',
                hintText: 'Nome completo no cartão',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              _PaymentTextField(
                controller: _cardNumberController,
                label: 'Número do Cartão',
                hintText: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                validator: (value) => value == null || value.length < 16
                    ? 'Número de cartão inválido'
                    : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _PaymentTextField(
                      controller: _expiryController,
                      label: 'Validade',
                      hintText: 'MM/AA',
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateInputFormatter(),
                      ],
                      validator: (value) => value == null || value.length < 5
                          ? 'Data inválida (MM/AA)'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PaymentTextField(
                      controller: _cvvController,
                      label: 'Código de Segurança',
                      hintText: 'CVV',
                      keyboardType: TextInputType.number,
                      isObscured: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) => value == null || value.length < 3
                          ? 'Código inválido'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Cardholder Data
              _PaymentTextField(
                controller: _cpfController,
                label: 'CPF',
                hintText: '000.000.000-00',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) =>
                    value == null || value.length < 11 ? 'CPF inválido' : null,
              ),
              _PaymentTextField(
                controller: _phoneController,
                label: 'Celular',
                hintText: '(00) 00000-0000',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) => value == null || value.length < 11
                    ? 'Telefone inválido'
                    : null,
              ),
              _buildAddressSection(),
              const SizedBox(height: 16),
              // Save Card Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _saveCardChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _saveCardChecked = newValue!;
                      });
                    },
                  ),
                  const Text('Salvar Cartão', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              // Security Info
              const Text(
                'As suas informações de pagamento serão armazenadas no sistema com a mais alta tecnologia de criptografia disponível atualmente e facilitarão o processo de pagamento em suas próximas compras. Para garantir ainda mais a integridade dos seus dados, o código de segurança do cartão de crédito não será armazenado e deverá ser informado em sua próxima compra.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        // Pix/Boleto Info
        if (_selectedPaymentMethod == PaymentMethod.pixBoleto)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PaymentTextField(
                controller: _pagadorController,
                label: 'Pagador',
                hintText: 'Nome completo do pagador',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              _PaymentTextField(
                controller: _cpfController,
                label: 'CPF',
                hintText: '000.000.000-00',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) =>
                    value == null || value.length < 11 ? 'CPF inválido' : null,
              ),
              _PaymentTextField(
                controller: _phoneController,
                label: 'Celular',
                hintText: '(00) 00000-0000',
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) => value == null || value.length < 11
                    ? 'Telefone inválido'
                    : null,
              ),
              _buildAddressSection(),
            ],
          ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('PAGAR'),
      ),
    );
  }

  Widget _buildLegalDisclaimer() {
    return const Text(
      'Em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei 13.709, de 14 de agosto de 2018), entenda por que coletamos os seus dados.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressHeader(),
        if (!_isCepFilled)
          _PaymentTextField(
            controller: _cepController,
            label: 'CEP',
            hintText: '00000-000',
            keyboardType: TextInputType.number,
            inputFormatters: [CepInputFormatter()],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu CEP';
              }
              if (value.length != 9) {
                return 'O CEP deve ter 9 caracteres';
              }
              return null;
            },
          )
        else if (_showManualAddress)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PaymentTextField(
                controller: _cepController,
                inputFormatters: [CepInputFormatter()],
                hintText: '00000-000',
                label: 'CEP',
                mandatory: true,
                tooltipMessage: 'Informe o CEP do seu endereo.',
              ),
              const SizedBox(height: 20),
              _PaymentTextField(
                controller: _complementoController,
                label: 'Complemento',
                tooltipMessage:
                    'Informe o complemento do seu endereo, se houver.',
              ),
              const SizedBox(height: 20),
              _PaymentTextField(
                controller: _bairroController,
                label: 'Bairro',
                mandatory: true,
                tooltipMessage: 'Informe o bairro do seu endereo.',
              ),
              const SizedBox(height: 20),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe o estado do seu endereo.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Tooltip(
                      message: 'Informe o estado do seu endereo.',
                      child: Icon(
                        Icons.help_outline,
                        size: 14,
                        color: AppColors.text.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedState,
                    items: _states.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedState = newValue;
                        _selectedCity = null;
                        _cities = [];
                        if (newValue != null) {
                          _fetchCities(newValue);
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Informe a cidade do seu endereo.'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    child: Tooltip(
                      message: 'Informe a cidade do seu endereo.',
                      child: Icon(
                        Icons.help_outline,
                        size: 14,
                        color: AppColors.text.withAlpha((0.6 * 255).round()),
                      ),
                    ),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCity,
                    items: _cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCity = newValue;
                      });
                    },
                  ),
                ),
              ),
            ],
          )
        else
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'CEP ${_cepController.text} - ${_addressData!['logradouro']}${(_addressData!['numero'] as String?)?.isNotEmpty == true ? ', N° ${_addressData!['numero']}' : ''}${(_addressData!['complemento'] as String?)?.isNotEmpty == true ? ', ${_addressData!['complemento']}' : ''}, ${_addressData!['bairro']!}, ${_addressData!['localidade']!}/${_addressData!['uf']!}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showManualAddress = true;
                        _numeroController.text = _addressData!['numero'] ?? '';
                        _complementoController.text =
                            _addressData!['complemento'] ?? '';
                      });
                    },
                    child: const Text('Mudar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _PaymentTextField(
                controller: _numeroController,
                label: 'Número',
                mandatory: true,
                tooltipMessage: 'Informe o número do imóvel do seu endereo.',
              ),
              const SizedBox(height: 20),
              _PaymentTextField(
                controller: _complementoController,
                label: 'Complemento',
                tooltipMessage:
                    'Informe o complemento do seu endereo, se houver.',
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAddressHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Endereço',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const Divider(color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }
}

// --- REUSABLE WIDGETS ---

// Widget for structuring information sections with a title and an info icon
class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.help_outline, size: 16, color: Colors.blue),
          ],
        ),
        ...children,
      ],
    );
  }
}

// Custom TextField that includes a help icon next to the label (as seen in the screenshot)
class _PaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isObscured;
  final FormFieldValidator<String>? validator;
  final bool mandatory;
  final String? tooltipMessage;

  const _PaymentTextField({
    required this.controller,
    required this.label,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.isObscured = false,
    this.validator,
    this.mandatory = false,
    this.tooltipMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (mandatory)
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              if (tooltipMessage != null)
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tooltipMessage!),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  child: Tooltip(
                    message: tooltipMessage,
                    child: Icon(
                      Icons.help_outline,
                      size: 14,
                      color: AppColors.text.withAlpha((0.6 * 255).round()),
                    ),
                  ),
                )
              else
                const Icon(Icons.help_outline, size: 14, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: isObscured,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- INPUT FORMATTERS (Simulated) ---

// Formatter to add spaces to card number (4 digits each)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// Formatter for MM/YY expiry date
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    if (text.length >= 2) {
      return newValue.copyWith(
        text: '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(
          offset:
              newValue.selection.end +
              (newValue.text.length - oldValue.text.length),
        ),
      );
    }
    return newValue;
  }
}
