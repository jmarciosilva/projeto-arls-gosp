<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin \App\Modules\Secretariat\Models\Member */
class MemberResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'status' => $this->status,
            'name' => $this->name,
            'nickname' => $this->nickname,
            'cim' => $this->cim,
            'degree' => $this->degree,
            'position' => $this->position,
            'admission_date' => $this->admission_date?->toDateString(),
            'admission_type' => $this->admission_type,
        ];
    }
}
