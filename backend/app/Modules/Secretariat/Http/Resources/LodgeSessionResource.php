<?php

namespace App\Modules\Secretariat\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Modules\Secretariat\Models\LodgeSession */
class LodgeSessionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'date' => $this->date?->toDateString(),
            'type' => $this->type,
            'degree' => $this->degree,
            'rite' => $this->rite,
            'summary' => $this->summary,
        ];
    }
}
