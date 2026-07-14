<?php

namespace App\Modules\Secretariat\Models;

use App\Modules\Lodges\Models\Lodge;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\SoftDeletes;

class LodgeSession extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'lodge_id',
        'date',
        'type',
        'degree',
        'rite',
        'tronco',
        'summary',
    ];

    protected function casts(): array
    {
        return [
            'date' => 'date',
            'tronco' => 'decimal:2',
        ];
    }

    public function lodge(): BelongsTo
    {
        return $this->belongsTo(Lodge::class);
    }

    public function balaustre(): HasOne
    {
        return $this->hasOne(Balaustre::class);
    }
}
