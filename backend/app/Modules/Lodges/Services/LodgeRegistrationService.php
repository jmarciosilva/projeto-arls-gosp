<?php

namespace App\Modules\Lodges\Services;

use App\Models\User;
use App\Modules\Lodges\Models\Lodge;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class LodgeRegistrationService
{
    /**
     * Cria a Loja, o registro de Membro do administrador e a conta de
     * usuário vinculada, em uma única transação.
     */
    public function register(array $data): Lodge
    {
        return DB::transaction(function () use ($data): Lodge {
            $lodge = Lodge::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'number' => $data['number'],
                'rite' => $data['rite'],
                'cep' => $data['cep'],
                'address_street' => $data['address_street'],
                'address_number' => $data['address_number'],
                'address_complement' => $data['address_complement'] ?? null,
                'address_neighborhood' => $data['address_neighborhood'],
                'city' => $data['city'],
                'state' => $data['state'],
            ]);

            $member = $lodge->members()->create([
                'status' => 'ativo',
                'name' => $data['admin_name'],
                'nickname' => $data['admin_nickname'] ?? null,
                'email' => $data['admin_email'],
                'mobile_phone' => $data['admin_whatsapp'],
                'cpf' => $data['admin_cpf'],
                'cim' => $data['admin_cim'],
                'degree' => $data['admin_degree'],
            ]);

            User::create([
                'lodge_id' => $lodge->id,
                'member_id' => $member->id,
                'name' => $data['admin_name'],
                'email' => $data['admin_email'],
                'whatsapp' => $data['admin_whatsapp'],
                'role' => 'lodge_admin',
                'password' => Hash::make($data['admin_password']),
            ]);

            return $lodge;
        });
    }
}
