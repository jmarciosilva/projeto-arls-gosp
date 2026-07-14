<?php

namespace App\Modules\Secretariat\Models;

use App\Modules\Lodges\Models\Lodge;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;

class Member extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'lodge_id',
        'status',
        'name',
        'birth_date',
        'natural_of',
        'marital_status',
        'email',
        'home_phone',
        'mobile_phone',
        'cpf',
        'rg',
        'blood_type',
        'occupation',
        'workplace',
        'work_phone',
        'address_state',
        'address_city',
        'address_street',
        'address_number',
        'address_complement',
        'address_neighborhood',
        'cep',
        'cim',
        'degree',
        'position',
        'admission_date',
        'admission_type',
        'observation',
    ];

    protected function casts(): array
    {
        return [
            'birth_date' => 'date',
            'admission_date' => 'date',
        ];
    }

    public function lodge(): BelongsTo
    {
        return $this->belongsTo(Lodge::class);
    }

    public function user(): HasOne
    {
        return $this->hasOne(User::class);
    }
}
