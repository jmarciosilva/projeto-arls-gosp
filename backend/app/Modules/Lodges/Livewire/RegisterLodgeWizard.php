<?php

namespace App\Modules\Lodges\Livewire;

use App\Modules\Lodges\Services\LodgeRegistrationService;
use Illuminate\Support\Facades\Http;
use Livewire\Attributes\Layout;
use Livewire\Component;

#[Layout('admin.layouts.app')]
class RegisterLodgeWizard extends Component
{
    public int $step = 1;

    // Passo 1 — Loja
    public string $name = '';
    public string $email = '';
    public string $number = '';
    public string $rite = '';

    // Passo 2 — Endereço
    public string $cep = '';
    public string $address_street = '';
    public string $address_number = '';
    public string $address_complement = '';
    public string $address_neighborhood = '';
    public string $city = '';
    public string $state = '';

    // Passo 2 — Administrador da Loja
    public string $admin_name = '';
    public string $admin_nickname = '';
    public string $admin_cim = '';
    public string $admin_cpf = '';
    public string $admin_degree = '';
    public string $admin_email = '';
    public string $admin_whatsapp = '';
    public string $admin_password = '';
    public string $admin_password_confirmation = '';

    public ?string $cepLookupError = null;

    protected function rulesForStep1(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:lodges,email'],
            'number' => ['required', 'string', 'max:50'],
            'rite' => ['required', 'in:'.implode(',', config('lodge.rites'))],
        ];
    }

    protected function rulesForStep2(): array
    {
        return [
            'cep' => ['required', 'regex:/^\d{5}-\d{3}$/'],
            'address_street' => ['required', 'string', 'max:255'],
            'address_number' => ['required', 'string', 'max:20'],
            'address_complement' => ['nullable', 'string', 'max:255'],
            'address_neighborhood' => ['required', 'string', 'max:255'],
            'city' => ['required', 'string', 'max:255'],
            'state' => ['required', 'string', 'in:'.implode(',', config('lodge.states'))],

            'admin_name' => ['required', 'string', 'max:255'],
            'admin_nickname' => ['nullable', 'string', 'max:255'],
            'admin_cim' => ['nullable', 'digits_between:1,8'],
            'admin_cpf' => ['required', 'digits:11', 'unique:members,cpf'],
            'admin_degree' => ['required', 'in:'.implode(',', config('lodge.degrees'))],
            'admin_email' => ['required', 'email', 'max:255', 'unique:users,email'],
            'admin_whatsapp' => ['required', 'digits_between:10,11'],
            'admin_password' => ['required', 'string', 'min:8', 'confirmed'],
        ];
    }

    public function updatedAdminCpf(string $value): void
    {
        $digits = preg_replace('/\D/', '', $value);

        $this->admin_cpf = strlen($digits) === 11
            ? preg_replace('/(\d{3})(\d{3})(\d{3})(\d{2})/', '$1.$2.$3-$4', $digits)
            : $digits;
    }

    public function updatedAdminWhatsapp(string $value): void
    {
        $digits = preg_replace('/\D/', '', $value);

        $this->admin_whatsapp = match (strlen($digits)) {
            11 => preg_replace('/(\d{2})(\d{5})(\d{4})/', '($1) $2-$3', $digits),
            10 => preg_replace('/(\d{2})(\d{4})(\d{4})/', '($1) $2-$3', $digits),
            default => $digits,
        };
    }

    public function updatedCep(string $value): void
    {
        $this->cepLookupError = null;
        $digits = preg_replace('/\D/', '', $value);

        if (strlen($digits) !== 8) {
            $this->cep = $digits;

            return;
        }

        $this->cep = substr($digits, 0, 5).'-'.substr($digits, 5);

        $response = Http::get("https://viacep.com.br/ws/{$digits}/json/");

        if (! $response->ok() || $response->json('erro')) {
            $this->cepLookupError = 'CEP não encontrado.';

            return;
        }

        $this->address_street = $response->json('logradouro') ?? '';
        $this->address_neighborhood = $response->json('bairro') ?? '';
        $this->city = $response->json('localidade') ?? '';
        $this->state = $response->json('uf') ?? '';
    }

    public function nextStep(): void
    {
        $this->validate($this->rulesForStep1());

        $this->step = 2;
    }

    public function previousStep(): void
    {
        $this->step = 1;
    }

    public function register(LodgeRegistrationService $service): void
    {
        // CPF e WhatsApp são armazenados só com dígitos; a máscara é só de exibição.
        $this->admin_cpf = preg_replace('/\D/', '', $this->admin_cpf);
        $this->admin_whatsapp = preg_replace('/\D/', '', $this->admin_whatsapp);

        $this->validate([...$this->rulesForStep1(), ...$this->rulesForStep2()]);

        $lodge = $service->register([
            'name' => $this->name,
            'email' => $this->email,
            'number' => $this->number,
            'rite' => $this->rite,
            'cep' => $this->cep,
            'address_street' => $this->address_street,
            'address_number' => $this->address_number,
            'address_complement' => $this->address_complement,
            'address_neighborhood' => $this->address_neighborhood,
            'city' => $this->city,
            'state' => $this->state,
            'admin_name' => $this->admin_name,
            'admin_nickname' => $this->admin_nickname,
            'admin_cim' => $this->admin_cim,
            'admin_cpf' => $this->admin_cpf,
            'admin_degree' => $this->admin_degree,
            'admin_email' => $this->admin_email,
            'admin_whatsapp' => $this->admin_whatsapp,
            'admin_password' => $this->admin_password,
        ]);

        session()->flash('success', "Loja \"{$lodge->name}\" cadastrada com sucesso.");

        $this->redirectRoute('admin.lodges.index', navigate: true);
    }

    public function render()
    {
        return view('livewire.lodges.register-lodge-wizard', [
            'rites' => config('lodge.rites'),
            'degrees' => config('lodge.degrees'),
            'states' => config('lodge.states'),
        ]);
    }
}
