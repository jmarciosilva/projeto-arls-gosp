<?php

namespace App\Modules\Lodges\Models;

use App\Modules\Secretariat\Models\Balaustre;
use App\Modules\Secretariat\Models\LodgeSession;
use App\Modules\Secretariat\Models\Member;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Lodge extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'email',
        'number',
        'rite',
        'cep',
        'address_street',
        'address_number',
        'address_complement',
        'address_neighborhood',
        'city',
        'state',
    ];

    public function users(): HasMany
    {
        return $this->hasMany(User::class);
    }

    public function members(): HasMany
    {
        return $this->hasMany(Member::class);
    }

    public function lodgeSessions(): HasMany
    {
        return $this->hasMany(LodgeSession::class);
    }

    public function balaustres(): HasMany
    {
        return $this->hasMany(Balaustre::class);
    }
}
