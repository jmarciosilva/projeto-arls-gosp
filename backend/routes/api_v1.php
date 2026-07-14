<?php

use App\Http\Controllers\Api\V1\LodgeOptionsController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/lodge-options', LodgeOptionsController::class)->name('lodge-options');

Route::middleware('auth:sanctum')->get('/me', function (Request $request) {
    return $request->user();
})->name('me');
