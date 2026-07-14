<?php

namespace App\Modules\Lodges\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreLodgeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'max:255', 'unique:lodges,email'],
            'number' => ['required', 'string', 'max:50'],
            'rite' => ['required', 'in:'.implode(',', config('lodge.rites'))],

            'cep' => ['required', 'regex:/^\d{5}-?\d{3}$/'],
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
            'admin_password' => ['required', 'string', 'min:8'],
        ];
    }

    /**
     * CPF, WhatsApp e CEP chegam do mobile já só com dígitos (mais o hífen
     * do CEP, opcional) — normaliza antes de validar/persistir.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'admin_cpf' => preg_replace('/\D/', '', (string) $this->admin_cpf),
            'admin_whatsapp' => preg_replace('/\D/', '', (string) $this->admin_whatsapp),
            'cep' => $this->cep ? $this->normalizeCep($this->cep) : $this->cep,
        ]);
    }

    private function normalizeCep(string $cep): string
    {
        $digits = preg_replace('/\D/', '', $cep);

        return strlen($digits) === 8
            ? substr($digits, 0, 5).'-'.substr($digits, 5)
            : $cep;
    }
}
