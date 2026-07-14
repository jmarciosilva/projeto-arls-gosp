<?php

namespace App\Modules\Secretariat\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Modules\Secretariat\Http\Resources\LodgeSessionResource;
use App\Modules\Secretariat\Models\LodgeSession;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class LodgeSessionController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $sessions = LodgeSession::query()
            ->where('lodge_id', $request->user()->lodge_id)
            ->orderByDesc('date')
            ->paginate(20);

        return LodgeSessionResource::collection($sessions);
    }
}
