<?php

namespace App\Modules\Secretariat\Models;

use App\Modules\Lodges\Models\Lodge;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class Balaustre extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'lodge_id',
        'lodge_session_id',
        'degree',
        'type',
        'minutes_number',
        'approved',
    ];

    protected function casts(): array
    {
        return [
            'approved' => 'boolean',
        ];
    }

    public function lodge(): BelongsTo
    {
        return $this->belongsTo(Lodge::class);
    }

    public function lodgeSession(): BelongsTo
    {
        return $this->belongsTo(LodgeSession::class);
    }
}
