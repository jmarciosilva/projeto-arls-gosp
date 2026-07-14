<?php

namespace App\Modules\Lodges\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\LodgeResource;
use App\Modules\Lodges\Http\Requests\StoreLodgeRequest;
use App\Modules\Lodges\Models\Lodge;
use App\Modules\Lodges\Services\LodgeRegistrationService;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class LodgeController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        $lodges = Lodge::query()->orderBy('name')->paginate(20);

        return LodgeResource::collection($lodges);
    }

    public function store(StoreLodgeRequest $request, LodgeRegistrationService $service): LodgeResource
    {
        $lodge = $service->register($request->validated());

        return new LodgeResource($lodge);
    }
}
